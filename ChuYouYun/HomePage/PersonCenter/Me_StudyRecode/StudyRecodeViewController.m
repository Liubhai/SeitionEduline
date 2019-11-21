//
//  StudyRecodeViewController.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/12.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "StudyRecodeViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "TKProgressHUD+Add.h"

#import "StudyRecodeTableViewCell.h"
#import "Good_ClassMainViewController.h"
#import "DLViewController.h"

@interface StudyRecodeViewController ()<UITableViewDelegate, UITableViewDataSource> {
    BOOL tableViewEditing;
    NSInteger page;
    NSString *learnTime;
    NSString *learnStatus;
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UISwitch *daySwitch;
@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UISwitch *moreSwitch;
@property (strong, nonatomic) UILabel *moreLabel;
@property (strong, nonatomic) UISwitch *passSwitch;
@property (strong, nonatomic) UILabel *passLabel;

@property (strong ,nonatomic)UIImageView *imageView;

//数据源
@property (strong, nonatomic) NSMutableArray *dataSource;
//时间断点
@property (strong ,nonatomic)NSMutableArray *timeArray;
//处理后排序的数据源
@property (strong ,nonatomic)NSMutableArray *allDateArray;

@property (strong ,nonatomic)UIView         *downView;
@property (strong ,nonatomic)UIButton       *allseleButton;
@property (strong ,nonatomic)UIButton       *sureButton;
@property (strong ,nonatomic)NSMutableArray *seleIDArray;//选中的ID的数组

@end

@implementation StudyRecodeViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
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
    _dataSource = [NSMutableArray new];
    _timeArray = [NSMutableArray new];
    _allDateArray = [NSMutableArray new];
    _seleIDArray = [NSMutableArray new];
    learnTime = @"0";// 默认全部 0  三天以内 1 更早 2
    learnStatus = @"0"; // 默认全部 0 过滤已看完 1
    page = 1;
    tableViewEditing = NO;
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"学习记录";
    [_rightButton setTitle:@"编辑" forState:0];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:0];
    _rightButton.hidden = NO;
    [self makeTopViews];
    [self makeTableView];
    [self addDownView];
    [self getFirstPageData];
}

- (void)makeTopViews {
    
    CGFloat space = (MainScreenWidth - 30 - (30 + 5 + 70) * 3) / 3.0;
    CGFloat switchSpace = space + 5 + 70;
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 54)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    _daySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(5, 0, 100, 20)];
    _daySwitch.tag = 111;
    _daySwitch.onTintColor = BasidColor;
    _daySwitch.tintColor = RGBHex(0xC9C9C9);
    _daySwitch.backgroundColor = RGBHex(0xC9C9C9);
    _daySwitch.thumbTintColor = [UIColor whiteColor];
    [_daySwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [_topView addSubview:_daySwitch];
    [_daySwitch setSize:_daySwitch.size];
    _daySwitch.centerY = _topView.height / 2.0;
    _daySwitch.transform = CGAffineTransformMakeScale(30/51.0, 30/51.0);
    _daySwitch.layer.masksToBounds = YES;
    _daySwitch.layer.cornerRadius = 15;
    
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(_daySwitch.right + 5, 0, 90 - 21, 20)];
    _dayLabel.font = SYSTEMFONT(14);
    _dayLabel.textColor = RGBHex(0x7A7A7A);
    _dayLabel.text = @"三天以内";
    _dayLabel.centerY = _daySwitch.centerY;
    [_topView addSubview:_dayLabel];
    
    _moreSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_daySwitch.right + switchSpace, _daySwitch.top, _daySwitch.width, _daySwitch.height)];
    _moreSwitch.tag = 112;
    _moreSwitch.onTintColor = BasidColor;
    _moreSwitch.layer.masksToBounds = YES;
    _moreSwitch.tintColor = RGBHex(0xC9C9C9);
    _moreSwitch.backgroundColor = RGBHex(0xC9C9C9);
    _moreSwitch.thumbTintColor = [UIColor whiteColor];
    _moreSwitch.layer.cornerRadius = 15;
    _moreSwitch.transform = CGAffineTransformMakeScale(30/51.0, 30/51.0);
    _moreSwitch.centerY = _daySwitch.centerY;
    [_moreSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [_topView addSubview:_moreSwitch];
    
    _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(_moreSwitch.right + 5, _dayLabel.top, 90 - 21, 20)];
    _moreLabel.font = SYSTEMFONT(14);
    _moreLabel.textColor = RGBHex(0x7A7A7A);
    _moreLabel.text = @"更早";
    [_topView addSubview:_moreLabel];
    
    _passSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_moreSwitch.right + switchSpace, _daySwitch.top, _daySwitch.width, _daySwitch.height)];
    _passSwitch.tag = 113;
    _passSwitch.onTintColor = BasidColor;
    _passSwitch.layer.masksToBounds = YES;
    _passSwitch.tintColor = RGBHex(0xC9C9C9);
    _passSwitch.backgroundColor = RGBHex(0xC9C9C9);
    _passSwitch.thumbTintColor = [UIColor whiteColor];
    _passSwitch.layer.cornerRadius = 15;
    _passSwitch.transform = CGAffineTransformMakeScale(30/51.0, 30/51.0);
    _passSwitch.centerY = _daySwitch.centerY;
    [_passSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [_topView addSubview:_passSwitch];
    
    _passLabel = [[UILabel alloc] initWithFrame:CGRectMake(_passSwitch.right + 5, _dayLabel.top, MainScreenWidth - _passSwitch.right - 5, 20)];
    _passLabel.font = SYSTEMFONT(14);
    _passLabel.textColor = RGBHex(0x7A7A7A);
    _passLabel.text = @"展示全部";
    [_topView addSubview:_passLabel];
    
}

