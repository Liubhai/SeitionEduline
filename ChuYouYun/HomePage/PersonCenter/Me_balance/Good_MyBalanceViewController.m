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
@property (strong ,nonatomic)UIView   *agreeView;
@property (strong ,nonatomic)UIView   *downView;
@property (strong ,nonatomic)UIWebView *webView;

@property (strong ,nonatomic)UILabel  *balanceLabel;
@property (strong ,nonatomic)UITextField *textField;
@property (strong ,nonatomic)UIButton  *submitButton;
@property (strong ,nonatomic)UIButton  *agreeButton;


@property (strong ,nonatomic)UIButton  *oneButton;
@property (strong ,nonatomic)UIButton  *twoButton;
@property (strong ,nonatomic)UIButton  *threeButton;
@property (strong ,nonatomic)UIButton  *fourButton;
@property (strong ,nonatomic)UILabel   *realMoney;

@property (strong ,nonatomic)NSString  *payTypeStr;
@property (strong ,nonatomic)NSString  *productID;
@property (strong ,nonatomic)NSDictionary *balanceDict;
@property (strong ,nonatomic)NSArray      *payTypeArray;//接口返回的方式
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
    [self addDownView];
    [self netWorkUserBalanceConfig];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBroadShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBroadHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBalanceData) name:@"reloadBalanceData" object:nil];
    
    _payTypeStr = @"3";
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
    
    _netWorkBalanceArray = (NSArray *)_applepayArray;
    
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
    for (int i  = 0 ; i < allNumber; i ++) {
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
    }

    if ((_netWorkBalanceArray.count + 1) % 2 == 0) {//能整除的时候
        _rechargeView.frame = CGRectMake(0, CGRectGetMaxY(_moneyView.frame), MainScreenWidth, ((_netWorkBalanceArray.count + 1) / 2) * (buttonH + 15 * WideEachUnit) + 60 * WideEachUnit);
        if (_applepayArray.count>0) {
            _rechargeView.frame = CGRectMake(0, CGRectGetMaxY(_moneyView.frame), MainScreenWidth, ((_netWorkBalanceArray.count + 1) / 2) * (buttonH + 15 * WideEachUnit) + 30);
        }
    } else {//不能整除的时候
        _rechargeView.frame = CGRectMake(0, CGRectGetMaxY(_moneyView.frame), MainScreenWidth, ((_netWorkBalanceArray.count + 1) / 2 + 1) * (buttonH + 15 * WideEachUnit) + 60 * WideEachUnit);
        if (_applepayArray.count>0) {
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
    [_agreeView setTop:CGRectGetMaxY(_rechargeView.frame) + 10 * WideEachUnit];
}

- (void)addAgreeView {
    if (_agreeView == nil) {
        _agreeView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, CGRectGetMaxY(_rechargeView.frame) + 10 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit, 44 * WideEachUnit)];
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
    
}

-(void)keyBroadHide:(NSNotification *)not {
    isScroll = NO;
    [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    _scrollView.scrollEnabled = YES;
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
    //配置充值是否充值赠送
    isGiveMoney = YES;
    isSeleMoneyButtonNumber = button.tag;
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

#pragma mark --- 网络请求
//获取余额各种数据以及配置
- (void)netWorkUserBalanceConfig {//
    
    NSString *endUrlStr = YunKeTang_User_user_balanceConfig;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1"forKey:@"tab"];
    [mutabDict setObject:@"50"forKey:@"limit"];
    
    [mutabDict setObject:@"1" forKey:@"is_ios"];
    
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
        [self addAgreeView];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)reloadBalanceData {
    [self netWorkUserBalanceConfig];
}

@end
