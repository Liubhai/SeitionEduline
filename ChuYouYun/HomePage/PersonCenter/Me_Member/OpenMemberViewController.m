//
//  OpenMemberViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/10/18.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "OpenMemberViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "ZhiyiHTTPRequest.h"
#import "BuyAgreementViewController.h"


@interface OpenMemberViewController ()<UIWebViewDelegate> {
    UIButton *_seleButton;//记录会员等级按钮选中状态
    UIButton *_moneySeleButton;
    UIButton *_paySeleButton;
    NSInteger Number;
    NSString *_payTypeStr;
}

@property (strong ,nonatomic)UIView      *memberView;
@property (strong ,nonatomic)UILabel     *advantage;
@property (strong ,nonatomic)UIView      *moneyView;
@property (strong ,nonatomic)UIView      *alipayView;
@property (strong ,nonatomic)UIView      *wxpayView;
@property (strong ,nonatomic)UIView    *balanceView;
@property (strong ,nonatomic)UIView      *rechargeCardView;
@property (strong ,nonatomic)UIView      *payView;
@property (strong ,nonatomic)UIView      *agreeView;
@property (strong ,nonatomic)UILabel     *titleLabel;
@property (strong ,nonatomic)UILabel     *numberLabel;
@property (strong ,nonatomic)UILabel     *unitLabel;
@property (strong ,nonatomic)NSString    *monthOrYearStr;
@property (strong ,nonatomic)UIWebView   *webView;
@property (strong ,nonatomic)NSString    *alipayStr;
@property (strong ,nonatomic)NSDictionary *wxPayDict;

@property (strong ,nonatomic)UIButton  *ailpaySeleButton;
@property (strong ,nonatomic)UIButton  *wxSeleButton;
@property (strong ,nonatomic)UIButton  *balanceButton;
@property (strong ,nonatomic)UIButton  *monthButton;
@property (strong ,nonatomic)UIButton  *yearButton;
@property (strong ,nonatomic)UIButton  *agreeButton;

@property (strong ,nonatomic)UIView      *downView;
@property (strong ,nonatomic)UIButton    *submitButton;
@property (strong ,nonatomic)UILabel     *realMoney;


@property (strong ,nonatomic)NSArray     *advantageArray;
@property (strong ,nonatomic)NSArray     *payTypeArray;
@property (strong ,nonatomic)NSString    *currentVipID;
@property (strong ,nonatomic)NSString  *balbanStr;//余额的字符串
@property (assign ,nonatomic)NSInteger   currentVipNumber;//当前等级的位置
@property (assign ,nonatomic)NSInteger   currentTimeTypeNumber;//当前是月还是年

//@property (strong ,nonatomic)NSString    *
@property (strong ,nonatomic)NSDictionary *payDataSource;
@property (strong ,nonatomic)NSDictionary *rechargeVipDict;

@property (strong ,nonatomic)NSArray   *testArray;
@property (strong ,nonatomic)NSDictionary *testDict;
@property (strong ,nonatomic)UILabel   *residue;//剩余的钱
@property (strong ,nonatomic)NSDictionary *userBalanceDict;

@end

@implementation OpenMemberViewController

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
    [self addCurrentView];
    [self addMemberView];
    [self addMoneyView];
//    [self addPayView];
//    [self addDownView];
    [self NetWorkConfigPaySwitch];
    [self netWorkUserGetAccount];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _advantageArray = @[@"每月可免费学习多个收费课程，还有更多惊喜折扣",@"每月可免费学习多个收费课程，还有更多惊喜折扣",@"每月可免费学习多个收费课程，还有更多惊喜折扣",@"每月可免费学习多个收费课程，还有更多惊喜折扣",@"每月可免费学习多个收费课程，还有更多惊喜折扣",@"每月可免费学习多个收费课程，还有更多惊喜折扣"];
    Number = 1;
    _payTypeStr = @"1";//默认支付宝
    _currentVipNumber = 0;
    _currentTimeTypeNumber = 0;
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
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"会员充值";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
    
}

