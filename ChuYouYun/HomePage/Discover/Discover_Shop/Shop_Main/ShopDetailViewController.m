//
//  ShopDetailViewController.m
//  dafengche
//
//  Created by IOS on 16/10/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//
#define rate MainScreenWidth/375
#define verticalrate  MainScreenHeight/667

#import "ShopDetailViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "UIView+Utils.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "ManageAddressViewController.h"
#import "ShopManagerAdressViewController.h"
#import "DLViewController.h"
#import "TKProgressHUD+Add.h"


@interface ShopDetailViewController ()<UIWebViewDelegate>{
    
    //标题
    UILabel *_titleLab;

    //兑换的个数
    UILabel *_Num;
    int _numValue;
    UIButton *_sureBtn;
    NSString *_IDStr;
    
    NSString *_num;
    UILabel *_moeyLab;
    UILabel *_numlab;
    
    UILabel *needSroce;
    UILabel *needMoney;
    UILabel *needMoneyTwo;
    
    //中间
    UILabel *_numlable;
    //快递运费
    UILabel *_peisong1;
    //地址
    UILabel *_jianjie1;
    //ID
    NSString * _goods_id;
    UIImageView *imgV;
    
    NSString *_adress;
    NSDictionary *_dic;
    NSString *_adress_id;
    BOOL      isHaveDefault;
    BOOL      isHaveAilPay;
    BOOL      isHaveWxPay;
}

@property (strong ,nonatomic)UIScrollView *mainScrollView;
@property (strong ,nonatomic)UIView       *twoView;
@property (strong ,nonatomic)UIView       *allWindowView;
@property (strong ,nonatomic)UIWebView    *webView;

@property (strong ,nonatomic)UIButton   *aliSeleButton;
@property (strong ,nonatomic)UIButton   *wxSeleButton;
@property (strong ,nonatomic)UIButton   *balanceSeleButton;
@property (strong ,nonatomic)UILabel    *pricePay;

@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *GLdataArray;

@property (strong ,nonatomic)NSDictionary   *addressDict;
@property (strong ,nonatomic)NSArray        *addressArray;
@property (strong ,nonatomic)NSDictionary   *payDataSource;


@property (strong ,nonatomic)NSString       *sokteStr;//库存字段
@property (strong ,nonatomic)NSString       *payTypeStr;
@property (strong ,nonatomic)NSString       *alipayStr;
@property (strong ,nonatomic)NSDictionary   *userAccountDict;
@property (strong ,nonatomic)NSDictionary   *wxPayDict;


@end

@implementation ShopDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];

    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    if (_peisong1) {
        if (_addressDict == nil) {
//            [self setDefaultRequest];
        } else {
        }
    }
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

-(instancetype)initWithID:(NSString *)IDStr{

    self = [super init];
    
    if (self) {
        
        _IDStr = IDStr;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setDefaultRequest];
    [self interFace];
    [self payTypeArrayDeal];
    [self addScrollow];
    [self addNav];
    [self addIMageView];
    [self addView];
    [self netWorkAdressGetMyList];
    [self netWorkUserGetAccount];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddress:) name:@"NSNotificationGetAddress" object:nil];
}
//获取默认地址
-(void)setDefaultRequest{
    
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
//        [TKProgressHUD showError:@"请先登录" toView:self.view];
    } else {
        [dict setObject:UserOathToken forKey:@"oauth_token"];
        [dict setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    [dict setObject:@"1" forKey:@"is_default"];
    
    [manager getpublicPort:dict mod:@"Address" act:@"getAddressList" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"===__===%@",responseObject);

        NSString *msg = responseObject[@"msg"];
    
        if ([msg isEqualToString:@"ok"]) {
            
            NSString *str1 = [[[responseObject arrayValueForKey:@"data"] objectAtIndex:0] stringValueForKey:@"province"];
            NSString *str2 = [[[responseObject arrayValueForKey:@"data"] objectAtIndex:0] stringValueForKey:@"city"];
            NSString *str3 = [[[responseObject arrayValueForKey:@"data"] objectAtIndex:0] stringValueForKey:@"area"];
            
            _adress = [NSString stringWithFormat:@"%@ %@ %@",str1,str2,str3];
            _adress_id = [[[responseObject arrayValueForKey:@"data"] objectAtIndex:0] stringValueForKey:@"address_id"];
            //运费
            NSString *yf = [NSString stringWithFormat:@"%@",_adress];
            _peisong1.text = yf;
            if (_adress == nil) {
                _peisong1.text = @"请选择收货地址";
            }
        } else {
            
//            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)interFace {
    _sokteStr = [_dict stringValueForKey:@"stock"];
    isHaveDefault = NO;
    _payTypeStr = @"1";
}

-(void)addScrollow{
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,-20, MainScreenWidth, MainScreenHeight+20)];
    _mainScrollView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight);
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
    _mainScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight*rate)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"商品详情";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40,40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        titleLab.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
}

