


//
//  GLNetWorking.m
//  dafengche
//
//  Created by IOS on 16/9/28.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLNetWorking.h"
#import "Reachability.h"

@interface GLNetWorking ()<UIAlertViewDelegate>

@end

@implementation GLNetWorking
+(NSString *) isConnectionAvailable{
    NSString *NET;
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reach currentReachabilityStatus]) {
            
        case NotReachable:{
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            NET = @"notReachable";
        }
            break;
        case ReachableViaWiFi:{
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            NET = @"wifi";
        }
            break;
        case ReachableViaWWAN:
        {
            isExistenceNetwork = YES;
            NET = @"3G";
            NSLog(@"3G");
        }
            break;
    }
    return NET;
}

@end
