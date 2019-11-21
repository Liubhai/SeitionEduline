//
//  Good_AliBoundViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/7.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_AliBoundViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "Good_AlipayViewController.h"


@interface Good_AliBoundViewController ()

@property (strong ,nonatomic)UIButton  *submitButton;
@property (strong ,nonatomic)UITextField  *aliTextField;
@property (strong ,nonatomic)UITextField  *nameTextField;

@end

@implementation Good_AliBoundViewController

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
    [self addAilpay];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"支付宝";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
}

#pragma mark --- 添加视图
- (void)addAilpay {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 64 , MainScreenWidth, 30 * WideEachUnit)];
    title.text = @"支付宝账号";
    title.font = Font(14 * WideEachUnit);
    title.textColor = [UIColor colorWithHexString:@"#656565"];
    [self.view addSubview:title];
    
    //添加输入框
    UITextField *aliTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64 + 30 * WideEachUnit, MainScreenWidth, 35 * WideEachUnit)];
    aliTextField.backgroundColor = [UIColor whiteColor];
    aliTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,20 * WideEachUnit, 35 * WideEachUnit)];
    aliTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:aliTextField];
    _aliTextField = aliTextField;
    
    //切换账号
    UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 64 + 65 * WideEachUnit , MainScreenWidth, 30 * WideEachUnit)];
    nameTitle.text = @"真实姓名";
    nameTitle.font = Font(14 * WideEachUnit);
    nameTitle.textColor = [UIColor colorWithHexString:@"#656565"];
    [self.view addSubview:nameTitle];
    
    //解除绑定
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64 + 95 * WideEachUnit, MainScreenWidth, 35 * WideEachUnit)];
    nameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,20 * WideEachUnit, 35 * WideEachUnit)];
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    nameTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameTextField];
    _nameTextField = nameTextField;
    
    //提交按钮
    
    //添加提交订单按钮
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 64 + 160 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 35 * WideEachUnit)];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitButton.backgroundColor = BasidColor;
    _submitButton.layer.cornerRadius = 10 * WideEachUnit;
    _submitButton.layer.masksToBounds = YES;
    [_submitButton addTarget:self action:@selector(submitButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    
}

#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitButtonCilck {
    [self netWorkUserSetAlipay];
}

#pragma mark --- 绑定支付宝
- (void)netWorkUserSetAlipay {
    
    NSString *endUrlStr = YunKeTang_User_user_setAlipay;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_aliTextField.text.length > 0) {
        [mutabDict setObject:_aliTextField.text forKey:@"alipay_account"];
    } else {
        [TKProgressHUD showError:@"填写支付宝账号" toView:self.view];
        return;
    }
    
    if (_nameTextField.text.length > 0) {
        [mutabDict setObject:_nameTextField.text forKey:@"real_name"];
    } else {
        [TKProgressHUD showError:@"请填写真实姓名" toView:self.view];
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([_formCommission isEqualToString:@"commisson"]) {
                    [self backPressed];
                } else {
                    Good_AlipayViewController *vc = [[Good_AlipayViewController alloc] init];
                    vc.isFormBound = @"bound";//刚绑定完
                    [self.navigationController pushViewController:vc animated:YES];
                }
            });
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        }
        NSLog(@"----%@",dict);
      
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}








@end
