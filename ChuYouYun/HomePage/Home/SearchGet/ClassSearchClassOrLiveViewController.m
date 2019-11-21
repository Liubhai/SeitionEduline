//
//  ClassSearchClassOrLiveViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/28.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ClassSearchClassOrLiveViewController.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

@interface ClassSearchClassOrLiveViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger Number;
}


@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)UIButton       *clearButton;


@end

@implementation ClassSearchClassOrLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTabView];
    [self addClearButton];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor clearColor];
    _dataArray = @[@"直播课程",@"点播课程",@"班级课程"];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelfView) name:@"SearchClassOrLiveRemove" object:nil];
}

- (void)addTabView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 36 * WideEachUnit * _dataArray.count) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 24, MainScreenWidth, 36 * WideEachUnit * _dataArray.count);
    }
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 36 * WideEachUnit;
    _tableView.tag = 1;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    
}

- (void)addClearButton {
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0,  36 * WideEachUnit * _dataArray.count , MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit - 36 * WideEachUnit * _dataArray.count)];
    if (iPhoneX) {
        clearButton.frame = CGRectMake(0, 24 + 36 * WideEachUnit * _dataArray.count, MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit - 36 * WideEachUnit * _dataArray.count);
    }
    clearButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [clearButton addTarget:self action:@selector(removeSelfView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    _clearButton = clearButton;
}


#pragma mark --- 刷新


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
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"#f0f0f2"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#656565"];
    cell.textLabel.font = Font(14);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //传值处理
    NSString *classOrLiveStr = [_dataArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationSearchClassOrLiveID" object:classOrLiveStr];
    [self removeSelfView];
}

#pragma mark --- 通知
-(void)removeSelfView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationSearchClassOrLiveButton" object:nil];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


@end
