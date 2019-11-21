//
//  MyViewController.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController<UITableViewDataSource,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *specialBtn;
@property (strong, nonatomic) UIButton *CrouseBtn;
@property (strong, nonatomic) UIView *line;
@property (strong ,nonatomic)UIView *bView;
@property (strong ,nonatomic)NSDictionary *allInformation;
@property (strong ,nonatomic)UILabel *userName;
@property (strong ,nonatomic)UIView *bgIView;

@property (strong ,nonatomic)UIView *orderView;
@property (strong ,nonatomic)UIView *hongBaoView;

@end
