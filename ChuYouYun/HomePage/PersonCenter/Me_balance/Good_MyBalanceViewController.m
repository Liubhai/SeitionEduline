//
//  Good_MyBalanceViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/10/17.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_MyBalanceViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "MyHttpRequest.h"

#import "Good_CommissionViewController.h"
#import "Good_RechargeCardViewController.h"
#import "Good_RechargeCardViewController.h"
#import "Good_IntegralParticularsViewController.h"
#import "BuyAgreementViewController.h"
#import "STRIAPManager.h"


@interface Good_MyBalanceViewController ()<UITextFieldDelegate,UIWebViewDelegate,UIScrollViewDelegate>{
    UIButton *moneySeleButton;//记录充值的button
    BOOL      isGiveMoney;
    NSInteger isSeleMoneyButtonNumber;
    BOOL      isScroll;//当在编辑中的状态能否滑动
}

@property (strong ,nonatomic)UIScrollView   *scrollView;
@property (strong ,nonatomic)UIView   *moneyView;
@property (strong ,nonatomic)UIView   *rechargeView;
@property (strong ,nonatomic)UIView   *payView;
@property (strong ,nonatomic)UIView   *alipayView;
@property (strong ,nonatomic)UIView   *wxpayView;
@property (strong ,nonatomic)UIView   *applePayView;
@property (strong ,nonatomic)UIView   *rechargeCardView;
@property (strong ,nonatomic)UIView   *agreeView;
@property (strong ,nonatomic)UIView   *downView;
@property (strong ,nonatomic)UIWebView *webView;

@property (strong ,nonatomic)UILabel  *balanceLabel;
@property (strong ,nonatomic)UITextField *textField;
@property (strong ,nonatomic)UIButton  *ailpaySeleButton;
@property (strong ,nonatomic)UIButton  *wxSeleButton;
@property (strong ,nonatomic)UIButton  *appleButton;
@property (strong ,nonatomic)UIButton  *submitButton;
@property (strong ,nonatomic)UIButton  *agreeButton;


@property (strong ,nonatomic)UIButton  *oneButton;
@property (strong ,nonatomic)UIButton  *twoButton;
@property (strong ,nonatomic)UIButton  *threeButton;
@property (strong ,nonatomic)UIButton  *fourButton;
@property (strong ,nonatomic)UILabel   *realMoney;

@property (strong ,nonatomic)NSString  *payTypeStr;
@property (strong ,nonatomic)NSString  *alipayStr;
@property (strong ,nonatomic)NSString  *productID;
@property (strong ,nonatomic)NSDictionary *balanceDict;
@property (strong ,nonatomic)NSDictionary *wxPayDict;
@property (strong ,nonatomic)NSArray      *payTypeArray;//接口返回的支付方式
@property (strong ,nonatomic)NSArray      *netWorkBalanceArray;//网络请求下来的个数
@property (strong ,nonatomic)NSArray      *applepayArray;
@property (strong ,nonatomic)STRIAPManager *iapManager;

@end

@implementation Good_MyBalanceViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    [self netWorkUserBalanceConfig];
    
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
//    [self addPayView];
//    [self addRechargeCardView];
//    [self addAgreeView];
    [self addDownView];
    [self netWorkUserBalanceConfig];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBroadShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBroadHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    _payTypeStr = @"1";
    isGiveMoney = NO;
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
    WZLabel.text = @"余额";
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

#pragma mark --- 添加网络视图
#pragma mark ---- 支付界面
- (void)addWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
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

#pragma mark --- 界面添加

//添加滚动视图
- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 49 * WideEachUnit - 64)];
    if (iPhoneX) {
        _scrollView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 83 * WideEachUnit - 88);
    }
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
}

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
    _balanceLabel = balanceLabel;
    
    //文字
    UILabel *balanceTitle = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit,60 * WideEachUnit , 200 * WideEachUnit, 15 * WideEachUnit)];
    balanceTitle.text = @"账户余额";
    [balanceTitle setTextColor:[UIColor groupTableViewBackgroundColor]];
    balanceTitle.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    balanceTitle.textAlignment = NSTextAlignmentCenter;
    [_moneyView addSubview:balanceTitle];
    
}

