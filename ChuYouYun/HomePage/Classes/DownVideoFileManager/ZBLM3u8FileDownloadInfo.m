//
//  ZBLM3u8FileDownloadInfo.m
//  M3U8DownLoadTest
//
//  Created by zengbailiang on 10/5/17.
//  Copyright © 2017 controling. All rights reserved.
//

#import "ZBLM3u8FileDownloadInfo.h"

@implementation ZBLM3u8FileDownloadInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        _success = NO;
        _failed = NO;
    }
    return self;
}
-(void)setDownloadUrl:(NSString *)downloadUrl{
    _downloadUrl = downloadUrl;
}
-(void)setM3u8FullRootUrlString:(NSString *)m3u8FullRootUrlString{
    
    m3u8FullRootUrlString = [[m3u8FullRootUrlString componentsSeparatedByString:@"?"] firstObject];
    _m3u8FullRootUrlString = m3u8FullRootUrlString;
}
@end
