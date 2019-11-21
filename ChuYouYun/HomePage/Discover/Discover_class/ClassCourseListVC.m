//
//  ClassCourseListVC.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "ClassCourseListVC.h"
#import "AppDelegate.h"
#import "ClassCourseListCell.h"
#import "Good_ClassMainViewController.h"
#import "ZhiBoMainViewController.h"

@interface ClassCourseListVC ()

@end

@implementation ClassCourseListVC

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
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    _headerView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, MainScreenWidth - 40, 0.5)];
    lineView.backgroundColor = RGBHex(0xF1F1F1);
    [_headerView addSubview:lineView];
    _dataSource = [NSMutableArray new];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tableHeight) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _headerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    [_tableView reloadData];
}

// MARK: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 * HigtEachUnit + 8 * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ClassCourseListCell";
    ClassCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ClassCourseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setCourseInfo:_dataSource[indexPath.row]];
    return cell;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *typeS = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"type"]];
    if ([typeS isEqualToString:@"1"]) {
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"id"]];
        [self.vc.navigationController pushViewController:vc animated:YES];
    } else {
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:[NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"id"]] andImage:nil andTitle:nil andNum:nil andprice:nil];
        [self.vc.navigationController pushViewController:zhiBoMainVc animated:YES];
    }
}

// MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.cellTabelCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        self.vc.canScroll = YES;
    }
}

- (void)setOriginDict:(NSDictionary *)originDict {
    _originDict = originDict;
    if (SWNOTEmptyDictionary(_originDict)) {
        if (SWNOTEmptyArr([_originDict objectForKey:@"videoData"])) {
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:[_originDict objectForKey:@"videoData"]];
            [_tableView reloadData];
        }
    }
}

@end
