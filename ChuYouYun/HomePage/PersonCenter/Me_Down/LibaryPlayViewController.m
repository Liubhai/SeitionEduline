//
//  LibaryPlayViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/7.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "LibaryPlayViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"



@interface LibaryPlayViewController ()<UIWebViewDelegate>

@property (strong ,nonatomic)UIWebView *webView;


@end

@implementation LibaryPlayViewController

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
    [self addWebView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"下载文库";
    [WZLabel setTextColor:BasidColor];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:lineButton];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)addWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth,MainScreenHeight - 64)];
    if (iPhone4SOriPhone4) {
        _webView.frame = CGRectMake(0, 64, MainScreenWidth,MainScreenHeight - 64);
    } else if (iPhone5o5Co5S) {
        _webView.frame = CGRectMake(0, 70, MainScreenWidth,MainScreenHeight - 64);
    } else if (iPhone6) {
        _webView.frame = CGRectMake(0, 64, MainScreenWidth,MainScreenHeight - 64);
    } else if (iPhone6Plus) {
        _webView.frame = CGRectMake(0, 64,MainScreenWidth,MainScreenHeight - 64);
    }
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSLog(@"----%@",_urlStr);
    NSURL *url = nil;
    url = [NSURL URLWithString:_urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [MBProgressHUD showMessag:@"加载中...." toView:self.view];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:@"加载成功" toView:self.view];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:@"加载失败" toView:self.view];
}


@end
