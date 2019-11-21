//
//  Good_LibraryViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/9.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_LibraryViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "BigWindCar.h"
#import "MyHttpRequest.h"
#import "TKProgressHUD+Add.h"
#import "MJRefresh.h"
#import "DLViewController.h"

#import "LibraryCell.h"

#import "ZFDownloadManager.h"
#import "GLNetWorking.h"

//优化
#import "Good_LibraryRankViewController.h"
#import "Good_LibraryClassViewController.h"
#import "Good_LibraryScreenViewController.h"


@interface Good_LibraryViewController ()<UITableViewDataSource,UITableViewDelegate> {
    BOOL isRank;
    BOOL isClass;
    BOOL isScreen;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSString *downUrl;
@property (strong ,nonatomic)NSString *downName;
@property (assign ,nonatomic)NSInteger num;
@property (strong ,nonatomic)NSString *docID;
@property (strong ,nonatomic)NSString *downExtension;
@property (strong ,nonatomic)UIView   *headerView;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)UIButton *rankButton;
@property (strong ,nonatomic)UIButton *classButton;
@property (strong ,nonatomic)UIButton *screenButton;


@property (strong ,nonatomic)NSString *doc_Category_ID;
@property (assign ,nonatomic)NSInteger indexRow;
@property (strong ,nonatomic)NSString  *needScore;//兑换此文库所需要的积分
@property (strong ,nonatomic)NSString  *cateStr;

@property (strong ,nonatomic)NSString  *rankID;
@property (strong ,nonatomic)NSString  *classID;
@property (strong ,nonatomic)NSString  *screenID;

@end

@implementation Good_LibraryViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit)];
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
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetLib_Category_ID:) name:@"NotificationLib_Category_ID" object:nil];
    
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
    //    [self addScreenView];
    [self addTableView];
    //    [self NetWork];
    //    [self netWork];
    //    [self netWorkCate];
    [self netWorkDocGetList:_num];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _num = 1;
    _doc_Category_ID = @"0";
    _indexRow = 0;
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassTypeID:) name:@"NSNotificationGood_LibraryClassTypeID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRankID:) name:@"NSNotificationGood_LibraryRankID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getScreenTypeID:) name:@"NSNotificationGood_LibraryScreenID" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classButtonType:) name:@"NSNotificationGood_LibraryClassTypeButton11" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rankButtonType:) name:@"NSNotificationGood_LibraryRankButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenButtonType:) name:@"NSNotificationGood_LibraryScreenButton" object:nil];
    
    
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
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"文库";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineLab.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, MainScreenWidth, 45 * WideEachUnit)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    
//    NSArray *titleArray = @[@"综合排序",@"分类",@"筛选条件"];
//    if (_cateStr != nil) {
//        titleArray = @[@"点播课程",_cateStr,@"综合条件"];
//    }
    
    NSArray *titleArray = @[@"分类",@"综合排序"];
    if (_cateStr != nil) {
        titleArray = @[_cateStr,@"综合排序"];
    }
    NSArray *imageArray = @[@"ic_dropdown_live@3x",@"ic_dropdown_live@3x"];
    CGFloat ButtonH = 45 * WideEachUnit;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonH)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        button.titleLabel.font = Font(16 * WideEachUnit);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_headerView addSubview:button];
        
        if (i == 0) {
            _classButton = button;
            _classButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80 * WideEachUnit,0,0);
            _classButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
            [button addTarget:self action:@selector(classButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
            
        } else if (i == 1) {
            _rankButton = button;
            _rankButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80 * WideEachUnit,0,0);
            _rankButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 80);
            [button addTarget:self action:@selector(rankButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 2) {
            _screenButton = button;
            _screenButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80 * WideEachUnit,0,0);
            _screenButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
            [button addTarget:self action:@selector(screenButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * WideEachUnit, MainScreenWidth, 1 * WideEachUnit)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_headerView addSubview:lineButton];
}

- (void)addTableView {
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit + 36) style:UITableViewStyleGrouped];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 + 36) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 88 + 36);
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 90 * WideEachUnit;
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
    [self netWorkDocGetList:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    _num ++;
    [self netWorkDocGetList:_num];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}


