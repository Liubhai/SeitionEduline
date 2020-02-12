//
//  ZBLM3u8Manager.h
//  M3U8DownLoadTest
//
//  Created by zengbailiang on 10/4/17.
//  Copyright © 2017 controling. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ZBLM3u8ManagerDownloadSuccessBlock)(NSString *localPlayUrlString,NSString *oriUrl);
typedef void (^ZBLM3u8ManagerDownloadProgressHandler)(float progress,NSString *oriUrl);
@interface ZBLM3u8Manager : NSObject
+ (instancetype)shareInstance;

- (BOOL)exitLocalVideoWithUrlString:(NSString*) urlStr;

- (NSString *)localPlayUrlWithOriUrlString:(NSString *)urlString;

- (NSURL *)localPlayUrlWithOriUrlUrl:(NSString *)urlString;

- (void)removeDownLoadFileUrlPath:(NSString *)urlStr;

/**
 根据url 获取下载根路径

 @param urlString <#urlString description#>
 @return <#return value description#>
 */
- (NSString *)getDownRootPathUrl:(NSString *)urlString;
- (void)downloadVideoWithUrlString:(NSString *)urlStr downloadProgressHandler:(ZBLM3u8ManagerDownloadProgressHandler)downloadProgressHandler downloadSuccessBlock:(ZBLM3u8ManagerDownloadSuccessBlock) downloadSuccessBlock;

- (void)tryStartLocalService;

- (void)tryStopLocalService;

- (void)resumeDownload;
- (void)suspendDownload;
@end
