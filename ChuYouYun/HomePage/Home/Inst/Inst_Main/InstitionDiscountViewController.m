//
//  InstitionDiscountViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/7.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "InstitionDiscountViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "InstReductionViewController.h"
#import "InstCouponViewController.h"



@interface InstitionDiscountViewController ()<UIScrollViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)UILabel *titleText;
@property (strong ,nonatomic)UIScrollView *controllerSrcollView;

@property (strong ,nonatomic)UIButton *reductionButton;
@property (strong ,nonatomic)UIButton *couponButton;


@end

@implementation InstitionDiscountViewController

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
    _titleLabel.text = @"机构优惠券";
    [self addWZView];
    [self addControllerSrcollView];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    _titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    _titleText.text = @"机构优惠券";
    [_titleText setTextColor:[UIColor whiteColor]];
    _titleText.textAlignment = NSTextAlignmentCenter;
    _titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:_titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 34)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT - 1,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [self.view addSubview:lineLab];
    //添加按钮
    NSArray *titleArray = @[@"优惠券",@"打折卡"];
    
    CGFloat ButtonH = 20;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    _buttonW = ButtonW;
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(ButtonW * i, 7, ButtonW, ButtonH);
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithRed:89.f / 255 green:89.f / 255 blue:89.f / 255 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(WZButton:) forControlEvents:UIControlEventTouchUpInside];
        [WZView addSubview:button];
        if (i == [_typeStr integerValue]) {
            [self WZButton:button];
        }
        
        if (i == 0) {
            _reductionButton = button;
        } else if (i == 1) {
            _couponButton = button;
        }
        
    }
    
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 1, 10, 1, 14)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [WZView addSubview:lineButton];
    
    //添加横线
    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * [_typeStr integerValue], 27 + 3, ButtonW, 1)];
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
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 34,  MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34)];
    _controllerSrcollView.backgroundColor = [UIColor clearColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.showsHorizontalScrollIndicator = NO;
    _controllerSrcollView.showsVerticalScrollIndicator = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 2,0);
    [self.view addSubview:_controllerSrcollView];
    _controllerSrcollView.backgroundColor = [UIColor redColor];
    
    InstReductionViewController * reductionVc= [[InstReductionViewController alloc]initWithSchoolID:_schoolID];
    reductionVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34);
    [_controllerSrcollView addSubview:reductionVc.view];
    [self addChildViewController:reductionVc];
    
    
    InstCouponViewController * couponVc= [[InstCouponViewController alloc]initWithSchoolID:_schoolID];
    couponVc.view.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34);
    [_controllerSrcollView addSubview:couponVc.view];
    [self addChildViewController:couponVc];
    
    //添加通知(通知所传达的地方必须要已经实体化，不然就不会相应通知的方法)
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"" forKey:@"school_id"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationInstitionSchoolID" object:nil userInfo:dict];
    
    //最先显示哪个视图
    _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * ([_typeStr integerValue]), 0);
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
            
            [_reductionButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_couponButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        } else if(point.x == MainScreenWidth) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW, 27 + 3, _buttonW, 1);
            }];
            [_reductionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_couponButton setTitleColor:BasidColor forState:UIControlStateNormal];
            
        }
    }
    
}





@end
