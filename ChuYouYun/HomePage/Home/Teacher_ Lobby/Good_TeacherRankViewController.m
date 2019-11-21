//
//  Good_TeacherRankViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/17.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_TeacherRankViewController.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

@interface Good_TeacherRankViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSInteger Number;
}

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSArray        *typeArray;

@end

@implementation Good_TeacherRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTabView];
    [self addClearButton];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor clearColor];
    _dataArray = [NSMutableArray array];
    _dataArray = @[@"智能排序",@"最新",@"热门老师"];
    
    _typeArray = @[@"default",@"new",@"hot"];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelfView) name:@"TeacherRankRemove" object:nil];
}

- (void)addTabView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _dataArray.count * 36) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth, _dataArray.count * 36);
    }
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 36;
    _tableView.tag = 1;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    //    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

- (void)addClearButton {
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _dataArray.count * 36, MainScreenWidth, MainScreenHeight  - _dataArray.count * 36)];
    if (iPhoneX) {
        clearButton.frame = CGRectMake(0, _dataArray.count * 36 ,MainScreenWidth,MainScreenHeight  - _dataArray.count * 36);
    }
    clearButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [clearButton addTarget:self action:@selector(removeSelfView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
}


#pragma mark --- 刷新

- (void)headerRerefreshings
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    Number ++;
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
//    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"name"];
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"#f0f0f2"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#656565"];
    cell.textLabel.font = Font(14);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //传值处理
    NSString *title = [_dataArray objectAtIndex:indexPath.row];
    NSString *order = [_typeArray objectAtIndex:indexPath.row];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:title forKey:@"title"];
    [dict setObject:order forKey:@"order"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationTeacherRankID" object:dict];
    [self removeSelfView];
}

#pragma mark --- 通知
-(void)removeSelfView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationTeacherRankButton" object:nil];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark --- 网络请求


@end
