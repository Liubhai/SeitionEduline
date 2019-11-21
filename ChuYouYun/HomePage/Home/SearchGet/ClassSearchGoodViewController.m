//
//  ClassSearchGoodViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/28.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ClassSearchGoodViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "SYGTextField.h"

#import "HomeInstitutionViewController.h"

#import "InstatutionCollectionViewCell.h"
#import "ZhiBoMainViewController.h"

#import "ZhiBoClassView.h"
#import "ZhiBoTeacherView.h"
#import "ZhiBoMoreView.h"
#import "ZhiBoClassTypeViewController.h"
#import "ZhiBoClassTeacherViewController.h"
#import "ZhiBoClassMoreViewController.h"

#import "ClassSearchClassOrLiveViewController.h"
#import "ClassSearchClassTypeViewController.h"
#import "ClassSearchMoreViewController.h"
#import "ClassScreeningViewController.h"


#import "ClassRevampCell.h"
#import "Good_ClassMainViewController.h"
#import "DLViewController.h"



static NSString *cellID = @"cell";

@interface ClassSearchGoodViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate> {
    BOOL isClassOrLive;
    BOOL isClassType;
    BOOL isMore;
    BOOL isScreen;
    /// 分页
    NSInteger pageCount;
}


@property (strong ,nonatomic)UICollectionView *collectionView;
@property (strong ,nonatomic)UITableView      *tableView;
@property (strong ,nonatomic)UIView           *headerView;
@property (strong ,nonatomic)UIButton         *classOrLiveButton;
@property (strong ,nonatomic)UIButton         *classTypeButton;
@property (strong ,nonatomic)UIButton         *moreButton;
@property (strong ,nonatomic)UIButton         *screeningButton;
@property (strong ,nonatomic)UIImageView      *imageView;

@property (strong ,nonatomic)NSMutableArray   *dataArray;
@property (strong ,nonatomic)NSString         *typeID;
@property (strong ,nonatomic)NSString         *teacherID;
@property (strong ,nonatomic)NSString         *moreTypeID;
@property (strong ,nonatomic)NSString         *moreRankID;

@property (strong ,nonatomic)NSDictionary     *dataSource;
@property (strong ,nonatomic)NSMutableArray   *dataSourceArray;

//营销数据
@property (strong ,nonatomic)NSString         *order_switch;

@end

@implementation ClassSearchGoodViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    if ([_typeTagStr integerValue] == 1) {
        [nv isHiddenCustomTabBarByBoolean:NO];
        self.navigationController.navigationBar.hidden = YES;
    } else {
        [nv isHiddenCustomTabBarByBoolean:YES];
        self.navigationController.navigationBar.hidden = YES;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"App_Key"] == nil) {
        [app netInitApp];
    }
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
    pageCount = 1;
    [self interFace];
    [self addNav];
    [self addHeaderView];
    [self addTableView];
//    [self netWorkGetLiveList:nil];
    [self netWorkHomeSearchClass];
    [self netWorkConfigGetMarketStatus];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray new];
    
    isClassOrLive = NO;
    isClassType = NO;
    isMore = NO;
    isScreen = NO;
    
    NSLog(@"---%@",_cateStr);
    
    _orderStr = @"default";
    _classType = @"1";
    if (_typeStr == nil) {
        _typeStr = @"1";
    } else if ([_typeStr isEqual:@"100"]) {//从会员中心过来
        _classType = nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassTypeID:) name:@"NSNotificationSearchClassOrLiveID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTeacherID:) name:@"NSNotificationSearchClassTypeID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoreID:) name:@"NSNotificationSearchClassMoreID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getScreeningID:) name:@"NSNotificationSearchClassScreeningID" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classButtonType:) name:@"NSNotificationSearchClassOrLiveButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teacherButtonType:) name:@"NSNotificationSearchClassTypeButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreButtonType:) name:@"NSNotificationSearchClassMoreButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screeningButtonType:) name:@"NSNotificationSearchClassScreeningButton" object:nil];
    
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, NavigationBarSubViewHeight, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    if ([_typeTagStr integerValue] == 1) {
        backButton.hidden = YES;
    } else {
        backButton.hidden = NO;
    }
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    if (iPhoneX) {
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
    WZLabel.text = @"课程";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    WZLabel.hidden = YES;
    
    
    _searchText = [[SYGTextField alloc] initWithFrame:CGRectMake(47.5 * WideEachUnit, NavigationBarSubViewHeight, MainScreenWidth - 95, 36)];
    _searchText.placeholder = @"搜课程";
    _searchText.font = Font(14 * WideEachUnit);
    [_searchText setValue:Font(16) forKeyPath:@"_placeholderLabel.font"];
//    [_searchText sygDrawPlaceholderInRect:CGRectMake(0, 10 * WideEachUnit, 0, 0)];
    _searchText.delegate = self;
    _searchText.returnKeyType = UIReturnKeySearch;
    _searchText.layer.cornerRadius = 18;
    _searchText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _searchText.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _searchText.leftViewMode = UITextFieldViewModeAlways;
    _searchText.text = _searchStr;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
    [button setImage:Image(@"yunketang_search") forState:UIControlStateNormal];
    [_searchText.leftView addSubview:button];
    [SYGView addSubview:_searchText];
    
    
    if ([_typeTagStr integerValue] == 1) {
        _searchText.hidden = YES;
        WZLabel.hidden = NO;
    }

    
}

- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, MainScreenWidth, 45 * WideEachUnit)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    
    NSArray *titleArray = @[@"点播课程",@"分类",@"综合条件",@"筛选"];
    if (_cateStr != nil) {
        titleArray = @[@"点播课程",_cateStr,@"综合条件",@"筛选"];
    }
    NSArray *imageArray = @[@"ic_dropdown_live@3x",@"ic_dropdown_live@3x",@"ic_dropdown_live@3x",@"ic_dropdown_live@3x"];
    CGFloat ButtonH = 45 * WideEachUnit;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonH)];
        button.titleLabel.font = Font(14 * WideEachUnit);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self dealButtonImageAndTitleUI:button];
        [_headerView addSubview:button];
        if (i == 0) {
            _classOrLiveButton = button;
            [button addTarget:self action:@selector(classOrLiveButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) {
            _classTypeButton = button;
            [button addTarget:self action:@selector(classTypeButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 2) {
            _moreButton = button;
            [button addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 3) {
            if (SWNOTEmptyStr(_screeningStr)) {
                if ([_screeningStr isEqualToString:@"best"]) {
                    [button setTitle:@"精选" forState:UIControlStateNormal];
                }
            }
            _screeningButton = button;
            [button addTarget:self action:@selector(screeningButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * WideEachUnit, MainScreenWidth, 1 * WideEachUnit)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_headerView addSubview:lineButton];
}

#pragma mark --- 表格试图

#pragma mark --- 表格视图
- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit) style:UITableViewStyleGrouped];
    if ([_typeTagStr integerValue] == 1) {
        _tableView.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45 * WideEachUnit - MACRO_UI_TABBAR_HEIGHT);
    } else {
        _tableView.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45 * WideEachUnit);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100 * WideEachUnit;
    [self.view addSubview:_tableView];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

- (void)headerRerefreshing
{
    pageCount = 1;
    [self netWorkHomeSearchClass];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing {
    pageCount = pageCount + 1;
    [self netWorkHomeSearchClassMoreData];
}


#pragma mark --- UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01 * WideEachUnit;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_typeStr isEqualToString:@"1"]) {//课程
        static NSString *CellID = nil;
        CellID = [NSString stringWithFormat:@"cellClass - %ld",indexPath.row];
        //自定义cell类
        ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
        }
        NSDictionary *dict = _dataArray[indexPath.row];
        [cell dataWithDict:dict withType:@"1" withOrderSwitch:_order_switch];
        return cell;
        
    } else if ([_typeStr integerValue] == 2) {//直播
        static NSString *CellID = nil;
        CellID = [NSString stringWithFormat:@"cellLive - %ld",indexPath.row];
        //自定义cell类
        ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
        }
        NSDictionary *dict = _dataArray[indexPath.row];
        [cell dataWithDict:dict withType:@"2" withOrderSwitch:_order_switch];
        return cell;
    } else if ([_typeStr integerValue] == 5) {//班级
        static NSString *CellID = nil;
        CellID = [NSString stringWithFormat:@"cellClass - %ld",indexPath.row];
        //自定义cell类
        ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
        }
        NSDictionary *dict = _dataArray[indexPath.row];
        [cell dataWithDict:dict withType:@"5" withOrderSwitch:_order_switch];
        return cell;
    } else {
        static NSString *CellID = @"cellClass";
        //自定义cell类
        ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
        }
        NSDictionary *dict = _dataArray[indexPath.row];
        [cell dataWithDict:dict withType:@"1"];
        return cell;
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    if ([_typeStr isEqualToString:@"1"] || [_typeStr isEqualToString:@"5"]) {//课程

        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"id"];
        vc.videoTitle = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
        vc.price = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"price"];
        vc.imageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
        vc.videoUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_address"];
        vc.orderSwitch = _order_switch;
        vc.isClassNew = [_typeStr isEqualToString:@"5"] ? YES : NO;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_typeStr isEqualToString:@"2"]) {
        
        NSLog(@"%@",_dataArray[indexPath.row]);
        NSString *Cid = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"live_id"]];
        NSString *Price = _dataArray[indexPath.row][@"price"];
        NSString *Title = _dataArray[indexPath.row][@"video_title"];
        NSString *ImageUrl = _dataArray[indexPath.row][@"imageurl"];
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
        zhiBoMainVc.order_switch = _order_switch;
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
        
    }
}