#pragma mark --- 添加界面
- (void)addCurrentView {
    UILabel *currentGrade = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 36 * WideEachUnit)];
    if (iPhoneX) {
        currentGrade.frame = CGRectMake(0, 88, MainScreenWidth, 36 * WideEachUnit);
    }
    currentGrade.text = @"    当前身份：非VIP会员";
    currentGrade.backgroundColor = [UIColor colorWithRed:47.f / 255 green:50.f / 255 blue:68.f / 255 alpha:1];
    currentGrade.textColor = [UIColor whiteColor];
    currentGrade.font = Font(12 * WideEachUnit);
    [self.view addSubview:currentGrade];
    
//    NSString *allStr = @"    当前身份：非VIP会员";
    NSString *allStr = [NSString stringWithFormat:@"    当前身份：%@",[_vipDict stringValueForKey:@"vip_type_txt"]];
    if ([[_vipDict stringValueForKey:@"vip_type"] integerValue] == 0) {
        allStr = [NSString stringWithFormat:@"    当前身份：非VIP会员"];
    } else {
        allStr = [NSString stringWithFormat:@"    当前身份：%@",[_vipDict stringValueForKey:@"vip_type_txt"]];
    }
    NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:allStr];
    [noteStr1 addAttribute:NSFontAttributeName value:Font(14 * WideEachUnit) range:NSMakeRange(9, allStr.length - 9)];
    [currentGrade setAttributedText:noteStr1];
    
}

- (void)addMemberView {
    _memberView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 36 * WideEachUnit, MainScreenWidth, 200 * WideEachUnit)];
    if (iPhoneX) {
        _memberView.frame = CGRectMake(0, 88 + 36 * WideEachUnit, MainScreenWidth, 200 * WideEachUnit);
    }
    _memberView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_memberView];
    
    //横线
    UILabel *line = [[UILabel  alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 10 * WideEachUnit , 3 * WideEachUnit, 15 * WideEachUnit)];
    line.backgroundColor = BasidColor;
    [_memberView addSubview:line];
    
    //名字
    UILabel *title = [[UILabel  alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 10 * WideEachUnit , 100 * WideEachUnit, 15 * WideEachUnit)];
    title.text = @"充会员";
    title.textColor = [UIColor blackColor];
    title.font = Font(14 * WideEachUnit);
    [_memberView addSubview:title];
    _titleLabel = title;
    if ([_openOrRenew isEqualToString:@"openOrRenew"]) {//说明是充值或者是续费
        _titleLabel.text = @"会员续费";
        if ([_upgradeStr integerValue] == 1) {//续费
             _titleLabel.text = @"会员续费";
        } else {
             _titleLabel.text = @"会员升级";
        }
    }
    
    
    CGFloat buttonW = 100 * WideEachUnit;
    CGFloat buttonH = 20 * WideEachUnit;
    CGFloat buttonWSpace = 22.5 * WideEachUnit;
    CGFloat buttonHSpace = 20 * WideEachUnit;
    
    
    for (int i = 0 ; i < _vipArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit + (buttonW + buttonWSpace) * (i % 3), 40 * WideEachUnit + (buttonH + buttonHSpace) * (i / 3), buttonW, buttonH)];
        [button setTitle:[[_vipArray objectAtIndex:i] stringValueForKey:@"title"] forState:UIControlStateNormal];
        [button setImage:Image(@"unchoose_s@3x") forState:UIControlStateNormal];
        [button setImage:Image(@"choose@3x") forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,0 * WideEachUnit,0,30 * WideEachUnit);
        button.tag = i;
        [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_memberView addSubview:button];
        if (i == _currentSeleVip) {
            [self buttonCilck:button];
        }
    }
    
    //添加不同等级会员的好处
    UILabel *advantage = [[UILabel  alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 40 * WideEachUnit + (buttonH + buttonHSpace) * (_vipArray.count / 3) , MainScreenWidth -  30 * WideEachUnit, 15 * WideEachUnit)];
    if (_vipArray.count % 3 == 0) {
        advantage.frame = CGRectMake(15 * WideEachUnit, 40 * WideEachUnit + (buttonH + buttonHSpace) * (_vipArray.count / 3) , MainScreenWidth - 30 * WideEachUnit, 15 * WideEachUnit);
    } else {
        advantage.frame = CGRectMake(15 * WideEachUnit, 40 * WideEachUnit + (buttonH + buttonHSpace) * (_vipArray.count / 3 + 1) , MainScreenWidth - 30 * WideEachUnit, 15 * WideEachUnit);
    }
    advantage.text = @"每月可免费学习多个收费课程，还有更多惊喜折扣";
    advantage.textColor = [UIColor colorWithHexString:@"#656565"];
    advantage.font = Font(12 * WideEachUnit);
    [_memberView addSubview:advantage];
    _advantage = advantage;
    
    _memberView.frame = CGRectMake(0, 64 + 36 * WideEachUnit, MainScreenWidth, CGRectGetMaxY(advantage.frame) + 20 * WideEachUnit);
    if (iPhoneX) {
        _memberView.frame = CGRectMake(0, 88 + 36 * WideEachUnit, MainScreenWidth, CGRectGetMaxY(advantage.frame) + 20 * WideEachUnit);
    }
}

