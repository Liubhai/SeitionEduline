//
//  NoPayVC.m
//  dafengche
//
//  Created by 赛新科技 on 2017/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "NoPayVC.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "TKProgressHUD+Add.h"

#import "InstitutionListCell.h"
#import "OrderCell.h"
#import "InstitutionMainViewController.h"

#import "ZhiBoMainViewController.h"
#import "Good_ClassMainViewController.h"
#import "OfflineDetailViewController.h"
#import "DLViewController.h"
#import "ClassDetailViewController.h"


@interface NoPayVC ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (strong ,nonatomic)NSString *pay_status;//标示符

@property (strong ,nonatomic)NSString *alipayStr;
@property (strong ,nonatomic)NSString *wxpayStr;
@property (strong ,nonatomic)NSDictionary *wxPayDict;
@property (strong ,nonatomic)UIWebView *webView;
@property (assign ,nonatomic)NSInteger typeNum;

@property (assign ,nonatomic)NSInteger number;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)UIView     *allView;
@property (strong ,nonatomic)UIButton   *allButton;
@property (strong ,nonatomic)UIView     *buyView;
@property (strong ,nonatomic)NSDictionary *userAccountDict;

@property (strong ,nonatomic)UIView     *allWindowView;
@property (strong ,nonatomic)UIButton   *aliSeleButton;
@property (strong ,nonatomic)UIButton   *wxSeleButton;
@property (strong ,nonatomic)UIButton   *balanceSeleButton;
@property (strong ,nonatomic)NSString   *classTypeStr;
@property (strong ,nonatomic)NSString   *payTypeStr;//支付类型的字段

@property (strong ,nonatomic)NSString   *order_switch;
//标识退款的字段
@property (strong ,nonatomic)NSString   *refundConfStr;


@property (strong, nonatomic) NSMutableArray *payTypeArray;


@end

@implementation NoPayVC

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
    _payTypeArray = [NSMutableArray new];
    [self interFace];
    [self addTableView];
//    [self NetWorkGetOrderWithNumber:1];
    [self netWorkUserBalanceConfig];
    [self netWorkUserGetAccount];
    [self netWorkOrderGetList:1];
    [self netWorkConfigGetMarketStatus];
    [self netWorkOrderRefundConf];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor blueColor];
    _number = 1;
    _payTypeStr = @"3";
    _isInst = @"order";
    _classTypeStr = @"4";//默认为点播
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassType:) name:@"My_Order_ClassType" object:nil];
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

- (void)footerRefreshing
{
    _number++;
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
    
    NSLog(@"----%@",_dataArray);
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict WithType:_isInst];
    
//    [cell.schoolButton addTarget:self action:@selector(schoolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.schoolButton.tag = indexPath.row;
    cell.actionButton.tag = indexPath.row;
    cell.cancelButton.tag = indexPath.row;
    
    //退款配置
    if ([_refundConfStr integerValue] == 0) {//不能退款
        if ([cell.actionButton.titleLabel.text isEqualToString:@"申请退款"]) {
            cell.actionButton.hidden = YES;
        }
    }
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    
    [cell addGestureRecognizer:longPressGr];
    cell.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"---%@",_dataArray[indexPath.row]);
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
        
        NSString *ID = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_id"]];
        if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 7) {
            ID = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"classes_id"]];
        }
        NSString *price = _dataArray[indexPath.row][@"price"];
        NSString *title = _dataArray[indexPath.row][@"video_name"];
        NSString *videoUrl = _dataArray[indexPath.row][@"source_info"][@"video_address"];
        NSString *imageUrl = _dataArray[indexPath.row][@"cover"];
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = ID;
        vc.price = price;
        vc.videoTitle = title;
        vc.videoUrl = videoUrl;
        vc.imageUrl = imageUrl;
        vc.orderSwitch = _order_switch;
        vc.isClassNew = ([_dataArray[indexPath.row][@"order_type"] integerValue] == 7 ? YES : NO);
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 5) {
        OfflineDetailViewController *vc = [[OfflineDetailViewController alloc] init];
        vc.ID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_id"];
        vc.imageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"cover"];
        vc.titleStr = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_name"];
        vc.orderSwitch = _order_switch;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 3){//直播
        NSString *Cid = nil;
        Cid = _dataArray[indexPath.row][@"live_id"];
        NSString *Price = _dataArray[indexPath.row][@"price"];
        NSString *Title = _dataArray[indexPath.row][@"video_name"];
        NSString *ImageUrl = _dataArray[indexPath.row][@"cover"];
        
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
    [self isSureDelete];
}

