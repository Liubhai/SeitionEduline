//
//  CardVoucherMainViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/3/5.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "CardVoucherMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"

#import "Card_CouponsViewController.h"
#import "Card_DiscountViewController.h"
#import "Card_MembersViewController.h"
#import "Card_TopUpViewController.h"
#import "Card_ClassViewController.h"


@interface CardVoucherMainViewController ()<UIScrollViewDelegate>

@property (strong ,nonatomic)UIButton *couponsButton;
@property (strong ,nonatomic)UIButton *discountCardButton;
@property (strong ,nonatomic)UIButton *membersButton;
@property (strong ,nonatomic)UIButton *topUpButton;
@property (strong ,nonatomic)UIButton *classButton;
@property (strong ,nonatomic)UIButton *newsButton;

@property (assign ,nonatomic)CGFloat  buttonW;
@property (strong ,nonatomic)UIButton *HDButton;
@property (strong ,nonatomic)UIButton *seletedButton;

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;

//营销数据
@property (strong ,nonatomic)NSString     *order_switch;

@end

@implementation CardVoucherMainViewController

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
    _titleLabel.text = @"领券中心";
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
    titleText.text = @"领券中心";
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
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 34)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    //添加按钮
    NSArray *titleArray = @[@"优惠券",@"打折卡",@"会员卡",@"课程卡"];
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
            _couponsButton = button;
        } else if (i == 1) {
            _discountCardButton = button;
        } else if (i == 2) {
            _membersButton = button;
        } else if (i == 3) {
            _classButton = button;
        } else if (i == 4) {
            _classButton = button;
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
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 34,  MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 4,0);
    [self.view addSubview:_controllerSrcollView];
    _controllerSrcollView.backgroundColor = [UIColor redColor];
    
    Card_CouponsViewController * couponsVc= [[Card_CouponsViewController alloc]init];
    couponsVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34);
    [_controllerSrcollView addSubview:couponsVc.view];
    [self addChildViewController:couponsVc];
    
    Card_DiscountViewController * discountVc = [[Card_DiscountViewController alloc]init];
    discountVc.view.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34);
    [_controllerSrcollView addSubview:discountVc.view];
    [self addChildViewController:discountVc];
    
    Card_MembersViewController * membersVc = [[Card_MembersViewController alloc]init];
    membersVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34);
    [_controllerSrcollView addSubview:membersVc.view];
    [self addChildViewController:membersVc];
    
    
//    Card_TopUpViewController * topUpVc = [[Card_TopUpViewController alloc]init];
//    topUpVc.view.frame = CGRectMake(MainScreenWidth * 3, -98, MainScreenWidth, MainScreenHeight);
//    [self addChildViewController:topUpVc];
//    [_controllerSrcollView addSubview:topUpVc.view];
    
    Card_ClassViewController *classVc = [[Card_ClassViewController alloc]init];
    classVc.view.frame = CGRectMake(MainScreenWidth * 3, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34);
    [_controllerSrcollView addSubview:classVc.view];
    [self addChildViewController:classVc];
    
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
            
            [_couponsButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_discountCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_membersButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_topUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        } else if(point.x == MainScreenWidth) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW, 27 + 3, _buttonW, 1);
            }];
            
            [_discountCardButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_couponsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_membersButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_topUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }else if (point.x == MainScreenWidth * 2) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 2, 27 + 3, _buttonW, 1);
            }];
            
            [_membersButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_discountCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_couponsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_topUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        } else if (point.x == MainScreenWidth * 3) {
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 3, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 3, 27 + 3, _buttonW, 1);
            }];
            
            [_classButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_discountCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_membersButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_couponsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        } else if (point.x == MainScreenWidth * 4) {
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 4, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 3, 27 + 3, _buttonW, 1);
            }];
            
            [_classButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_discountCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_membersButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_topUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_couponsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}


#pragma mark ---   网络请求
//获取营销数据
- (void)netWorkConfigGetMarketStatus {
    
    NSString *endUrlStr = YunKeTang_config_getMarketStatus;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _order_switch = [dict stringValueForKey:@"order_switch"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
