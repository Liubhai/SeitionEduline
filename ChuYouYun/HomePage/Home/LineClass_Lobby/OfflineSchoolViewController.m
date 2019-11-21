//
//  OfflineSchoolViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "OfflineSchoolViewController.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

@interface OfflineSchoolViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger Number;
}


@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)UIButton       *clearButton;

@end

@implementation OfflineSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
//    [self addTabView];
//    [self addClearButton];
//    [self netWorkGetScreen];
    [self netWorkLineVideoScreen];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor clearColor];
    _dataArray = [NSMutableArray array];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelfView) name:@"OfflineClassTeacherRemove" object:nil];
}

- (void)addTabView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45*HigtEachUnit) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 36 * WideEachUnit;
    _tableView.tag = 1;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];

    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView withHight:36];
    }
}

- (void)addClearButton {
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0,  36 * WideEachUnit * _dataArray.count , MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit - 36 * WideEachUnit * _dataArray.count)];
    clearButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [clearButton addTarget:self action:@selector(removeSelfView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    _clearButton = clearButton;
}


#pragma mark --- 刷新

- (void)headerRerefreshings
{
//    [self netWorkGetScreen];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    Number ++;
//    [self netWorkGetScreen:Number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
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
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"title"];
    cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"#f0f0f2"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#656565"];
    cell.textLabel.font = Font(14);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //传值处理
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationOfflineTeacherID" object:dict];
    [self removeSelfView];
}

#pragma mark --- 通知
-(void)removeSelfView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationOfflineTeacherButton" object:nil];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark --- 网络请求
//获取课程分类里面的数据

//线下课列表数据
- (void)netWorkLineVideoScreen {
    
    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_screen;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _dataArray = (NSMutableArray *)[dict arrayValueForKey:@"school"];
            [self addTabView];
            [self addClearButton];
            [_tableView reloadData];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
