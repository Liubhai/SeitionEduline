//
//  MyCommentListVC.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/11/21.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "MyCommentListVC.h"
#import "SYG.h"
#import "YunKeTang_Api.h"
#import "TKProgressHUD+Add.h"
#import "Passport.h"
#import "AppDelegate.h"
#import "EvaluateCell.h"
#import "Good_ClassMainViewController.h"
#import "ZhiBoMainViewController.h"
#import "ClassDetailViewController.h"
#import "TeacherMainViewController.h"
#import "OfflineDetailViewController.h"

@interface MyCommentListVC ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger page;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MyCommentListVC

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    _dataSource = [NSMutableArray new];
    [self makeTableView];
    [_tableView headerBeginRefreshing];
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 44)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView addHeaderWithTarget:self action:@selector(getFirstPageData)];
    [_tableView addFooterWithTarget:self action:@selector(getMorePageData)];
    [[[Passport alloc] init] adapterOfIOS11With:_tableView];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"myquestionlistcell";
    EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[EvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    [cell setEvaluateListCellInfo:_dataSource[indexPath.row] typeString:_commentTypeString];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *video_type = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"video_type"]];
    NSString *source_id = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"oid"]];
    if ([video_type isEqualToString:@"1"]) {
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = source_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([video_type isEqualToString:@"2"]) {
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:source_id andImage:nil andTitle:nil andNum:nil andprice:nil];
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
    } else if ([video_type isEqualToString:@"3"]) {
        OfflineDetailViewController *vc = [[OfflineDetailViewController alloc] init];
        vc.ID = source_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([video_type isEqualToString:@"4"]) {
        TeacherMainViewController *teacherMainVc = [[TeacherMainViewController alloc] initWithNumID:source_id];
        [self.navigationController pushViewController:teacherMainVc animated:YES];
    } else if ([video_type isEqualToString:@"5"]) {
        ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
        vc.combo_id = source_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([video_type isEqualToString:@"6"]) {
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = source_id;
        vc.isClassNew = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getFirstPageData {
    page = 1;
    
    NSString *endUrlStr = user_getCommentList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@(page) forKey:@"page"];
    [mutabDict setObject:@"20" forKey:@"count"];
    [mutabDict setObject:_commentTypeString forKey:@"type"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if (_tableView.isHeaderRefreshing) {
            [_tableView headerEndRefreshing];
        }
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
        }
        if (_dataSource.count < 10) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (_tableView.isHeaderRefreshing) {
            [_tableView headerEndRefreshing];
        }
    }];
    [op start];
}

- (void)getMorePageData {
    
    page = page + 1;
    
    NSString *endUrlStr = user_getCommentList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@(page) forKey:@"page"];
    [mutabDict setObject:@"20" forKey:@"count"];
    [mutabDict setObject:_commentTypeString forKey:@"type"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (_tableView.isFooterRefreshing) {
            [_tableView footerEndRefreshing];
        }
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        NSMutableArray *pass = [NSMutableArray new];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [pass addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
            [_dataSource addObjectsFromArray:pass];
        }
        if (pass.count < 10) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (_tableView.isFooterRefreshing) {
            [_tableView footerEndRefreshing];
        }
        page--;
    }];
    [op start];
}

@end
