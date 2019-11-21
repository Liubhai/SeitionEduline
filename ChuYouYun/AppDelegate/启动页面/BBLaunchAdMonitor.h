//
//  BBLaunchAdMonitor.h
//  Search
//
//  Created by iXcoder on 15/4/22.
//  Copyright (c) 2015年 iXcoder. All rights reserved.
//

#import <Foundation/Foundation.h>
//@import UIKit.UIView;
#import <UIKit/UIKit.h>


extern NSString *BBLaunchAdDetailDisplayNotification;
extern NSString *BBLaunchAdDetailImageUrlNotification;

@interface BBLaunchAdMonitor : NSObject

+ (void)showAdAtPath:(NSString *)path onView:(UIView *)container timeInterval:(NSTimeInterval)interval detailParameters:(NSDictionary *)param;

@end
