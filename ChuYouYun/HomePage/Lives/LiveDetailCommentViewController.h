//
//  LiveDetailCommentViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/3/29.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhiBoMainViewController.h"

@interface LiveDetailCommentViewController : UIViewController

@property (strong ,nonatomic)UITableView     *tableView;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) ZhiBoMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;

@property (strong ,nonatomic)void (^getCommentHight)(CGFloat commentHight);
- (instancetype)initWithNumID:(NSString *)ID;

@end
