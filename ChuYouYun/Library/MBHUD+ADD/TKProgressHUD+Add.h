//
//  TKProgressHUD+Add.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/8/22.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//


#import "TKProgressHUD.h"

@interface TKProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (TKProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;
@end

