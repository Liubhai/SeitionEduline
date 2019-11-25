//
//  GroupTwoViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/19.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "GroupTwoViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "MJRefresh.h"

#import "GroupTableViewCell.h"
#import "GroupDetailViewController.h"

@interface GroupTwoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;


@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSArray *cateArray;

@end

@implementation GroupTwoViewController

-(instancetype)initWithArray:(NSArray *)dataArray{
    
    self = [super init];
    if (self) {
        _dataArray = dataArray;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark --- 添加表格

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 12) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
}

#pragma mark --- 刷新
- (void)headerRerefreshings
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

#pragma mark -- UITableViewDataSoucre


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.05;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GroupTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell dataSourceWithDict:dic];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GroupDetailViewController *groupDVc = [[GroupDetailViewController alloc] init];
    [self.navigationController pushViewController:groupDVc animated:YES];
    
    groupDVc.IDString = _dataArray[indexPath.row][@"id"];
    groupDVc.imageStr = _dataArray[indexPath.row][@"logo"];
    NSString *imageStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"logourl"]];
    groupDVc.imageStr = imageStr;
    groupDVc.cateArray = _cateArray;
    
}




@end
