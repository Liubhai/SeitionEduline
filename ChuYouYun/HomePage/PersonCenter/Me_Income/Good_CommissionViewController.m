//
//  CommissionViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/10/17.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_CommissionViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "Good_BoundCardViewController.h"
#import "Good_IntegralParticularsViewController.h"
#import "Good_AddBankViewController.h"
#import "Good_AliBoundViewController.h"
#import "BuyAgreementViewController.h"
#import "UMSocial.h"

@interface Good_CommissionViewController ()<UITextFieldDelegate,UIScrollViewDelegate>  {
    NSInteger bankSeleNumber;//银行卡选中的位置
}

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)UIView   *moneyView;
@property (strong ,nonatomic)UIView   *rechargeView;
@property (strong ,nonatomic)UIView   *payTypeView;
@property (strong ,nonatomic)UIView   *payView;
@property (strong ,nonatomic)UIView   *banlancepayView;
@property (strong ,nonatomic)UIView   *alipayView;
@property (strong ,nonatomic)UIView    *wxpayView;
@property (strong ,nonatomic)UIView   *bankpayView;

@property (strong ,nonatomic)UIView   *agreeView;
@property (strong ,nonatomic)UIView   *downView;

@property (strong ,nonatomic)UILabel  *commissionLabel;
@property (strong ,nonatomic)UITextField *textField;
@property (strong ,nonatomic)UIButton  *balanceSeleButton;
@property (strong ,nonatomic)UIButton  *bankSeleButton;
@property (strong ,nonatomic)UIButton  *ailpaySeleButton;
@property (strong ,nonatomic)UIButton  *wxSeleButton;
@property (strong ,nonatomic)UIButton  *submitButton;
@property (strong ,nonatomic)UIButton  *agreeButton;
@property (strong ,nonatomic)UIButton  *myBankSeleButton;
@property (strong ,nonatomic)UIButton  *allCommissionButton;
@property (strong ,nonatomic)UILabel   *allCommissionLabel;
@property (strong ,nonatomic)UILabel   *bankLabel;
@property (strong ,nonatomic)UILabel   *remainLabel;

@property (strong ,nonatomic)UILabel   *balanceseInformationLabel;
@property (strong ,nonatomic)UILabel   *bankInformationLabel;
@property (strong ,nonatomic)UILabel   *realMoney;

@property (strong ,nonatomic)NSString  *payTypeStr;
@property (strong ,nonatomic)NSDictionary *commissionDict;
@property (strong ,nonatomic)NSMutableArray      *payTypeArray;
@property (strong ,nonatomic)NSArray             *cardListArray;

//添加银行卡
@property (strong ,nonatomic)UIView    *allView;
@property (strong ,nonatomic)UIButton  *allButton;
@property (strong ,nonatomic)UIView    *bankView;

//记录顺序
@property (assign ,nonatomic)int  bankNumber;
@property (assign ,nonatomic)int  aliNumber;
@property (assign ,nonatomic)int  balanNumber;

//记录选中的银行卡
@property (strong ,nonatomic)NSDictionary   *seleBankDict;//记录选中银行卡的信息


@end

@implementation Good_CommissionViewController


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
    [self addScrollView];
    
    [self addMoneyView];
//    [self addRechargeView];
//    [self addPayTypeView];
//    [self addPayView];
//    [self addAgreeView];
//    [self addDownView];
//    [self NetWorkAccountInfo];
    [self netWorkUserSpiltConfig];
