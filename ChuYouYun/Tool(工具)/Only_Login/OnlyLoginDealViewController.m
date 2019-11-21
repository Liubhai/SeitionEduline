//
//  OnlyLoginDealViewController.m
//  YunKeTang
//
//  Created by IOS on 2018/11/26.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "OnlyLoginDealViewController.h"

@interface OnlyLoginDealViewController ()

@end

@implementation OnlyLoginDealViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
}

- (void)interFace {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlyLogin:) name:@"OnlyLoginNSNotification" object:nil];
}


- (void)onlyLogin:(NSNotification *)not {
    
    
}


@end
