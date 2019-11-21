//
//  CalendarViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/3.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "CalendarViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

#import "GFCalendar.h"


@interface CalendarViewController ()

@end

@implementation CalendarViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNotication];
    [self addNav];
    [self setupCalendar];
}

- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNotication {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNoticationGetInstID" object:_schoolID];
    
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    titleText.text = @"日历";
    [titleText setTextColor:[UIColor whiteColor]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --- 添加界面

- (void)setupCalendar {
    
    CGFloat width = self.view.bounds.size.width - 20.0;
    CGPoint origin = CGPointMake(10.0, 64.0 + 70.0);
    
    GFCalendarView *calendar = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width];
    
    calendar.schoolID = _schoolID;
    // 点击某一天的回调   
    calendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
        
        NSLog(@"%ld  %ld   %ld",year,month,day);
        
        NSString *timeStr = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationGetDate" object:timeStr];
        
        [self backPressed];
    
        
        
//        PushedViewController *pvc = [[PushedViewController alloc] init];
//        pvc.title = [NSString stringWithFormat:@"%ld年%ld月%ld日", year, month, day];
//        [self.navigationController pushViewController:pvc animated:YES];
        
    };
    
    [self.view addSubview:calendar];
    
}


@end
