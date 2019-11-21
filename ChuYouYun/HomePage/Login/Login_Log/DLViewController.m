//
//  DLViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/20.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕


#import "DLViewController.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "UMSocial.h"
#import "MyHttpRequest.h"
#import "BaseClass.h"
#import "Data.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "MyViewController.h"
#import "ZCViewController.h"
#import "WJMMViewController.h"
#import "MyViewController.h"
#import "AppDelegate.h"
#import "SJZCViewController.h"

//人脸识别
#import "DetectionViewController.h"
#import "NetAccessModel.h"
#import "Good_PersonFaceRegisterViewController.h"
#import "YunKeTang_Api_Tool.h"
#import "Api_Config.h"


@interface DLViewController ()<UMSocialUIDelegate>

{
    BaseClass *base;
    UIImage   *faceImage;
    BOOL      isFaceLogin;
    BOOL      isNameFaceLogin;
}

@property (strong ,nonatomic)UITextField *NameField;

@property (strong ,nonatomic)UITextField *PassField;

@property (strong ,nonatomic)UIButton *backButton;
@property (strong ,nonatomic)UIButton *addButton;

@property (strong ,nonatomic)NSString *loginType;
@property (strong ,nonatomic)NSString *UID;
@property (strong ,nonatomic)NSString *appToken;

//几个关键的按钮
@property (strong ,nonatomic)UIButton  *DLButton;
@property (strong ,nonatomic)UIButton  *WJButton;
@property (strong ,nonatomic)UIButton  *YKButton;
@property (strong ,nonatomic)UIButton  *faceButton;

//人脸识别
@property (strong ,nonatomic)NSString *faceID;
@property (strong ,nonatomic)NSArray  *getFaceSceneArray;
@property (strong ,nonatomic)NSString *faceOpenStr;
@property (strong ,nonatomic)NSString *loginTypeStr;//标示是输入用户名登录还是直接扫脸登录
@property (strong ,nonatomic)NSDictionary *statusDict;
@property (strong ,nonatomic)NSDictionary *loginSuccessDict;//登录成功后的字典

@property (strong ,nonatomic)NSDictionary *dataSource;
@property (strong ,nonatomic)NSDictionary *loginSyncDataSource;
@property (strong ,nonatomic)NSDictionary *faceStatusDataSource;
@property (strong ,nonatomic)NSDictionary *faceSceneDataSource;

//标识符
@property (strong ,nonatomic)NSString *faceOpen;
@property (strong ,nonatomic)NSString *registerConfStr;

@end

@implementation DLViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameAndPassword:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFaceOrRegister:) name:@"NSNotificationCenterFaceLoginOrRegister" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initer];
    [self NavButton];
    [self addInfo];
    [self NetWorkGetFaceScene];
    [self NetWorkPassportRegisterConf];
//    [self NetWorkGetFaceStatus];

}

- (void)initer {
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    self.navigationItem.title = @"登录";
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    isFaceLogin = NO;
    isNameFaceLogin = NO;
    _loginTypeStr = @"0";//1 是用户名登录  // 2 为直接扫脸登录  // 0 为初始化的值
}

- (void)NavButton {
    
    //添加view
    UIView *NavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    NavView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self.view addSubview:NavView];
    
    //添加登录
    UILabel *DLLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 25, 100, 30)];
    DLLabel.text = @"登录";
    DLLabel.textColor = [UIColor whiteColor];
    DLLabel.font = [UIFont systemFontOfSize:20];
    DLLabel.textAlignment = NSTextAlignmentCenter;
    [NavView addSubview:DLLabel];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [addButton addTarget:self action:@selector(addPressed) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"注册" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [NavView addSubview:addButton];
    _addButton = addButton;
    
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 30, 30)];
    [_backButton setImage:[UIImage imageNamed:@"dlgb"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:_backButton];
    
//    if (self.typeStr) {
//        _backButton.hidden = NO;
//        [_backButton addTarget:self action:@selector(goHomeVc) forControlEvents:UIControlEventTouchUpInside];
//    }else {
//        _backButton.hidden = NO;
//    }
    
    
    if (iPhoneX) {
        _backButton.frame = CGRectMake(10, 40, 30, 30);
        DLLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        addButton.frame = CGRectMake(MainScreenWidth - 50, 40, 40, 40);
    }
    

}

