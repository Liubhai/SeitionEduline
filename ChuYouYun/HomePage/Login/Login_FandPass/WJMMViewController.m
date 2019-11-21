//
//  WJMMViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/21.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//
//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "WJMMViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "PhoneMd.h"
#import "MyHttpRequest.h"
#import "MZTimerLabel.h"
#import "YXZHViewController.h"
#import "ZHCGViewController.h"
#import "AppDelegate.h"
#import "TKProgressHUD+Add.h"
#import "UIView+Utils.h"
#import "SYG.h"


@interface WJMMViewController ()

@property (strong ,nonatomic)UITextField *phoneField;

@property (strong ,nonatomic)UITextField *YZMField;

@property (strong ,nonatomic)UITextField *XMMField;

@property (strong ,nonatomic)UIView *waitView;

@property (strong ,nonatomic)UILabel *waitLabel;

@end

@implementation WJMMViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if ([self.typeStr isEqualToString:@"123"]) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if ([self.typeStr isEqualToString:@"123"]) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:NO];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initer];
    [self addPhone];
}

- (void)initer {
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    self.navigationItem.title = @"找回密码";
}

- (void)addPhone {
    
    //添加View
    UIView *NavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    NavView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self.view addSubview:NavView];
    
    //添加按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 30, 14, 23)];
    [backButton setImage:[UIImage imageNamed:@"ArrowWJ"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:backButton];

    //添加
    UILabel *ZCLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 25, 100, 30)];
    ZCLabel.textAlignment = NSTextAlignmentCenter;
    ZCLabel.text = @"找回密码";
    ZCLabel.textColor = [UIColor whiteColor];
    ZCLabel.font = [UIFont systemFontOfSize:20];
    [NavView addSubview:ZCLabel];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(10, 40, 14, 23);
        ZCLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
//        addButton.frame = CGRectMake(MainScreenWidth - 50, 40, 40, 40);
    }
    
    
    //添加输入文本框
    //添加呢称
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 50)];
    _phoneField.placeholder = @"手机号";
    _phoneField.backgroundColor = [UIColor whiteColor];
    _phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_phoneField];
    
    //添加发送验证码
    UIButton *YZMButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 7 + 100, 80, 36)];
    [YZMButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [YZMButton addTarget:self action:@selector(YZMButton) forControlEvents:UIControlEventTouchUpInside];
    YZMButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [YZMButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    YZMButton.layer.cornerRadius = 3;
    YZMButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:YZMButton];

    //验证码
    _YZMField= [[UITextField alloc] initWithFrame:CGRectMake(0, 151, MainScreenWidth, 50)];
    _YZMField.placeholder = @"验证码";
    _YZMField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _YZMField.leftViewMode = UITextFieldViewModeAlways;
    _YZMField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_YZMField];
    
    
    //添加新密码
    _XMMField = [[UITextField alloc] initWithFrame:CGRectMake(0, 202, MainScreenWidth, 50)];
    _XMMField.placeholder = @"请输入6-12位字符的新密码";
    _XMMField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _XMMField.leftViewMode = UITextFieldViewModeAlways;
    _XMMField.backgroundColor = [UIColor whiteColor];
    _XMMField.secureTextEntry = YES;//密码形式
    [self.view addSubview:_XMMField];
    
    
    //添加手机注册
    UIButton *SJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 260, 100, 30)];
    [SJButton setTitle:@"邮箱找回" forState:UIControlStateNormal];
    [SJButton setTitleColor:[UIColor colorWithRed:31.f / 255 green:65.f / 255 blue:192.f / 255 alpha:1] forState:UIControlStateNormal];
    SJButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [SJButton addTarget:self action:@selector(SJButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:SJButton];
    
    //提交
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, MainScreenWidth - 40, 45)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(TJButton) forControlEvents:UIControlEventTouchUpInside];
    TJButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    TJButton.layer.cornerRadius = 4;
    [self.view addSubview:TJButton];

}

