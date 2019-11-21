//
//  UIView+HUD.h
//  ZWMFrameWork
//
//  Created by ZhouWeiMing on 14/8/15.
//  Copyright (c) 2014年 zhishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

@end