//退出登录界面
- (void)backPressed {
    if ([_typeStr integerValue] == 123) {//从账号退出来的
        MyViewController *myVC = [[MyViewController alloc] init];
        [self.navigationController pushViewController:myVC animated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)goHomeVc {
    MyViewController *myVC = [[MyViewController alloc] init];
    [self.navigationController pushViewController:myVC animated:YES];
}

//注册
- (void)addPressed {
    if ([_registerConfStr isEqualToString:@"phone"]) {
        SJZCViewController *SJZCVC = [[SJZCViewController alloc] init];
        if ([_typeStr isEqualToString:@"123"]) {
            SJZCVC.type = @"123";
        }
        [self.navigationController pushViewController:SJZCVC animated:YES];
    } else if ([_registerConfStr isEqualToString:@"email"]) {
        ZCViewController *ZCVC = [[ZCViewController alloc] init];
        ZCVC.registerStr = _registerConfStr;
        if (_backButton.hidden == YES) {//退出账号的
            ZCVC.type = @"123";
        }
        
        if ([_typeStr integerValue] == 123) {
            ZCVC.type = @"123";
        }
        [self.navigationController pushViewController:ZCVC animated:YES];
    } else if ([_registerConfStr isEqualToString:@"all"]) {
        ZCViewController *ZCVC = [[ZCViewController alloc] init];
        if (_backButton.hidden == YES) {//退出账号的
            ZCVC.type = @"123";
        }
        if ([_typeStr integerValue] == 123) {
            ZCVC.type = @"123";
        }
        [self.navigationController pushViewController:ZCVC animated:YES];
    }
}

//用户名和密码限制长度为20
- (void)nameAndPassword:(NSNotification *)Not {
    NSLog(@"%@",Not.userInfo);
    if (_NameField.text.length >= 20) {

         self.NameField.text = [self.NameField.text substringToIndex:20];
        
    }
    if (_PassField.text.length >= 20) {

         self.PassField.text = [self.PassField.text substringToIndex:20];
    }
    
}

#pragma mark --- 通知
- (void)getFaceOrRegister:(NSNotification *)not {
    
    [[NSUserDefaults standardUserDefaults]setObject:[_loginSuccessDict stringValueForKey:@"oauth_token"] forKey:@"oauthToken"];
    [[NSUserDefaults standardUserDefaults]setObject:[_loginSuccessDict stringValueForKey:@"oauth_token_secret"] forKey:@"oauthTokenSecret"];
    [[NSUserDefaults standardUserDefaults]setObject:[_loginSuccessDict stringValueForKey:@"uid"] forKey:@"User_id"];
    [[NSUserDefaults standardUserDefaults]setObject:[_loginSuccessDict stringValueForKey:@"userface"] forKey:@"userface"];
    [[NSUserDefaults standardUserDefaults]setObject:self.NameField.text forKey:@"uname"];
    [[NSUserDefaults standardUserDefaults]setObject:self.PassField.text forKey:@"upwd"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [Passport userDataWithSavelocality:base.data];
    });
    
    //应该直接到我的主界面
    MyViewController *myVC = [[MyViewController alloc] init];
    if ([self.typeStr isEqualToString:@"123"]) {
        [self.navigationController pushViewController:myVC animated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)coverButtonTouch {
    [_NameField becomeFirstResponder];
}

- (void)addInfo {
    
    //添加输入文本框
    _NameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, MainScreenWidth, 50)];
    _NameField.placeholder = @"请输入邮箱/手机号/用户名";
    _NameField.backgroundColor = [UIColor whiteColor];
    _NameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
    _NameField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_NameField];
    
    /// 这个过度的 UITextField 是为了解决 12系统上 当手机只有搜狗输入法的时候,页面有两个或者两个以上的 UITextField 设置了 secureTextEntry 之后,相邻的 UITextField 也会被系统判定成 secureTextEntry 从而导致切换不到搜狗输入法
    UITextField *pass = [[UITextField alloc] initWithFrame:CGRectMake(0, _NameField.bottom, MainScreenWidth, 0.5)];
    [self.view addSubview:pass];
    
    /// 为了覆盖这个 0.5 的 textField
    UIButton *coverButton = [[UIButton alloc] initWithFrame:pass.frame];
    [coverButton addTarget:self action:@selector(coverButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:coverButton];
    
    //添加输入图标
    UIButton *nameButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 86 , 13, 18)];
    [nameButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shouji@2x"] forState:UIControlStateNormal];
    [self.view addSubview:nameButton];

    //添加密码文本框
    _PassField = [[UITextField alloc] initWithFrame:CGRectMake(0, coverButton.bottom, MainScreenWidth , 50)];
    _PassField.placeholder = @"请输入密码";
    _PassField.backgroundColor = [UIColor whiteColor];
    _PassField.secureTextEntry = YES;//密码形式
    _PassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
    _PassField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_PassField];
    
    
    //添加密码图标
    UIButton *MMButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 121 + 16, 13, 18)];
    [MMButton setBackgroundImage:[UIImage imageNamed:@"iconfont-mima@2x"] forState:UIControlStateNormal];
    [self.view addSubview:MMButton];
    
    
    //添加登录按钮
    UIButton *DLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    DLButton.frame = CGRectMake(20, 210, MainScreenWidth - 40, 45);
    [DLButton setTitle:@"登录" forState:UIControlStateNormal];
    [DLButton addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
    DLButton.tag = 10;
    DLButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [DLButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    DLButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    DLButton.layer.cornerRadius = 4;
    _DLButton = DLButton;
    [self.view addSubview:DLButton];
    
    
    UIButton *YKButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(DLButton.frame) + 30, MainScreenWidth / 3, 20)];
    [YKButton setTitle:@"游客登录" forState:UIControlStateNormal];
    YKButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [YKButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [YKButton addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
    YKButton.tag = 30;
    _YKButton = YKButton;
    _YKButton.hidden = YES;
    [self.view addSubview:YKButton];
    
    //添加忘记密码按钮
    UIButton *WJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 3 * 2, CGRectGetMaxY(DLButton.frame) + 30, MainScreenWidth / 3, 20)];
    [WJButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    WJButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [WJButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [WJButton addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
    WJButton.tag = 20;
    _WJButton = WJButton;
    _WJButton.hidden = YES;
    [self.view addSubview:WJButton];
    
    //添加人脸识别的按钮
    UIButton *faceButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 3, CGRectGetMaxY(DLButton.frame) + 30, MainScreenWidth / 3, 20)];
    [faceButton setTitle:@"刷脸登录" forState:UIControlStateNormal];
    faceButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [faceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
    faceButton.tag = 40;
    _faceButton = faceButton;
    _faceButton.hidden = YES;
    [self.view addSubview:faceButton];
    
    
    
    

    if (self.typeStr) {//说明是从退出账号过来的
//        UIButton *YKButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 3 * 2, CGRectGetMaxY(DLButton.frame) + 30, MainScreenWidth / 3, 20)];
//        [YKButton setTitle:@"游客登录" forState:UIControlStateNormal];
//        YKButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        [YKButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [YKButton addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
//        YKButton.tag = 30;
//        _YKButton = YKButton;
//        [self.view addSubview:YKButton];

        //设置忘记密码的位置
        WJButton.frame = CGRectMake(0, CGRectGetMaxY(DLButton.frame) + 30, MainScreenWidth / 3, 20);
        
        //设置人脸识别的位置
        faceButton.frame =  CGRectMake(MainScreenWidth / 3 , CGRectGetMaxY(DLButton.frame) + 30, MainScreenWidth / 3, 20);
        
        
    }
    
    if (iPhone4SOriPhone4) {
        
        //添加横线
        UIButton *ZButton = [[UIButton alloc] initWithFrame:CGRectMake(0,MainScreenHeight / 5 * 3 + 50, MainScreenWidth / 2 - 60, 1)];
        ZButton.backgroundColor = [UIColor colorWithRed:223.f / 255 green:223.f / 255 blue:223.f / 255 alpha:1];
        [self.view addSubview:ZButton];
        
        UIButton *YButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 + 60,MainScreenHeight / 5 * 3 + 50, MainScreenWidth / 2 - 60, 1)];
        YButton.backgroundColor = [UIColor colorWithRed:223.f / 255 green:223.f / 255 blue:223.f / 255 alpha:1];
        [self.view addSubview:YButton];
        
        //添加第三方登录
        UILabel *SFLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60, MainScreenHeight / 5 * 3 - 15 + 50, 120, 30)];
        SFLabel.text = @"第三方登录";
        SFLabel.textColor = [UIColor colorWithRed:200.f / 255 green:200.f / 255 blue:200.f / 255 alpha:1];
        SFLabel.font = [UIFont systemFontOfSize:14];
        SFLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:SFLabel];
        
        //添加三方登录按钮
        NSArray *SFArray = @[@"微博.png",@"QQ.png",@"微信.png"];
        for (int i = 0 ; i < 3; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 7 + MainScreenWidth / 7  * 2 * i, MainScreenHeight / 5 * 3 + 100, MainScreenWidth / 7, MainScreenWidth / 7)];
            [button setBackgroundImage:[UIImage imageNamed:SFArray[i]] forState:UIControlStateNormal];
            button.tag = i;
            button.layer.cornerRadius = MainScreenWidth / 7 / 2;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
        
    }else {
        
        //添加横线
        UIButton *ZButton = [[UIButton alloc] initWithFrame:CGRectMake(0,MainScreenHeight / 5 * 3 + 50, MainScreenWidth / 2 - 60, 1)];
        ZButton.backgroundColor = [UIColor colorWithRed:223.f / 255 green:223.f / 255 blue:223.f / 255 alpha:1];
        [self.view addSubview:ZButton];
        
        UIButton *YButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 + 60,MainScreenHeight / 5 * 3 + 50, MainScreenWidth / 2 - 60, 1)];
        YButton.backgroundColor = [UIColor colorWithRed:223.f / 255 green:223.f / 255 blue:223.f / 255 alpha:1];
        [self.view addSubview:YButton];
        
        //添加第三方登录
        UILabel *SFLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60, MainScreenHeight / 5 * 3 - 15 + 50, 120, 30)];
        SFLabel.text = @"第三方登录";
        SFLabel.textColor = [UIColor colorWithRed:200.f / 255 green:200.f / 255 blue:200.f / 255 alpha:1];
        SFLabel.font = [UIFont systemFontOfSize:14];
        SFLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:SFLabel];

        //添加三方登录按钮
        NSArray *SFArray = @[@"微博.png",@"QQ.png",@"微信.png"];
        for (int i = 0 ; i < 3; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 7 + MainScreenWidth / 7  * 2 * i, MainScreenHeight / 5 * 3 + 100, MainScreenWidth / 7, MainScreenWidth / 7)];
            [button setBackgroundImage:[UIImage imageNamed:SFArray[i]] forState:UIControlStateNormal];
            button.tag = i;
            button.layer.cornerRadius = MainScreenWidth / 7 / 2;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
    }
    
    if (iPhoneX) {//iphoneX 所有的适配都在这里
        _NameField.frame = CGRectMake(0, 94, MainScreenWidth, 50);
        nameButton.frame = CGRectMake(17, 110, 13, 18);
        _PassField.frame = CGRectMake(0, 145, MainScreenWidth, 50);
        MMButton.frame = CGRectMake(17, 121 + 16 + 24, 13,18);
        DLButton.frame = CGRectMake(20, 225, MainScreenWidth - 40, 45);
    }
}

