//
//  GroupViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//  发现 小组

#import "GroupViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "MJRefresh.h"

#import "GroupTableViewCell.h"
#import "ZhiyiHTTPRequest.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "GroupDetailViewController.h"

#import "GreatViewController.h"
#import "GroupMainViewController.h"



@interface GroupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UIScrollView *scrollView;

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)NSMutableArray *dataSource;

@property (strong ,nonatomic)NSArray *oneArray;

@property (strong ,nonatomic)NSArray *twoArray;

@property (strong ,nonatomic)NSArray *threeArray;

@property (strong ,nonatomic)NSArray *cateArray;

@property (strong ,nonatomic)NSMutableArray *titleArray;

@property (strong ,nonatomic)NSString *typeTitleStr;

@property (strong ,nonatomic)NSString *typeStr;

@property (strong ,nonatomic)UIButton *seletButton;



@end

@implementation GroupViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self netWork];//刷新
    
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
//    [self addControllerSrcollView];
    [self addTableView];
    [self netWork];
    [self netWorkCate];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"小组";
    _dataArray = [NSArray array];
    _dataSource = [NSMutableArray array];
    _oneArray = [NSArray array];
    _twoArray = [NSArray array];
    _threeArray = [NSArray array];
    _titleArray = [NSMutableArray array];
    _typeStr = @"0";//分类的标示符
    
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
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];

    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"小组";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];

    //添加分类的按钮
    UIButton *SortButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 20, 40, 30)];
    [SortButton setBackgroundImage:Image(@"创建小组2") forState:UIControlStateNormal];
    [SortButton addTarget:self action:@selector(SortButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SortButton];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 40)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    //添加按钮
    for (int i = 0 ; i < _titleArray.count; i ++) {
        
        CGFloat buttonW = (MainScreenWidth - 4 * SpaceBaside) / 3;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((buttonW + SpaceBaside) * i + SpaceBaside, 5, buttonW, 30)];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:BasidColor forState:UIControlStateSelected];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        if (i == [_typeStr integerValue]) {//刷新的时候 还是显示当前分类的数据
            [self buttonCilck:button];
        }
    }
    [_tableView reloadData];
    
}


- (void)addControllerSrcollView {
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) + 10,  MainScreenWidth, MainScreenHeight * 3 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [self.view addSubview:_controllerSrcollView];
    
//    InstitutionHomeViewController * instHomeVc= [[InstitutionHomeViewController alloc]init];
//    instHomeVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
//    [self addChildViewController:instHomeVc];
//    [_controllerSrcollView addSubview:instHomeVc.view];
//    
//    InstationClassViewController * classVc = [[InstationClassViewController alloc]init];
//    classVc.view.frame = CGRectMake(MainScreenWidth, -64, MainScreenWidth, MainScreenHeight * 2 + 500);
//    [self addChildViewController:classVc];
//    [_controllerSrcollView addSubview:classVc.view];
//    
//    InstationTeacherViewController * teacherVc = [[InstationTeacherViewController alloc]init];
//    teacherVc.view.frame = CGRectMake(MainScreenWidth * 2, -64, MainScreenWidth, MainScreenHeight);
//    [self addChildViewController:teacherVc];
//    [_controllerSrcollView addSubview:teacherVc.view];
    
}


- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 40, MainScreenWidth, MainScreenHeight - 64  - 5) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 110;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
}

#pragma mark --- 刷新

- (void)headerRerefreshings
{
    [self netWork];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    //    _numder++;
    //    [self requestData:_numder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
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
    NSString *baseUrl = @"http://dafengche.51eduline.com//data//upload//";
    NSString *imageStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"logourl"]];
    groupDVc.imageStr = imageStr;
    groupDVc.cateArray = _cateArray;
    
}

#pragma mark --- 事件监听
- (void)buttonCilck:(UIButton *)button {
    
    self.seletButton.selected = NO;
    button.selected = YES;
    self.seletButton = button;
    _typeStr = [NSString stringWithFormat:@"%ld",button.tag];
    
    if (_dataSource.count != 0) {
        _dataArray = _dataSource[button.tag];
    }

    _tableView.contentOffset = CGPointMake(0, 0);
    [_tableView reloadData];
    
}

- (void)SortButtonClick {
    
//    GreatViewController *greatVc = [[GreatViewController alloc] init];
//    [self.navigationController pushViewController:greatVc animated:YES];
//    greatVc.cateArray = _cateArray;
    
    GroupMainViewController *mainVc = [[GroupMainViewController alloc] init];
    [self.navigationController pushViewController:mainVc animated:YES];
    
    
}
#pragma mark -- 网络请求

- (void)netWork {

    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    
    [manager BigWinCar_GroupList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);

         _dataArray = responseObject[@"data"];

         for (int i = 0 ; i < _dataArray.count ; i ++) {
             NSArray *array = _dataArray[i][@"group_list"];
             [_dataSource addObject:array];
         }

         [self addScrollView];
         
         [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
 
}


- (void)netWorkCate {

    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    
    [manager BigWinCar_GroupCate:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {

         _cateArray = responseObject[@"data"];
         for (int i = 0 ; i < _cateArray.count ; i ++) {
             NSString *titleStr = _cateArray[i][@"title"];
             [_titleArray addObject:titleStr];
         }

         [self addScrollView];
         
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}


@end
