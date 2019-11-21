//
//  SJZCViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/20.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SJZCViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "PhoneMd.h"
#import "MyHttpRequest.h"
#import "MZTimerLabel.h"
#import "MyViewController.h"
#import "BaseClass.h"
#import "ReMD.h"
#import "Passport.h"
#import "AppDelegate.h"
#import "UIView+Utils.h"
#import "TKProgressHUD+Add.h"

#import "XYViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "Good_PersonFaceRegisterViewController.h"




@interface SJZCViewController ()
{
    BaseClass *base;
    UIImageView *_imgV ;
    int _tempnum;
}

@property (strong ,nonatomic)UITextField *PhoneField;

@property (strong ,nonatomic)UITextField *NameField;

@property (strong ,nonatomic)UITextField *PassField;

//邀请码
//@property (strong ,nonatomic)UITextField *YQMField;


@property (strong ,nonatomic)UITextField *YZMField;

@property (strong ,nonatomic)UIView *waitView;

@property (strong ,nonatomic)UILabel *waitLabel;

@property (strong ,nonatomic)NSTimer *timer;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)UIButton *YZMButton;

@property (strong ,nonatomic)NSArray     *getFaceSceneArray;
@property (strong ,nonatomic)NSString    *faceOpenStr;
@property (strong ,nonatomic)NSDictionary *resigerSuccessDict;
@property (strong ,nonatomic)NSDictionary *faceSceneDataSource;

@property (strong ,nonatomic)NSDictionary *codeDict;//手机验证码的字典

@end

@implementation SJZCViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if ([self.type isEqualToString:@"123"]) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if ([self.type isEqualToString:@"123"]) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initer];
    [self addPhone];
    [self NetWorkGetFaceScene];

}

- (void)initer {
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    self.navigationItem.title = @"注册";
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFaceOrRegister:) name:@"NSNotificationCenterFaceLoginOrRegister" object:nil];
}

- (void)addPhone {
    
    
    //添加View
    UIView *NavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    NavView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self.view addSubview:NavView];
    
    //添加按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 55, 50)];
    [backButton setImage:[UIImage imageNamed:@"ZCZC"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:backButton];
    
    //添加
    UILabel *ZCLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 25, 100, 30)];
    ZCLabel.textAlignment = NSTextAlignmentCenter;
    ZCLabel.text = @"注册";
    ZCLabel.textColor = [UIColor whiteColor];
    ZCLabel.font = [UIFont systemFontOfSize:20];
    [NavView addSubview:ZCLabel];
    
    //添加登录按钮
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [addButton addTarget:self action:@selector(addPressed) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"登录" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [NavView addSubview:addButton];
    addButton.hidden = YES;
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(10, 40, 55, 50);
        ZCLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        addButton.frame = CGRectMake(MainScreenWidth - 50, 40, 40, 40);
    }
    
    //添加手机号
    _PhoneField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 50)];
    _PhoneField.placeholder = @"请输入手机号";
    _PhoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _PhoneField.leftViewMode = UITextFieldViewModeAlways;
    _PhoneField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_PhoneField];
    _PhoneField.userInteractionEnabled = YES;
    
    //添加发送验证码
    UIButton *YZMButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 7 + 100, 80, 36)];
    [YZMButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [YZMButton addTarget:self action:@selector(YZMButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    YZMButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [YZMButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    YZMButton.layer.cornerRadius = 3;
    YZMButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:YZMButton];
    _YZMButton = YZMButton;
    
    //添加呢称
    _NameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 202, MainScreenWidth, 50)];
    _NameField.placeholder = @"请输入昵称";
    _NameField.backgroundColor = [UIColor whiteColor];
    _NameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _NameField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_NameField];
    
    //添加验证码
    _YZMField = [[UITextField alloc] initWithFrame:CGRectMake(0, 151, MainScreenWidth, 50)];
    _YZMField.placeholder = @"请输入验证码";
    _YZMField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _YZMField.leftViewMode = UITextFieldViewModeAlways;
    _YZMField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_YZMField];
    
    //添加密码
    _PassField = [[UITextField alloc] initWithFrame:CGRectMake(0, 253, MainScreenWidth, 50)];
    _PassField.placeholder = @"请输入密码";
    _PassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _PassField.leftViewMode = UITextFieldViewModeAlways;
    _PassField.backgroundColor = [UIColor whiteColor];
    _PassField.secureTextEntry = YES;//密码形式
    [self.view addSubview:_PassField];
    