#pragma mark --- 配置按钮的位置 （忘记密码，人脸识别，游客登录）
- (void)sceneButtons:(BOOL)isScene {
    if (isScene) {//说明是配置有登录的
        _faceButton.hidden = NO;
        _YKButton.hidden = YES;
        _WJButton.hidden = NO;
        if (self.typeStr) {
            _WJButton.frame = CGRectMake(MainScreenWidth / 3 * 2, CGRectGetMaxY(_DLButton.frame) + 30, MainScreenWidth / 3, 20);
            _YKButton.frame = CGRectMake(0, CGRectGetMaxY(_DLButton.frame) + 30, MainScreenWidth / 3, 20);
        }
        _faceButton.centerX = MainScreenWidth / 4.0;
        _WJButton.centerX = MainScreenWidth * 3 / 4.0;
    } else {//配置没有登录的
        _faceButton.hidden = YES;
        _WJButton.hidden = NO;
        if (self.typeStr) {//从设置退出来的
            _WJButton.frame = CGRectMake(MainScreenWidth / 4, CGRectGetMaxY(_DLButton.frame) + 30, MainScreenWidth / 2, 20);
            _YKButton.frame = CGRectMake(0, CGRectGetMaxY(_DLButton.frame) + 30, MainScreenWidth / 3, 20);
            _YKButton.hidden = YES;
        } else {//最先登录的
            _YKButton.frame = CGRectMake(0, CGRectGetMaxY(_DLButton.frame) + 30, MainScreenWidth / 2, 20);
            _YKButton.hidden = YES;
            _WJButton.frame = CGRectMake(MainScreenWidth / 4, CGRectGetMaxY(_DLButton.frame) + 30, MainScreenWidth / 2, 20);
        }
    }
}