- (void)addMoneyView {
    
    _moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_memberView.frame) + 10 * WideEachUnit, MainScreenWidth, 150 * WideEachUnit)];
    _moneyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_moneyView];
    
    
    NSString *monthStr = [NSString stringWithFormat:@"育币%@／月",[[_vipMoneyArray objectAtIndex:_currentSeleVip] stringValueForKey:@"vip_month"]];
    NSString *yearStr = [NSString stringWithFormat:@"育币%@／年",[[_vipMoneyArray objectAtIndex:_currentSeleVip] stringValueForKey:@"vip_year"]];
    
    NSArray *titleArray = @[monthStr,yearStr];
    CGFloat buttonW = 165 * WideEachUnit;
    CGFloat buttonH = 60 * WideEachUnit;
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit + (buttonW + 15 * WideEachUnit) * (i % 2), 12 * WideEachUnit, buttonW, buttonH)];
        button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        button.layer.borderWidth = 1 * WideEachUnit;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(moneyButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_moneyView addSubview:button];
        if (i == 0) {
            _monthButton = button;
            [self moneyButtonCilck:button];
        } else if (i == 1) {
            _yearButton = button;
        }
        
    }
    
    //添加数量
    UILabel *countLabel = [[UILabel  alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 100 * WideEachUnit , 45 * WideEachUnit, 15 * WideEachUnit)];
    countLabel.text = @"数量：";
    countLabel.textColor = [UIColor colorWithHexString:@"#888"];
    countLabel.font = Font(14 * WideEachUnit);
    [_moneyView addSubview:countLabel];
    
    //添加加减按钮
    UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(60 * WideEachUnit, 92.5 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit)];
    minusButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    minusButton.layer.borderWidth = 1 * WideEachUnit;
    minusButton.titleLabel.font = [UIFont systemFontOfSize:30 * WideEachUnit weight:UIFontWeightThin];
    [minusButton setTitle:@"-" forState:UIControlStateNormal];
    [minusButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
    [_moneyView addSubview:minusButton];
    minusButton.tag = 0;
    [minusButton addTarget:self action:@selector(addButtonOrMinusButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    minusButton.titleEdgeInsets =  UIEdgeInsetsMake(-3 * WideEachUnit,0,0,0);
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(140 * WideEachUnit, 92.5 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit)];
    addButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    addButton.layer.borderWidth = 1 * WideEachUnit;
    addButton.titleLabel.font = [UIFont systemFontOfSize:30 * WideEachUnit weight:UIFontWeightThin];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
    [_moneyView addSubview:addButton];
    addButton.tag = 1;
    [addButton addTarget:self action:@selector(addButtonOrMinusButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    addButton.titleEdgeInsets =  UIEdgeInsetsMake(-3 * WideEachUnit,0,0,0);
    
    //添加显示数量的文本
    UILabel *numberLabel = [[UILabel  alloc] initWithFrame:CGRectMake(90 * WideEachUnit, 92.5 * WideEachUnit , 50 * WideEachUnit, 30 * WideEachUnit)];
    numberLabel.text = @"1";
    numberLabel.textColor = [UIColor colorWithHexString:@"#888"];
    numberLabel.font = Font(18 * WideEachUnit);
    numberLabel.layer.borderWidth = 1;
    numberLabel.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [_moneyView addSubview:numberLabel];
    _numberLabel = numberLabel;
    
    //显示是单位
    UILabel *unitLabel = [[UILabel  alloc] initWithFrame:CGRectMake(180 * WideEachUnit, 92.5 * WideEachUnit , 50 * WideEachUnit, 30 * WideEachUnit)];
    unitLabel.text = @"月";
    unitLabel.textColor = [UIColor colorWithHexString:@"#888"];
    unitLabel.font = Font(12 * WideEachUnit);
    [_moneyView addSubview:unitLabel];
    _unitLabel = unitLabel;
    
}

- (void)addPayView {
    
    _payView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_moneyView.frame) + 10 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit)];
    _payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_payView];
    
    
    //添加线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 36 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit, 1 * WideEachUnit)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_payView addSubview:line];
    
    CGFloat viewW = MainScreenWidth;
    CGFloat viewH = 50 * WideEachUnit;
    
    NSArray *imageArray = @[@"Alipay@3x",@"weixinpay@3x"];
    
    for (int i = 0 ; i < 2 ; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * WideEachUnit + viewH * i, viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 0.5 * WideEachUnit;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [_payView addSubview:view];
        
        
        UIButton *payTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit,0, 80 * WideEachUnit, 50 * WideEachUnit)];
        [payTypeButton setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        [view addSubview:payTypeButton];
        
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = i;
        if (i == 0) {//支付宝
            _ailpaySeleButton = seleButton;
            _ailpaySeleButton.selected = YES;
        } else {//微信
            _wxSeleButton = seleButton;
            _wxSeleButton.selected = NO;
        }
        [view addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = i;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allClearButton];
        
    }
}


