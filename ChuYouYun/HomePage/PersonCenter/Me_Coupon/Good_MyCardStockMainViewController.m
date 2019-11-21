//
//  Good_MyCardStockMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/2.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_MyCardStockMainViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"

#import "Good_DiscountCardViewController.h"
#import "Good_MemberCardViewController.h"
#import "Good_ClassCardViewController.h"
#import "Good_OnSaleViewController.h"


@interface Good_MyCardStockMainViewController ()<UIScrollViewDelegate>

@property (strong ,nonatomic)UIButton *liveButton;
@property (strong ,nonatomic)UIButton *classButton;
@property (strong ,nonatomic)UIButton *topicButton;
@property (strong ,nonatomic)UIButton *lineClassButton;

@property (assign ,nonatomic)CGFloat  buttonW;
@property (strong ,nonatomic)UIButton *HDButton;
@property (strong ,nonatomic)UIButton *seletedButton;

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;

@end

@implementation Good_MyCardStockMainViewController

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
    [self addNav];
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
    titleText.text = @"我的卡劵";
    [titleText setTextColor:[UIColor whiteColor]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:titleText];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        titleText.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 34)];
    if (iPhoneX) {
        WZView.frame = CGRectMake(0, 88, MainScreenWidth, 34);
    }
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];

    //添加按钮
    NSArray *titleArray = @[@"优惠券",@"打折卡",@"课程卡",@"会员卡"];
    
    CGFloat ButtonH = 20;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    _buttonW = ButtonW;
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(ButtonW * i, 7, ButtonW, ButtonH);
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        //        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(WZButton:) forControlEvents:UIControlEventTouchUpInside];
        [WZView addSubview:button];
        if (i == 0) {
            [self WZButton:button];
        }
        if (i == 0) {
            _liveButton = button;
        } else if (i == 1) {
            _classButton = button;
        } else if (i == 2) {
            _lineClassButton = button;
        } else if (i == 3) {
            _topicButton = button;
        }

        //添加分割线
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW + ButtonW * i, 10, 1, ButtonH - 6)];
        lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
        [WZView addSubview:lineButton];
        
        
    }
    
    //添加横线
    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 27 + 3, ButtonW, 1)];
    _HDButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [WZView addSubview:_HDButton];
    _HDButton.hidden = YES;
    
    
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
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 98,  MainScreenWidth, MainScreenHeight * 3 + 500)];
    if (iPhoneX) {
        _controllerSrcollView.frame = CGRectMake(0, 88 + 34, MainScreenWidth, MainScreenHeight * 3 + 500);
    }
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 4,0);
    [self.view addSubview:_controllerSrcollView];
    _controllerSrcollView.backgroundColor = [UIColor redColor];
    
    Good_OnSaleViewController * onSaleVc = [[Good_OnSaleViewController alloc]init];
    onSaleVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34);
    [_controllerSrcollView addSubview:onSaleVc.view];
    [self addChildViewController:onSaleVc];
    
    Good_DiscountCardViewController * discountCardVc= [[Good_DiscountCardViewController alloc]init];
    discountCardVc.view.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34);
    [_controllerSrcollView addSubview:discountCardVc.view];
    [self addChildViewController:discountCardVc];
    
    Good_ClassCardViewController * classCardVc = [[Good_ClassCardViewController alloc]init];
    classCardVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34);
    [_controllerSrcollView addSubview:classCardVc.view];
    [self addChildViewController:classCardVc];
    
    Good_MemberCardViewController * memberCardVc = [[Good_MemberCardViewController alloc]init];
    memberCardVc.view.frame = CGRectMake(MainScreenWidth * 3, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34);
    [_controllerSrcollView addSubview:memberCardVc.view];
    [self addChildViewController:memberCardVc];
    
    
    
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
            
            [_liveButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_topicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        } else if(point.x == MainScreenWidth) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW, 27 + 3, _buttonW, 1);
            }];
            [_liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_topicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }else if (point.x == MainScreenWidth * 2) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 2, 27 + 3, _buttonW, 1);
            }];
            
            [_liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_topicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        } else if (point.x == MainScreenWidth * 3) {
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 3, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 3, 27 + 3, _buttonW, 1);
            }];
            
            [_liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_topicButton setTitleColor:BasidColor forState:UIControlStateNormal];
        }
    }
}



@end