- (void)allWindowViewClick:(UITapGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

#pragma mark --- 通知
- (void)getClassType:(NSNotification *)not {
    _classTypeStr = (NSString *)not.object;
    if ([_classTypeStr integerValue] == 0) {//点播
        _classTypeStr = @"4";
    } else if ([_classTypeStr integerValue] == 1) {//直播
        _classTypeStr = @"3";
    } else if ([_classTypeStr integerValue] == 2) {//线下课
        _classTypeStr = @"5";
    } else if ([_classTypeStr integerValue] == 3) {
        // 考试订单
        _classTypeStr = @"6";
    } else if ([_classTypeStr integerValue] == 4) {
        _classTypeStr = @"2";
    } else if ([_classTypeStr integerValue] == 5) {
        // 班级课
        _classTypeStr = @"7";
    }
    [self netWorkOrderGetList:1];
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
    
    NSLog(@"%@",_orderDict);
    NSString *title = button.titleLabel.text;
    
    if ([title isEqualToString:@"去支付"]) {
//        [self whichPay];
        [self whichPayView];
        
    } else if ([title isEqualToString:@"申请退款"]) {
        if ([[[_dataArray objectAtIndex:index] stringValueForKey:@"order_type"] integerValue] == 5) {//线下课
            [TKProgressHUD showError:@"线下课暂不支持申请退款" toView:self.view];
            return;
        } else {
            [self isSureRefund];
        }
    } else if ([title isEqualToString:@"退款中"]) {
    } else if ([title isEqualToString:@"退款查看"]) {
    }
}

- (void)cancelButtonClick:(UIButton *)button {
    NSInteger index = button.tag;
    _orderDict = _dataArray[index];
     [self isSureCanleOrder];
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
        if ([[_orderDict stringValueForKey:@"course_hour_id"] integerValue] != 0) {//课时解锁
            [self netWorkCourseBuyCourseHourById];
        } else {
            [self netWorkCourseCourseBuyVideo];
        }
    } else if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 3) {//直播
        if ([[_orderDict stringValueForKey:@"course_hour_id"] integerValue] != 0) {//课时解锁
            [self netWorkCourseBuyCourseHourById];
        } else {
            [self netWorkCourseCourseBuyLive];
        }
    } else if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 5) {//线下课
        [self netWorkCourseCourseBuyLineCourse];
    } else if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 6) {
        // 考试付费
        [self netWorkGoodsBuyGoods];
    } else if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 2) {
        // 套餐解锁
        [self payForCombo];
    } else if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 7) {
        // 班级课解锁
        //班级购买
        if ([[_orderDict stringValueForKey:@"course_hour_id"] integerValue] != 0) {//单课时解锁
            [self netWorkCourseBuyCourseHourById];
        } else {
            [self classBuy];
        }
    }
}

