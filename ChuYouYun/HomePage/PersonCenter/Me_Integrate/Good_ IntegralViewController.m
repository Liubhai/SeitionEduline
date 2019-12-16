//
//  Good_ IntegralViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/10/17.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_ IntegralViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "Good_IntegralParticularsViewController.h"
#import "BuyAgreementViewController.h"

@interface Good__IntegralViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (strong ,nonatomic)NSMutableArray   *payTypeArray;

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)UIView   *moneyView;
@property (strong ,nonatomic)UIView   *rechargeView;
@property (strong ,nonatomic)UIView   *payView;
@property (strong ,nonatomic)UIView   *agreeView;
@property (strong ,nonatomic)UIView   *downView;

@property (strong ,nonatomic)UILabel  *scoreLabel;
@property (strong ,nonatomic)UITextField *textField;
@property (strong ,nonatomic)UIButton  *balanceSeleButton;
@property (strong ,nonatomic)UIButton  *bankSeleButton;
@property (strong ,nonatomic)UIButton  *agreeButton;
@property (strong ,nonatomic)UIButton  *submitButton;
@property (strong ,nonatomic)UILabel   *remark;
@property (strong ,nonatomic)UILabel   *exchange;
@property (strong ,nonatomic)UILabel   *balanceseInformationLabel;
@property (strong ,nonatomic)UILabel   *splitInformationLabel;
@property (strong ,nonatomic)UILabel   *realMoney;

@property (strong ,nonatomic)NSString  *payTypeStr;
@property (strong ,nonatomic)NSDictionary *scoreDict;
@property (strong ,nonatomic)NSArray      *componentsArray;
@property (strong ,nonatomic)NSString     *sple_score_str;

@end

@implementation Good__IntegralViewController

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
    _payTypeArray = [NSMutableArray new];
    [self interFace];
    [self addNav];
    [self addScrollView];
    
    [self addMoneyView];
    [self NetWorkUserCreditConfig];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _payTypeStr = @"1";
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
    WZLabel.text = @"积分";
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
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
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
    balanceLabel.text = @"200";
    [balanceLabel setTextColor:[UIColor whiteColor]];
    balanceLabel.font = [UIFont systemFontOfSize:24 * WideEachUnit];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [_moneyView addSubview:balanceLabel];
    _scoreLabel = balanceLabel;
    
    //文字
    UILabel *balanceTitle = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit,60 * WideEachUnit , 200 * WideEachUnit, 15 * WideEachUnit)];
    balanceTitle.text = @"账户积分";
    [balanceTitle setTextColor:[UIColor groupTableViewBackgroundColor]];
    balanceTitle.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    balanceTitle.textAlignment = NSTextAlignmentCenter;
    [_moneyView addSubview:balanceTitle];
    
}

#pragma mark --- 通知
- (void)textChange:(NSNotification *)not {
    NSLog(@"%@",_textField);
    if (_textField.text.length > 8) {
        [TKProgressHUD showError:@"积分数量不能过大" toView:self.view];
        _textField.text = [_textField.text substringToIndex:8];
        return;
    } else if (_textField.text.length == 0) {
        _textField.text = @"";
        _remark.text = [NSString stringWithFormat:@"需要花费0个育币"];
        _realMoney.text = @"育币 0";
        return;
    } else {
        NSString *textStr = [_textField.text substringFromIndex:0];
        CGFloat hh = [textStr floatValue] / [_sple_score_str integerValue];
        _remark.text = [NSString stringWithFormat:@"需要花费%.2f 育币",hh];
        _realMoney.text = [NSString stringWithFormat:@"%.2f 育币",hh];
    }
}

#pragma mark --- UITextFieldDelegate

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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailButtonCilck {
    Good_IntegralParticularsViewController *vc = [[Good_IntegralParticularsViewController alloc] init];
    vc.typeStr = @"3";
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
        [TKProgressHUD showError:@"请输入兑换积分的个数" toView:self.view];
        return;
    }
    [self isSurePay];
}

- (void)pactButtonCilck {
    BuyAgreementViewController *vc = [[BuyAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//是否 真要支付
- (void)isSurePay {
    return;
}



#pragma mark --- 网络请求
//获取积分配置
- (void)NetWorkUserCreditConfig {
    
    NSString *endUrlStr = YunKeTang_User_user_creditConfig;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"10" forKey:@"count"];
    NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dataSource stringValueForKey:@"code"] integerValue] == 1) {
            dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _scoreDict = [dataSource dictionaryValueForKey:@"credit_info"];
            NSArray *array = [dataSource arrayValueForKey:@"pay_type"];
            [_payTypeArray removeAllObjects];
            for (NSDictionary *dict in array) {
                [_payTypeArray addObject:[dict stringValueForKey:@"pay_num"]];
            }
            _scoreLabel.text = [_scoreDict stringValueForKey:@"score"];
            
            return;
            
        } else {
            [TKProgressHUD showError:[dataSource stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

@end
