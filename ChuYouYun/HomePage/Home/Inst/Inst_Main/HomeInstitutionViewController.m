//
//  HomeInstitutionViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/10.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "HomeInstitutionViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "ZhiyiHTTPRequest.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "MyHttpRequest.h"


#import "InstitutionListCell.h"
#import "InstitutionMainViewController.h"
#import "Good_InstitutionMainViewController.h"



@interface HomeInstitutionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (assign ,nonatomic)NSInteger Num;

@end

@implementation HomeInstitutionViewController

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
//    [self addScreenView];
    [self addTableView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _Num = 1;
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
    
    
    
    UIButton *backButton1 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [backButton1 setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton1 addTarget:self action:@selector(backPressed1) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton1];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    WZLabel.text = @"入驻机构";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];

}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backPressed1 {
    Good_InstitutionMainViewController *vc = [[Good_InstitutionMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addScreenView {
    UIView *screenView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 40)];
    screenView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:screenView];
    
    NSArray *titleArray = @[@"综合排序",@"进行筛选"];
    for (int i = 0; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * MainScreenWidth / 2, 5, MainScreenWidth / 2, 30)];
        button.titleLabel.font = Font(15);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"灰色乡下"] forState:UIControlStateNormal];
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,MainScreenWidth / 2 - 70,0,80);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 30);
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [screenView addSubview:button];
        
    }

}


- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 33) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 105;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
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
    _Num ++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = nil;
    CellID = [NSString stringWithFormat:@"%@-%ld",@"cell",indexPath.row];
    //自定义cell类
    InstitutionListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[InstitutionListCell alloc] initWithReuseIdentifier:CellID];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    InstitutionMainViewController*instVc = [[InstitutionMainViewController alloc] init];
    instVc.schoolID = _dataArray[indexPath.row][@"school_id"];
    instVc.uID = _dataArray[indexPath.row][@"uid"];
    instVc.address = _dataArray[indexPath.row][@"location"];
    [self.navigationController pushViewController:instVc animated:YES];
}

#pragma mark --- 事件监听
- (void)buttonCilck:(UIButton *)button {
    
}

#pragma mark --- 网络请求


@end
