//
//  Good_BankViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/7.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_BankViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "rootViewController.h"
#import "BigWindCar.h"

#import "Good_ManagementCardViewController.h"
#import "Good_BankTableViewCell.h"
#import "Good_AddBankViewController.h"

@interface Good_BankViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView    *tableView;
@property (strong ,nonatomic)UIView         *footView;
@property (strong ,nonatomic)NSArray        *dataArray;

@end

@implementation Good_BankViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self netWorkUserBankCardList];
    
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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"银行卡";
    _rightButton.hidden = NO;
    [_rightButton setImage:[UIImage imageNamed:@"set1@3x"] forState:UIControlStateNormal];
    [self interFace];
    [self addFootView];
    [self addTableView];
    [self netWorkUserBankCardList];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [setButton setImage:[UIImage imageNamed:@"set1@3x"] forState:UIControlStateNormal];
    [setButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:setButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"银行卡";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
}

- (void)rightButtonClick:(id)sender {
    [self setButtonPressed];
}

- (void)addFootView {
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 66 * WideEachUnit)];
    _footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_footView];
    
    //添加按钮
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 18 * WideEachUnit, 120 * WideEachUnit, 30 * WideEachUnit)];
    addButton.backgroundColor = [UIColor clearColor];
    [addButton setTitle:@" 添加银行卡" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
    addButton.titleLabel.font = Font(16 * WideEachUnit);
    [addButton setImage:Image(@"bank_add@3x") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:addButton];
}

#pragma mark --- 添加表格
- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 130 * WideEachUnit;
    _tableView.tableFooterView = _footView;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01 * WideEachUnit;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"cell";
    //自定义cell类
    Good_BankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[Good_BankTableViewCell alloc] initWithReuseIdentifier:CellID];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setButtonPressed {
    Good_ManagementCardViewController *vc = [[Good_ManagementCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addButtonCilck:(UIButton *)button {
    Good_AddBankViewController *vc = [[Good_AddBankViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 网络请求
//获取最新会员
//- (void)NetWorkBanks {
//
//    BigWindCar *manager = [BigWindCar manager];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
//
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
//        [dic setObject:UserOathToken forKey:@"oauth_token"];
//        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
//    }
//    [manager BigWinCar_GetPublicWay:dic mod:@"User" act:@"banks" success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([responseObject[@"code"] integerValue] == 1) {
//            _dataArray = [[responseObject dictionaryValueForKey:@"data"] arrayValueForKey:@"card_list"];
//        }
//        [_tableView reloadData];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
//}


- (void)netWorkUserBankCardList {
    
    NSString *endUrlStr = YunKeTang_User_user_bankCardList;
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            _dataArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}



@end
