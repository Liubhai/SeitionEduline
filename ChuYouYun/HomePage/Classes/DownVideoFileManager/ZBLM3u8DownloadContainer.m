//
//  ZBLM3u8DownloadContainer.m
//  M3U8DownLoadTest
//
//  Created by zengbailiang on 10/4/17.
//  Copyright © 2017 controling. All rights reserved.
//

#import "ZBLM3u8DownloadContainer.h"
#import "ZBLM3u8Analysiser.h"
#import "ZBLM3u8Downloader.h"
#import "ZBLM3u8Info.h"
#import "ZBLM3u8FileDownloadInfo.h"
#import "ZBLM3u8FileManager.h"
#import "ZBLM3u8Setting.h"


NSString * const ZBLM3u8DownloadContainerGreateRootDirErrorDomain = @"error.m3u8.container.createRootDir";

/*发起解析，发起下载，中断恢复控制...*/
@interface ZBLM3u8DownloadContainer()
@property (nonatomic, strong) ZBLM3u8Info *m3u8Info;
@property (nonatomic, strong) ZBLM3u8Downloader *downloader;
@property (nonatomic, copy) NSString *m3u8OriUrl;
@property (nonatomic, assign) NSInteger maxConcurrenceDownloadTaskCount;
@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, copy) ZBLM3u8DownloadCompletaionHandler completaionHandler;
@property (nonatomic, assign,getter=isSuspend) BOOL suspend;
@property (nonatomic, assign) BOOL isExitRootDir;
@property (nonatomic, strong) ZBLM3u8DownloadProgressHandler downloadProgressHandler;
@end

@implementation ZBLM3u8DownloadContainer
- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = dispatch_semaphore_create(1);
        _suspend = NO;
        _maxConcurrenceDownloadTaskCount = 3;
    }
    return self;
}

- (void)dealloc
{

}

/*
 加锁说明：
 1.startDownloadWithUrlString 执行过程中可能会接受suspendDownload或者resumeDownload，故其需要保持原子性。startDownloadWithUrlString - 》 suspendDownload-》stop
 2.resumeDownload  stop->start
 3.suspendDownload startDownloadWithUrlString -> stop
 以上个方法需要互斥
 */

/*
 1.外部发起
 2.resume方法发起
 */
- (void)startDownloadWithUrlString:(NSString *)urlStr  downloadProgressHandler:(ZBLM3u8DownloadProgressHandler)downloadProgressHandler completaionHandler:(ZBLM3u8DownloadCompletaionHandler)completaionHandler
{
    [self _lock];
    if (_suspend) {
        [self _unlock];
        return;
    }
    if (!_m3u8OriUrl) {
        _m3u8OriUrl = urlStr;
    }
    if (!_completaionHandler) {
        _completaionHandler = completaionHandler;
    }
    if (!_downloadProgressHandler) {
        _downloadProgressHandler = downloadProgressHandler;
    }
    if(![self tryCreateRootDir])
    {
        _completaionHandler(nil,[[NSError alloc]initWithDomain:ZBLM3u8DownloadContainerGreateRootDirErrorDomain code:NSURLErrorCannotCreateFile userInfo:nil],urlStr);
        [self _unlock];
        return;
    }
    [ZBLM3u8Analysiser analysisWithUrlString:urlStr completaionHandler:^(ZBLM3u8Info *m3u8Info, NSError *error) {
        if (!error) {
            self.m3u8Info = m3u8Info;
            if (self.analysisM3u8InfoSuccessBlock) {
               self.maxConcurrenceDownloadTaskCount = self.analysisM3u8InfoSuccessBlock();
            }
            [self downloadAction];
        }
        else
        {
            _completaionHandler(nil,error,urlStr);
            NSLog(@"error:%@",error.description);
        }
    }];
    [self _unlock];
}

//通过suspend变量 控制执行的步骤
- (void)resumeDownload
{
    [self _lock];
    _suspend = NO;
    //任何步骤都没有开启，等待上层发起
    if (!_m3u8OriUrl) {
        [self _unlock];
        return;
    }

    //解析失败，重新开始
    if (_m3u8OriUrl && !_m3u8Info) {
        [self _unlock];
        ///该方法里面自带锁
        [self startDownloadWithUrlString:_m3u8OriUrl downloadProgressHandler:_downloadProgressHandler completaionHandler:_completaionHandler];
        return;
    }
    //解析成功但下载被中断了， 发起下载
    if (!_downloader) {
        [self downloadAction];
    }
    else
    {
        //否则告诉下载器恢复下载
        [_downloader resumeDownload];
    }
    [self _unlock];
}

- (void)suspendDownload
{
    //设置变量，中断流程
    [self _lock];
    _suspend = YES;
    //告诉下层中断下载
    [_downloader suspendDownload];
    [self _unlock];
}

