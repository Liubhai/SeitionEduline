//
//  InstationTeacherViewController.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstitutionMainViewController.h"

@interface InstationTeacherViewController : UIViewController

@property (strong ,nonatomic)UITableView *tableView;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) InstitutionMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;

@property (strong ,nonatomic)NSString *schoolID;
@property (strong ,nonatomic)void (^scrollHight)(CGFloat hight);

@end