- (void)addIMageView {
    imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, 230 * WideEachUnit)];
    [_mainScrollView addSubview:imgV];
    imgV.backgroundColor = [UIColor clearColor];
    [imgV sd_setImageWithURL:[NSURL URLWithString:[_dict stringValueForKey:@"cover"]] placeholderImage:Image(@"站位图")];
}

- (void)addView {
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame) + 10 * WideEachUnit, MainScreenWidth, 89 * WideEachUnit)];
    oneView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:oneView];
    
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    _titleLab.text = [_dict stringValueForKey:@"title"];
    [oneView addSubview:_titleLab];
    _titleLab.font = [UIFont systemFontOfSize:16 * WideEachUnit];
    
    _moeyLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * WideEachUnit, 40 * WideEachUnit, 50 * WideEachUnit ,30 * WideEachUnit)];
    _moeyLab.text = @"所需积分";
    _moeyLab.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _moeyLab.textColor = [UIColor colorWithHexString:@"#888"];
    [oneView addSubview:_moeyLab];
    
    needSroce = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_moeyLab.frame) + 10 * WideEachUnit, 42 * WideEachUnit,MainScreenWidth / 2 - CGRectGetMaxX(_moeyLab.frame) - 10 * WideEachUnit , 25 * WideEachUnit)];
    needSroce.text = [_dict stringValueForKey:@"price"];
    needSroce.textColor = [UIColor colorWithHexString:@"#ed2726"];
    needSroce.font = Font(20 * WideEachUnit);
    [oneView addSubview:needSroce];
    
    //积分配置
    if ([_scoreStaus integerValue] == 0) {
        _moeyLab.text = @"所需金钱";
        needSroce.text = [NSString stringWithFormat:@"%.2f",[[_dict stringValueForKey:@"price"] floatValue] * _percentage];
    }
    
    
    _numlab = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 30 * WideEachUnit, 60*rate, 20*verticalrate)];
    [oneView addSubview:_numlab];
    
    _numlab.textColor = [UIColor colorWithHexString:@"#333333"];
    _numlab.textAlignment = NSTextAlignmentCenter;
    _numlab.font = [UIFont systemFontOfSize:10 * WideEachUnit];
    _numlab.text = [_dict stringValueForKey:@"num"];
    
    UILabel *numlab1 = [[UILabel alloc]initWithFrame:CGRectMake(_numlab.frame.origin.x, _numlab.current_y_h, 60*rate, 25*verticalrate)];
    [oneView addSubview:numlab1];
    numlab1.text = @"兑换人数";
    numlab1.textColor = [UIColor colorWithHexString:@"#c0c2c4"];
    numlab1.textAlignment = NSTextAlignmentCenter;
    numlab1.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 35 * WideEachUnit, 1, 35 * WideEachUnit)];
    [oneView addSubview:lineLab];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    
    //中间
    _numlable = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 120 * WideEachUnit, 30 * WideEachUnit, 60 * WideEachUnit, 20 * WideEachUnit)];
    [oneView addSubview:_numlable];
    _numlable.text = [_dict stringValueForKey:@"stock"];
    _numlable.textColor = [UIColor colorWithHexString:@"#333333"];
    _numlable.textAlignment = NSTextAlignmentCenter;
    _numlable.font = [UIFont systemFontOfSize:11*rate];
    
    UILabel *numlable1 = [[UILabel alloc]initWithFrame:CGRectMake(_numlable.frame.origin.x, _numlable.current_y_h, 60 * WideEachUnit, 25 * WideEachUnit)];
    [oneView addSubview:numlable1];
    numlable1.text = @"仓库剩余";
    numlable1.textColor = [UIColor colorWithHexString:@"#c0c2c4"];
    numlable1.textAlignment = NSTextAlignmentCenter;
    numlable1.font = [UIFont systemFontOfSize:12 * WideEachUnit];

    
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(oneView.frame) + 10 * WideEachUnit, MainScreenWidth, 160 * WideEachUnit)];
    twoView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:twoView];
    _twoView = twoView;
    
    
    //添加快递详情
    //配送
    UILabel *peisong = [[UILabel alloc]initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit,50 * WideEachUnit, 20 * WideEachUnit)];
    [twoView addSubview:peisong];
    peisong.text = @"送至";
    peisong.textAlignment = NSTextAlignmentLeft;
    peisong.textColor = [UIColor grayColor];
    peisong.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    
    _peisong1 = [[UILabel alloc]initWithFrame:CGRectMake(60 * WideEachUnit, 10 * WideEachUnit,MainScreenWidth - 80 * WideEachUnit, 20 * WideEachUnit)];
    [twoView addSubview:_peisong1];
    _peisong1.text = @"请选择收获地址";
    _peisong1.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    _peisong1.textAlignment = NSTextAlignmentLeft;
    _peisong1.textColor = [UIColor colorWithHexString:@"#888"];
    _peisong1.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(peisong.current_x_w ,10 * WideEachUnit,(MainScreenWidth -peisong.current_x_w-10) * WideEachUnit, 20 * WideEachUnit)];
    [twoView addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(adress) forControlEvents:UIControlEventTouchUpInside];
    
    //运费
    needMoney = [[UILabel alloc]initWithFrame:CGRectMake(10 * WideEachUnit, 40 * WideEachUnit,50 * WideEachUnit, 20 * WideEachUnit)];
    [twoView addSubview:needMoney];
    needMoney.text = @"运费";
    needMoney.textAlignment = NSTextAlignmentLeft;
    needMoney.textColor = [UIColor grayColor];
    needMoney.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    
    
    needMoneyTwo = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(needMoney.frame) + 0 * WideEachUnit, 40 * WideEachUnit,50 * WideEachUnit, 20 * WideEachUnit)];
    [twoView addSubview:needMoneyTwo];
    needMoneyTwo.text = [_dict stringValueForKey:@"fare"];
    if ([_scoreStaus integerValue] == 0) {
        needMoneyTwo.text = [NSString stringWithFormat:@"%.2f",[[_dict stringValueForKey:@"fare"] integerValue] * _percentage];
    }
    needMoneyTwo.textAlignment = NSTextAlignmentLeft;
    needMoneyTwo.textColor = BlackNotColor;
    needMoney.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    
    
    //数量
    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(10 * WideEachUnit,70 * WideEachUnit ,50 * WideEachUnit, 20 * WideEachUnit)];
    [twoView addSubview:number];
    number.text = @"数量";
    number.textAlignment = NSTextAlignmentLeft;
    number.textColor = [UIColor grayColor];
    number.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    
    //加，减
    UIButton *cutBtn = [[UIButton alloc]initWithFrame:CGRectMake(number.current_x_w, number.current_y, 20*rate, 20*verticalrate)];
    cutBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [twoView addSubview:cutBtn];
    [cutBtn setTitle:@"-" forState:UIControlStateNormal];
    [cutBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    
    _Num = [[UILabel alloc]initWithFrame:CGRectMake(cutBtn.current_x_w,cutBtn.current_y,50*rate, 20*verticalrate)];
    [twoView addSubview:_Num];
    [cutBtn.titleLabel setFont:[UIFont systemFontOfSize:14*verticalrate]];
    
    cutBtn.tag = 1;
    [cutBtn addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    _numValue = 1;
    _Num.text = [NSString stringWithFormat:@"%d",_numValue];;
    _Num.textColor = [UIColor colorWithHexString:@"#333333"];
    _Num.font = [UIFont systemFontOfSize:14*verticalrate];
    _Num.textAlignment = NSTextAlignmentCenter;
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(_Num.current_x_w, _Num.current_y, 20 * WideEachUnit, 20*WideEachUnit)];
    addBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [twoView addSubview:addBtn];
    addBtn.tag = 2;
    [addBtn addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    addBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2 * WideEachUnit, 0);
    
    UILabel *lastLab = [[UILabel alloc]initWithFrame:CGRectMake(addBtn.current_x_w+2,addBtn.current_y,50*rate, 20*verticalrate)];
    [twoView addSubview:lastLab];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:14*verticalrate]];
    
    lastLab.text = @"  件";
    lastLab.textColor = [UIColor colorWithHexString:@"#333333"];
    lastLab.font = [UIFont systemFontOfSize:15*verticalrate];
    lastLab.textAlignment = NSTextAlignmentLeft;
    //北京lab
    UILabel *backlab = [[UILabel alloc]initWithFrame:CGRectMake(0, lastLab.current_y_h + 20 * WideEachUnit, MainScreenWidth, 1 * WideEachUnit)];
    [twoView addSubview:backlab];
    backlab.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    backlab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    //简介
    UILabel *jianjie = [[UILabel alloc]initWithFrame:CGRectMake(10 * WideEachUnit, 130 * WideEachUnit,50 * WideEachUnit, 20 * WideEachUnit)];
    [twoView addSubview:jianjie];
    jianjie.text = @"简介";
    jianjie.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    jianjie.textAlignment = NSTextAlignmentLeft;
    jianjie.textColor = [UIColor grayColor];
    
    
    _jianjie1 = [[UILabel alloc]initWithFrame:CGRectMake(60 * WideEachUnit , 130 * WideEachUnit,(MainScreenWidth -jianjie.current_x_w-10)*rate , 20 * WideEachUnit)];
    [self setIntroductionText:[_dict stringValueForKey:@"info"]];
    _jianjie1.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _jianjie1.textAlignment = NSTextAlignmentLeft;
    _jianjie1.textColor = [UIColor colorWithHexString:@"#333333"];
    [twoView addSubview:_jianjie1];
    _jianjie1.numberOfLines = 0;
    
    //确定按钮
    _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, MainScreenHeight - 49 * WideEachUnit, MainScreenWidth, 49 * WideEachUnit)];
    [_sureBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.backgroundColor = [UIColor colorWithHexString:@"#e55c5c"];
    [self.view addSubview:_sureBtn];
    [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15*verticalrate]];
}


