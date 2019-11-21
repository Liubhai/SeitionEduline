//
//  NewsViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/1.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "NewsViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZXDTViewController.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "UIButton+WebCache.h"

#import "ZXZXTableViewCell.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSInteger Number;
}

@property (strong ,nonatomic)NSString *IDStr;
@property (strong ,nonatomic)NSString *schoolIDStr;
@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;


@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSArray *cateArray;


@end

@implementation NewsViewController

-(instancetype)initWithIDString:(NSString *)IDStr schoolId:(NSString *)schoolID{
    
    self = [super init];
    if (self) {
        _IDStr = IDStr;
        _schoolIDStr = schoolID;
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_SAFEAREA - MACRO_UI_UPHEIGHT - 40 * HigtEachUnit)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
        [_tableView addSubview:_imageView];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self netWorkNewsGetListWithID:_IDStr WithNumber:1];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    Number = 1;
}

#pragma mark --- 添加表格

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 40 * HigtEachUnit) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- 刷新
- (void)headerRerefreshings
{
    Number = 1;
    [self netWorkNewsGetListWithID:_IDStr WithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    Number ++;
    [self netWorkNewsGetListWithID:_IDStr WithNumber:Number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    });
}


#pragma mark -- UITableViewDataSoucre


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    ZXZXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZXZXTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    cell.titleLabel.text = _dataArray[indexPath.row][@"title"];
    NSString *readStr = [NSString stringWithFormat:@"阅读：%@",_dataArray[indexPath.row][@"readcount"]];
    cell.readLabel.text = readStr;
    cell.timeLabel.text = _dataArray[indexPath.row][@"dateline"];
    cell.JTLabel.text = [Passport filterHTML:_dataArray[indexPath.row][@"text"]];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZXDTViewController *ZXDTVC = [[ZXDTViewController alloc] init];
    ZXDTVC.ID = _dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:ZXDTVC animated:YES];
}


#pragma mark --- 网络请求
- (void)netWorkNewsGetListWithID:(NSString *)IDStr WithNumber:(NSInteger)Number {
    
    NSString *endUrlStr = YunKeTang_News_news_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1" forKey:@"order"];
    [mutabDict setObject:[NSString stringWithFormat:@"%@",_IDStr] forKey:@"cid"];
    [mutabDict setValue:[NSNumber numberWithInteger:Number] forKey:@"page"];
    [mutabDict setValue:@"10" forKey:@"count"];
    [mutabDict setObject:[NSString stringWithFormat:@"%@",_schoolIDStr] forKey:@"school_id"];

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
            if (Number == 1) {
                _dataArray = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                //判断添加图片
                if (_dataArray.count == 0) {
                    self.imageView.hidden = NO;
                } else {
                    self.imageView.hidden = YES;
                }
            } else {
                [_dataArray addObjectsFromArray:(NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
            }
        } else {
            
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}




@end
