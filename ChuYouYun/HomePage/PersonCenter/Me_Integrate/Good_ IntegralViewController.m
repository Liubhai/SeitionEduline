//
//  Good_ IntegralViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/10/17.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_ IntegralViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "Good_IntegralParticularsViewController.h"
#import "BuyAgreementViewController.h"

@interface Good__IntegralViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIWebViewDelegate>

@property (strong ,nonatomic)UIView   *alipayView;
@property (strong ,nonatomic)UIView    *wxpayView;
@property (strong ,nonatomic)UIButton  *ailpaySeleButton;
@property (strong ,nonatomic)UIButton  *wxSeleButton;
@property (strong ,nonatomic)NSMutableArray   *payTypeArray;

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)UIView   *moneyView;
@property (strong ,nonatomic)UIView   *rechargeView;
@property (strong ,nonatomic)UIView   *payView;
@property (strong ,nonatomic)UIView   *agreeView;
@property (strong ,nonatomic)UIView   *downView;

@property (strong ,nonatomic)UILabel  *scoreLabel;
@property (strong ,nonatomic)UITextField *textField;
@property (strong ,nonatomic)UIButton  *balanceSeleButton;
@property (strong ,nonatomic)UIButton  *bankSeleButton;
@property (strong ,nonatomic)UIButton  *agreeButton;
@property (strong ,nonatomic)UIButton  *submitButton;
@property (strong ,nonatomic)UILabel   *remark;
@property (strong ,nonatomic)UILabel   *exchange;
@property (strong ,nonatomic)UILabel   *balanceseInformationLabel;
@property (strong ,nonatomic)UILabel   *splitInformationLabel;
@property (strong ,nonatomic)UILabel   *realMoney;

@property (strong ,nonatomic)NSString  *payTypeStr;
@property (strong ,nonatomic)NSDictionary *scoreDict;
@property (strong ,nonatomic)NSArray      *componentsArray;
@property (strong ,nonatomic)NSString     *sple_score_str;

@property (strong ,nonatomic)UIWebView *webView;

@end

@implementation Good__IntegralViewController

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
    _payTypeArray = [NSMutableArray new];
    [self interFace];
    [self addNav];
    [self addScrollView];
    
    [self addMoneyView];
//    [self NetWorkConfigPaySwitch];
//    [self NetWorkAccountAllocation];
//    [self NetWorkCredit];
    [self NetWorkUserCreditConfig];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _payTypeStr = @"1";
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    
    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 30, 40, 20)];
    [detailButton setTitle:@"明细" forState:UIControlStateNormal];
    detailButton.titleLabel.font = Font(16);
    [detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(detailButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:detailButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"积分";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        detailButton.frame = CGRectMake(MainScreenWidth - 50, 40, 40, 20);
    }
    
}

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 49 * WideEachUnit - 64)];
    if (iPhoneX) {
        _scrollView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 83 - 88);
    }
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight - 49 * WideEachUnit - 50);
}

#pragma mark --- 界面添加

- (void)addMoneyView {
    _moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 98 * WideEachUnit)];
    _moneyView.backgroundColor = BasidColor;
    [_scrollView addSubview:_moneyView];
    
    //添加余额
    UILabel *balanceLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit, 25 * WideEachUnit , 200 * WideEachUnit, 30 * WideEachUnit)];
    balanceLabel.text = @"200";
    [balanceLabel setTextColor:[UIColor whiteColor]];
    balanceLabel.font = [UIFont systemFontOfSize:24 * WideEachUnit];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [_moneyView addSubview:balanceLabel];
    _scoreLabel = balanceLabel;
    
    //文字
    UILabel *balanceTitle = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit,60 * WideEachUnit , 200 * WideEachUnit, 15 * WideEachUnit)];
    balanceTitle.text = @"账户积分";
    [balanceTitle setTextColor:[UIColor groupTableViewBackgroundColor]];
    balanceTitle.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    balanceTitle.textAlignment = NSTextAlignmentCenter;
    [_moneyView addSubview:balanceTitle];
    
}

