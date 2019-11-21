//
//  TKProgressHUD+Add.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/8/22.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "TKProgressHUD+Add.h"

@implementation TKProgressHUD (Add)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    TKProgressHUD *hud = [TKProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片 TKProgressHUD.bundle/
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    // 再设置模式
    hud.mode = TKProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.2];
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    //    [self show:error icon:@"error.png" view:view];
    [self show:error icon:@"" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}
#pragma mark 显示一些信息
+ (TKProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    TKProgressHUD *hud = [TKProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

/**
 *  手动关闭TKProgressHUD
 *
 *  @param view    显示TKProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}
@end