- (void)SYGButton:(UIButton *)button {
    
    if (button.tag == 10) {//登录
        _loginTypeStr = @"1";//用户名登录
        [self Login];
    }
    if (button.tag == 20) {//忘记密码
        [self WJMM];
    }
    if (button.tag == 30) {//游客登录
        [self addYKDL];
    }
    if (button.tag == 40) {//人脸识别
        _loginTypeStr = @"2";
        [self faceLogin];
    }
    if (button.tag == 0) {//新浪
        [self Sina];
    }
    if (button.tag == 1) {//扣扣
        [self Tencent];
    }
    if (button.tag == 2) {//微信
        [self WeChat];
    }
    
}

- (void)Login {
    
    if ([_NameField.text isEqual:@""] || _PassField.text.length < 6) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"账号或密码不正确" message:nil delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.NameField resignFirstResponder];
    [self.PassField resignFirstResponder];

    [self LoginRequset];

}

//注册接口的配置
- (void)registerConfDeal {
    if (_registerConfStr == nil) {
        
    } else if ([_registerConfStr isEqualToString:@"phone"]) {
        
    } else if ([_registerConfStr isEqualToString:@"email"]) {
        
    } else if ([_registerConfStr isEqualToString:@"all"]) {
        
    }
}


#pragma mark --- 人脸识别登录