//    [self NetWorkConfigPaySwitch];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _payTypeStr = @"0";
    _payTypeArray = [NSMutableArray array];
    
    _bankNumber = 100;
    _aliNumber = 100;
    _balanNumber = 100;
    
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
    WZLabel.text = @"我的收入";
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
    balanceLabel.text = @"育币0";
    [balanceLabel setTextColor:[UIColor whiteColor]];
    balanceLabel.font = [UIFont systemFontOfSize:24 * WideEachUnit];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [_moneyView addSubview:balanceLabel];
    _commissionLabel = balanceLabel;
    
    //文字
    UILabel *balanceTitle = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit,60 * WideEachUnit , 200 * WideEachUnit, 15 * WideEachUnit)];
    balanceTitle.text = @"账户收入";
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
    UILabel *title = [[UILabel  alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 10 * WideEachUnit , 30 * WideEachUnit, 10 * WideEachUnit)];
    title.text = @"提现";
    title.textColor = [UIColor blackColor];
    title.font = Font(12 * WideEachUnit);
    [_rechargeView addSubview:title];
    
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
//    [_textField becomeFirstResponder];
//     _textField.inputView=[[UIView alloc]initWithFrame:CGRectZero];
    
    //添加育币字端
    UILabel *moneyTitle = [[UILabel  alloc] initWithFrame:CGRectMake(textField.left - 50, 40 * WideEachUnit , 50 * WideEachUnit, 30 * WideEachUnit)];
    moneyTitle.text = @"育币";
    moneyTitle.textAlignment = NSTextAlignmentRight;
    moneyTitle.textColor = [UIColor colorWithHexString:@"#888"];
    moneyTitle.font = Font(20 * WideEachUnit);
    [_rechargeView addSubview:moneyTitle];
    
    //添加分割线
    UILabel *lineButton = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit, 75 * WideEachUnit , 200 * WideEachUnit, 1 * WideEachUnit)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_rechargeView addSubview:lineButton];
    
    //添加备注
    _allCommissionLabel = [[UILabel  alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 90 * WideEachUnit ,MainScreenWidth - 40 * WideEachUnit, 15 * WideEachUnit)];
    _allCommissionLabel.text = @"当前已得收入为 0 育币，全部提现";
    _allCommissionLabel.textColor = [UIColor colorWithHexString:@"#888"];
    _allCommissionLabel.font = Font(12 * WideEachUnit);
    _allCommissionLabel.textAlignment = NSTextAlignmentCenter;
    [_rechargeView addSubview:_allCommissionLabel];
    _allCommissionLabel.userInteractionEnabled = YES;
    [_allCommissionLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allCommissionLabelClick:)]];
    if (SWNOTEmptyDictionary(_commissionDict)) {
        NSString *allCommissonStr = [NSString stringWithFormat:@"当前已得育币为%@，全部提现",[[_commissionDict dictionaryValueForKey:@"spilt_info"] stringValueForKey:@"balance" defaultValue:@"0"]];
        if ([_commissionDict dictionaryValueForKey:@"spilt_info"] == nil) {
            allCommissonStr = @"当前已得育币为0，全部提现";
        }
        
        NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:allCommissonStr];
        [noteStr1 addAttribute:NSForegroundColorAttributeName value:BasidColor range:NSMakeRange(noteStr1.length - 4, 4)];
        [_allCommissionLabel setAttributedText:noteStr1];
    }
    
    //添加提醒的文本
    _remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 120 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 20 * WideEachUnit )];
    _remainLabel.textColor = [UIColor colorWithHexString:@"#888"];
    _remainLabel.font = Font(12 * WideEachUnit);
    _remainLabel.hidden = YES;
    if (SWNOTEmptyDictionary(_commissionDict)) {
        _remainLabel.text = [NSString stringWithFormat:@"%@",[_commissionDict stringValueForKey:@"pay_note"]];
    }
    if ([_payTypeArray containsObject:@"alipay"]) {
        _remainLabel.hidden = NO;
    }
    [_rechargeView addSubview:_remainLabel];
}

- (void)addPayTypeView {
    _payTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_rechargeView.frame) + 10 * WideEachUnit, MainScreenWidth, 40 * WideEachUnit)];
    _payTypeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_payTypeView];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 5 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 30 * WideEachUnit)];
    typeLabel.text = @"提现方式";
    typeLabel.textColor = [UIColor colorWithHexString:@"#333"];
    typeLabel.font = Font(16);
    [_payTypeView addSubview:typeLabel];
    
    //添加线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 39 * WideEachUnit, MainScreenWidth, 1 * WideEachUnit)];
    lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_payTypeView addSubview:lineLabel];
}

