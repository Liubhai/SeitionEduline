//
//  YXZHViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/29.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "YXZHViewController.h"
#import "ZHCGViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "AppDelegate.h"
#import "TKProgressHUD+Add.h"
#import "SYG.h"



@interface YXZHViewController ()

@property (strong ,nonatomic)UITextField *YXField;

@property (strong ,nonatomic)UITextField *MMField;

@end

@implementation YXZHViewController

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
    [self addYX];

}

- (void)initer {
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    self.navigationItem.title = @"找回密码";
    
    
    
}

- (void)addYX {
    
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
        
    }
    
    
    //添加呢称
    _YXField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 50)];
    _YXField.placeholder = @"邮箱";
    _YXField.backgroundColor = [UIColor whiteColor];
    _YXField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _YXField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_YXField];

//
//    //验证码
//    _MMField= [[UITextField alloc] initWithFrame:CGRectMake(0, 151, MainScreenWidth, 50)];
//    _MMField.placeholder = @"请输入6-12位字符的新密码";
//    _MMField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
//    _MMField.leftViewMode = UITextFieldViewModeAlways;
//    _MMField.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_MMField];
    
    //提交
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 190, MainScreenWidth - 40, 45)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(TJButton) forControlEvents:UIControlEventTouchUpInside];
    TJButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    TJButton.layer.cornerRadius = 4;
    [self.view addSubview:TJButton];
    
}

- (void)TJButton {

    if (_YXField.text.length == 0) {
        [TKProgressHUD showError:@"请输入邮箱" toView:self.view];
    } else {
//        [self YXNetWork];
        [self netWorkPassportDoFindPasswordByEmail];
    }
    
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)YXNetWork {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:_YXField.text forKey:@"email"];
    
    [manager YXPWDSendCode:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {//成功
            [TKProgressHUD showSuccess:@"找回成功" toView:self.view];
            if ([_typeStr integerValue] == 123) {//说明是从设置界面退出登陆的
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }

        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark --- 邮箱找回
//通过手机找回密码
- (void)netWorkPassportDoFindPasswordByEmail {
    
    NSString *endUrlStr = YunKeTang_passport_doFindPasswordByEmail;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_YXField.text.length == 0) {
        [TKProgressHUD showError:@"请输入邮箱" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_YXField.text forKey:@"email"];
    }
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
//    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if (dict.allKeys.count > 0) {
                [TKProgressHUD showError:@"操作成功" toView:self.view];
                if ([_typeStr integerValue] == 123) {//说明是从设置界面退出登陆的
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                } else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
