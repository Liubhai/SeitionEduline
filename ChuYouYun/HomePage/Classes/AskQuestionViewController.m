//
//  AskQuestionViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/3/20.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "AskQuestionViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "BigWindCar.h"
#import "DLViewController.h"


@interface AskQuestionViewController ()

@property (strong ,nonatomic)UITextView    *textView;
@property (strong ,nonatomic)UILabel       *remainLabel;
@property (strong ,nonatomic)UIButton      *releaseButton;

@end

@implementation AskQuestionViewController


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
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTextView];
    [self addButtonView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchang:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"提问";
    [WZLabel setTextColor:[UIColor clearColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}


- (void)addTextView {
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 64, MainScreenWidth - 20 * WideEachUnit, 100 * WideEachUnit)];
    _textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_textView];
    
    _remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, 200 * WideEachUnit, 20 * WideEachUnit)];
    _remainLabel.text = @"请输入您遇到的问题";
    _remainLabel.font = Font(13);
    _remainLabel.textColor = [UIColor colorWithHexString:@"#9B9999"];
    [_textView addSubview:_remainLabel];
    
}

- (void)addButtonView {
    _releaseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100 * WideEachUnit,CGRectGetMaxY(_textView.frame) + 10 * WideEachUnit , 80 * WideEachUnit, 25 * WideEachUnit)];
    [_releaseButton setTitle:@"发布" forState:UIControlStateNormal];
    _releaseButton.backgroundColor = BasidColor;
    _releaseButton.layer.cornerRadius = 5;
    [self.view addSubview:_releaseButton];
}

#pragma mark --- 通知
- (void)exchang:(NSNotification *)not {
    if (_textView.text.length > 0) {
        _remainLabel.hidden = YES;
    } else {
        _remainLabel.hidden = NO;
    }
}

#pragma mark --- 事件点击
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----NetWorking
//课程添加评论
//- (void)netWorkVideoAddQuestion {
//
//    NSString *endUrlStr = YunKeTang_Video_video_addQuestion;
//    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
//
//    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [mutabDict setValue:_ID forKey:@"kzid"];
//    [mutabDict setValue:_textView.text forKey:@"content"];
//    //评论星级
//    [mutabDict setValue:_currentID forKey:@"pid"];//提问的id
//    [mutabDict setValue:@"1" forKey:@"kztype"]; // 2为专辑 1 为课程
//
//
//    NSString *oath_token_Str = nil;
//    if (UserOathToken) {
//        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
//        //        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
//    } else {
//        [TKProgressHUD showError:@"请先去登陆" toView:self.view];
//        return;
//    }
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
//    [request setHTTPMethod:NetWay];
//    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
//    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
//    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
//
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
//        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
//            [_allWindowView removeFromSuperview];
//            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
//            [self netWorkVideoGetRender];
//        } else {
//            [_allWindowView removeFromSuperview];
//            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
//            [self netWorkVideoGetRender];
//        }
//
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//    }];
//    [op start];
//}






@end
