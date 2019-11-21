//
//  GenSeeLiveViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/8/2.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenSeeLiveViewController : UIViewController

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *secitonID;
@property (strong ,nonatomic)NSString *account;
@property (strong ,nonatomic)NSString *domain;
@property (strong ,nonatomic)NSString *typeStr;


-(void)initwithTitle:(NSString *)title nickName:(NSString *)nickName watchPassword:(NSString *)watchPassword roomNumber:(NSString *)roomNumber;

@end
