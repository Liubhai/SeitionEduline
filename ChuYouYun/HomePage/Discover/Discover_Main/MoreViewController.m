//
//  MoreViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/12/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "GLReachabilityView.h"
#import "GroupViewController.h"
#import "ExchangeViewController.h"
#import "TempViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "GroupMainViewController.h"
#import "NewsMainViewController.h"
#import "ShoppingViewController.h"
#import "SYG.h"

#import "OfflineMainViewController.h"
#import "TestMainViewController.h"

#import "Good_ClassMainViewController.h"
#import "Good_LibraryViewController.h"
#import "Good_QuestionsAndAnswersMainViewController.h"
#import "CardVoucherMainViewController.h"

#import "ClassMainViewController.h"
#import "Good_InstitutionMainViewController.h"


@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@end

@implementation MoreViewController

- (void)viewWillAppear:(BOOL)animated {
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"App_Key"] == nil) {
        [app netInitApp];
    }
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [GLReachabilityView isConnectionAvailable];
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    navView.backgroundColor = BasidColor;
    [self.view addSubview:navView];
    
    //添加标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, MainScreenWidth, 30)];
    if (iPhoneX) {
        titleLabel.frame = CGRectMake(0, 45, MainScreenWidth, 30);
    }
    titleLabel.text = @"发现";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    [navView addSubview:titleLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80, 20, 50, 50)];
    button.backgroundColor = [UIColor redColor];
    [navView addSubview:button];
    [button addTarget:self action:@selector(buttonCilck) forControlEvents:UIControlEventTouchUpInside];
    button.hidden = YES;
    
    
    //添加表格视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, MainScreenWidth, MainScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88 - 83);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,16)];
    }
}


- (void)buttonCilck {
    OfflineMainViewController *vc = [[OfflineMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 3) {
        if ([HASJIANGREN isEqualToString:@"0"]) {
            return 1;
        } else {
            return 2;
        }
    } else if (section == 2) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSArray *titleArray = @[@"资讯",@"商城",@"考试",@"文库",@"问答",@"小组",@"临时"];
    NSArray *titleArray = @[@"线下课",@"资讯",@"商城",@"考试",@"文库",@"问答",@"卡券",@"套餐",@"机构"];
    NSArray *imageArray = @[@"线下课",@"资讯",@"商 城 (2)",@"考试(3)",@"文库",@"问答(4)",@"卡券(3)",@"发现_小组",@"faxian_organization"];
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MoreTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSInteger indexSet = indexPath.section;
    NSInteger indexRow = indexPath.row;
    
    if (indexSet == 0) {
        [cell.SYGButton setBackgroundImage:[UIImage imageNamed:imageArray[indexRow]] forState:UIControlStateNormal];
        cell.SYGLabel.text = titleArray[indexRow];
    } else if (indexSet == 1) {
        [cell.SYGButton setBackgroundImage:[UIImage imageNamed:imageArray[indexRow + 1]] forState:UIControlStateNormal];
        cell.SYGLabel.text = titleArray[indexRow+ 1];
    } else if (indexSet == 2) {
        [cell.SYGButton setBackgroundImage:[UIImage imageNamed:imageArray[indexRow + 3]] forState:UIControlStateNormal];
        cell.SYGLabel.text = titleArray[indexRow + 3];
    } else if (indexSet == 3) {
        [cell.SYGButton setBackgroundImage:[UIImage imageNamed:imageArray[indexRow + 5]] forState:UIControlStateNormal];
        cell.SYGLabel.text = titleArray[indexRow + 5];
    } else if (indexSet == 4) {
        [cell.SYGButton setBackgroundImage:[UIImage imageNamed:imageArray[indexRow + 7]] forState:UIControlStateNormal];
        cell.SYGLabel.text = titleArray[indexRow + 7];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//表格箭头的样式
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 20;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0 * WideEachUnit;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger indexSet = indexPath.section;
    NSInteger indexRow = indexPath.row;
    
    if (indexSet == 1) {//第一列
        if (indexRow == 0) {//资讯
            NewsMainViewController *newsMainVc = [[NewsMainViewController alloc] init];
            [self.navigationController pushViewController:newsMainVc animated:YES];
        } else { //积分商城
            ShoppingViewController *shopVc = [[ShoppingViewController alloc] init];
            [self.navigationController pushViewController:shopVc animated:YES];
        }
        
    } else if (indexSet == 2) {

        if (indexRow == 0) {//在线考试
            TestMainViewController *vc = [[TestMainViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {//文库
//            LibraryViewController *libVc = [[LibraryViewController alloc] init];
//            [self.navigationController pushViewController:libVc animated:YES];
            
            Good_LibraryViewController *vc = [[Good_LibraryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexSet == 3) {
        if (indexRow == 0) {//问答
//            YunKeTang_questionViewController *vc = [[YunKeTang_questionViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            
            Good_QuestionsAndAnswersMainViewController *vc = [[Good_QuestionsAndAnswersMainViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {//小组
//            GroupMainViewController *groupMainVc = [[GroupMainViewController alloc] init];
//            [self.navigationController pushViewController:groupMainVc animated:YES];
            
            CardVoucherMainViewController *vc = [[CardVoucherMainViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }

    } else if (indexSet == 4) {//临时
        if (indexRow == 0) {
            ClassMainViewController *exchangeV = [[ClassMainViewController alloc]init];//TempViewController
            [self.navigationController pushViewController:exchangeV animated:YES];
        } else {
            Good_InstitutionMainViewController *homeInStVc = [[Good_InstitutionMainViewController alloc] init];
            [self.navigationController pushViewController:homeInStVc animated:YES];
        }
    } else if (indexSet == 0) {
        OfflineMainViewController *vc = [[OfflineMainViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}




@end