#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01 * WideEachUnit;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = nil;
    CellIdentifier = [NSString stringWithFormat:@"cell - %ld",indexPath.row];
    //自定义cell类
    LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LibraryCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict];
    
    [cell.downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.downButton.tag = indexPath.row;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    LibraryDetailViewController *libDetaliVc = [[LibraryDetailViewController alloc] init];
    //    [self.navigationController pushViewController:libDetaliVc animated:YES];
}

#pragma mark --- 通知

- (void)GetLib_Category_ID:(NSNotification *)Not {
    _doc_Category_ID = (NSString *)Not.userInfo;
    _num = 1;
    [self netWorkDocGetList:_num];
}

- (void)getRankID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _rankID = dict[@"order"];
    NSString *title = dict[@"title"];
    [_rankButton setTitle:title forState:UIControlStateNormal];
    [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isRank = NO;
    [self netWorkDocGetList:1];
}

- (void)getClassTypeID:(NSNotification *)not {


    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _classID = dict[@"doc_category_id"];
    _doc_Category_ID = dict[@"doc_category_id"];
    NSString *title = dict[@"title"];
    if (title.length > 4) {
        title = [title substringToIndex:2];
    }
    _classButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80 * WideEachUnit,0,0);
    _classButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 80);
    [_classButton setTitle:title forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClass = NO;
    [self netWorkDocGetList:1];
    
}
- (void)getScreenTypeID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _screenID = dict[@"typeStr"];
    _screenID = dict[@"rankStr"];
    [_screenButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isScreen = NO;
    [self netWorkDocGetList:1];
}

