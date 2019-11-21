//
//  AllOrderModelVC.m
//  dafengche
//
//  Created by 赛新科技 on 2017/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "AllOrderModelVC.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "TKProgressHUD+Add.h"

#import "InstitutionListCell.h"
#import "OrderCell.h"
#import "RefundViewController.h"
#import "InstitutionMainViewController.h"


#import "ZhiBoMainViewController.h"
#import "Good_ClassMainViewController.h"
#import "OfflineDetailViewController.h"
#import "DLViewController.h"
#import "ClassDetailViewController.h"


@interface AllOrderModelVC ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)UIView         *allView;
@property (strong ,nonatomic)UIButton       *allButton;
@property (strong ,nonatomic)UIView         *payView;

@property (strong ,nonatomic)NSString *pay_status;//标示符

@property (strong ,nonatomic)NSString *alipayStr;
@property (strong ,nonatomic)NSString *wxpayStr;
@property (strong ,nonatomic)NSDictionary *wxPayDict;
@property (strong ,nonatomic)UIWebView *webView;
@property (assign ,nonatomic)NSInteger typeNum;
@property (strong ,nonatomic)NSDictionary *userAccountDict;

@property (assign ,nonatomic)NSInteger number;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)UIView     *allWindowView;
@property (strong ,nonatomic)UIButton   *aliSeleButton;
@property (strong ,nonatomic)UIButton   *wxSeleButton;
@property (strong ,nonatomic)UIButton   *balanceSeleButton;
@property (strong ,nonatomic)NSString   *payTypeStr;//支付类型的字段

//营销数据
@property (strong ,nonatomic)NSString   *order_switch;



@end

@implementation AllOrderModelVC

- (instancetype)initWithType:(NSString *)type {
    if (self=[super init]) {
        _isInst = type;
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + 40, MainScreenWidth, MainScreenHeight - 64 - 40)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
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
    [self netWorkOrderGetList:1];
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
    [self addTableView];
    [self netWorkOrderGetList:1];
    [self netWorkConfigGetMarketStatus];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _number = 1;
    _payTypeStr = @"1";
    _isInst = @"order";
}

#pragma mark --- UITableView

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 44 * WideEachUnit + 36) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 64 + 44 * WideEachUnit, MainScreenWidth, MainScreenHeight - 88 - 44 * WideEachUnit + 36);
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 190;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
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


#pragma mark --- 刷新