//    //添加密码
//    _YQMField = [[UITextField alloc] initWithFrame:CGRectMake(0, 304, MainScreenWidth, 50)];
//    _YQMField.placeholder = @"请输入邀请码";
//    _YQMField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
//    _YQMField.leftViewMode = UITextFieldViewModeAlways;
//    _YQMField.backgroundColor = [UIColor whiteColor];
//    _YQMField.secureTextEntry = YES;//密码形式
//    [self.view addSubview:_YQMField];
    
    //添加按钮
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 355, MainScreenWidth - 40, 45)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(TJButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    TJButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    TJButton.layer.cornerRadius = 4;
    [self.view addSubview:TJButton];

    //服务协议
    _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(TJButton.current_x, TJButton.current_y_h +20, 15, 15)];
    [self.view addSubview:_imgV];
    _imgV.image = [UIImage imageNamed:@"gl未选中"];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(_imgV.current_x_w +3, _imgV.current_y, 86, 15)];
    [self.view addSubview:lab];
    lab.text = @"我已阅读并同意";
    lab.textColor = [UIColor grayColor];
    lab.font = [UIFont systemFontOfSize:12];
    lab.textAlignment = NSTextAlignmentLeft;
    
    UIButton *FWbtn = [[UIButton alloc]initWithFrame:CGRectMake(lab.current_x_w, lab.current_y, 200, 15)];
    [self.view addSubview:FWbtn];
    [FWbtn setTitle:@"《云课堂服务协议》" forState:UIControlStateNormal];
    [FWbtn setTitle:[NSString stringWithFormat:@"《%@服务协议》",AppName] forState:UIControlStateNormal];
    [FWbtn setTitleColor:BasidColor forState:UIControlStateNormal];
    FWbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    FWbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    FWbtn.backgroundColor = [UIColor redColor];
    FWbtn.alpha = 0.8;
    [FWbtn addTarget:self action:@selector(XYView) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(TJButton.current_x, TJButton.current_y_h +20, 100, 15)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    _tempnum = 1;
    
}
-(void)XYView{
    
    [self.navigationController pushViewController:[XYViewController new] animated:YES];
    
}
- (void)TJButtonCilck {
    
    if (_tempnum == 1) {
        [TKProgressHUD showError:@"请先同意《云课堂服务协议》" toView:self.view];
        [TKProgressHUD showError:[NSString stringWithFormat:@"请先同意《%@服务协议》",AppName] toView:self.view];
        return;
    }
    
    if (_PhoneField.text.length == 0 || _PhoneField.text.length != 11 ) {
        [TKProgressHUD showError:@"请输入手机号或正确的格式" toView:self.view];
        return;
    }else if (_YZMField.text.length == 0){
        [TKProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }else if (_PassField.text.length == 0){
        [TKProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }    
    
    if (_loginType) {//第三方绑定
        [self loginWithType];
    } else {
//        [self netWorkPassportClickRepwdCode];
        [self TJNetWork];
    }
    
}

-(void)sure{
    
    if (_tempnum == 0) {
        _imgV.image = [UIImage imageNamed:@"gl未选中"];
        _tempnum = 1;
        
    }else{
        
        _imgV.image = [UIImage imageNamed:@"gl选中"];
        _tempnum = 0;
    }
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addPressed {
}

- (void)YZMButtonPressed {

    if (_PhoneField.text.length == 0 || _PhoneField.text.length != 11 ) {
        [TKProgressHUD showError:@"请输入手机号或正确的格式" toView:self.view];
        return;
        
    } else {
        
        NSString *endUrlStr = YunKeTang_sms_getRegphoneCode;
        NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
        
//        NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//        [mutabDict setValue:self.NameField.text forKey:@"uname"];
//        [mutabDict setValue:self.PassField.text forKey:@"upwd"];

        
        
        
        NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
        NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
        
        NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@reg",timeSp,NetKey]];
        [mutabDict setObject:ggg forKey:@"hextime"];
        [mutabDict setObject:tokenStr forKey:@"token"];
        [mutabDict setObject:@"reg" forKey:@"type"];
        [mutabDict setObject:_PhoneField.text forKey:@"phone"];
        
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
            _codeDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
            if ([[_codeDict stringValueForKey:@"code"] integerValue] == 0) {
                [TKProgressHUD showError:[_codeDict stringValueForKey:@"msg"] toView:self.view];
                return ;
            } else if ([[_codeDict stringValueForKey:@"code"] integerValue] == 1) {
                _codeDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                _number = 0;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
                _YZMButton.enabled = NO;
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        [op start];
    }
}

- (void)timePast {
    
    _number ++;
    NSInteger endTime = 60 - _number;
    NSString *endString = [NSString stringWithFormat:@"%ld", endTime];
    NSString *MStr = [NSString stringWithFormat:@"%@S后重发",endString];
    [_YZMButton setTitle:MStr forState:UIControlStateNormal];
    
    if ([_YZMButton.titleLabel.text isEqualToString:@"0S后重发"]) {
        
        _YZMButton.enabled = YES;
        [_YZMButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _number = 0;
    }
}

-(void)thenGo
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _waitView.alpha =0;
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}



//验证码是否正确
- (void)netWorkPassportClickRepwdCode {
    
    NSString *endUrlStr = YunKeTang_passport_clickRepwdCode;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [mutabDict setObject:self.PhoneField.text forKey:@"login"];
//    [mutabDict setObject:_NameField.text forKey:@"uname"];
//    [mutabDict setObject:_PassField.text forKey:@"password"];
//    [mutabDict setObject:@"2" forKey:@"type"];
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
            [self TJNetWork];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




- (void)TJNetWork {

    NSString *endUrlStr = YunKeTang_passport_regist;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:self.PhoneField.text forKey:@"login"];
    [mutabDict setObject:_NameField.text forKey:@"uname"];
    [mutabDict setObject:_PassField.text forKey:@"password"];
    [mutabDict setObject:@"2" forKey:@"type"];
    [mutabDict setObject:_YZMField.text forKey:@"code"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        _codeDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_codeDict stringValueForKey:@"code"] integerValue] == 0) {
            [TKProgressHUD showError:[_codeDict stringValueForKey:@"msg"] toView:self.view];
            return ;
        } else if ([[_codeDict stringValueForKey:@"code"] integerValue] == 1) {
            _codeDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            base = [BaseClass modelObjectWithDictionary:responseObject];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
            [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"only_login_key"] forKey:@"only_login_key"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Passport userDataWithSavelocality:base.data];
            });
            [TKProgressHUD showSuccess:@"注册成功" toView:self.view];
            MyViewController *myVC = [[MyViewController alloc] init];

            if ([_type isEqualToString:@"123"]) {
                //说明不是第一次
                 [self.navigationController pushViewController:myVC animated:YES];
            } else {//第一次
                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

#pragma mark --- 第三方登录

- (void)loginWithType {
    NSString *endUrlStr = YunKeTang_passport_regist;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:self.NameField.text forKey:@"uname"];
    [mutabDict setValue:self.PassField.text forKey:@"password"];
    [mutabDict setValue:_loginType forKey:@"type_oauth"];
    [mutabDict setValue:@"2" forKey:@"type"];
    [mutabDict setValue:_appToken forKey:@"type_uid"];
    [mutabDict setObject:self.PhoneField.text forKey:@"login"];
    [mutabDict setObject:_YZMField.text forKey:@"code"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        _codeDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_codeDict stringValueForKey:@"code"] integerValue] == 0) {
            [TKProgressHUD showError:[_codeDict stringValueForKey:@"msg"] toView:self.view];
            return ;
        } else if ([[_codeDict stringValueForKey:@"code"] integerValue] == 1) {
            _codeDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_faceOpenStr integerValue] == 0) {
                [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"oauth_token"] forKey:@"oauthToken"];
                [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"oauth_token_secret"] forKey:@"oauthTokenSecret"];
                [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"uid"] forKey:@"User_id"];
                [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"userface"] forKey:@"userface"];
                [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"only_login_key"] forKey:@"only_login_key"];
                
                [TKProgressHUD showSuccess:@"注册成功" toView:self.view];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                if ([self.type isEqualToString:@"123"]) {//从设置页面过来
                    MyViewController *myVC = [[MyViewController alloc] init];
                    [self.navigationController pushViewController:myVC animated:YES];
                } else {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            } else if ([_faceOpenStr integerValue] == 1){
                [self isBoundFace];
            }
        } else {
            [TKProgressHUD showError:[_codeDict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


#pragma mark --- 提示是否绑定人脸 （注册的时候绑定人脸）
- (void)isBoundFace {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有绑定人脸，是否需要现在去绑定？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self resignFace];
    }];
    [alertController addAction:sureAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (_loginType) {//正在第三方登录
            [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"oauth_token"] forKey:@"oauthToken"];
            [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"oauth_token_secret"] forKey:@"oauthTokenSecret"];
            [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"uid"] forKey:@"User_id"];
            [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"userface"] forKey:@"userface"];
            [[NSUserDefaults standardUserDefaults]setObject:[_codeDict stringValueForKey:@"only_login_key"] forKey:@"only_login_key"];
            
            [TKProgressHUD showSuccess:@"注册成功" toView:self.view];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            if ([self.type isEqualToString:@"123"]) {//从设置页面过来
                MyViewController *myVC = [[MyViewController alloc] init];
                [self.navigationController pushViewController:myVC animated:YES];
            } else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [self backPressed];
            [self backPressed];
        }

    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)resignFace {
    Good_PersonFaceRegisterViewController *vc = [[Good_PersonFaceRegisterViewController alloc] init];
    vc.typeStr = @"1";
    vc.tryStr = @"1";
    vc.tokenAndTokenSerectDict = _resigerSuccessDict;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --- 网络请求
#pragma mark --- 人脸识别配置的接口
//获取人脸识别的配置接口
- (void)NetWorkGetFaceScene {
    
    NSString *endUrlStr = YunKeTang_config_getFaceScene;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _faceSceneDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_faceSceneDataSource stringValueForKey:@"code"] integerValue] == 0) {
            [TKProgressHUD showError:[_faceSceneDataSource stringValueForKey:@"msg"] toView:self.view];
            return ;
        } else if ([[_faceSceneDataSource stringValueForKey:@"code"] integerValue] == 1) {
            _faceSceneDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        }
        
        _getFaceSceneArray = [_faceSceneDataSource arrayValueForKey:@"open_scene"];
        _faceOpenStr = [_faceSceneDataSource stringValueForKey:@"is_open"];
        BOOL isScene = NO;
        for (NSString *typeStr in _getFaceSceneArray) {
            if ([typeStr isEqualToString:@"login_force_verify"]) {//说明配置的有考试相关的
                isScene = YES;
            }
            if ([typeStr isEqualToString:@"login"]) {
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//第三方登录



#pragma mark --- 通知
- (void)getFaceOrRegister:(NSNotification *)not {
    
    [[NSUserDefaults standardUserDefaults]setObject:[_resigerSuccessDict stringValueForKey:@"oauth_token"] forKey:@"oauthToken"];
    [[NSUserDefaults standardUserDefaults]setObject:[_resigerSuccessDict stringValueForKey:@"oauth_token_secret"] forKey:@"oauthTokenSecret"];
    [[NSUserDefaults standardUserDefaults]setObject:[_resigerSuccessDict stringValueForKey:@"uid"] forKey:@"User_id"];
    [[NSUserDefaults standardUserDefaults]setObject:[_resigerSuccessDict stringValueForKey:@"userface"] forKey:@"userface"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [Passport userDataWithSavelocality:base.data];
    });
    
    //应该直接到我的主界面
    MyViewController *myVC = [[MyViewController alloc] init];
    if ([_type isEqualToString:@"123"]) {
        [self.navigationController pushViewController:myVC animated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}






@end
