//
//  MyTeacherManageReservationViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/5/7.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "MyTeacherManageReservationViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "MyLineDownClassTableViewCell.h"


@interface MyTeacherManageReservationViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSInteger pageCount;
    BOOL loadMore;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray     *dataArray;

@property (strong ,nonatomic)NSDictionary *dict;
@property (strong ,nonatomic)NSDictionary *cellDict;


@end

@implementation MyTeacherManageReservationViewController

-(instancetype)initWithID:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _dict = dict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    pageCount = 1;
    loadMore = NO;
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
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

- (void)headerRefresh {
    pageCount = 1;
    loadMore = NO;
    if ([[_dict stringValueForKey:@"is_teacher"] integerValue] == 1) {
        [self netWorkUserLineVideoManageMyList:pageCount];
    } else {
        [self netWorkUserLineVideoGetMyList:pageCount];
    }
}

- (void)footerRefresh {
    pageCount = pageCount + 1;
    loadMore = YES;
    if ([[_dict stringValueForKey:@"is_teacher"] integerValue] == 1) {
        [self netWorkUserLineVideoManageMyList:pageCount];
    } else {
        [self netWorkUserLineVideoGetMyList:pageCount];
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
        [cell dataSourceWithTeacher:dict WithType:@"1"];
//        [cell.completeButton setTitle:@"待学生完成" forState:UIControlStateNormal];
        cell.completeButton.frame = CGRectMake(MainScreenWidth - 80 * WideEachUnit, 170 * WideEachUnit, 70 * WideEachUnit, 20 * WideEachUnit);
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
    if ([[_cellDict stringValueForKey:@"learn_status"] integerValue] == 0) {//学生自己还没有确定只有学生能自己确定
        if ([[_dict stringValueForKey:@"is_teacher"] integerValue] == 1) {
            [TKProgressHUD showError:@"学生还待完成" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
    }
    [self netWorkUserLineVideoComfirm];
}
#pragma mark --- 网络请求
- (void)netWorkUserLineVideoGetMyList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_getMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"0" forKey:@"status"];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setObject:@"10" forKey:@"count"];
    
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
            NSArray *passArray;
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                passArray = (NSArray *)[dict arrayValueForKey:@"data"];
            } else {
                if (SWNOTEmptyArr([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject])) {
                    passArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject];
                }
            }
            if (loadMore) {
            } else {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:passArray];
            if (loadMore) {
                [_tableView footerEndRefreshing];
                if (passArray.count < 10) {
                    [_tableView setFooterHidden:YES];
                } else {
                    [_tableView setFooterHidden:NO];
                }
            } else {
                [_tableView headerEndRefreshing];
                if (passArray.count < 10) {
                    [_tableView setFooterHidden:YES];
                } else {
                    [_tableView setFooterHidden:NO];
                }
            }
        } else {
            if (loadMore) {
                pageCount--;
                [_tableView footerEndRefreshing];
            } else {
                [_tableView headerEndRefreshing];
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
        if (loadMore) {
            pageCount--;
            [_tableView footerEndRefreshing];
        } else {
            [_tableView headerEndRefreshing];
        }
        [_tableView reloadData];
    }];
    [op start];
}



- (void)netWorkUserLineVideoManageMyList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_manageMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1" forKey:@"status"];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setObject:@"10" forKey:@"limit"];
    
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
            NSArray *passArray;
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                passArray = (NSArray *)[dict arrayValueForKey:@"data"];
            } else {
                if (SWNOTEmptyArr([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject])) {
                    passArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject];
                }
            }
            if (loadMore) {
            } else {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:passArray];
            if (loadMore) {
                [_tableView footerEndRefreshing];
                if (passArray.count < 10) {
                    [_tableView setFooterHidden:YES];
                } else {
                    [_tableView setFooterHidden:NO];
                }
            } else {
                [_tableView headerEndRefreshing];
                if (passArray.count < 10) {
                    [_tableView setFooterHidden:YES];
                } else {
                    [_tableView setFooterHidden:NO];
                }
            }
        } else {
            if (loadMore) {
                pageCount--;
                [_tableView footerEndRefreshing];
            } else {
                [_tableView headerEndRefreshing];
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
        if (loadMore) {
            pageCount--;
            [_tableView footerEndRefreshing];
        } else {
            [_tableView headerEndRefreshing];
        }
        [_tableView reloadData];
    }];
    [op start];
}



- (void)netWorkUserLineVideoComfirm {
    
    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_confirm;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([[_dict stringValueForKey:@"is_teacher"] integerValue] == 1) {
        [mutabDict setObject:@"2" forKey:@"status"];
        [mutabDict setObject:[_cellDict stringValueForKey:@"id"] forKey:@"id"];
        
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
