//
//  MyLiveViewController.m
//  ChuYouYun
//
//  Created by IOS on 16/11/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "MyLiveViewController.h"
#import "MyHttpRequest.h"
#import "teacherList.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MJRefreshBaseView.h"
#import "SYGClassTool.h"
#import "UIButton+WebCache.h"
#import "GLReachabilityView.h"
#import "UIColor+HTMLColors.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "ZhiBoMainViewController.h"

#import "ClassRevampCell.h"
#import "SYG.h"
#import "DLViewController.h"

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

@interface MyLiveViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * dataArray2;
    UIView *_view;
    UILabel *_lable;
    
}

@property (strong ,nonatomic)UIImageView *imageView;

@property(nonatomic,assign)NSInteger numder;

//营销数据
@property (strong ,nonatomic)NSString *order_switch;

@end

@implementation MyLiveViewController

- (id)initWithId:(NSString *)Id
{
    if (self=[super init]) {
        _cateory_id = Id;
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34)];
        _imageView.image = Image(@"云课堂_空数据");
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

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
    
    _view = (UIView *)[GLReachabilityView popview];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110 * WideEachUnit;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    dataArray2 = [[NSMutableArray alloc]init];
    
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [_tableView headerBeginRefreshing];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    
    //营销数据的请求
    [self netWorkConfigGetMarketStatus];
}

- (void)headerRerefreshing
{
    _numder = 1;
    [self netWorkUserGetMyLiveList:_numder];
}

- (void)footerRefreshing
{
    //先隐藏
    _numder++;
    [self loadMoreData];
}

#pragma mark --- UITableViewDelegata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"GLLiveTableViewCell";
    //自定义cell类
    ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
//    [cell dataWithDict:dict withType:@"2"];
    [cell dataWithDict:dict withType:@"2" withOrderSwitch:_order_switch];
    cell.isBuyButton.hidden = YES;
    cell.kinsOf.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"time_limit"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *Cid = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"live_id"];
    NSString *Title = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
    NSString *ImageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"cover"];
    NSString *price = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"t_price"];
    
    self.navigationController.navigationBar.hidden = NO;

    ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:price];
    zhiBoMainVc.order_switch = _order_switch;
    [self.navigationController pushViewController:zhiBoMainVc animated:YES];
}

#pragma mark --- 事件点击
-(void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 网络请求
- (void)netWorkUserGetMyLiveList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_User_live_getMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@(Num) forKey:@"page"];
    [mutabDict setValue:@"10" forKey:@"count"];
    
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
        if (Num == 1) {
            _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        } else {
            [_dataArray addObjectsFromArray:(NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
        }
        
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        if (_dataArray.count<10) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        [_tableView headerEndRefreshing];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [_tableView headerEndRefreshing];
        [_tableView reloadData];
    }];
    [op start];
}

- (void)loadMoreData {
    NSString *endUrlStr = YunKeTang_User_live_getMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@(_numder) forKey:@"page"];
    [mutabDict setValue:@"10" forKey:@"count"];
    
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
        NSArray *pass;
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                pass = (NSArray *)[dict arrayValueForKey:@"data"];
            } else {
                pass = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        } else {
            _numder--;
        }
        if (pass.count) {
            [_dataArray addObjectsFromArray:pass];
        }
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        if (pass.count<10) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        _numder--;
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    }];
    [op start];
}

//获取营销数据
- (void)netWorkConfigGetMarketStatus {
    
    NSString *endUrlStr = YunKeTang_config_getMarketStatus;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _order_switch = [dict stringValueForKey:@"order_switch"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

@end