- (void)addPayView {
    
    _payView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_rechargeView.frame) + 10 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit)];
    _payView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_payView];
    
    
    //添加线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 36 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit, 1 * WideEachUnit)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_payView addSubview:line];
    
    CGFloat viewW = MainScreenWidth;
    CGFloat viewH = 50 * WideEachUnit;
    
    NSArray *titleArray = @[@"余额",@"银行卡"];
    NSArray *iconArray = @[@"money",@"card"];
    NSArray *informationArray = @[@"(当前育币40)",@"(中国银行1204)"];
    
    for (int i = 0 ; i < 2 ; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * WideEachUnit + viewH * i, viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 0.5 * WideEachUnit;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [_payView addSubview:view];
        UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
        alipayIcon.image = Image(iconArray[i]);
        alipayIcon.centerY = 50 * HigtEachUnit / 2.0;
        [view addSubview:alipayIcon];
        //类型
        UILabel *typeLabel = [[UILabel  alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0 ,40 * WideEachUnit, 50 * WideEachUnit)];
        if (i == 0) {
            typeLabel.frame = CGRectMake(alipayIcon.right, 0, 40 * WideEachUnit, 50 * WideEachUnit);
        } else if (i == 1) {
//            NSString *str = informationArray[1];
            typeLabel.frame = CGRectMake(alipayIcon.right, 0, (60) * WideEachUnit, 50 * WideEachUnit);
        }
        typeLabel.text = titleArray[i];
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.font = Font(16 * WideEachUnit);
        [view addSubview:typeLabel];
        
        //添加类型的信息
        UILabel *informationLabel = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeLabel.frame), 0 ,MainScreenWidth - typeLabel.frame.size.width - 40 * WideEachUnit, 50 * WideEachUnit)];
        informationLabel.text = informationArray[i];
        informationLabel.textColor = [UIColor colorWithHexString:@"#888"];
        informationLabel.font = Font(13 * WideEachUnit);
        [view addSubview:informationLabel];
        if (i == 0) {
            _balanceseInformationLabel = informationLabel;
        } else if (i == 1) {
            _bankInformationLabel = informationLabel;
        }
        
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50 - 20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = i;
        if (i == 0) {//支付宝
            _balanceSeleButton = seleButton;
            _balanceSeleButton.selected = YES;
        } else {//微信
            _bankSeleButton = seleButton;
            _bankSeleButton.selected = NO;
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
    
    _alipayView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_rechargeView.frame) + 10 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit)];
    _alipayView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_alipayView];
    
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
        aliPayTitle.text = @"支付宝";
        aliPayTitle.textColor = [UIColor blackColor];
        aliPayTitle.font = Font(16 * WideEachUnit);
        CGFloat titleWidth = [aliPayTitle.text sizeWithFont:aliPayTitle.font].width + 4;
        aliPayTitle.frame = CGRectMake(alipayIcon.right + 5,0, titleWidth, 50 * WideEachUnit);
        [view addSubview:aliPayTitle];
        
        //添加备注
        UILabel *remainTitle = [[UILabel alloc] initWithFrame:CGRectMake(aliPayTitle.right,0, MainScreenWidth - 40 * WideEachUnit - aliPayTitle.right, 50 * WideEachUnit)];
        
        if (_aliNumber == 100) {
            
        } else {
            if ([[[[_commissionDict arrayValueForKey:@"pay_type"] objectAtIndex:_aliNumber] stringValueForKey:@"pay_type_note"] isEqualToString:@""]) {
                remainTitle.text = @"(去绑定)";
            } else {
                remainTitle.text = [NSString stringWithFormat:@"(%@)",[[[_commissionDict arrayValueForKey:@"pay_type"] objectAtIndex:_aliNumber] stringValueForKey:@"pay_type_note" defaultValue:@"去绑定"]];
            }
        }
        remainTitle.textColor = [UIColor colorWithHexString:@"#888"];
        remainTitle.font = Font(16 * WideEachUnit);
        [view addSubview:remainTitle];
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = 1;
        _ailpaySeleButton = seleButton;
        _ailpaySeleButton.selected = YES;
        [self seleButtonCilck:_ailpaySeleButton];
        [view addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = 1;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allClearButton];
    } else {
        _alipayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_rechargeView.frame) + 10 * WideEachUnit, 0, 0 * WideEachUnit);
    }
}

- (void)addWxPayView {
    _wxpayView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit)];
    _wxpayView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_wxpayView];
    
    //判断是否应该有此支付方式
    BOOL isAddWxpayView = NO;
    //暂时体现没有微信
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
        aliPayTitle.text = @"微信";
        aliPayTitle.textColor = [UIColor blackColor];
        aliPayTitle.font = Font(16 * WideEachUnit);
        CGFloat titleWidth = [aliPayTitle.text sizeWithFont:aliPayTitle.font].width + 4;
        aliPayTitle.frame = CGRectMake(alipayIcon.right + 5,0, titleWidth, 50 * WideEachUnit);
        [view addSubview:aliPayTitle];
        
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = 3;
        _wxSeleButton = seleButton;
        _wxSeleButton.selected = NO;
        if (_alipayView.frame.size.height == 0) {
            [self seleButtonCilck:seleButton];
        }
        [view addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = 3;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allClearButton];
    } else {
        _wxpayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), 0, 0 * WideEachUnit);
    }
}

