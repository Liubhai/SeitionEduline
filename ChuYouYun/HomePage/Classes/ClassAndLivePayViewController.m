//
//  ClassAndLivePayViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/10/13.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ClassAndLivePayViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "BigWindCar.h"
#import "MyHttpRequest.h"
#import "TKProgressHUD+Add.h"
#import "MJRefresh.h"
#import "Good_DiscountMainViewController.h"
#import "EntityCardViewController.h"
#import "BuyAgreementViewController.h"

@interface ClassAndLivePayViewController ()<UIWebViewDelegate> {
    BOOL isArgree;
    BOOL isGoOut;
}

@property (strong ,nonatomic)UIScrollView  *scrollView;
@property (strong ,nonatomic)UIView *buyView;
@property (strong ,nonatomic)UILabel *counpLabel;
@property (strong ,nonatomic)UILabel *infoLabel;
@property (strong ,nonatomic)UILabel *priceLabel;
@property (strong ,nonatomic)NSMutableArray *counpArray;

@property (strong ,nonatomic)NSString *alipayStr;
@property (strong ,nonatomic)NSString *counpID;
@property (strong ,nonatomic)NSString *wxpayStr;
@property (strong ,nonatomic)NSDictionary *wxPayDict;


@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIWebView *webView;
@property (assign,nonatomic) NSInteger typeNum;

//优化后的界面
@property (strong ,nonatomic)UIView    *classInformationView;
@property (strong ,nonatomic)UIView    *payView;
@property (strong ,nonatomic)UIView    *alipayView;
@property (strong ,nonatomic)UIView    *wxpayView;
@property (strong ,nonatomic)UIView    *balanceView;
@property (strong ,nonatomic)UIView    *discountView;
@property (strong ,nonatomic)UIView    *moneyView;
@property (strong ,nonatomic)UIView    *agreeView;
@property (strong ,nonatomic)UIView    *downView;

@property (strong ,nonatomic)UIButton  *submitButton;
@property (strong ,nonatomic)UIButton  *ailpaySeleButton;
@property (strong ,nonatomic)UIButton  *wxSeleButton;
@property (strong ,nonatomic)UIButton  *balanceButton;
@property (strong ,nonatomic)UIButton  *agreeButton;
@property (strong ,nonatomic)UIButton  *entityGoToUseButton;

@property (strong ,nonatomic)UILabel   *residue;//剩余的钱
@property (strong ,nonatomic)UILabel   *discountMoneyLabel;//优惠的价钱
@property (strong ,nonatomic)UILabel   *reminderDiscount;//提示是否有优惠券使用
@property (strong ,nonatomic)UILabel   *entityDiscount;//实体卡的情况
@property (strong ,nonatomic)UILabel   *realMoney;
@property (strong ,nonatomic)NSDictionary *userBalanceDict;

@property (strong ,nonatomic)NSString  *payTypeStr;//用于区分支付类型 （支付宝和微信）
@property (strong ,nonatomic)NSArray   *payTypeArray;
@property (strong ,nonatomic)NSString  *balbanStr;//余额的字符串

@property (strong ,nonatomic)NSArray   *testArray;
@property (strong ,nonatomic)NSDictionary *testDict;
@property (strong ,nonatomic)NSDictionary *videoDataSource;//课程的详情

//实体卡的一些数据
@property (strong ,nonatomic)NSDictionary  *entityReturnDict;//实体卡通知返回回来的信息
@property (strong ,nonatomic)NSString      *stasutStr;//优惠券的状态
@property (strong ,nonatomic)NSTimer       *timer;



@end

@implementation ClassAndLivePayViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (isGoOut) {//说明是从付款页回来
        [self backPressed];
    }
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
    NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_dict];
    [pass setObject:[[pass objectForKey:@"mz_price"] objectForKey:@"selPrice"] forKey:@"price"];
    _dict = [NSDictionary dictionaryWithDictionary:pass];
    _counpArray = [NSMutableArray new];
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = [_typeStr isEqualToString:@"4"] ? @"解锁套餐" : @"解锁课程";
    [self interFace];
    [self addScrollView];
    [self addInfoView];
    [self addClassInformationView];
    [self NetWorkConfigPaySwitch];
//    [self NetWorkAccountInfo];
//    [self netWorkUserBalanceConfig];
    if ([_typeStr isEqualToString:@"4"]) {
        [self netWorkComboGetCanUseCouponList];
    } else {
        [self netWorkVideoGetCanUseCouponList];
    }
//    [self getMyMoney];
    [self netWorkUserGetAccount];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSLog(@"---%@",_dict);
    _payTypeStr = @"0";//默认是支付宝
    NSLog(@"---%@",_typeStr);
    isGoOut = NO;
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDiscount:) name:@"NSNotificationGetWhichDiscount" object:nil];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEntityCardUse:) name:@"NSNotificationEntityCardUse" object:nil];
    
    //从第三方支付回来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(APPWillEnterForeground:) name:@"APPWillEnterForeground" object:nil];
    
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"解锁课程";
    if ([_typeStr isEqualToString:@"4"]) {
        WZLabel.text = @"解锁套餐";
    }
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    //   // 添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark --- 添加界面

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_SAFEAREA - 49 * HigtEachUnit)];
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_scrollView];
}

- (void)addInfoView {
    
    
}

