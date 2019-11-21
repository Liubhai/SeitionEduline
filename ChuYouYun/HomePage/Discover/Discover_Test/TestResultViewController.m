//
//  TestResultViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/27.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestResultViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "TestResultTableViewCell.h"
#import "TestCurrentViewController.h"

@interface TestResultViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIView       *headerView;
@property (strong ,nonatomic)UIView       *downView;
@property (strong ,nonatomic)UILabel      *currentGetScoreLabel;
@property (strong ,nonatomic)UIButton     *userImageButton;
@property (strong ,nonatomic)UILabel      *planLabel;




@property (strong ,nonatomic)NSArray      *dataArray;
@property (strong ,nonatomic)NSDictionary *userTestDict;//用户自己的考试信息
@property (strong ,nonatomic)NSDictionary *dataSource;


@end

@implementation TestResultViewController


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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"考试结果";
    [self addHeaderView];
    [self addTableView];
    [self addDownView];
//    [self NetWorkGetExamsRank];
    [self netWorkExamsRank];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
//    _dataArray = @[@[@"1",@"2"],@[@"1",@"2",@"3",@"4",@"5",@"6"]];
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
    WZLabel.text = @"考试结果";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    lineLab.hidden = YES;
    
    
}


#pragma mark --- 添加表格头试图

- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 400 * WideEachUnit)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 330 * WideEachUnit)];
    imageView.backgroundColor = BasidColor;
    [_headerView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    UIButton *circleButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 62.5 * WideEachUnit, 30 * WideEachUnit, 125 * WideEachUnit, 125 * WideEachUnit)];
    circleButton.backgroundColor = [UIColor clearColor];
    [circleButton setBackgroundImage:Image(@"score@3x") forState:UIControlStateNormal];
    [_headerView addSubview:circleButton];
    
    //分数
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80 * WideEachUnit, 80 * WideEachUnit)];
    scoreLabel.text = [_testDict stringValueForKey:@"score"];
    scoreLabel.font = Font(50 * WideEachUnit);
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.center = circleButton.center;
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:scoreLabel];
    
    //summary (总结)
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 170 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    summaryLabel.text = @"本卷平均75分，超过80%的人";
    summaryLabel.font = Font(12 * WideEachUnit);
    summaryLabel.textColor = [UIColor colorWithHexString:@"#a9bde7"];
    summaryLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:summaryLabel];
    summaryLabel.hidden = YES;
    
    //again
    UIButton *againButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 75 * WideEachUnit, 205 * WideEachUnit, 150 * WideEachUnit, 40 * WideEachUnit)];
    againButton.backgroundColor = [UIColor clearColor];
    [againButton setTitle:@"再次挑战" forState:UIControlStateNormal];
    againButton.titleLabel.font = Font(14 * WideEachUnit);
    [againButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    againButton.layer.cornerRadius = 20 * WideEachUnit;
    againButton.layer.masksToBounds = YES;
    againButton.layer.borderColor = [UIColor whiteColor].CGColor;
    againButton.layer.borderWidth = 1 * WideEachUnit;
    [againButton addTarget:self action:@selector(againButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:againButton];
    
    
    //排名
    UILabel *rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 380 * WideEachUnit, 40 * WideEachUnit, 17 * WideEachUnit)];
    rankingLabel.text = @"排名";
    rankingLabel.font = Font(12 * WideEachUnit);
    rankingLabel.textColor = [UIColor colorWithHexString:@"#888"];
    [_headerView addSubview:rankingLabel];
    
    //用时
    UILabel *useTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WideEachUnit, 380 * WideEachUnit, 30 * WideEachUnit, 17 * WideEachUnit)];
    useTimeLabel.text = @"用时";
    useTimeLabel.font = Font(12 * WideEachUnit);
    useTimeLabel.textColor = [UIColor colorWithHexString:@"#888"];
    [_headerView addSubview:useTimeLabel];
    
    //得分
    UILabel *getScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 30 * WideEachUnit, 380 * WideEachUnit, 30 * WideEachUnit, 17 * WideEachUnit)];
    getScoreLabel.text = @"得分";
    getScoreLabel.font = Font(12 * WideEachUnit);
    getScoreLabel.textColor = [UIColor colorWithHexString:@"#888"];
    [_headerView addSubview:getScoreLabel];
    
    
    //当前考试排名
    UIView *currentTestView = [[UIView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 280 * WideEachUnit, 355 * WideEachUnit, 90 * WideEachUnit)];
    currentTestView.backgroundColor = [UIColor whiteColor];
    currentTestView.layer.cornerRadius = 3 * WideEachUnit;
    currentTestView.layer.shadowOffset = CGSizeMake(0, 3);//偏移距离
    currentTestView.layer.shadowOpacity = 0.2;//不透明度
    currentTestView.layer.shadowRadius = 3;//半径
    currentTestView.userInteractionEnabled = YES;
    [_headerView addSubview:currentTestView];
    
    //当前排名
    UILabel *currentRankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 18 * WideEachUnit, 40 * WideEachUnit, 15 * WideEachUnit)];
    currentRankingLabel.text = @"排名";
    currentRankingLabel.font = Font(12 * WideEachUnit);
    currentRankingLabel.textColor = [UIColor colorWithHexString:@"#656565"];
    [currentTestView addSubview:currentRankingLabel];
    
    //得分
    UILabel *currentGetScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 43 * WideEachUnit, 120 * WideEachUnit, 30 * WideEachUnit)];
    currentGetScoreLabel.text = @"142";
    currentGetScoreLabel.font = Font(28 * WideEachUnit);
    currentGetScoreLabel.textColor = BasidColor;
    currentGetScoreLabel.textAlignment = NSTextAlignmentCenter;
    [currentTestView addSubview:currentGetScoreLabel];
    _currentGetScoreLabel = currentGetScoreLabel;
    
    //图像
    UIButton *userImageButton = [[UIButton alloc] initWithFrame:CGRectMake(140 * WideEachUnit, 20 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit)];
    userImageButton.backgroundColor = [UIColor redColor];
    [userImageButton setImage:Image(@"站位图") forState:UIControlStateNormal];
    userImageButton.layer.cornerRadius = 25 * WideEachUnit;
    userImageButton.layer.masksToBounds = YES;
    [currentTestView addSubview:userImageButton];
    _userImageButton = userImageButton;
    
    //计划
    UILabel *planLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImageButton.frame) + 15 * WideEachUnit, 20 * WideEachUnit, 120 * WideEachUnit, 20 * WideEachUnit)];
    planLabel.text = @"激光计划";
    planLabel.font = Font(13 * WideEachUnit);
    planLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [currentTestView addSubview:planLabel];
    _planLabel = planLabel;
    
    //用时
    UILabel *currentUseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImageButton.frame) + 15 * WideEachUnit, 50 * WideEachUnit, 30 * WideEachUnit, 17 * WideEachUnit)];
    currentUseTimeLabel.text = @"用时";
    currentUseTimeLabel.font = Font(12 * WideEachUnit);
    currentUseTimeLabel.textColor = [UIColor colorWithHexString:@"#888"];
    [currentTestView addSubview:currentUseTimeLabel];
    
    //用多少时间
    UILabel *anserTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(currentUseTimeLabel.frame), 50 * WideEachUnit, 30 * WideEachUnit, 17 * WideEachUnit)];
    if ([[_testDict stringValueForKey:@"anser_time"] integerValue] > 3600) {//小时
        NSInteger hour = [[_testDict stringValueForKey:@"anser_time"] integerValue] / 3600;
        NSInteger mins = [[_testDict stringValueForKey:@"anser_time"] integerValue] % 3600 / 60;
        NSInteger seind = [[_testDict stringValueForKey:@"anser_time"] integerValue] % 3600 / 60 % 60;
        anserTimeLabel.text = [NSString stringWithFormat:@"%ld'%ld'%ld",hour,mins,seind];
    } else if ([[_testDict stringValueForKey:@"anser_time"] integerValue] > 60) {
        NSInteger mins = [[_testDict stringValueForKey:@"anser_time"] integerValue] / 60;
        NSInteger seind = [[_testDict stringValueForKey:@"anser_time"] integerValue] % 60;
        anserTimeLabel.text = [NSString stringWithFormat:@"%ld'%ld",mins,seind];
    } else {
        anserTimeLabel.text = [_testDict stringValueForKey:@"anser_time"];
    }
    anserTimeLabel.font = Font(12 * WideEachUnit);
    anserTimeLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [currentTestView addSubview:anserTimeLabel];
    
    
    //得分
    UILabel *currentScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(anserTimeLabel.frame) + 10 * WideEachUnit, 50 * WideEachUnit, 30 * WideEachUnit, 17 * WideEachUnit)];
    currentScoreLabel.text = @"得分";
    currentScoreLabel.font = Font(12 * WideEachUnit);
    currentScoreLabel.textColor = [UIColor colorWithHexString:@"#888"];
    [currentTestView addSubview:currentScoreLabel];
    
    //用户得分
    UILabel *userScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(currentScoreLabel.frame) + 10 * WideEachUnit, 50 * WideEachUnit, 30 * WideEachUnit, 17 * WideEachUnit)];
    userScoreLabel.text = [_testDict stringValueForKey:@"score"];
    userScoreLabel.font = Font(12 * WideEachUnit);
    userScoreLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [currentTestView addSubview:userScoreLabel];
    
}


- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 49 * WideEachUnit) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60 * WideEachUnit;
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = _headerView;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01 * WideEachUnit;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01 * WideEachUnit;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    TestResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TestResultTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell dataWithDict:dic WithNumber:indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --- 添加底部试图
- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 49 * WideEachUnit, MainScreenWidth, 49 * WideEachUnit)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];
    
    NSArray *titleArray = @[@"全部解析",@"错题解析"];
    CGFloat buttonW = MainScreenWidth / 2 ;
    CGFloat buttonH = 49 * WideEachUnit;
    
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonW * i, 0, buttonW, buttonH)];
        [button setTitleColor:BasidColor forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(analysisButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
    }
    
    //添加中间的分割线
    UIButton *lineButton2 = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 0.5 * WideEachUnit, 6.5 * WideEachUnit, 1, 36 * WideEachUnit)];
    lineButton2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton2];
    
}


#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)againButtonCilck {//再次挑战
    if ([_examType integerValue] == 2) {//考试模式
        _examType = @"2";
    } else {
        _examType = @"1";
    }

    if ([[_testDict stringValueForKey:@"pid"] integerValue] == 0) {
        [self netWorkExamsGetPaperInfo];
    } else {//错题重练生成的记录
        [self netWorkExamsWrongExams];
    }
}

- (void)analysisButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//全部解析
        _examType = @"3";
        [self netWorkExamsResult];
    } else if (button.tag == 1) {//错题解析
        _examType = @"3";
        [self netWorkExamsWrongData];
    }
}