- (void)addBalancePayView {
    
    _banlancepayView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_wxpayView.frame), MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit)];
    _banlancepayView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_banlancepayView];
    
    //判断是否应该有此支付方式
    BOOL isAddAilpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"lcnpay"]) {
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
        [_banlancepayView addSubview:view];
        
        UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
        alipayIcon.image = Image(@"money");
        alipayIcon.centerY = 50 * HigtEachUnit / 2.0;
        [view addSubview:alipayIcon];
        
        UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(alipayIcon.right + 5,0, 40 * WideEachUnit, 50 * WideEachUnit)];
        payTypeLabel.text = @"余额";
        payTypeLabel.textColor = [UIColor blackColor];
        payTypeLabel.font = Font(16 * WideEachUnit);
        [view addSubview:payTypeLabel];
        
        //添加备注
        UILabel *remainTitle = [[UILabel alloc] initWithFrame:CGRectMake(payTypeLabel.right,0, MainScreenWidth - payTypeLabel.right - 40 * WideEachUnit, 50 * WideEachUnit)];
        if (_balanNumber == 100) {
            
        } else {
            remainTitle.text = [NSString stringWithFormat:@"(当前育币%@)",[[[_commissionDict arrayValueForKey:@"pay_type"] objectAtIndex:_balanNumber] stringValueForKey:@"learn_balance"]];
            
        }
        
        remainTitle.textColor = [UIColor colorWithHexString:@"#888"];
        remainTitle.font = Font(16 * WideEachUnit);
        [view addSubview:remainTitle];
        
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = 0;
        _balanceSeleButton = seleButton;
        if (_wxpayView.frame.size.height == 0 && _alipayView.frame.size.height == 0) {
            [self seleButtonCilck:_balanceSeleButton];
        }
        [view addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = 0;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allClearButton];
    } else {
        _banlancepayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_wxpayView.frame) + 10 * WideEachUnit, 0, 0 * WideEachUnit);
    }
}

- (void)addBankPayView {
    _bankpayView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_banlancepayView.frame), MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit + 48 * WideEachUnit)];
    _bankpayView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bankpayView];
    
    //判断是否应该有此支付方式
    BOOL isAddWxpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"unionpay"]) {
            isAddWxpayView = YES;
        }
    }
    
    if (isAddWxpayView) {//有微信
        CGFloat viewW = MainScreenWidth;
        CGFloat viewH = 50 * WideEachUnit;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * WideEachUnit , viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        //    view.layer.borderWidth = 0.5 * WideEachUnit;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [_bankpayView addSubview:view];
        
        UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
        alipayIcon.image = Image(@"card");
        alipayIcon.centerY = 50 * HigtEachUnit / 2.0;
        [view addSubview:alipayIcon];
        
        UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(alipayIcon.right + 5,0, 50 * WideEachUnit, 50 * WideEachUnit)];
        payTypeLabel.text = @"银行卡";
        payTypeLabel.textColor = [UIColor blackColor];
        payTypeLabel.font = Font(16 * WideEachUnit);
        CGFloat titleWidth = [payTypeLabel.text sizeWithFont:payTypeLabel.font].width + 4;
        payTypeLabel.frame = CGRectMake(alipayIcon.right + 5,0, titleWidth, 50 * WideEachUnit);
        [view addSubview:payTypeLabel];
        
        //添加备注
        UILabel *remainTitle = [[UILabel alloc] initWithFrame:CGRectMake(payTypeLabel.right,0, MainScreenWidth - 40 * WideEachUnit - payTypeLabel.right, 50 * WideEachUnit)];
        
        if (_balanNumber == 100) {
            
        } else {
        }
        remainTitle.textColor = [UIColor colorWithHexString:@"#888"];
        remainTitle.font = Font(16 * WideEachUnit);
        [view addSubview:remainTitle];
        
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = 2;
        _bankSeleButton = seleButton;
        if (_banlancepayView.bounds.size.height == 0) {//说明支付宝也没有
            _bankSeleButton.selected = YES;
        } else {
            _bankSeleButton.selected = NO;
        }
        
        [view addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = 2;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allClearButton];
        
        UIView *bankLabelView = [[UIView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 50 * WideEachUnit, MainScreenWidth - 25 * WideEachUnit, 30)];
        bankLabelView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:bankLabelView];
        //    [bankLabelView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)]];
        
        //添加银行卡的信息
        UILabel *bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth / 2, 30 * WideEachUnit)];
        //    bankLabel.text = @"中国银行1024";
        NSLog(@"--%@",_cardListArray);
        if (_cardListArray.count == 0) {
            bankLabel.text = @"去绑定";
        } else {
            bankLabel.text = [[_cardListArray objectAtIndex:0] stringValueForKey:@"card_info"];
            _seleBankDict = [_cardListArray objectAtIndex:0];
        }
        
        bankLabel.font = Font(14 * WideEachUnit);
        bankLabel.textColor = [UIColor colorWithHexString:@"#888"];
        [bankLabelView addSubview:bankLabel];
        bankLabel.userInteractionEnabled = YES;
        _bankLabel = bankLabel;
        
        //添加肩头按钮
        UIButton *payTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 45 * WideEachUnit,0,20 * WideEachUnit, 30 * WideEachUnit)];
        payTypeButton.backgroundColor = [UIColor clearColor];
        [payTypeButton setImage:Image(@"ic_more@3x") forState:UIControlStateNormal];
        [bankLabelView addSubview:payTypeButton];
        payTypeButton.userInteractionEnabled = YES;
        
        //添加透明的按钮
        UIButton *bankClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50 * WideEachUnit, MainScreenWidth, 48 * WideEachUnit)];
        bankClearButton.backgroundColor = [UIColor clearColor];
        bankClearButton.tag = 100;
        [bankClearButton addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bankpayView addSubview:bankClearButton];
    } else {
        _bankpayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_banlancepayView.frame), 0, 0 * WideEachUnit);
    }

}