- (void)headerRerefreshings
{
    [self netWorkOrderGetList:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing {
    _number ++;
    [self netWorkOrderGetList:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}




#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = nil;
    CellID = [NSString stringWithFormat:@"cell%@ - %ld",_pay_status,indexPath.row];
    //自定义cell类
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithReuseIdentifier:CellID];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict WithType:_isInst];
    
//    [cell.schoolButton addTarget:self action:@selector(schoolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.schoolButton.tag = indexPath.row;
    cell.actionButton.tag = indexPath.row;
    cell.cancelButton.tag = indexPath.row;
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    
    [cell addGestureRecognizer:longPressGr];
    cell.tag = indexPath.row;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 4 || [_dataArray[indexPath.row][@"order_type"] integerValue] == 7) {//点播
        
        NSString *ID = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"source_info"][@"id"]];
        NSString *price = _dataArray[indexPath.row][@"source_info"][@"mz_price"][@"price"];
        NSString *title = _dataArray[indexPath.row][@"source_info"][@"video_title"];
        NSString *videoUrl =  [[[_dataArray objectAtIndex:indexPath.row] dictionaryValueForKey:@"source_info"] stringValueForKey:@"video_address"];;
        NSString *imageUrl = _dataArray[indexPath.row][@"source_info"][@"cover"];
        
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.imageUrl = imageUrl;
        vc.videoTitle = title;
        vc.videoUrl = videoUrl;
        vc.price = price;
        vc.ID = ID;
        vc.orderSwitch = _order_switch;
        vc.isClassNew = ([_dataArray[indexPath.row][@"order_type"] integerValue] == 7 ? YES : NO);
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 5) {
        OfflineDetailViewController *vc = [[OfflineDetailViewController alloc] init];
        vc.ID = [[[_dataArray objectAtIndex:indexPath.row] dictionaryValueForKey:@"line_class"] stringValueForKey:@"course_id"];
        vc.imageUrl = [[[_dataArray objectAtIndex:indexPath.row] dictionaryValueForKey:@"line_class"] stringValueForKey:@"imageurl"];
        vc.titleStr = [[[_dataArray objectAtIndex:indexPath.row] dictionaryValueForKey:@"line_class"] stringValueForKey:@"course_name"];
        vc.orderSwitch = _order_switch;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 3){//直播
        NSString *Cid = nil;
        Cid = _dataArray[indexPath.row][@"source_info"][@"id"];
        NSString *Price = _dataArray[indexPath.row][@"source_info"][@"price"];
        NSString *Title = _dataArray[indexPath.row][@"source_info"][@"video_title"];
        NSString *ImageUrl = _dataArray[indexPath.row][@"source_info"][@"cover"];
        
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
        zhiBoMainVc.order_switch = _order_switch;
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
    } else if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 2) {
        ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
        vc.combo_id = [NSString stringWithFormat:@"%@",[_dataArray[indexPath.row] objectForKey:@"album_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --- 手势

- (void)longPressToDo:(UILongPressGestureRecognizer *)gest {
    NSInteger Number = gest.view.tag;
    NSLog(@"%ld",(long)Number);
    _orderDict = _dataArray[Number];
    NSLog(@"%@",_dataArray[Number]);
    [self isSureDelete];
}

- (void)allWindowViewClick:(UITapGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

#pragma mark --- 事件

- (void)schoolButtonClick:(UIButton *)button {
    InstitutionMainViewController *mainVc = [[InstitutionMainViewController alloc] init];
    mainVc.schoolID = _dataArray[button.tag][@"source_info"][@"school_info"][@"school_id"];
    [self.navigationController pushViewController:mainVc animated:YES];
}

- (void)actionButtonClick:(UIButton *)button {
    NSInteger index = button.tag;
    _orderDict = _dataArray[index];
    NSString *title = button.titleLabel.text;
    
    if ([title isEqualToString:@"去支付"]) {
        [self netWorkUserGetAccount];
    } else if ([title isEqualToString:@"申请退款"]) {
        if ([[[_dataArray objectAtIndex:index] stringValueForKey:@"order_type"] integerValue] == 5) {//线下课
            [self gotoRefundVc];
        } else {
            [self gotoRefundVc];
        }
    } else if ([title isEqualToString:@"退款中"]) {
    } else if ([title isEqualToString:@"退款查看"]) {
    }
}

- (void)cancelButtonClick:(UIButton *)button {
    NSInteger index = button.tag;
    _orderDict = _dataArray[index];
    if ([[[_dataArray objectAtIndex:index] stringValueForKey:@"order_type"] integerValue] == 5) {//线下课
//        [TKProgressHUD showError:@"线下课暂不支持取消订单" toView:self.view];
//        return;
        [self isSureCancel];
    } else {
         [self isSureCancel];
    }
}

- (void)seleButtonCilck:(UIButton *)button {
    NSInteger buttonTag = button.tag;
    
    if (buttonTag == 0) {
        _aliSeleButton.selected = YES;
        _payTypeStr = @"1";
        
        _wxSeleButton.selected = NO;
        _balanceSeleButton.selected = NO;
    } else if (buttonTag == 1) {
        _wxSeleButton.selected = YES;
        _payTypeStr = @"2";
        
        _aliSeleButton.selected = NO;
        _balanceSeleButton.selected = NO;
    } else if (buttonTag == 2) {
        _balanceSeleButton.selected = YES;
        _payTypeStr = @"3";
        
        _aliSeleButton.selected = NO;
        _wxSeleButton.selected = NO;
    }
}

- (void)nowPayButtonCilck {
    //解锁
    if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 4) {//课程
        [self netWorkCourseCourseBuyVideo];
    } else if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 3) {//直播
        [self netWorkCourseCourseBuyLive];
    } else if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 5) {//线下课
        [self netWorkCourseCourseBuyLineCourse];
    }
}


//是否 真要删除小组
- (void)isSureCancel {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确定要取消该订单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self NetWorkCancel];
        [self netWorkOrderCancel];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//是否 真要申请退款
- (void)isSureRefund {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否要要申请退款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self gotoRefundVc];
        
        
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)gotoRefundVc {
    RefundViewController *refundVc = [[RefundViewController alloc] init];
    refundVc.orderDict = _orderDict;
    if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 5) {//线下课
        refundVc.downLineClass = @"lineClass";
    }
    [self.navigationController pushViewController:refundVc animated:YES];
}

#pragma mark --- 删除订单
- (void)isSureDelete {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否要要申请退款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self NetWorkdelete];
        [self netWorkOrderDelete];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark --- 网络请求
//获取全部的订单
- (void)netWorkOrderGetList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_Order_order_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setValue:@"10" forKey:@"count"];
    [mutabDict setValue:@"course" forKey:@"type"];
    [mutabDict setValue:@"0" forKey:@"pay_status"];
    
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
        }
//        if (Num == 1) {
//            _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
//        } else {
//            [_dataArray addObjectsFromArray:(NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
//        }
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