- (void)addRechargeView {
    if (_rechargeView == nil) {
        _rechargeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_moneyView.frame), MainScreenWidth, 215 * WideEachUnit)];
        _rechargeView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_rechargeView];
    }
    [_rechargeView removeAllSubviews];
    
    
    //横线
    UILabel *line = [[UILabel  alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 10 * WideEachUnit , 3 * WideEachUnit, 10 * WideEachUnit)];
    line.backgroundColor = BasidColor;
    [_rechargeView addSubview:line];
    
    //名字
    UILabel *title = [[UILabel  alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 10 * WideEachUnit , 30 * WideEachUnit, 10 * WideEachUnit)];
    title.text = @"充值";
    title.textColor = [UIColor blackColor];
    title.font = Font(12 * WideEachUnit);
    [_rechargeView addSubview:title];
    
    //判断是否应该有此支付方式
    BOOL isAddAilpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"alipay"]) {
            isAddAilpayView = YES;
        }
    }
    //判断是否应该有此支付方式
    BOOL isAddWxpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"wxpay"]) {
            isAddWxpayView = YES;
        }
    }
    //判断是否应该有此支付方式
    BOOL isAddApplepayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"applepay"]) {
            isAddApplepayView = YES;
        }
    }
    //判断是否应该有此支付方式
    BOOL isAddRechargeCardView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"cardpay"]) {
            isAddRechargeCardView = YES;
        }
    }
    
    if (_appleButton.selected || (!isAddAilpayView && !isAddWxpayView && !isAddRechargeCardView)) {
        _netWorkBalanceArray = (NSArray *)_applepayArray;
    } else {
        _netWorkBalanceArray = (NSArray *)[_balanceDict arrayValueForKey:@"rechange_default"];
    }
    
    //添加充值界面
    
    CGFloat buttonW = 165 * WideEachUnit;
    CGFloat buttonH = 59 * WideEachUnit;
    NSArray *titleArray = nil;
    NSArray *additionArray = nil;
    NSInteger allNumber = 0;
    if (_netWorkBalanceArray.count == 0) {
        titleArray = @[@"育币20",@"",@"",@"育币   "];
        additionArray = @[@"",@"充50送10",@"充100送30",@""];
        allNumber = 4;
    } else {
        allNumber = _netWorkBalanceArray.count;
    }
    for (int i  = 0 ; i < allNumber + 1 ; i ++) {
        if (i < _netWorkBalanceArray.count) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit + (buttonW + 10 * WideEachUnit) * (i % 2), 30 * WideEachUnit + (buttonH + 15 * WideEachUnit) * (i / 2), buttonW, buttonH)];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            button.layer.borderWidth = 1 * WideEachUnit;
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = Font(20 * WideEachUnit);
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [_rechargeView addSubview:button];
            if (i == 0) {
                _oneButton = button;
                [self buttonCilck:button];
            }
            
            
            //钱的数字
            UILabel *number1 = [[UILabel  alloc] initWithFrame:CGRectMake(0, 10 * WideEachUnit , buttonW, 20 * WideEachUnit)];
            number1.text = [NSString stringWithFormat:@"%@育币",[[_netWorkBalanceArray objectAtIndex:i] stringValueForKey:@"rechange"]];
            number1.textColor = [UIColor colorWithHexString:@"#888"];
            number1.font = Font(20 * WideEachUnit);
            number1.textAlignment = NSTextAlignmentCenter;
            [button addSubview:number1];
            
            //提示
            UILabel *title = [[UILabel  alloc] initWithFrame:CGRectMake(0, 34 * WideEachUnit , buttonW, 15 * WideEachUnit)];
            title.text = @"充50送10";
            if (_netWorkBalanceArray.count == 0) {
                title.text = @"充50送10";
            } else {
                
                if ([[[_netWorkBalanceArray objectAtIndex:i] stringValueForKey:@"give"] integerValue] == 0) {
                    title.text = @"";
                    number1.frame = CGRectMake(0, 0, buttonW, buttonH);
                } else {
                    title.text = [NSString stringWithFormat:@"充%@送%@",[[_netWorkBalanceArray objectAtIndex:i] stringValueForKey:@"rechange"],[[_netWorkBalanceArray objectAtIndex:i] stringValueForKey:@"give"]];
                }
            }
            title.textColor = [UIColor colorWithHexString:@"#888"];
            title.font = Font(12 * WideEachUnit);
            title.textAlignment = NSTextAlignmentCenter;
            [button addSubview:title];
            
        } else if (i == _netWorkBalanceArray.count) {
            if ((isAddAilpayView || isAddWxpayView || isAddRechargeCardView) && !_appleButton.selected) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit + (buttonW + 10 * WideEachUnit) * (i % 2), 30 * WideEachUnit + (buttonH + 15 * WideEachUnit) * (i / 2), buttonW, buttonH)];
                button.backgroundColor = [UIColor whiteColor];
                button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
                button.layer.borderWidth = 1 * WideEachUnit;
                [button setTitle:titleArray[i] forState:UIControlStateNormal];
                button.titleLabel.font = Font(20 * WideEachUnit);
                [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                [button setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                [_rechargeView addSubview:button];
                
                
                _fourButton = button;
                //添加自定义
                UIButton *moneyButton = [[UIButton alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 0, 25 * WideEachUnit, buttonH)];
                moneyButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [moneyButton setTitle:@"育币" forState:UIControlStateNormal];
                moneyButton.titleLabel.numberOfLines = 0;
                moneyButton.titleLabel.font = Font(13 * WideEachUnit);
                [moneyButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
                [button addSubview:moneyButton];
                
                //添加输入文本
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(25 * WideEachUnit, 0, buttonW - 50 * WideEachUnit, buttonH)];
                textField.backgroundColor = [UIColor whiteColor];
                textField.font = Font(20 * WideEachUnit);
                textField.text = @"";
                textField.textAlignment = NSTextAlignmentCenter;
                textField.delegate = self;
                textField.textColor = [UIColor colorWithHexString:@"#888"];
                textField.returnKeyType = UIReturnKeyDone;
                [button addSubview:textField];
                _textField = textField;
                //            [_textField becomeFirstResponder];
                
                
                
                //添加自定义
                UIButton *selfButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonW - 25 * WideEachUnit, 0, 25 * WideEachUnit, buttonH)];
                selfButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [selfButton setTitle:@"自定义" forState:UIControlStateNormal];
                selfButton.titleLabel.numberOfLines = 0;
                selfButton.titleLabel.font = Font(13 * WideEachUnit);
                [selfButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
                [button addSubview:selfButton];
            }
        }
    }

    if ((_netWorkBalanceArray.count + 1) % 2 == 0) {//能整除的时候
        _rechargeView.frame = CGRectMake(0, CGRectGetMaxY(_moneyView.frame), MainScreenWidth, ((_netWorkBalanceArray.count + 1) / 2) * (buttonH + 15 * WideEachUnit) + 60 * WideEachUnit);
        if (_applepayArray.count>0 && (_appleButton.selected || (!isAddAilpayView && !isAddWxpayView && !isAddRechargeCardView))) {
            _rechargeView.frame = CGRectMake(0, CGRectGetMaxY(_moneyView.frame), MainScreenWidth, ((_netWorkBalanceArray.count + 1) / 2) * (buttonH + 15 * WideEachUnit) + 30);
        }
    } else {//不能整除的时候
        _rechargeView.frame = CGRectMake(0, CGRectGetMaxY(_moneyView.frame), MainScreenWidth, ((_netWorkBalanceArray.count + 1) / 2 + 1) * (buttonH + 15 * WideEachUnit) + 60 * WideEachUnit);
        if (_applepayArray.count>0 && (_appleButton.selected || (!isAddAilpayView && !isAddWxpayView && !isAddRechargeCardView))) {
            _rechargeView.frame = CGRectMake(0, CGRectGetMaxY(_moneyView.frame), MainScreenWidth, ((_netWorkBalanceArray.count + 1) / 2) * (buttonH + 15 * WideEachUnit) + 30);
        }
    }
    
    
    //添加备注的文本
    UILabel *remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetHeight(_rechargeView.frame) - 30 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 20 * WideEachUnit)];
    remainLabel.text = [_balanceDict stringValueForKey:@"pay_note"];
    remainLabel.textColor = [UIColor colorWithHexString:@"#888"];
    remainLabel.font = Font(12 * WideEachUnit);
    remainLabel.hidden = YES;
    [_rechargeView addSubview:remainLabel];
    
    [_alipayView setTop:CGRectGetMaxY(_rechargeView.frame) + 10 * WideEachUnit];
    [_wxpayView setTop:CGRectGetMaxY(_alipayView.frame)];
    [_applePayView setTop:CGRectGetMaxY(_wxpayView.frame)];
    [_rechargeCardView setTop:CGRectGetMaxY(_applePayView.frame)];
    [_agreeView setTop:CGRectGetMaxY(_rechargeCardView.frame) + 10 * WideEachUnit];
}