- (void)addAgreeView {
    _agreeView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_bankpayView.frame) + 10 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit, 44 * WideEachUnit)];
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
    
    
//    //备注
//    UILabel *remark = [[UILabel  alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 55 * WideEachUnit ,MainScreenWidth - 40 * WideEachUnit, 15 * WideEachUnit)];
//    remark.text = @"注：充50送10，充满100送50，满200送100";
//    remark.textColor = [UIColor colorWithHexString:@"#888"];
//    remark.font = Font(12 * WideEachUnit);
//    [_agreeView addSubview:remark];
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
    realTitle.text = @"提现";
    realTitle.font = Font(14 * WideEachUnit);
    realTitle.textColor = [UIColor colorWithHexString:@"#888"];
    realTitle.textAlignment = NSTextAlignmentRight;
    [_downView addSubview:realTitle];
    
    //实际钱
    UILabel *realMoney = [[UILabel alloc] initWithFrame:CGRectMake(115 * WideEachUnit, 0, 90 * WideEachUnit, 49 * WideEachUnit)];
    //    realMoney.text = [NSString stringWithFormat:@"育币%@",[_dict stringValueForKey:@"t_price"]];
    realMoney.text = @"育币 0";
    realMoney.font = Font(16 * WideEachUnit);
    realMoney.textColor = [UIColor colorWithHexString:@"#fc0203"];
    [_downView addSubview:realMoney];
    _realMoney = realMoney;
    
    
    //添加提交订单按钮
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 170 * WideEachUnit, 0, 170 * WideEachUnit, 49 * WideEachUnit)];
    [_submitButton setTitle:@"提现" forState:UIControlStateNormal];
    _submitButton.backgroundColor = BasidColor;
    [_submitButton addTarget:self action:@selector(submitButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:_submitButton];
    
}

#pragma mark --- UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    _textField.inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
//    [_textField resignFirstResponder];
//    [_textField becomeFirstResponder];
}

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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}



#pragma mark --- 通知
- (void)textChange:(NSNotification *)not {
    NSLog(@"%@",_textField);
    if (_textField.text.length > 6) {
        [TKProgressHUD showError:@"提现金额不能过大" toView:self.view];
        _textField.text = [_textField.text substringToIndex:6];
        return;
    }
    
    _realMoney.text = [NSString stringWithFormat:@"育币 %@",_textField.text];
    
}


#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailButtonCilck {
    Good_IntegralParticularsViewController *vc = [[Good_IntegralParticularsViewController alloc] init];
    vc.typeStr = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)allCommissionButtonCilck {
    NSInteger allCommiss = [[[_commissionDict dictionaryValueForKey:@"spilt_info"] stringValueForKey:@"balance"] integerValue];
    _textField.text = [NSString stringWithFormat:@"%ld",allCommiss];
    _realMoney.text = [NSString stringWithFormat:@"育币 %ld",allCommiss];
}