- (void)rankButtonType:(NSNotification *)not {
    [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isRank = NO;
}

- (void)classButtonType:(NSNotification *)not {
    [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClass = NO;
}

- (void)screenButtonType:(NSNotification *)not {
    [_screenButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isScreen = NO;
}


#pragma mark --- 事件监听
- (void)rankButtonCilck:(UIButton *)button {
    
    [_rankButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_rankButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    _rankButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80,0,0);
    _rankButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 80);
    
    [_rankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    isRank = !isRank;
    
    if (isRank) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_LibraryClassTypeButton" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClass = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_LibraryScreenRemove" object:@"remove"];
        [_screenButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_screenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isScreen = NO;
        
        
        Good_LibraryRankViewController *vc = [[Good_LibraryRankViewController alloc] init];
        vc.view.frame = CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth , MainScreenHeight - 64 - 45 * WideEachUnit);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    }
    else {
        //传通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_LibraryRankRemove" object:@"remove"];
        [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
    
}
- (void)classButtonCilck:(UIButton *)button {
    [_classButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    _classButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80,0,0);
    _classButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    isClass = !isClass;
    
    if (isClass) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_LibraryRankRemove" object:@"remove"];
        [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_rankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isRank = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_LibraryScreenRemove" object:@"remove"];
        [_screenButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_screenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isScreen = NO;
        
        
        Good_LibraryClassViewController *vc = [[Good_LibraryClassViewController alloc] init];
        vc.view.frame = CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth , MainScreenHeight - 64 - 45 * WideEachUnit);
        if (iPhoneX) {
            vc.view.frame = CGRectMake(0, 88 + 45 * WideEachUnit, MainScreenWidth , MainScreenHeight - 88 - 45 * WideEachUnit);
        }
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    }
    else {
        //传通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_LibraryClassTypeButton" object:@"remove"];
        [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
}

- (void)screenButtonCilck:(UIButton *)button {
    [_screenButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_screenButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    _screenButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80,0,0);
    _screenButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    [_screenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    isScreen = !isScreen;
    
    if (isScreen) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_LibraryRankRemove" object:@"remove"];
        [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_rankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isRank = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_LibraryClassTypeButton" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClass = NO;
        
        
        Good_LibraryScreenViewController *vc = [[Good_LibraryScreenViewController alloc] init];
        vc.view.frame = CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth , MainScreenHeight - 64 - 45 * WideEachUnit);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    }
    else {
        //传通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_LibraryScreenRemove" object:@"remove"];
        [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
}


- (void)buttonCilck:(UIButton *)button {
    
    
}

- (void)downButtonClick:(UIButton *)button {
    
    _downUrl = _dataArray[button.tag][@"attach"];
    _docID = _dataArray[button.tag][@"doc_id"];
    _downName = _dataArray[button.tag][@"title"];
    _downExtension = _dataArray[button.tag][@"attach_info"][@"extension"];
    _indexRow = button.tag;
    _needScore = _dataArray[button.tag][@"price"];
    NSString *title = button.titleLabel.text;
    if ([title isEqualToString:@"下载"]) {
        [self downButtonClick];
    } else if ([title isEqualToString:@"兑换"]) {
        [self isSurePay];
    }
    
}

//是否 真要支付
- (void)isSurePay {
    if (!UserOathToken) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    NSString *messageStr = [NSString stringWithFormat:@"确定要花费%@个积分兑换该文库？",_needScore];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16 * WideEachUnit]
                  range:NSMakeRange(0, messageStr.length)];
    [alertController setValue:hogan forKey:@"attributedMessage"];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self netWorkDocExchange:_docID];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark --- 网络请求
//文库的列表
- (void)netWorkDocGetList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_Doc_doc_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_doc_Category_ID forKey:@"doc_category_id"];
    [mutabDict setValue:_rankID forKey:@"order"];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setValue:@"20" forKey:@"count"];
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
                    _dataArray = (NSMutableArray *) [dict arrayValueForKey:@"data"];
                } else {
                    NSArray *array = (NSArray *) [dict arrayValueForKey:@"data"];
                    [_dataArray addObjectsFromArray:array];
                }
            } else {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                } else {
                    NSArray *array = (NSArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
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

//文库兑换
- (void)netWorkDocExchange:(NSString *)docID {
    
    NSString *endUrlStr = YunKeTang_Doc_doc_exchange;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:docID forKey:@"doc_id"];
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
            [TKProgressHUD showError:@"兑换成功" toView:self.view];
            [self netWorkDocGetList:_num];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}

#pragma mark --- 下载

-(void)downButtonClick{
    
    if ([[GLNetWorking isConnectionAvailable] isEqualToString:@"4G"] || [[GLNetWorking isConnectionAvailable] isEqualToString:@"3G"] || [[GLNetWorking isConnectionAvailable] isEqualToString:@"2G"]) {
        UIAlertView *_downAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"如果您正在使用2G/3G/4G,如果继续运营商可能会收取流量费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_downAlertView show];
        });
        
    } else {
        [self downLoadVideo];
    }
    
}

-(void)downLoadVideo{
    
    NSString *imageStr = @"PPT@3x";
    UIImage *image = nil;
    if ([_downExtension isEqualToString:@"ppt"] || [_downExtension isEqualToString:@"pptx"]) {
        imageStr = @"PPT@3x";
    } else if ([_downExtension isEqualToString:@"excel"]) {
        imageStr = @"excel";
    } else if ([_downExtension isEqualToString:@"pdf"]) {
        imageStr = @"PDF@3x";
    } else if ([_downExtension isEqualToString:@"word"]) {
        imageStr = @"WORD@3x";
    } else if ([_downExtension isEqualToString:@"txt"]) {
        imageStr = @"txt@3x";
    } else if ([_downExtension isEqualToString:@"docx"]) {
        imageStr = @"WORD@3x";
    } else if ([_downExtension isEqualToString:@"zip"]) {
        imageStr = @"ZIP@3x";
    } else if ([_downExtension isEqualToString:@"jpg"]) {
        imageStr = @"ZIP@3x";
    } else {
        imageStr = @"PPT@3x";
    }
    image = Image(imageStr);
    
    NSString *libriyName = [NSString stringWithFormat:@"%@.%@",_downName,_downExtension];
    
    if (!_downUrl.length) {
        [TKProgressHUD showError:@"下载地址为空" toView:self.view];
        return ;
    }
    
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:_downUrl filename:libriyName fileimage:image];
    //设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 1;
    
}
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self downLoadVideo];
    }else
        return;
}



@end