- (void)makeTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + _topView.height, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - _topView.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 67 + 10;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    [self.view addSubview:_tableView];
}

- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50 - MACRO_UI_SAFEAREA, MainScreenWidth, 50 + MACRO_UI_SAFEAREA)];
    
    _downView.backgroundColor = [UIColor whiteColor];
    _downView.layer.shadowColor = RGBHex(0x737373).CGColor;
    //剪切边界 如果视图上的子视图layer超出视图layer部分就截取掉 如果添加阴影这个属性必须是NO 不然会把阴影切掉
    //阴影半径，默认3
    _downView.layer.shadowRadius = 3;
    //shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    _downView.layer.shadowOffset = CGSizeMake(0.0f,-3.0f);
    // 阴影透明度，默认0
    _downView.layer.shadowOpacity = 0.2f;
    [self.view addSubview:_downView];
    _downView.hidden = YES;
    
    CGFloat downWidth = (MainScreenWidth - 1) / 2.0;
    
    //添加按钮
    _allseleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, downWidth , 50)];
    [_allseleButton setTitle:@"全选" forState:UIControlStateNormal];
    [_allseleButton setTitleColor:RGBHex(0x575757) forState:0];
    [_downView addSubview:_allseleButton];
    [_allseleButton addTarget:self action:@selector(allSeleButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_allseleButton.right, 0, 1, 24)];
    line.backgroundColor = RGBHex(0xEEEEEE);
    line.centerY = _allseleButton.height / 2.0;
    [_downView addSubview:line];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(line.right, 0, downWidth , 50)];
    [_sureButton setTitle:@"取消删除" forState:UIControlStateNormal];
    [_sureButton setTitleColor:RGBHex(0xF86515) forState:0];
    [_downView addSubview:_sureButton];
    [_sureButton addTarget:self action:@selector(sureButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)headerRefresh {
    page = 1;
    [self getFirstPageData];
}

- (void)footerRefresh {
    page = page + 1;
}

- (void)switchIsChanged:(UISwitch *)sender {
    if (sender.tag == 113) {
        _passLabel.text = sender.on ? @"过滤已看完" : @"展示全部";
        learnStatus = sender.on ? @"1" : @"0";
    } else if (sender.tag == 111) {
        if (sender.on) {
            _moreSwitch.on = NO;
            learnTime = @"1";
        } else {
            if (_moreSwitch.on) {
                learnTime = @"2";
            } else {
                learnTime = @"0";
            }
        }
    } else if (sender.tag == 112) {
        if (sender.on) {
            _daySwitch.on = NO;
            learnTime = @"2";
        } else {
            if (_daySwitch.on) {
                learnTime = @"1";
            } else {
                learnTime = @"0";
            }
        }
    }
    tableViewEditing = NO;
    [_rightButton setTitle:tableViewEditing ?  @"取消" : @"编辑" forState:0];
    _downView.hidden = !tableViewEditing;
    [_tableView setHeight:tableViewEditing ? (MainScreenHeight - MACRO_UI_UPHEIGHT - _topView.height - _downView.height) : (MainScreenHeight - MACRO_UI_UPHEIGHT - _topView.height)];
    if (!tableViewEditing) {
        [_seleIDArray removeAllObjects];
    }
    [_tableView reloadData];
    [self getFirstPageData];
}

- (void)rightButtonClick:(id)sender {
    tableViewEditing = !tableViewEditing;
    [_rightButton setTitle:tableViewEditing ?  @"取消" : @"编辑" forState:0];
    _downView.hidden = !tableViewEditing;
    [_tableView setHeight:tableViewEditing ? (MainScreenHeight - MACRO_UI_UPHEIGHT - _topView.height - _downView.height) : (MainScreenHeight - MACRO_UI_UPHEIGHT - _topView.height)];
    if (!tableViewEditing) {
        [_seleIDArray removeAllObjects];
    }
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12 + 12 + 13;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 37)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(15, 12, 2, 13)];
    blueView.backgroundColor = BasidColor;
    [headerView addSubview:blueView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(blueView.right + 7, 0, MainScreenWidth - blueView.right - 7, 37)];
    timeLabel.font = SYSTEMFONT(11);
    timeLabel.textColor = RGBHex(0x1D1D1D);
    [headerView addSubview:timeLabel];
    timeLabel.text = [NSString stringWithFormat:@"%@",_timeArray[section]];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _timeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_allDateArray.count == 0) {
        return 0;
    }
    NSArray *array = _allDateArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *recodeCell = @"recodeCell";
    StudyRecodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recodeCell];
    if (!cell) {
        cell = [[StudyRecodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recodeCell];
    }
    NSString *recordId = [NSString stringWithFormat:@"%@",[_allDateArray[indexPath.section][indexPath.row] objectForKey:@"record_id"]];
    [cell setStudyRecodeInfo:_allDateArray[indexPath.section][indexPath.row] editing:tableViewEditing selected:[_seleIDArray containsObject:recordId]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableViewEditing) {
        StudyRecodeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *recordId = [NSString stringWithFormat:@"%@",[_allDateArray[indexPath.section][indexPath.row] objectForKey:@"record_id"]];
        if ([_seleIDArray containsObject:recordId]) {
            [_seleIDArray removeObject:recordId];
            cell.editingButton.selected = NO;
        } else {
            [_seleIDArray addObject:recordId];
            cell.editingButton.selected = YES;
        }
        NSString *sureStr = [NSString stringWithFormat:@"确定删除(%@)",@(_seleIDArray.count)];
        if (_seleIDArray.count == 0) {
            sureStr = @"取消删除";
        }
        [_sureButton setTitle:sureStr forState:UIControlStateNormal];
    } else {
        if ([HASALIPAY isEqualToString:@"0"]) {
            if (!UserOathToken) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
                alert.tag = 100;
                [alert show];
                return;
            }
        }
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        NSDictionary *dict = _allDateArray[indexPath.section][indexPath.row];
        vc.ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"vid"]];
        vc.videoTitle = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"video_info"] objectForKey:@"video_title"]];
        vc.sid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sid"]];
        vc.isClassNew = ([[[dict objectForKey:@"video_info"] objectForKey:@"type"] integerValue] == 6 ? YES : NO);
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)getFirstPageData {
    NSString *endUrlStr = YunKeTang_User_user_getRecordList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    [mutabDict setValue:@(page) forKey:@"page"];
    [mutabDict setObject:learnTime forKey:@"learn_time"];
    [mutabDict setObject:learnStatus forKey:@"status"];
    
    NSString *lll = nil;
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        lll = oath_token_Str;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:lll forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
        }
        if (_dataSource.count == 0) {
            //添加空白处理
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        if (_dataSource.count < 20) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        //处理数据
        if (_dataSource.count == 0) {
            return;
        } else {
            [_timeArray removeAllObjects];
            [_allDateArray removeAllObjects];
            [self dealDataSource];
        }
        [_tableView headerEndRefreshing];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [_tableView headerEndRefreshing];
    }];
    [op start];
}