- (void)addAliPayView {
    
    _alipayView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_moneyView.frame) + 10 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit)];
    _alipayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_alipayView];
    
    //判断是否应该有此支付方式
    BOOL isAddAilpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"alipay"]) {
            isAddAilpayView = YES;
        }
    }
    
    if (isAddAilpayView) {//有支付宝
        
        CGFloat viewW = MainScreenWidth;
        CGFloat viewH = 50 * WideEachUnit;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * WideEachUnit , viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 0.5 * WideEachUnit;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [_alipayView addSubview:view];
        
        UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
        alipayIcon.image = Image(@"aliPay");
        alipayIcon.centerY = 50 * HigtEachUnit / 2.0;
        [view addSubview:alipayIcon];
        
        UILabel *aliPayTitle = [[UILabel alloc] initWithFrame:CGRectMake(alipayIcon.right + 5,0, 60 * WideEachUnit, 50 * WideEachUnit)];
        aliPayTitle.text = @"支付宝支付";
        aliPayTitle.textColor = [UIColor blackColor];
        aliPayTitle.font = Font(16 * WideEachUnit);
        CGFloat titleWidth = [aliPayTitle.text sizeWithFont:aliPayTitle.font].width + 4;
        aliPayTitle.frame = CGRectMake(alipayIcon.right + 5,0, titleWidth, 50 * WideEachUnit);
        [view addSubview:aliPayTitle];
        
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

    } else {
        _alipayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_moneyView.frame) + 10 * WideEachUnit, 0, 0 * WideEachUnit);
    }
    
}


