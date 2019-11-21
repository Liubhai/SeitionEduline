//
//  MessageSendViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/31.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "MessageSendViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "DLViewController.h"
#import "SYG.h"


@interface MessageSendViewController ()
{
    CGRect WDrect;
}

@property (strong ,nonatomic)UIView *SYGView;

@property (strong ,nonatomic)UIView *downView;

@property (strong ,nonatomic)UITextField *PLTextField;

@property (strong ,nonatomic)UITextView *textView;

@property (strong ,nonatomic)UILabel *TSLabel;

@end

@implementation MessageSendViewController


-(void)viewWillAppear:(BOOL)animated
{
    WDrect = [UIScreen mainScreen].applicationFrame;
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //创建通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
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
    [self addNav];
    [self addDownView];
}

- (void)addNav {
    
    self.view.backgroundColor = [UIColor whiteColor];
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    _SYGView = SYGView;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"发私信";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,286)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
//    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
//    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    //添加发送的按钮
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:sendButton];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addDownView {
    
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0,64 , MainScreenWidth, 210)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加接收人
    UILabel *JSLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, MainScreenWidth - 40, 20)];
    JSLabel.text = [NSString stringWithFormat:@"收信人：%@",_name];
    [_downView addSubview:JSLabel];
    
    //添加分割线
    UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth, 0.5)];
    HLabel.backgroundColor = PartitionColor;
    [_downView addSubview:HLabel];

    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 65, MainScreenWidth - 30, 150)];
    _textView.layer.cornerRadius = 3;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = PartitionColor.CGColor;
    [_downView addSubview:_textView];
    
    //添加提示文本
    _TSLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65,MainScreenWidth - 25, 30)];
    _TSLabel.text = @"请输入要私信的内容";
    _TSLabel.textColor = [UIColor lightGrayColor];
    _TSLabel.font = [UIFont systemFontOfSize:15];
    [_downView addSubview:_TSLabel];
    
}


- (void)textViewChange:(NSNotification *)not {
    if (_textView.text.length > 0) {
        _TSLabel.hidden = YES;
    } else {
        _TSLabel.hidden = NO;
    }
}

- (void)sendButton {
//    [self sendMessage];
    [self netWorkMessageSend];
}

-(void)sendMessage
{
    
    //应该判断是否登录
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
        
    }
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    NSString *speak =  _textView.text;
    [dic setObject:speak forKey:@"content"];
    [dic setObject:_TID forKey:@"to"];
    [manager sendToChat:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"您刚才发送的信息内容为:%@",speak] message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"信息发送成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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

//获取课程分享的链接
- (void)netWorkMessageSend {
    
    NSString *endUrlStr = YunKeTang_Message_message_send;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *speak =  _textView.text;
    [mutabDict setObject:speak forKey:@"content"];
    [mutabDict setObject:_TID forKey:@"to"];
    if ([_TID integerValue] == [UserID integerValue]) {
        [TKProgressHUD showError:@"不能给自己发私信" toView:self.view];
        return;
    }

    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backPressed];
            });
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
