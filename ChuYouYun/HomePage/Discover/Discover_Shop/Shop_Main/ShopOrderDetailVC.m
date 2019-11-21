//
//  ShopOrderDetailVC.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/6/11.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "ShopOrderDetailVC.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ManageAddressViewController.h"
#import "DLViewController.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "BuyAgreementViewController.h"

@interface ShopOrderDetailVC ()<UIWebViewDelegate> {
    NSString  *_adress_id;
}
/** 0 是阿里支付 1 微信支付 2 积分支付 */
@property (strong, nonatomic) NSString *payMethodString;
/** 阿里支付所用信息 */
@property (strong, nonatomic) NSString *alipayStr;
/** 微信支付所用信息 */
@property (strong, nonatomic) NSDictionary *wxPayDict;
/** 阿里支付网页调起 */
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation ShopOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = @"确认订单";
    _titleImage.backgroundColor = RGBHex(0x2069CF);
    if (SWNOTEmptyDictionary(_originDict)) {
        [self makeSubView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)makeSubView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_SAFEAREA - 50 * HigtEachUnit)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainScrollView];

    // 商品信息视图
    _shopIntroBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 118 * HigtEachUnit)];
    _shopIntroBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_shopIntroBackView];
    
    _shopFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 10 * HigtEachUnit, 116 * WideEachUnit, 98 * HigtEachUnit)];
    [_shopFaceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_originDict objectForKey:@"cover"]]] placeholderImage:Image(@"站位图")];
    _shopFaceImageView.clipsToBounds = YES;
    _shopFaceImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_shopIntroBackView addSubview:_shopFaceImageView];
    
    _shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shopFaceImageView.right + 10 * WideEachUnit, _shopFaceImageView.top, MainScreenWidth - _shopFaceImageView.right - 10 - 33 * WideEachUnit, 14 * HigtEachUnit)];
    _shopNameLabel.textColor = RGBHex(0x282727);
    _shopNameLabel.font = Font(14);
    _shopNameLabel.numberOfLines = 2;
    _shopNameLabel.text = [NSString stringWithFormat:@"%@",[_originDict objectForKey:@"title"]];
    [_shopNameLabel sizeToFit];
    _shopNameLabel.frame = CGRectMake(_shopFaceImageView.right + 10 * WideEachUnit, _shopFaceImageView.top, MainScreenWidth - _shopFaceImageView.right - 10 - 33 * WideEachUnit, _shopNameLabel.size.height);
    [_shopIntroBackView addSubview:_shopNameLabel];
    
    _shopIntroLabel = [[UILabel alloc] initWithFrame:CGRectMake(_shopNameLabel.left, _shopNameLabel.bottom + 16 * HigtEachUnit, _shopNameLabel.size.width, 58 * HigtEachUnit)];
    _shopIntroLabel.textColor = RGBHex(0x8C8C8C);
    _shopIntroLabel.font = Font(10);
    _shopIntroLabel.numberOfLines = 0;
    _shopIntroLabel.text = [NSString stringWithFormat:@"%@",[_originDict objectForKey:@"info"]];
    CGFloat introHeight = [YunKeTang_Api_Tool heightForString:_shopIntroLabel.text fontSize:Font(10) andWidth:_shopIntroLabel.size.width];
    if (_shopIntroLabel.top + introHeight <= _shopFaceImageView.bottom) {
        _shopIntroLabel.frame = CGRectMake(_shopNameLabel.left, _shopNameLabel.bottom + 16 * HigtEachUnit, _shopNameLabel.size.width, introHeight);
    } else {
        _shopIntroLabel.frame = CGRectMake(_shopNameLabel.left, _shopNameLabel.bottom + 16 * HigtEachUnit, _shopNameLabel.size.width, _shopFaceImageView.bottom - _shopIntroLabel.top);
    }
    [_shopIntroBackView addSubview:_shopIntroLabel];

    // 支付方式视图
    _payMethodBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _shopIntroBackView.bottom, MainScreenWidth, 1)];
    [_mainScrollView addSubview:_payMethodBackView];
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 5 * HigtEachUnit)];
    _line1.backgroundColor = RGBHex(0xE5E5E5);
    [_payMethodBackView addSubview:_line1];
    _payTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, _line1.bottom, MainScreenWidth - 20 * WideEachUnit, 34 * HigtEachUnit)];
    _payTitleLabel.text = @"支付方式";
    _payTitleLabel.textColor = RGBHex(0x1E2133);
    _payTitleLabel.font = Font(14);
    [_payMethodBackView addSubview:_payTitleLabel];
    
    /// 支付宝
    _alipayBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _payTitleLabel.bottom, MainScreenWidth, _isHaveAilPay ? 43 * HigtEachUnit : 0)];
    _alipayBackView.hidden = !_isHaveAilPay;
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1 * HigtEachUnit)];
    _line2.backgroundColor = RGBHex(0xE5E5E5);
    [_alipayBackView addSubview:_line2];
    _alipayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
    _alipayIcon.image = Image(@"aliPay");
    _alipayIcon.centerY = 42 * HigtEachUnit / 2.0;
    [_alipayBackView addSubview:_alipayIcon];
    _alipayLabel = [[UILabel alloc] initWithFrame:CGRectMake(_alipayIcon.right + 12 * WideEachUnit, 0, 100, 42 * HigtEachUnit)];
    _alipayLabel.textColor = RGBHex(0x1E2133);
    _alipayLabel.font = Font(13);
    _alipayLabel.text = @"支付宝支付";
    [_alipayBackView addSubview:_alipayLabel];
    _alipayButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - (20+22)*WideEachUnit, 0, 20 * WideEachUnit, 20 * HigtEachUnit)];
    _alipayButton.centerY = 42 * HigtEachUnit / 2.0;
    [_alipayButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
    [_alipayButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
    [_alipayBackView addSubview:_alipayButton];
    _alipayBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 43 * HigtEachUnit)];
    _alipayBackButton.backgroundColor = [UIColor clearColor];
    [_alipayBackButton addTarget:self action:@selector(payMethodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_alipayBackView addSubview:_alipayBackButton];
    [_payMethodBackView addSubview:_alipayBackView];
    
    /// 微信支付
    _weixinBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _alipayBackView.bottom, MainScreenWidth, _isHaveWxPay ? 43 * HigtEachUnit : 0)];
    _weixinBackView.hidden = !_isHaveWxPay;
    _line3 = [[UIView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 0, MainScreenWidth - 40 * WideEachUnit, 1 * HigtEachUnit)];
    _line3.backgroundColor = RGBHex(0xE5E5E5);
    [_weixinBackView addSubview:_line3];
    _weixinIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
    _weixinIcon.image = Image(@"wxPay");
    _weixinIcon.centerY = 42 * HigtEachUnit / 2.0;
    [_weixinBackView addSubview:_weixinIcon];
    _weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(_weixinIcon.right + 12 * WideEachUnit, 0, 100, 42 * HigtEachUnit)];
    _weixinLabel.textColor = RGBHex(0x1E2133);
    _weixinLabel.font = Font(13);
    _weixinLabel.text = @"微信支付";
    [_weixinBackView addSubview:_weixinLabel];
    _weixinButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - (20+22)*WideEachUnit, 0, 20 * WideEachUnit, 20 * HigtEachUnit)];
    _weixinButton.centerY = 42 * HigtEachUnit / 2.0;
    [_weixinButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
    [_weixinButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
    [_weixinBackView addSubview:_weixinButton];
    _weixinBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 43 * HigtEachUnit)];
    _weixinBackButton.backgroundColor = [UIColor clearColor];
    [_weixinBackButton addTarget:self action:@selector(payMethodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_weixinBackView addSubview:_weixinBackButton];
    [_payMethodBackView addSubview:_weixinBackView];
    
    /// 积分支付
    _integralBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _weixinBackView.bottom, MainScreenWidth, [_scoreStaus integerValue] == 1 ? 43 * HigtEachUnit : 0)];
    _integralBackView.hidden = ![_scoreStaus boolValue];
    _line4 = [[UIView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 0, MainScreenWidth - 40 * WideEachUnit, 1 * HigtEachUnit)];
    _line4.backgroundColor = RGBHex(0xE5E5E5);
    [_integralBackView addSubview:_line4];
    _integralIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
    _integralIcon.image = Image(@"integral");
    _integralIcon.centerY = 42 * HigtEachUnit / 2.0;
    [_integralBackView addSubview:_integralIcon];
    _integralLabel = [[UILabel alloc] initWithFrame:CGRectMake(_integralIcon.right + 12 * WideEachUnit, 0, MainScreenWidth - _integralIcon.right - 12 * WideEachUnit - 44 * WideEachUnit, 42 * HigtEachUnit)];
    _integralLabel.textColor = RGBHex(0x1E2133);
    _integralLabel.font = Font(13);
    _integralLabel.text = @"积分支付";
    if (SWNOTEmptyDictionary(_userAccountDict)) {
        _integralLabel.text = [NSString stringWithFormat:@"积分支付(当前积分%@)",[_userAccountDict stringValueForKey:@"score" defaultValue:@"0"]];
        NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_integralLabel.text];
        [pass addAttributes:@{NSForegroundColorAttributeName: RGBHex(0x888888)} range:NSMakeRange(4, _integralLabel.text.length - 4)];
        _integralLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
    }
    [_integralBackView addSubview:_integralLabel];
    _integralButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - (20+22)*WideEachUnit, 0, 20 * WideEachUnit, 20 * HigtEachUnit)];
    _integralButton.centerY = 42 * HigtEachUnit / 2.0;
    [_integralButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
    [_integralButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
    [_integralBackView addSubview:_integralButton];
    _integralBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 43 * HigtEachUnit)];
    _integralBackButton.backgroundColor = [UIColor clearColor];
    [_integralBackView addSubview:_integralBackButton];
    [_integralBackButton addTarget:self action:@selector(payMethodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_payMethodBackView addSubview:_integralBackView];

    _line5 = [[UIView alloc] initWithFrame:CGRectMake(0, _integralBackView.bottom, MainScreenWidth, 1 *HigtEachUnit)];
    _line5.backgroundColor = RGBHex(0xE5E5E5);
    [_payMethodBackView addSubview:_line5];
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, _line5.bottom + 5, MainScreenWidth - 20 * WideEachUnit, 15 * HigtEachUnit)];
    _tipLabel.text = [NSString stringWithFormat:@"注:育币与积分的兑换比例为1:%@",@(1 / _percentage)];
    _tipLabel.textColor = RGBHex(0xE94048);
    _tipLabel.font = SYSTEMFONT(12);
    _tipLabel.hidden = !_isHaveAilPay;
    [_payMethodBackView addSubview:_tipLabel];
    _payMethodBackView.frame = CGRectMake(0, _shopIntroBackView.bottom, MainScreenWidth, _tipLabel.bottom + 5);
    
    /// 收货地址
    _addressBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _payMethodBackView.bottom, MainScreenWidth, 115 * HigtEachUnit)];
    [_mainScrollView addSubview:_addressBackView];
    _addressBackView.backgroundColor = [UIColor whiteColor];
    _addressLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 5 * HigtEachUnit)];
    _addressLine1.backgroundColor = RGBHex(0xE5E5E5);
    [_addressBackView addSubview:_addressLine1];
    _addressTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, _addressLine1.bottom, MainScreenWidth - 20 * WideEachUnit, 38 * HigtEachUnit)];
    _addressTitleLabel.textColor = RGBHex(0x1E2133);
    _addressTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:14];
    _addressTitleLabel.text = @"收货地址";
    [_addressBackView addSubview:_addressTitleLabel];
    _addressLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, _addressTitleLabel.bottom, MainScreenWidth, 1 * HigtEachUnit)];
    _addressLine2.backgroundColor = RGBHex(0xE5E5E5);
    [_addressBackView addSubview:_addressLine2];
    _addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 0, 18 * WideEachUnit, 22 * HigtEachUnit)];
    _addressIcon.image = Image(@"定位");
    _addressIcon.centerY = _addressLine2.bottom + 70 * HigtEachUnit / 2.0;
    [_addressBackView addSubview:_addressIcon];
    /// 收货地址具体地址内容
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_addressIcon.right + 7 * WideEachUnit, 0, MainScreenWidth - _addressIcon.right - (7 + 20 + 15) * WideEachUnit, 70 * HigtEachUnit)];
    _addressLabel.numberOfLines = 0;
    _addressLabel.textColor = RGBHex(0x868686);
    _addressLabel.font = Font(12);
    if (SWNOTEmptyDictionary(_addressDict)) {
        NSString *name = [NSString stringWithFormat:@"%@",_addressDict[@"name"]];
        NSString *phone = [NSString stringWithFormat:@"%@",_addressDict[@"phone"]];
        NSString *address = [NSString stringWithFormat:@"%@%@ %@%@",_addressDict[@"province"],_addressDict[@"city"],_addressDict[@"area"],_addressDict[@"address"]];
        _addressLabel.text = [NSString stringWithFormat:@"%@  %@\n%@",name,phone,address];
        NSRange nameRange = [_addressLabel.text rangeOfString:name];
        NSRange phoneRange = [_addressLabel.text rangeOfString:phone];
        NSMutableAttributedString *mutal = [[NSMutableAttributedString alloc] initWithString:_addressLabel.text];
        [mutal addAttributes:@{NSForegroundColorAttributeName: RGBHex(0x282727),NSFontAttributeName: Font(14)} range:nameRange];
        [mutal addAttributes:@{NSForegroundColorAttributeName: RGBHex(0x393939),NSFontAttributeName: Font(14)} range:phoneRange];
        _addressLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:mutal];
        _adress_id = _addressDict[@"address_id"];
    } else {
        _addressLabel.text = @"请选择收货地址";
    }
    _addressLabel.centerY = _addressLine2.bottom + 70 * HigtEachUnit / 2.0;
    [_addressBackView addSubview:_addressLabel];
    _rightIcon = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - (20 + 15) * WideEachUnit, 0, 15 * WideEachUnit, 23 * HigtEachUnit)];
    [_rightIcon setImage:Image(@"更多(2)") forState:0];
    _rightIcon.centerY = _addressLine2.bottom + 70 * HigtEachUnit / 2.0;
    [_addressBackView addSubview:_rightIcon];
    _addressButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _addressLine2.bottom, MainScreenWidth, 70 * HigtEachUnit)];
    _addressButton.backgroundColor = [UIColor clearColor];
    [_addressButton addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_addressBackView addSubview:_addressButton];

    /// 实付金额
    _payCountBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _addressBackView.bottom, MainScreenWidth, 49 * HigtEachUnit)];
    _payCountBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_payCountBackView];
    _payCountLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 5 * HigtEachUnit)];
    _payCountLine.backgroundColor = RGBHex(0xE5E5E5);
    [_payCountBackView addSubview:_payCountLine];
    _payCountTitle = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, _payCountLine.bottom, 60 * WideEachUnit, 44 *HigtEachUnit)];
    _payCountTitle.text = @"实付金额";
    _payCountTitle.textColor = RGBHex(0x1E2133);
    _payCountTitle.font = SYSTEMFONT(13);
    [_payCountBackView addSubview:_payCountTitle];
    _payCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - (150 + 20) * WideEachUnit, _payCountLine.bottom, 150 * WideEachUnit, 44 * HigtEachUnit)];
    _payCountLabel.textColor = RGBHex(0xE94048);
    _payCountLabel.textAlignment = NSTextAlignmentRight;
    _payCountLabel.font = [UIFont fontWithName:@"Alibaba-PuHuiTi-B" size:14];
    _payCountLabel.text = @"育币500";
    CGFloat Money = [[_originDict stringValueForKey:@"price"] integerValue] * _numValue + [[_originDict stringValueForKey:@"fare"] integerValue];
    if ([_scoreStaus integerValue] == 0) {
        Money = ([[_originDict stringValueForKey:@"price"] integerValue] * _numValue + [[_originDict stringValueForKey:@"fare"] integerValue]) * _percentage;
    } else {
        if (_isHaveWxPay || _isHaveAilPay) {
            Money = ([[_originDict stringValueForKey:@"price"] integerValue] * _numValue + [[_originDict stringValueForKey:@"fare"] integerValue]) * _percentage;
        } else {
            Money = [[_originDict stringValueForKey:@"price"] integerValue] * _numValue + [[_originDict stringValueForKey:@"fare"] integerValue];
        }
    }
    _payCountLabel.text = [NSString stringWithFormat:@"育币%.2f",Money];
    [_payCountBackView addSubview:_payCountLabel];

    /// 解锁协议
    _agreementBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _payCountBackView.bottom, MainScreenWidth, 55 * HigtEachUnit)];
    _agreementBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_agreementBackView];
    _agreementLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 5 * HigtEachUnit)];
    _agreementLine.backgroundColor = RGBHex(0xE5E5E5);
    [_agreementBackView addSubview:_agreementLine];
    _agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(20 * WideEachUnit, _agreementLine.bottom + 20 *HigtEachUnit, 24 * WideEachUnit, 24 * HigtEachUnit)];
    [_agreementBackView addSubview:_agreeButton];
    [_agreeButton setImage:Image(@"unchoose_s@3x") forState:0];
    [_agreeButton setImage:Image(@"choose@3x") forState:UIControlStateSelected];
    _agreeButton.selected = YES;
    _agreeButton.centerX = _agreementBackView.height / 2.0;
    _agreeBackButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, _agreementLine.bottom + 15* HigtEachUnit, 30 * WideEachUnit, 30 *HigtEachUnit)];
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
    if (_agreementBackView.bottom > _mainScrollView.height) {
        _mainScrollView.contentSize = CGSizeMake(MainScreenWidth, _agreementBackView.bottom);
    } else {
        _mainScrollView.contentSize = CGSizeMake(MainScreenWidth, _mainScrollView.height);
    }

    /// 底部视图
    _allMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_SAFEAREA - 50 * HigtEachUnit, MainScreenWidth / 2.0, 50 * HigtEachUnit)];
    _allMoneyLabel.backgroundColor = RGBHex(0xF7F7F7);
    _allMoneyLabel.font = [UIFont fontWithName:@"Alibaba-PuHuiTi-B" size:14];
    _allMoneyLabel.textColor = RGBHex(0xE94048);
    _allMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _allMoneyLabel.text = @"合计：育币500";
    [self.view addSubview:_allMoneyLabel];

    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2.0, _allMoneyLabel.top, MainScreenWidth / 2.0, 50 * HigtEachUnit)];
    _submitButton.backgroundColor = RGBHex(0x2069CF);
    [_submitButton setTitle:@"提交订单" forState:0];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:0];
    [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    /// 判断当前默认选中的支付方式是什么
    if (_isHaveAilPay) {
        [self payMethodButtonClick:_alipayBackButton];
    } else {
        if (_isHaveWxPay) {
            [self payMethodButtonClick:_weixinBackButton];
        } else {
            if ([_scoreStaus integerValue] == 1) {
                [self payMethodButtonClick:_integralBackButton];
            }
        }
    }
}

