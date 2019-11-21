//
//  LookRecodeViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/9/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//  观看记录

#import "LookRecodeViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "TKProgressHUD+Add.h"

#import "LookRecodeCell.h"
#import "Good_ClassMainViewController.h"
#import "DLViewController.h"



@interface LookRecodeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    BOOL isHave;//判断数组里面是否有这个ID
    NSInteger Number;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSDictionary *dataSource;
@property (strong ,nonatomic)NSArray *lookArray;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *titleTimeArray;
@property (strong ,nonatomic)NSMutableArray *timeArray;
@property (strong ,nonatomic)NSMutableArray *allDateArray;
@property (strong ,nonatomic)NSMutableArray *seleArray;
@property (strong ,nonatomic)NSMutableArray *seleIDArray;//选中的ID的数组

@property (strong ,nonatomic)UIButton       *lineButton;
@property (strong ,nonatomic)UIButton       *deleButton;
@property (assign ,nonatomic)BOOL           isDeleing;//是否正在删除操作
@property (strong ,nonatomic)UIView         *downView;
@property (strong ,nonatomic)UIButton       *allseleButton;
@property (strong ,nonatomic)UIButton       *sureButton;
@property (strong ,nonatomic)NSMutableArray *seleingArray;//正在被选中的数组

@end

@implementation LookRecodeViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
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
    [self interFace];
    [self addNav];
    [self addTableView];
    [self netWorkUserGetRecordList:1];
}


- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _lookArray = [NSArray array];
    _titleTimeArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _timeArray = [NSMutableArray array];
    _allDateArray = [NSMutableArray array];
    _seleArray = [NSMutableArray array];
    _isDeleing = NO;
    _seleingArray = [NSMutableArray array];
    _seleIDArray = [NSMutableArray array];
    isHave = NO;
}


- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"学习记录";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    
    UIButton *deleButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [deleButton setImage:[UIImage imageNamed:@"ic_delate@3x"] forState:UIControlStateNormal];
    [deleButton addTarget:self action:@selector(deleButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:deleButton];
    _deleButton = deleButton;
    [_deleButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
    _deleButton.titleLabel.font = Font(15);
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        deleButton.frame = CGRectMake(MainScreenWidth - 50, 40, 40, 40);
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
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addFooterWithTarget:self action:@selector(footRefresh)];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 55, MainScreenWidth, 55)];
    
    _downView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_downView];
    
    //添加按钮
    _allseleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2 , 55)];
    [_allseleButton setTitle:@"全选" forState:UIControlStateNormal];
    _allseleButton.backgroundColor = BlackNotColor;
    [_downView addSubview:_allseleButton];
    [_allseleButton addTarget:self action:@selector(allSeleButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, 0, MainScreenWidth / 2 , 55)];
    [_sureButton setTitle:@"取消删除" forState:UIControlStateNormal];
    _sureButton.backgroundColor = BasidColor;
    [_downView addSubview:_sureButton];
    [_sureButton addTarget:self action:@selector(sureButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)footRefresh {
    Number ++;
    [self netWorkUserGetRecordList:Number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

#pragma mark -- UITableViewDatasoure

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 40;
    } else {
        return 40;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *time = [[UILabel alloc] init];
    if (section == 0) {
        time.frame = CGRectMake(20, 0, MainScreenWidth, 40);
    } else {
        time.frame = CGRectMake(20, 0, MainScreenWidth, 40);
    }
    
    if (_timeArray.count == 0) {
        
    } else {
        time.text = _timeArray[section];
    }
    time.textColor = BasidColor;
    [headerView addSubview:time];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 0, 1, 40)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headerView addSubview:lineButton];
    _lineButton = lineButton;
    
    UIButton *circleButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 15, 10, 10)];
    circleButton.backgroundColor = BasidColor;
    circleButton.layer.cornerRadius = 5;
    circleButton.layer.masksToBounds = YES;
    [headerView addSubview:circleButton];
    
    if (_isDeleing) {
        lineButton.hidden = YES;
        circleButton.hidden = YES;
    } else {
        lineButton.hidden = NO;
        circleButton.hidden = NO;
    }
    
    return headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
    static NSString *cellID = @"cell";
    LookRecodeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[LookRecodeCell alloc] initWithReuseIdentifier:cellID];
    }
    NSDictionary *dict = _allDateArray[indexPath.section][indexPath.row];
    [cell dataSourceWith:dict];
    
    if ([_seleArray[indexPath.section][indexPath.row] boolValue] == NO) {
        [cell.seleButton setBackgroundImage:Image(@"ic_unchoose@3x") forState:UIControlStateNormal];
    }else {
        [cell.seleButton setBackgroundImage:Image(@"ic_choose@3x") forState:UIControlStateNormal];
    }
    
    if (_isDeleing) {
        cell.seleButton.hidden = NO;
        cell.lineButton.hidden = YES;
    } else {
        cell.seleButton.hidden = YES;
        cell.lineButton.hidden = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"----%@",_dataArray[indexPath.row]);

    
    if (_isDeleing) {
        
        NSMutableArray *sectionArray = _seleArray[indexPath.section];
        if ([_seleArray[indexPath.section][indexPath.row] isEqualToString:@"1"]) {//已经选中
            [sectionArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
            if (_seleingArray.count) {
                [_seleingArray removeLastObject];
            }
        } else {
            [sectionArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [_seleingArray addObject:@"0"];
        }
        [_seleArray replaceObjectAtIndex:indexPath.section withObject:sectionArray];
        [_tableView reloadData];
        NSString *sureStr = [NSString stringWithFormat:@"确定删除(%ld)",_seleingArray.count];
        if (_seleingArray.count == 0) {
            sureStr = @"取消删除";
        }
        [_sureButton setTitle:sureStr forState:UIControlStateNormal];

        
        //选中ID的处理
        NSString *ID = [NSString stringWithFormat:@"%@",_allDateArray[indexPath.section][indexPath.row][@"record_id"]];
        NSLog(@"%@",ID);
        NSLog(@"%@",_seleIDArray);
        
        if (_seleIDArray.count == 0) {//当数组是空的时候
            [_seleIDArray addObject:ID];
        } else {
//            //遍历
            for (int i = 0 ; i < _seleIDArray.count ; i ++) {
                NSString *seleID = [NSString stringWithFormat:@"%@",_seleIDArray[i]];
                NSLog(@"%@  %@",ID,seleID);
                if ([seleID isEqualToString:ID]) {//说明相同 应删除
                    isHave = YES;
                    continue;
                } else {
                    isHave = NO;
                }
            }
            
            if (isHave) {
                [_seleIDArray removeObject:ID];
            } else {
                [_seleIDArray addObject:ID];
            }
        }

        NSLog(@"sele---%@",_seleIDArray);
        
        isHave = NO;
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
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NSLog(@"0---%@",_seleIDArray);

    [_tableView reloadData];
}

#pragma mark --- 网络请求
//首页推荐机构的数据
- (void)netWorkUserGetRecordList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_User_user_getRecordList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    
    NSString *lll = nil;
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
//        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
        lll = oath_token_Str;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:lll forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            if ([[_dataSource arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *)[_dataSource arrayValueForKey:@"data"];
                } else {
                    NSArray *array = (NSMutableArray *)[_dataSource arrayValueForKey:@"data"];
                    [_dataArray addObjectsFromArray:array];
                }

            } else {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                } else {
                    NSArray *array = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                    [_dataArray addObjectsFromArray:array];
                }
            }
        }
        if (_dataArray.count == 0) {
            //添加空白处理
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        //处理数据
        if (_dataArray.count == 0) {
            return;
        } else {
            [_titleTimeArray removeAllObjects];
            [_timeArray removeAllObjects];
            [_seleArray removeAllObjects];
            [_seleingArray removeAllObjects];
            [self dealDataSource];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}

#pragma mark --- 删除记录
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
        [self netWorkUserGetRecordList:1];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}