- (void)addAliPayView {
    
    if (_applePayView == nil) {
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

    
}


- (void)addWxPayView {
    if (_wxpayView == nil) {
        _wxpayView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit)];
        _rechargeCardView.backgroundColor = [UIColor whiteColor];
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
    
}

- (void)addApplePayView {
    if (_applePayView == nil) {
        _applePayView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_wxpayView.frame), MainScreenWidth, 50 * WideEachUnit)];
        _applePayView.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:_applePayView];
    }
    [_applePayView removeAllSubviews];
    //判断是否应该有此支付方式
    BOOL isAddApplepayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"applepay"]) {
            isAddApplepayView = YES;
        }
    }
    
    if (isAddApplepayView) {//有苹果支付
        
        if (_alipayView.frame.size.height > 0 ) {
            if (_wxpayView.frame.size.height > 0) {
                _applePayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_wxpayView.frame), MainScreenWidth, 50 * WideEachUnit);
            } else {
                _applePayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), MainScreenWidth, 50 * WideEachUnit);
            }
            
        } else if (_wxpayView.frame.size.height > 0) {
            _applePayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_wxpayView.frame), MainScreenWidth, 50 * WideEachUnit);
        } else {
            _applePayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_rechargeView.frame), MainScreenWidth, 50 * WideEachUnit);
        }
        
    } else {
        _applePayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_wxpayView.frame), 0, 0 * WideEachUnit);
        _applePayView.hidden = YES;
    }
    
    
    CGFloat viewW = MainScreenWidth;
    CGFloat viewH = 50 * WideEachUnit;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 * WideEachUnit , viewW, viewH)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0.5 * WideEachUnit;
    view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [_applePayView addSubview:view];
    
    UIImageView *weixinIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
    weixinIcon.image = Image(@"apple_pay");
    weixinIcon.centerY = 50 * HigtEachUnit / 2.0;
    [_applePayView addSubview:weixinIcon];
    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(weixinIcon.right + 12 * WideEachUnit, 0, 100, 50 * HigtEachUnit)];
    weixinLabel.textColor = RGBHex(0x1E2133);
    weixinLabel.font = Font(13);
    weixinLabel.text = @"苹果支付";
    [_applePayView addSubview:weixinLabel];
    
    
    UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
    [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
    [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
    [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    seleButton.tag = 2;
    _appleButton = seleButton;
    _appleButton.selected = NO;
    
    if (_alipayView.frame.size.height == 0 && _wxpayView.frame.size.height == 0) {//说明没有支付宝支付
        [self seleButtonCilck:seleButton];
    }
    
    [view addSubview:seleButton];
    
    UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    allClearButton.backgroundColor = [UIColor clearColor];
    allClearButton.tag = 2;
    [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:allClearButton];
    
    //判断是否应该有此支付方式
    BOOL isAddRechargeCardView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"cardpay"]) {
            isAddRechargeCardView = YES;
        }
    }
    if (_alipayView.height == 0 && _wxpayView.height == 0 && !isAddRechargeCardView) {
        // 上架处理
        UIView *whiteView = [[UIView alloc] initWithFrame:_applePayView.frame];
        whiteView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:whiteView];
    }
}


