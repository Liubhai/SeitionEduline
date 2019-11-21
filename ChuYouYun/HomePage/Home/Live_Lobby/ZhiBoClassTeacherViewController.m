//
//  ZhiBoClassTeacherViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/18.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoClassTeacherViewController.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "BigWindCar.h"
#import "MJRefresh.h"


@interface ZhiBoClassTeacherViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSInteger Number;
}

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSMutableArray *dataArray;

@end

@implementation ZhiBoClassTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Number = 1;
    [self interFace];
    [self addTabView];
    [self addClearButton];
    [self netWorkLiveGetScreenTeacher];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor clearColor];
    _dataArray = [NSMutableArray array];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelfView) name:@"ZhiBoClassTeacherRemove" object:nil];
}

- (void)addTabView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 109 - 200) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 36;
    _tableView.tag = 1;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    
}

- (void)addClearButton {
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 200 - 109, MainScreenWidth, 200)];
    clearButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [clearButton addTarget:self action:@selector(removeSelfView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
}


#pragma mark --- 刷新

- (void)headerRerefreshings
{
    Number = 1;
    [self netWorkLiveGetScreenTeacher];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView headerEndRefreshing];
        [_tableView reloadData];
    });
}

- (void)footerRefreshing
{
    Number = Number + 1;
    [self netWorkLiveGetScreenTeacherMoreData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    });
}



#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"cellClassTeacher";
    //自定义cell类
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"name"];
    cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"#f0f0f2"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#656565"];
    cell.textLabel.font = Font(14);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //传值处理
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationZhiBoTeacherID" object:dict];
    [self removeSelfView];
}

#pragma mark --- 通知
-(void)removeSelfView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationZhiBoTeacherButton" object:nil];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark --- 网络请求
- (void)netWorkLiveGetScreenTeacher {
    
    NSString *endUrlStr = YunKeTang_Live_live_getScreenTeacher;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"10" forKey:@"count"];
    [mutabDict setObject:@(Number) forKey:@"page"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        [_dataArray removeAllObjects];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        if (_dataArray.count<10) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)netWorkLiveGetScreenTeacherMoreData {
    
    NSString *endUrlStr = YunKeTang_Live_live_getScreenTeacher;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"10" forKey:@"count"];
    [mutabDict setObject:@(Number) forKey:@"page"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        NSMutableArray *pass = [NSMutableArray new];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [pass addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [_dataArray addObjectsFromArray:pass];
        if (pass.count<10) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        Number--;
    }];
    [op start];
}


@end