- (void)addWxPayView {
    _wxpayView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit)];
    _wxpayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_wxpayView];
    
    //判断是否应该有此支付方式
    BOOL isAddWxpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"wxpay"]) {
            isAddWxpayView = YES;
        }
    }
    
    if (isAddWxpayView) {//有微信
        
        CGFloat viewW = MainScreenWidth;
        CGFloat viewH = 50 * WideEachUnit;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * WideEachUnit , viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 0.5 * WideEachUnit;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [_wxpayView addSubview:view];
        
        
        UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
        alipayIcon.image = Image(@"wxPay");
        alipayIcon.centerY = 50 * HigtEachUnit / 2.0;
        [view addSubview:alipayIcon];
        
        UILabel *aliPayTitle = [[UILabel alloc] initWithFrame:CGRectMake(alipayIcon.right + 5,0, 60 * WideEachUnit, 50 * WideEachUnit)];
        aliPayTitle.text = @"微信支付";
        aliPayTitle.textColor = [UIColor blackColor];
        aliPayTitle.font = Font(16 * WideEachUnit);
        CGFloat titleWidth = [aliPayTitle.text sizeWithFont:aliPayTitle.font].width + 4;
        aliPayTitle.frame = CGRectMake(alipayIcon.right + 5,0, titleWidth, 50 * WideEachUnit);
        [view addSubview:aliPayTitle];
        
        
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
        
    } else {
        _wxpayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), 0, 0 * WideEachUnit);
    }

}

- (void)addBalanceView {
    _balanceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_wxpayView.frame), MainScreenWidth, 50 * WideEachUnit)];
    _balanceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_balanceView];
    
    //判断是否应该有此支付方式
    BOOL isAddBanlancepayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"lcnpay"]) {
            isAddBanlancepayView = YES;
        }
    }
    
    BOOL isHaveBanlance = NO;
    for (int i = 0 ; i < _testArray.count ; i ++) {
        NSDictionary *dict = [_testArray objectAtIndex:i];
        if ([[dict stringValueForKey:@"pay_num"] isEqualToString:@"lcnpay"]) {
            isHaveBanlance = YES;
            _testDict = dict;
        }
    }
    
    
    if (isAddBanlancepayView) {
        
        UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
        alipayIcon.image = Image(@"money");
        alipayIcon.centerY = 50 * HigtEachUnit / 2.0;
        [_balanceView addSubview:alipayIcon];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(alipayIcon.right + 5, 0,60 * WideEachUnit, 50 * WideEachUnit)];
        title.text = @"育币支付";
        title.font = Font(16 * WideEachUnit);
        title.textColor = [UIColor colorWithHexString:@"#333"];
        CGFloat titleWidth = [title.text sizeWithFont:title.font].width + 4;
        [title setWidth:titleWidth];
        [_balanceView addSubview:title];
        
        //剩余的钱
        UILabel *residue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 0,MainScreenWidth - title.right - 0 * WideEachUnit - 40 * WideEachUnit, 50 * WideEachUnit)];
        //        residue.text = @"100";
        residue.font = Font(14 * WideEachUnit);
        residue.textColor = [UIColor colorWithHexString:@"#888"];
        [_balanceView addSubview:residue];
        _residue = residue;
        _residue.text = [NSString stringWithFormat:@"(当前育币%@)",[_userBalanceDict stringValueForKey:@"learn" defaultValue:@"0"]];
        if (isHaveBanlance) {//说明是余额
            residue.text = [NSString stringWithFormat:@"(%@)",[_testDict stringValueForKey:@"pay_type_note"]];
        }
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 0 * WideEachUnit - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = 2;
        [_balanceView addSubview:seleButton];
        _balanceButton = seleButton;
        if (_alipayView.frame.size.height == 0 && _wxpayView.frame.size.height == 0) {
            [self seleButtonCilck:seleButton];
        }
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = 2;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_balanceView addSubview:allClearButton];
        
    } else {
        _balanceView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_wxpayView.frame), 0, 0 * WideEachUnit);
    }
    
}

