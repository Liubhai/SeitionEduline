//
//  OrderPagerViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/3/9.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPagerViewController : UIViewController

@property (strong ,nonatomic)UIButton *HDButton;
@property (strong ,nonatomic)UIButton *seletedButton;
@property (assign ,nonatomic)CGFloat buttonW;

@property (strong ,nonatomic)NSString *typeStr;
@property (strong ,nonatomic)NSDictionary *orderDict;

@property (strong ,nonatomic) NSString *isInstOrMyOrder;//判定是否是机构的订单还是我的订单

@end
