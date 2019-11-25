//
//  ClassAndLivePayViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/10/13.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ClassAndLivePayViewController : BaseViewController

@property (strong ,nonatomic)NSDictionary *dict;
@property (strong ,nonatomic)NSDictionary *cellDict;
@property (strong ,nonatomic)NSString *cid;
@property (strong ,nonatomic)NSString *typeStr;//区分是直播还是视频 1 点播 2 直播 3 线下课 4 套餐
@property (strong, nonatomic) NSDictionary *activityInfo;//是否有活动详情

@end
