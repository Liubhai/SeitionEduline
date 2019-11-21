//
//  TestMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/25.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestMainViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "BigWindCar.h"

#import "TestMainTableViewCell.h"
#import "TestClassMainViewController.h"


@interface TestMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSArray     *dataArray;
@property (strong ,nonatomic)NSArray     *titleArray;
@property (strong ,nonatomic)NSArray     *contentArray;
@property (strong ,nonatomic)NSArray     *imageArray;


@end

@implementation TestMainViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
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
    //    [self addTableHeaderView];
    [self addTableView];
    [self netWorkExamsGetMoudles];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//    _titleArray = @[@"知识练习",@"模拟考试",@"能力评测"];
//    _contentArray = @[@"两种做题模式适应您的选择",@"真题在线模拟",@"综合测评掌握自己学习情况"];
//    _imageArray = @[@"practice@3x",@"exam@3x",@"test@3x"];
    
    
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


#pragma mark ----- 

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 64, MainScreenWidth - 20 * WideEachUnit, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(10, 88, MainScreenWidth, MainScreenHeight - 88);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 130 * WideEachUnit;
    [self.view addSubview:_tableView];
    
}


#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1 * WideEachUnit;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = nil;
    CellIdentifier = [NSString stringWithFormat:@"cell - %ld",indexPath.row];
    //自定义cell类
    TestMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TestMainTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    cell.titleLabel.text = [[_dataArray objectAtIndex:indexPath.section] stringValueForKey:@"title"];
    cell.contentLabel.text =  [[_dataArray objectAtIndex:indexPath.section] stringValueForKey:@"description"];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[[_dataArray objectAtIndex:indexPath.section] stringValueForKey:@"icon"]] placeholderImage:Image(@"站位图")];
//    NSDictionary *dict = _dataArray[indexPath.row];
//    [cell dataSourceWith:dict];
//    if (indexPath.section == 0) {
//        cell.titleLabel.text = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"title"];
//        cell.contentLabel.text =  [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"description"];
//        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"icon"]] placeholderImage:Image(@"站位图")];
//    } else if (indexPath.section == 1) {
//        cell.titleLabel.text = [[_dataArray objectAtIndex:indexPath.row + 1] stringValueForKey:@"title"];
//        cell.contentLabel.text =  [[_dataArray objectAtIndex:indexPath.row + 1] stringValueForKey:@"description"];
//        cell.headImageView.image = Image(_imageArray[indexPath.row + 1]);
//        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[[_dataArray objectAtIndex:indexPath.row + 1] stringValueForKey:@"icon"]] placeholderImage:Image(@"站位图")];
//    } else if (indexPath.section == 2) {
//        cell.titleLabel.text = [[_dataArray objectAtIndex:indexPath.row + 2] stringValueForKey:@"title"];
//        cell.contentLabel.text =  [[_dataArray objectAtIndex:indexPath.row + 2] stringValueForKey:@"description"];
//        cell.headImageView.image = Image(_imageArray[indexPath.row]);
//        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[[_dataArray objectAtIndex:indexPath.row + 2] stringValueForKey:@"icon"]] placeholderImage:Image(@"站位图")];
//    } else if (indexPath.section == 3) {
//        cell.titleLabel.text = [[_dataArray objectAtIndex:indexPath.row + 3] stringValueForKey:@"title"];
//        cell.contentLabel.text =  [[_dataArray objectAtIndex:indexPath.row + 3] stringValueForKey:@"description"];
//        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[[_dataArray objectAtIndex:indexPath.row + 3] stringValueForKey:@"icon"]] placeholderImage:Image(@"站位图")];
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    TestClassMainViewController *vc = [[TestClassMainViewController alloc] init];
    vc.moduleID = [[_dataArray objectAtIndex:indexPath.section] stringValueForKey:@"exams_module_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 网络请求
//考试模块的分类
- (void)netWorkExamsGetMoudles {
    NSString *endUrlStr = YunKeTang_Exams_exams_getMoudles;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"50" forKey:@"count"];
    
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
                 _dataArray = (NSArray *) [dict arrayValueForKey:@"data"];
            } else {
                 _dataArray = (NSArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
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





@end