- (void)addressButtonClick {
    ManageAddressViewController *vc = [[ManageAddressViewController alloc] init];
    vc.seleAdressCell = ^(NSDictionary *adressDict) {
        NSString *name = [NSString stringWithFormat:@"%@",adressDict[@"name"]];
        NSString *phone = [NSString stringWithFormat:@"%@",adressDict[@"phone"]];
        NSString *address = [NSString stringWithFormat:@"%@%@ %@%@",adressDict[@"province"],adressDict[@"city"],adressDict[@"area"],adressDict[@"address"]];
        _addressLabel.text = [NSString stringWithFormat:@"%@  %@\n%@",name,phone,address];
        NSRange nameRange = [_addressLabel.text rangeOfString:name];
        NSRange phoneRange = [_addressLabel.text rangeOfString:phone];
        NSMutableAttributedString *mutal = [[NSMutableAttributedString alloc] initWithString:_addressLabel.text];
        [mutal addAttributes:@{NSForegroundColorAttributeName: RGBHex(0x282727),NSFontAttributeName: Font(14)} range:nameRange];
        [mutal addAttributes:@{NSForegroundColorAttributeName: RGBHex(0x393939),NSFontAttributeName: Font(14)} range:phoneRange];
        _addressLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:mutal];
        if (adressDict == nil) {
            _addressLabel.text = @"请选择收货地址";
        }
        _adress_id = adressDict[@"address_id"];
        _addressDict = adressDict;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitButtonClick {
    // 先判断勾选了支付协议没有
    if (!_agreeButton.selected) {
        [TKProgressHUD showError:@"请先阅读并同意《eduline解锁协议》" toView:self.view];
        return;
    }
    if ([_payMethodString integerValue] == 0) {//支付宝支付
        [self netWorkGoodsBuyGoods];
    } else if ([_payMethodString integerValue] == 1) {//微信支付
        [self netWorkGoodsBuyGoods];
    } else if ([_payMethodString integerValue] == 2) {//积分支付
        [self netWorkGoodsExchange];
    }
}

- (void)payMethodButtonClick:(UIButton *)sender {
    if (sender == _alipayBackButton) {
        _alipayButton.selected = YES;
        _weixinButton.selected = NO;
        _integralButton.selected = NO;
        _payMethodString = @"0";
        _payCountLabel.text = [NSString stringWithFormat:@"%.2f",([[_originDict stringValueForKey:@"price"] integerValue] * _numValue + [[_originDict stringValueForKey:@"fare"] integerValue]) * _percentage];
    } else if (sender == _weixinBackButton) {
        _alipayButton.selected = NO;
        _weixinButton.selected = YES;
        _integralButton.selected = NO;
        _payMethodString = @"1";
        _payCountLabel.text = [NSString stringWithFormat:@"%.2f",([[_originDict stringValueForKey:@"price"] integerValue] * _numValue + [[_originDict stringValueForKey:@"fare"] integerValue]) * _percentage];
    } else if (sender == _integralBackButton) {
        _alipayButton.selected = NO;
        _weixinButton.selected = NO;
        _integralButton.selected = YES;
        _payMethodString = @"2";
        if ([_scoreStaus integerValue] == 1) {
            _payCountLabel.text = [NSString stringWithFormat:@"%ld积分",([[_originDict stringValueForKey:@"price"] integerValue] * _numValue + [[_originDict stringValueForKey:@"fare"] integerValue])];
        }
    }
    _allMoneyLabel.text = [NSString stringWithFormat:@"合计: %@",_payCountLabel.text];
}

//商品的解锁
- (void)netWorkGoodsBuyGoods {
    NSString *endUrlStr = YunKeTang_Goods_goods_buyGoods;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_originDict stringValueForKey:@"goods_id"] forKey:@"goods_id"];
    [mutabDict setObject:[NSString stringWithFormat:@"%d",_numValue] forKey:@"count"];
    if ([_payMethodString integerValue] == 0) {//支付宝
        [mutabDict setObject:@"alipay" forKey:@"pay"];
    } else if ([_payMethodString integerValue] == 1) {//微信
        [mutabDict setObject:@"wxpay" forKey:@"pay"];
    }
    
    CGFloat Money = ([[_originDict stringValueForKey:@"price"] integerValue] * _numValue + [[_originDict stringValueForKey:@"fare"] integerValue]) * _percentage;
    [mutabDict setObject:[NSString stringWithFormat:@"%.2f",Money] forKey:@"money"];
    
    if (_adress_id) {
        [mutabDict setObject:_adress_id forKey:@"address_id"];
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
            if ([_payMethodString integerValue] == 0) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
            } else if ([_payMethodString integerValue] == 1){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//商品的兑换
- (void)netWorkGoodsExchange {
    NSString *endUrlStr = YunKeTang_Goods_goods_exchange;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];

    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_originDict stringValueForKey:@"goods_id"] forKey:@"goods_id"];
    [mutabDict setObject:[NSString stringWithFormat:@"%d",_numValue] forKey:@"num"];
    if (_adress_id) {
        [mutabDict setObject:_adress_id forKey:@"address_id"];
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
        if ([[dict stringValueForKey:@"code"] integerValue] == 0) {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

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

// MARK: - 微信支付
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

@end