- (void)addAgreeView {
    _agreeView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_balanceView.frame) + 10 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit, 44 * WideEachUnit)];
    _agreeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_agreeView];
    
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
}


- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 49 * WideEachUnit, MainScreenWidth, 49 * WideEachUnit)];
    if (iPhoneX) {
        _downView.frame = CGRectMake(0, MainScreenHeight - 83, MainScreenHeight, 83);
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
    realMoney.text = [NSString stringWithFormat:@"育币%@",[[_vipMoneyArray objectAtIndex:_currentSeleVip] stringValueForKey:@"vip_month"]];
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

}


#pragma mark --- 添加支付网络视图
- (void)addWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate = self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    url = [NSURL URLWithString:_alipayStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

#pragma mark --- 微信支付

- (void)WXPay:(NSDictionary *)dict {
    NSString * timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSLog(@"=====%@",timeString);
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [_wxPayDict stringValueForKey:@"partnerid"];
    request.prepayId= [_wxPayDict stringValueForKey:@"prepayid"];
    request.package = [_wxPayDict stringValueForKey:@"package"];
    request.nonceStr= [_wxPayDict stringValueForKey:@"noncestr"];
    request.timeStamp= timeString.intValue;
    request.timeStamp= [_wxPayDict stringValueForKey:@"timestamp"].intValue;
    request.sign= [_wxPayDict stringValueForKey:@"sign"];
    [WXApi sendReq:request];
    
}


#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonCilck:(UIButton *)button {
    _seleButton.selected = NO;
    button.selected = YES;
    _seleButton = button;
    
    if ([_openOrRenew isEqualToString:@"openOrRenew"]) {//充值或者是续费
        if (button.tag == 0) {//第一个（也就是当前会员等级的）
            if ([_upgradeStr integerValue] == 1) {
                 _titleLabel.text = @"会员续费";
            } else {
                 _titleLabel.text = @"会员升级";
            }
        } else {
            _titleLabel.text = @"会员升级";
        }
    }
    
    _currentVipNumber = button.tag;
    _currentVipID = [[_vipArray objectAtIndex:button.tag] stringValueForKey:@"id"];
    _advantage.text = _advantageArray[button.tag];
    
    NSLog(@"---%@",_currentVipID);
    
    
    NSString *monthStr = [NSString stringWithFormat:@"育币%@／月",[[_vipMoneyArray objectAtIndex:button.tag] stringValueForKey:@"vip_month"]];
    NSString *yearStr = [NSString stringWithFormat:@"育币%@／年",[[_vipMoneyArray objectAtIndex:button.tag] stringValueForKey:@"vip_year"]];
    [_monthButton setTitle:monthStr forState:UIControlStateNormal];
    [_yearButton setTitle:yearStr forState:UIControlStateNormal];
    
    //赋值
    if (_currentTimeTypeNumber == 0) {
        _monthOrYearStr = [NSString stringWithFormat:@"%@",[[_vipMoneyArray objectAtIndex:_currentVipNumber] stringValueForKey:@"vip_month"]];
    } else if (_currentTimeTypeNumber == 1) {
        _monthOrYearStr = [NSString stringWithFormat:@"%@",[[_vipMoneyArray objectAtIndex:_currentVipNumber] stringValueForKey:@"vip_year"]];
    }
    
    _realMoney.text = [NSString stringWithFormat:@"育币%ld",Number * ([_monthOrYearStr integerValue])];
    
}

- (void)moneyButtonCilck:(UIButton *)button {
    _moneySeleButton.selected = NO;
    _moneySeleButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    button.selected = YES;
    _moneySeleButton = button;
    button.layer.borderColor = [UIColor redColor].CGColor;
    _currentTimeTypeNumber = button.tag;
    
    if (button.tag == 0) {
        _unitLabel.text = @"月";
        _monthOrYearStr = [NSString stringWithFormat:@"%@",[[_vipMoneyArray objectAtIndex:_currentVipNumber] stringValueForKey:@"vip_month"]];
        
    } else {
        _unitLabel.text = @"年";
        _monthOrYearStr = [NSString stringWithFormat:@"%@",[[_vipMoneyArray objectAtIndex:_currentVipNumber] stringValueForKey:@"vip_year"]];
    }
    _realMoney.text = [NSString stringWithFormat:@"育币%ld",Number * ([_monthOrYearStr integerValue])];
    
}