- (void)addClassInformationView {
    _classInformationView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit,10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 121 * WideEachUnit)];
    _classInformationView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_classInformationView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0,MainScreenWidth - 40 * WideEachUnit, 36 * WideEachUnit)];
    title.text = @"商品信息";
    title.font = Font(13 * WideEachUnit);
    title.textColor = [UIColor colorWithHexString:@"#888"];
    [_classInformationView addSubview:title];
    
    //添加线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 36 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit, 1 * WideEachUnit)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_classInformationView addSubview:line];
    
    
    //添加图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 46 * WideEachUnit, 105 * WideEachUnit, 60 * WideEachUnit)];
    NSString *urlStr = [_dict stringValueForKey:@"cover"];
    if ([_typeStr integerValue] == 3 || [_typeStr integerValue] == 4) {//线下课
        urlStr = [_dict stringValueForKey:@"imageurl" defaultValue:@""];
    }
    NSLog(@"%@",_dict);
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    [_classInformationView addSubview:imageView];
    
    //添加课程名字
    UILabel *className = [[UILabel alloc] initWithFrame:CGRectMake(130 * WideEachUnit, 46 * WideEachUnit,MainScreenWidth - 160 * WideEachUnit, 24 * WideEachUnit)];
    className.text = @"商品信息";
    className.numberOfLines = 2;
    NSLog(@"%@",_dict);
    className.text = [_dict stringValueForKey:@"video_title" defaultValue:@""];
    if ([_typeStr integerValue] == 3) {
        className.text = [_dict stringValueForKey:@"course_name" defaultValue:@""];
    }
    if ([_typeStr integerValue] == 4) {
        className.text = [NSString stringWithFormat:@"%@",[_dict objectForKey:@"album_title"]];
    }
    if (_cellDict != nil) {//单课时解锁
        className.text = [NSString stringWithFormat:@"%@—————%@",[_dict stringValueForKey:@"video_title"],[_cellDict stringValueForKey:@"title"]];
    }
    className.font = Font(12 * WideEachUnit);
    className.textColor = [UIColor colorWithHexString:@"#333"];
    [_classInformationView addSubview:className];
    
    //添加课程价格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(130 * WideEachUnit, 86 * WideEachUnit,MainScreenWidth - 140 * WideEachUnit, 20 * WideEachUnit)];
    price.font = Font(14 * WideEachUnit);
    price.textColor = [UIColor colorWithHexString:@"#fc0203"];
    price.text = [NSString stringWithFormat:@"育币%@",[_dict stringValueForKey:@"price"]];
    if (SWNOTEmptyDictionary(_activityInfo)) {
        NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
            price.text = [NSString stringWithFormat:@"育币 %@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
            if (_isJoinGroup) {
                price.text = [NSString stringWithFormat:@"育币 %@",[_activityInfo objectForKey:@"event_price_other"]];
            } else {
                price.text = [NSString stringWithFormat:@"育币 %@",[_activityInfo objectForKey:@"event_price"]];
            }
        }
    }
    if (_cellDict != nil) {//单课时解锁
        price.text = [NSString stringWithFormat:@"育币%@",[_cellDict stringValueForKey:@"course_hour_price"]];
    }
    [_classInformationView addSubview:price];
    
    
    
}
- (void)addPayView {
    _payView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_classInformationView.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 36 * WideEachUnit)];
    _payView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_payView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0,MainScreenWidth - 40 * WideEachUnit, 36 * WideEachUnit)];
    title.text = @"支付方式";
    title.font = Font(13 * WideEachUnit);
    title.textColor = [UIColor colorWithHexString:@"#888"];
    [_payView addSubview:title];
    
//    //添加线
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 36 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit, 1 * WideEachUnit)];
//    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [_payView addSubview:line];
//    
//    CGFloat viewW = MainScreenWidth - 30 * WideEachUnit;
//    CGFloat viewH = 50 * WideEachUnit;
//    
//    NSArray *imageArray = @[@"Alipay@3x",@"weixinpay@3x"];
//    
//    for (int i = 0 ; i < 2 ; i ++) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 36 * WideEachUnit + viewH * i, viewW, viewH)];
//        view.backgroundColor = [UIColor whiteColor];
//        view.layer.borderWidth = 0.5 * WideEachUnit;
//        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
//        [_payView addSubview:view];
//        
//        
//        UIButton *payTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit,0, 80 * WideEachUnit, 50 * WideEachUnit)];
//        [payTypeButton setImage:Image(imageArray[i]) forState:UIControlStateNormal];
//        [view addSubview:payTypeButton];
//        
//        
//        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 40 * WideEachUnit,0, 30 * WideEachUnit, 50 * WideEachUnit)];
//        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
//        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
//        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
//        seleButton.tag = i;
//        if (i == 0) {//支付宝
//            _ailpaySeleButton = seleButton;
//            _ailpaySeleButton.selected = YES;
//        } else {//微信
//            _wxSeleButton = seleButton;
//            _wxSeleButton.selected = NO;
//        }
//        [view addSubview:seleButton];
//        
//        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
//        allClearButton.backgroundColor = [UIColor clearColor];
//        allClearButton.tag = i;
//        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:allClearButton];
//        
//    }
    
}


- (void)addAliPayView {
    
    _alipayView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_classInformationView.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit)];
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
        _alipayStr = @"1";
        CGFloat viewW = MainScreenWidth - 30 * WideEachUnit;
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
        
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50 - 20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
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
        _alipayView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_classInformationView.frame) + 10 * WideEachUnit, 0, 0 * WideEachUnit);
    }
}