- (void)addRechargeView {
    _rechargeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_moneyView.frame), MainScreenWidth, 150 * WideEachUnit)];
    _rechargeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_rechargeView];
    
    
    //横线
    UILabel *line = [[UILabel  alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 10 * WideEachUnit , 3 * WideEachUnit, 10 * WideEachUnit)];
    line.backgroundColor = BasidColor;
    [_rechargeView addSubview:line];
    
    //名字
    UILabel *title = [[UILabel  alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 10 * WideEachUnit , 100 * WideEachUnit, 10 * WideEachUnit)];
    title.text = @"充积分";
    title.textColor = [UIColor blackColor];
    title.font = Font(12 * WideEachUnit);
    [_rechargeView addSubview:title];
    
    //添加充值界面
    
    //添加输入文本
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit, 40 * WideEachUnit, 200 * WideEachUnit, 30 * WideEachUnit)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = Font(20 * WideEachUnit);
    textField.text = @"";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor colorWithHexString:@"#888"];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    [_rechargeView addSubview:textField];
    _textField = textField;
    
    //添加分割线
    UILabel *lineButton = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit, 75 * WideEachUnit , 200 * WideEachUnit, 1 * WideEachUnit)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_rechargeView addSubview:lineButton];
    
    
    //添加备注
    UILabel *remark = [[UILabel  alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 90 * WideEachUnit ,MainScreenWidth - 40 * WideEachUnit, 15 * WideEachUnit)];
    remark.text = @"需要花费育币0";
    remark.textColor = [UIColor colorWithHexString:@"#888"];
    remark.textAlignment = NSTextAlignmentCenter;
    remark.font = Font(12 * WideEachUnit);
    [_rechargeView addSubview:remark];
    _remark = remark;
    
    
    //兑换计算
    UILabel *exchange = [[UILabel  alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 120 * WideEachUnit ,MainScreenWidth - 40 * WideEachUnit, 15 * WideEachUnit)];
    exchange.text = @"(注：1 育币 = 10积分)";
    exchange.textColor = [UIColor colorWithHexString:@"#888"];
