//
//  Good_MessageMainViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/9.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_MessageMainViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"

#import "MyMsgViewController.h"
#import "receiveCommandViewController.h"
#import "SystemViewController.h"

@interface Good_MessageMainViewController ()<UIScrollViewDelegate>

@property (strong ,nonatomic)UIButton *msgButton;
@property (strong ,nonatomic)UIButton *receiveButton;
@property (strong ,nonatomic)UIButton *systemButton;

@property (assign ,nonatomic)CGFloat  buttonW;
@property (strong ,nonatomic)UIButton *HDButton;
@property (strong ,nonatomic)UIButton *seletedButton;

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;


@end

@implementation Good_MessageMainViewController
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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"我的消息";
    [self addWZView];
    [self addControllerSrcollView];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    UILabel *titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    titleText.text = @"我的消息";
    [titleText setTextColor:[UIColor whiteColor]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        titleText.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        button.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 45)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    //添加按钮
    NSArray *titleArray = @[@"私信",@"评论",@"通知"];
    //    NSArray *titleArray = @[@"直播",@"点播"];
    
    CGFloat ButtonH = 25 * WideEachUnit;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    _buttonW = ButtonW;
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(ButtonW * i, 10 * WideEachUnit, ButtonW, ButtonH);
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14 * WideEachUnit];
        //        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(WZButton:) forControlEvents:UIControlEventTouchUpInside];
        [WZView addSubview:button];
        if (i == 0) {
            [self WZButton:button];
        }
        
        if (i == 0) {
            _msgButton = button;
        } else if (i == 1) {
            _receiveButton = button;
        } else if (i == 2) {
            _systemButton = button;
        }
        
        //添加分割线
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW + ButtonW * i, 10 * WideEachUnit, 1, 25 * WideEachUnit)];
        lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
        [WZView addSubview:lineButton];
    }
    
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
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 45 * WideEachUnit,  MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [self.view addSubview:_controllerSrcollView];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    MyMsgViewController * msgVc= [[MyMsgViewController alloc]init];
    msgVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45);
    [_controllerSrcollView addSubview:msgVc.view];
    [self addChildViewController:msgVc];
    
    receiveCommandViewController * receiveVc = [[receiveCommandViewController alloc]init];
    receiveVc.view.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45);
    [_controllerSrcollView addSubview:receiveVc.view];
    [self addChildViewController:receiveVc];
    
    SystemViewController* systemVc = [[SystemViewController alloc]init];
    systemVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45);
    [_controllerSrcollView addSubview:systemVc.view];
    [self addChildViewController:systemVc];
    
}



#pragma mark --- 滚动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //要吧之前的按钮设置为未选中 不然颜色不会变
    self.seletedButton.selected = NO;
    
    
    NSLog(@"%lf",scrollView.contentOffset.x);
    
    if (_controllerSrcollView == scrollView) {
        CGPoint point = scrollView.contentOffset;
        if (point.x == 0) {
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(0, 27 + 3, _buttonW, 1);
            }];
            
            [_msgButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_receiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_systemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        } else if(point.x == MainScreenWidth) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW, 27 + 3, _buttonW, 1);
            }];
            [_msgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_receiveButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_systemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        }else if (point.x == MainScreenWidth * 2) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 2, 27 + 3, _buttonW, 1);
            }];
            
            [_msgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_receiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_systemButton setTitleColor:BasidColor forState:UIControlStateNormal];
        }
    }
}


@end
