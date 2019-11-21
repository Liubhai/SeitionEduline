//
//  ZFDownloadManager.h
//  dafengche
//
//  Created by IOS on 16/9/23.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFCommonHelper.h"
#import "ZFDownloadDelegate.h"
#import "ZFFileModel.h"
#import "ZFHttpRequest.h"

#define kMaxRequestCount  @"kMaxRequestCount"

@interface ZFDownloadManager : NSObject<ZFHttpRequestDelegate>

/** 获得下载事件的vc，用在比如多选图片后批量下载的情况，这时需配合 allowNextRequest 协议方法使用 */
@property (nonatomic, weak) id<ZFDownloadDelegate> VCdelegate;
/** 下载列表delegate */
@property (nonatomic, weak) id<ZFDownloadDelegate> downloadDelegate;
/** 设置最大的并发下载个数 */
@property (nonatomic, assign) NSInteger              maxCount;
/** 已下载完成的文件列表（文件对象） */
@property (atomic, strong, readonly) NSMutableArray *finishedlist;
/** 正在下载的文件列表(ASIHttpRequest对象) */
@property (atomic, strong, readonly) NSMutableArray *downinglist;
/** 未下载完成的临时文件数组（文件对象) */
@property (atomic, strong, readonly) NSMutableArray *filelist;
/** 下载文件的模型 */
@property (nonatomic, strong, readonly) ZFFileModel      *fileInfo;

/** 单例 */

+ (ZFDownloadManager *)sharedDownloadManager;
/** 清除所有正在下载的请求 */
- (void)clearAllRquests;
/** 清除所有下载完的文件 */
- (void)clearAllFinished;
/** 恢复下载 */
- (void)resumeRequest:(ZFHttpRequest *)request;
/** 删除这个下载请求 */
- (void)deleteRequest:(ZFHttpRequest *)request;
/** 停止这个下载请求 */
- (void)stopRequest:(ZFHttpRequest *)request;
/** 保存下载完成的文件信息到plist */
- (void)saveFinishedFile;
/** 删除某一个下载完成的文件 */
- (void)deleteFinishFile:(ZFFileModel *)selectFile;
/** 下载视频时候调用 */
- (void)downFileUrl:(NSString*)url
           filename:(NSString*)name
          fileimage:(UIImage *)image;



/** Eduline 自定义方法 下载阿里云 */
- (void)downFileUrl:(NSString*)url
           filename:(NSString*)name
          fileimage:(UIImage *)image withType:(NSString *)type;

/** 开始任务 */
- (void)startLoad;
/** 重新开始任务 */
- (void)restartAllRquests;

@end
