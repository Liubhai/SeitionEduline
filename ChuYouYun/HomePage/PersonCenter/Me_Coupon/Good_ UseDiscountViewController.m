//
//  Good_ UseDiscountViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/12/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_ UseDiscountViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "Good_CardStockTableViewCell.h"
#import "InstitutionMainViewController.h"
#import "Good_UseTableViewCell.h"

@interface Good__UseDiscountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray     *dataArray;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSMutableArray *seleArray;

@property (strong ,nonatomic)NSString     *ID;
@property (strong ,nonatomic)NSDictionary *dict;
@property (strong ,nonatomic)NSDictionary *seleDict;

@property (strong ,nonatomic)UIButton    *sureButton;

@end

@implementation Good__UseDiscountViewController

- (instancetype)initWithID:(NSString *)ID withDict:(NSDictionary *)dict{
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
    _dataArray = [NSMutableArray new];
    [self interFace];
    [self addTableView];
//    [self addDownButton];
    [self netWorkVideoGetCanUseCouponList];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _seleArray = [NSMutableArray array];
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

- (void)addDownButton {
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 - 45 * WideEachUnit, 200 *WideEachUnit, 30 * WideEachUnit)];
    _sureButton.backgroundColor = [UIColor colorWithRed:240.f / 255 green:60.f / 255 blue:57.f / 255 alpha:1];
    _sureButton.layer.cornerRadius = 5 * WideEachUnit;
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sureButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureButton];
}

#pragma mark --- UITableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    cell.use.text = @"立\n即\n使\n用";
    return cell;
//    static NSString *CellIdentifier = @"culture";
//    //自定义cell类
//    Good_UseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    //自定义cell类
//    if (cell == nil) {
//        cell = [[Good_UseTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
//    }
//
//    NSDictionary *dict = _dataArray[indexPath.row];
//    [cell dataSourceWith:dict];
//
//    if ([[_seleArray objectAtIndex:indexPath.row] integerValue] == 0) {
//        [cell.seleButton setImage:Image(@"unchoose_s@3x") forState:UIControlStateNormal];
//    } else {
//        [cell.seleButton setImage:Image(@"choose@3x") forState:UIControlStateNormal];
//    }
//
////    [cell.useLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellUserLabelClick:)]];
//    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_seleArray removeAllObjects];
    
    for (int i = 0 ; i < _dataArray.count; i ++) {
        if (i == indexPath.row) {//当前的
            [_seleArray addObject:@"1"];
        } else {
            [_seleArray addObject:@"0"];
        }
    }
    
    [_tableView reloadData];
    _seleDict = [_dataArray objectAtIndex:indexPath.row];
    
    if (_seleDict.allKeys.count == 0) {
        _sureButton.enabled = YES;
        _sureButton.backgroundColor = [UIColor whiteColor];
    }
    [self sureButtonCilck];
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

- (void)sureButtonCilck {
    if (_seleDict.allKeys.count == 0) {
        return;
    }
    //传通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationGetWhichDiscount" object:_seleDict];
    [self backPressed];
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
        [mutabDict setValue:@"20" forKey:@"count"];
        [mutabDict setValue:_ID forKey:@"album_id"];
        [mutabDict setObject:@"0" forKey:@"canot"];
    } else {
        [mutabDict setValue:@"1" forKey:@"page"];
        [mutabDict setValue:@"50" forKey:@"count"];
        [mutabDict setValue:_ID forKey:@"id"];
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
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:(NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
            if (SWNOTEmptyArr(_dataArray)) {
                if (_showYouhui) {
                    for (int i = (int)(_dataArray.count - 1); i>=0; i--) {
                        if ([[_dataArray[i] stringValueForKey:@"type"] integerValue] != 5) {
                            [_dataArray removeObjectAtIndex:i];
                        }
                    }
                }
            }
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
            for (int i = 0 ; i < _dataArray.count ; i ++) {
                [_seleArray addObject:@"0"];
            }
            [_tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
