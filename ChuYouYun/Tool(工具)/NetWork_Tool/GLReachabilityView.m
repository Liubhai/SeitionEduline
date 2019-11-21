//
//  GLReachabilityView.m
//  ChuYouYun
//
//  Created by IOS on 16/5/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLReachabilityView.h"

#import "Reachability.h"

#import "UIColor+HTMLColors.h"

@implementation GLReachabilityView



+(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"当前网络不可用，请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //[alert show];
        
        return NO;
    }
    
    return isExistenceNetwork;
}

+(UIView *)popview{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 30)];
    UIColor *color = [UIColor colorWithHexString:@"#d8eafc"];
   // color = [color colorWithAlphaComponent:0.05];
    view.backgroundColor = color;
    UILabel *alab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 30)];
    [view addSubview:alab];
    alab.text = @"当前网络不可用，请检查网络设置";
    alab.textColor = [UIColor colorWithHexString:@"#666666"];
    alab.font = [UIFont systemFontOfSize:12];
    alab.textAlignment = NSTextAlignmentCenter;
    
    return view;
    
    
}

@end
