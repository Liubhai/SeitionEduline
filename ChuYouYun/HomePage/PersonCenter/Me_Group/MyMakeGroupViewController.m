//
//  MyMakeGroupViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/9.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MyMakeGroupViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "MyGroupTableViewCell.h"
#import "GroupDetailViewController.h"

@interface MyMakeGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>{
    NSInteger Number;
}

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSMutableArray     *dataArray;
@property (strong ,nonatomic)NSString           *IDString;


@end

@implementation MyMakeGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self netWorkGetJoinGroupListWithNumber:1];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    Number = 0;
}

#pragma mark --- 添加表格

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 12) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 88 - 12);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- 刷新
- (void)headerRerefreshings {
    Number = 1;
    [self netWorkGetJoinGroupListWithNumber:1];
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
    MyGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyGroupTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell dataSourceWith:dic WithType:@"1"];
    [cell.actionButton addTarget:self action:@selector(actionButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    cell.actionButton.tag = indexPath.row;
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
    
}

#pragma mark --- 事件点击
- (void)actionButtonCilck:(UIButton *)button {
    _IDString = _dataArray[button.tag][@"id"];
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解散小组", nil];
    action.delegate = self;
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%@",_IDString);
    if (buttonIndex == 0) {//退出小组
        [self netWorkDeleteGroup];
    } else {
        
    }
}


#pragma mark --- 网络请求
- (void)netWorkGetJoinGroupListWithNumber:(NSInteger)number {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:[NSString stringWithFormat:@"%ld",number] forKey:@"page"];
    [dic setValue:@"100" forKey:@"count"];
    [dic setValue:@"create" forKey:@"type"];
    
    [manager BigWinCar_getJoinGroupList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *array = responseObject[@"data"];
        if (number == 1) {
            if (array.count == 0) {//空数据
                //添加空白处理
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64)];
                imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
                [_tableView addSubview:imageView];
            } else {
                _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            }
        } else {
            if ([responseObject[@"code"] integerValue] == 0) {//没有更多数据了
                [TKProgressHUD showError:@"没有更多数据了" toView:self.view];
            } else {
                NSArray *array = responseObject[@"data"];
                [_dataArray addObjectsFromArray:array];
            }
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}


//解散小组
- (void)netWorkDeleteGroup {

    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [TKProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
    [dic setValue:_IDString forKey:@"group_id"];
    [manager BigWinCar_deleteGroup:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"解散成功" toView:self.view];
            [self netWorkGetJoinGroupListWithNumber:1];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showSuccess:@"解散失败" toView:self.view];
    }];
}








@end
