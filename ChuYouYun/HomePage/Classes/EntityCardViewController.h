//
//  EntityCardViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2018/1/8.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EntityCardViewController : BaseViewController

@property (strong ,nonatomic)NSDictionary     *dict;
@property (strong ,nonatomic)NSDictionary     *entityDict;
@property (strong, nonatomic) NSDictionary *activityInfo;//是否有活动详情
@property (assign, nonatomic) BOOL isCombo;// 是否是套餐

@end