- (void)seleButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//余额
        _balanceSeleButton.selected = YES;
        _bankSeleButton.selected = NO;
        _ailpaySeleButton.selected = NO;
        _wxSeleButton.selected = NO;
        _payTypeStr = @"0";
        
        if (_balanNumber != 100) {//说明有余额这个支付方式
            
        } else if (_balanNumber == 100){//没有这个方式
            
        }
    } else if (button.tag == 1) {//支付宝
        _balanceSeleButton.selected = NO;
        _bankSeleButton.selected = NO;
        _ailpaySeleButton.selected = YES;
        _wxSeleButton.selected = NO;
        _payTypeStr = @"1";
    } else if (button.tag == 2) {//银行卡
        if ([_bankInformationLabel.text isEqualToString:@"(未绑定)"]) {
            _balanceSeleButton.selected = YES;
            _bankSeleButton.selected = NO;
            _payTypeStr = @"2";
            [TKProgressHUD showError:@"暂不支持提现到银行卡" toView:self.view];
            return;
        } else {
            _balanceSeleButton.selected = NO;
            _ailpaySeleButton.selected = NO;
            _bankSeleButton.selected = YES;
            _wxSeleButton.selected = NO;
            _payTypeStr = @"2";
        }
    } else if (button.tag == 3) {
        /// 微信提现
        _balanceSeleButton.selected = NO;
        _ailpaySeleButton.selected = NO;
        _bankSeleButton.selected = NO;
        _wxSeleButton.selected = YES;
        _payTypeStr = @"3";
    }
}

- (void)goToBoundCard {
    Good_BoundCardViewController *vc = [[Good_BoundCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
        [TKProgressHUD showError:@"请输入要提现的金额" toView:self.view];
        return;
    }
    [self isSurePay];
    
}

- (void)bankSeleButtonCilck:(UIButton *)button {
    _myBankSeleButton.selected = NO;
    button.selected = YES;
    _myBankSeleButton = button;
    bankSeleNumber = button.tag;
    
    _seleBankDict = [_cardListArray objectAtIndex:button.tag];
    _bankLabel.text = [_seleBankDict stringValueForKey:@"card_info"];
    
    //让银行卡选中
    _balanceSeleButton.selected = NO;
    _ailpaySeleButton.selected = NO;
    _bankSeleButton.selected = YES;
    _wxSeleButton.selected = NO;
    _payTypeStr = @"2";
    
    [self miss];
    
}

- (void)addBankButtonCilck:(UIButton *)button {
    Good_AddBankViewController *vc = [[Good_AddBankViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pactButtonCilck {
    BuyAgreementViewController *vc = [[BuyAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 手势

- (void)allCommissionLabelClick:(UITapGestureRecognizer *)tap {
    
    NSInteger allCommiss = [[[_commissionDict dictionaryValueForKey:@"spilt_info"] stringValueForKey:@"balance"] integerValue];
    _textField.text = [NSString stringWithFormat:@"%ld",allCommiss];
    _realMoney.text = [NSString stringWithFormat:@"育币 %ld",allCommiss];
}

- (void)viewClick:(UIButton *)tap {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];
    
    
    
    _bankView = [[UIView alloc] init];
    _bankView.frame = CGRectMake(0, 0, 250 * WideEachUnit, 88 * WideEachUnit + 44 * WideEachUnit * _cardListArray.count);
    _bankView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _bankView.layer.cornerRadius = 5 * WideEachUnit;
    _bankView.center = self.view.center;
    [_allView addSubview:_bankView];
    
    //添加选择银行卡
    UILabel *addBankTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250 * WideEachUnit, 44 * WideEachUnit)];
    addBankTitle.text = @"请选择银行卡";
    addBankTitle.font = Font(14 * WideEachUnit);
    addBankTitle.textColor = [UIColor colorWithHexString:@"#333"];
    addBankTitle.textAlignment = NSTextAlignmentCenter;
    [_bankView addSubview:addBankTitle];
    
    //添加按钮
    UIButton *addBankButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _bankView.bounds.size.height - 44 * WideEachUnit,250 * WideEachUnit , 44 * WideEachUnit)];
    [addBankButton setTitle:@" 添加新卡" forState:UIControlStateNormal];
    [addBankButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
    addBankButton.titleLabel.font = Font(14 * WideEachUnit);
    [addBankButton setImage:Image(@"bank_add@3x") forState:UIControlStateNormal];
    [addBankButton addTarget:self action:@selector(addBankButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_bankView addSubview:addBankButton];
    
        
    //在view上面添加东西
    for (int i = 0 ; i < _cardListArray.count ; i ++) {
        UILabel *bankTitle = [[UILabel alloc ] initWithFrame:CGRectMake(10 * WideEachUnit, 44 * WideEachUnit * (1 + i), 230 * WideEachUnit, 44 * WideEachUnit)];
        bankTitle.textColor = [UIColor colorWithHexString:@"#888"];
        bankTitle.font = [UIFont systemFontOfSize:14];
        bankTitle.text = [[_cardListArray objectAtIndex:i] stringValueForKey:@"card_info"];
        [_bankView addSubview:bankTitle];
        bankTitle.userInteractionEnabled = YES;
        
        //添加按钮
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(bankSeleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = i;
        if (bankSeleNumber == i) {
            seleButton.selected = YES;
        }
        [bankTitle addSubview:seleButton];
        
        //添加透明的按钮
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 30 * WideEachUnit, 250 * WideEachUnit)];
//        [clearButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
//        [clearButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [clearButton addTarget:self action:@selector(bankSeleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        clearButton.tag = i;
        [bankTitle addSubview:clearButton];
        
        
    }
    
    //添加中间的分割线
    for (int i = 0; i < _cardListArray.count + 2; i ++) {
        UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * WideEachUnit * i , 250 * WideEachUnit, 1 * WideEachUnit)];
        XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_bankView addSubview:XButton];
    }
}

