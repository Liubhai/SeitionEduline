//
//  TestClassMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/25.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestClassMainViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "ZhiyiHTTPRequest.h"

#import "TestClassMainTableViewCell.h"
#import "TestClassViewController.h"
#import "TestMoreViewController.h"
#import "TestCurrentViewController.h"

#import "DLViewController.h"

#import "Good_PersonFaceRegisterViewController.h"

//人脸识别
#import "DetectionViewController.h"
#import "NetAccessModel.h"

// 付费
#import "TestPayViewController.h"



@interface TestClassMainViewController ()<UITableViewDelegate,UITableViewDataSource,TestClassMainTableViewCellDelegate>{
    BOOL isClass;
    BOOL isMore;
    UIImage *faceImage;
}


@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;
@property (strong ,nonatomic)NSMutableArray     *dataArray;

@property (strong ,nonatomic)UIView           *headerView;
@property (strong ,nonatomic)UIButton         *classButton;
@property (strong ,nonatomic)UIButton         *schoolButton;
@property (strong ,nonatomic)UIButton         *moreButton;

@property (strong ,nonatomic)UIButton         *testButton;
@property (strong ,nonatomic)UIButton         *examButton;

@property (strong ,nonatomic)NSString         *typeID;
@property (strong ,nonatomic)NSString         *moreTypeID;
@property (strong ,nonatomic)NSString         *moreRankID;
@property (strong ,nonatomic)NSString         *examsType;


@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIView *buyView;
@property (strong ,nonatomic)NSDictionary     *testDict;

@property (strong ,nonatomic)NSDictionary     *dataSource;//试卷所有的数据汇总

//人脸识别相关
@property (strong ,nonatomic)NSDictionary     *statusDict;
@property (strong ,nonatomic)NSArray          *getFaceSceneArray;
@property (strong ,nonatomic)NSString         *faceID;

@end

@implementation TestClassMainViewController

#pragma mark --- lazy
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45)];
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
    //    [self addTableHeaderView];
    [self addTableView];
    //    [self NetWorkCate];
    [self netWorkExamsGetPaperList];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    isClass = NO;
    isMore = NO;
    _examsType = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassTypeID:) name:@"NSNotificationTestClassTypeID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoreID:) name:@"NSNotificationTestMoreTypeID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classButtonType:) name:@"NSNotificationTestClassTypeButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreButtonType:) name:@"NSNotificationTestMoreButton" object:nil];

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
    WZLabel.text = @"在线考试";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
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
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 45 * WideEachUnit)];
    if (iPhoneX) {
        _headerView.frame = CGRectMake(0, 88, MainScreenWidth, 45);
    }
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    
    NSArray *titleArray = @[@"分类",@"筛选条件"];
    NSArray *imageArray = @[@"ic_dropdown_live@3x",@"ic_dropdown_live@3x"];
    CGFloat ButtonH = 45 * WideEachUnit;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonH)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        button.titleLabel.font = Font(16);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_headerView addSubview:button];
        
        if (i == 0) {
            _classButton = button;
            _classButton.imageEdgeInsets =  UIEdgeInsetsMake(0,120 * WideEachUnit,0,0);
            _classButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30 * WideEachUnit);
            [button addTarget:self action:@selector(classButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) {
            _moreButton = button;
            _moreButton.imageEdgeInsets =  UIEdgeInsetsMake(0,120 * WideEachUnit,0,0);
            _moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30 * WideEachUnit);
            [button addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * WideEachUnit, MainScreenWidth, 1 * WideEachUnit)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_headerView addSubview:lineButton];
}




#pragma mark ----- UITableView

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88 + 45, MainScreenWidth, MainScreenHeight - 88 - 45);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 75 * WideEachUnit;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}


#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1 * WideEachUnit;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = nil;
    CellIdentifier = [NSString stringWithFormat:@"cell - %ld",indexPath.row];
    //自定义cell类
    TestClassMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TestClassMainTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// MARK: - TestClassMainTableViewCellDelegate(cell代理)
