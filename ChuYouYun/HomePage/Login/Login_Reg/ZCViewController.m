//
//  ZCViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/20.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ZCViewController.h"
#import "UMSocial.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "TKProgressHUD+Add.h"

#import "ReMD.h"
#import "Passport.h"
#import "rootViewController.h"
#import "BaseClass.h"
#import "SJZCViewController.h"
#import "MyViewController.h"
#import "AppDelegate.h"
#import "UIView+Utils.h"
#import "XYViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "Good_PersonFaceRegisterViewController.h"



@interface ZCViewController ()

{
    BaseClass *base;
    UIImageView *_imgV ;
    int _tempnum;
}

@property (strong ,nonatomic)UITextField *EmailField;

@property (strong ,nonatomic)UITextField *NameField;

@property (strong ,nonatomic)UITextField *PassField;

@property (strong ,nonatomic)NSArray     *getFaceSceneArray;
@property (strong ,nonatomic)NSString    *faceOpenStr;
@property (strong ,nonatomic)NSDictionary *resigerSuccessDict;
@property (strong ,nonatomic)NSDictionary *dataSource;
@property (strong ,nonatomic)NSDictionary *faceSceneDataSource;


@end

@implementation ZCViewController

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
    [self addInfor];
    [self NetWorkGetFaceScene];
}

- (void)initer {
    
    NSLog(@"%@",self.type);
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    self.navigationItem.title = @"注册";
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFaceOrRegister:) name:@"NSNotificationCenterFaceLoginOrRegister" object:nil];
}

- (void)addInfor {
    
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
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(10, 40, 55, 50);
        ZCLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        addButton.frame = CGRectMake(MainScreenWidth - 50, 40, 40, 40);
    }
    
    //添加邮箱
    _EmailField = [[UITextField alloc] initWithFrame:CGRectMake(0, 151, MainScreenWidth, 50)];
    _EmailField.placeholder = @"邮箱";
    _EmailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _EmailField.leftViewMode = UITextFieldViewModeAlways;
    _EmailField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_EmailField];
    
    //添加呢称
    _NameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 50)];
    _NameField.placeholder = @"昵称";
    _NameField.backgroundColor = [UIColor whiteColor];
    _NameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _NameField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_NameField];
    
    //添加密码
    _PassField = [[UITextField alloc] initWithFrame:CGRectMake(0, 202, MainScreenWidth, 50)];
    _PassField.placeholder = @"密码";
    _PassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _PassField.leftViewMode = UITextFieldViewModeAlways;
    _PassField.backgroundColor = [UIColor whiteColor];
    _PassField.secureTextEntry = YES;//密码形式
    [self.view addSubview:_PassField];
    
    
    //添加按钮
    
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, MainScreenWidth - 40, 45)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(TJButton:) forControlEvents:UIControlEventTouchUpInside];
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
    
    //添加手机注册
    UIButton *SJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 260, 100, 30)];
    [SJButton setTitle:@"手机注册" forState:UIControlStateNormal];
    [SJButton setTitleColor:[UIColor colorWithRed:33.f / 255 green:87.f / 255 blue:198.f / 255 alpha:1] forState:UIControlStateNormal];
    SJButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [SJButton addTarget:self action:@selector(SJButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SJButton];
    
    if ([_registerStr isEqualToString:@"email"]) {
        SJButton.hidden = YES;
    }
    
}

-(void)XYView{

    [self.navigationController pushViewController:[XYViewController new] animated:YES];
    
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
    
    [self.navigationController popViewControllerAnimated:YES];
}
//手机注册
- (void)SJButton:(UIButton *)button {
    
    SJZCViewController *SJZCVC = [[SJZCViewController alloc] init];
    
    if ([_type isEqualToString:@"123"]) {
        SJZCVC.type = @"123";
    }
    [self.navigationController pushViewController:SJZCVC animated:YES];
}

- (void)TJButton:(UIButton *)button {
    if (_tempnum == 1) {
        [TKProgressHUD showError:[NSString stringWithFormat:@"请先同意《%@服务协议》",AppName] toView:self.view];
        return;
    }
    if (self.EmailField.text.length == 0 || self.NameField.text.length == 0 || self.PassField.text.length == 0) {
        [TKProgressHUD showError:@"请提交所需完善资料" toView:self.view];
        return;
    }
    [self.EmailField resignFirstResponder];
    [self.NameField resignFirstResponder];
    [self.PassField resignFirstResponder];
    [self TJNetWorkPassportRegist];
}

-(void)thenGo {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:self.EmailField.text forKey:@"uname"];
    [dic setValue: self.PassField.text forKey:@"upwd"];
    [manager userLogin:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (base.code == 0) {
            _resigerSuccessDict = [responseObject dictionaryValueForKey:@"data"];
            if ([_faceOpenStr integerValue] == 0) {//没有开启人脸识别功能
                base = [BaseClass modelObjectWithDictionary:responseObject];
                [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
                [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
                [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
                [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
                
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
            } else if ([_faceOpenStr integerValue] == 1) {//开启了人脸识别的功能
                [self isBoundFace];
            }

        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登陆错误" message:base.msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark --- 提示是否绑定人脸
- (void)isBoundFace {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有绑定人脸，是否需要现在去绑定？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self resignFace];
    }];
    [alertController addAction:sureAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self backPressed];
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


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户信息不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
    }
    return YES;
}


- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark --- 网络请求
- (void)TJNetWorkPassportRegist {
    
    NSString *endUrlStr = YunKeTang_passport_regist;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:self.EmailField.text forKey:@"login"];
    [mutabDict setValue:self.NameField.text forKey:@"uname"];
    [mutabDict setValue:self.PassField.text forKey:@"password"];
    [mutabDict setValue:@"1" forKey:@"type"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {//注册成功 直接去登录
            [TKProgressHUD showError:@"注册成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backPressed];
            });
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//注册完登录接口
- (void)LoginRequset {
    
    NSString *endUrlStr = YunKeTang_passport_login;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:self.NameField.text forKey:@"uname"];
    [mutabDict setValue:self.PassField.text forKey:@"upwd"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 0) {
            [TKProgressHUD showError:[_dataSource stringValueForKey:@"msg"] toView:self.view];
            return ;
        } else if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        }
        
        if ([_faceOpenStr integerValue] == 0) {//没有开启人脸识别功能
            [[NSUserDefaults standardUserDefaults]setObject:[_dataSource stringValueForKey:@"oauth_token"] forKey:@"oauthToken"];
            [[NSUserDefaults standardUserDefaults]setObject:[_dataSource stringValueForKey:@"oauth_token_secret"] forKey:@"oauthTokenSecret"];
            [[NSUserDefaults standardUserDefaults]setObject:[_dataSource stringValueForKey:@"uid"] forKey:@"User_id"];
            [[NSUserDefaults standardUserDefaults]setObject:[_dataSource stringValueForKey:@"userface"] forKey:@"userface"];

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
        } else if ([_faceOpenStr integerValue] == 1) {//开启了人脸识别的功能
            [self isBoundFace];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

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