- (void)addPayView {
    
    _payView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_rechargeView.frame) + 10 * WideEachUnit, MainScreenWidth, 150 * WideEachUnit)];
    _payView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_payView];
    
    
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

- (void)addRechargeCardView {
    if (_rechargeCardView == nil) {
        _rechargeCardView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_applePayView.frame), MainScreenWidth - 0 * WideEachUnit, 50 * WideEachUnit)];
        _rechargeCardView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_rechargeCardView];
    }
    [_rechargeCardView removeAllSubviews];
    
    //判断是否应该有此支付方式
    BOOL isAddRechargeCardView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"cardpay"]) {
            isAddRechargeCardView = YES;
        }
    }
    
    if (isAddRechargeCardView) {//有充值卡
        
    } else {
        _rechargeCardView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_applePayView.frame), 0, 0 * WideEachUnit);
        _rechargeCardView.hidden = YES;
    }
    

    //添加充值卡
    UIImageView *rechargeCardIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
    rechargeCardIcon.image = Image(@"recharge_card");
    rechargeCardIcon.centerY = 50 * HigtEachUnit / 2.0;
    [_rechargeCardView addSubview:rechargeCardIcon];
    UILabel *rechargeCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(rechargeCardIcon.right + 12 * WideEachUnit, 0, 100, 50 * HigtEachUnit)];
    rechargeCardLabel.textColor = RGBHex(0x1E2133);
    rechargeCardLabel.font = Font(13);
    rechargeCardLabel.text = @"充值卡充值";
    [_rechargeCardView addSubview:rechargeCardLabel];
    
    //添加箭头
    UIButton *arrowsButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 35 * WideEachUnit,15 * WideEachUnit, 20 * WideEachUnit, 20 * WideEachUnit)];
    [arrowsButton setImage:Image(@"考试右@2x") forState:UIControlStateNormal];
    [arrowsButton addTarget:self action:@selector(arrowsButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_rechargeCardView addSubview:arrowsButton];
    
    //添加手势
    [_rechargeCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rechargeCardViewClick:)]];
    
}

