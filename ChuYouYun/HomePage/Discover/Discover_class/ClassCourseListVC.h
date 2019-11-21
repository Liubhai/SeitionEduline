//
//  ClassCourseListVC.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassDetailViewController.h"

@class ClassDetailViewController;

@interface ClassCourseListVC : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (strong, nonatomic) ClassDetailViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (nonatomic, assign) CGFloat tableHeight;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSDictionary *originDict;

@end
