//
//  ZHCGViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//
//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕


#import "ZHCGViewController.h"
#import "AppDelegate.h"
#import "SYG.h"

@interface ZHCGViewController ()

@end

@implementation ZHCGViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if ([self.typeStr isEqualToString:@"123"]) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:YES];
    }

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if ([self.typeStr isEqualToString:@"123"]) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:NO];
    }

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self addImageAndButton];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    
}

- (void)addNav {
    //添加View
    UIView *NavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    NavView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self.view addSubview:NavView];
    
    //添加按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 30, 14, 23)];
    [backButton setImage:[UIImage imageNamed:@"ArrowWJ"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:backButton];
    
    //添加
    UILabel *ZCLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 25, 100, 30)];
    ZCLabel.textAlignment = NSTextAlignmentCenter;
    ZCLabel.text = @"找回密码";
    ZCLabel.textColor = [UIColor whiteColor];
    ZCLabel.font = [UIFont systemFontOfSize:20];
    [NavView addSubview:ZCLabel];

}

- (void)addImageAndButton {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 40, MainScreenHeight / 5, 80, 80)];
    imageView.image = [UIImage imageNamed:@"找回成功@2x"];
    [self.view addSubview:imageView];
    
    //添加成功
    UILabel *CGLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 80, MainScreenHeight / 5 * 2, 160, 30)];
    CGLabel.text = @"成功";
    CGLabel.textColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    CGLabel.textAlignment = NSTextAlignmentCenter;
    CGLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:CGLabel];
    
    //提示成功
    UILabel *TSLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, MainScreenHeight / 9 * 4, MainScreenWidth - 60, 60)];
    TSLabel.numberOfLines = 2;
    TSLabel.textColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    TSLabel.text = @"我们已将找回密码的邮件发送到你的邮箱，请尽快查阅邮箱并重设密码";
    TSLabel.textAlignment = NSTextAlignmentCenter;
    TSLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:TSLabel];

    //查看邮箱
    UIButton *YXButton = [[UIButton alloc] initWithFrame:CGRectMake(25, MainScreenHeight / 7 * 4, MainScreenWidth - 50, 40)];
    [YXButton setTitle:@"查看邮箱" forState:UIControlStateNormal];
    [YXButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    YXButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    YXButton.layer.cornerRadius = 3;
    [YXButton addTarget:self action:@selector(YXButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:YXButton];
    YXButton.hidden = YES;
    
    if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
        YXButton.frame = CGRectMake(25, MainScreenHeight / 7 * 4 + 30, MainScreenWidth - 50, 40);
    }else if (iPhone6) {
        imageView.frame = CGRectMake(MainScreenWidth / 2 - 40, MainScreenHeight / 5 - 20, 80, 80);
        CGLabel.frame = CGRectMake(MainScreenWidth / 2 - 80, MainScreenHeight / 3, 160, 30);
    }else if (iPhone6Plus) {
        CGLabel.frame = CGRectMake(MainScreenWidth / 2 - 80, MainScreenHeight / 3 + 20, 160, 30);
    }
    
   
    
    
}

- (void)YXButton {
    
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
