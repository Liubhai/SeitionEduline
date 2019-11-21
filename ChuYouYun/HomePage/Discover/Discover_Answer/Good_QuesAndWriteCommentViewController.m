//
//  Good_QuesAndWriteCommentViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/19.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_QuesAndWriteCommentViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"

#import "Good_QuesAndWriteCommentTableViewCell.h"

@interface Good_QuesAndWriteCommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView       *tableView;
@property (strong ,nonatomic)UIView            *downView;

@property (strong ,nonatomic)NSArray           *dataArray;

@end

@implementation Good_QuesAndWriteCommentViewController


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
    [self addDownView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"评论";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
}

#pragma mark --- 表格
- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 44 * WideEachUnit, MainScreenWidth, 44 * WideEachUnit)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加输入框
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 5 * WideEachUnit, MainScreenWidth - 120 * WideEachUnit, 34 * WideEachUnit)];
    textField.placeholder = @"添加评论";
    textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [textField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    textField.layer.cornerRadius = 3 ;
    [_downView addSubview:textField];
    
    //添加发送的按钮
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, 5 * WideEachUnit, 80 * WideEachUnit, 34 * WideEachUnit)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.layer.cornerRadius = 3;
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = Font(15 * WideEachUnit);
    sendButton.backgroundColor = BasidColor;
    [_downView addSubview:sendButton];
}
#pragma mark --- UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44 * WideEachUnit;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 44 * WideEachUnit)];
    view.backgroundColor = [UIColor whiteColor];
    
    //添加文本
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth / 2 , 44 * WideEachUnit)];
    label.text = @"3条评论";
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"#333"];
    [view addSubview:label];
    
    //添加按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, 0, 80 * WideEachUnit, 44 * WideEachUnit)];
    [button setTitle:@"默认排序" forState:UIControlStateNormal];
    [button setImage:Image(@"") forState:UIControlStateNormal];
    button.titleLabel.font = Font(12 * WideEachUnit);
    [button setTitleColor:[UIColor colorWithHexString:@"#666"] forState:UIControlStateNormal];
    [view addSubview:button];
    
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130 * WideEachUnit;
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"WDTableViewCell";
    Good_QuesAndWriteCommentTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];

    if (cell == nil) {
        cell = [[Good_QuesAndWriteCommentTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [cell dataWithDict:dict];
    return cell;
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    Good_QuesAndCommentDetailViewController *vc = [[Good_QuesAndCommentDetailViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark --- 事件点击
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
