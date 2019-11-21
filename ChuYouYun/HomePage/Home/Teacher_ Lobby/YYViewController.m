//
//  YYViewController.m
//  dafengche
//
//  Created by IOS on 16/12/23.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "YYViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "DLViewController.h"
#import "SYG.h"
#import "MyHttpRequest.h"
#import "TKProgressHUD.h"
#import "TKProgressHUD+Add.h"

@interface YYViewController ()<UITextViewDelegate,UIWebViewDelegate>{
    
    CGRect WDrect;
    NSString *_type;
    NSString *_word;
    
    NSString *_aliPayUrl;
    NSString *_WXPayUrl;
    
    NSString *_price;
    NSInteger typeNum;
}

@property (strong ,nonatomic)UIView *SYGView;
@property (strong ,nonatomic)UITextField *PLTextField;
@property (strong ,nonatomic)UITextView *textView;
@property (strong ,nonatomic)UILabel *TSLabel;
@property (strong, nonatomic)UIWebView *webView;

@end

@implementation YYViewController

-(void)viewWillAppear:(BOOL)animated
{
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

-(void)YYrequestData
{
    
    _word = _textView.text;
    QKHTTPManager * manager = [QKHTTPManager manager];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *key = [ user objectForKey:@"oauthToken"];
    NSString *passWord = [ user objectForKey:@"oauthTokenSecret"];
    if (passWord == nil) {
        [TKProgressHUD showError:@"要先登陆才能预约" toView:self.view];
        return;
    }
    
    NSDictionary *parameter=@{@"oauth_token": [NSString stringWithFormat:@"%@",key],@"oauth_token_secret": [NSString stringWithFormat:@"%@",passWord] ,@"teacher_id": _TID,@"type":_type,@"word":_word};
    
    [manager getpublicPort:parameter mod:@"Teacher" act:@"bespeak" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        NSLog(@"----%@",msg);
        
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 1) {
                [TKProgressHUD showSuccess:msg toView:self.view];
            } else {//不免费
                _aliPayUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"alipay"][@"ios"]];
                _WXPayUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"wxpay"][@"ios"]];
                [self whichPay];
            }
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        

//        NSLog(@"%@",_WXPayUrl);
//        NSString *Msg = responseObject[@"msg"];
//
//        if ([responseObject[@"code"] integerValue] == 1) {
//            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {//不是免费
//                if (_aliPayUrl.length) {
//                    [self whichPay];
//                }
//            } else {//免费
//                [TKProgressHUD showSuccess:@"解锁成功" toView:self.view];
//            }
//        } else {
//            [TKProgressHUD showError:Msg toView:self.view];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"获取数据失败" toView:self.view];
    }];
}

-(void)addpayView{

//    _payV = [[GLPayV alloc]initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight) ALiPayUrl:_aliPayUrl WXPayUrl:_WXPayUrl withPrice:_price];
//    [self.view addSubview:_payV];
    
}


- (void)addNav {
    
    self.view.backgroundColor = [UIColor whiteColor];
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    _SYGView = SYGView;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = [NSString stringWithFormat:@"预约：%@老师",_name];
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
    [sendButton setTitle:@"预约" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:sendButton];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}

- (void)change:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            //线上试听
        {
            _type = @"online";
            _price = _lineonPrice;

        }
            break;
        case 1:
            //线下试听
            
        {
            _type = @"offline";
            _price = _lineoffprice;

        }
            
            break;
        default:
            break;
    }
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addDownView {
    

    NSArray *titleArray = @[@"在线授课",@"线下授课"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:titleArray];
    segment.frame = CGRectMake(MainScreenWidth / 4 , 80, MainScreenWidth / 2 , 30);
    segment.selectedSegmentIndex = 0;
    _type = @"online";
    _price = _lineonPrice;
    [segment setTintColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1]];
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, segment.current_y_h +20, MainScreenWidth - 30, 40)];
    lab1.text = [NSString stringWithFormat:@"在线学习：%@ 育币",_lineonPrice];
    if (_lineonPrice == nil) {
        lab1.text = @"线上学习：0.00 育币";
    }
    [self.view addSubview:lab1];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = Font(18);
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, lab1.current_y_h , MainScreenWidth - 30, 40)];
    lab2.text = [NSString stringWithFormat:@"线下学习：%@ 育币",_lineoffprice];
    if (_lineoffprice == nil) {
        lab2.text = @"线下学习：0.00 育币";
    }
    [self.view addSubview:lab2];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = Font(18);
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, lab2.current_y_h + 10, MainScreenWidth - 30, 150)];
    _textView.layer.cornerRadius = 3;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = [UIColor brownColor].CGColor;
    [self.view addSubview:_textView];
    
    //添加提示文本
    _TSLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, lab2.current_y_h + 10,MainScreenWidth - 25, 30)];
    _TSLabel.text = @"我想对老师说：";
    _TSLabel.textColor = [UIColor lightGrayColor];
    _TSLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_TSLabel];
    
}


- (void)textViewChange:(NSNotification *)not {
    if (_textView.text.length > 0) {
        _TSLabel.hidden = YES;
    } else {
        _TSLabel.hidden = NO;
    }
}

- (void)sendButton {
//    [self whichPay];
    [self YYrequestData];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark --- 添加视图

//是否 真要删除小组
- (void)whichPay {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择支付方式" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *aliAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        typeNum = 1;
        [self addWebView];
    }];
    [alertController addAction:aliAction];
    
    UIAlertAction *wxAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        typeNum = 2;
        [self addWebView];
    }];
    [alertController addAction:wxAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark --- 添加跳转识图
- (void)addWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    if (typeNum == 1) {
        if (_aliPayUrl == nil) {
            [TKProgressHUD showError:@"支付失败" toView:self.view];
        } else {
            url = [NSURL URLWithString:_aliPayUrl];
        }

    } else if (typeNum == 2) {
        if (_WXPayUrl == nil) {
            [TKProgressHUD showError:@"支付失败" toView:self.view];
        } else {
            url = [NSURL URLWithString:_WXPayUrl];
        }
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];

}


@end