- (void)doButtonClick:(TestClassMainTableViewCell *)cell cellInfo:(NSDictionary *)cellDict {
    // 首先判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if ([[cellDict objectForKey:@"price"] integerValue] == 0) {
        // 去考试
        _testDict = cellDict;
        [self addMoreView];
    } else {
        if ([[cellDict objectForKey:@"is_buy"] boolValue]) {
            // 去考试
            _testDict = cellDict;
            [self addMoreView];
        } else {
            // 去付费
            TestPayViewController *vc = [[TestPayViewController alloc] init];
            vc.info = cellDict;
            vc.paySuccess = ^(NSString *paper_id) {
                for (int i = 0; i<_dataArray.count; i++) {
                    if ([paper_id isEqualToString:[NSString stringWithFormat:@"%@",[_dataArray[i] objectForKey:@"exams_paper_id"]]]) {
                        NSDictionary *origin = [NSDictionary dictionaryWithDictionary:_dataArray[i]];
                        NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:origin];
                        [pass setObject:@"1" forKey:@"is_buy"];
                        origin = [NSDictionary dictionaryWithDictionary:pass];
                        [_dataArray replaceObjectAtIndex:i withObject:origin];
                        break;
                    }
                }
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark --- 事件处理
- (void)classButtonCilck:(UIButton *)button {
    [_classButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    _classButton.imageEdgeInsets =  UIEdgeInsetsMake(0,120 * WideEachUnit,0,0);
    _classButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30 * WideEachUnit);
    
    [_schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isClass = !isClass;
    
    if (isClass) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TestClassMoreRemove" object:@"remove"];
        [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isMore = NO;
        
        TestClassViewController *vc = [[TestClassViewController alloc] init];
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45 * WideEachUnit, MainScreenWidth , MainScreenHeight - MACRO_UI_UPHEIGHT - 45 * WideEachUnit);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        //传通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TestClassTypeRemove" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
    
    
}

- (void)moreButtonCilck:(UIButton *)button {
    [_moreButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_moreButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    _moreButton.imageEdgeInsets =  UIEdgeInsetsMake(0,120 * WideEachUnit,0,0);
    _moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30 * WideEachUnit);
    
    [_schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isMore = !isMore;
    
    if (isMore) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TestClassTypeRemove" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClass = NO;
        
        TestMoreViewController *vc = [[TestMoreViewController alloc] initWithTypeStr:_moreTypeID withMoreStr:_moreRankID];
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45 * WideEachUnit, MainScreenWidth , MainScreenHeight - MACRO_UI_UPHEIGHT - 45 * WideEachUnit);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TestClassMoreRemove" object:@"remove"];
        [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
}

#pragma mark --- 通知
- (void)getClassTypeID:(NSNotification *)not {
    NSDictionary *dict = not.object;
    _typeID = dict[@"subject_id"];
    NSString *title = dict[@"title"];
    [_classButton setTitle:title forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClass = NO;
    [self netWorkExamsGetPaperList];
}

- (void)getMoreID:(NSNotification *)not {
    NSString *typeID = not.object;
    _moreTypeID = typeID;
    [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    if ([_moreTypeID integerValue] == 1) {//简单
        [_moreButton setTitle:@"简单" forState:UIControlStateNormal];
    } else if ([_moreTypeID integerValue] == 2) {
        [_moreButton setTitle:@"普通" forState:UIControlStateNormal];
    } else if ([_moreTypeID integerValue] == 3) {
        [_moreButton setTitle:@"困难" forState:UIControlStateNormal];
    }
    isMore = NO;
    [self netWorkExamsGetPaperList];
}

- (void)classButtonType:(NSNotification *)not {
    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClass = NO;
}

- (void)moreButtonType:(NSNotification *)not {
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isMore = NO;
}


#pragma mark --- 进入考试

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
//    _buyView = [[UIView alloc] init];
//    _buyView.frame = CGRectMake(0, 0, 10 * WideEachUnit, 10 * WideEachUnit);
//    _buyView.center = _allView.center;
//    [_allView addSubview:_buyView];
    
//    [UIView animateWithDuration:0.25 animations:^{
        _buyView = [[UIView alloc] init];
        _buyView.frame = CGRectMake(MainScreenWidth, MACRO_UI_UPHEIGHT, 335 * WideEachUnit, 288 * WideEachUnit);
        _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
        _buyView.layer.cornerRadius = 3;
        _buyView.center = _allView.center;
        [_allView addSubview:_buyView];
//    }];
    
    [self addTestDetail];
}

- (void)removeMoreView {
    
    [UIView animateWithDuration:0.25 animations:^{
        _allView.alpha = 0;
        _allButton.alpha = 0;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
    });
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        _allView.alpha = 0;
        _allButton.alpha = 0;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
    });
}

- (void)SYGButton:(UIButton *)button {
    
//    isSecet = NO;
//    NSLog(@"%@",button.titleLabel.text);
//    [self miss];
//    
//    //将分类的id传过去
//    _ID = [NSString stringWithFormat:@"%ld",button.tag];
//    NSLog(@"%@",_ID);
//
//    _number = 1;
    
}


- (void)eaxmTypeButtonCilck:(UIButton *)button {
    [self miss];
    if (button.tag == 0) {//练习模式
        _examsType = @"1";
        [self netWorkExamsGetPaperInfo];
    } else {//考试模式
        _examsType = @"2";
        [self netWorkCongigGetFaceScene];
    }
    
}



- (void)addTestDetail {
    
    NSLog(@"%@",_testDict);
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30 * WideEachUnit, 0, 275 * WideEachUnit, 70 * WideEachUnit)];
    title.text = [NSString stringWithFormat:@"%@",[_testDict stringValueForKey:@"exams_paper_title"]];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = Font(18 * WideEachUnit);
    [_buyView addSubview:title];
    
    //添加线
    UIButton *titleLineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, 335 * WideEachUnit, 1)];
    titleLineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_buyView addSubview:titleLineButton];
    
    
    NSArray *titleArray = @[@"题数",@"总分",@"考试时间"];
    
    NSString *Str1 = [NSString stringWithFormat:@"%@题",[_testDict stringValueForKey:@"questions_count"]];
    NSString *Str2 = [NSString stringWithFormat:@"%@分",[_testDict stringValueForKey:@"score"]];
    NSString *Str3 = [NSString stringWithFormat:@"%@分钟",[_testDict stringValueForKey:@"reply_time"]];
    if ([Str3 integerValue] == 0) {
        Str3 = @"无限制";
    }
    
    NSArray *numberArray = @[Str1,Str2,Str3];
    
    for (int i = 0 ; i < 3 ; i ++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(70 * WideEachUnit, 70 * WideEachUnit, 100 * WideEachUnit, 60 * WideEachUnit)];
        
        if (i == 1) {
            title.frame = CGRectMake(70 * WideEachUnit, 130 * WideEachUnit, 100 * WideEachUnit, 49 * WideEachUnit);
        } else if (i == 2) {
            title.frame = CGRectMake(70 * WideEachUnit, 179 * WideEachUnit, 100 * WideEachUnit, 60 * WideEachUnit);
        }
        
        title.text = titleArray[i];
        title.font = Font(14 * WideEachUnit);
        title.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
        [_buyView addSubview:title];
        
        
        
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(190 * WideEachUnit, 70 * WideEachUnit, 100 * WideEachUnit, 60 * WideEachUnit)];
        
        if (i == 1) {
            number.frame = CGRectMake(190 * WideEachUnit, 130 * WideEachUnit, 100 * WideEachUnit, 49 * WideEachUnit);
        } else if (i == 2) {
            number.frame = CGRectMake(190 * WideEachUnit, 179 * WideEachUnit, 100 * WideEachUnit, 60 * WideEachUnit);
        }
        
        number.text = numberArray[i];
        number.font = Font(14 * WideEachUnit);
        number.textColor = [UIColor colorWithHexString:@"#333"];
        [_buyView addSubview:number];
        
        
    }
    
    
    NSArray *testArray = @[@"练习模式",@"考试模式"];
    
    CGFloat buttonW = 168 * WideEachUnit;
    CGFloat buttonH = 49 * WideEachUnit;
    for (int i  = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonW * i, 239 * WideEachUnit, buttonW, buttonH)];
        [button setTitle:testArray[i] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(eaxmTypeButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    
        if (i == 0) {
            _testButton = button;
            button.backgroundColor = BasidColor;
        } else {
            _examButton = button;
             button.backgroundColor = [UIColor colorWithHexString:@"#f76c59"];
        }
    }
    
    
    //添加横线
    UIButton *lineButton1 = [[UIButton alloc] initWithFrame:CGRectMake(30 * WideEachUnit, 130 * WideEachUnit, 275 * WideEachUnit, 1)];
    lineButton1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_buyView addSubview:lineButton1];
    
    UIButton *lineButton2 = [[UIButton alloc] initWithFrame:CGRectMake(30 * WideEachUnit, 179 * WideEachUnit, 275 * WideEachUnit, 1)];
    lineButton2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_buyView addSubview:lineButton2];
}

