//
//  Good_DiscountMainViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/12/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface Good_DiscountMainViewController : BaseViewController

@property (strong ,nonatomic)NSDictionary *dict;
@property (strong ,nonatomic)NSString     *ID;
@property (assign, nonatomic) BOOL showYouhui;
@property (assign, nonatomic) BOOL isCombo;// 是不是套餐

@end
