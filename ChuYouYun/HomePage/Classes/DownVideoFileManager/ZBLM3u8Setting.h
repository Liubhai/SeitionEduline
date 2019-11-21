//
//  ZBLM3U8Setting.h
//  M3U8DownLoadTest
//
//  Created by zengbailiang on 10/6/17.
//  Copyright © 2017 controling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBLM3u8Setting : NSObject

#pragma mark - download Controller parameter
+ (NSInteger)maxConcurrentMovieDownloadCount;
+ (NSInteger)maxTsFileDownloadCount;

#pragma mark - service
+ (NSString *)localHost;
+ (NSString *)port;

#pragma mark - dir/fileName
+ (NSString *)commonDirPrefix;
+ (NSString *)m3u8InfoFileName;
+ (NSString *)videoInfoName;
+ (NSString *)oriM3u8InfoFileName;
+ (NSString *)keyFileName;
+ (NSString *)notm3u8type;
+ (BOOL)judgeIsm3u8Video:(NSString *)url;
+ (BOOL)judgeIsLocalVideoPath:(NSString *)url;
+ (NSString *)uuidWithUrl:(NSString *)Url;
+ (NSString *)fullCommonDirPrefixWithUrl:(NSString *)url;
+ (NSString *)tsFileWithIdentify:(NSString *)identify;

@end
