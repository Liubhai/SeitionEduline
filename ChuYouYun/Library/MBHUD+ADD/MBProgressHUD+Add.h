//
//  MBProgressHUD+Add.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/8/22.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//


#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;
@end

