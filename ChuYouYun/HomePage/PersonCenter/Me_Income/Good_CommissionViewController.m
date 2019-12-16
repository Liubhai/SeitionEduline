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
    [self netWorkUserSpiltConfig];
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
        [MBProgressHUD showError:@"提现金额不能过大" toView:self.view];
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
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

@end