- (void)addAgreeView {
    if (_agreeView == nil) {
        _agreeView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_rechargeCardView.frame) + 10 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit, 44 * WideEachUnit)];
        _agreeView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_agreeView];
    }
    [_agreeView removeAllSubviews];
    
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
    [pactButton addTarget:self action:@selector(pactButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [pactButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_agreeView addSubview:pactButton];
    
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_agreeView.frame) + 30 * WideEachUnit);
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
    realMoney.text = @"¥0";
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

#pragma mark --- 通知
- (void)textChange:(NSNotification *)not {
    NSLog(@"%@",_textField);
    if (_textField.text.length > 6) {
        [TKProgressHUD showError:@"充值金额不能过大" toView:self.view];
        _textField.text = [_textField.text substringToIndex:6];
        return;
    } else if (_textField.text.length == 0) {
        _textField.text = @"";
        return;
    }
    
    _realMoney.text = [NSString stringWithFormat:@"¥%@",_textField.text];
}

-(void)keyBroadShow:(NSNotification *)not {
    [_scrollView setContentOffset:CGPointMake(0,MainScreenHeight - CGRectGetMaxY(_rechargeView.frame)) animated:YES];
    if (iPhoneX) {
        [_scrollView setContentOffset:CGPointMake(0,MainScreenHeight - CGRectGetMaxY(_rechargeView.frame) - 200) animated:YES];
    }
    isScroll = NO;
    _scrollView.scrollEnabled = NO;
    
//    for (int i = 0; i < _netWorkBalanceArray.count - 1; i ++) {
//        UIButton *button =(UIButton *) [self.view viewWithTag:i];
//        button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
//        button.enabled = NO;
//    }
//    _fourButton.enabled = YES;
    
}

