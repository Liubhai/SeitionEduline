//
//  ClassServiceViewController.m
//  YunKeTang
//
//  Created by IOS on 2018/12/17.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassServiceViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "YunKeTang_Api_Tool.h"

@interface Good_ClassServiceViewController ()<UIWebViewDelegate>

@property (strong ,nonatomic)NSDictionary  *dataSoruce;
@property (strong ,nonatomic)NSString      *ID;
@property (strong ,nonatomic)NSString      *urlStr;
@property (strong ,nonatomic)UIWebView     *webView;

@end

@implementation Good_ClassServiceViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addWebView];
    [self netWorkGetThirdServiceUrl];
}

- (void)interFace {
    
}

- (void)addWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 50 * WideEachUnit - 210 * WideEachUnit - 150 * WideEachUnit)];
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate = self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    url = [NSURL URLWithString:_urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}


//请求课程下的评论
- (void)netWorkGetThirdServiceUrl {

    NSString *endUrlStr = YunKeTang_Basic_Basic_getThirdServiceUrl;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];

    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"5" forKey:@"count"];

    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (oath_token_Str != nil) {
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _dataSoruce = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        _urlStr = [_dataSoruce stringValueForKey:@"url"];
        [self addWebView];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





@end
