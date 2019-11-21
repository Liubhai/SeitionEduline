//
//  BoundViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/7.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "BoundViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "rootViewController.h"
#import "BigWindCar.h"

#import "Good_BankViewController.h"
#import "Good_AlipayViewController.h"
#import "Good_AliBoundViewController.h"
#import "Good_PersonFaceBoundViewController.h"
#import "Good_ThirdBoundViewController.h"


@interface BoundViewController ()<UITableViewDelegate,UITableViewDataSource> {
    BOOL isHaveAli;
}

@property (strong ,nonatomic)UITableView    *tableView;

@property (strong ,nonatomic)NSDictionary   *aliDict;
@property (strong ,nonatomic)NSDictionary   *faceStatusDataSource;
@property (strong ,nonatomic)NSString       *faceOpen;
@property (strong ,nonatomic)NSMutableArray        *titleArray;

@property (strong, nonatomic) NSMutableArray *payTypeArray;


@end

@implementation BoundViewController

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
    _titleArray = [NSMutableArray new];
    _payTypeArray = [NSMutableArray new];
    [self interFace];
    [self addNav];
    [self addTableView];
    [self netWorkUserBalanceConfig];
    [self NetWorkGetFaceStatus];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    isHaveAli = NO;
//    _titleArray = @[@"银行卡",@"支付宝",@"第三方绑定"];
    [_titleArray addObjectsFromArray:@[@"第三方绑定"]];
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
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"绑定管理";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    if (iPhoneX) {
        SYGView.frame = CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight);
        backButton.frame = CGRectMake(5, 35, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
}

#pragma mark --- 添加表格
- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50 * WideEachUnit;
    [self.view addSubview:_tableView];
    
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1 * WideEachUnit;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_titleArray[indexPath.row] isEqualToString:@"银行卡"]) {
        Good_BankViewController *vc = [[Good_BankViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_titleArray[indexPath.row] isEqualToString:@"支付宝"]) {
        [self netWorkUserGetAlipayInfo];
    } else if ([_titleArray[indexPath.row] isEqualToString:@"第三方绑定"]) {
        Good_ThirdBoundViewController *vc = [[Good_ThirdBoundViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_titleArray[indexPath.row] isEqualToString:@"刷脸绑定"]) {
        Good_PersonFaceBoundViewController *vc = [[Good_PersonFaceBoundViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 网络请求
- (void)netWorkUserGetAlipayInfo {
    
    NSString *endUrlStr = YunKeTang_User_user_getAlipayInfo;
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
        _aliDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        _aliDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([_aliDict stringValueForKey:@"account"] != nil) {
            isHaveAli = YES;
        } else {
            isHaveAli = NO;
        }
        //跳转
        if (isHaveAli) {
            Good_AlipayViewController *vc = [[Good_AlipayViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            Good_AliBoundViewController *vc = [[Good_AliBoundViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}

//人脸识别的配置接口
- (void)NetWorkGetFaceStatus {
    
    NSString *endUrlStr = YunKeTang_config_getFaceStatus;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
    [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _faceStatusDataSource = [dict dictionaryValueForKey:@"data"];
            } else {
                _faceStatusDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        }

        if ([[_faceStatusDataSource stringValueForKey:@"is_open"] integerValue] == 0) {//不存在
            _faceOpen = @"0";
//            _titleArray = @[@"银行卡",@"支付宝",@"第三方绑定"];
//            _titleArray = @[@"银行卡",@"第三方绑定"];
        } else if ([[_faceStatusDataSource stringValueForKey:@"is_open"] integerValue] == 1) {//正常使用
            _faceOpen = @"1";
//            _titleArray = @[@"银行卡",@"支付宝",@"第三方绑定",@"刷脸绑定"];
//            _titleArray = @[@"银行卡",@"第三方绑定",@"刷脸绑定"];
            [_titleArray addObject:@"刷脸绑定"];
        } else if ([[_faceStatusDataSource stringValueForKey:@"is_open"] integerValue] == 2) {//需要上传更多的照片
            _faceOpen = @"2";
//            _titleArray = @[@"银行卡",@"支付宝",@"第三方绑定",@"刷脸绑定"];
//            _titleArray = @[@"银行卡",@"第三方绑定",@"刷脸绑定"];
            [_titleArray addObject:@"刷脸绑定"];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取余额各种数据以及配置
- (void)netWorkUserBalanceConfig {
    
    NSString *endUrlStr = YunKeTang_User_user_balanceConfig;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1"forKey:@"tab"];
    [mutabDict setObject:@"50"forKey:@"limit"];
    
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
        if ([[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject] objectForKey:@"code"] integerValue] == 1) {
            if (SWNOTEmptyDictionary([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject])) {
                [_payTypeArray addObjectsFromArray:[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject] arrayValueForKey:@"pay"]];
            }
            /// 这里优化处理  由于后台强制会有银行卡 这里根据是不是只有余额方式来显示
            if ([_payTypeArray containsObject:@"alipay"]) {
                [_titleArray insertObject:@"支付宝" atIndex:0];
                [_titleArray insertObject:@"银行卡" atIndex:0];
            }
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [self netWorkUserBalanceConfig];
    }];
    [op start];
}



@end
