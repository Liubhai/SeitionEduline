//
//  MyInstationViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/10.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "MyInstationViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

#import "InstitutionListCell.h"
#import "MoreTableViewCell.h"
#import "InstitutionMainViewController.h"
#import "InstCourseViewController.h"

#import "ApplyInsViewController.h"
#import "InstationOrderViewController.h"




@interface MyInstationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL isSele;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)UIButton *stausButton;
@property (strong ,nonatomic)UIButton *titleButton;
@property (strong ,nonatomic)UIView   *allWindowView;

@property (strong ,nonatomic)NSString *classTypeStr;
@property (strong ,nonatomic)NSArray  *indexTitleArray;
@end

@implementation MyInstationViewController

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
    [self addButtonView];
    [self netWorkUserGetMySchoolStatus];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    _titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    _titleText.text = @"我的机构";
    [_titleText setTextColor:[UIColor whiteColor]];
    _titleText.textAlignment = NSTextAlignmentCenter;
    _titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:_titleText];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        _titleText.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
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
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    _tableView.hidden = YES;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}


- (void)addButtonView {
    _stausButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 90, MainScreenWidth - 100, 40)];
    _stausButton.center = self.view.center;
    _stausButton.layer.cornerRadius = 5;
    _stausButton.backgroundColor = [UIColor redColor];
    [_stausButton addTarget:self action:@selector(stausButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stausButton];
    _stausButton.hidden = YES;
    
}

#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    
    NSArray *imageArray = @[@"org_home@3x",@"org_order@3x"];
//       NSArray *imageArray = @[@"org_home@3x",@"org_class@3x",@"org_order@3x"];
    NSArray *titleArray = @[@"主页",@"机构订单"];
//        NSArray *titleArray = @[@"主页",@"排课",@"机构订单"];
    
    //自定义cell类
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MoreTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    [cell.SYGButton setBackgroundImage:Image(imageArray[indexPath.row]) forState:UIControlStateNormal];
    cell.SYGLabel.text = titleArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    
    if (indexPath.row == 0) {
        InstitutionMainViewController *institionMainVc = [[InstitutionMainViewController alloc] init];
        institionMainVc.schoolID = _schoolID;
        [self.navigationController pushViewController:institionMainVc animated:YES];
    } else if (indexPath.row == 1) {
//        InstCourseViewController *instCourseVc = [[InstCourseViewController alloc] init];
//        instCourseVc.schoolID = _schoolID;
//        [self.navigationController pushViewController:instCourseVc animated:YES];
        
        InstationOrderViewController *instOrderVc = [[InstationOrderViewController alloc] init];
        instOrderVc.schoolID = _schoolID;
        [self.navigationController pushViewController:instOrderVc animated:YES];
    } else if (indexPath.row == 2) {
        InstationOrderViewController *instOrderVc = [[InstationOrderViewController alloc] init];
        [self.navigationController pushViewController:instOrderVc animated:YES];
    }
    
}


#pragma mark --- 事件监听
- (void)stausButtonClick {
    ApplyInsViewController *applyInsVc = [[ApplyInsViewController alloc] init];
    [self.navigationController pushViewController:applyInsVc animated:YES];
}

#pragma mark --- 网络请求
- (void)netWorkUserGetMySchoolStatus {
    
    NSString *endUrlStr = YunKeTang_User_school_getMySchoolStatus;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"0" forKey:@"doc_category_id"];
    
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
        NSDictionary *statusDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        _statusStr = [statusDict stringValueForKey:@"status"];
        _schoolID = [statusDict stringValueForKey:@"id"];
        
        //存到本地
        [[NSUserDefaults standardUserDefaults] setObject:_schoolID forKey:@"schoolID"];
        
        if ([_statusStr integerValue] == -1) {//未提交或失败
            [_stausButton setTitle:@"还不是机构，去申请吧" forState:UIControlStateNormal];
            _tableView.hidden = YES;
            _stausButton.hidden = NO;
        } else if ([_statusStr integerValue] == 0) {//提交 但未审核
            [_stausButton setTitle:@"已提交，待审核" forState:UIControlStateNormal];
            _tableView.hidden = YES;
            _stausButton.hidden = NO;
            _stausButton.enabled = NO;
        } else if ([_statusStr integerValue] == 1) {//通过了
            _tableView.hidden = NO;
            _stausButton.hidden = YES;
        } else if ([_statusStr integerValue] == 2) {//禁用
            [_stausButton setTitle:@"被禁用，用不了啦" forState:UIControlStateNormal];
            _tableView.hidden = YES;
            _stausButton.hidden = NO;
        } else if ([_statusStr integerValue] == 3) {//没有通过
            [_stausButton setTitle:@"没有通过,请重新申请" forState:UIControlStateNormal];
            _tableView.hidden = YES;
            _stausButton.hidden = NO;
        }
     [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}






@end