#pragma mark --- 点击事件
-(void)adress{

    if (UserOathToken == nil) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    } else {
        ManageAddressViewController *vc = [[ManageAddressViewController alloc] init];
        vc.seleAdressCell = ^(NSDictionary *adressDict) {
            _peisong1.text = [NSString stringWithFormat:@"%@%@ %@",adressDict[@"province"],adressDict[@"city"],adressDict[@"address"]];
            if (adressDict == nil) {
                _peisong1.text = @"请选择收货地址";
            }
            _adress_id = adressDict[@"address_id"];
            _addressDict = adressDict;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }

}


//是否 真要支付
- (void)isSurePay {
    
    if (!UserOathToken) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    NSInteger Score = [needSroce.text integerValue];
    NSInteger Number  = [_Num.text integerValue];
    NSString *messageStr = [NSString stringWithFormat:@"确定要花费%ld个积分兑换%ld件该商品？",Score * Number + [[_dict stringValueForKey:@"fare"] integerValue] ,Number];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16 * WideEachUnit]
                  range:NSMakeRange(0, messageStr.length)];
    [alertController setValue:hogan forKey:@"attributedMessage"];
    
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self netWorkGoodsExchange];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


//确定
-(void)sure{
    if ([_scoreStaus integerValue] == 0 && isHaveAilPay == NO && isHaveWxPay == NO) {
        [TKProgressHUD showError:@"无法支付" toView:self.view];
        return;
    }
    [self whichPayView];
}

