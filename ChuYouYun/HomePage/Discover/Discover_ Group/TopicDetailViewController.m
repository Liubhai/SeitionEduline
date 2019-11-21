//
//  TopicDetailViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/9/20.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "UIButton+WebCache.h"
#import "PhotosView.h"
#import "Passport.h"
#import "ZhiyiHTTPRequest.h"
#import "MyHttpRequest.h"


@interface TopicDetailViewController ()<UIWebViewDelegate>

{
    BOOL isSecet;
}

@property (strong ,nonatomic)UIView *infoView;

@property (strong ,nonatomic)UILabel *contentLabel;

@property (strong ,nonatomic)PhotosView *photoView;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)UIView *downView;

@property (strong ,nonatomic)UITextField *reviewField;

@property (strong ,nonatomic)NSArray *SYGArray;

@property (strong ,nonatomic)UIView *allView;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)UIWebView *webView;//网络试图

@end

@implementation TopicDetailViewController


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
    isSecet = NO;
    _SYGArray = @[@"发布"];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"话题详情";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加分类的按钮
    UIButton *SortButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 30, 60, 30)];
    [SortButton setTitle:@"++" forState:UIControlStateNormal];
//    [SortButton addTarget:self action:@selector(SortButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SortButton];
    SortButton.hidden = YES;
    
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:lineButton];
    
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 网络试图
- (void)addWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    //http://www.igenwoxue.com/index.php?app=group&mod=Index&act=detail&id=75
    NSString *oneStr = @"app=group&mod=Index&act=detail&id=";
    NSString *twoStr = [NSString stringWithFormat:@"%@",_topicID];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",basidUrl,oneStr,twoStr];
    NSLog(@"----%@",urlStr);
    urlStr = @"http://edu.51daxuetong.cn/logs/";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_webView];
//    [self.webView setMediaPlaybackRequiresUserAction:NO];
    _webView.mediaPlaybackRequiresUserAction = NO;
//    _webview.allowsInlineMediaPlayback = YES;
}

//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    return YES;
//}













@end