#pragma mark --- 网络请求
//考试试题的列表
- (void)netWorkExamsGetPaperList {
    NSString *endUrlStr = YunKeTang_Exams_exams_getPaperList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_moduleID forKey:@"module_id"];
    
    if (_typeID) {
         [mutabDict setObject:_typeID forKey:@"subject_id"];
    }
    if (_moreTypeID == nil) {
        [mutabDict setObject:@"0" forKey:@"level"];
    } else {
        [mutabDict setObject:_moreTypeID forKey:@"level"];
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
        NSDictionary *dict =  [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _dataArray = (NSMutableArray *) [dict arrayValueForKey:@"data"];
            } else {
                _dataArray = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        [_tableView reloadData];
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//考试试题的详情
- (void)netWorkExamsGetPaperInfo {
    NSString *endUrlStr = YunKeTang_Exams_exams_getPaperInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_paper_id"] forKey:@"paper_id"];
    [mutabDict setObject:_examsType forKey:@"exams_type"];

    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    [TKProgressHUD showMessag:@"加载中...." toView:[UIApplication sharedApplication].keyWindow];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([_dataSource dictionaryValueForKey:@"paper_options"].allKeys.count == 0) {
            [TKProgressHUD showError:@"考试数据为空" toView:self.view];
            return ;
        }
        if ([[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions"].allKeys.count == 0) {
            [TKProgressHUD showError:@"考试数据为空" toView:self.view];
            return ;
        }
        if ([_examsType integerValue] == 1) {//练习模式
            TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
            vc.examsType = _examsType;
            vc.dataSource = _dataSource;
            vc.testDict = _testDict;
            [self.navigationController pushViewController:vc animated:YES];
        } else {//考试模式
            TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
            vc.examsType = _examsType;
            vc.dataSource = _dataSource;
            vc.testDict = _testDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [TKProgressHUD showError:@"加载失败" toView:self.view];
    }];
    [op start];
}



#pragma mark --- 配置接口
//检测是否已经绑定了人脸
- (void)netWorkYouTuIsExist {
    NSString *endUrlStr = YunKeTang_YouTu_youtu_isExist;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
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
        }
        if ([[dict stringValueForKey:@"is_exist"] integerValue] == 1) {//已经创建了人脸识别
//            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//            NSString *faceStr = [defaults objectForKey:@"Video_Face"];
//            if ([faceStr isEqualToString:@"face"]) {//说明已经扫过脸了
//                [self netWorkExamsGetPaperInfo];
//            } else {
//                [self isScanFace];
//            }
            [self isScanFace];
        } else if ([[dict stringValueForKey:@"is_exist"] integerValue] == 0) {//还没有创建的 （需要提醒）
            [self isBoundFace];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}

//获取人脸识别的配置接口
- (void)netWorkCongigGetFaceScene {
    NSString *endUrlStr = YunKeTang_config_getFaceScene;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *hexStr = [Passport getHexByDecimal:[timeSp integerValue]];
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,hexStr]];
    [mutabDict setObject:hexStr forKey:@"hextime"];
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
        NSDictionary *sceneDict = [NSDictionary dictionary];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                sceneDict = [dict dictionaryValueForKey:@"data"];
            } else {
                sceneDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        BOOL isScene = NO;
        _getFaceSceneArray = [sceneDict arrayValueForKey:@"open_scene"];
        for (NSString *typeStr in _getFaceSceneArray) {
            if ([typeStr isEqualToString:@"exams"]) {//说明配置的有考试相关的
                isScene = YES;
                [self netWorkYouTuIsExist];
            }
        }
        if (!isScene) {
            [self netWorkExamsGetPaperInfo];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


#pragma mark --- 选择视图
- (void)isScanFace {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此操作需扫脸验证" message:@"是否需要扫脸进行考试？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self faceScan];
    }];
    [alertController addAction:sureAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)isBoundFace {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此操作需扫脸验证" message:@"您还没有绑定您的个人信息，是否开始添加？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self gotoBoundFace];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self NetWorkGetPaperInfo];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark --- 人脸识别登录