- (void)nameAndPassFaceLogin {
    __weak typeof(self) weakSelf = self;
    DetectionViewController* dvc = [[DetectionViewController alloc] init];
    dvc.completion = ^(NSDictionary* images, UIImage* originImage){
        if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
            NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage* bestImage = [UIImage imageWithData:data];
            NSLog(@"bestImage = %@",bestImage);
            faceImage = bestImage;
            [self netWorkUserUpLoad];
            NSString* bestImageStr = [[images[@"bestImage"] lastObject] copy];
            
            //检测活动的方法
            [[NetAccessModel sharedInstance] detectUserLivenessWithFaceImageStr:bestImageStr completion:^(NSError *error, id resultObject) {
                if (error == nil) {
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
                    if ([dict[@"result_num"] integerValue] > 0) {
                        NSDictionary* d = dict[@"result"][0];
                        NSLog(@"faceliveness = %f",[d[@"face_probability"] floatValue]);
                        if (d[@"faceliveness"] != nil && [d[@"faceliveness"] floatValue] > 0.834963 ) {
                            //                            [weakSelf gotoRegister:bestImageStr originImage:originImage];
                        } else {
                        }
                    }
                }
            }];
        }
    };
    [self presentViewController:dvc animated:YES completion:nil];

}

- (void)faceLogin {
    __weak typeof(self) weakSelf = self;
    DetectionViewController* dvc = [[DetectionViewController alloc] init];
    dvc.completion = ^(NSDictionary* images, UIImage* originImage){
        if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
            NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage* bestImage = [UIImage imageWithData:data];
            NSLog(@"bestImage = %@",bestImage);
            faceImage = bestImage;
            [self netWorkUserUpLoad];
            NSString* bestImageStr = [[images[@"bestImage"] lastObject] copy];
            
            //检测活动的方法
            [[NetAccessModel sharedInstance] detectUserLivenessWithFaceImageStr:bestImageStr completion:^(NSError *error, id resultObject) {
                if (error == nil) {
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
                    if ([dict[@"result_num"] integerValue] > 0) {
                        NSDictionary* d = dict[@"result"][0];
                        NSLog(@"faceliveness = %f",[d[@"face_probability"] floatValue]);
                        if (d[@"faceliveness"] != nil && [d[@"faceliveness"] floatValue] > 0.834963 ) {
                            //                            [weakSelf gotoRegister:bestImageStr originImage:originImage];
                        } else {
                            //                            [weakSelf performSegueWithIdentifier:@"Register2Fail" sender:@{@"image":originImage,@"tip":@"注册人脸非活体",@"subtip":[NSString stringWithFormat:@"活体检测分数:%0.6f",[d[@"faceliveness"] floatValue]],@"kind":@"注册",@"goon":@(0),@"name":@"123456"}];
                        }
                    }
                }
            }];
        }
    };
    [self presentViewController:dvc animated:YES completion:nil];

}



- (void)WJMM {
    
    WJMMViewController *WJMMVC = [[WJMMViewController alloc] init];
    
    WJMMVC.typeStr = self.typeStr;
    
    [self.navigationController pushViewController:WJMMVC animated:YES];
}