//是否 真要取消订单
- (void)isSureCanleOrder {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确定要取消该订单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self netWorkOrderCancel];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//是否 真要删除小组
- (void)isSureRefund {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否要要申请退款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark --- 删除订单
- (void)isSureDelete {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否要要申请退款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
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
    
    NSString *endUrlStr = YunKeTang_Order_order_getCourseOrderList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",(long)Num] forKey:@"page"];
    [mutabDict setValue:@"10" forKey:@"count"];
    [mutabDict setValue:_classTypeStr forKey:@"order_type"];
    [mutabDict setValue:@"1" forKey:@"pay_status"];
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

//是否 真要删除小组
- (void)whichPay {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择支付方式" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *aliAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        _typeNum = 1;
    }];
    [alertController addAction:aliAction];
    
    UIAlertAction *wxAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        _typeNum = 2;
    }];
    [alertController addAction:wxAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)whichPayView {
    if (_allWindowView == nil) {
        _allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
        _allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        _allWindowView.layer.masksToBounds =YES;
        [_allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    }
    [_allWindowView removeAllSubviews];
    if (_allWindowView.superview == nil) {
        //获取当前UIWindow 并添加一个视图
        UIApplication *app = [UIApplication sharedApplication];
        [app.keyWindow addSubview:_allWindowView];
    }
    
    
     // 还要把 _payTypeStr 初始化 1;
    UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(0,MainScreenHeight - 250 * WideEachUnit, MainScreenWidth, 250 * WideEachUnit)];
    buyView.backgroundColor = [UIColor whiteColor];
    [_allWindowView addSubview:buyView];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth - 10 * WideEachUnit, 50 * WideEachUnit)];
    title.text = @"请选择支付方式";
    title.textColor = BlackNotColor;
    title.backgroundColor = [UIColor whiteColor];
    title.font = Font(16);
    [buyView addSubview:title];
    
    NSArray *imageArray = @[@"Alipay@3x",@"weixinpay@3x",@""];
    //判断是否应该有此支付方式
    BOOL isAddAilpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"alipay"]) {
            isAddAilpayView = YES;
        }
    }
    //判断是否应该有此支付方式
    BOOL isAddWxpayView = NO;
    for (NSString *payStr in _payTypeArray) {
        if ([payStr isEqualToString:@"wxpay"]) {
            isAddWxpayView = YES;
        }
    }
    CGFloat viewW = MainScreenWidth;
    CGFloat viewH = 50 * WideEachUnit;
    CGFloat ButtonTop = 50 * WideEachUnit;
    for (int i = 0 ; i < 3 ; i ++) {
        UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, ButtonTop  , viewW, viewH)];
        payView.backgroundColor = [UIColor whiteColor];
        payView.layer.borderWidth = 0.5 * WideEachUnit;
        payView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [buyView addSubview:payView];
        if (i == 0) {
            if (isAddAilpayView) {
                [payView setHeight:viewH];
                payView.hidden = NO;
            } else {
                [payView setHeight:0];
                payView.hidden = NO;
            }
        }
        if (i == 1) {
            if (isAddWxpayView) {
                [payView setHeight:viewH];
                payView.hidden = NO;
            } else {
                [payView setHeight:0];
                payView.hidden = NO;
            }
        }
        
        UIButton *payTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit,0, 80 * WideEachUnit, 50 * WideEachUnit)];
        [payTypeButton setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        [payView addSubview:payTypeButton];
        
        if (i == 2) {
            payTypeButton.hidden = YES;
            UILabel *payType = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, 250 * WideEachUnit, 50 * WideEachUnit)];
            payType.text = @"余额";
            payType.textColor = [UIColor colorWithHexString:@"#888"];
            [payView addSubview:payType];
            payType.font = Font(14);
            payType.text = [NSString stringWithFormat:@"余额 (当前育币%@)",[_userAccountDict stringValueForKey:@"learn" defaultValue:@"0"]];
        }
        
        UIButton *seleButton = [[UIButton alloc] initWithFrame:CGRectMake(viewW - 30 * WideEachUnit,(50-20)/2.0, 20 * WideEachUnit, 20 * WideEachUnit)];
        [seleButton setImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
        [seleButton setImage:Image(@"ic_choose@3x") forState:UIControlStateSelected];
        [seleButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        seleButton.tag = i;
        if (i == 0) {
            _aliSeleButton = seleButton;
            if (isAddAilpayView) {
                _aliSeleButton.selected = YES;
                [self seleButtonCilck:_aliSeleButton];
            } else {
                _aliSeleButton.selected = NO;
            }
        } else if (i == 1) {
            _wxSeleButton = seleButton;
            if (isAddWxpayView && !isAddAilpayView) {
                _wxSeleButton.selected = YES;
                [self seleButtonCilck:_wxSeleButton];
            } else {
                _wxSeleButton.selected = NO;
            }
        } else if (i == 2) {
            _balanceSeleButton = seleButton;
            if (!isAddAilpayView && !isAddWxpayView) {
                _balanceSeleButton.selected = YES;
                [self seleButtonCilck:_balanceSeleButton];
            } else {
                _balanceSeleButton.selected = NO;
            }
        }
        
        [payView addSubview:seleButton];
        
        UIButton *allClearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        allClearButton.backgroundColor = [UIColor clearColor];
        allClearButton.tag = i;
        [allClearButton addTarget:self action:@selector(seleButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [payView addSubview:allClearButton];
        
        ButtonTop = ButtonTop + payView.height;
    }
    
    
    //添加价格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, ButtonTop, MainScreenWidth / 2, 50 *WideEachUnit)];
    price.text = @"实付：100";
    [buyView addSubview:price];
    price.textAlignment = NSTextAlignmentCenter;
    price.textColor = [UIColor colorWithHexString:@"#888"];
    price.textColor = [UIColor orangeColor];
    price.text = [NSString stringWithFormat:@"实付：育币%@",[_orderDict stringValueForKey:@"price"]];
    
    //添加按钮
    UIButton *nowPayButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, ButtonTop, MainScreenWidth / 2, 50 * WideEachUnit)];
    nowPayButton.backgroundColor = BasidColor;
    [nowPayButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [nowPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyView addSubview:nowPayButton];
    [nowPayButton addTarget:self action:@selector(nowPayButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [buyView setHeight:nowPayButton.bottom];
    [buyView setTop:_allWindowView.height - buyView.height];
}


#pragma mark -- 添加视图

- (void)addMoreView {
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.8];
    [window addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];

    [_allView addSubview:_allButton];
    [UIView animateWithDuration:0.25 animations:^{
        
    }];
}

- (void)miss {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
    });
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
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [self netWorkUserGetAccount];
    }];
    [op start];
}

