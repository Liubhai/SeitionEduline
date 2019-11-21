//
//  TestPayViewController.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/8/2.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "TestPayViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "BuyAgreementViewController.h"
#import "DLViewController.h"

@interface TestPayViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) NSMutableArray *payTypeArray;
@property (strong, nonatomic) NSDictionary *balanceInfo;

@property (strong ,nonatomic)UIButton  *ailpaySeleButton;
@property (strong ,nonatomic)UIButton  *wxSeleButton;
@property (strong ,nonatomic)UIButton  *balanceButton;
@property (strong ,nonatomic)NSString  *payTypeStr;//用于区分支付类型

@property (strong ,nonatomic)UIView    *alipayView;
@property (strong ,nonatomic)UIView    *wxpayView;
@property (strong ,nonatomic)UIView    *balanceView;
@property (strong ,nonatomic)UIScrollView *mainScrollView;

/** 支付协议背景 */
@property (strong, nonatomic) UIView *agreementBackView;
@property (strong, nonatomic) UIView *agreementLine;
@property (strong, nonatomic) UIButton *agreeButton;
@property (strong, nonatomic) UIButton *agreeBackButton;
@property (strong, nonatomic) UILabel *agreeTitle;

@property (strong, nonatomic) UIButton *submitButton;

@end

@implementation TestPayViewController

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
    self.view.backgroundColor = RGBHex(0xEEEEEE);
    _payTypeStr = @"1";
    _payTypeArray = [NSMutableArray new];
    _titleLabel.text = @"支付订单";
    _titleImage.backgroundColor = BasidColor;
    [self netWorkUserBalanceConfig];
}

- (void)creatSubView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    line1.backgroundColor = RGBHex(0xEEEEEE);
    [_mainScrollView addSubview:line1];
    
    UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, line1.bottom, MainScreenWidth - 15, 35)];
    nameTitle.font = SYSTEMFONT(16);
    nameTitle.textColor = RGBHex(0x3C4654);
    nameTitle.text = @"商品名称";
    [_mainScrollView addSubview:nameTitle];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, nameTitle.bottom, MainScreenWidth, 1)];
    line2.backgroundColor = RGBHex(0xEEEEEE);
    [_mainScrollView addSubview:line2];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, line2.bottom, MainScreenWidth - 30, 54)];
    name.numberOfLines = 0;
    name.textColor = RGBHex(0x5A5A5A);
    name.font = SYSTEMFONT(14);
    name.text = [NSString stringWithFormat:@"%@",[_info objectForKey:@"exams_paper_title"]];
    [_mainScrollView addSubview:name];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, name.bottom, MainScreenWidth, 3)];
    line3.backgroundColor = RGBHex(0xEEEEEE);
    [_mainScrollView addSubview:line3];
    
    UILabel *payMoneyTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, line3.bottom, MainScreenWidth - 15 - 70, 44)];
    payMoneyTitle.textColor = RGBHex(0x3C4654);
    payMoneyTitle.font = SYSTEMFONT(16);
    payMoneyTitle.text = @"订单金额";
    [_mainScrollView addSubview:payMoneyTitle];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, payMoneyTitle.top, 100, 44)];
    moneyLabel.textColor = BasidColor;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = SYSTEMFONT(16);
    moneyLabel.text = [NSString stringWithFormat:@"%@",[_info objectForKey:@"price"]];
    [_mainScrollView addSubview:moneyLabel];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, payMoneyTitle.bottom, MainScreenWidth, 3)];
    line4.backgroundColor = RGBHex(0xEEEEEE);
    [_mainScrollView addSubview:line4];
    
    UILabel *payMethod = [[UILabel alloc] initWithFrame:CGRectMake(15, line4.bottom, MainScreenWidth - 30, 40)];
    payMethod.text = @"选择支付方式";
    payMethod.textColor = RGBHex(0x3C4654);
    payMethod.font = SYSTEMFONT(16);
    [_mainScrollView addSubview:payMethod];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, payMethod.bottom, MainScreenWidth, 1)];
    line5.backgroundColor = RGBHex(0xEEEEEE);
    [_mainScrollView addSubview:line5];
    
    [self addAliPayView:line5];
    [self addWxPayView];
    [self addBalanceView];
    
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, _balanceView.bottom, MainScreenWidth, 3)];
    line6.backgroundColor = RGBHex(0xEEEEEE);
    [_mainScrollView addSubview:line6];
    
    /// 解锁协议
    _agreementBackView = [[UIView alloc] initWithFrame:CGRectMake(0, line6.bottom, MainScreenWidth, 55 * HigtEachUnit)];
    _agreementBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_agreementBackView];
    _agreementLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0 * HigtEachUnit)];
    _agreementLine.backgroundColor = RGBHex(0xE5E5E5);
    [_agreementBackView addSubview:_agreementLine];
    _agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, _agreementLine.bottom + 20 *HigtEachUnit, 24 * WideEachUnit, 24 * HigtEachUnit)];
    [_agreementBackView addSubview:_agreeButton];
    [_agreeButton setImage:Image(@"unchoose_s@3x") forState:0];
    [_agreeButton setImage:Image(@"choose@3x") forState:UIControlStateSelected];
    _agreeButton.selected = YES;
    _agreeButton.centerX = _agreementBackView.height / 2.0;
    _agreeBackButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, _agreementLine.bottom + 15* HigtEachUnit, 30 * WideEachUnit, 30 *HigtEachUnit)];
    _agreeBackButton.backgroundColor = [UIColor clearColor];
    [_agreeBackButton addTarget:self action:@selector(agreeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _agreeBackButton.center = _agreeButton.center;
    [_agreementBackView addSubview:_agreeBackButton];
    _agreeTitle = [[UILabel alloc] initWithFrame:CGRectMake(_agreeButton.right + 3 * HigtEachUnit, _agreeButton.top, MainScreenWidth - _agreeButton.right - 3 * HigtEachUnit, 16)];
    _agreeTitle.text = @"我已阅读并同意《Eduline解锁协议》";
    _agreeTitle.textColor = RGBHex(0x8B8888);
    _agreeTitle.font = SYSTEMFONT(14);
    NSMutableAttributedString *mutal = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《Eduline解锁协议》"];
    [mutal addAttributes:@{NSForegroundColorAttributeName: BasidColor} range:NSMakeRange(7, _agreeTitle.text.length - 7)];
    _agreeTitle.attributedText = [[NSAttributedString alloc] initWithAttributedString:mutal];
    _agreeTitle.centerY = _agreeButton.centerY;
    [_agreementBackView addSubview:_agreeTitle];
    CGFloat labelWidth = [_agreeTitle.text sizeWithFont:_agreeTitle.font].width + 4;
    UIButton *agreeDetailVCButton = [[UIButton alloc] initWithFrame:CGRectMake(_agreeTitle.left + labelWidth / 2.0, 0, labelWidth / 2.0, 30)];
    agreeDetailVCButton.centerY = _agreeTitle.centerY;
    agreeDetailVCButton.backgroundColor = [UIColor clearColor];
    [agreeDetailVCButton addTarget:self action:@selector(goToAgreeDetailVC) forControlEvents:UIControlEventTouchUpInside];
    [_agreementBackView addSubview:agreeDetailVCButton];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(50, _agreementBackView.bottom + 36, MainScreenWidth - 100, 44 * HigtEachUnit)];
    _submitButton.backgroundColor = RGBHex(0x2069CF);
    [_submitButton setTitle:@"去支付" forState:0];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:0];
    [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = _submitButton.height / 2.0;
    [_mainScrollView addSubview:_submitButton];
    
    if (_submitButton.bottom > _mainScrollView.height) {
        _mainScrollView.contentSize = CGSizeMake(MainScreenWidth, _submitButton.bottom);
    } else {
        _mainScrollView.contentSize = CGSizeMake(MainScreenWidth, _mainScrollView.height);
    }
}