-(void)keyBroadHide:(NSNotification *)not {
    isScroll = NO;
    [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    _scrollView.scrollEnabled = YES;
    
//    for (int i = 0; i < _netWorkBalanceArray.count - 1; i ++) {
//        UIButton *button =(UIButton *) [self.view viewWithTag:i];
//        button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
//        button.enabled = YES;
//    }
//    _fourButton.enabled = YES;
}


#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailButtonCilck {
    Good_IntegralParticularsViewController *vc = [[Good_IntegralParticularsViewController alloc] init];
    vc.typeStr = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buttonCilck:(UIButton *)button {
    NSLog(@"----%ld",button.tag);
    moneySeleButton.selected = NO;
    moneySeleButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    button.selected = YES;
    moneySeleButton = button;
    
    if (button.selected == YES) {
        button.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }
    
    _fourButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    if (_appleButton.selected) {
        NSString *price = [NSString stringWithFormat:@"%@",[[_netWorkBalanceArray objectAtIndex:button.tag] stringValueForKey:@"rechange"]];
        if ([price isEqualToString:@"4.2"]) {
            _realMoney.text = @"¥6";
        } else if ([price isEqualToString:@"8.4"]) {
            _realMoney.text = @"¥12";
        } else if ([price isEqualToString:@"21"]) {
            _realMoney.text = @"¥30";
        } else if ([price isEqualToString:@"35"]) {
            _realMoney.text = @"¥50";
        } else if ([price isEqualToString:@"131.6"]) {
            _realMoney.text = @"¥188";
        } else if ([price isEqualToString:@"432.6"]) {
            _realMoney.text = @"¥618";
        }
        if (_applepayArray.count) {
            _productID = [[_applepayArray objectAtIndex:button.tag] stringValueForKey:@"product_id"];
        }
    } else {
        _realMoney.text = [NSString stringWithFormat:@"¥%@",[[_netWorkBalanceArray objectAtIndex:button.tag] stringValueForKey:@"rechange"]];
    }
    //配置充值是否充值赠送
    isGiveMoney = YES;
    isSeleMoneyButtonNumber = button.tag;
}

- (void)seleButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//支付宝
        _ailpaySeleButton.selected = YES;
        _wxSeleButton.selected = NO;
        _appleButton.selected = NO;
        if ([_payTypeStr isEqualToString:@"3"]) {
            [self addRechargeView];
        }
        _payTypeStr = @"1";
    } else if (button.tag == 1) {//微信
        _ailpaySeleButton.selected = NO;
        _wxSeleButton.selected = YES;
        _appleButton.selected = NO;
        if ([_payTypeStr isEqualToString:@"3"]) {
            [self addRechargeView];
        }
        _payTypeStr = @"2";
    } else if (button.tag == 2) {//苹果
        _ailpaySeleButton.selected = NO;
        _wxSeleButton.selected = NO;
        _appleButton.selected = YES;
        if (![_payTypeStr isEqualToString:@"3"]) {
            [self addRechargeView];
        }
        _payTypeStr = @"3";
    }
}

