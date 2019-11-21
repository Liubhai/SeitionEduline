//
//  ExchangeViewController.m
//  dafengche
//
//  Created by IOS on 16/10/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ExchangeViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "TKProgressHUD+Add.h"

#import "Passport.h"


@interface ExchangeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *lookArray;
@property (assign ,nonatomic)NSInteger number;


@end

@implementation ExchangeViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
        [_tableView addSubview:_imageView];
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
    [self interFace];
    [self addNav];
    [self addTableView];

}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _number = 1;
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"兑换记录";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        titleLab.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        
    }

}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 65;
    [self.view addSubview:_tableView];
    //添加刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];

    //设置表格分割线的长度（跟两边的距离）
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,10)];
    }
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    
}
- (void)headerRerefreshing
{
    _number = 1;
    [self netWorkOrderGetList:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    _number++;
    [self netWorkOrderGetList:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

#pragma mark -- UITableViewDatasoure


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 36 * WideEachUnit;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10 * WideEachUnit;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    headerLab.text = @"支付";
    headerLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [cell.contentView addSubview:headerLab];
    headerLab.font  = Font(13);
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    NSLog(@"===%@",dict);
    
    UILabel *detilLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, MainScreenWidth - 130 , 20)];
//    detilLab.text = _dataArray[indexPath.row][@"goods_info"][@"title"];
    
    NSLog(@"----%@",[[_dataArray objectAtIndex:indexPath.row] dictionaryValueForKey:@"goods_info"]);
    NSLog(@"----%@",[[[_dataArray objectAtIndex:indexPath.row] dictionaryValueForKey:@"goods_info"] stringValueForKey:@"title"]);
    
    if ([[[_dataArray objectAtIndex:indexPath.row] arrayValueForKey:@"goods_info"] isKindOfClass:[NSArray class]]) {
        
    } else {
        
//        [[[_dataArray objectAtIndex:indexPath.row] dictionaryForKey:@"goods_info"] isKindOfClass:[NSDictionary class]]
        if ([_dataArray objectAtIndex:indexPath.row]== nil) {

            
        } else {
//             detilLab.text = [NSString stringWithFormat:@"----%@",[[[_dataArray objectAtIndex:indexPath.row] dictionaryForKey:@"goods_info"] stringValueForKey:@"title"]];
            detilLab.text = _dataArray[indexPath.row][@"goods_info"][@"title"];
            
        }
    }
    detilLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [cell.contentView addSubview:detilLab];
    detilLab.font  = Font(13);
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 210, 10, 200, 20)];
    timeLab.text = [Passport formatterTime:_dataArray[indexPath.row][@"ctime"]];;
    timeLab.textColor = [UIColor grayColor];
    [cell.contentView addSubview:timeLab];
    timeLab.alpha = 0.7;
    timeLab.font  = Font(12);
    timeLab.textAlignment = NSTextAlignmentRight;
    
    UILabel *last = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 130, 35, 120, 20)];
    last.text = [NSString stringWithFormat:@"-%@积分",_dataArray[indexPath.row][@"price"]];;
    if ([[[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"pay_price"] floatValue] != 0) {
        last.text = [NSString stringWithFormat:@"%@育币",[[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"pay_price"]];
    }
    last.textColor = BasidColor;
    last.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:last];
    last.font  = Font(13);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark ---- 网络请求
- (void)netWorkOrderGetList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_Order_order_getGoodsOrderList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"exchange" forKey:@"type"];
    [mutabDict setValue:@"10" forKey:@"count"];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",_number] forKey:@"page"];
    
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
                if (Num == 1) {
                    _dataArray = (NSMutableArray *)[dict arrayValueForKey:@"data"];
                } else {
                    [_dataArray addObjectsFromArray:(NSMutableArray *)[dict arrayValueForKey:@"data"]];
                }
            } else {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                } else {
                    [_dataArray addObjectsFromArray:(NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
                }
            }
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





@end
