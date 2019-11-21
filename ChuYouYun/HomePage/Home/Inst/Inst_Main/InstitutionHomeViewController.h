//
//  InstitutionHomeViewController.h
//  dafengche
//
//  Created by 智艺创想 on 16/10/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstitutionMainViewController.h"

@interface InstitutionHomeViewController : UIViewController

@property (strong ,nonatomic)UIView *allBigView;
@property (strong ,nonatomic)UIWindow *window;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIImageView *imgaeView;
@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)NSString *schoolID;
@property (strong ,nonatomic)NSDictionary *schoolDic;
@property (strong ,nonatomic)NSString *address;

@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) InstitutionMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;


@end
