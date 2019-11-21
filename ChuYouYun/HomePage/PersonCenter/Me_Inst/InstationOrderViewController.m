//
//  InstationOrderViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "InstationOrderViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

#import "AllOrderModelVC.h"
#import "NoPayVC.h"
#import "CanceledVC.h"
#import "PaidVC.h"
#import "NoRefundVC.h"
#import "RefundVC.h"



@interface InstationOrderViewController ()<UIScrollViewDelegate>{
    BOOL isSele;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UILabel *titleText;
@property (strong ,nonatomic)UIScrollView *controllerSrcollView;

@property (strong ,nonatomic)UIButton *allOrderButton;
@property (strong ,nonatomic)UIButton *noPayButton;
@property (strong ,nonatomic)UIButton *canceledButton;
@property (strong ,nonatomic)UIButton *paidButton;
@property (strong ,nonatomic)UIButton *noRefundButton;
@property (strong ,nonatomic)UIButton *refundButton;

@property (strong ,nonatomic)UIButton *titleButton;
@property (strong ,nonatomic)UIView   *allWindowView;

@property (strong ,nonatomic)NSString *classTypeStr;
@property (strong ,nonatomic)NSArray  *indexTitleArray;



@end

@implementation InstationOrderViewController

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
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
//    //添加中间的文字
//    _titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
//    _titleText.text = @"机构订单";
//    [_titleText setTextColor:[UIColor whiteColor]];
//    _titleText.textAlignment = NSTextAlignmentCenter;
//    _titleText.font = [UIFont systemFontOfSize:20];
//    [SYGView addSubview:_titleText];
    
    
    _titleButton = [[UIButton  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    [_titleButton setTitle:@"点播订单" forState:UIControlStateNormal];
    [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _titleButton.titleLabel.font = Font(20);
    [_titleButton setImage:Image(@"icon_white_down") forState:UIControlStateNormal];
    _titleButton.imageEdgeInsets =  UIEdgeInsetsMake(0,170 * WideEachUnit,0,0);
    _titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [_titleButton addTarget:self action:@selector(titleButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:_titleButton];
    
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 34)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [self.view addSubview:lineLab];
    //添加按钮
    NSArray *titleArray = @[@"已支付",@"未退款",@"已退款"];
    
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
        if (i == 0) {
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
        } else if (i == 4) {
            _noRefundButton = button;
        } else if (i == 5) {
            _refundButton = button;
        }
        
    }
    
    //添加横线
    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * [_typeStr integerValue], 27 + 3, ButtonW, 1)];
    _HDButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [WZView addSubview:_HDButton];
    
    
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

    _HDButton.hidden = YES;
      _controllerSrcollView.contentOffset = CGPointMake(button.tag * MainScreenWidth, 0);
    
}


- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 98,  MainScreenWidth, MainScreenHeight * 3 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [self.view addSubview:_controllerSrcollView];
    _controllerSrcollView.backgroundColor = [UIColor whiteColor];
    
//    AllOrderModelVC * allVc= [[AllOrderModelVC alloc]init];
//    allVc.view.frame = CGRectMake(0, -98, MainScreenWidth, MainScreenHeight);
//    [self addChildViewController:allVc];
//    [_controllerSrcollView addSubview:allVc.view];
//
//    NoPayVC * noPayVc = [[NoPayVC alloc]init];
//    noPayVc.view.frame = CGRectMake(MainScreenWidth, -98, MainScreenWidth, MainScreenHeight * 2 + 500);
//    [self addChildViewController:noPayVc];
//    [_controllerSrcollView addSubview:noPayVc.view];
//
//    CanceledVC * canceledVc = [[CanceledVC alloc]init];
//    canceledVc.view.frame = CGRectMake(MainScreenWidth * 2, -98, MainScreenWidth, MainScreenHeight);
//    [self addChildViewController:canceledVc];
//    [_controllerSrcollView addSubview:canceledVc.view];
//    
//    PaidVC * paidVc = [[PaidVC alloc]init];
    PaidVC *paidVc = [[PaidVC alloc] initWithType:@"inst" WithSchoolID:_schoolID];
    paidVc.view.frame = CGRectMake(0, -98, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:paidVc];
    [_controllerSrcollView addSubview:paidVc.view];
    
    NoRefundVC * noRefundVc = [[NoRefundVC alloc] initWithType:@"inst"];
    noRefundVc.view.frame = CGRectMake(MainScreenWidth, -98, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:noRefundVc];
    [_controllerSrcollView addSubview:noRefundVc.view];
    
    RefundVC * refundVc = [[RefundVC alloc] initWithType:@"inst"];
    refundVc.view.frame = CGRectMake(MainScreenWidth * 2, -98, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:refundVc];
    [_controllerSrcollView addSubview:refundVc.view];
    
    //添加通知(通知所传达的地方必须要已经实体化，不然就不会相应通知的方法)
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_schoolID forKey:@"school_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationInstitionSchoolID" object:nil userInfo:dict];
    
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
            
            [_allOrderButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_noPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_canceledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_paidButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_noRefundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_refundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        } else if(point.x == MainScreenWidth) {

            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW, 27 + 3, _buttonW, 1);
            }];
            [_allOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_noPayButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_canceledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_paidButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_noRefundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_refundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }else if (point.x == MainScreenWidth * 2) {

            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 2, 27 + 3, _buttonW, 1);
            }];
            
            [_allOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_noPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_canceledButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_paidButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_noRefundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_refundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        } else if (point.x == MainScreenWidth * 3) {
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 3, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 3, 27 + 3, _buttonW, 1);
            }];
            
            [_allOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_noPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_canceledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_paidButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_noRefundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_refundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        } else if (point.x == MainScreenWidth * 4) {
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 4, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 4, 27 + 3, _buttonW, 1);
            }];
            
            [_allOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_noPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_canceledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_paidButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_noRefundButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_refundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        } else if (point.x == MainScreenWidth * 5) {
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 5, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 5, 27 + 3, _buttonW, 1);
            }];
            
            [_allOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_noPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_canceledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_paidButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_noRefundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_refundButton setTitleColor:BasidColor forState:UIControlStateNormal];
        }

    }

}


