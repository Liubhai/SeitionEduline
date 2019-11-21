//
//  OfflineMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "OfflineMainViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BigWindCar.h"

#import "OfflineClassTypeViewController.h"
#import "OfflineSchoolViewController.h"
#import "OfflineMoreViewController.h"
#import "OfflineMainTableViewCell.h"
#import "OfflineDetailViewController.h"

#import "MessageSendViewController.h"
#import "DLViewController.h"


@interface OfflineMainViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    NSInteger Num;
    BOOL isClass;
    BOOL isSchool;
    BOOL isMore;
}


@property (strong ,nonatomic)NSMutableArray   *dataArray;
@property (strong ,nonatomic)UIView           *headerView;
@property (strong ,nonatomic)UIButton         *classButton;
@property (strong ,nonatomic)UIButton         *schoolButton;
@property (strong ,nonatomic)UIButton         *moreButton;
@property (strong ,nonatomic)UIImageView      *imageView;
@property (strong ,nonatomic)UITableView      *tableView;

@property (strong ,nonatomic)NSString         *typeID;
@property (strong ,nonatomic)NSString         *teacherID;
@property (strong ,nonatomic)NSString         *moreTypeID;
@property (strong ,nonatomic)NSString         *moreRankID;
@property (strong ,nonatomic)NSString         *timeStr;
@property (assign ,nonatomic)NSInteger        typeNum;

@property (strong ,nonatomic)NSString         *alipayStr;
@property (strong ,nonatomic)NSString         *wxpayStr;
@property (strong ,nonatomic)UIWebView        *webView;

@property (strong ,nonatomic)NSString         *ID;

@end

@implementation OfflineMainViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 45*HigtEachUnit, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45*HigtEachUnit)];
        _imageView.image = Image(@"云课堂_空数据.png");
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
    [self interFace];
    [self addNav];
    [self addHeaderView];
    [self addTableView];
    [self netWorkLineVideoGetList:1];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dataArray = [NSMutableArray array];
    
    isClass = NO;
    isSchool = NO;
    isMore = NO;
    Num = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassTypeID:) name:@"NSNotificationOfflineClassTypeID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTeacherID:) name:@"NSNotificationOfflineTeacherID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoreID:) name:@"NSNotificationOfflineMoreTypeID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classButtonType:) name:@"NSNotificationOfflineClassTypeButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teacherButtonType:) name:@"NSNotificationOfflineTeacherButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreButtonType:) name:@"NSNotificationOfflineMoreButton" object:nil];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    WZLabel.text = @"线下课程";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        
    }
    
}

- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, MainScreenWidth, 45 * WideEachUnit)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    
    NSArray *titleArray = @[@"分类",@"校区",@"筛选条件"];
    NSArray *imageArray = @[@"ic_dropdown_live@3x",@"ic_dropdown_live@3x",@"ic_dropdown_live@3x"];
    if (([MoreOrSingle integerValue] == 1)) {
        titleArray = @[@"分类",@"筛选条件"];
        imageArray = @[@"ic_dropdown_live@3x",@"ic_dropdown_live@3x"];
    }
    CGFloat ButtonH = 45 * WideEachUnit;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonH)];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        button.titleLabel.font = Font(16);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self dealButtonImageAndTitleUI:button];
        [_headerView addSubview:button];
        if (i == 0) {
            _classButton = button;
            [button addTarget:self action:@selector(classButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) {
            if ([MoreOrSingle integerValue] == 1) {
                _moreButton = button;
                [button addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                _schoolButton = button;
                [button addTarget:self action:@selector(teacherButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
            }
        } else if (i == 2) {
            _moreButton = button;
            [button addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * WideEachUnit, MainScreenWidth, 1 * WideEachUnit)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_headerView addSubview:lineButton];
}


- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88 + 45, MainScreenWidth, MainScreenHeight - 88 - 45);
    }
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.rowHeight = 120 * WideEachUnit;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- 刷新

- (void)headerRerefreshing {
    Num = 1;
    [self netWorkLineVideoGetList:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing {
    Num ++;
    [self netWorkLineVideoGetList:Num];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
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
    static NSString *CellIdentifier = nil;
    CellIdentifier = [NSString stringWithFormat:@"cell - %ld",indexPath.row];
    //自定义cell类
    OfflineMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //自定义cell类
    if (cell == nil) {
        cell = [[OfflineMainTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict];
    
    [cell.onlineButton addTarget:self action:@selector(onlineButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [cell.orderButton addTarget:self action:@selector(orderButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    cell.onlineButton.tag = indexPath.row;
    cell.orderButton.tag = indexPath.row;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    OfflineDetailViewController *vc = [[OfflineDetailViewController alloc] init];
    vc.ID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"course_id"];
    vc.imageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
    vc.titleStr = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"course_name"];
    vc.orderSwitch = _orderSwitch;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)classButtonCilck:(UIButton *)button {
    [_classButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    
    [_schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isClass = !isClass;
    
    if (isClass) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OfflineClassTeacherRemove" object:@"remove"];
        [_schoolButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isSchool = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OfflineClassMoreRemove" object:@"remove"];
        [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isMore = NO;
        
        OfflineClassTypeViewController *vc = [[OfflineClassTypeViewController alloc] init];
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45 * WideEachUnit, MainScreenWidth , MainScreenHeight - MACRO_UI_UPHEIGHT - 45 * WideEachUnit);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        //传通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OfflineClassTypeRemove" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
    
    
}

- (void)teacherButtonCilck:(UIButton *)button {
    
    [_schoolButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_schoolButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    
    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isSchool = !isSchool;
    
    if (isSchool) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OfflineClassTypeRemove" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClass = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OfflineClassMoreRemove" object:@"remove"];
        [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isMore = NO;
        
        OfflineSchoolViewController *vc = [[OfflineSchoolViewController alloc] init];
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45 * WideEachUnit, MainScreenWidth , MainScreenHeight - MACRO_UI_UPHEIGHT - 45 * WideEachUnit);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OfflineClassTeacherRemove" object:@"remove"];
        [_schoolButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
    
    
}

- (void)moreButtonCilck:(UIButton *)button {
    [_moreButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_moreButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    
    [_schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isMore = !isMore;
    
    if (isMore) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OfflineClassTypeRemove" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClass = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OfflineClassTeacherRemove" object:@"remove"];
        [_schoolButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isSchool = NO;
        
        NSLog(@"----%@",_moreTypeID);
        OfflineMoreViewController *vc = [[OfflineMoreViewController alloc] initWithTypeStr:_moreTypeID withMoreStr:_moreRankID];
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45 * WideEachUnit, MainScreenWidth , MainScreenHeight - MACRO_UI_UPHEIGHT - 45 * WideEachUnit);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OfflineClassMoreRemove" object:@"remove"];
        [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
}

- (void)onlineButtonCilck:(UIButton *)button {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    NSDictionary *dict = _dataArray[button.tag];
    
    MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
    MSVC.TID = [dict stringValueForKey:@"teacher_id"];
    MSVC.name = [dict stringValueForKey:@"teacher_name"];
    [self.navigationController pushViewController:MSVC animated:YES];
}

- (void)orderButtonCilck:(UIButton *)button {
    NSDictionary *dict = _dataArray[button.tag];
    _ID = [dict stringValueForKey:@"course_id"];
    if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {
        [TKProgressHUD showError:@"已经解锁" toView:self.view];
        return;
    } else {
        [self whichPay];
    }

}

#pragma mark --- 通知
- (void)getClassTypeID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _typeID = dict[@"id"];
    NSString *title = dict[@"title"];
    if (title.length>6) {
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:4]];
    }
    [_classButton setTitle:title forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClass = NO;
    [self dealButtonImageAndTitleUI:_classButton];
    [self netWorkLineVideoGetList:1];
}

- (void)getTeacherID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _teacherID = dict[@"id"];
    NSString *title = dict[@"title"];
    if (title.length>6) {
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:4]];
    }
    [_schoolButton setTitle:title forState:UIControlStateNormal];
    [_schoolButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isSchool = NO;
    [self dealButtonImageAndTitleUI:_schoolButton];
    [self netWorkLineVideoGetList:1];
}

- (void)getMoreID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _moreTypeID = dict[@"typeStr"];
    _moreRankID = dict[@"rankStr"];
    [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isMore = NO;
    [self netWorkLineVideoGetList:1];
}

- (void)classButtonType:(NSNotification *)not {
    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClass = NO;
}

- (void)teacherButtonType:(NSNotification *)not {
    [_schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_schoolButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isSchool = NO;
}

- (void)moreButtonType:(NSNotification *)not {
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isMore = NO;
}

#pragma mark --- 网络请求
//线下课列表数据
- (void)netWorkLineVideoGetList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"10" forKey:@"count"];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    
    
    if (_typeID) {
        [mutabDict setObject:_typeID forKey:@"cateId"];
    }
    if (_teacherID) {//校区
        [mutabDict setObject:_teacherID forKey:@"school_id"];
    }
    if (_moreTypeID) {
        [mutabDict setObject:_moreTypeID forKey:@"status"];
    }
    if (_moreRankID) {//排序
        [mutabDict setObject:_moreRankID forKey:@"orderBy"];
    }
    if (_timeStr) {//时间
        [mutabDict setObject:_timeStr forKey:@"time"];
    }
    
//    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
//            _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if (Num == 1) {
                if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    _dataArray = (NSMutableArray *) [dict arrayValueForKey:@"data"];
                } else {
                    _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                }
            } else {
                if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                   NSMutableArray *array = (NSMutableArray *)[dict arrayValueForKey:@"data"];
                    [_dataArray addObject:array];
                } else {
                    NSMutableArray *array = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                    [_dataArray addObjectsFromArray:array];
                }
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
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



#pragma mark --- 支付

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

#pragma mark --- 添加跳转识图
- (void)addWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate = self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    if (_typeNum == 1) {
        if (_alipayStr == nil) {
            [TKProgressHUD showError:@"支付失败" toView:self.view];
        } else {
            url = [NSURL URLWithString:_alipayStr];
        }
        
    } else if (_typeNum == 2) {
        if (_wxpayStr == nil) {
            [TKProgressHUD showError:@"支付失败" toView:self.view];
        } else {
            url = [NSURL URLWithString:_wxpayStr];
        }
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)dealButtonImageAndTitleUI:(UIButton *)sender {
    CGFloat labelWidth = [sender.titleLabel.text sizeWithFont:sender.titleLabel.font].width;
    if (labelWidth>(sender.size.width - sender.currentImage.size.width)) {
        labelWidth = 71.5 * WideEachUnit;
    }
    [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -sender.currentImage.size.width, 0, sender.currentImage.size.width)];
    [sender setImageEdgeInsets:UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth)];
}

@end