- (void)addAliPayView:(UIView *)upView {
    
    _alipayView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(upView.frame), MainScreenWidth - 30 * WideEachUnit, 51 * WideEachUnit)];
    _alipayView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_alipayView];
    
    //判断是否应该有此支付方式
    BOOL isAddAilpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"alipay"]) {
            isAddAilpayView = YES;
        }
    }
    
    if (isAddAilpayView) {//有支付宝
        
        CGFloat viewW = MainScreenWidth - 30 * WideEachUnit;
        CGFloat viewH = 51 * WideEachUnit;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * WideEachUnit , viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        [_alipayView addSubview:view];
        
        
        UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
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
        
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50 - 20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = 0;
        _ailpaySeleButton = seleButton;
        _ailpaySeleButton.selected = YES;
        [view addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH - 1 * HigtEachUnit)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = 0;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allClearButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth - 15, 1 * HigtEachUnit)];
        line.backgroundColor = RGBHex(0xEEEEEE);
        [view addSubview:line];
    } else {
        _alipayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(upView.frame), 0, 0 * WideEachUnit);
    }
}


- (void)addWxPayView {
    _wxpayView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), MainScreenWidth - 30 * WideEachUnit, 51 * WideEachUnit)];
    _wxpayView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_wxpayView];
    
    //判断是否应该有此支付方式
    BOOL isAddWxpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"wxpay"]) {
            isAddWxpayView = YES;
        }
    }
    
    if (isAddWxpayView) {//有微信
        
        CGFloat viewW = MainScreenWidth - 30 * WideEachUnit;
        CGFloat viewH = 51 * WideEachUnit;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * WideEachUnit , viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        [_wxpayView addSubview:view];
        
        
        UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
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
        if (_alipayView.frame.size.height == 0) {
            [self seleButtonCilck:seleButton];
        }
        [view addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH - 1 * HigtEachUnit)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = 1;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allClearButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth - 15, 1 * HigtEachUnit)];
        line.backgroundColor = RGBHex(0xEEEEEE);
        [view addSubview:line];
    } else {
        _wxpayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), 0, 0 * WideEachUnit);
    }
}

