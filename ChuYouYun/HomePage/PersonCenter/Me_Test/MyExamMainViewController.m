//
//  MyExamMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/26.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MyExamMainViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

#import "MyExerciseViewController.h"
#import "MyTestViewController.h"
#import "MyFaultViewController.h"
#import "MyTestCollectViewController.h"


@interface MyExamMainViewController ()<UIScrollViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UILabel *titleText;
@property (strong ,nonatomic)UIScrollView *controllerSrcollView;

@property (strong ,nonatomic)UIButton *allOrderButton;
@property (strong ,nonatomic)UIButton *noPayButton;
@property (strong ,nonatomic)UIButton *canceledButton;
@property (strong ,nonatomic)UIButton *paidButton;
@property (strong ,nonatomic)UIButton *noRefundButton;
@property (strong ,nonatomic)UIButton *refundButton;

@property (strong ,nonatomic)NSString *offStr;//计算偏移量的

@end

@implementation MyExamMainViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if (_offStr == nil) {
        
    } else {
        _controllerSrcollView.contentOffset = CGPointMake([_offStr integerValue] * MainScreenWidth, 0);
    }
    
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
    [self addNav];
    [self addWZView];
    [self addControllerSrcollView];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exercise:) name:@"NSNotificationExercise" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exams:) name:@"NSNotificationExams" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WrongExams:) name:@"NSNotificationWrongExams" object:nil];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    _titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    _titleText.text = @"我的考试";
    [_titleText setTextColor:[UIColor whiteColor]];
    _titleText.textAlignment = NSTextAlignmentCenter;
    _titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:_titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        _titleText.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        button.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 44 * WideEachUnit)];
    if (iPhoneX) {
        WZView.frame = CGRectMake(0, 88, MainScreenWidth, 44 * WideEachUnit);
    }
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    //添加按钮
    NSArray *titleArray = @[@"练习记录",@"考试记录",@"错题记录",@"题目收藏"];
    
    CGFloat ButtonH = 44 * WideEachUnit;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    _buttonW = ButtonW;
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(ButtonW * i, 0, ButtonW, ButtonH);
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16 * WideEachUnit];
        //        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(WZButton:) forControlEvents:UIControlEventTouchUpInside];
        [WZView addSubview:button];
        if (i == [_typeStr integerValue]) {
            [self WZButton:button];
        }
        
        if (i == 0) {
            _allOrderButton = button;
        } else if (i == 1) {
            _noPayButton = button;
        } else if (i == 2) {
            _canceledButton = button;
        } else if (i == 3) {
            _paidButton = button;
        }
        
        //添加分割线
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW + ButtonW * i, 15 * WideEachUnit, 1, 14 * WideEachUnit)];
        lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
        [WZView addSubview:lineButton];
        
        
    }
    
    //添加横线
    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * [_typeStr integerValue], 27 + 3, ButtonW, 1)];
    
    //    NSString *title = titleArray[[_typeStr integerValue]];
    //    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * [_typeStr integerValue], 27 + 3, title.length * 14, 1)];
    
    _HDButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [WZView addSubview:_HDButton];
    _HDButton.hidden = YES;
    
    //添加线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 43 * WideEachUnit, MainScreenWidth, 1 * WideEachUnit)];
    lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [WZView addSubview:lineLabel];
    
    
}


- (void)WZButton:(UIButton *)button {
    
    self.seletedButton.selected = NO;
    button.selected = YES;
    self.seletedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        _HDButton.frame = CGRectMake(button.tag * _buttonW, 27 + 3, _buttonW, 1);
        //        _pay_status = [NSString stringWithFormat:@"%ld",button.tag];
    }];
    //    [self NetWorkGetOrder];
    
    _controllerSrcollView.contentOffset = CGPointMake(button.tag * MainScreenWidth, 0);
    
}


- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 44 * WideEachUnit,  MainScreenWidth, MainScreenHeight * 3 + 500)];
    if (iPhoneX) {
        _controllerSrcollView.frame = CGRectMake(0, 88 + 44, MainScreenWidth, MainScreenHeight * 3 + 500);
    }
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 4,0);
    [self.view addSubview:_controllerSrcollView];
    _controllerSrcollView.backgroundColor = [UIColor redColor];
    
    MyExerciseViewController * exerciseVc = [[MyExerciseViewController alloc] init];
    exerciseVc.view.frame = CGRectMake(0, -64 - 44 * WideEachUnit, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:exerciseVc];
    [_controllerSrcollView addSubview:exerciseVc.view];
    
    MyTestViewController * testVc = [[MyTestViewController alloc] init];
    testVc.view.frame = CGRectMake(MainScreenWidth, -64 - 44 * WideEachUnit, MainScreenWidth, MainScreenHeight * 2 + 500);
    [self addChildViewController:testVc];
    [_controllerSrcollView addSubview:testVc.view];
    
    MyFaultViewController * faultVc = [[MyFaultViewController alloc] init];
    faultVc.view.frame = CGRectMake(MainScreenWidth * 2, -64 - 44 * WideEachUnit, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:faultVc];
    [_controllerSrcollView addSubview:faultVc.view];
    //
    //    PaidVC * paidVc = [[PaidVC alloc]init];
    MyTestCollectViewController *testCollectVc = [[MyTestCollectViewController alloc] init];
    testCollectVc.view.frame = CGRectMake(MainScreenWidth * 3, -64 - 44 * WideEachUnit, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:testCollectVc];
    [_controllerSrcollView addSubview:testCollectVc.view];
    
    //添加通知(通知所传达的地方必须要已经实体化，不然就不会相应通知的方法)
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"" forKey:@"school_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationInstitionSchoolID" object:nil userInfo:dict];
    
    //最先显示哪个视图
    _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * ([_typeStr integerValue]), 0);
}


#pragma mark ---- 通知

- (void)exercise:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSString *offStr = (NSString *)not.object;
    _offStr = offStr;
    _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * ([offStr integerValue]), 0);
}

- (void)exams:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSString *offStr = (NSString *)not.object;
    _offStr = offStr;
    _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * ([offStr integerValue]), 0);
}

- (void)WrongExams:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSString *offStr = (NSString *)not.object;
    _offStr = offStr;
    _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * ([offStr integerValue]), 0);
}

//
//#pragma mark --- 滚动代理
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    //要吧之前的按钮设置为未选中 不然颜色不会变
//    self.seletedButton.selected = NO;
//
//
//    NSLog(@"%lf",scrollView.contentOffset.x);
//
//    if (_controllerSrcollView == scrollView) {
//        CGPoint point = scrollView.contentOffset;
//        if (point.x == 0) {
//            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
//
//
//            [UIView animateWithDuration:0.25 animations:^{
//                _HDButton.frame = CGRectMake(0, 27 + 3, _buttonW, 1);
//            }];
//
//            [_allOrderButton setTitleColor:BasidColor forState:UIControlStateNormal];
//            [_noPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_canceledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_paidButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_noRefundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_refundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//
//        } else if(point.x == MainScreenWidth) {
//
//            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
//
//            [UIView animateWithDuration:0.25 animations:^{
//                _HDButton.frame = CGRectMake(_buttonW, 27 + 3, _buttonW, 1);
//            }];
//            [_allOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_noPayButton setTitleColor:BasidColor forState:UIControlStateNormal];
//            [_canceledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_paidButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_noRefundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_refundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//        }else if (point.x == MainScreenWidth * 2) {
//
//            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
//
//            [UIView animateWithDuration:0.25 animations:^{
//                _HDButton.frame = CGRectMake(_buttonW * 2, 27 + 3, _buttonW, 1);
//            }];
//
//            [_allOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_noPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_canceledButton setTitleColor:BasidColor forState:UIControlStateNormal];
//            [_paidButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_noRefundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_refundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//        } else if (point.x == MainScreenWidth * 3) {
//            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 3, 0);
//
//            [UIView animateWithDuration:0.25 animations:^{
//                _HDButton.frame = CGRectMake(_buttonW * 3, 27 + 3, _buttonW, 1);
//            }];
//
//            [_allOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_noPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_canceledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_paidButton setTitleColor:BasidColor forState:UIControlStateNormal];
//            [_noRefundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_refundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//        } else if (point.x == MainScreenWidth * 4) {
//            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 4, 0);
//
//            [UIView animateWithDuration:0.25 animations:^{
//                _HDButton.frame = CGRectMake(_buttonW * 4, 27 + 3, _buttonW, 1);
//            }];
//
//            [_allOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_noPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_canceledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_paidButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_noRefundButton setTitleColor:BasidColor forState:UIControlStateNormal];
//            [_refundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//        } else if (point.x == MainScreenWidth * 5) {
//            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 5, 0);
//
//            [UIView animateWithDuration:0.25 animations:^{
//                _HDButton.frame = CGRectMake(_buttonW * 5, 27 + 3, _buttonW, 1);
//            }];
//
//            [_allOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_noPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_canceledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_paidButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_noRefundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_refundButton setTitleColor:BasidColor forState:UIControlStateNormal];
//        }
//
//    }
//    
//}


@end