- (void)faceScan {
    __weak typeof(self) weakSelf = self;
    DetectionViewController* dvc = [[DetectionViewController alloc] init];
    dvc.completion = ^(NSDictionary* images, UIImage* originImage){
        if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
            NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage* bestImage = [UIImage imageWithData:data];
            NSLog(@"bestImage = %@",bestImage);
            faceImage = bestImage;
            [self netWorkUserUpLoad];
            NSString* bestImageStr = [[images[@"bestImage"] lastObject] copy];
            
            //检测活动的方法
            [[NetAccessModel sharedInstance] detectUserLivenessWithFaceImageStr:bestImageStr completion:^(NSError *error, id resultObject) {
                if (error == nil) {
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
                    if ([dict[@"result_num"] integerValue] > 0) {
                        NSDictionary* d = dict[@"result"][0];
                        NSLog(@"faceliveness = %f",[d[@"face_probability"] floatValue]);
                        if (d[@"faceliveness"] != nil && [d[@"faceliveness"] floatValue] > 0.834963 ) {
                        } else {
                        }
                    }
                }
            }];
        }
    };
    [self presentViewController:dvc animated:YES completion:nil];
    
}


#pragma mark --- 网络请求 (人脸识别的图片上传的接口)
//获得图片的ID
- (void)netWorkUserUpLoad {
    
    NSString *endUrlStr = YunKeTang_Attach_attach_upload;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    NSString *encryptStr1 = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [requestSerializer setValue:encryptStr1 forHTTPHeaderField:HeaderKey];
    [requestSerializer setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    manger.requestSerializer = requestSerializer;
    
    [manger POST:allUrlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *dataImg=UIImageJPEGRepresentation(faceImage, 1.0);
        [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_WithJson:[dict stringValueForKey:@"data"]];
            _faceID = [dict stringValueForKey:@"attach_id"];
            [self netWorkYouTuFaceverify];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark --- 人脸对比
- (void)netWorkYouTuFaceverify {
    NSString *endUrlStr = YunKeTang_YouTu_youtu_faceverify;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_faceID forKey:@"attach_id"];
    
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
            if ([[dict stringValueForKey:@"ismatch"] integerValue] == 1) {
                [[NSUserDefaults standardUserDefaults] setObject:@"face" forKey:@"Video_Face"];
                [self netWorkExamsGetPaperInfo];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


#pragma mark --- 进去人脸识别
- (void)gotoBoundFace {
    Good_PersonFaceRegisterViewController *vc = [[Good_PersonFaceRegisterViewController alloc] init];
    vc.typeStr = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}







@end
