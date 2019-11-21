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
@property (strong ,nonatomic)NSString *typeStr;//区分是直播还是视频 1 点播 2 直播 3 线下课 4 套餐 5 班级课
@property (strong, nonatomic) NSDictionary *activityInfo;//是否有活动详情
@property (assign, nonatomic) BOOL isBuyAlone;// 立即购买(单独购买) yes 不是单独购买 NO 是单独购买
@property (assign, nonatomic) BOOL isJoinGroup;//是否是参团
@property (strong ,nonatomic) NSString *groupID;//如果是参团  团的 id 参团时候才有效


@end