#pragma mark --- 处理数据
- (void)dealDataSource {
    
    for (int i = 0 ; i < _dataArray.count ; i ++) {
        [Passport formatterDate:_dataArray[i][@"ctime"]];
        NSString *timeStr =  [Passport formatterDate:_dataArray[i][@"ctime"]];
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
    
    NSLog(@"%@",timeArray);
    _timeArray = timeArray;
    
    
    NSMutableArray *array= [NSMutableArray arrayWithArray:_dataArray];
    
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
    
    [self addSele];
}


#pragma mark --- 添加选中数组
- (void)addSele {
    for (int i = 0 ; i < _allDateArray.count ; i ++) {
        NSArray *array = _allDateArray[i];
        NSMutableArray *yesArray = [NSMutableArray array];
        for (int k = 0 ; k < array.count ; k ++) {
            [yesArray addObject:@"0"];
        }
        [_seleArray addObject:yesArray];
    }
    
    NSLog(@"%@",_seleArray);
}

#pragma mark --- 事件点击

- (void)deleButtonCilck {
    _isDeleing = !_isDeleing;
    if (_isDeleing) {
        [UIView animateWithDuration:0.25 animations:^{
            [self addDownView];
            _tableView.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 55);
            if (iPhoneX) {
                _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88 - 55);
            }
        }];
        [_deleButton setImage:Image(@"") forState:UIControlStateNormal];
        [_deleButton setTitle:@"取消" forState:UIControlStateNormal];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            _downView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, 55);
            _tableView.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64);
            if (iPhoneX) {
                _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88);
//                _downView.frame = CGRectMake(0, mai, <#CGFloat width#>, <#CGFloat height#>)
            }
        }];
        [_deleButton setImage:Image(@"ic_delate@3x") forState:UIControlStateNormal];
        [_deleButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    [_tableView reloadData];
    
}

- (void)allSeleButtonCilck {
    
    NSLog(@"%@",_allDateArray);
    if ([_allseleButton.titleLabel.text isEqualToString:@"全选"]) {
        for (int l = 0 ; l < _seleArray.count ; l ++) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:_seleArray[l]];
            for (int i = 0 ; i < array.count ; i ++) {
                [ array replaceObjectAtIndex:i  withObject:@"1"];
            }
            [_seleArray replaceObjectAtIndex:l withObject:array];
        }
        [_allseleButton setTitle:@"取消全选" forState:UIControlStateNormal];
        NSString *allStr = [NSString stringWithFormat:@"确认删除(%ld)",_dataArray.count];
        [_sureButton setTitle:allStr forState:UIControlStateNormal];
        [_seleingArray removeAllObjects];
        [_seleIDArray removeAllObjects];
        for (int i = 0; i < _dataArray.count ; i ++) {
            [_seleingArray addObject:@"1"];
    
            //添加全部的课程ID
            NSString *ID = _dataArray[i][@"record_id"];
            [_seleIDArray addObject:ID];
        }
    } else if ([_allseleButton.titleLabel.text isEqualToString:@"取消全选"]) {
        for (int l = 0 ; l < _seleArray.count ; l ++) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:_seleArray[l]];
            for (int i = 0 ; i < array.count ; i ++) {
                [ array replaceObjectAtIndex:i  withObject:@"0"];
            }
            [_seleArray replaceObjectAtIndex:l withObject:array];
        }
        [_allseleButton setTitle:@"全选" forState:UIControlStateNormal];
        [_sureButton setTitle:@"取消删除" forState:UIControlStateNormal];
        [_seleingArray removeAllObjects];
        [_seleIDArray removeAllObjects];
    }
    
    NSLog(@"%@",_allseleButton.titleLabel.text);
    
    NSLog(@"%@",_seleArray);
    
    [_tableView reloadData];
}

- (void)sureButtonCilck {
    if (!_seleingArray.count) {
        _isDeleing = !_isDeleing;
        [UIView animateWithDuration:0.25 animations:^{
            _downView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, 55);
            _tableView.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64);
            if (iPhoneX) {
                _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88);
            }
        }];
    } else {//有选择的时候 (确认删除然后网络请求操作)
        [self netWorkUserUserDeleteRecord];
        [_sureButton setTitle:@"取消删除" forState:UIControlStateNormal];
    }
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
