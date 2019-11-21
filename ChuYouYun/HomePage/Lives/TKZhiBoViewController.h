//
//  TKZhiBoViewController.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/8/22.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhiBoMainViewController.h"

@interface TKZhiBoViewController : UIViewController

@property (strong ,nonatomic)UITableView *tableView;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) ZhiBoMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;

@property (strong ,nonatomic)void (^vcHight)(CGFloat hight);
-(instancetype)initWithNumID:(NSString *)ID;

@end