//取消订单
- (void)netWorkOrderCancel {
    
    NSString *endUrlStr = YunKeTang_Order_order_cancel;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_orderDict[@"id"] forKey:@"order_id"];
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
            [TKProgressHUD showSuccess:[cancelDict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
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
    if ([[_orderDict objectForKey:@"asb_id"] isKindOfClass:[NSString class]]) {
        [mutabDict setObject:[_orderDict objectForKey:@"asb_id"] forKey:@"asb"];
    }
    [mutabDict setValue:[_orderDict stringValueForKey:@"video_id"] forKey:@"vids"];
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
        } else {
            [_allWindowView removeFromSuperview];
            [TKProgressHUD showError:[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject] objectForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//解锁课程
- (void)netWorkCourseBuyCourseHourById {
    
    NSString *endUrlStr = YunKeTang_Course_Course_buyCourseHourById;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:[_orderDict stringValueForKey:@"course_hour_id"] forKey:@"sid"];
    if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 4) {//课程
        [mutabDict setValue:@"1" forKey:@"vtype"];
        [mutabDict setValue:[_orderDict stringValueForKey:@"video_id"] forKey:@"vid"];
    } else if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 3) {//直播
        [mutabDict setValue:@"2" forKey:@"vtype"];
        [mutabDict setValue:[_orderDict stringValueForKey:@"live_id"] forKey:@"vid"];
    }
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
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        [_allWindowView removeFromSuperview];
        [self netWorkOrderGetList:_number];
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
    if ([[_orderDict objectForKey:@"asb_id"] isKindOfClass:[NSString class]]) {
        [mutabDict setObject:[_orderDict objectForKey:@"asb_id"] forKey:@"asb"];
    }
    [mutabDict setValue:[_orderDict stringValueForKey:@"live_id"] forKey:@"live_id"];
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
        NSLog(@"----%@",dict);
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            NSDictionary *balanceDict = dict;
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_payTypeStr integerValue] == 1) {//支付宝
                _alipayStr = [[dict dictionaryValueForKey:@"alipay"] stringValueForKey:@"ios"];
                [self addWebView];
            } else if ([_payTypeStr integerValue] == 2){//微信
                _wxPayDict = [[dict dictionaryValueForKey:@"wxpay"] dictionaryValueForKey:@"ios"];
                [self WXPay:_wxPayDict];
            } else if ([_payTypeStr integerValue] == 3) {//余额
                [_allWindowView removeFromSuperview];
                [TKProgressHUD showError:[balanceDict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
                [self netWorkOrderGetList:_number];
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
    [mutabDict setValue:[_orderDict stringValueForKey:@"video_id"] forKey:@"vids"];
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
                [self netWorkOrderGetList:_number];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [_allWindowView removeFromSuperview];
        [TKProgressHUD showError:@"解锁失败" toView:[UIApplication sharedApplication].keyWindow];
        [self netWorkOrderGetList:_number];
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


//获取申请退款的配置
- (void)netWorkOrderRefundConf {
    
    NSString *endUrlStr = YunKeTang_Order_order_refundConf;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
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
            _refundConfStr = [dict stringValueForKey:@"refund_switch"];
        }
        [_tableView reloadData];
        
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
    request.timeStamp= timeString.intValue;
    request.timeStamp= [_wxPayDict stringValueForKey:@"timestamp"].intValue;
    request.sign= [_wxPayDict stringValueForKey:@"sign"];
    [WXApi sendReq:request];
}

//获取余额各种数据以及配置
- (void)netWorkUserBalanceConfig {
    
    NSString *endUrlStr = YunKeTang_User_user_balanceConfig;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1"forKey:@"tab"];
    [mutabDict setObject:@"50"forKey:@"limit"];
    
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
        if ([[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject] objectForKey:@"code"] integerValue] == 1) {
            if (SWNOTEmptyDictionary([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject])) {
                [_payTypeArray addObjectsFromArray:[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject] arrayValueForKey:@"pay"]];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [self netWorkUserBalanceConfig];
    }];
    [op start];
}

