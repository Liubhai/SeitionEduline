//
//  InstitionDiscountViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/3/7.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface InstitionDiscountViewController : BaseViewController

@property (strong ,nonatomic)NSString *schoolID;
@property (strong ,nonatomic)UIButton *HDButton;
@property (strong ,nonatomic)UIButton *seletedButton;
@property (assign ,nonatomic)CGFloat buttonW;

@property (strong ,nonatomic)NSString *typeStr;
//@property (strong ,nonatomic)NSDictionary *orderDict;

@end