#pragma mark --- 网络请求
//获取考试结果
- (void)netWorkExamsResult {
    NSString *endUrlStr = YunKeTang_Exams_exams_result;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_paper_id"] forKey:@"paper_id"];
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_users_id"] forKey:@"exams_users_id"];
    
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
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
            vc.examsType = _examType;
            vc.dataSource = _dataSource;
            vc.testDict = _testDict;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [TKProgressHUD showError:[_dataSource stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



//获取考试排名
- (void)NetWorkGetExamsRank {
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    [dic setObject:@"10" forKey:@"count"];
    [dic setObject:[_testDict stringValueForKey:@"exams_users_id"] forKey:@"exams_users_id"];
    
    NSLog(@"---%@",dic);
    [manager BigWinCar_GetPublicWay:dic mod:@"Exams" act:@"getExamsRank" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([[responseObject stringValueForKey:@"code"] integerValue] == 1) {
            _dataArray = [[responseObject dictionaryValueForKey:@"data"] arrayValueForKey:@"list"];
            _userTestDict = [[responseObject dictionaryValueForKey:@"data"] dictionaryValueForKey:@"now"];
            _currentGetScoreLabel.text = [_userTestDict stringValueForKey:@"rank_nomber"];
            _planLabel.text = [_userTestDict stringValueForKey:@"username"];
            NSString *urlStr = [_userTestDict stringValueForKey:@"userface"];
            [_userImageButton sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }

        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取考试结果
- (void)netWorkExamsRank {
    NSString *endUrlStr = YunKeTang_Exams_exams_rank;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"10" forKey:@"count"];
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_users_id"] forKey:@"exams_users_id"];
    
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
            _dataArray = [dict arrayValueForKey:@"list"];
            _userTestDict = [dict dictionaryValueForKey:@"now"];
            _currentGetScoreLabel.text = [_userTestDict stringValueForKey:@"rank_nomber"];
            _planLabel.text = [_userTestDict stringValueForKey:@"username"];
            NSString *urlStr = [_userTestDict stringValueForKey:@"userface"];
            [_userImageButton sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取考试的数据
- (void)netWorkExamsGetPaperInfo {
    NSString *endUrlStr = YunKeTang_Exams_exams_getPaperInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_paper_id"] forKey:@"paper_id"];
    [mutabDict setObject:_examType forKey:@"exams_type"];//这个界面为练习模式
//    [mutabDict setObject:[_testDict stringValueForKey:@"exams_users_id"] forKey:@"exams_users_id"];
//    [mutabDict setObject:@"1" forKey:@"is_rechallenge"];
    
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
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_dataSource dictionaryValueForKey:@"paper_options"].allKeys.count == 0) {
                [TKProgressHUD showError:@"考试数据为空" toView:self.view];
                return ;
            }
            if ([[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions"].allKeys.count == 0) {
                [TKProgressHUD showError:@"考试数据为空" toView:self.view];
                return ;
            }
            TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
            vc.examsType = _examType;
            vc.dataSource = _dataSource;
            vc.testDict = _testDict;
            vc.continueStr = @"again";//再次挑战
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [TKProgressHUD showError:[_dataSource stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//错题重练
- (void)netWorkExamsWrongExams {
    NSString *endUrlStr = YunKeTang_Exams_exams_wrongExams;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_paper_id"] forKey:@"paper_id"];
    [mutabDict setObject:_examType forKey:@"exams_type"];//这个界面为练习模式
    [mutabDict setObject:[_testDict stringValueForKey:@"pid"] forKey:@"exams_users_id"];//1 收藏 0 取消收藏
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    [TKProgressHUD showMessag:@"加载中..." toView:[UIApplication sharedApplication].keyWindow];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
            vc.examsType = @"1";
            vc.dataSource = _dataSource;
            vc.errorsFag = @"wrongExams";//错题重做的标示
            vc.continueStr = @"continue";
            vc.testDict = _testDict;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [TKProgressHUD showError:[_dataSource stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
    [op start];
}




//获取指定考试里面的错题
- (void)netWorkExamsWrongData {
    NSString *endUrlStr = YunKeTang_Exams_exams_wrongData;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_paper_id"] forKey:@"paper_id"];
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_users_id"] forKey:@"exams_users_id"];
    
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
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"].allKeys.count == 0) {
                [TKProgressHUD showError:@"数据为空" toView:self.view];
                return;
            }
            TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
            vc.examsType = _examType;
            vc.dataSource = _dataSource;
            vc.errorsFag = @"error";//这个是错题解析的标识符（主要用于来判断错题解析的总题数）
            vc.testDict = _testDict;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [TKProgressHUD showError:[_dataSource stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