- (void)getMoreData {
    NSString *endUrlStr = YunKeTang_User_user_getRecordList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    [mutabDict setValue:@(page) forKey:@"page"];
    [mutabDict setObject:learnTime forKey:@"learn_time"];
    [mutabDict setObject:learnStatus forKey:@"status"];
    
    NSString *lll = nil;
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        lll = oath_token_Str;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:lll forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        NSMutableArray *pass = [NSMutableArray new];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [pass addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
            [_dataSource addObjectsFromArray:pass];
        } else {
            page--;
        }
        if (_dataSource.count == 0) {
            //添加空白处理
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        if (pass.count < 20) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        //处理数据
        if (_dataSource.count == 0) {
            return;
        } else {
            [_timeArray removeAllObjects];
            [_allDateArray removeAllObjects];
            [self dealDataSource];
        }
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        page--;
        [_tableView footerEndRefreshing];
    }];
    [op start];
}


#pragma mark --- 处理数据
- (void)dealDataSource {
    
    NSMutableArray *_titleTimeArray = [NSMutableArray new];
    
    for (int i = 0 ; i < _dataSource.count ; i ++) {
        [Passport formatterDate:_dataSource[i][@"ctime"]];
        NSString *timeStr =  [Passport formatterDate:_dataSource[i][@"ctime"]];
        [_titleTimeArray addObject:timeStr];
    }
    
    NSMutableArray *timeArray = [NSMutableArray array];
    NSMutableArray *numArray = [NSMutableArray array];
    
    for (int i = 0 ; i < _titleTimeArray.count ; i ++) {
        NSString *timeStr = _titleTimeArray[i];
        if (![timeArray containsObject:timeStr]) {
            [timeArray addObject:timeStr];
        } else {
            NSLog(@"%d",i);
            [numArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    _timeArray = timeArray;
    
    NSMutableArray *array= [NSMutableArray arrayWithArray:_dataSource];
    
    NSMutableArray*dateMutablearray = [@[]mutableCopy];
    for(int i = 0;i < array.count;i ++) {
        
        NSDictionary *dict1 = array[i];
        
        NSMutableArray*tempArray = [@[]mutableCopy];
        
        [tempArray addObject:dict1];
        
        for(int j = i+1;j < array.count;j ++) {
            
            NSDictionary *dict2 = array[j];
            
            NSString *day1 = [Passport formatterDate:dict1[@"ctime"]];
            NSString *day2 = [Passport formatterDate:dict2[@"ctime"]];
            
            if([ day1 isEqualToString:day2]){
                
                [tempArray addObject:dict2];
                
                [array removeObjectAtIndex:j];
                
                j -= 1;
                
            }
        }
        [dateMutablearray addObject:tempArray];
    }
    _allDateArray = dateMutablearray;
    [_tableView reloadData];
}

// MARK: - 删除选中的记录
- (void)netWorkUserUserDeleteRecord {
    
    NSString *endUrlStr = YunKeTang_User_user_deleteRecord;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //串联ID
    NSString *classIDS = nil;
    for (int i = 0 ; i < _seleIDArray.count ; i++) {
        if (i == 0) {
            classIDS = _seleIDArray[0];
        } else {
            classIDS = [NSString stringWithFormat:@"%@,%@",classIDS,_seleIDArray[i]];
        }
        
    }
    
    
    NSLog(@"%@",_seleIDArray);
    //清空数组
    [_seleIDArray removeAllObjects];
    
    
    NSLog(@"----%@",classIDS);
    [mutabDict setValue:classIDS forKey:@"sid"];
    
    NSString *lll = nil;
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        lll = oath_token_Str;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:lll forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [self getFirstPageData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}

- (void)allSeleButtonCilck {
    NSLog(@"%@",_allDateArray);
    if ([_allseleButton.titleLabel.text isEqualToString:@"全选"]) {
        for (int i = 0; i < _allDateArray.count; i++) {
            for (int j = 0; j < [_allDateArray[i] count]; j++) {
                NSString *recordId = [NSString stringWithFormat:@"%@",[_allDateArray[i][j] objectForKey:@"record_id"]];
                if ([_seleIDArray containsObject:recordId]) {
                    continue;
                } else {
                    [_seleIDArray addObject:recordId];
                }
            }
        }
        [_allseleButton setTitle:@"取消全选" forState:UIControlStateNormal];
        NSString *allStr = [NSString stringWithFormat:@"确认删除(%ld)",_seleIDArray.count];
        [_sureButton setTitle:allStr forState:UIControlStateNormal];
    } else if ([_allseleButton.titleLabel.text isEqualToString:@"取消全选"]) {
        [_seleIDArray removeAllObjects];
        [_allseleButton setTitle:@"全选" forState:UIControlStateNormal];
        [_sureButton setTitle:@"取消删除" forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}

- (void)sureButtonCilck {
    if (!_seleIDArray.count) {
        tableViewEditing = NO;
    } else {//有选择的时候 (确认删除然后网络请求操作)
        [self netWorkUserUserDeleteRecord];
    }
    [_rightButton setTitle:tableViewEditing ?  @"取消" : @"编辑" forState:0];
    _downView.hidden = !tableViewEditing;
    [_tableView setHeight:tableViewEditing ? (MainScreenHeight - MACRO_UI_UPHEIGHT - _topView.height - _downView.height) : (MainScreenHeight - MACRO_UI_UPHEIGHT - _topView.height)];
    [_tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

@end