- (void)addWxPayView {
    _wxpayView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_alipayView.frame), MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit)];
    _wxpayView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_wxpayView];
    
    //判断是否应该有此支付方式
    BOOL isAddWxpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"wxpay"]) {
            isAddWxpayView = YES;
        }
    }
    
    if (isAddWxpayView) {//有微信
        
        CGFloat viewW = MainScreenWidth - 30 * WideEachUnit;
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
        if (_alipayView.frame.size.height == 0) {
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
    _balanceView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_wxpayView.frame), MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit)];
    _balanceView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_balanceView];
    
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
        UILabel *residue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 0,MainScreenWidth - title.right - 30 * WideEachUnit - 40 * WideEachUnit, 50 * WideEachUnit)];
//        residue.text = @"100";
        residue.font = Font(14 * WideEachUnit);
        residue.textColor = [UIColor colorWithHexString:@"#888"];
        [_balanceView addSubview:residue];
        _residue = residue;
        _residue.text = [NSString stringWithFormat:@"(当前育币%@)",[_userBalanceDict stringValueForKey:@"learn" defaultValue:@"0"]];
        if (isHaveBanlance) {//说明是余额
            residue.text = [NSString stringWithFormat:@"(%@)",[_testDict stringValueForKey:@"pay_type_note"]];
        }
        
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

- (void)addDiscountView {
    _discountView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_balanceView.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 44 * WideEachUnit * 2 + 1 * WideEachUnit)];
    _discountView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_discountView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0,MainScreenWidth - 40 * WideEachUnit, 44 * WideEachUnit)];
    title.text = @"优惠券";
    title.font = Font(13 * WideEachUnit);
    title.textColor = [UIColor colorWithHexString:@"#888"];
    [_discountView addSubview:title];
    
    //添加优惠券的相关信息
    UILabel *reminderDiscount = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 140 * WideEachUnit, 0,80 * WideEachUnit, 44 * WideEachUnit)];
    if (_counpArray.count == 0) {
        reminderDiscount.text = @"无可用优惠券";
    } else if (_counpArray.count > 0) {
        reminderDiscount.text = @"有可用优惠券";
    }
    reminderDiscount.font = Font(12 * WideEachUnit);
    reminderDiscount.textColor = [UIColor colorWithHexString:@"#ccc"];
    reminderDiscount.textAlignment = NSTextAlignmentRight;
    _reminderDiscount = reminderDiscount;
    [_discountView addSubview:reminderDiscount];
    
    //添加箭头
    UIButton *arrowsButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 12 * WideEachUnit, 20 * WideEachUnit, 20 * WideEachUnit)];
    [arrowsButton setBackgroundImage:Image(@"考试右@2x") forState:UIControlStateNormal];
    [_discountView addSubview:arrowsButton];
    
    UIButton *discountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30 * WideEachUnit, 44 * WideEachUnit)];
    discountButton.backgroundColor = [UIColor clearColor];
    [discountButton addTarget:self action:@selector(discountButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_discountView addSubview:discountButton];
    
    //添加中间的线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * WideEachUnit, MainScreenWidth, WideEachUnit)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_discountView addSubview:lineButton];
    
    
    //添加箭头
    UIButton *entityArrowsButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 12 * WideEachUnit + 44 * WideEachUnit, 20 * WideEachUnit, 20 * WideEachUnit)];
    [entityArrowsButton setBackgroundImage:Image(@"考试右@2x") forState:UIControlStateNormal];
    [_discountView addSubview:entityArrowsButton];

    //添加实体卡的界面
    UILabel *entityTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 45 * WideEachUnit,MainScreenWidth - 40 * WideEachUnit, 44 * WideEachUnit)];
    entityTitle.text = @"实体卡";
    entityTitle.font = Font(13 * WideEachUnit);
    entityTitle.textColor = [UIColor colorWithHexString:@"#888"];
    [_discountView addSubview:entityTitle];
    
    //添加实体卡的相关信息
    UILabel *entityDiscount = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 140 * WideEachUnit, 44 * WideEachUnit,80 * WideEachUnit, 44 * WideEachUnit)];
    entityDiscount.text = @"";
    entityDiscount.font = Font(12 * WideEachUnit);
    entityDiscount.textColor = [UIColor colorWithHexString:@"#ccc"];
    entityDiscount.textAlignment = NSTextAlignmentRight;
    _entityDiscount = entityDiscount;
    [_discountView addSubview:entityDiscount];
    
    //添加透明的按钮
    UIButton *entityGoToUseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 44 * WideEachUnit)];
    entityGoToUseButton.backgroundColor = [UIColor clearColor];
    [entityGoToUseButton addTarget:self action:@selector(entityGoToUseButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_discountView addSubview:entityGoToUseButton];
    
//
//    //添加实体卡去使用的按钮
//    UIButton *entityGoToUseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, 45 * WideEachUnit,50 * WideEachUnit, 44 * WideEachUnit)];
//    entityGoToUseButton.backgroundColor = BasidColor;
//    [entityGoToUseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [entityGoToUseButton setTitle:@"去使用" forState:UIControlStateNormal];
//    entityGoToUseButton.titleLabel.font = Font(14 * WideEachUnit);
//    [entityGoToUseButton addTarget:self action:@selector(entityGoToUseButtonCilck) forControlEvents:UIControlEventTouchUpInside];
//    [_discountView addSubview:entityGoToUseButton];
//    _entityGoToUseButton = entityGoToUseButton;
    
    
    if ([_typeStr integerValue] == 3 || (_alipayView.height == 0 && _wxpayView.height == 0 && _balanceView.height != 0)) {
        _discountView.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_balanceView.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit,0);
        [_discountView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}
- (void)addMoneyView {
    _moneyView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_discountView.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 70 * WideEachUnit)];
    _moneyView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_moneyView];
    
    //判断单课时
    if (_cellDict) {//单课时
        _moneyView.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_balanceView.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 70 * WideEachUnit);
        _discountView.hidden = YES;
    }
    
    CGFloat labelW = (MainScreenWidth - 30 * WideEachUnit) / 2;
    CGFloat labelH = 35 * WideEachUnit;
    NSArray *titleArray = @[@"商品金额",@"优惠折扣"];
    for (int i = 0 ; i < 2 ; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, labelH * i, labelW, labelH)];
        label.text = titleArray[i];
        label.textColor = [UIColor colorWithHexString:@"#888"];
        label.font = Font(14 * WideEachUnit);
        [_moneyView addSubview:label];
        
        
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelW, labelH * i, labelW - 10 * WideEachUnit, labelH)];
        if (i == 0) {//原价
            moneyLabel.text = [NSString stringWithFormat:@"育币%@",[_dict stringValueForKey:@"price"]];
            if (SWNOTEmptyDictionary(_activityInfo)) {
                NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
                if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
                    moneyLabel.text = [NSString stringWithFormat:@"育币 %@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
                    if (_isJoinGroup) {
                        moneyLabel.text = [NSString stringWithFormat:@"育币 %@",[_activityInfo objectForKey:@"event_price_other"]];
                    } else {
                        moneyLabel.text = [NSString stringWithFormat:@"育币 %@",[_activityInfo objectForKey:@"event_price"]];
                    }
                }
            }
            if (_cellDict != nil) {
                 moneyLabel.text = [NSString stringWithFormat:@"育币%@",[_cellDict stringValueForKey:@"course_hour_price"]];
            }
        } else {//优惠
            _discountMoneyLabel = moneyLabel;
            _discountMoneyLabel.text = @"-育币0.0";
        }
        moneyLabel.textColor = [UIColor colorWithHexString:@"#fc0203"];
        moneyLabel.font = Font(14 * WideEachUnit);
        moneyLabel.textAlignment = NSTextAlignmentRight;
        [_moneyView addSubview:moneyLabel];
        
    }
    
    if ([_typeStr integerValue] == 3 || (_alipayView.height == 0 && _wxpayView.height == 0 && _balanceView.height != 0)) {
        _moneyView.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_discountView.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 0);
        [_moneyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}
