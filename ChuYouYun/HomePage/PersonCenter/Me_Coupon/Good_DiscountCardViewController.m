//
//  Good_DiscountCardViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/2.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_DiscountCardViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "Good_CardStockTableViewCell.h"
#import "InstitutionMainViewController.h"
#import "ClassSearchGoodViewController.h"

@interface Good_DiscountCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray     *dataArray;

@end

@implementation Good_DiscountCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self netWorkCouponGetMyCouponList];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.rowHeight = 170 * WideEachUnit;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
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
//    return 5;
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    Good_CardStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //自定义cell类
    if (cell == nil) {
        cell = [[Good_CardStockTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict WithType:[NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]]];
    [cell.useLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellUserLabelClick:)]];
    cell.useLabel.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger tapTag = indexPath.row;
    if ([MoreOrSingle integerValue] == 1) {
        ClassSearchGoodViewController *getSearchVc = [[ClassSearchGoodViewController alloc] init];
        getSearchVc.typeStr = @"1";
        [self.navigationController pushViewController:getSearchVc animated:YES];
    } else {
        InstitutionMainViewController *instVc = [[InstitutionMainViewController alloc] init];
        instVc.schoolID =  [NSString stringWithFormat:@"%@",_dataArray[tapTag][@"sid"]];
        instVc.uID = [NSString stringWithFormat:@"%@",_dataArray[tapTag][@"uid"]];
        [self.navigationController pushViewController:instVc animated:YES];
    }
}

#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

//手势
- (void)cellUserLabelClick:(UIGestureRecognizer *)tap {
    
    NSInteger tapTag = tap.view.tag;
    if ([MoreOrSingle integerValue] == 1) {
        ClassSearchGoodViewController *getSearchVc = [[ClassSearchGoodViewController alloc] init];
        getSearchVc.typeStr = @"1";
        [self.navigationController pushViewController:getSearchVc animated:YES];
    } else {
        InstitutionMainViewController *instVc = [[InstitutionMainViewController alloc] init];
        instVc.schoolID =  [NSString stringWithFormat:@"%@",_dataArray[tapTag][@"sid"]];
        instVc.uID = [NSString stringWithFormat:@"%@",_dataArray[tapTag][@"uid"]];
        [self.navigationController pushViewController:instVc animated:YES];
    }
}


#pragma mark ----网络请求
//获取打折卡
- (void)netWorkCouponGetMyCouponList {
    
    NSString *endUrlStr = YunKeTang_Coupon_coupon_getMyCouponList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"100" forKey:@"count"];
    [mutabDict setObject:@"2" forKey:@"type"];
    [mutabDict setObject:@"1" forKey:@"page"];
    [mutabDict setObject:@"0" forKey:@"status"];
    
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
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        if (_dataArray.count == 0) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-15 * WideEachUnit, 0, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
            [_tableView addSubview:imageView];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


@end