- (void)removeMoreView {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _bankView.center = self.view.center;
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_bankView removeFromSuperview];
        
    });
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
//        _bankView.frame = CGRectMake(0, 0, 250 * WideEachUnit, 176 * WideEachUnit);
        _bankView.center = self.view.center;
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_bankView removeFromSuperview];
        
    });
    
    
    
    
}

- (void)SYGButton:(UIButton *)button {
    
    _balanceSeleButton.selected = NO;
    _ailpaySeleButton.selected = NO;
    _bankSeleButton.selected = YES;
    _payTypeStr = @"2";
    
    
    
}



//是否 真要支付
- (void)isSurePay {
    
    NSString *messageStr = [NSString stringWithFormat:@"确定要兑换%@育币到余额？",_textField.text];
    if ([_payTypeStr integerValue] == 1) {//余额
        if ([[[[_commissionDict arrayValueForKey:@"pay_type"] objectAtIndex:_aliNumber] stringValueForKey:@"pay_type_note"] isEqualToString:@""]) {
            Good_AliBoundViewController *vc = [[Good_AliBoundViewController alloc] init];
            vc.formCommission = @"commisson";
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        messageStr = [NSString stringWithFormat:@"确定要兑换%@元到支付宝？",_textField.text];
    } else if ([_payTypeStr integerValue] == 2) {
        if (_cardListArray.count == 0) {//说明没有绑定银行卡
            Good_AddBankViewController *vc = [[Good_AddBankViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        messageStr = [NSString stringWithFormat:@"确定要兑换%@元到银行卡？",_textField.text];
    } else if ([_payTypeStr integerValue] == 0) {
        messageStr = [NSString stringWithFormat:@"确定要兑换%@育币到余额？",_textField.text];
    } else if ([_payTypeStr integerValue] == 3) {
        messageStr = [NSString stringWithFormat:@"确定要兑换%@元到微信？",_textField.text];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16 * WideEachUnit]
                  range:NSMakeRange(0, messageStr.length)];
    [alertController setValue:hogan forKey:@"attributedMessage"];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if ([_payTypeStr isEqualToString:@"3"]) {
            [self WeChat];
        } else {
            [self NetWorkUserApplyWithdraw:nil weixinOpenId:nil];
        }
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark --- 网络请求
//获取收入各种数据
- (void)netWorkUserSpiltConfig {//收入
    
    NSString *endUrlStr = YunKeTang_User_user_spiltConfig;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1"forKey:@"tab"];
    [mutabDict setObject:@"50"forKey:@"limit"];
    
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
        _commissionDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        
        
        _remainLabel.text = [_commissionDict stringValueForKey:@"pay_note"];
        _commissionLabel.text = [NSString stringWithFormat:@"育币%@",[[_commissionDict dictionaryValueForKey:@"spilt_info"] stringValueForKey:@"balance" defaultValue:@"0"]];
        if ([_commissionDict dictionaryValueForKey:@"spilt_info"] == nil ) {
            _commissionLabel.text = @"0";
        }
        _balanceseInformationLabel.text = [NSString stringWithFormat:@"(当前育币%@)",[_commissionDict stringValueForKey:@"learn" defaultValue:@"0"]];
        _bankInformationLabel.text = [NSString stringWithFormat:@"(%@)",[_commissionDict stringValueForKey:@"card_info" defaultValue:@"未绑定"]];
        if ([[_commissionDict stringValueForKey:@"card_info"] isEqualToString:@""]) {//未绑定
            _bankInformationLabel.text = @"(未绑定)";
        }
        
        NSString *allCommissonStr = [NSString stringWithFormat:@"当前已得育币为%@，全部提现",[[_commissionDict dictionaryValueForKey:@"spilt_info"] stringValueForKey:@"balance" defaultValue:@"0"]];
        if ([_commissionDict dictionaryValueForKey:@"spilt_info"] == nil) {
            allCommissonStr = @"当前已得育币为0，全部提现";
        }
        
        NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:allCommissonStr];
        [noteStr1 addAttribute:NSForegroundColorAttributeName value:BasidColor range:NSMakeRange(noteStr1.length - 4, 4)];
        [_allCommissionLabel setAttributedText:noteStr1];
        
        //添加支付类型
        
        NSArray *payArray = [_commissionDict arrayValueForKey:@"pay_type"];
        NSLog(@"%@",_payTypeArray);
        for (int i = 0; i < payArray.count ; i ++) {
            NSString *pay_num = [[payArray objectAtIndex:i] stringValueForKey:@"pay_num"];
            [_payTypeArray addObject:pay_num];
            
            if ([pay_num isEqualToString:@"unionpay"]) {//银行卡
                _cardListArray = [[payArray objectAtIndex:i] arrayValueForKey:@"card_list"];
                _bankNumber = i;
            } else if ([pay_num isEqualToString:@"alipay"]) {
                _aliNumber =  i;
            } else if ([pay_num isEqualToString:@"lcnpay"]) {
                _balanNumber = i;
            }
        }
        /// 这里优化处理  由于后台强制会有银行卡 这里根据是不是只有余额方式来显示
        if (![_payTypeArray containsObject:@"alipay"] && [_payTypeArray containsObject:@"unionpay"]) {
            [_payTypeArray removeObject:@"unionpay"];
        }
        if ([_payTypeArray containsObject:@"alipay"]) {
            [self addRechargeView];
            [self addAliPayView];
            [self addWxPayView];
            [self addBalancePayView];
            [self addBankPayView];
            [self addAgreeView];
            [self addDownView];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//体现
- (void)NetWorkUserApplyWithdraw:(NSString *)weixinName weixinOpenId:(NSString *)open_id {
    
    NSString *endUrlStr = YunKeTang_User_user_applyWithdraw;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([_payTypeStr integerValue] == 1) {//余额兑换积分
        [mutabDict setObject:@"2" forKey:@"type"];
    } else if ([_payTypeStr integerValue] == 2) {//收入兑换成积分
    }
    if (_textField.text.length == 0) {
        [TKProgressHUD showError:@"请输入要提现的育币数量" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_textField.text forKey:@"exchange_balance"];
    }
    
    if ([_payTypeStr integerValue] == 0) {//余额
        [mutabDict setObject:@"lcnpay" forKey:@"type"];
    } else if ([_payTypeStr integerValue] == 1) {//支付宝
        [mutabDict setObject:@"alipay" forKey:@"type"];
    } else if ([_payTypeStr integerValue] == 2) {//银行卡
        [mutabDict setObject:@"unionpay" forKey:@"type"];
        [mutabDict setObject:[_seleBankDict stringValueForKey:@"id"] forKey:@"card_id"];
    } else if ([_payTypeStr integerValue] == 3) {//微信
        [mutabDict setObject:@"wxpay" forKey:@"type"];
        [mutabDict setObject:weixinName forKey:@"wx_nickname"];
        [mutabDict setObject:open_id forKey:@"wx_openid"];
    }

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
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backPressed];
            });
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            [self addBalancePayView];
            [self addAliPayView];
            [self addBankPayView];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

// MARK: - 先授权微信获取信息再请求提现接口
- (void)WeChat {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        NSLog(@"----%@",response);
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [self NetWorkUserApplyWithdraw:snsAccount.userName weixinOpenId:snsAccount.openId];
        }});
    
    
}





@end
