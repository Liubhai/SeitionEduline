//
//  Good_ClassCommentViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Good_ClassMainViewController.h"

@interface Good_ClassCommentViewController : UIViewController

@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) Good_ClassMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (assign, nonatomic) BOOL isNewClass;

@property (strong ,nonatomic)UITableView     *tableView;

@property (strong ,nonatomic)void(^vcHight)(CGFloat hight);
-(instancetype)initWithNumID:(NSString *)ID;

@end