#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)classOrLiveButtonCilck:(UIButton *)button {
    [_classOrLiveButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_classOrLiveButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];

    [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_screeningButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isClassOrLive = !isClassOrLive;
    
    if (isClassOrLive) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassTypeRemove" object:@"remove"];
        [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClassType = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassMoreRemove" object:@"remove"];
        [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isMore = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassScreeningRemove" object:@"remove"];
        [_screeningButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_screeningButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isScreen = NO;
        
        
        ClassSearchClassOrLiveViewController *vc = [[ClassSearchClassOrLiveViewController alloc] init];
        vc.view.frame = CGRectMake(0, 109, MainScreenWidth , MainScreenHeight - 109);
//        if (iPhoneX) {
//            vc.view.frame = CGRectMake(0, 45 + 88, MainScreenWidth , MainScreenHeight - 88 - 45);
//        }
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        //传通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassOrLiveRemove" object:@"remove"];
        [_classOrLiveButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
    
    
}

- (void)classTypeButtonCilck:(UIButton *)button {

        [_classTypeButton setTitleColor:BasidColor forState:UIControlStateNormal];
        [_classTypeButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    
        [_classOrLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_screeningButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        isClassType = !isClassType;
        
        if (isClassType) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassOrLiveRemove" object:@"remove"];
            [_classOrLiveButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
            [_classOrLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            isClassOrLive = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassMoreRemove" object:@"remove"];
            [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
            [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            isMore = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassScreeningRemove" object:@"remove"];
            [_screeningButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
            [_screeningButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            isScreen = NO;
            
            ClassSearchClassTypeViewController *vc = [[ClassSearchClassTypeViewController alloc] init];
            vc.typeTagStr = _typeTagStr;
            vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth , MainScreenHeight - MACRO_UI_UPHEIGHT - 45 - ([_typeTagStr integerValue] == 1 ? MACRO_UI_TABBAR_HEIGHT : 0));
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        } else {
            //传通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassTypeRemove" object:@"remove"];
            [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        }
}

- (void)moreButtonCilck:(UIButton *)button {
    [_moreButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_moreButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classOrLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_screeningButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isMore = !isMore;
    
    if (isMore) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassOrLiveRemove" object:@"remove"];
        [_classOrLiveButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classOrLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClassOrLive = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassTypeRemove" object:@"remove"];
        [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClassType = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassScreeningRemove" object:@"remove"];
        [_screeningButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_screeningButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isScreen = NO;
        
        ClassSearchMoreViewController *vc = [[ClassSearchMoreViewController alloc] init];
        vc.view.frame = CGRectMake(0, 109, MainScreenWidth , MainScreenHeight - 109);
//        if (iPhoneX) {
//            vc.view.frame = CGRectMake(0, 45 + 88, MainScreenWidth , MainScreenHeight - 88 - 45);
//        }
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassMoreRemove" object:@"remove"];
        [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
}

- (void)screeningButtonCilck:(UIButton *)button {
    
    [_screeningButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_screeningButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    
    [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classOrLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isScreen = !isScreen;
    
    if (isScreen) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassOrLiveRemove" object:@"remove"];
        [_classOrLiveButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classOrLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClassOrLive = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassTypeRemove" object:@"remove"];
        [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClassType = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassMoreRemove" object:@"remove"];
        [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isMore = NO;
        
        
        ClassScreeningViewController *vc = [[ClassScreeningViewController alloc] init];
        vc.view.frame = CGRectMake(0, 109, MainScreenWidth , MainScreenHeight - 109);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchClassScreeningRemove" object:@"remove"];
        [_screeningButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
}

#pragma mark --- 通知
- (void)getClassTypeID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSString *title = not.object;
    if ([title isEqualToString:@"直播课程"]) {
        _classType = @"2";
    } else if ([title isEqualToString:@"点播课程"]) {
        _classType = @"1";
    } else if ([title isEqualToString:@"班级课程"]) {
        _classType = @"5";
    }
    _typeStr = _classType;
    [_classOrLiveButton setTitle:title forState:UIControlStateNormal];
    [_classOrLiveButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClassOrLive = NO;
    [self dealButtonImageAndTitleUI:_classOrLiveButton];
//    [self netWorkGetLiveList:nil];
    [self netWorkHomeSearchClass];
}

- (void)getTeacherID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _cate_ID = dict[@"id"];
    NSString *title = dict[@"title"];
    if (title.length>6) {
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:4]];
    }
    [_classTypeButton setTitle:title forState:UIControlStateNormal];
    [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_classTypeButton];
    isClassType = NO;
//    [self netWorkGetLiveList:nil];
    [self netWorkHomeSearchClass];
}

- (void)getMoreID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _orderStr = [dict stringValueForKey:@"order"];
    [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
//    if ([_orderStr isEqualToString:@"hot"]) {
//        [_moreButton setTitle:@"人气最高" forState:UIControlStateNormal];
//    } else if ([_orderStr isEqualToString:@"default"]) {
//        [_moreButton setTitle:@"智能排序" forState:UIControlStateNormal];
//    }
    [_moreButton setTitle:[dict stringValueForKey:@"title"] forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_moreButton];
    isMore = NO;
    [self netWorkHomeSearchClass];
}

- (void)getScreeningID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _screeningStr = [dict stringValueForKey:@"order"];
    [_screeningButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    //    if ([_orderStr isEqualToString:@"hot"]) {
    //        [_moreButton setTitle:@"人气最高" forState:UIControlStateNormal];
    //    } else if ([_orderStr isEqualToString:@"default"]) {
    //        [_moreButton setTitle:@"智能排序" forState:UIControlStateNormal];
    //    }
    [_screeningButton setTitle:[dict stringValueForKey:@"title"] forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_screeningButton];
    isScreen = NO;
    [self netWorkHomeSearchClass];
}

- (void)classButtonType:(NSNotification *)not {
    [_classOrLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classOrLiveButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClassOrLive = NO;
}

- (void)teacherButtonType:(NSNotification *)not {
    [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClassType = NO;
}

- (void)moreButtonType:(NSNotification *)not {
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isMore = NO;
}

- (void)screeningButtonType:(NSNotification *)not {
    [_screeningButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_screeningButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isScreen = NO;
}

#pragma mark --- 键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //点搜索按钮
    if (_searchText.text.length > 0) {
        [self netWorkHomeSearchClass];
    }
    
    [textField becomeFirstResponder];
    if ([textField.text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
}


#pragma mark --- 网络请求
//获取视频课 和 直播课
- (void)netWorkHomeSearchClass {
    
    NSString *endUrlStr = YunKeTang_Home_home_search;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1" forKey:@"page"];
    [mutabDict setObject:@"10" forKey:@"count"];
    if (_classType == nil) {
        [mutabDict setObject:@"0" forKey:@"type"];//全部
    } else {
        [mutabDict setObject:_classType forKey:@"type"];
    }
    if (_searchText.text.length > 0) {
        [mutabDict setObject:_searchText.text forKey:@"keyword"];
    }
    if (_cate_ID) {
        [mutabDict setObject:_cate_ID forKey:@"cate_id"];
    }
    if (_orderStr) {
        [mutabDict setObject:_orderStr forKey:@"order"];
        if ([_screeningStr isEqualToString:@"best"]) {
             [mutabDict setObject:_screeningStr forKey:@"order"];
        }
    }
    if (_currentVipId) {
        [mutabDict setObject:_currentVipId forKey:@"vip_id"];
    }
    if (_screeningStr) {
        if ([_screeningStr isEqualToString:@"free"]) {
              [mutabDict setObject:@"1" forKey:@"free"];
        } else if ([_screeningStr isEqualToString:@"charge"]) {
              [mutabDict setObject:@"1" forKey:@"charge"];
        } else if ([_screeningStr isEqualToString:@"vip_level"]) {
              [mutabDict setObject:@"1" forKey:@"vip_level"];
        }
    }
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
         [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            
            if ([[_dataSource arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                [_dataArray removeAllObjects];
                 [_dataArray addObjectsFromArray:(NSMutableArray *) [[[_dataSource arrayValueForKey:@"data"] objectAtIndex:0] arrayValueForKey:@"list"]];
            } else {
                [_dataArray removeAllObjects];
                NSArray *dataSourceArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                [_dataArray addObjectsFromArray:(NSMutableArray *)[[dataSourceArray objectAtIndex:0] arrayValueForKey:@"list"]];
            }
            if (_dataArray.count<10) {
                [_tableView setFooterHidden:YES];
            } else {
                [_tableView setFooterHidden:NO];
            }
            if (_dataArray.count == 0) {
                _imageView.hidden = NO;
                if (_imageView.image) {//已经存在
                } else {//第一次就添加
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 109, MainScreenWidth, MainScreenHeight - 109)];
                    if (iPhoneX) {
                        imageView.frame = CGRectMake(0, 88 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 88 - 45 * WideEachUnit);
                    }
                    imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
                    [self.view addSubview:imageView];
                    _imageView = imageView;
                }
            } else {
                _imageView.hidden = YES;
            }
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

// MARK: - 加载更多
- (void)netWorkHomeSearchClassMoreData {
    
    NSString *endUrlStr = YunKeTang_Home_home_search;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@(pageCount) forKey:@"page"];
    [mutabDict setObject:@"10" forKey:@"count"];
    if (_classType == nil) {
        [mutabDict setObject:@"0" forKey:@"type"];//全部
    } else {
        [mutabDict setObject:_classType forKey:@"type"];
    }
    if (_searchText.text.length > 0) {
        [mutabDict setObject:_searchText.text forKey:@"keyword"];
    }
    if (_cate_ID) {
        [mutabDict setObject:_cate_ID forKey:@"cate_id"];
    }
    if (_orderStr) {
        [mutabDict setObject:_orderStr forKey:@"order"];
        if ([_screeningStr isEqualToString:@"best"]) {
            [mutabDict setObject:_screeningStr forKey:@"order"];
        }
    }
    if (_currentVipId) {
        [mutabDict setObject:_currentVipId forKey:@"vip_id"];
    }
    if (_screeningStr) {
        if ([_screeningStr isEqualToString:@"free"]) {
            [mutabDict setObject:@"1" forKey:@"free"];
        } else if ([_screeningStr isEqualToString:@"charge"]) {
            [mutabDict setObject:@"1" forKey:@"charge"];
        } else if ([_screeningStr isEqualToString:@"vip_level"]) {
            [mutabDict setObject:@"1" forKey:@"vip_level"];
        }
    }
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            if ([[_dataSource arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                if ([[[_dataSource objectForKey:@"data"][0] objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                    NSArray *moreArray = [[_dataSource objectForKey:@"data"][0] objectForKey:@"list"];
                    [_dataArray addObjectsFromArray:moreArray];
                    if (moreArray.count<10) {
                        [_tableView setFooterHidden:YES];
                    } else {
                        [_tableView setFooterHidden:NO];
                    }
                }
            } else {
                NSArray *dataSourceArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                NSArray *moreArray = (NSMutableArray *)[[dataSourceArray objectAtIndex:0] arrayValueForKey:@"list"];
                [_dataArray addObjectsFromArray:moreArray];
                if (moreArray.count<10) {
                    [_tableView setFooterHidden:YES];
                } else {
                    [_tableView setFooterHidden:NO];
                }
            }
            if (_dataArray.count == 0) {
                _imageView.hidden = NO;
                if (_imageView.image) {//已经存在
                } else {//第一次就添加
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 109, MainScreenWidth, MainScreenHeight - 109)];
                    if (iPhoneX) {
                        imageView.frame = CGRectMake(0, 88 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 88 - 45 * WideEachUnit);
                    }
                    imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
                    [self.view addSubview:imageView];
                    _imageView = imageView;
                }
            } else {
                _imageView.hidden = YES;
            }
        } else {
            pageCount--;
        }
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        pageCount--;
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
            [_tableView reloadData];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

@end
