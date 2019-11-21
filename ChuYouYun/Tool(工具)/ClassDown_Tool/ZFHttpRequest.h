//
//  ZFHttpRequest.h
//  dafengche
//
//  Created by IOS on 16/9/23.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"

@class ZFHttpRequest;

@protocol ZFHttpRequestDelegate <NSObject>

- (void)requestFailed:(ZFHttpRequest *)request;
- (void)requestStarted:(ZFHttpRequest *)request;
- (void)request:(ZFHttpRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)request:(ZFHttpRequest *)request didReceiveBytes:(long long)bytes;
- (void)requestFinished:(ZFHttpRequest *)request;
@optional
- (void)request:(ZFHttpRequest *)request willRedirectToURL:(NSURL *)newURL;

@end

@interface ZFHttpRequest : NSObject


@property (weak, nonatomic  ) id<ZFHttpRequestDelegate> delegate;
@property (strong, nonatomic) NSURL                  *url;
@property (strong, nonatomic) NSURL                  *originalURL;
@property (strong, nonatomic) NSDictionary           *userInfo;
@property (assign, nonatomic) NSInteger              tag;
@property (strong, nonatomic) NSString               *downloadDestinationPath;
@property (strong, nonatomic) NSString               *temporaryFileDownloadPath;
@property (strong,readonly,nonatomic) NSError *error;

- (instancetype)initWithURL:(NSURL*)url;
- (void)startAsynchronous;
- (BOOL)isFinished;
- (BOOL)isExecuting;
- (void)cancel;


@end
