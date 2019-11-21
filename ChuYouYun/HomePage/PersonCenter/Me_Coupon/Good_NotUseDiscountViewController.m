//
//  Good_NotUseDiscountViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/12/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_NotUseDiscountViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "Good_CardStockTableViewCell.h"
#import "InstitutionMainViewController.h"
#import "Good_UseTableViewCell.h"

@interface Good_NotUseDiscountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray     *dataArray;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSString     *ID;
@property (strong ,nonatomic)NSDictionary *dict;

@end

@implementation Good_NotUseDiscountViewController

- (instancetype)initWithID:(NSString *)ID withDict:(NSDictionary *)dict; {
    if (self=[super init]) {
        _ID = ID;
        _dict = dict;
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
        [_tableView addSubview:_imageView];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
//    [self NetWorkGetMyCouponList];
    [self netWorkVideoGetCanUseCouponList];
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
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
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
    
    //    cell.useLabel.hidden = YES;
    //    cell.insetLabel.hidden = YES;
    cell.use.text = @"不\n可\n使\n用";
    return cell;
//    static NSString *CellIdentifier = @"culture";
//    //自定义cell类
//    Good_UseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    //自定义cell类
//    if (cell == nil) {
//        cell = [[Good_UseTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
//    }
//    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;//不能被点击
//
//    NSDictionary *dict = _dataArray[indexPath.row];
//    [cell dataSourceWith:dict];
//
//    cell.seleButton.hidden = YES;
//    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    //    OfflineDetailViewController *vc = [[OfflineDetailViewController alloc] init];
    //    vc.ID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"course_id"];
    //    vc.imageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
    //    vc.titleStr = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"course_name"];
    //    [self.navigationController pushViewController:vc animated:YES];
    
//    NSInteger tapTag = indexPath.row;
//    InstitutionMainViewController *instVc = [[InstitutionMainViewController alloc] init];
//    instVc.schoolID =  [NSString stringWithFormat:@"%@",_dataArray[tapTag][@"sid"]];
//    instVc.uID = [NSString stringWithFormat:@"%@",_dataArray[tapTag][@"uid"]];
//    [self.navigationController pushViewController:instVc animated:YES];
}

#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

//手势
- (void)cellUserLabelClick:(UIGestureRecognizer *)tap {
    
    NSInteger tapTag = tap.view.tag;
    InstitutionMainViewController *instVc = [[InstitutionMainViewController alloc] init];
    instVc.schoolID =  [NSString stringWithFormat:@"%@",_dataArray[tapTag][@"sid"]];
    instVc.uID = [NSString stringWithFormat:@"%@",_dataArray[tapTag][@"uid"]];
    [self.navigationController pushViewController:instVc animated:YES];
}


#pragma mark ----网络请求

//获取打折卡
- (void)NetWorkGetMyCouponList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    [dic setObject:_ID forKey:@"id"];
    [dic setObject:@"1" forKey:@"canot"];
    
    
    [manager BigWinCar_GetPublicWay:dic mod:@"Video" act:@"getCanUseCouponList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 1) {
            _dataArray = [responseObject arrayValueForKey:@"data"];
        }
        if (_dataArray.count == 0) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
            [_tableView addSubview:imageView];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}




#pragma mark --- 网络请求
//获取制定课程的优惠券
- (void)netWorkVideoGetCanUseCouponList {//
    
    NSString *endUrlStr = YunKeTang_Video_video_getCanUseCouponList;
    if ([[_dict stringValueForKey:@"2"] integerValue] == 2) {//直播 默认是点播
        endUrlStr = YunKeTang_Live_live_getCanUseCouponList;
    }
    if (_isCombo) {
        endUrlStr = album_getCanUseCouponList;
    }
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_isCombo) {
        [mutabDict setValue:@"1" forKey:@"page"];
        [mutabDict setValue:@"50" forKey:@"count"];
        [mutabDict setValue:_ID forKey:@"album_id"];
        [mutabDict setObject:@"1" forKey:@"canot"];
    } else {
        [mutabDict setValue:@"1" forKey:@"page"];
        [mutabDict setValue:@"50" forKey:@"count"];
        [mutabDict setValue:_ID forKey:@"id"];
        [mutabDict setObject:@"1" forKey:@"canot"];
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
            _dataArray =  (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
            [_tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


@end