//    exchange.textAlignment = NSTextAlignmentCenter;
    exchange.font = Font(12 * WideEachUnit);
    [_rechargeView addSubview:exchange];
    _exchange = exchange;
    if ([HASALIPAY isEqualToString:@"0"]) {
        _rechargeView.hidden = YES;
    } else {
        _rechargeView.hidden = NO;
    }
}
- (void)addAliPayView {
    
    if (_alipayView == nil) {
        _alipayView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_rechargeView.frame) + 10 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit)];
        _alipayView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_alipayView];
    }
    [_alipayView removeAllSubviews];
    //判断是否应该有此支付方式
    BOOL isAddAilpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"alipay"]) {
            isAddAilpayView = YES;
        }
    }
    
    if (isAddAilpayView) {//有支付宝
        
    } else {
        _alipayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_rechargeView.frame) + 10 * WideEachUnit, 0, 0 * WideEachUnit);
        _alipayView.hidden = YES;
    }
    
    CGFloat viewW = MainScreenWidth;
    CGFloat viewH = 50 * WideEachUnit;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * WideEachUnit , viewW, viewH)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0.5 * WideEachUnit;
    view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [_alipayView addSubview:view];
    
    
    UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
    alipayIcon.image = Image(@"aliPay");
    alipayIcon.centerY = 50 * HigtEachUnit / 2.0;
    [_alipayView addSubview:alipayIcon];
    UILabel *alipayLabel = [[UILabel alloc] initWithFrame:CGRectMake(alipayIcon.right + 12 * WideEachUnit, 0, 100, 50 * HigtEachUnit)];
    alipayLabel.textColor = RGBHex(0x1E2133);
    alipayLabel.font = Font(13);
    alipayLabel.text = @"支付宝支付";
    [_alipayView addSubview:alipayLabel];
    
    
    UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
    [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
    [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
    [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    seleButton.tag = 0;
    _ailpaySeleButton = seleButton;
    _ailpaySeleButton.selected = YES;
    [view addSubview:seleButton];
    
    UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    allClearButton.backgroundColor = [UIColor clearColor];
    allClearButton.tag = 0;
    [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:allClearButton];
    if ([HASALIPAY isEqualToString:@"0"]) {
        _alipayView.hidden = YES;
    } else {
        if (isAddAilpayView) {
            _alipayView.hidden = NO;
        } else {
            _alipayView.hidden = YES;
        }
    }
}

- (void)addWxPayView {
    if (_wxpayView == nil) {
        _wxpayView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit)];
        _wxpayView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_wxpayView];
    }
    [_wxpayView removeAllSubviews];
    
    //判断是否应该有此支付方式
    BOOL isAddWxpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"wxpay"]) {
            isAddWxpayView = YES;
        }
    }
    
    if (isAddWxpayView) {//有微信
        
    } else {
        _wxpayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), 0, 0 * WideEachUnit);
        _wxpayView.hidden = YES;
    }
    
    
    CGFloat viewW = MainScreenWidth;
    CGFloat viewH = 50 * WideEachUnit;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * WideEachUnit , viewW, viewH)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0.5 * WideEachUnit;
    view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [_wxpayView addSubview:view];
    
    UIImageView *weixinIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
    weixinIcon.image = Image(@"wxPay");
    weixinIcon.centerY = 50 * HigtEachUnit / 2.0;
    [_wxpayView addSubview:weixinIcon];
    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(weixinIcon.right + 12 * WideEachUnit, 0, 100, 50 * HigtEachUnit)];
    weixinLabel.textColor = RGBHex(0x1E2133);
    weixinLabel.font = Font(13);
    weixinLabel.text = @"微信支付";
    [_wxpayView addSubview:weixinLabel];
    
    
    UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
    [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
    [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
    [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    seleButton.tag = 1;
    _wxSeleButton = seleButton;
    _wxSeleButton.selected = NO;
    
    if (_alipayView.frame.size.height == 0) {//说明没有支付宝支付
        [self seleButtonCilck:seleButton];
    }
    
    [view addSubview:seleButton];
    
    UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    allClearButton.backgroundColor = [UIColor clearColor];
    allClearButton.tag = 1;
    [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:allClearButton];
    
    if ([HASALIPAY isEqualToString:@"0"]) {
        _wxpayView.hidden = YES;
    } else {
        if (isAddWxpayView) {
            _wxpayView.hidden = NO;
        } else {
            _wxpayView.hidden = YES;
        }
    }
}

- (void)addPayView {
    
    _payView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_wxpayView.frame) + 0.5, MainScreenWidth, 100 * WideEachUnit)];
    _payView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_payView];
    
    
    //添加线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 36 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit, 1 * WideEachUnit)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_payView addSubview:line];
    
    BOOL hasSpipay = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"spipay"]) {
            hasSpipay = YES;
        }
    }
    
    BOOL hasBalancePay = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"lcnpay"]) {
            hasBalancePay = YES;
        }
    }
    
    if (hasSpipay && hasBalancePay) {
        [_payView setHeight:100 * WideEachUnit];
    } else {
        if (hasSpipay || hasBalancePay) {
            [_payView setHeight:50 * WideEachUnit];
        } else {
            [_payView setHeight:0 * WideEachUnit];
        }
    }
    
    CGFloat viewW = MainScreenWidth;
    CGFloat viewH = 50 * WideEachUnit;
    
    NSArray *titleArray = @[@"育币",@"收入"];
    NSArray *iconArray = @[@"money",@"income"];
    NSArray *informationArray = @[@"(当前育币0)",@"(当前账户提成为育币0)"];
    CGFloat topY = 0;
    for (int i = 0 ; i < 2 ; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, topY, viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 0.5 * WideEachUnit;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [_payView addSubview:view];
        //icon
        UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
        alipayIcon.image = Image(iconArray[i]);
        alipayIcon.centerY = viewH / 2.0;
        [view addSubview:alipayIcon];
        //类型
        UILabel *typeLabel = [[UILabel  alloc] initWithFrame:CGRectMake(alipayIcon.right + 5, 0 ,40 * WideEachUnit, 50 * WideEachUnit)];
        if (i == 0) {
            typeLabel.frame = CGRectMake(alipayIcon.right + 5, 0, 40 * WideEachUnit, 50 * WideEachUnit);
        } else if (i == 1) {
            //            NSString *str = informationArray[1];
            typeLabel.frame = CGRectMake(alipayIcon.right + 5, 0, (40) * WideEachUnit, 50 * WideEachUnit);
        }
        typeLabel.text = titleArray[i];
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.font = Font(16 * WideEachUnit);
        [view addSubview:typeLabel];
        
        //添加类型的信息
        UILabel *informationLabel = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeLabel.frame), 0 ,MainScreenWidth - typeLabel.right - 40 * WideEachUnit, 50 * WideEachUnit)];
        informationLabel.text = informationArray[i];
        informationLabel.textColor = [UIColor colorWithHexString:@"#888"];
        informationLabel.font = Font(13 * WideEachUnit);
        [view addSubview:informationLabel];
        if (i == 0) {
            _balanceseInformationLabel = informationLabel;
        } else if (i == 1) {
            _splitInformationLabel = informationLabel;
        }
        
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = i + 2;
        if (i == 0) {//支付宝
            _balanceSeleButton = seleButton;
            if (_alipayView.height == 0 && _wxpayView.height == 0 && hasBalancePay) {
                _balanceSeleButton.selected = YES;
                [self seleButtonCilck:_balanceSeleButton];
            } else {
                _balanceSeleButton.selected = NO;
            }
        } else {//微信
            _bankSeleButton = seleButton;
            if (_alipayView.height == 0 && _wxpayView.height == 0 && !hasBalancePay && hasSpipay) {
                _bankSeleButton.selected = YES;
                [self seleButtonCilck:_bankSeleButton];
            } else {
                _bankSeleButton.selected = NO;
            }
        }
        [view addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = i + 2;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allClearButton];
        if (i == 0) {
            if (!hasBalancePay) {
                [view setHeight:0];
                view.hidden = YES;
            }
        } else if (i == 1) {
            if (!hasSpipay) {
                [view setHeight:0];
                view.hidden = YES;
            }
        }
        topY = view.height;
    }
    if ([HASALIPAY isEqualToString:@"0"]) {
        _payView.hidden = YES;
    } else {
        _payView.hidden = NO;
    }
}