#pragma mark --- 添加视图
- (void)whichPayView {
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds =YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    _allWindowView = allWindowView;
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    
    UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(0,MainScreenHeight - 250 * WideEachUnit, MainScreenWidth, 250 * WideEachUnit)];
    buyView.backgroundColor = [UIColor whiteColor];
    [allWindowView addSubview:buyView];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth - 10 * WideEachUnit, 50 * WideEachUnit)];
    title.text = @"请选择支付方式";
    title.textColor = BlackNotColor;
    title.backgroundColor = [UIColor whiteColor];
    title.font = Font(16);
    [buyView addSubview:title];
    
    NSArray *imageArray = @[@"Alipay@3x",@"weixinpay@3x",@""];
    CGFloat viewW = MainScreenWidth;
    CGFloat viewH = 50 * WideEachUnit;
    
    for (int i = 0 ; i < 3 ; i ++) {
        
        UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, 50 * WideEachUnit + i * viewH  , viewW, viewH)];
        payView.backgroundColor = [UIColor whiteColor];
        payView.layer.borderWidth = 0.5 * WideEachUnit;
        payView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [buyView addSubview:payView];
        
        
        UIButton *payTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit,0, 80 * WideEachUnit, 50 * WideEachUnit)];
        [payTypeButton setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        [payView addSubview:payTypeButton];
        
        if (i == 2) {
            //            [payTypeButton setTitle:@"余额" forState:UIControlStateNormal];
            payTypeButton.hidden = YES;
            UILabel *payType = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, 250 * WideEachUnit, 50 * WideEachUnit)];
            payType.text = @"育币";
            payType.textColor = [UIColor colorWithHexString:@"#888"];
            [payView addSubview:payType];
            payType.font = Font(14);
            payType.text = [NSString stringWithFormat:@"育币 (当前账号育币为%@)",[_userAccountDict stringValueForKey:@"learn" defaultValue:@"0"]];
                            
        }
        
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = i;
        if (i == 0) {
            _aliSeleButton = seleButton;
            _aliSeleButton.selected = YES;
        } else if (i == 1) {
            _wxSeleButton = seleButton;
            _wxSeleButton.selected = NO;
        } else if (i == 2) {
            _balanceSeleButton = seleButton;
            _balanceSeleButton.selected = NO;
        }
        //        _wxSeleButton = seleButton;
        //        _wxSeleButton.selected = NO;
        
        //        if (_alipayView.frame.size.height == 0) {//说明没有支付宝支付
        //            [self seleButtonCilck:seleButton];
        //        }
        
        [payView addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = i;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [payView addSubview:allClearButton];
        
    }
    
    
    //添加价格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, 201 * WideEachUnit, MainScreenWidth / 2, 48 *WideEachUnit)];
    price.text = @"实付：100";
    [buyView addSubview:price];
    price.textAlignment = NSTextAlignmentCenter;
    price.textColor = [UIColor colorWithHexString:@"#888"];
    price.textColor = [UIColor orangeColor];
    price.text = [NSString stringWithFormat:@"实付：育币%@",[_orderDict stringValueForKey:@"price"]];
    
    //添加按钮
    UIButton *nowPayButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, 200 * WideEachUnit, MainScreenWidth / 2, 50 * WideEachUnit)];
    nowPayButton.backgroundColor = BasidColor;
    [nowPayButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [nowPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyView addSubview:nowPayButton];
    [nowPayButton addTarget:self action:@selector(nowPayButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --- 添加跳转识图
- (void)addWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    url = [NSURL URLWithString:_alipayStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    if ([url containsString:@"alipay://alipayclient"]) {
        NSMutableString *param = [NSMutableString stringWithFormat:@"%@", (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)url, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))];
        
        NSRange range = [param rangeOfString:@"{"];
        // 截取 json 部分
        NSString *param1 = [param substringFromIndex:range.location];
        if ([param1 rangeOfString:@"\"fromAppUrlScheme\":"].length > 0) {
            NSData *data = [param1 dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (![tempDic isKindOfClass:[NSDictionary class]]) {
                return NO;
            }
            
            NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:tempDic];
            dicM[@"fromAppUrlScheme"] = AlipayBundleId;
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicM options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSString *encodedString = (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,                           (CFStringRef)jsonStr, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
            
            // 只替换 json 部分
            [param replaceCharactersInRange:NSMakeRange(range.location, param.length - range.location)  withString:encodedString];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:param]];
            
            return NO;
        }
    }
    return NO;
}

