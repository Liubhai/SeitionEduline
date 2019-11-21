//
//  ZBLM3U8Setting.m
//  M3U8DownLoadTest
//
//  Created by zengbailiang on 10/6/17.
//  Copyright © 2017 controling. All rights reserved.
//

#import "ZBLM3u8Setting.h"
#import "NSString+m3u8.h"
#import "SYG.h"
@implementation ZBLM3u8Setting
#pragma mark - download Controller parameter
+ (NSInteger)maxConcurrentMovieDownloadCount
{
    return 2;
}
+ (NSInteger)maxTsFileDownloadCount
{
    return 20;
}

#pragma mark - service
+ (NSString *)localHost
{
    return @"http://127.0.0.1:8080";
}
+ (NSString *)port
{
    return @"8080";
}

#pragma mark - dir/fileName
+ (NSString *)commonDirPrefix
{
//    if (UserID) {
//        NSString *mu38 = [NSString stringWithFormat:@"m3u8files_%@",UserID];
//        return  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:mu38];;
//    }
    return  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"m3u8files"];
}
+(NSString *)videoInfoName{
    return @"videoInfo.data";
}
+ (NSString *)m3u8InfoFileName
{
    return @"movie.m3u8";
}

+ (NSString *)oriM3u8InfoFileName
{
    return @"oriMovie.m3u8";
}

+ (NSString *)keyFileName
{
    return @"key";
}
+(NSString *)notm3u8type{
    return @".mp3";
}
+(BOOL)judgeIsm3u8Video:(NSString *)url{
    if ([url rangeOfString:@".m3u8"].location == NSNotFound) {
        return NO;
    }
   
    return YES;
}
+(BOOL)judgeIsLocalVideoPath:(NSString *)url{
    if ([url rangeOfString:[self commonDirPrefix]].location == NSNotFound){
        return NO;
    }
    return YES;
}
+ (NSString *)uuidWithUrl:(NSString *)Url
{
    Url = [[Url componentsSeparatedByString:@"?"] firstObject];
    return [Url md5];
}
+ (NSString *)fullCommonDirPrefixWithUrl:(NSString *)url
{
    return [[self commonDirPrefix] stringByAppendingPathComponent:[self uuidWithUrl:url]];
}
+ (NSString *)tsFileWithIdentify:(NSString *)identify;
{
    if ([identify rangeOfString:@"."].location == NSNotFound) {
        return [NSString stringWithFormat:@"%@.ts",identify];
    }
    return identify;
}
@end
