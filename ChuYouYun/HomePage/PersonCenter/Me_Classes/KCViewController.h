//
//  KCViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 15/12/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCViewController : UIViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic) NSString *typeString;// newClass 班级课 course 点播课

@end