-(void)changeNum:(UIButton *)sender{
    
    if (sender.tag==1) {
        if (_numValue==1) {
            return;
        }
        _numValue--;
        _Num.text = [NSString stringWithFormat:@"%d",_numValue];

    }else{
        _numValue++;
        if (_numValue == [_sokteStr integerValue]) {
            _Num.text = [NSString stringWithFormat:@"%@",_sokteStr];
        } else if (_numValue > [_sokteStr integerValue]) {
            _numValue --;
            _Num.text = [NSString stringWithFormat:@"%@",_sokteStr];
        } else {
           _Num.text = [NSString stringWithFormat:@"%d",_numValue];
        }
    }
}
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)seleButtonCilck:(UIButton *)button {
    NSInteger buttonTag = button.tag;
    
    if (isHaveAilPay && isHaveWxPay) {
        if (buttonTag == 0) {
            _aliSeleButton.selected = YES;
            _payTypeStr = @"1";
            
            _wxSeleButton.selected = NO;
            _balanceSeleButton.selected = NO;
            
            if ([_scoreStaus integerValue] == 1) {//积分
                _pricePay.text = [NSString stringWithFormat:@"%.2f",([[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue]) * _percentage];
            }
            
        } else if (buttonTag == 1) {
            _wxSeleButton.selected = YES;
            _payTypeStr = @"2";
            
            _aliSeleButton.selected = NO;
            _balanceSeleButton.selected = NO;
            
            if ([_scoreStaus integerValue] == 1) {//积分
                _pricePay.text = [NSString stringWithFormat:@"%.2f",([[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue]) * _percentage];
            }
            
        } else if (buttonTag == 2) {
            _balanceSeleButton.selected = YES;
            _payTypeStr = @"3";
            
            _aliSeleButton.selected = NO;
            _wxSeleButton.selected = NO;
            
            if ([_scoreStaus integerValue] == 1) {//积分
                _pricePay.text = [NSString stringWithFormat:@"%ld",([[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue])];
            }
        }
    } else if (isHaveAilPay && !isHaveWxPay) {
        if (buttonTag == 0) {
            _aliSeleButton.selected = YES;
            _payTypeStr = @"1";
            
            _wxSeleButton.selected = NO;
            _balanceSeleButton.selected = NO;
            
            if ([_scoreStaus integerValue] == 1) {//积分
                _pricePay.text = [NSString stringWithFormat:@"%.2f",([[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue]) * _percentage];
            }
            
        }  else if (buttonTag == 1) {
            _balanceSeleButton.selected = YES;
            _payTypeStr = @"3";
            
            _aliSeleButton.selected = NO;
            _wxSeleButton.selected = NO;
            
            if ([_scoreStaus integerValue] == 1) {//积分
                _pricePay.text = [NSString stringWithFormat:@"%ld",([[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue])];
            }
        }
    } else if (isHaveWxPay && !isHaveAilPay) {
         if (buttonTag == 0) {
            _wxSeleButton.selected = YES;
            _payTypeStr = @"2";
            
            _aliSeleButton.selected = NO;
            _balanceSeleButton.selected = NO;
            
            if ([_scoreStaus integerValue] == 1) {//积分
                _pricePay.text = [NSString stringWithFormat:@"%.2f",([[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue]) * _percentage];
            }
            
        } else if (buttonTag == 1) {
            _balanceSeleButton.selected = YES;
            _payTypeStr = @"3";
            
            _aliSeleButton.selected = NO;
            _wxSeleButton.selected = NO;
            
            if ([_scoreStaus integerValue] == 1) {//积分
                _pricePay.text = [NSString stringWithFormat:@"%ld",([[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue])];
            }
        }
    }
}

- (void)nowPayButtonCilck {
    //解锁
    if ([_payTypeStr integerValue] == 1) {//支付宝支付
        [self netWorkGoodsBuyGoods];
    } else if ([_payTypeStr integerValue] == 2) {//微信支付
        [self netWorkGoodsBuyGoods];
    } else if ([_payTypeStr integerValue] == 3) {//积分支付
        [self netWorkGoodsExchange];
    }
}

#pragma mark ---- 通知

- (void)getAddress:(NSNotification *)not {
    
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    NSLog(@"%@",_peisong1.text);
    _peisong1.text = [NSString stringWithFormat:@"%@%@ %@",dict[@"province"],dict[@"city"],dict[@"address"]];
    if (dict == nil) {
        _peisong1.text = @"请选择收货地址";
    }
    _adress_id = dict[@"address_id"];
    _addressDict = dict;
}


#pragma mark --- 文本适应

-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _jianjie1.text = text;
    //设置label的最大行数
    _jianjie1.numberOfLines = 0;
    
    CGRect labelSize = [_jianjie1.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 70 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 * WideEachUnit]} context:nil];
    
    //计算出自适应的高度
    _jianjie1.frame = CGRectMake(60 * WideEachUnit , 130 * WideEachUnit,MainScreenWidth - 70 * WideEachUnit , labelSize.size.height);
    _twoView.frame = CGRectMake(0, _twoView.frame.origin.y, MainScreenWidth, 130 + labelSize.size.height + 20 * WideEachUnit);
    
    _mainScrollView.contentSize =CGSizeMake(MainScreenWidth, CGRectGetMaxY(_twoView.frame) + 10 * WideEachUnit);
    
    if (currentIOS >= 11.0) {
         _mainScrollView.contentSize =CGSizeMake(MainScreenWidth, CGRectGetMaxY(_twoView.frame) + 50 * WideEachUnit);
    }
}

#pragma mark --- 支付类型的配置
- (void)payTypeArrayDeal {
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"alipay"]) {//有支付宝
            isHaveAilPay = YES;
        }
        if ([payStr isEqualToString:@"wxpay"]) {//有微信支付
            isHaveWxPay = YES;
        }
    }
}

#pragma mark --- 支付界面
- (void)whichPayView {
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds =YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    _allWindowView = allWindowView;
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    
    UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(0,MainScreenHeight - 250 * WideEachUnit, MainScreenWidth, 250 * WideEachUnit)];
    buyView.backgroundColor = [UIColor whiteColor];
    [allWindowView addSubview:buyView];
    if ([_scoreStaus integerValue] == 1) {
        if (isHaveAilPay && isHaveWxPay) {//都有
            buyView.frame = CGRectMake(0,MainScreenHeight - 250 * WideEachUnit, MainScreenWidth, 250 * WideEachUnit);
            _payTypeStr = @"1";
        } else if (isHaveAilPay && !isHaveWxPay) {//只有支付宝和积分
            buyView.frame = CGRectMake(0,MainScreenHeight - 200 * WideEachUnit, MainScreenWidth, 200 * WideEachUnit);
            _payTypeStr = @"1";
        } else if (!isHaveAilPay && isHaveWxPay) {//只有微信和积分
            buyView.frame = CGRectMake(0,MainScreenHeight - 200 * WideEachUnit, MainScreenWidth, 200 * WideEachUnit);
            _payTypeStr = @"2";
        } else {
            buyView.frame = CGRectMake(0,MainScreenHeight - 150 * WideEachUnit, MainScreenWidth, 150 * WideEachUnit);
            _payTypeStr = @"3";
        }
    } else {
        if (isHaveAilPay && isHaveWxPay) {//没有积分
            buyView.frame = CGRectMake(0,MainScreenHeight - 200 * WideEachUnit, MainScreenWidth, 200 * WideEachUnit);
            _payTypeStr = @"1";
        } else if (isHaveAilPay && !isHaveWxPay) {//只有支付宝和积分
            buyView.frame = CGRectMake(0,MainScreenHeight - 150 * WideEachUnit, MainScreenWidth, 150 * WideEachUnit);
            _payTypeStr = @"1";
        } else if (!isHaveAilPay && isHaveWxPay) {//只有微信和积分
            buyView.frame = CGRectMake(0,MainScreenHeight - 150 * WideEachUnit, MainScreenWidth, 150 * WideEachUnit);
            _payTypeStr = @"2";
        }
    }
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth - 10 * WideEachUnit, 50 * WideEachUnit)];
    title.text = @"请选择支付方式";
    title.textColor = BlackNotColor;
    title.backgroundColor = [UIColor whiteColor];
    title.font = Font(16);
    [buyView addSubview:title];
    
    NSArray *imageArray = @[@"Alipay@3x",@"weixinpay@3x",@""];
    if ([_scoreStaus integerValue] == 1) {//积分支付
        if (isHaveAilPay && isHaveWxPay) {//都有
            imageArray = @[@"Alipay@3x",@"weixinpay@3x",@""];
        } else if (isHaveAilPay && !isHaveWxPay) {//只有支付宝和积分
            imageArray = @[@"Alipay@3x",@""];
        } else if (!isHaveAilPay && isHaveWxPay) {//只有微信和积分
            imageArray = @[@"weixinpay@3x",@""];
        } else {
            imageArray = @[@""];
        }
        
    } else {
        if (isHaveAilPay && isHaveWxPay) {//没有积分
            imageArray = @[@"Alipay@3x",@"weixinpay@3x"];
        } else if (isHaveAilPay && !isHaveWxPay) {//只有支付宝
            imageArray = @[@"Alipay@3x"];
        } else if (!isHaveAilPay && isHaveWxPay) {//只有微信
            imageArray = @[@"weixinpay@3x"];
        }
    }
    CGFloat viewW = MainScreenWidth;
    CGFloat viewH = 50 * WideEachUnit;
    
    for (int i = 0 ; i < imageArray.count ; i ++) {
        
        UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, 50 * WideEachUnit + i * viewH  , viewW, viewH)];
        payView.backgroundColor = [UIColor whiteColor];
        payView.layer.borderWidth = 0.5 * WideEachUnit;
        payView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [buyView addSubview:payView];
        
        
        UIButton *payTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit,0, 80 * WideEachUnit, 50 * WideEachUnit)];
        [payTypeButton setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        [payView addSubview:payTypeButton];
        
        if ([_scoreStaus integerValue] == 1) {
            if (i == imageArray.count - 1) {
                //            [payTypeButton setTitle:@"余额" forState:UIControlStateNormal];
                payTypeButton.hidden = YES;
                UILabel *payType = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, 250 * WideEachUnit, 50 * WideEachUnit)];
                payType.text = @"积分";
                payType.textColor = [UIColor colorWithHexString:@"#888"];
                [payView addSubview:payType];
                payType.font = Font(14);
                payType.text = [NSString stringWithFormat:@"积分 (当前账号积分为育币%@)",[_userAccountDict stringValueForKey:@"score" defaultValue:@"0"]];
                
            }
        }
        
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = i;
        if (isHaveAilPay && isHaveWxPay) {
            if (i == 0) {
                _aliSeleButton = seleButton;
                _aliSeleButton.selected = YES;
            } else if (i == 1) {
                _wxSeleButton = seleButton;
                _wxSeleButton.selected = NO;
            } else if (i == 2) {
                _balanceSeleButton = seleButton;
                _balanceSeleButton.selected = NO;
            }
        } else if (!isHaveAilPay && isHaveWxPay) {
            if (i == 0) {
                _wxSeleButton = seleButton;
                _wxSeleButton.selected = YES;
            } else if (i == 1) {
                _balanceSeleButton = seleButton;
                _balanceSeleButton.selected = NO;
            }
        } else if (isHaveAilPay && !isHaveWxPay) {
            if (i == 0) {
                _aliSeleButton = seleButton;
                _aliSeleButton.selected = YES;
            } else if (i == 1) {
                _balanceSeleButton = seleButton;
                _balanceSeleButton.selected = NO;
            }
        } else {//只有积分
            if (i == 0) {
                _balanceSeleButton = seleButton;
                _balanceSeleButton.selected = YES;
            }
        }
        
        [payView addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = i;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [payView addSubview:allClearButton];
        
    }
    
    
    //添加价格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, buyView.frame.size.height - 49 * WideEachUnit, MainScreenWidth / 2, 48 *WideEachUnit)];
    price.text = @"实付：100";
    [buyView addSubview:price];
    price.textAlignment = NSTextAlignmentCenter;
    price.textColor = [UIColor colorWithHexString:@"#888"];
    price.textColor = [UIColor orangeColor];
    
    CGFloat Money = [[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue];
    if ([_scoreStaus integerValue] == 0) {
        Money = ([[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue]) * _percentage;
    } else {
        if (isHaveWxPay || isHaveAilPay) {
            Money = ([[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue]) * _percentage;
        } else {
            Money = [[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue];
        }
    }
    price.text = [NSString stringWithFormat:@"实付：育币%.2f",Money];
    
    _pricePay = price;
    
    //添加按钮
    UIButton *nowPayButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, buyView.frame.size.height - 50 * WideEachUnit, MainScreenWidth / 2, 50 * WideEachUnit)];
    nowPayButton.backgroundColor = BasidColor;
    [nowPayButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [nowPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyView addSubview:nowPayButton];
    [nowPayButton addTarget:self action:@selector(nowPayButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_scoreStaus integerValue] == 0) {
        price.frame = CGRectMake(0, buyView.frame.size.height - 49 * WideEachUnit, MainScreenWidth / 2, 48 * WideEachUnit);
        nowPayButton.frame = CGRectMake(MainScreenWidth / 2, buyView.frame.size.height - 50 * WideEachUnit , MainScreenWidth / 2, 50 * WideEachUnit);
    }
}

#pragma mark --- 网络视图

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

#pragma mark --- 手势
- (void)allWindowViewClick:(UIGestureRecognizer *)ger {
    [_allWindowView removeFromSuperview];
}


#pragma mark --- 网络请求

//获取收货地址
- (void)netWorkAdressGetMyList {
    NSString *endUrlStr = YunKeTang_Address_address_getMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"50" forKey:@"count"];
    
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
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _addressArray = [dict arrayValueForKey:@"data"];
            } else {
                _addressArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            
            
            for (int i = 0; i < _addressArray.count ; i ++) {
                NSDictionary *indexDict = [_addressArray objectAtIndex:i];
                if ([[indexDict stringValueForKey:@"is_default"] integerValue] == 1) {
                    isHaveDefault = YES;
                    _addressDict = indexDict;
                    _peisong1.text = [NSString stringWithFormat:@"%@%@ %@",_addressDict[@"province"],_addressDict[@"city"],_addressDict[@"address"]];
                    _adress_id = [_addressDict stringValueForKey:@"address_id"];
                }
            }
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
    [mutabDict setObject:[_dict stringValueForKey:@"goods_id"] forKey:@"goods_id"];
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
            [_allWindowView removeFromSuperview];
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backPressed];
            });
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//商品的解锁
- (void)netWorkGoodsBuyGoods {
    NSString *endUrlStr = YunKeTang_Goods_goods_buyGoods;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_dict stringValueForKey:@"goods_id"] forKey:@"goods_id"];
    [mutabDict setObject:[NSString stringWithFormat:@"%d",_numValue] forKey:@"count"];
    if ([_payTypeStr integerValue] == 1) {//支付宝
        [mutabDict setObject:@"alipay" forKey:@"pay"];
    } else if ([_payTypeStr integerValue] == 2) {//微信
        [mutabDict setObject:@"wxpay" forKey:@"pay"];
    }
    
    CGFloat Money = ([[_dict stringValueForKey:@"price"] integerValue] * _numValue + [[_dict stringValueForKey:@"fare"] integerValue]) * _percentage;
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
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
            } else if ([_payTypeStr integerValue] == 2){//微信
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _userAccountDict = [dict dictionaryValueForKey:@"data"];
            } else {
                _userAccountDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