- (void)addAgreeView {
    _agreeView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_payView.frame) + 10 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit, 44 * WideEachUnit)];
    _agreeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_agreeView];
    
    CGFloat labelWidth = [@"我已阅读并同意" sizeWithFont:Font(14 * WideEachUnit)].width + 4;
    CGFloat agreeButtonWidth = labelWidth + 10*2 + 16;
    
    UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, agreeButtonWidth, 44 * WideEachUnit)];
    [agreeButton setImage:Image(@"choose@3x") forState:UIControlStateSelected];
    [agreeButton setImage:Image(@"unchoose_s@3x") forState:UIControlStateNormal];
    [agreeButton setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    agreeButton.titleLabel.font = Font(14 * WideEachUnit);
    agreeButton.imageEdgeInsets =  UIEdgeInsetsMake(0,10 * WideEachUnit,0,agreeButtonWidth - 30);
    agreeButton.selected = YES;
    _agreeButton = agreeButton;
    [agreeButton addTarget:self action:@selector(agreeButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    //    agreeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30 * WideEachUnit, 0, 0 * WideEachUnit);
    
    [agreeButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
    [_agreeView addSubview:agreeButton];
    
    //条约按钮
    CGFloat buttonWidth = [[NSString stringWithFormat:@"《%@解锁协议》",AppName] sizeWithFont:Font(14 * WideEachUnit)].width + 4;
    UIButton *pactButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(agreeButton.frame) + 10 + 7 + labelWidth, 0, buttonWidth, 44 * WideEachUnit)];
    [pactButton setTitle:[NSString stringWithFormat:@"《%@解锁协议》",AppName] forState:UIControlStateNormal];
    pactButton.titleLabel.font = Font(14 * WideEachUnit);
    [pactButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [pactButton addTarget:self action:@selector(pactButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_agreeView addSubview:pactButton];
    if ([HASALIPAY isEqualToString:@"0"]) {
        _agreeView.hidden = YES;
    } else {
        _agreeView.hidden = NO;
    }
}


- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 49 * WideEachUnit, MainScreenWidth, 49 * WideEachUnit)];
    if (iPhoneX) {
        _downView.frame = CGRectMake(0, MainScreenHeight - 83, MainScreenWidth, 83);
    }
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    
    //实际付钱
    UILabel *realTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 105 * WideEachUnit, 49 * WideEachUnit)];
    realTitle.text = @"实付";
    realTitle.font = Font(14 * WideEachUnit);
    realTitle.textColor = [UIColor colorWithHexString:@"#888"];
    realTitle.textAlignment = NSTextAlignmentRight;
    [_downView addSubview:realTitle];
    
    //实际钱
    UILabel *realMoney = [[UILabel alloc] initWithFrame:CGRectMake(115 * WideEachUnit, 0, 90 * WideEachUnit, 49 * WideEachUnit)];
    //    realMoney.text = [NSString stringWithFormat:@"育币%@",[_dict stringValueForKey:@"t_price"]];
    realMoney.text = @"育币0";
    realMoney.font = Font(16 * WideEachUnit);
    realMoney.textColor = [UIColor colorWithHexString:@"#fc0203"];
    [_downView addSubview:realMoney];
    _realMoney = realMoney;
    
    
    //添加提交订单按钮
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 170 * WideEachUnit, 0, 170 * WideEachUnit, 49 * WideEachUnit)];
    [_submitButton setTitle:@"确认支付" forState:UIControlStateNormal];
    _submitButton.backgroundColor = BasidColor;
    [_submitButton addTarget:self action:@selector(submitButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:_submitButton];
    if ([HASALIPAY isEqualToString:@"0"]) {
        _downView.hidden = YES;
    } else {
        _downView.hidden = NO;
    }
}

