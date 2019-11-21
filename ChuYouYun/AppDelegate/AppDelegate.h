//
//  AppDelegate.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "rootViewController.h"

#import "WXApi.h"



@class HTTPServer;


@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    UIWindow * window;
    HTTPServer *httpServer;
    BOOL _reGetSWRespone;//正在重新获得socket的回调,如果ping发现bool为yes代表需要去查看重发队列进行消息重发
    long _ftime;

    
}

@property (assign, nonatomic) BOOL shouldNeedLandscape;//是否需要横屏

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL _allowRotation;
@property (nonatomic, strong) rootViewController * tabbar;


//@property (strong, nonatomic) VodPlayer *vodplayer;


+(AppDelegate *)delegate;

- (rootViewController *)rootVC;

- (void)netInitApp;

@end