- (void)addBalanceView {
    _balanceView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_wxpayView.frame), MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit)];
    _balanceView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_balanceView];
    
    //判断是否应该有此支付方式
    BOOL isAddBanlancepayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"lcnpay"]) {
            isAddBanlancepayView = YES;
        }
    }
    
    if (isAddBanlancepayView) {
        
        UIImageView *alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
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
        UILabel *residue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 0,MainScreenWidth - title.right - 30 * WideEachUnit - 40 * WideEachUnit, 50 * WideEachUnit)];
        residue.font = Font(14 * WideEachUnit);
        residue.textColor = [UIColor colorWithHexString:@"#888"];
        residue.text = [NSString stringWithFormat:@"(%@)",[[_balanceInfo objectForKey:@"learncoin_info"] objectForKey:@"balance"]];
        [_balanceView addSubview:residue];
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30 * WideEachUnit - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = 2;
        [_balanceView addSubview:seleButton];
        _balanceButton = seleButton;
        if (_alipayView.frame.size.height == 0 && _wxpayView.frame.size.height == 0) {
            [self seleButtonCilck:seleButton];
        }
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = 2;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_balanceView addSubview:allClearButton];
    } else {
        _balanceView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_wxpayView.frame), 0, 0 * WideEachUnit);
    }
}

- (void)seleButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//支付宝
        _ailpaySeleButton.selected = YES;
        _wxSeleButton.selected = NO;
        _balanceButton.selected = NO;
        _payTypeStr = @"1";
    } else if (button.tag == 1) {//微信
        _ailpaySeleButton.selected = NO;
        _wxSeleButton.selected = YES;
        _balanceButton.selected = NO;
        _payTypeStr = @"2";
    } else if (button.tag == 2) {
        _ailpaySeleButton.selected = NO;
        _wxSeleButton.selected = NO;
        _balanceButton.selected = YES;
        _payTypeStr = @"3";
    }
}

//获取余额各种数据以及配置
- (void)netWorkUserBalanceConfig {
    
    NSString *endUrlStr = YunKeTang_User_user_balanceConfig;
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if (SWNOTEmptyDictionary([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject])) {
                [_payTypeArray addObjectsFromArray:(NSArray *)[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject] objectForKey:@"pay"]];
                _balanceInfo = [NSDictionary dictionaryWithDictionary:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
                [self creatSubView];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)agreeButtonClick {
    _agreeButton.selected = !_agreeButton.selected;
    if (_agreeButton.selected) {
        _submitButton.enabled = YES;
        _submitButton.backgroundColor = BasidColor;
    } else {
        _submitButton.enabled = NO;
        _submitButton.backgroundColor = [UIColor colorWithHexString:@"#a5c3eb"];
    }
}

- (void)goToAgreeDetailVC {
    BuyAgreementViewController *vc = [[BuyAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitButtonClick {
    // 先判断勾选了支付协议没有
    if (!_agreeButton.selected) {
        [TKProgressHUD showError:@"请先阅读并同意《eduline解锁协议》" toView:self.view];
        return;
    }
    [self netWorkGoodsBuyGoods];
}

//商品的解锁
- (void)netWorkGoodsBuyGoods {
    NSString *endUrlStr = BUYEXAMS;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_info stringValueForKey:@"exams_paper_id"] forKey:@"paper_id"];
    if ([_payTypeStr integerValue] == 1) {//支付宝
        [mutabDict setObject:@"alipay" forKey:@"pay"];
    } else if ([_payTypeStr integerValue] == 2) {//微信
        [mutabDict setObject:@"wxpay" forKey:@"pay"];
    } else if ([_payTypeStr integerValue] == 3) {//微信
        [mutabDict setObject:@"lcnpay" forKey:@"pay"];
    }
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_payTypeStr integerValue] == 1) {//支付宝
                [self addWebView:[NSString stringWithFormat:@"%@",[[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"]]];
            } else if ([_payTypeStr integerValue] == 2){//微信
                [self WXPay:[[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"]];
            } else if ([_payTypeStr integerValue] == 3) {
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                self.paySuccess([NSString stringWithFormat:@"%@",[_info stringValueForKey:@"exams_paper_id"]]);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

// MARK: - pay
- (void)addWebView:(NSString *)alipayStr {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:webView];

    [webView setUserInteractionEnabled:YES];//是否支持交互
    webView.delegate = self;
    [webView setOpaque:YES];//opaque是不透明的意思
    [webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    url = [NSURL URLWithString:alipayStr];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
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

// MARK: -  微信支付

- (void)WXPay:(NSDictionary *)dict {
    NSString * timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
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

@end
