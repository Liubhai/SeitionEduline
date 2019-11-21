//
//  RCGlobalConfig.h
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKProgressHUD.h"

@interface TKRCGlobalConfig : NSObject

// Global UI
+ (TKProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view;
// Global UI
+ (TKProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view showTime:(CGFloat)time;

@end
