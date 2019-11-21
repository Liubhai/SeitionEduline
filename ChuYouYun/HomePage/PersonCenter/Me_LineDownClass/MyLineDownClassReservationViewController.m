//
//  MyLineDownClassReservationViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/3/1.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "MyLineDownClassReservationViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "MyLineDownClassTableViewCell.h"

@interface MyLineDownClassReservationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray     *dataArray;

@property (strong ,nonatomic)NSDictionary *cellDict;

@end

@implementation MyLineDownClassReservationViewController

-(instancetype)initWithID:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _dict = dict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];

    if ([[_dict stringValueForKey:@"is_teacher"] integerValue] == 1) {
        [self netWorkUserLineVideoManageMyList:1];
    } else {
        [self netWorkUserLineVideoGetMyList:1];
    }
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 88 - 34 + 36);
    }
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.rowHeight = 240 * WideEachUnit;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- UITableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    MyLineDownClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //自定义cell类
    if (cell == nil) {
        cell = [[MyLineDownClassTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    if ([[_dict stringValueForKey:@"is_teacher"] integerValue] == 1) {
//        [cell dataSourceWithTeacher:dict WithType:@"1"];
        [cell dataSourceWith:dict WithType:@"1"];
    } else {
        [cell dataSourceWith:dict WithType:@"1"];
    }
    
    cell.completeButton.tag = indexPath.row;
    [cell.completeButton addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    InstitutionMainViewController*instVc = [[InstitutionMainViewController alloc] init];
//    instVc.schoolID = _dataArray[indexPath.row][@"school_id"];
//    instVc.uID = _dataArray[indexPath.row][@"uid"];
//    instVc.address = _dataArray[indexPath.row][@"location"];
//    [self.navigationController pushViewController:instVc animated:YES];
}

#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonCilck:(UIButton *)button {
    _cellDict = [_dataArray objectAtIndex:button.tag];
    [self netWorkUserLineVideoComfirm];
}
#pragma mark --- 网络请求
- (void)netWorkUserLineVideoGetMyList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_getMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"0" forKey:@"status"];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setObject:@"0" forKey:@"count"];
    
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
        
        NSDictionary *dict=  [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([dict[@"code"] integerValue] == 1 ) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _dataArray = [dict arrayValueForKey:@"data"];
            } else {
                _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        } else {
            _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        }
        if (_dataArray.count == 0) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 48)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
            [self.view addSubview:imageView];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



- (void)netWorkUserLineVideoManageMyList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_getMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"0" forKey:@"status"];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setObject:@"0" forKey:@"count"];
    
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
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _dataArray = [dict arrayValueForKey:@"data"];
            } else {
                _dataArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        if (_dataArray.count == 0) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 48)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
            [self.view addSubview:imageView];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}



- (void)netWorkUserLineVideoComfirm {

    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_confirm;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];

    if ([[_dict stringValueForKey:@"is_teacher"] integerValue] == 1) {
        [mutabDict setObject:@"1" forKey:@"status"];
        [mutabDict setObject:[_cellDict stringValueForKey:@"order_id"] forKey:@"id"];

    } else {
        [mutabDict setObject:@"1" forKey:@"status"];
        [mutabDict setObject:[_cellDict stringValueForKey:@"order_id"] forKey:@"id"];

    }
    
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
            if ([[_dict stringValueForKey:@"is_teacher"] integerValue] == 1) {
                [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
                [self netWorkUserLineVideoManageMyList:1];
            } else {
                [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
                [self netWorkUserLineVideoGetMyList:1];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}






@end
