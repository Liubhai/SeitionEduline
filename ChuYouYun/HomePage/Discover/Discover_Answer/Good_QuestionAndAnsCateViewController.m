//
//  Good_QuestionAndAnsCateViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/28.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_QuestionAndAnsCateViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "Good_ WeekHotViewController.h"
#import "Good_HonorListViewController.h"

@interface Good_QuestionAndAnsCateViewController ()

@property (strong ,nonatomic)UIScrollView     *allScrollView;

@property (strong ,nonatomic)NSMutableArray   *dataArray;
@property (strong ,nonatomic)NSMutableArray   *titleArray;
@property (strong ,nonatomic)NSDictionary     *cateDict;

@end

@implementation Good_QuestionAndAnsCateViewController

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
    [self addScrollView];
    [self netWorkWenGetCategory];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _titleArray = [NSMutableArray array];
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
    WZLabel.text = @"分类选择";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    if (iPhoneX) {
        SYGView.frame = CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight);
        backButton.frame = CGRectMake(5, 35, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
}

- (void)addScrollView {
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    if (iPhoneX) {
        _allScrollView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88);
    }
    _allScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_allScrollView];
}

- (void)addButtonView {
    
    NSArray *moreArray = @[@"一周热门",@"光荣榜"];
    [_titleArray addObjectsFromArray:moreArray];
    CGFloat buttonW =  MainScreenWidth / 2 - 33;
    CGFloat buttonH = 40;
    CGFloat space = 22;
    
    for (int i = 0 ; i < _titleArray.count ; i ++) {

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(space + (i % 2) * ((MainScreenWidth - 3 * space) /2 + space), (i / 2) * 40 + (i / 2) * 35 + 40,buttonW, buttonH)];
        [button setTitle:[_titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.layer setBorderColor:BasidColor.CGColor];
        [button.layer setBorderWidth:1];
        [button.layer setMasksToBounds:YES];
        button.layer.cornerRadius = 5;
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_allScrollView addSubview:button];
    }
}

#pragma mark --- 事件点击
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonClick:(UIButton *)button {
    NSInteger count = _titleArray.count;
    NSInteger buttonTag = button.tag;
    if (buttonTag == count - 1) {//光荣榜
        Good_HonorListViewController *vc = [[Good_HonorListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (buttonTag == count - 2) {//一周热门
        Good__WeekHotViewController *vc = [[Good__WeekHotViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {//其他分类
        _cateDict = [_dataArray objectAtIndex:buttonTag];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationQuestionCateDict" object:_cateDict];
        [self backPressed];
    }
}


#pragma mark --- 网络请求

- (void)netWorkWenGetCategory {
    
    NSString *endUrlStr = YunKeTang_WenDa_wenda_getCategory;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
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
        _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        for (int i = 0 ; i < _dataArray.count ; i ++) {
            NSString *title = [[_dataArray objectAtIndex:i] stringValueForKey:@"title"];
            [_titleArray addObject:title];
        }
        [self addButtonView];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}







@end
