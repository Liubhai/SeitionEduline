//
//  ZBLM3u8Info.m
//  M3U8DownLoadTest
//
//  Created by zengbailiang on 10/5/17.
//  Copyright © 2017 controling. All rights reserved.
//

#import "ZBLM3u8Info.h"

@implementation ZBLM3u8Info

@end

@implementation ZBLM3u8TsInfo

-(void)setM3u8FullRootUrlString:(NSString *)m3u8FullRootUrlString{
    
    m3u8FullRootUrlString = [[m3u8FullRootUrlString componentsSeparatedByString:@"?"] firstObject];
    _m3u8FullRootUrlString = m3u8FullRootUrlString;
}
@end