- (void)addYKDL {
    if (self.typeStr) {
        MyViewController *myVC = [[MyViewController alloc] init];
        [self.navigationController pushViewController:myVC animated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)Sina {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        
        NSLog(@"-----%@",response);
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            _UID = snsAccount.usid;
            _appToken = snsAccount.accessToken;
            
            [self loginWithSNSAccount:snsAccount loginType:@"sina"];
        }});
}


- (void)Tencent {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        
        NSLog(@"%@",response);
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            _UID = snsAccount.openId;
            _appToken = snsAccount.unionId;
            
            [self loginWithSNSAccount:snsAccount loginType:@"qzone"];
        }});
}

- (void)WeChat {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        NSLog(@"----%@",response);
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            _UID = snsAccount.openId;
            _appToken = snsAccount.unionId;
            
            [self loginWithSNSAccount:snsAccount loginType:@"weixin"];
        }});
    
    
}

- (void)loginWithSNSAccount:(UMSocialAccountEntity *)snsAccount loginType:(NSString *)type
{
    NSString *endUrlStr = YunKeTang_passport_loginSync;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([type isEqualToString:@"sina"]) {
        [mutabDict setValue:snsAccount.accessToken forKey:@"app_token"];
    } else if ([type isEqualToString:@"qzone"]){
        [mutabDict setValue:snsAccount.usid forKey:@"app_token"];
    } else {
        [mutabDict setValue:snsAccount.unionId forKey:@"app_token"];
    }
    [mutabDict setValue:type forKey:@"app_login_type"];
    [[NSUserDefaults standardUserDefaults]setObject:type forKey:@"loginType"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        _loginType = type;
        _loginSyncDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_loginSyncDataSource stringValueForKey:@"code"] integerValue] == 0) {//未绑定
            [self type_regis];
            return ;
        } else if ([[_loginSyncDataSource stringValueForKey:@"code"] integerValue] == 1) {
            _loginSyncDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:[_loginSyncDataSource stringValueForKey:@"oauth_token"] forKey:@"oauthToken"];
        [[NSUserDefaults standardUserDefaults]setObject:[_loginSyncDataSource stringValueForKey:@"oauth_token_secret"] forKey:@"oauthTokenSecret"];
