//
//  Good_MyClassDownViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/6/4.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_MyClassDownViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "ZFDownloadManager.h"
#import "Good_ClassDownViewController.h"
#import "ClassRevampCell.h"

#import "BRDownFileCacheManager.h"

#import "BRCourseDownInfoTableViewCell.h"

@interface Good_MyClassDownViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView       *tableView;
@property (strong ,nonatomic)UIImageView       *imageView;

@property (strong ,nonatomic)NSMutableArray    *dataArray;
@property (strong ,nonatomic)NSMutableArray    *downloadObjectArr;
@property (nonatomic, strong)ZFDownloadManager *downloadManage;
@property (strong ,nonatomic)NSArray           *sectionTitleArray;

@end

@implementation Good_MyClassDownViewController
//
//- (ZFDownloadManager *)downloadManage
//{
//    if (!_downloadManage) {
//        _downloadManage = [ZFDownloadManager sharedDownloadManager];
//    }
//    return _downloadManage;
//}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34)];
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
    [BRDownFileCacheManager manager];
    [self initer];
    [self addNav];
    [self addTableView];
    [self getDataSource];
}

- (void)initer {
    _dataArray = [NSMutableArray array];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"我的课程";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
}

#pragma mark --- UITableView

- (void)addTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1];
    self.tableView.userInteractionEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 110;
    [self.view addSubview:self.tableView];
    
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1 * WideEachUnit;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BRCourseDownInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BRCourseDownInfoTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BRCourseDownInfoTableViewCell" owner:self options:nil] firstObject];
        cell.hadDownLabel.text = nil;
        
    }
    NSDictionary *_videoDataSource = _dataArray[indexPath.row];
    NSString *video_title = [_videoDataSource stringValueForKey:@"video_title"];
    cell.mNameLabel.text = video_title;
    NSString *urlStr = [_videoDataSource stringValueForKey:@"cover"];
    [cell.mImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    NSString * section_count =  [_videoDataSource stringValueForKey:@"section_count"];
    cell.totalCourseLabel.text = [NSString stringWithFormat:@"共%@节",section_count];
    return cell;
    //    static NSString * cellStr = @"SYGClassTableViewCell";
    //    ClassRevampCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    //    if (cell == nil) {
    //        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:cellStr];
    //    }
    //
    ////    NSDictionary *dict = self.downloadObjectArr[indexPath.section][indexPath.row];
    ////    [cell dataWithDict:dict withType:@"1"];
    //    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    //    [cell dataWithDict:dict withType:@"3"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Good_ClassDownViewController *vc = [[Good_ClassDownViewController alloc] init];
    vc.videoDataSource = [_dataArray objectAtIndex:indexPath.row];
    vc.isDown = @"1";
    vc.isClassCourse = [[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] integerValue] == 6 ? YES : NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 事件点击
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 得到数据源
- (void)getDataSource {
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSMutableArray *saveDataSource = (NSMutableArray *)[userDefaults objectForKey:YunKeTang_VideoDataSource];
    //    _dataArray = saveDataSource;
    NSArray *temp = [[BRDownFileCacheManager manager] classWithDic:nil];
    _dataArray = temp;
    [_tableView reloadData];
    if (_dataArray.count == 0) {
        self.imageView.hidden = NO;
    } else {
        self.imageView.hidden = YES;
    }
}





@end