- (void)arrowsButtonCilck {
    Good_RechargeCardViewController *vc = [[Good_RechargeCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//手势
- (void)rechargeCardViewClick:(UITapGestureRecognizer *)tap {
    Good_RechargeCardViewController *vc = [[Good_RechargeCardViewController alloc] init];
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

- (void)pactButtonCilck {
    BuyAgreementViewController *vc = [[BuyAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitButtonCilck {
    if ([_payTypeStr integerValue] == 3) {
        
    } else {
        [self netWorkUserRechargeBalance];
        return;
    }

    
    if (!_iapManager) {
        _iapManager = [[STRIAPManager shareSIAPManager] init];
    }

    
    // iTunesConnect 苹果后台配置的产品ID
    if (_productID == nil) {
        [TKProgressHUD showError:@"请选择充值的金额" toView:self.view];
        return;
    }
    [TKProgressHUD showSuccess:@"请稍等" toView:self.view];
    [_iapManager startPurchWithID:_productID completeHandle:^(SIAPPurchType type,NSData *data) {
        NSLog(@"----%@",data);
        NSString *str =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", str);
    }];
}

#pragma mark --- UITextFieldDelegate


#pragma mark --- 键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"123");
    //点搜索按钮
    
    [textField resignFirstResponder];
    if ([textField.text isEqualToString:@"完成"]){
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _fourButton.layer.borderColor = [UIColor redColor].CGColor;
    _oneButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    moneySeleButton.selected = NO;
    moneySeleButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    for (int i = 0; i < _netWorkBalanceArray.count; i ++) {
        UIButton *button =(UIButton *) [self.view viewWithTag:i];
        button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }
    
    _realMoney.text = [NSString stringWithFormat:@"¥%@",_textField.text];
    
    isGiveMoney = NO;
    isSeleMoneyButtonNumber = 100;//表示不是选中的有赠送的按钮
    
    isScroll = NO;
    
    [_scrollView setContentOffset:CGPointMake(0,MainScreenHeight - CGRectGetMaxY(_rechargeView.frame)) animated:YES];
    
    
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
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
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

#pragma mark --- UIScrollView 

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isScroll) {
        [self.view endEditing:YES];
    } else {
        NSLog(@"12");
    }

}


//是否 真要删除小组
- (void)isSurePay {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确定要取消该订单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self NetWorkCancel];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark --- 支付相关
//支付宝
//解锁积分 获取支付的链接
- (void)BuyNetInfoAlipay {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [TKProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
    
    if (_realMoney.text.length > 1) {
        NSString *moneyStr = [_realMoney.text substringFromIndex:1];
        if (isSeleMoneyButtonNumber == 100) {//表示在输入框中
            [dic setValue:[NSString stringWithFormat:@"%@",moneyStr] forKey:@"money"];
        } else {//在赠送的按钮上
            NSString *giveMoney = [[_netWorkBalanceArray objectAtIndex:isSeleMoneyButtonNumber] stringValueForKey:@"give"];
            if ([giveMoney integerValue] == 0) {
                [dic setValue:[NSString stringWithFormat:@"%@",moneyStr] forKey:@"money"];
            } else {
                [dic setValue:[NSString stringWithFormat:@"%@=>%@",moneyStr,giveMoney] forKey:@"money"];
            }
        }
        
    } else {
        [TKProgressHUD showError:@"充值金额不能为空" toView:self.view];
    }


    [dic setValue:@"alipay" forKey:@"pay_for"];
    
    NSLog(@"%@",dic);
    
    [manager getpublicPort:dic mod:@"User" act:@"pay" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSLog(@"%@",operation);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {//不是免费
                _alipayStr = responseObject[@"data"][@"alipay"][@"ios"];
                [self addWebView];
            } else {//免费
                [TKProgressHUD showSuccess:@"解锁成功" toView:self.view];
            }
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//微信支付
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


#pragma mark --- 网络请求
//获取余额各种数据以及配置
- (void)netWorkUserBalanceConfig {//
    
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
        _balanceDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        _balanceLabel.text = [NSString stringWithFormat:@"育币%@",[_balanceDict stringValueForKey:@"balance" defaultValue:@"0"]];
        _balanceLabel.text = [NSString stringWithFormat:@"%@",[[_balanceDict dictionaryValueForKey:@"learncoin_info"] stringValueForKey:@"balance" defaultValue:@"0"]];
        
        
        _netWorkBalanceArray = [_balanceDict arrayValueForKey:@"rechange_default"];
        _payTypeArray = [_balanceDict arrayValueForKey:@"pay"];
        _applepayArray = [_balanceDict arrayValueForKey:@"rechange_iphone"];
        [self addRechargeView];
        [self addAliPayView];
        [self addWxPayView];
        [self addApplePayView];
        [self addRechargeCardView];
        [self addAgreeView];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//充值余额
- (void)netWorkUserRechargeBalance {//
    
    NSString *endUrlStr = YunKeTang_User_user_rechargeBalance;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([_payTypeStr integerValue] == 1) {//支付宝支付
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {//微信支付
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {//余额支付
        [mutabDict setValue:@"" forKey:@"pay_for"];
    }
    if (_realMoney.text.length > 1) {
        NSString *moneyStr = [_realMoney.text substringFromIndex:1];
        if (isSeleMoneyButtonNumber == 100) {//表示在输入框中
            [mutabDict setValue:[NSString stringWithFormat:@"%@",moneyStr] forKey:@"money"];
        } else {//在赠送的按钮上
            NSString *giveMoney = [[_netWorkBalanceArray objectAtIndex:isSeleMoneyButtonNumber] stringValueForKey:@"give"];
            if ([giveMoney integerValue] == 0) {
                [mutabDict setValue:[NSString stringWithFormat:@"%@",moneyStr] forKey:@"money"];
            } else {
                [mutabDict setValue:[NSString stringWithFormat:@"%@=>%@",moneyStr,giveMoney] forKey:@"money"];
            }
        }
        
    } else {
        [TKProgressHUD showError:@"充值育币不能为空" toView:self.view];
        return;
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
            } else if ([_payTypeStr integerValue] == 2) {//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
