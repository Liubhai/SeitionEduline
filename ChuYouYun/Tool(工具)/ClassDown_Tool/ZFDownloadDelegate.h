//
//  ZFDownloadDelegate.h
//  dafengche
//
//  Created by IOS on 16/9/23.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFHttpRequest.h"

@protocol ZFDownloadDelegate <NSObject>

@optional

- (void)startDownload:(ZFHttpRequest *)request;
- (void)updateCellProgress:(ZFHttpRequest *)request;
- (void)finishedDownload:(ZFHttpRequest *)request;
- (void)allowNextRequest;//处理一个窗口内连续下载多个文件且重复下载的情况

@end
