//
//  GroupListPopViewController.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/23.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassAndLivePayViewController.h"

@interface GroupListPopViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *videoDataSource;
@property (strong, nonatomic) NSDictionary *activityInfo;//是否有活动详情
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UILabel *groupTitleLabel;
@property (strong, nonatomic) NSString *courseType;// 1 点播 2 直播 3 线下课 4 套餐 5 班级课

@end
