//
//  Good_ClassNotesViewController.h
//  YunKeTang
//
//  Created by IOS on 2019/3/19.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Good_ClassMainViewController.h"

@interface Good_ClassNotesViewController : UIViewController

@property (assign, nonatomic) BOOL isNewClass;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) Good_ClassMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;

@property (strong ,nonatomic)UITableView   *tableView;

@property (strong ,nonatomic)void (^vcHight)(CGFloat hight);
-(instancetype)initWithNumID:(NSString *)ID;


@end
