//
//  RCGlobalConfig.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "TKPromptMessage.h"

@implementation TKPromptMessage

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global UI

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TKProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view
{
    return [TKPromptMessage HUDShowMessage:msg addedToView:view showTime:1.0f];
}
+ (TKProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view showTime:(CGFloat)time
{
   static TKProgressHUD* hud = nil;
    if(hud != nil && hud.superview != view)
    {
        UIView* theSuper = hud.superview;
        hud = nil;
        [TKProgressHUD hideAllHUDsForView:theSuper animated:NO];
    }
    if (!hud) {
        hud = [TKProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.mode = TKProgressHUDModeText;
    hud.labelText = msg;
    hud.hidden = NO;
    hud.alpha = 1.0f;
    [hud hide:YES afterDelay:time];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeRight:
            hud.transform = CGAffineTransformMakeRotation(-M_PI * 2);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            hud.transform = CGAffineTransformMakeRotation(-M_PI * 2);
            break;
        case UIInterfaceOrientationPortrait:
            hud.transform = CGAffineTransformIdentity;
            break;
        default:
            break;
    }
    return hud;
}
@end
