//
//  GroupMangerViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GroupMangerViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BigWindCar.h"
#import "TKProgressHUD+Add.h"
#import "MJRefresh.h"
#import "DLViewController.h"

#import "GroupMangerCell.h"


@interface GroupMangerViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)NSString *actionStr;
@property (strong ,nonatomic)NSDictionary *settingDict;
@property (strong ,nonatomic)NSString *memberID;
@property (assign ,nonatomic)NSInteger Num;

@end

@implementation GroupMangerViewController

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
    [self addTableView];
    [self netWorkGetMember];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _Num = 0;
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
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"小组管理";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- View
- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 80;
    _tableView.dataSource = self;
    _tableView.delegate = self;
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

- (void)headerRerefreshings
{
    [self netWorkGetMember];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
        _Num ++;
        [self netWorkGetMember];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

#pragma mark --- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellStr = @"WDTableViewCell";
    GroupMangerCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[GroupMangerCell alloc] initWithReuseIdentifier:cellStr];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *managerID = [_dict stringValueForKey:@"uid"];
    _settingDict = _dataArray[indexPath.row];
    NSLog(@"------%@",_settingDict);
    _memberID = [_settingDict stringValueForKey:@"uid"];
    
    
    NSString *adminStr = @"设为管理员";
    NSString *joinStr = @"踢出该小组";
    NSString *adminUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    
    if ([adminUID isEqualToString:_memberID]) {//说明就是自己
        [TKProgressHUD showError:@"不能对自己进行操作" toView:self.view];
        return;
    }
    
    if ([adminUID isEqualToString:managerID]) {//说明自己是管理员
        
    } else {//不是管理元
        
        if ([managerID isEqualToString:_memberID]) {//说明你操作的是管理员
            [TKProgressHUD showError:@"没有权限" toView:self.view];
            return;
        } else {
            if ([[_dict stringValueForKey:@"is_admin"] integerValue] == 0) {//没有权限
                [TKProgressHUD showError:@"没有权限" toView:self.view];
                return;
            } else {//有权限
                
            }
        }
        
    }
    
    if ([[_settingDict stringValueForKey:@"is_admin"] integerValue] == 1) {
        adminStr = @"降为普通成员";
    }
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:adminStr otherButtonTitles:joinStr, nil];
    action.delegate = self;
    [action showInView:self.view];
}

#pragma mark --- UISheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _actionStr = @"1";
    if (buttonIndex == 0) {//管理员
        if ([[_settingDict stringValueForKey:@"is_admin"] integerValue] == 1) {
            _actionStr = @"normal";
        } else {
            _actionStr = @"admin";
        }
    } else if (buttonIndex == 1) {//移除小组
        _actionStr = @"out";
    } else {
        return;
    }
    
    [self netWorkManger];
}



#pragma mark --- 网络请求

//小组成员
- (void)netWorkGetMember {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:_IDString forKey:@"group_id"];
    if (_typeStr == nil) {
        [dic setValue:@"" forKey:@"type"];
    } else {
        [dic setValue:_typeStr forKey:@"type"];
    }

    [manager BigWinCar_getGroupMember:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _dataArray = responseObject[@"data"];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

//小组成员管理
- (void)netWorkManger {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    [dic setValue:_memberID forKey:@"uid"];//需要管理成员的Uid
    [dic setValue:_IDString forKey:@"group_id"];
    [dic setValue:_actionStr forKey:@"action"];
    
    NSLog(@"%@",dic);
    [manager BigWinCar_member:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"操作成功" toView:self.view];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [TKProgressHUD showError:@"操作失败" toView:self.view];
    }];
    
}


@end
