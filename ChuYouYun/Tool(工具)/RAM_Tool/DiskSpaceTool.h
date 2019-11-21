//
//  DiskSpaceTool.h
//  dafengche
//
//  Created by IOS on 16/11/1.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sys/param.h>
#include <sys/mount.h>


@interface DiskSpaceTool : NSObject

+ (NSString *) freeDiskSpaceInBytes;//手机剩余空间
+ (NSString *) totalDiskSpaceInBytes;//手机总空间
+ (NSString *) folderSizeAtPath:(NSString *) folderPath;//某个文件夹占用空间的大小

@end
