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

@property (strong ,nonatomic)UIButton  *balanceButton;
@property (strong ,nonatomic)NSString  *payTypeStr;//用于区分支付类型

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
    _payTypeStr = @"3";
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
    payMethod.text = @"支付方式";
    payMethod.textColor = RGBHex(0x3C4654);
    payMethod.font = SYSTEMFONT(16);
    [_mainScrollView addSubview:payMethod];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, payMethod.bottom, MainScreenWidth, 1)];
    line5.backgroundColor = RGBHex(0xEEEEEE);
    [_mainScrollView addSubview:line5];
    
    [self addBalanceView:line5];
    
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

- (void)addBalanceView:(UIView *)upView {
    _balanceView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(upView.frame), MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit)];
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
        
        UIImageView *payIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 0, 24 * WideEachUnit, 24 *HigtEachUnit)];
        payIcon.image = Image(@"money");
        payIcon.centerY = 50 * HigtEachUnit / 2.0;
        [_balanceView addSubview:payIcon];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(payIcon.right + 5, 0,60 * WideEachUnit, 50 * WideEachUnit)];
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
        [self seleButtonCilck:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = 2;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_balanceView addSubview:allClearButton];
    } else {
        _balanceView.frame = CGRectMake(0 * WideEachUnit, CGRectGetMaxY(upView.frame), 0, 0 * WideEachUnit);
    }
}

- (void)seleButtonCilck:(UIButton *)button {
    _balanceButton.selected = YES;
    _payTypeStr = @"3";
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
        [TKProgressHUD showError:@"请先阅读并同意《墨点课堂解锁协议》" toView:self.view];
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
    if ([_payTypeStr integerValue] == 3) {
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
            if ([_payTypeStr integerValue] == 3) {
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

@end
