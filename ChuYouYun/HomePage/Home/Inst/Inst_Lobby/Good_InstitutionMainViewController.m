//
//  Good_InstitutionMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/16.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_InstitutionMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "InstitutionListCell.h"
#import "InstitutionMainViewController.h"
#import "Good_InstClassViewController.h"
#import "Good_InstRankViewController.h"


@interface Good_InstitutionMainViewController ()<UITableViewDelegate,UITableViewDataSource> {
    BOOL isClass;
    BOOL isRank;
}

@property (strong ,nonatomic)UIView           *headerView;
@property (strong ,nonatomic)UITableView      *tableView;
@property (strong ,nonatomic)UIButton         *classButton;
@property (strong ,nonatomic)UIButton         *rankButton;
@property (strong ,nonatomic)UIImageView      *imageView;

@property (strong ,nonatomic)NSMutableArray     *dataArray;
@property (assign ,nonatomic)NSInteger Num;
@property (strong ,nonatomic)NSString         *classID;
@property (strong ,nonatomic)NSString         *rankID;
@property (strong ,nonatomic)NSArray          *cateArray;

//营销数据
@property (strong ,nonatomic)NSString         *order_switch;


@end

@implementation Good_InstitutionMainViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 109, MainScreenWidth, MainScreenHeight - 109)];
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
    [self netWorkSchoolGetCategory];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dataArray = [NSMutableArray array];
    isClass = NO;
    isRank = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassTypeID:) name:@"NSNotificationInstClassTypeID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRankID:) name:@"NSNotificationInstRankID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classButtonType:) name:@"NSNotificationInstClassTypeButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rankButtonType:) name:@"NSNotificationInstRankButton" object:nil];
    
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
    WZLabel.text = @"机构大厅";
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
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, MainScreenWidth, 45)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    
    NSArray *titleArray = @[@"分类",@"筛选条件"];
    NSArray *imageArray = @[@"ic_dropdown_live@3x",@"ic_dropdown_live@3x",@"ic_dropdown_live@3x"];
    CGFloat ButtonH = 45;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonH)];
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
            _rankButton = button;
            [button addTarget:self action:@selector(rankButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_headerView addSubview:lineButton];
}

#pragma mark --- UITableView
- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64 + 45 , MainScreenWidth, MainScreenHeight - 64 - 45 + 36) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88 + 45, MainScreenWidth, MainScreenHeight - 88 - 45 + 36);
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 105;
    _tableView.rowHeight = 85;
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
    [self netWorkSchoolGetList:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    _Num ++;
    [self netWorkSchoolGetList:_Num];
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
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"culture";
    //自定义cell类
    InstitutionListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[InstitutionListCell alloc] initWithReuseIdentifier:CellID];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    InstitutionMainViewController*instVc = [[InstitutionMainViewController alloc] init];
    instVc.schoolID = _dataArray[indexPath.row][@"school_id"];
    instVc.uID = _dataArray[indexPath.row][@"uid"];
    instVc.address = _dataArray[indexPath.row][@"location"];
    [self.navigationController pushViewController:instVc animated:YES];
}

#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)classButtonCilck:(UIButton *)button {
    [_classButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    
    [_rankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isClass = !isClass;
    
    if (isClass) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InstRankRemove" object:@"remove"];
        [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_rankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isRank = NO;
        
        Good_InstClassViewController *vc = [[Good_InstClassViewController alloc] init];
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth , MainScreenHeight - (MACRO_UI_UPHEIGHT + 45));
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        //传通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InstClassRemove" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }

}

- (void)rankButtonCilck:(UIButton *)button {
    [_rankButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_rankButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    
    [_rankButton setTitleColor:BasidColor forState:UIControlStateNormal];
    
    isRank = !isRank;
    
    if (isRank) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InstClassRemove" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClass = NO;
        
        Good_InstRankViewController *vc = [[Good_InstRankViewController alloc] init];
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth , MainScreenHeight - (MACRO_UI_UPHEIGHT + 45));
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        //传通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InstRankRemove" object:@"remove"];
        [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }

}


#pragma mark --- 通知
- (void)getClassTypeID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _classID = dict[@"id"];
    NSString *title = dict[@"title"];
    if (title.length>6) {
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:4]];
    }
    [_classButton setTitle:title forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClass = NO;
    [self dealButtonImageAndTitleUI:_classButton];
    _Num = 1;
    [self netWorkSchoolGetList:_Num];
}

- (void)getRankID:(NSNotification *)not {
//    NSLog(@"%@",not.object);
//    NSDictionary *dict = not.object;
//    _rankID = dict[@"id"];
//    NSString *title = dict[@"name"];
//    [_rankButton setTitle:title forState:UIControlStateNormal];
//    [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
//    isRank = NO;
//    _Num ++;
    
    NSDictionary *dict = (NSDictionary *)not.object;
    [_rankButton setTitle:[dict stringValueForKey:@"title"] forState:UIControlStateNormal];
    [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_rankButton];
    _rankID = [dict stringValueForKey:@"order"];
    [self netWorkSchoolGetList:1];
    isRank = NO;
    
}

- (void)classButtonType:(NSNotification *)not {
    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClass = NO;
}

- (void)rankButtonType:(NSNotification *)not {
    [_rankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rankButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isRank = NO;
}


#pragma mark --- 网络请求
//机构列表的数据
- (void)netWorkSchoolGetList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_School_school_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",(long)Num] forKey:@"page"];
    [mutabDict setObject:@"20" forKey:@"count"];
    if (_classID) {
         [mutabDict setObject:_classID forKey:@"cateId"];
    }
    if (_rankID) {
         [mutabDict setObject:_rankID forKey:@"orderBy"];
    }
    
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
        if (Num == 1) {
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
        } else {
            self.imageView.hidden = YES;
        }

        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//机构分类的数据
- (void)netWorkSchoolGetCategory {
    
    NSString *endUrlStr = YunKeTang_School_school_getCategory;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _cateArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        
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


- (void)dealButtonImageAndTitleUI:(UIButton *)sender {
    CGFloat labelWidth = [sender.titleLabel.text sizeWithFont:sender.titleLabel.font].width;
    if (labelWidth>(sender.size.width - sender.currentImage.size.width)) {
        labelWidth = 71.5 * WideEachUnit;
    }
    [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -sender.currentImage.size.width, 0, sender.currentImage.size.width)];
    [sender setImageEdgeInsets:UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth)];
}

@end