#pragma mark - create downloader
/*外部已经加锁，故内部不需要额外加锁，否则导致死锁*/
- (void)downloadAction
{
    if (!_downloader) {
        __weak __typeof(self) weakself = self;
        _downloader = [[ZBLM3u8Downloader alloc]initWithfileDownloadInfos:[self fileDownloadInfos] maxConcurrenceDownloadTaskCount:_maxConcurrenceDownloadTaskCount completaionHandler:^(NSError *error) {
            if (!error) {
                [weakself saveM3u8File];
            }
            else
            {
                weakself.completaionHandler(nil,error,nil);
            }
        } downloadQueue:nil];
        if (_downloadProgressHandler) {
            [_downloader setDownloadProgressHandler:^(float progress,NSString *oriUrl){
                if (weakself.downloadProgressHandler) {
                    weakself.downloadProgressHandler(progress,oriUrl);
                }
            }];
        }
        _downloader.isM3u8Type = [ZBLM3u8Setting judgeIsm3u8Video:self.m3u8OriUrl];
        [_downloader startDownload];
    }
}

#pragma mark - info & file
- (BOOL)tryCreateRootDir
{
    return  [ZBLM3u8FileManager tryGreateDir:[[ZBLM3u8Setting commonDirPrefix]  stringByAppendingPathComponent:[ZBLM3u8Setting uuidWithUrl:_m3u8OriUrl]]];
}

- (NSMutableArray <ZBLM3u8FileDownloadInfo*> *)fileDownloadInfos
{
    NSMutableArray <ZBLM3u8FileDownloadInfo*> *fileDownloadInfos = [NSMutableArray arrayWithCapacity:0];
    if (_m3u8Info.keyUri.length > 0) {
        ZBLM3u8FileDownloadInfo *downloadKeyInfo = [ZBLM3u8FileDownloadInfo new];
        downloadKeyInfo.downloadUrl = _m3u8Info.keyUri;
        downloadKeyInfo.filePath = [[ZBLM3u8Setting fullCommonDirPrefixWithUrl:_m3u8OriUrl]stringByAppendingPathComponent:[ZBLM3u8Setting keyFileName]];
        downloadKeyInfo.m3u8FullRootUrlString = _m3u8Info.tsInfos.firstObject.m3u8FullRootUrlString;
        [fileDownloadInfos addObject:downloadKeyInfo];
    }
    
    for (ZBLM3u8TsInfo *tsInfo in _m3u8Info.tsInfos) {
         ZBLM3u8FileDownloadInfo *downloadInfo = [ZBLM3u8FileDownloadInfo new];
        downloadInfo.downloadUrl = tsInfo.oriUrlString;
        if ([_m3u8Info.keyMethod isEqualToString:[ZBLM3u8Setting notm3u8type]]) {
            downloadInfo.filePath = tsInfo.localUrlString;

        }else{
            downloadInfo.filePath = [[ZBLM3u8Setting fullCommonDirPrefixWithUrl:_m3u8OriUrl]stringByAppendingPathComponent:[ZBLM3u8Setting tsFileWithIdentify:@(tsInfo.index).stringValue]];

        }
        downloadInfo.m3u8FullRootUrlString = tsInfo.m3u8FullRootUrlString;
        [fileDownloadInfos addObject:downloadInfo];
        if (tsInfo.localUrlString == nil) {
            NSLog(@"");
        }
    }
    
    return fileDownloadInfos;
}

- (void)saveM3u8File
{
    __weak __typeof(self) weakself = self;
    NSString *m3u8info = [ZBLM3u8Analysiser synthesisLocalM3u8Withm3u8Info:self.m3u8Info];
    NSString *localPath;
    localPath = [[ZBLM3u8Setting fullCommonDirPrefixWithUrl:_m3u8OriUrl] stringByAppendingPathComponent:[ZBLM3u8Setting m3u8InfoFileName]];
    [[ZBLM3u8FileManager shareInstance] saveDate:[m3u8info dataUsingEncoding:NSUTF8StringEncoding] ToFile:[[ZBLM3u8Setting fullCommonDirPrefixWithUrl:_m3u8OriUrl] stringByAppendingPathComponent:[ZBLM3u8Setting m3u8InfoFileName]] completaionHandler:^(NSError *error) {
        if (!error) {
            if ([self.m3u8Info.keyMethod isEqualToString:[ZBLM3u8Setting notm3u8type]]) {
                weakself.completaionHandler([self.m3u8Info.tsInfos firstObject].localUrlString,nil,_m3u8OriUrl);
            }
            else{
                weakself.completaionHandler([NSString stringWithFormat:@"%@/%@/%@",[ZBLM3u8Setting localHost],[ZBLM3u8Setting uuidWithUrl:_m3u8OriUrl],[ZBLM3u8Setting m3u8InfoFileName]],nil,_m3u8OriUrl);
            }
        }
        else
        {
            weakself.completaionHandler(nil,error,_m3u8OriUrl);
        }
        
    }];
}

#pragma mark -
- (void)_lock
{
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
}

- (void)_unlock
{
    dispatch_semaphore_signal(_lock);
}

@end
