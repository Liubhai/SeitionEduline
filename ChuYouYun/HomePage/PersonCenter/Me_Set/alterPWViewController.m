//
//  alterPWViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "alterPWViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "UIColor+HTMLColors.h"
#import "SYG.h"

@interface alterPWViewController ()<UITextFieldDelegate>
{
    BOOL isSecure;
}

@end

@implementation alterPWViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameAndPassword:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    // Do any additional setup after loading the view from its nib.
    [_originalPW becomeFirstResponder];
    isSecure = NO;
    self.originalPW.secureTextEntry = YES;
    self.nowPW.secureTextEntry = YES;
    self.nowPW.delegate = self;
    self.verifyPW.secureTextEntry = YES;
    [self.SecureBtn.layer setMasksToBounds:YES];
    [self.SecureBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.SecureBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 188.0/255.0, 188.0/255.0, 190.0/255.0, 1 });
    [self.SecureBtn.layer setBorderColor:colorref];//边框颜色
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
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"修改密码";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineLab.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

//用户名和密码限制长度为20
- (void)nameAndPassword:(NSNotification *)Not {
    
    if (_originalPW.text.length >= 20) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户名长度不得超过20位数" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
        
        self.originalPW.text = [self.originalPW.text substringToIndex:20];
        
    }else if (_nowPW.text.length >= 20) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"密码长度不得超过20位数" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
        
        self.nowPW.text = [self.nowPW.text substringToIndex:20];
    }
    
}

- (IBAction)isSecure:(id)sender
{
    isSecure = !isSecure;
    NSLog(@"isSecure %d",isSecure);
    if (isSecure == YES) {
        self.SecureBtn.backgroundColor = BasidColor;
        self.originalPW.secureTextEntry = NO;
        self.nowPW.secureTextEntry = NO;
        self.verifyPW.secureTextEntry = NO;
    }else if (isSecure == NO){
        self.SecureBtn.backgroundColor = [UIColor whiteColor];
        self.originalPW.secureTextEntry = YES;
        self.nowPW.secureTextEntry = YES;
        self.verifyPW.secureTextEntry = YES;
    }
}
- (IBAction)enterClick:(id)sender
{
    [self netWorkPassportSavePwd];
}


#pragma mark --- 键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"123");
    //点搜索按钮
    if (_nowPW.text.length > 0) {
//        //将数据存在本地
//        [self readIn];
//        SearchGetViewController *searchGetVc = [[SearchGetViewController alloc] init];
//        searchGetVc.searchStr = _searchText.text;
//        searchGetVc.typeStr = _typeStr;
//        [self.navigationController pushViewController:searchGetVc animated:YES];
    }
    
    [_nowPW becomeFirstResponder];
    if ([textField.text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


//移除警告框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


#pragma mark --- 网络请求
//用户重置密码
- (void)netWorkPassportSavePwd {
    
    NSString *endUrlStr = YunKeTang_passport_doModifyPassword;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:self.originalPW.text forKey:@"oldpassword"];
    [mutabDict setObject:self.nowPW.text forKey:@"password"];
    [mutabDict setObject:self.verifyPW.text forKey:@"repassword"];
    
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
                    [self backPressed];
                });
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