#pragma mark --- 通知
- (void)textChange:(NSNotification *)not {
    NSLog(@"%@",_textField);
    if (_textField.text.length > 8) {
        [TKProgressHUD showError:@"积分数量不能过大" toView:self.view];
        _textField.text = [_textField.text substringToIndex:8];
        return;
    } else if (_textField.text.length == 0) {
        _textField.text = @"";
        _remark.text = [NSString stringWithFormat:@"需要花费0个育币"];
        _realMoney.text = @"育币 0";
        return;
    } else {
        NSString *textStr = [_textField.text substringFromIndex:0];
        CGFloat hh = [textStr floatValue] / [_sple_score_str integerValue];
        _remark.text = [NSString stringWithFormat:@"需要花费%.2f 育币",hh];
        _realMoney.text = [NSString stringWithFormat:@"%.2f 育币",hh];
    }
}

#pragma mark --- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _textField) {
        if ([string isEqualToString:@"\n"]) {
            [textField resignFirstResponder];
            return NO;
        } else {
            return [self validateNumber:string];
        }
    } else {
        return YES;
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark --- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailButtonCilck {
    Good_IntegralParticularsViewController *vc = [[Good_IntegralParticularsViewController alloc] init];
    vc.typeStr = @"3";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)seleButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//支付宝
        _ailpaySeleButton.selected = YES;
        _wxSeleButton.selected = NO;
        _balanceSeleButton.selected = NO;
        _bankSeleButton.selected = NO;
        _payTypeStr = @"1";
    } else if (button.tag == 1) {//微信
        _ailpaySeleButton.selected = NO;
        _wxSeleButton.selected = YES;
        _balanceSeleButton.selected = NO;
        _bankSeleButton.selected = NO;
        _payTypeStr = @"2";
    } else if (button.tag == 2) {
        _ailpaySeleButton.selected = NO;
        _wxSeleButton.selected = NO;
        _balanceSeleButton.selected = YES;
        _bankSeleButton.selected = NO;
        _payTypeStr = @"3";
    } else if (button.tag == 3) {
        _ailpaySeleButton.selected = NO;
        _wxSeleButton.selected = NO;
        _balanceSeleButton.selected = NO;
        _bankSeleButton.selected = YES;
        _payTypeStr = @"4";
    }
}

