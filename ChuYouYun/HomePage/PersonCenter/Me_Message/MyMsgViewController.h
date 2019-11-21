//
//  MyMsgViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MyMsgViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong ,nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *msgArr;
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic)NSMutableArray *to_user_infoArr;
@property (strong ,nonatomic)NSMutableArray *magArr;

@end