- (void)addButtonOrMinusButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//减
        Number --;
        if (Number == 0) {
            Number = 1;
        }
        _numberLabel.text = [NSString stringWithFormat:@"%ld",Number];
    } else {//加
        Number ++;
        _numberLabel.text = [NSString stringWithFormat:@"%ld",Number];
    }
    
    _realMoney.text = [NSString stringWithFormat:@"育币%ld",Number * ([_monthOrYearStr integerValue])];

}

- (void)seleButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//支付宝
        _ailpaySeleButton.selected = YES;
        _wxSeleButton.selected = NO;
        _payTypeStr = @"1";
    } else if (button.tag == 1) {//微信
        _ailpaySeleButton.selected = NO;
        _wxSeleButton.selected = YES;
        _payTypeStr = @"2";
    } else if (button.tag == 2) {
        _ailpaySeleButton.selected = NO;
        _wxSeleButton.selected = NO;
        _balanceButton.selected = YES;
        _payTypeStr = @"3";
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

- (void)pactButtonCilck {
    BuyAgreementViewController *vc = [[BuyAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitButtonCilck {
    [self netWorkUserRechargeVip];
}

#pragma mark --- 网络请求
//会员充值
- (void)netWorkUserRechargeVip {
    
    NSString *endUrlStr = YunKeTang_User_user_rechargeVip;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([_payTypeStr integerValue] == 1) {//支付宝
        [mutabDict setObject:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {//微信
        [mutabDict setObject:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setObject:@"lcnpay" forKey:@"pay_for"];
    }
    
    [mutabDict setObject:_currentVipID forKey:@"user_vip"];//会员等级的id
    if (_currentTimeTypeNumber == 0) {//月
        [mutabDict setObject:@"month" forKey:@"vip_type_time"];//开通方式
    } else {//年
        [mutabDict setObject:@"year" forKey:@"vip_type_time"];//开通方式
    }
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",Number] forKey:@"vip_time"];//开通时长
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _rechargeVipDict = [dict dictionaryValueForKey:@"data"];
            } else {
                _rechargeVipDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        
        if ([_payTypeStr integerValue] == 1) {//支付宝
            _alipayStr = [[_rechargeVipDict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios" defaultValue:@""];
            [self addWebView];
        } else if ([_payTypeStr integerValue] == 2){
            _wxPayDict =  [[_rechargeVipDict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
            [self WXPay:_wxPayDict];
        } else if ([_payTypeStr integerValue] == 3) {
            [TKProgressHUD showError:[dict objectForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}


//获取充值的支付方式
//获取支付开关
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
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                 _payDataSource = [dict dictionaryValueForKey:@"data"];
            } else {
                 _payDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
            }
        }

        if ([[_payDataSource stringValueForKey:@"code"] integerValue] == 0) {
            [TKProgressHUD showError:[_payDataSource stringValueForKey:@"msg"] toView:self.view];
            return ;
        } else if ([[_payDataSource stringValueForKey:@"code"] integerValue] == 1) {
            _payDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        }
        _payTypeArray = [_payDataSource arrayValueForKey:@"pay"];
        [self addAliPayView];
        [self addWxPayView];
        [self addBalanceView];
        [self addAgreeView];
        [self addDownView];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//获取用户的流水数据
- (void)netWorkUserGetAccount {
    
    NSString *endUrlStr = YunKeTang_User_user_getAccount;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"new" forKey:@"time"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _userBalanceDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        _residue.text = [NSString stringWithFormat:@"(当前育币%@)",[_userBalanceDict stringValueForKey:@"learn" defaultValue:@"0"]];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


@end