//        [[NSUserDefaults standardUserDefaults]setObject:[_loginSyncDataSource stringValueForKey:@"uid"] forKey:@"User_id"];
        [[NSUserDefaults standardUserDefaults]setObject:[_loginSyncDataSource stringValueForKey:@"userface"] forKey:@"userface"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPayMethodConfig" object:nil];
        rootViewController *blum = [[rootViewController alloc]init];
        self.view.window.rootViewController = blum;
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

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
            if ([_faceOpenStr integerValue] == 1) {//说明人脸识别开启了的
                if (isNameFaceLogin) {//开启了强制登录
                    //应该先判断是否绑定人脸
                    _loginSuccessDict = _dataSource;
//                    [self NetWorkGetFaceStatus];
                    [self NetWorkYouTuIsExist];
                    return;
                } else {//没有开启
                    
                }
            }
        }
        
        NSLog(@"%@",_dataSource);
        
        NSLog(@"%@",operation);
        base = [BaseClass modelObjectWithDictionary:responseObject];
        [[NSUserDefaults standardUserDefaults]setObject:[_dataSource stringValueForKey:@"oauth_token"] forKey:@"oauthToken"];
        [[NSUserDefaults standardUserDefaults]setObject:[_dataSource stringValueForKey:@"oauth_token_secret"] forKey:@"oauthTokenSecret"];
        [[NSUserDefaults standardUserDefaults]setObject:[_dataSource stringValueForKey:@"uid"] forKey:@"User_id"];
        [[NSUserDefaults standardUserDefaults]setObject:[_dataSource stringValueForKey:@"userface"] forKey:@"userface"];
        [[NSUserDefaults standardUserDefaults]setObject:[_dataSource stringValueForKey:@"only_login_key"] forKey:@"only_login_key"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPayMethodConfig" object:nil];
        if (base.code == 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Passport userDataWithSavelocality:base.data];
            });
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            if ([self.typeStr isEqualToString:@"123"]) {//从设置页面过来
                MyViewController *myVC = [[MyViewController alloc] init];
                [self.navigationController pushViewController:myVC animated:YES];

            } else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }

            //在登录成功的地方将数据保存下来
            [[NSUserDefaults standardUserDefaults]setObject:self.NameField.text forKey:@"uname"];
            [[NSUserDefaults standardUserDefaults]setObject:self.PassField.text forKey:@"upwd"];
            
            NSLog(@"保存----%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"oauthToken"]);

        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"账号或密码不正确" message:base.msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
        }
     
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

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
            if ([[_faceSceneDataSource dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _faceSceneDataSource = [_faceSceneDataSource dictionaryValueForKey:@"data"];
            } else {
                _faceSceneDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        _getFaceSceneArray = [_faceSceneDataSource arrayValueForKey:@"open_scene"];
        _faceOpenStr = [_faceSceneDataSource stringValueForKey:@"is_open"];
        BOOL isScene = NO;
        for (NSString *typeStr in _getFaceSceneArray) {
            if ([typeStr isEqualToString:@"login_force_verify"]) {//说明配置的有考试相关的
                isScene = YES;
                isNameFaceLogin = YES;
            }
            if ([typeStr isEqualToString:@"login"]) {
                isFaceLogin = YES;
            }
        }
        [self sceneButtons:isFaceLogin];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


#pragma mark --- 网络请求 (人脸识别的图片上传的接口)
//上传用户头像
- (void)netWorkUserUpLoad {
    
    NSString *endUrlStr = YunKeTang_Attach_attach_upload;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    NSString *encryptStr1 = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [requestSerializer setValue:encryptStr1 forHTTPHeaderField:HeaderKey];
    [requestSerializer setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    manger.requestSerializer = requestSerializer;
    [manger POST:allUrlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *dataImg=UIImageJPEGRepresentation(faceImage, 1.0);
        [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_WithJson:[dict stringValueForKey:@"data"]];
            _faceID = [dict stringValueForKey:@"attach_id"];
//            [self NetWorkFaceLogin];
            [self NetWorkYouTuFaceLogin];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



//人脸识别登录的接口
- (void)NetWorkFaceLogin {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    [dic setObject:_faceID forKey:@"attach_id"];
    
    [manager BigWinCar_GetPublicWay:dic mod:@"Youtu" act:@"faceLogin" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSString *msg = responseObject[@"msg"];
        NSDictionary *dataDict = [responseObject dictionaryValueForKey:@"data"];
        if ([responseObject[@"code"] integerValue] == 1) {
            
            if ([_loginTypeStr integerValue] == 1) {//用户名登录
                if ([_NameField.text isEqualToString:[dataDict stringValueForKey:@"uname"]]) {//说明是同一个人
                    
                } else {//说明不是同一个人人
                    [TKProgressHUD showError:@"扫脸识别用户与账号并未绑定" toView:self.view];
                    return ;
                }
            } else if ([_loginTypeStr integerValue] == 2) {//直接扫脸登录
                
            }
            //保存数据
            base = [BaseClass modelObjectWithDictionary:responseObject];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
            
            //在登录成功的地方将数据保存下来
            [[NSUserDefaults standardUserDefaults]setObject:self.NameField.text forKey:@"uname"];
            [[NSUserDefaults standardUserDefaults]setObject:self.PassField.text forKey:@"upwd"];
            
            if ([self.typeStr isEqualToString:@"123"]) {//从设置页面过来
                MyViewController *myVC = [[MyViewController alloc] init];
                [self.navigationController pushViewController:myVC animated:YES];
            } else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        return ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//人脸识别登陆
- (void)NetWorkYouTuFaceLogin {
    
    NSString *endUrlStr = YunKeTang_YouTu_youtu_faceLogin;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_faceID forKey:@"attach_id"];
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 0) {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        } else if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_loginTypeStr integerValue] == 1) {//用户名登录
                if ([_NameField.text isEqualToString:[dict stringValueForKey:@"uname"]]) {//说明是同一个人
                } else {//说明不是同一个人人
                    [TKProgressHUD showError:@"扫脸识别用户与账号并未绑定" toView:self.view];
                    return ;
                }
            } else if ([_loginTypeStr integerValue] == 2) {//直接扫脸登录
                
            }
            //保存数据
            base = [BaseClass modelObjectWithDictionary:responseObject];
            [[NSUserDefaults standardUserDefaults]setObject:[dict stringValueForKey:@"oauth_token"] forKey:@"oauthToken"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict stringValueForKey:@"oauth_token_secret"] forKey:@"oauthTokenSecret"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict stringValueForKey:@"uid"] forKey:@"User_id"];
            [[NSUserDefaults standardUserDefaults]setObject:[dict stringValueForKey:@"userface"] forKey:@"userface"];
            
            //在登录成功的地方将数据保存下来
            [[NSUserDefaults standardUserDefaults]setObject:[dict stringValueForKey:@"uname"] forKey:@"uname"];
            [[NSUserDefaults standardUserDefaults]setObject:self.PassField.text forKey:@"upwd"];
            
            if ([self.typeStr isEqualToString:@"123"]) {//从设置页面过来
                MyViewController *myVC = [[MyViewController alloc] init];
                [self.navigationController pushViewController:myVC animated:YES];
            } else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



#pragma mark --- 检测后台是否开启人脸识别的功能
//检测后台是否开启人脸识别的功能
- (void)NetWorkGetFaceStatus {
    
    NSString *endUrlStr = YunKeTang_config_getFaceStatus;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    NSString *oauth_token = [_loginSuccessDict stringValueForKey:@"oauth_token"];
    NSString *oauth_token_secret = [_loginSuccessDict stringValueForKey:@"oauth_token_secret"];
    NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",oauth_token,oauth_token_secret];
    [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _faceStatusDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_faceStatusDataSource stringValueForKey:@"code"] integerValue] == 0) {
            [TKProgressHUD showError:[_faceSceneDataSource stringValueForKey:@"msg"] toView:self.view];
            return ;
        } else if ([[_faceStatusDataSource stringValueForKey:@"code"] integerValue] == 1) {
            if ([[_faceSceneDataSource dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _faceStatusDataSource = [_faceStatusDataSource dictionaryValueForKey:@"data"];
            } else {
                 _faceStatusDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        if ([[_faceStatusDataSource stringValueForKey:@"is_open"] integerValue] == 0) {//不存在
            _faceOpen = @"0";
            //一些按钮的位置设置
            _faceButton.hidden = YES;
            _WJButton.frame = CGRectMake(MainScreenWidth / 4, CGRectGetMaxY(_DLButton.frame) + 30, MainScreenWidth / 2, 20);
            [self isBoundFace];
        } else if ([[_faceStatusDataSource stringValueForKey:@"is_open"] integerValue] == 1) {//正常使用
            _faceOpen = @"1";
            [self faceLogin];
        } else if ([[_faceStatusDataSource stringValueForKey:@"is_open"] integerValue] == 2) {//需要上传更多的照片
            _faceOpen = @"2";
            [self faceLogin];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//检测是否已经绑定了人脸
- (void)NetWorkYouTuIsExist {
    
    NSString *endUrlStr = YunKeTang_YouTu_youtu_isExist;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",[_dataSource stringValueForKey:@"oauth_token"],[_dataSource stringValueForKey:@"oauth_token_secret"]];
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
                dict = [dict dictionaryValueForKey:@"data"];
            } else {
                dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            if ([[dict stringValueForKey:@"is_exist"] integerValue] == 0) {//不存在
//                _personTitle.text = @"创建人物信息";
                [self isBoundFace];
            } else if ([[dict stringValueForKey:@"is_exist"] integerValue] == 1) {//正常使用
//                _personTitle.text = @"已绑定";
                [self faceLogin];
            } else if ([[dict stringValueForKey:@"is_exist"] integerValue] == 2) {//需要上传更多的照片
//                _personTitle.text = @"完善人物信息";
                [self faceLogin];
            }
        } else {
            [TKProgressHUD showError:[_statusDict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}

//注册的配置接口
- (void)NetWorkPassportRegisterConf {
    
    NSString *endUrlStr = YunKeTang_passport_registerConf;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
           dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _registerConfStr = [dict stringValueForKey:@"account_type"];
        }
        NSLog(@"----%@",dict);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



- (void)isBoundFace {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有绑定人脸，是否需要现在去绑定？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self resignFace];
    }];
    [alertController addAction:sureAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //        [self NetWorkGetPaperInfo];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)resignFace {
    Good_PersonFaceRegisterViewController *vc = [[Good_PersonFaceRegisterViewController alloc] init];
    vc.typeStr = @"1";
    vc.tryStr = @"1";
    vc.tokenAndTokenSerectDict = _loginSuccessDict;
    [self.navigationController pushViewController:vc animated:YES];
}



//移除警告框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


- (void)type_regis {
    SJZCViewController *phoneVc = [[SJZCViewController alloc] init];
    if (_backButton.hidden == YES) {//退出账号的
        phoneVc.type = @"123";
    }
    phoneVc.loginType = _loginType;
    phoneVc.UID = _UID;
    phoneVc.appToken = _appToken;
    NSLog(@"%@",_appToken);
    [self.navigationController pushViewController:phoneVc animated:YES];
    
}

@end