- (void)addAgreeView {
    _agreeView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_moneyView.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 44 * WideEachUnit)];
    _agreeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_agreeView];
    
    if ([_typeStr integerValue] == 3) {
        _agreeView.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_moneyView.frame) - 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 44 * WideEachUnit);
    }
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
    
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight);
}
- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0,MainScreenHeight - 49 * WideEachUnit - MACRO_UI_SAFEAREA, MainScreenWidth, 49 * WideEachUnit + MACRO_UI_SAFEAREA)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //实际付钱
    UILabel *realTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 105 * WideEachUnit, 49 * WideEachUnit)];
    realTitle.text = @"实付:";
    realTitle.font = Font(14 * WideEachUnit);
    realTitle.textColor = [UIColor colorWithHexString:@"#888"];
    realTitle.textAlignment = NSTextAlignmentRight;
    [_downView addSubview:realTitle];
    
    //实际钱
    UILabel *realMoney = [[UILabel alloc] initWithFrame:CGRectMake(115 * WideEachUnit, 0, 90 * WideEachUnit, 49 * WideEachUnit)];
    realMoney.text = [NSString stringWithFormat:@"育币%@",[_dict stringValueForKey:@"price"]];
    if (SWNOTEmptyDictionary(_activityInfo)) {
        NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
            realMoney.text = [NSString stringWithFormat:@"育币 %@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
            if (_isJoinGroup) {
                realMoney.text = [NSString stringWithFormat:@"育币 %@",[_activityInfo objectForKey:@"event_price_other"]];
            } else {
                realMoney.text = [NSString stringWithFormat:@"育币 %@",[_activityInfo objectForKey:@"event_price"]];
            }
        }
    }
    if (_cellDict != nil) {
        realMoney.text = [NSString stringWithFormat:@"育币%@",[_cellDict stringValueForKey:@"course_hour_price"]];
    }
    realMoney.font = Font(16 * WideEachUnit);
    realMoney.textColor = [UIColor colorWithHexString:@"#fc0203"];
    [_downView addSubview:realMoney];
    _realMoney = realMoney;
    
    
    //添加提交订单按钮
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 170 * WideEachUnit, 0, 170 * WideEachUnit, 49 * WideEachUnit)];
    [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    _submitButton.backgroundColor = BasidColor;
    [_submitButton addTarget:self action:@selector(submitButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:_submitButton];
    
}


#pragma mark --- 按钮点击事件

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

//优惠券的按钮
- (void)discountButtonCilck {
    if (_counpArray.count == 0) {
        [TKProgressHUD showError:@"无可用优惠券" toView:self.view];
        return;
    }
    if (_entityDiscount.text.length > 0) {//说明已经使用实体卡了 不能再用优惠券了
        [TKProgressHUD showError:@"已经使用实体卡" toView:self.view];
        return;
    }
    
    Good_DiscountMainViewController *vc = [[Good_DiscountMainViewController alloc] init];
    if (SWNOTEmptyDictionary(_activityInfo)) {
        if ([[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"] integerValue] == 6) {
            
        } else {
            if ([[_activityInfo objectForKey:@"is_start"] integerValue]) {
                vc.showYouhui = YES;
            }
        }
    }
    vc.ID = _cid;
    vc.dict = _dict;
    vc.isCombo = [_typeStr isEqualToString:@"4"] ? YES : NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)entityGoToUseButtonCilck {
    if (SWNOTEmptyDictionary(_activityInfo)) {
        if ([[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"] integerValue] == 6) {
            return;
        }
    }
    EntityCardViewController *vc = [[EntityCardViewController alloc] init];
    vc.dict = _dict;
    vc.activityInfo = [NSDictionary dictionaryWithDictionary:_activityInfo];
    if (_entityReturnDict != nil) {
        vc.entityDict = _entityReturnDict;
    }
    vc.isCombo = [_typeStr isEqualToString:@"4"] ? YES : NO;
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
    if ([_payTypeStr integerValue] == 0) {
        [TKProgressHUD showError:@"暂无支付方式可选" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    if ([[_dict stringValueForKey:@"price"] floatValue] == 0) {//免费
        [self netWorkOrderAddFreeOrder];
        return;
    }
    if ([_typeStr integerValue] == 1) {//课程
        if (_cellDict != nil) {//单课时解锁
            [self netWorkCourseBuyCourseHourById];
        } else {
            [self netWorkCourseCourseBuyVideo];
        }
    } else if ([_typeStr integerValue] == 2) {//直播
        if (_cellDict != nil) {//单课时解锁
            [self netWorkCourseBuyCourseHourById];
        } else {
            [self netWorkCourseCourseBuyLive];
        }
    } else if ([_typeStr integerValue] == 3) {//线下课
        [self netWorkCourseCourseBuyLineCourse];
    } else if ([_typeStr integerValue] == 4) {
        // 套餐
        [self payForCombo];
    } else if ([_typeStr integerValue] == 5) {
        //班级购买
        if (_cellDict != nil) {//单课时解锁
            [self netWorkCourseBuyCourseHourById];
        } else {
            [self classBuy];
        }
    }
}

- (void)pactButtonCilck {
    BuyAgreementViewController *vc = [[BuyAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 获取通知
- (void)getDiscount:(NSNotification *)not {
    
    NSDictionary *dict = (NSDictionary *)not.object;
    if ([[dict stringValueForKey:@"type"] integerValue] == 1) {//优惠券
        _reminderDiscount.text = [NSString stringWithFormat:@"优惠券 %@",[dict stringValueForKey:@"price"]];
        _discountMoneyLabel.text = [NSString stringWithFormat:@"-育币%@",[dict stringValueForKey:@"price"]];
        CGFloat money1 = [[_dict stringValueForKey:@"price"] floatValue];
        if (SWNOTEmptyDictionary(_activityInfo)) {
            NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
            if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
                money1 = [[NSString stringWithFormat:@"%@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]] floatValue];
            }
        }
        CGFloat discount1 = [[dict stringValueForKey:@"price"] floatValue];
        _realMoney.text = [NSString stringWithFormat:@"育币%1f",money1 - discount1];
        NSString *money2 = [NSString stringWithFormat:@"育币%.2f",money1 - discount1];
        _realMoney.text = money2;
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 2) {//大折卡
        _reminderDiscount.text = [NSString stringWithFormat:@"打折卡 %@折",[dict stringValueForKey:@"discount"]];
        _discountMoneyLabel.text = [NSString stringWithFormat:@"-%@折",[dict stringValueForKey:@"discount"]];
        CGFloat money1 = [[_dict stringValueForKey:@"price"] floatValue];
        if (SWNOTEmptyDictionary(_activityInfo)) {
            NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
            if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
                money1 = [[NSString stringWithFormat:@"%@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]] floatValue];
            }
        }
        CGFloat discount1 = [[dict stringValueForKey:@"discount"] integerValue];
        _realMoney.text = [NSString stringWithFormat:@"育币%1f",money1 * discount1 / 10];
        NSString *money2 = [NSString stringWithFormat:@"育币%.2f",money1 * discount1 / 10];
        _realMoney.text = money2;
        _discountMoneyLabel.text = [NSString stringWithFormat:@"-育币%.2f",[[_dict stringValueForKey:@"price"] floatValue] - money1 * discount1 / 10];
        if (SWNOTEmptyDictionary(_activityInfo)) {
            NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
            if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
                _discountMoneyLabel.text = [NSString stringWithFormat:@"-育币%.2f",[[NSString stringWithFormat:@"%@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]] floatValue] - money1 * discount1 / 10];
            }
        }
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 3) {
        _reminderDiscount.text = [NSString stringWithFormat:@"会员卡 %@",[dict stringValueForKey:@"discount"]];
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 4) {
        _reminderDiscount.text = [NSString stringWithFormat:@"充值卡 %@",[dict stringValueForKey:@"price"]];
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 5) {
        _reminderDiscount.text = @"课程卡";
        _realMoney.text = @"0育币";
        _discountMoneyLabel.text = [NSString stringWithFormat:@"-育币%@",[_dict stringValueForKey:@"price"]];
        if (SWNOTEmptyDictionary(_activityInfo)) {
            NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
            if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
                _discountMoneyLabel.text = [NSString stringWithFormat:@"-育币%@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
            }
        }
    }

    _counpID = [dict stringValueForKey:@"coupon_id"];
    
}

- (void)getEntityCardUse:(NSNotification *)not {
    _entityReturnDict = not.object;
    if (_entityReturnDict == nil) {
        _reminderDiscount.text = @"使用优惠券";
         _entityDiscount.text = @"";
        _discountMoneyLabel.text = [NSString stringWithFormat:@"-育币0.0"];
        _realMoney.text = [NSString stringWithFormat:@"育币%@",[_dict stringValueForKey:@"price"]];
        if (SWNOTEmptyDictionary(_activityInfo)) {
            NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
            if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
                _realMoney.text = [NSString stringWithFormat:@"育币%@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
            }
        }
        return;
    }
//    _discountView.backgroundColor = [UIColor lightGrayColor];
//    [_entityGoToUseButton setTitle:@"取消" forState:UIControlStateNormal];
//    _entityGoToUseButton.backgroundColor = [UIColor redColor];
    _reminderDiscount.text = @"已使用实体卡";
    
    if ([[_entityReturnDict stringValueForKey:@"type"] integerValue] == 1) {//优惠券
        _entityDiscount.text = [NSString stringWithFormat:@"优惠券 %@",[_entityReturnDict stringValueForKey:@"price"]];
        _discountMoneyLabel.text = [NSString stringWithFormat:@"-育币%@",[_entityReturnDict stringValueForKey:@"price"]];
        CGFloat money1 = [[_dict stringValueForKey:@"price"] floatValue];
        if (SWNOTEmptyDictionary(_activityInfo)) {
            NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
            if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
                money1 = [[NSString stringWithFormat:@"%@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]] floatValue];
            }
        }
        CGFloat discount1 = [[_entityReturnDict stringValueForKey:@"price"] floatValue];
        _realMoney.text = [NSString stringWithFormat:@"育币%2f",money1 - discount1];
        NSString *money2 = [NSString stringWithFormat:@"育币%.2f",money1 - discount1];
        _realMoney.text = money2;
    } else if ([[_entityReturnDict stringValueForKey:@"type"] integerValue] == 2) {//打折卡
        _entityDiscount.text = [NSString stringWithFormat:@"打折卡 %@折",[_entityReturnDict stringValueForKey:@"discount"]];
        _discountMoneyLabel.text = [NSString stringWithFormat:@"-%@折",[_entityReturnDict stringValueForKey:@"price"]];
        CGFloat money1 = [[_dict stringValueForKey:@"price"] floatValue];
        if (SWNOTEmptyDictionary(_activityInfo)) {
            NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
            if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
                money1 = [[NSString stringWithFormat:@"%@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]] floatValue];
            }
        }
        CGFloat discount1 = [[_entityReturnDict stringValueForKey:@"discount"] integerValue];
        _realMoney.text = [NSString stringWithFormat:@"育币%1f",money1 * discount1 / 10];
        NSString *money2 = [NSString stringWithFormat:@"育币%.2f",money1 * discount1 / 10];
        _realMoney.text = money2;
    } else if ([[_entityReturnDict stringValueForKey:@"type"] integerValue] == 3) {//会员卡
        
    } else if ([[_entityReturnDict stringValueForKey:@"type"] integerValue] == 4) {//充值卡
        
    } else if ([[_entityReturnDict stringValueForKey:@"type"] integerValue] == 5) {//课程卡
        _realMoney.text = @"0育币";
        _discountMoneyLabel.text = [NSString stringWithFormat:@"-育币%@",[_dict stringValueForKey:@"price"]];
        _counpID = [_entityReturnDict stringValueForKey:@"coupon_id"];
        if (SWNOTEmptyDictionary(_activityInfo)) {
            NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
            if ([eventType integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1 && _isBuyAlone) {
                _discountMoneyLabel.text = [NSString stringWithFormat:@"-育币%@",[[_dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
            }
        }
    }
    
    _counpID = [_entityReturnDict stringValueForKey:@"coupon_id"];
}

- (void)APPWillEnterForeground:(NSNotification *)not {
    NSString *objectStr = (NSString *)not.object;
    if ([objectStr integerValue] == 1) {
        [self backPressed];//退出当前页面
        if ([_typeStr integerValue] == 1) {//课程
            [self netWorkVideoGetInfo];
        } else if ([_typeStr integerValue] == 2) {//直播
            [self netWorkLiveGetInfo];
        } else if ([_typeStr integerValue] == 3) {//线下课
            
        }
    }
}

#pragma mark --- webView
- (void)addWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    _webView.backgroundColor = [UIColor clearColor];
    //    _webView.center = self.view.center;
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

#pragma mark --- webViewDelegate


#pragma mark --- 网络请求
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




#pragma mark --- 获取优惠券的类型

#pragma mark --- 网络请求
//获取制定课程的优惠券
- (void)netWorkVideoGetCanUseCouponList {//
    
    NSString *endUrlStr = YunKeTang_Video_video_getCanUseCouponList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"1" forKey:@"page"];
    [mutabDict setValue:@"20" forKey:@"count"];
    [mutabDict setValue:_cid forKey:@"id"];
    
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
            [_counpArray removeAllObjects];
            [_counpArray addObjectsFromArray:(NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
            if (SWNOTEmptyDictionary(_activityInfo) && _isBuyAlone) {
                if ([[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"] integerValue] == 6 && [[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                    [_counpArray removeAllObjects];
                } else {
                    if ([[_activityInfo objectForKey:@"is_start"] integerValue] && SWNOTEmptyArr(_counpArray)) {
                        for (int i = (int)(_counpArray.count - 1); i>=0; i--) {
                            if ([[_counpArray[i] stringValueForKey:@"type"] integerValue] != 5) {
                                [_counpArray removeObjectAtIndex:i];
                            }
                        }
                    }
                }
            }
            if (_counpArray.count == 0) {
                _reminderDiscount.text = @"无可用优惠券";
            } else if (_counpArray.count > 0) {
                _reminderDiscount.text = @"有可用优惠券";
            }
            _stasutStr = _reminderDiscount.text;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取指定套餐的优惠券
- (void)netWorkComboGetCanUseCouponList {//
    
    NSString *endUrlStr = album_getCanUseCouponList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"1" forKey:@"page"];
    [mutabDict setValue:@"20" forKey:@"count"];
    [mutabDict setValue:_cid forKey:@"album_id"];
    [mutabDict setObject:@"0" forKey:@"canot"];
    
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
            [_counpArray removeAllObjects];
            [_counpArray addObjectsFromArray:(NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] && SWNOTEmptyArr(_counpArray)) {
                for (int i = (int)(_counpArray.count - 1); i>=0; i--) {
                    if ([[_counpArray[i] stringValueForKey:@"type"] integerValue] != 5) {
                        [_counpArray removeObjectAtIndex:i];
                    }
                }
            }
            if (_counpArray.count == 0) {
                _reminderDiscount.text = @"无可用优惠券";
            } else if (_counpArray.count > 0) {
                _reminderDiscount.text = @"有可用优惠券";
            }
            _stasutStr = _reminderDiscount.text;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




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
        [self addBalanceView];
        [self addDiscountView];
        [self addMoneyView];
        [self addAgreeView];
        [self addDownView];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            _payTypeArray = [dict arrayValueForKey:@"pay"];
            [self addAliPayView];
            [self addWxPayView];
            [self addBalanceView];
            [self addDiscountView];
            [self addMoneyView];
            [self addAgreeView];
            [self addDownView];
        } else {
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//解锁课程
- (void)netWorkCourseCourseBuyVideo {
    
    NSString *endUrlStr = YunKeTang_Course_Course_buyVideo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:_cid forKey:@"vids"];
    if (_counpID) {
        [mutabDict setValue:_counpID forKey:@"coupon_id"];
    }
    if (SWNOTEmptyDictionary(_activityInfo) && _isBuyAlone) {
        NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        if ([eventType integerValue] == 6) {
            if ([[_activityInfo objectForKey:@"is_start"] integerValue]) {
                //拼团
                if (_isJoinGroup && SWNOTEmptyStr(_groupID)) {
                    [mutabDict setObject:_groupID forKey:@"asb"];
                } else {
                    [mutabDict setObject:@"asb_ep" forKey:@"asb"];
                }
            }
        }
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
            if ([[_entityReturnDict stringValueForKey:@"type"] integerValue] == 5) {//课程卡
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
                return;
            }
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
            }
        } else {
                [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//解锁课程
- (void)netWorkCourseBuyCourseHourById {
    
    NSString *endUrlStr = YunKeTang_Course_Course_buyCourseHourById;
    if ([_typeStr integerValue] == 5) {
        endUrlStr = course_buyClassesHourById;
    }
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    if ([_typeStr integerValue] == 1) {//课程
        [mutabDict setValue:@"1" forKey:@"vtype"];
    } else if ([_typeStr integerValue] == 2) {//直播
        [mutabDict setValue:@"2" forKey:@"vtype"];
    } else if ([_typeStr integerValue] == 5) {//直播
        [mutabDict setValue:@"6" forKey:@"vtype"];
    }
    [mutabDict setValue:_cid forKey:@"vid"];
    if (_cellDict != nil) {
        if ([_typeStr integerValue] == 1) {//课程
             [mutabDict setValue:[_cellDict stringValueForKey:@"id"] forKey:@"sid"];
        } else if ([_typeStr integerValue] == 2){//直播
             [mutabDict setValue:[_cellDict stringValueForKey:@"id"] forKey:@"sid"];
        } else if ([_typeStr integerValue] == 5){//班级课
            [mutabDict setValue:[_cellDict stringValueForKey:@"id"] forKey:@"sid"];
        }
    }
    
    if (_counpID) {
        [mutabDict setValue:_counpID forKey:@"coupon_id"];
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
            if ([[_entityReturnDict stringValueForKey:@"type"] integerValue] == 5) {//课程卡
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
                return ;
            }
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//解锁直播
- (void)netWorkCourseCourseBuyLive {
    
    NSString *endUrlStr = YunKeTang_Course_Course_buyLive;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];

    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:_cid forKey:@"live_id"];
    if (_counpID) {
        [mutabDict setValue:_counpID forKey:@"coupon_id"];
    }
    if (SWNOTEmptyDictionary(_activityInfo) && _isBuyAlone) {
        NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        if ([eventType integerValue] == 6) {
            if ([[_activityInfo objectForKey:@"is_start"] integerValue]) {
                //拼团
                if (_isJoinGroup && SWNOTEmptyStr(_groupID)) {
                    [mutabDict setObject:_groupID forKey:@"asb"];
                } else {
                    [mutabDict setObject:@"asb_ep" forKey:@"asb"];
                }
            }
        }
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
            if ([[_entityReturnDict stringValueForKey:@"type"] integerValue] == 5) {//课程卡
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
                return ;
            }
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [self netWorkCourseCourseBuyLive];//失败的话就再买一次
    }];
    [op start];
}



//解锁线下课
- (void)netWorkCourseCourseBuyLineCourse {
    
    NSString *endUrlStr = YunKeTang_Course_Course_buyLineCourse;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:_cid forKey:@"vids"];
    if (_counpID) {
        [mutabDict setValue:_counpID forKey:@"coupon_id"];
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
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//加入看单（免费解锁）
- (void)netWorkOrderAddFreeOrder {
    
    NSString *endUrlStr = YunKeTang_Order_order_addFreeOrder;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([_typeStr integerValue] == 1) {//课程
        [mutabDict setValue:@"1" forKey:@"vtype"];
    } else if ([_typeStr integerValue] == 2) {//直播
        [mutabDict setValue:@"2" forKey:@"vtype"];
    } else if ([_typeStr integerValue] == 3) {//线下课
        [mutabDict setValue:@"4" forKey:@"vtype"];
    } else if ([_typeStr integerValue] == 5) {//线下课
        [mutabDict setValue:@"6" forKey:@"vtype"];
    }
    [mutabDict setValue:_cid forKey:@"vid"];
    if (_counpID) {
        [mutabDict setValue:_counpID forKey:@"coupon_id"];
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            [self backPressed];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)classBuy {
    NSString *endUrlStr = course_buyClasses;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:_cid forKey:@"vids"];
    if (_counpID) {
        [mutabDict setValue:_counpID forKey:@"coupon_id"];
    }
    if (SWNOTEmptyDictionary(_activityInfo) && _isBuyAlone) {
        NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        if ([eventType integerValue] == 6) {
            if ([[_activityInfo objectForKey:@"is_start"] integerValue]) {
                //拼团
                if (_isJoinGroup && SWNOTEmptyStr(_groupID)) {
                    [mutabDict setObject:_groupID forKey:@"asb"];
                } else {
                    [mutabDict setObject:@"asb_ep" forKey:@"asb"];
                }
            }
        }
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
            if ([[_entityReturnDict stringValueForKey:@"type"] integerValue] == 5) {//课程卡
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
                return;
            }
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取课程详情
- (void)netWorkVideoGetInfo {
    
    NSString *endUrlStr = YunKeTang_Video_video_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_cid forKey:@"id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _videoDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_videoDataSource stringValueForKey:@"code"] integerValue] == 1) {
            if ([[_videoDataSource dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _videoDataSource = [_videoDataSource dictionaryValueForKey:@"data"];
            } else {
                _videoDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            if ([[_videoDataSource stringValueForKey:@"is_buy"] integerValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [TKProgressHUD showError:@"支付成功" toView:[UIApplication sharedApplication].keyWindow];
                });
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [TKProgressHUD showError:@"支付失败" toView:[UIApplication sharedApplication].keyWindow];
                });
            }
        }

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [TKProgressHUD showError:@"请求错误" toView:self.view];
        [self backPressed];
    }];
    [op start];
}


//直播详情
- (void)netWorkLiveGetInfo {
    
    NSString *endUrlStr = YunKeTang_Live_live_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_cid forKey:@"live_id"];
    
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
                dict = [dict dictionaryValueForKey:@"data"];
            } else {
                dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [TKProgressHUD showError:@"支付成功" toView:[UIApplication sharedApplication].keyWindow];
                });
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [TKProgressHUD showError:@"支付失败" toView:[UIApplication sharedApplication].keyWindow];
                });
            }
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [TKProgressHUD showError:@"支付失败" toView:[UIApplication sharedApplication].keyWindow];
            });
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//线下课的详情
- (void)netWorkLineVideoGetInfo {
    
    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_cid == nil) {
        return;
    }
    [mutabDict setObject:_cid forKey:@"id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                dict = [dict dictionaryValueForKey:@"data"];
            } else {
                dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [TKProgressHUD showError:@"支付成功" toView:[UIApplication sharedApplication].keyWindow];
                });
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [TKProgressHUD showError:@"支付失败" toView:[UIApplication sharedApplication].keyWindow];
                });
            }
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [TKProgressHUD showError:@"支付失败" toView:[UIApplication sharedApplication].keyWindow];
            });
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
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

// MARK: - 解锁套餐
- (void)payForCombo {
    NSString *endUrlStr = Pay_Combo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:_cid forKey:@"album_id"];
    if (_counpID) {
        [mutabDict setValue:_counpID forKey:@"coupon_id"];
    }
    if (SWNOTEmptyDictionary(_activityInfo) && _isBuyAlone) {
        NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        if ([eventType integerValue] == 6) {
            if ([[_activityInfo objectForKey:@"is_start"] integerValue]) {
                //拼团
                if (_isJoinGroup && SWNOTEmptyStr(_groupID)) {
                    [mutabDict setObject:_groupID forKey:@"asb"];
                } else {
                    [mutabDict setObject:@"asb_ep" forKey:@"asb"];
                }
            }
        }
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
            if ([[_entityReturnDict stringValueForKey:@"type"] integerValue] == 5) {//课程卡
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
                return;
            }
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
                isGoOut = YES;
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self backPressed];
                });
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

@end