#pragma mark --- 添加标题视图
- (void)addTitleView {
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds = YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0,64,MainScreenWidth,150 * WideEachUnit)];
    //    moreView.center = app.keyWindow.center;
    //    moreView.center = CGPointMake(MainScreenWidth / 2, MainScreenHeight / 3);
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    moreView.userInteractionEnabled = YES;
    _allWindowView.userInteractionEnabled = YES;
    
    NSArray *indexImageArray = @[@"icon_order_class",@"icon_order_live",@"icon_order_teacher",@"icon_order_teacher"];
    NSArray *indexTitleArray = @[@"点播订单",@"直播订单",@"线下课订单",@"考试订单"];
    _indexTitleArray = indexTitleArray;
    CGFloat indexViewW = MainScreenWidth;
    CGFloat indexViewH = 50 * WideEachUnit;
    [moreView setHeight:indexViewH * indexTitleArray.count];
    for (int i = 0 ; i < 4; i ++) {
        
        UIView *indexView = [[UIView alloc] initWithFrame:CGRectMake(0, indexViewH * i, indexViewW, indexViewH)];
        indexView.backgroundColor = [UIColor whiteColor];
        [moreView addSubview:indexView];
        indexView.tag = i;
        [indexView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)]];
        
        
        
        
        UIImageView *indexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 15 * WideEachUnit, 20 * WideEachUnit, 20 * WideEachUnit)];
        indexImageView.image = Image(indexImageArray[i]);
        [indexView addSubview:indexImageView];
        
        UILabel *indexTitle = [[UILabel alloc] initWithFrame:CGRectMake(40 * WideEachUnit, 15 * WideEachUnit, 100 * WideEachUnit, 20 * WideEachUnit)];
        indexTitle.font = Font(15);
        indexTitle.textColor = [UIColor colorWithHexString:@"#888"];
        indexTitle.text = indexTitleArray[i];
        [indexView addSubview:indexTitle];
    }
    
}



- (void)titleButtonCilck {
    isSele = !isSele;
    if (isSele) {//添加
        [self addTitleView];
        [UIView animateWithDuration:0.25 animations:^{
            self.titleButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {//取消
        [UIView animateWithDuration:0.25 animations:^{
            self.titleButton.imageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
        }];
    }
}

- (void)allWindowViewClick:(UIGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
    isSele = NO;
}

#pragma mark --- 手势
- (void)viewClick:(UIGestureRecognizer *)tap {
    NSInteger indexTag = tap.view.tag;
    _classTypeStr = [NSString stringWithFormat:@"%ld",indexTag];
    [_titleButton setTitle:_indexTitleArray[indexTag] forState:UIControlStateNormal];
    [_allWindowView removeFromSuperview];
    isSele = NO;
    //动画
    [UIView animateWithDuration:0.25 animations:^{
        self.titleButton.imageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
    }];
    
    //这里做数据传输
    [[NSNotificationCenter defaultCenter] postNotificationName:@"My_Inst_Order_ClassType" object:_classTypeStr];
    
}

@end
