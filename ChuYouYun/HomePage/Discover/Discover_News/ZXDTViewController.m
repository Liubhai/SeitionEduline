//
//  ZXDTViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ZXDTViewController.h"
#import "AppDelegate.h"
#import "Passport.h"
#import "ZhiyiHTTPRequest.h"
#import "UIColor+HTMLColors.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"


#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"

//图文混排
#import "TYAttributedLabel.h"
#import "RegexKitLite.h"



@interface ZXDTViewController ()<UIWebViewDelegate,UMSocialUIDelegate,TYAttributedLabelDelegate>{
    UIImageView  *shareImageView;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *shareImageView;
@property (strong ,nonatomic)NSDictionary *SYGDic;
@property (nonatomic,strong) TYAttributedLabel *textLabel;
@property (strong ,nonatomic)NSString          *shareVideoUrl;


@end

@implementation ZXDTViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"资讯详情";
    _rightButton.hidden = NO;
    [_rightButton setImage:Image(@"avcMore") forState:0];
    [self interFace];
    [self getNewsData];
}

- (void)rightButtonClick:(id)sender {
    [self NewsShare];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [shareImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"资讯详情";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加分享按钮
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 20, 50, 30)];
    [shareButton setTitle:@"..." forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    [SYGView addSubview:shareButton];
    [shareButton addTarget:self action:@selector(NewsShare) forControlEvents:UIControlEventTouchUpInside];
    
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(15, 40, 40, 40);
        titleLab.frame = CGRectMake(50, 35, MainScreenWidth - 100, 30);
        shareButton.frame = CGRectMake(MainScreenWidth - 60, 45, 50, 30);
        lineLab.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
}

#pragma mark --- 添加分享的图片
- (void)addShareImageView {
    _shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_shareImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
}

#pragma mark --- 添加网络视图
- (void)addWebView {
    NSString *allStr = [NSString stringWithFormat:@"%@",_SYGDic[@"text"]];
    NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *textStr = [allStr stringByReplacingOccurrencesOfString:@"<img src=\"/data/upload" withString:replaceStr];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    if (iPhoneX) {
        webView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88);
    }
    [self.view addSubview:webView];
    
    
    NSString *content = textStr;
    if (content.length>2) {
        NSString *str2 = [content substringWithRange:NSMakeRange(0, 3)];
        if ([str2 isEqualToString:@"<p>"]) {
            content = [content substringFromIndex:3];
        }
    }
    
//    9B9B9B
    NSString * str1 = [NSString stringWithFormat:@"<div style=\"margin-left:0px; margin-bottom:5px;font-size:%fpx;color:#010101;text-align:left;\">%@</div>",24.0,[_SYGDic objectForKey:@"title"]];
    NSString * str2 = [NSString stringWithFormat:@"<div style=\"display:inline-block;padding:10 0;font-size:%fpx;color:#888;text-align:left;\">%@</div>",15.0,[NSString stringWithFormat:@"发布时间：%@",_timeStr]];
    NSString * str3 = [NSString stringWithFormat:@"<div style=\"display:inline-block;padding:10 3;float:right;font-size:%fpx;color:#9B9B9B;text-align:left;\">%@</div>",15.0,[NSString stringWithFormat:@"阅读：%@",_readStr]];
    NSString * str4 = [NSString stringWithFormat:@"<div style=\"display:block;margin-left:-10px;padding:0 10; margin-top:5px;font-size:%fpx;color:#5A5A5A;text-align:left;background-color:#eeeeee;width:365;\">%@</div>",16.0,[NSString stringWithFormat:@"摘要：%@",_ZYStr]];
    if (iPhone6) {
        str4 = [NSString stringWithFormat:@"<div style=\"display:block;margin-left:-10px;padding:0 10; margin-top:5px;font-size:%fpx;color:#5A5A5A;text-align:left;background-color:#eeeeee;width:365;\">%@</div>",16.0,[NSString stringWithFormat:@"摘要：%@",_ZYStr]];
    } else if (iPhone6Plus) {
       str4 = [NSString stringWithFormat:@"<div style=\"display:block;margin-left:-10px;padding:0 10; margin-top:5px;font-size:%fpx;color:#5A5A5A;text-align:left;background-color:#eeeeee;width:404;\">%@</div>",16.0,[NSString stringWithFormat:@"摘要：%@",_ZYStr]];
    }
    
    NSString *divStr = [NSString stringWithFormat:@"<div style=\"margin:%dpx;border:10;padding:0;display:block;\"></div>",SpaceBaside];
    
    NSString *styleStr = [NSString stringWithFormat:@"<style> .mobile_upload {width:%fpx;height:auto;} </style><style> .emot {width:%fpx;height:%fpx;overflow:hidden;} img{max-width:%fpx;margin:10fpx  0;display:inline-block;} </style><div style=\"word-wrap:break-word;border-top:0.5px solid #999;padding-top:20px; width:%fpx;\"><font style=\"font-size:%fpx;color:#727272;\">",MainScreenWidth - SpaceBaside * 2 + 20,16.0,16.0,MainScreenWidth - 4 * SpaceBaside + 20,MainScreenWidth - SpaceBaside * 2,16.0];
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@</font></div>",str1,str2,str3,divStr,styleStr,content];
    [webView loadHTMLString:str baseURL:nil];
    
}

#pragma mark --- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 分享
- (void)NewsShare {
    _shareVideoUrl = [NSString stringWithFormat:@"%@/news/%@.html",EncryptHeaderUrl,_ID];
    
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:_shareVideoUrl];
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:_shareVideoUrl];
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppId secret:SinaAppSecret RedirectURL:_shareVideoUrl];
    //    UMShareToSina
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:_titleStr
                                     shareImage:_shareImageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
}


#pragma mark --- 网络请求
//获取课程分享的链接
- (void)netWorkVideoGetShareUrl {
    
    NSString *endUrlStr = YunKeTang_Video_video_getShareUrl;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"10" forKey:@"count"];
//    [mutabDict setObject:@"3" forKey:@"type"];
    [mutabDict setObject:_ID forKey:@"vid"];
    
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _shareVideoUrl = [dict stringValueForKey:@"share_url"];
            [self NewsShare];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)getNewsData {
    if (SWNOTEmptyStr(_ID)) {
        NSString *endUrlStr = @"news.getInfo";
        NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
        
        NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [mutabDict setObject:_ID forKey:@"id"];
        
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
                if (SWNOTEmptyDictionary([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject])) {
                    _SYGDic = [NSDictionary dictionaryWithDictionary:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
                    _titleStr = _SYGDic[@"title"];
                    _timeStr = _SYGDic[@"dateline"];
                    _readStr = _SYGDic[@"readcount"];
                    _ZYStr = _SYGDic[@"desc"];
                    _GDStr = _SYGDic[@"text"];
                    _imageUrl = _SYGDic[@"image"];
                    [self addShareImageView];
                    [self addWebView];
                }
            } else {
                [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        }];
        [op start];
    }
}

@end