- (void)agreeButtonCilck {
    if (_agreeButton.selected == YES) {
        _submitButton.enabled = NO;
        _submitButton.backgroundColor = [UIColor colorWithHexString:@"#a5c3eb"];
    } else {
        _submitButton.enabled = YES;
        _submitButton.backgroundColor = BasidColor;
    }
    _agreeButton.selected = !_agreeButton.selected;

}

- (void)submitButtonCilck {
    if (_textField.text.length == 0) {
        [TKProgressHUD showError:@"请输入兑换积分的个数" toView:self.view];
        return;
    }
    [self isSurePay];
}

- (void)pactButtonCilck {
    BuyAgreementViewController *vc = [[BuyAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//是否 真要支付
- (void)isSurePay {
    
    NSString *moneyStr = [_realMoney.text substringFromIndex:1];
    NSString *messageStr = [NSString stringWithFormat:@"确定要花费%@兑换%@积分？",_realMoney.text,_textField.text];
    

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16 * WideEachUnit]
                  range:NSMakeRange(0, messageStr.length)];
    [alertController setValue:hogan forKey:@"attributedMessage"];
    
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self NetWorkRechargeScore];
        [self NetWorkUserRechargeScore];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark --- 网络请求
//获取积分配置
- (void)NetWorkUserCreditConfig {
    
    NSString *endUrlStr = YunKeTang_User_user_creditConfig;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"10" forKey:@"count"];
    NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dataSource stringValueForKey:@"code"] integerValue] == 1) {
            dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _scoreDict = [dataSource dictionaryValueForKey:@"credit_info"];
            NSArray *array = [dataSource arrayValueForKey:@"pay_type"];
            [_payTypeArray removeAllObjects];
            for (NSDictionary *dict in array) {
                [_payTypeArray addObject:[dict stringValueForKey:@"pay_num"]];
            }
            _scoreLabel.text = [_scoreDict stringValueForKey:@"score"];
            if ([_payTypeArray containsObject:@"alipay"]) {
                if ([HASALIPAY isEqualToString:@"0"]) {
                    return;
                } else {
                    [self addRechargeView];
                    [self addAliPayView];
                    [self addWxPayView];
                    [self addPayView];
                    [self addAgreeView];
                    [self addDownView];
                }
            } else {
                return;
            }
            
            NSString *Str = [dataSource stringValueForKey:@"pay_note" defaultValue:@""];
            _componentsArray = [Str componentsSeparatedByString:@" "];
            if (_componentsArray.count >= 2) {
                _sple_score_str = [NSString stringWithFormat:@"%@",_componentsArray[1]];
                NSArray *array = [_sple_score_str componentsSeparatedByString:@"："];
                _sple_score_str = array[1];
                _exchange.text = [NSString stringWithFormat:@"(注:%@育币=%@积分)",@"1",_componentsArray[1]];
                _exchange.text = [dataSource stringValueForKey:@"pay_note"];
            }
            
            for (int i = 0 ; i < array.count ; i ++) {
                NSDictionary *dict = [array objectAtIndex:i];
                if ([[dict stringValueForKey:@"pay_num"] isEqualToString:@"lcnpay"]) {//余额支付
                    _balanceseInformationLabel.text = [NSString stringWithFormat:@"(当前育币%@)",[dict stringValueForKey:@"balance" defaultValue:@"0"]];
                } else if ([[dict stringValueForKey:@"pay_num"] isEqualToString:@"spipay"]) {
                    _splitInformationLabel.text = [NSString stringWithFormat:@"(当前育币%@)",[dict stringValueForKey:@"balance" defaultValue:@"0"]];
                }
            }
            
        } else {
            [TKProgressHUD showError:[dataSource stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//积分兑换
- (void)NetWorkUserRechargeScore{
    
    NSString *endUrlStr = YunKeTang_User_user_rechargeScore;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([_payTypeStr integerValue] == 3) {//余额兑换积分
        [mutabDict setObject:@"lcnpay" forKey:@"type"];
    } else if ([_payTypeStr integerValue] == 4) {//收入兑换成积分
        [mutabDict setObject:@"spipay" forKey:@"type"];
    } else if ([_payTypeStr integerValue] == 1) {//收入兑换成积分
        [mutabDict setObject:@"alipay" forKey:@"type"];
    } else if ([_payTypeStr integerValue] == 2) {//收入兑换成积分
        [mutabDict setObject:@"wxpay" forKey:@"type"];
    }
    if (_textField.text.length == 0) {
        [TKProgressHUD showError:@"请输入兑换积分的个数" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_textField.text  forKey:@"exchange_score"];
    }
    
    NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dataSource stringValueForKey:@"code"] integerValue] == 1) {
            if ([_payTypeStr isEqualToString:@"1"]) {
                [self addWebView:[[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject] dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"]];
                return;
            } else if ([_payTypeStr isEqualToString:@"2"]) {
                [self WXPay:[[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject] dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"]];
                return;
            }
            [TKProgressHUD showError:[dataSource stringValueForKey:@"msg"] toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backPressed];
            });
        } else {
            [TKProgressHUD showError:[dataSource stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

#pragma mark ---- 支付界面
- (void)addWebView:(NSString *)aliString {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    
    url = [NSURL URLWithString:aliString];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    if ([url containsString:@"alipay://alipayclient"]) {
        NSMutableString *param = [NSMutableString stringWithFormat:@"%@", (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)url, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))];
        
        NSRange range = [param rangeOfString:@"{"];
        // 截取 json 部分
        NSString *param1 = [param substringFromIndex:range.location];
        if ([param1 rangeOfString:@"\"fromAppUrlScheme\":"].length > 0) {
            NSData *data = [param1 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (![tempDic isKindOfClass:[NSDictionary class]]) {
                return NO;
            }
            
            NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:tempDic];
            dicM[@"fromAppUrlScheme"] = AlipayBundleId;
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicM options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSString *encodedString = (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,                           (CFStringRef)jsonStr, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
            
            // 只替换 json 部分
            [param replaceCharactersInRange:NSMakeRange(range.location, param.length - range.location)  withString:encodedString];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:param]];
            
            return NO;
        }
    }
    return NO;
}

//微信支付
- (void)WXPay:(NSDictionary *)dict {
    NSString * timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSLog(@"=====%@",timeString);
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [dict stringValueForKey:@"partnerid"];
    request.prepayId= [dict stringValueForKey:@"prepayid"];
    request.package = [dict stringValueForKey:@"package"];
    request.nonceStr= [dict stringValueForKey:@"noncestr"];
    request.timeStamp= timeString.intValue;
    request.timeStamp= [dict stringValueForKey:@"timestamp"].intValue;
    request.sign= [dict stringValueForKey:@"sign"];
    [WXApi sendReq:request];
    
}

/**
- (void)NetWorkConfigPaySwitch {
    
    NSString *endUrlStr = YunKeTang_config_paySwitch;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 0) {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        } else if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        }
        _payTypeArray = [dict arrayValueForKey:@"pay"];
        [self addAliPayView];
        [self addWxPayView];
        [self addPayView];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}
*/
@end