//取消订单
- (void)netWorkOrderCancel {
    
    NSString *endUrlStr = YunKeTang_Order_order_cancel;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_orderDict[@"order_id"] forKey:@"order_id"];
    [mutabDict setValue:_orderDict[@"order_type"] forKey:@"order_type"];
    
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
        NSDictionary *cancelDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[cancelDict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:@"取消成功" toView:[UIApplication sharedApplication].keyWindow];
            [self netWorkOrderGetList:_number];
        } else {
            [TKProgressHUD showSuccess:[cancelDict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//删除订单
- (void)netWorkOrderDelete {
    
    NSString *endUrlStr = YunKeTang_Order_order_delete;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_orderDict[@"order_id"] forKey:@"order_id"];
    [mutabDict setValue:_orderDict[@"order_type"] forKey:@"order_type"];
    
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
        NSDictionary *cancelDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        
        if ([[cancelDict stringValueForKey:@"staust"] integerValue] == 1) {
            [TKProgressHUD showError:@"取消成功" toView:[UIApplication sharedApplication].keyWindow];
            [self netWorkOrderGetList:_number];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取用户的流水数据
- (void)netWorkUserGetAccount {
    
    NSString *endUrlStr = YunKeTang_User_user_getAccount;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"new" forKey:@"time"];
    
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
        _userAccountDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        [self whichPayView];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//解锁课程
- (void)netWorkCourseCourseBuyVideo {

    NSString *endUrlStr = YunKeTang_Course_Course_buyVideo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];

    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];

    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:[[_orderDict dictionaryValueForKey:@"source_info"] stringValueForKey:@"id"] forKey:@"vids"];
    if ([[_orderDict stringValueForKey:@"coupon_id"] integerValue] != 0) {
        [mutabDict setValue:[_orderDict stringValueForKey:@"coupon_id"] forKey:@"coupon_id"];
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [_allWindowView removeFromSuperview];
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                [self netWorkOrderGetList:1];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//解锁直播
- (void)netWorkCourseCourseBuyLive {

    NSString *endUrlStr = YunKeTang_Course_Course_buyLive;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];

    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];

    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:[[_orderDict dictionaryValueForKey:@"source_info"] stringValueForKey:@"id"] forKey:@"live_id"];
    if ([[_orderDict stringValueForKey:@"coupon_id"] integerValue] != 0) {
        [mutabDict setValue:[_orderDict stringValueForKey:@"coupon_id"] forKey:@"coupon_id"];
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [_allWindowView removeFromSuperview];
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                [self netWorkOrderGetList:1];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [_allWindowView removeFromSuperview];
        [self netWorkOrderGetList:_number];
    }];
    [op start];
}



//解锁线下课
- (void)netWorkCourseCourseBuyLineCourse {

    NSString *endUrlStr = YunKeTang_Course_Course_buyLineCourse;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];

    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];

    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:[[_orderDict dictionaryValueForKey:@"line_class"] stringValueForKey:@"course_id"] forKey:@"vids"];
    if ([[_orderDict stringValueForKey:@"coupon_id"] integerValue] != 0) {
        [mutabDict setValue:[_orderDict stringValueForKey:@"coupon_id"] forKey:@"coupon_id"];
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                BOOL ali = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_alipayStr]];
                if (ali) {
                    [self addWebView];
                } else {
                    [TKProgressHUD showError:@"未检测到支付宝" toView:self.view];
                    return ;
                }
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [_allWindowView removeFromSuperview];
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                [self netWorkOrderGetList:1];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//继续支付
- (void)netWorkOrderOrderPay {
    
    NSString *endUrlStr = YunKeTang_Order_order_pay;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
//    if ([_payTypeStr integerValue] == 1) {
//        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
//    } else if ([_payTypeStr integerValue] == 2) {
//        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
//    } else if ([_payTypeStr integerValue] == 3) {
//        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
//    }
    
    [mutabDict setValue:_orderDict[@"order_id"] forKey:@"order_id"];
    [mutabDict setValue:_orderDict[@"order_type"] forKey:@"order_type"];//类型
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [_allWindowView removeFromSuperview];
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
                [self netWorkOrderGetList:1];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
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



#pragma mark --- 微信支付

- (void)WXPay:(NSDictionary *)dict {
    NSString * timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSLog(@"=====%@",timeString);
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [_wxPayDict stringValueForKey:@"partnerid"];
    request.prepayId= [_wxPayDict stringValueForKey:@"prepayid"];
    request.package = [_wxPayDict stringValueForKey:@"package"];
    request.nonceStr= [_wxPayDict stringValueForKey:@"noncestr"];
    request.timeStamp= [_wxPayDict stringValueForKey:@"timestamp"].intValue;
    request.sign= [_wxPayDict stringValueForKey:@"sign"];
    [WXApi sendReq:request];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}


@end
