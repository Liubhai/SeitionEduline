//
//  XZViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/12/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "XZViewController.h"
#import "ZFDownloadManager.h"
#import "ZFPlayerModel.h"
#import "SYG.h"

@interface XZViewController ()

@property (strong ,nonatomic)UIButton *seletButton;

@property (strong ,nonatomic)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation XZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initer];
    [self titleSet];
    
}

- (void)initer {
    self.navigationItem.title = @"下载";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加清除按钮
    UIButton *QCButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [QCButton setTitle:@"清除" forState:UIControlStateNormal];
    [QCButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [QCButton addTarget:self action:@selector(QCPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:QCButton];
    [self.navigationItem setRightBarButtonItem:back];
    [self addZKView];
    [self addTableView];
    
    
}

- (void)addZKView {
    
    UIView *ZKView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 40)];
    ZKView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ZKView];
    
    //添加中间的线
    UILabel *FGLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 0.5, 10, 1, 20)];
    FGLabel.backgroundColor = [UIColor lightGrayColor];
    [ZKView addSubview:FGLabel];
    
    
    NSArray *titleArray = @[@"专辑",@"课程"];
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 -100 + i * 100, 0, 100, 40)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ZKButton:) forControlEvents:UIControlEventTouchUpInside];
        [ZKView addSubview:button];
        if (i == 0) {
            [self ZKButton:button];
        }
    }
}

- (void)ZKButton:(UIButton *)button {
    self.seletButton.selected = NO;
    button.selected = YES;
    self.seletButton = button;
}


- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, MainScreenWidth, MainScreenHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithRed:243.f / 255 green:244.f / 255 blue:245.f / 255 alpha:1];
    [self.view addSubview:_tableView];
    
}

- (void)titleSet {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:44.f / 255 green:132.f / 255 blue:214.f / 255 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
}
- (void)requestData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videoData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.dataSource = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"videoList"];
    for (NSDictionary *dataDic in videoList) {
        ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic];
        [self.dataSource addObject:model];
    }
    
}
- (void)QCPressed {
    
}

@end