//考试付费
- (void)netWorkGoodsBuyGoods {
    NSString *endUrlStr = BUYEXAMS;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_orderDict stringValueForKey:@"paper_id"] forKey:@"paper_id"];
    if ([_payTypeStr integerValue] == 1) {//支付宝
        [mutabDict setObject:@"alipay" forKey:@"pay"];
    } else if ([_payTypeStr integerValue] == 2) {//微信
        [mutabDict setObject:@"wxpay" forKey:@"pay"];
    } else if ([_payTypeStr integerValue] == 3) {//微信
        [mutabDict setObject:@"lcnpay" forKey:@"pay"];
    }
    
    NSString *oath_token_Str = nil;
    oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    
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
            } else if ([_payTypeStr integerValue] == 3) {
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
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

// MARK: - 解锁套餐
//解锁课程
- (void)payForCombo {
    
    NSString *endUrlStr = Pay_Combo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:[_orderDict stringValueForKey:@"album_id"] forKey:@"album_id"];
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
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        [_allWindowView removeFromSuperview];
        [self netWorkOrderGetList:_number];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)classBuy {
    NSString *endUrlStr = course_buyClasses;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([_payTypeStr integerValue] == 1) {
        [mutabDict setValue:@"alipay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 2) {
        [mutabDict setValue:@"wxpay" forKey:@"pay_for"];
    } else if ([_payTypeStr integerValue] == 3) {
        [mutabDict setValue:@"lcnpay" forKey:@"pay_for"];
    }
    [mutabDict setValue:[_orderDict stringValueForKey:@"classes_id"] forKey:@"vids"];
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
                [TKProgressHUD showError:@"解锁成功" toView:[UIApplication sharedApplication].keyWindow];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        [_allWindowView removeFromSuperview];
        [self netWorkOrderGetList:_number];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

@end