- (void)SJButton:(UIButton *)button {
    
    YXZHViewController *YXZHVC = [[YXZHViewController alloc] init];
    YXZHVC.typeStr = self.typeStr;
    [self.navigationController pushViewController:YXZHVC animated:YES];
}

- (void)YZMButton {
    [self TJNetWorkPassportGetRegphoneCode];
}

- (void)TJNetWorkPassportGetRegphoneCode {
    if (_phoneField.text.length == 0) {
        [TKProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }
    NSString *endUrlStr = YunKeTang_sms_phoneGetPwd;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
//    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [mutabDict setObject:self.phoneField.text forKey:@"phone"];
    
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@refound",timeSp,NetKey]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    [mutabDict setObject:@"refound" forKey:@"type"];
    [mutabDict setObject:_phoneField.text forKey:@"phone"];
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 0) {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        } else if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
             [TKProgressHUD showSuccess:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)TJButton {
    if (_phoneField.text.length == 0 || _phoneField.text.length != 11) {
        [TKProgressHUD showError:@"请输入手机号或正确的手机号" toView:self.view];
        return;
    }else if (_YZMField.text.length == 0){
        [TKProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }else if (_XMMField.text.length == 0){
        [TKProgressHUD showError:@"请输入新密码" toView:self.view];
        return;
    }
    else {
        [self netWorkPassportSavePwd];
//        [self netWorkPassportPhoneGetPwd];
//        [self netWorkPassportClickRepwdCode];
//        [self netWorkPassportPhoneGetPwd];
    }
}

#pragma mark --- 验证码
//用户重置密码
- (void)netWorkPassportSavePwd {
    
    NSString *endUrlStr = YunKeTang_passport_savePwd;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:self.phoneField.text forKey:@"phone"];
    self.PhoneStr = self.phoneField.text;
    [mutabDict setObject:_YZMField.text forKey:@"code"];
    [mutabDict setObject:_XMMField.text forKey:@"pwd"];
    [mutabDict setObject:_XMMField.text forKey:@"repwd"];
    
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
            if (dict.allKeys.count > 0) {
                [TKProgressHUD showError:@"重置成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_typeStr integerValue] == 123) {//说明是从设置界面退出登陆的
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                    } else {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                });
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//验证码是否正确
- (void)netWorkPassportClickRepwdCode {
    
    NSString *endUrlStr = YunKeTang_passport_clickRepwdCode;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:self.phoneField.text forKey:@"phone"];
    [mutabDict setObject:_YZMField.text forKey:@"code"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [self netWorkPassportPhoneGetPwd];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



//通过手机找回密码
- (void)netWorkPassportPhoneGetPwd {
    
    NSString *endUrlStr = YunKeTang_passport_phoneGetPwd;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
//    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [mutabDict setObject:self.phoneField.text forKey:@"phone"];
//    self.PhoneStr = self.phoneField.text;
//    [mutabDict setObject:_YZMField.text forKey:@"code"];
//    [mutabDict setObject:_XMMField.text forKey:@"pwd"];
//    [mutabDict setObject:_XMMField.text forKey:@"repwd"];
    
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    [mutabDict setObject:@"refound" forKey:@"token"];
    
    [mutabDict setObject:self.phoneField.text forKey:@"phone"];
    self.PhoneStr = self.phoneField.text;
    [mutabDict setObject:_YZMField.text forKey:@"code"];
    [mutabDict setObject:_XMMField.text forKey:@"pwd"];
    [mutabDict setObject:_XMMField.text forKey:@"repwd"];
    
    
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
            if ([_typeStr integerValue] == 123) {//说明是从设置界面退出登陆的
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


#pragma mark --- 其他

-(void)thenGo
{
    [UIView animateWithDuration:0.3 animations:^{
        _waitView.alpha =0;
    }];
}

//键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




@end
