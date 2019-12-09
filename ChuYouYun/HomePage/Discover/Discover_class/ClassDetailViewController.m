//
//  ClassDetailViewController.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "ClassDetailViewController.h"

#import "SYG.h"
#import "YunKeTang_Api.h"
#import "TKProgressHUD+Add.h"
#import "Passport.h"
#import "AppDelegate.h"
#import "ClassAndLivePayViewController.h"
#import "DLViewController.h"

@interface ClassDetailViewController () {
    CGFloat sectionHeight;
}

/** 活动详情信息 */
@property (strong, nonatomic) NSDictionary *activityInfo;

@end

@implementation ClassDetailViewController

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
    _originDict = [[NSDictionary alloc] init];
    sectionHeight = 0.01;
    self.canScroll = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"套餐详情";
    sectionHeight = MainScreenHeight - MACRO_UI_UPHEIGHT;
    [self makeTableView];
    [self makeHeaderView];
}

// MARK: - 创建tableView
- (void)makeTableView {
    _tableView = [[LBHTableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView addHeaderWithTarget:self action:@selector(getComboDetail)];
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    [self.view addSubview:_tableView];
    [_tableView headerBeginRefreshing];
    [self getCourceActivityInfo];
}

// MARK: - 创建头部视图
- (void)makeHeaderView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10 * 2 + 96 * HigtEachUnit)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 173 * WideEachUnit, 96 * HigtEachUnit)];
        [_headerView addSubview:_faceImageView];
        
        _classTitle = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 10, 0, MainScreenWidth - (_faceImageView.right + 10) - 20, 15)];
        _classTitle.font = SYSTEMFONT(13);
        _classTitle.textColor = RGBHex(0x3D3E3E);
        [_headerView addSubview:_classTitle];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 20 - _classTitle.width, 0, _classTitle.width, 15)];
        _priceLabel.font = SYSTEMFONT(13);
        _priceLabel.textColor = RGBHex(0xFF0000);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [_headerView addSubview:_priceLabel];
        
        _teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(_classTitle.left, 0, _classTitle.width, 15)];
        _teacherLabel.font = SYSTEMFONT(11);
        _teacherLabel.textColor = RGBHex(0x7C7C7C);
        [_headerView addSubview:_teacherLabel];
        
        _courseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_classTitle.left, 0, _classTitle.width, 15)];
        _courseCountLabel.font = SYSTEMFONT(11);
        _courseCountLabel.textColor = RGBHex(0x7C7C7C);
        _courseCountLabel.text = @"包含：2门课程";
        [_headerView addSubview:_courseCountLabel];
        
        _joinButton = [[UIButton alloc] initWithFrame:CGRectMake(_classTitle.left, 0, 50, 20)];
        [_joinButton setTitle:@"已加入" forState:0];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:0];
        _joinButton.titleLabel.font = SYSTEMFONT(11);
        _joinButton.backgroundColor = RGBHex(0x00BED4);
        [_joinButton addTarget:self action:@selector(payForCombo) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_joinButton];
        
        _collectionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 20 - 50, 0, 50, 15)];
        _collectionButton.titleLabel.font = SYSTEMFONT(11);
        [_collectionButton setImage:Image(@"collection") forState:UIControlStateSelected];
        [_collectionButton setImage:Image(@"uncollection") forState:0];
        [_collectionButton setTitle:@"已收藏" forState:UIControlStateSelected];
        [_collectionButton setTitle:@"收藏" forState:0];
        [_collectionButton setTitleColor:RGBHex(0x7C7C7C) forState:0];
        
        _collectionButton.selected = YES;
        _collectionButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5/2.0, 0, 5/2.0);
        _collectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5/2.0, 0, -5/2.0);
        [_collectionButton addTarget:self action:@selector(collectOrUnCollectCombo:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_collectionButton];
        
        _classTitle.centerY = 10 + _faceImageView.height / 8.0;
        _priceLabel.centerY = 10 + _faceImageView.height / 8.0;
        _teacherLabel.centerY = 10 + _faceImageView.height * 3 / 8.0;
        _courseCountLabel.centerY = 10 + _faceImageView.height * 5 / 8.0;
        _joinButton.centerY = 10 + _faceImageView.height * 7 / 8.0;
        _collectionButton.centerY = 10 + _faceImageView.height * 7 / 8.0;
    }
    if (SWNOTEmptyDictionary(_originDict)) {
        [_faceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_originDict objectForKey:@"imageurl"]]] placeholderImage:Image(@"站位图")];
        _classTitle.text = [NSString stringWithFormat:@"%@",[_originDict objectForKey:@"album_title"]];
        _priceLabel.text = [NSString stringWithFormat:@"%@育币",[_originDict objectForKey:@"price"]];
        CGFloat priceWidth = [_priceLabel.text sizeWithFont:_priceLabel.font].width + 5;
        // 避免遮挡
        [_classTitle setWidth:MainScreenWidth - (_faceImageView.right + 10) - 20 - priceWidth];
        NSArray *teacherArr = [NSArray arrayWithArray:[_originDict objectForKey:@"teacher"]];
        if (SWNOTEmptyArr(teacherArr)) {
            _teacherLabel.text = [NSString stringWithFormat:@"讲师：%@",[teacherArr[0] objectForKey:@"name"]];
        }
        _courseCountLabel.text = [NSString stringWithFormat:@"包含：%@门课程",[_originDict objectForKey:@"video_count"]];
        [_joinButton setTitle:[[_originDict objectForKey:@"is_buy"] integerValue] ? @"已加入" : @"加入" forState:0];
        _collectionButton.selected = [[_originDict objectForKey:@"isCollect"] integerValue];
    } else {
        _faceImageView.image = Image(@"站位图");
    }
    _tableView.tableHeaderView = _headerView;
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifireAC =@"ActivityListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifireAC];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifireAC];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return sectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, sectionHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
    } else {
        _bgView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight);
    }
    
    if (sectionHeight>1) {
        if (_introButton == nil) {
            self.introButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth/3.0, 32 * HigtEachUnit)];
            self.courseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/3.0, 0, MainScreenWidth/3.0, 32 * HigtEachUnit)];
            self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth*2/3.0, 0, MainScreenWidth/3.0, 32 * HigtEachUnit)];
            [self.introButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.courseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.commentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.introButton setTitle:@"套餐简介" forState:0];
            [self.courseButton setTitle:@"班内课程" forState:0];
            [self.commentButton setTitle:@"套餐评论" forState:0];
            
            self.introButton.titleLabel.font = SYSTEMFONT(12);
            self.courseButton.titleLabel.font = SYSTEMFONT(12);
            self.commentButton.titleLabel.font = SYSTEMFONT(12);
            
            [self.introButton setTitleColor:[UIColor blackColor] forState:0];
            [self.courseButton setTitleColor:[UIColor blackColor] forState:0];
            [self.commentButton setTitleColor:[UIColor blackColor] forState:0];
            
            [self.introButton setTitleColor:BasidColor forState:UIControlStateSelected];
            [self.courseButton setTitleColor:BasidColor forState:UIControlStateSelected];
            [self.commentButton setTitleColor:BasidColor forState:UIControlStateSelected];
            
            self.introButton.selected = YES;
            
            self.blueLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 * HigtEachUnit, MainScreenWidth / 5.0, 2 * HigtEachUnit)];
            self.blueLineView.backgroundColor = BasidColor;
            self.blueLineView.centerX = self.introButton.centerX;
            
            [_bgView addSubview:self.introButton];
            [_bgView addSubview:self.courseButton];
            [_bgView addSubview:self.commentButton];
            [_bgView addSubview:self.blueLineView];
        }
        
        if (self.mainScroll == nil) {
            self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,32 * HigtEachUnit, MainScreenWidth, sectionHeight - 32 * HigtEachUnit)];
            self.mainScroll.contentSize = CGSizeMake(MainScreenWidth*3, 0);
            self.mainScroll.pagingEnabled = YES;
            self.mainScroll.showsHorizontalScrollIndicator = NO;
            self.mainScroll.showsVerticalScrollIndicator = NO;
            self.mainScroll.bounces = NO;
            self.mainScroll.delegate = self;
            [_bgView addSubview:self.mainScroll];
        } else {
            self.mainScroll.frame = CGRectMake(0,32 * HigtEachUnit, MainScreenWidth, sectionHeight - 32 * HigtEachUnit);
        }
        
        if (_introVC == nil) {
            _introVC = [[ClassInfoDetailVC alloc] init];
            _introVC.tableHeight = sectionHeight - 32 * HigtEachUnit;
            _introVC.vc = self;
            _introVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 32 * HigtEachUnit);
            [self.mainScroll addSubview:_introVC.view];
            [self addChildViewController:_introVC];
        } else {
            _introVC.tableHeight = sectionHeight - 32 * HigtEachUnit;
            _introVC.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 32 * HigtEachUnit);
        }
        [_introVC setOriginDict:_originDict];
        
        if (_courseListVC == nil) {
            _courseListVC = [[ClassCourseListVC alloc] init];
            _courseListVC.tableHeight = sectionHeight - 32 * HigtEachUnit;
            _courseListVC.vc = self;
            _courseListVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 32 * HigtEachUnit);
            [self.mainScroll addSubview:_courseListVC.view];
            [self addChildViewController:_courseListVC];
        } else {
            _courseListVC.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 32 * HigtEachUnit);
            _courseListVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 32 * HigtEachUnit);
        }
        
        [_courseListVC setOriginDict:_originDict];
        
        if (_commentListVC == nil) {
            _commentListVC = [[ClassCommentListVC alloc] init];
            _commentListVC.tableHeight = sectionHeight - 32 * HigtEachUnit;
            _commentListVC.vc = self;
            _commentListVC.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 32 * HigtEachUnit);
            [self.mainScroll addSubview:_commentListVC.view];
            [self addChildViewController:_commentListVC];
        } else {
            _commentListVC.cellTabelCanScroll = NO;
            _commentListVC.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 32 * HigtEachUnit);
            _commentListVC.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 32 * HigtEachUnit);
        }
        [_commentListVC setOriginDict:_originDict];
    }
    return _bgView;
}

- (void)buttonClick:(UIButton *)sender{
    
    if (sender == self.introButton) {
        [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == self.courseButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth, 0) animated:YES];
    } else if (sender == self.commentButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 2, 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScroll) {
        if (scrollView.contentOffset.x <= 0) {
            self.blueLineView.centerX = self.introButton.centerX;
            self.introButton.selected = YES;
            self.courseButton.selected = NO;
            self.commentButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.blueLineView.centerX = self.commentButton.centerX;
            self.commentButton.selected = YES;
            self.introButton.selected = NO;
            self.courseButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.blueLineView.centerX = self.courseButton.centerX;
            self.courseButton.selected = YES;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
        }
    } if (scrollView == self.tableView) {
        CGFloat bottomCellOffset = self.headerView.height;
        if (scrollView.contentOffset.y > bottomCellOffset + 0.5) {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (UIViewController *vc in self.childViewControllers) {
                    if (self.courseButton.selected) {
                        if ([vc isKindOfClass:[ClassCourseListVC class]]) {
                            ClassCourseListVC *vccomment = (ClassCourseListVC *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.introButton.selected) {
                        if ([vc isKindOfClass:[ClassInfoDetailVC class]]) {
                            ClassInfoDetailVC *vccomment = (ClassInfoDetailVC *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.commentButton.selected) {
                        if ([vc isKindOfClass:[ClassCommentListVC class]]) {
                            ClassCommentListVC *vccomment = (ClassCommentListVC *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                }
            }
        }else{
            if (!self.canScroll) {//子视图没到顶部
                scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }
        }
    }
}

// MARK: - 获取套餐详情
- (void)getComboDetail {
    NSString *endUrlStr = ComBo_Detail;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_combo_id forKey:@"id"];
    
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
        if (SWNOTEmptyDictionary([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject])) {
            if ([[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject] objectForKey:@"code"] integerValue]) {
                _originDict = [NSDictionary dictionaryWithDictionary:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
            }
        }
        [self makeHeaderView];
        [_tableView headerEndRefreshing];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [_tableView headerEndRefreshing];
        [_tableView reloadData];
    }];
    [op start];
}

// MARK: - 收藏取消收藏
- (void)collectOrUnCollectCombo:(UIButton *)collectBtn {
    if (!SWNOTEmptyDictionary(_originDict)) {
        return;
    }
    if (!SWNOTEmptyStr(_combo_id)) {
        return;
    }
    BOOL collect = ![[NSString stringWithFormat:@"%@",[_originDict objectForKey:@"isCollect"]] boolValue];
    NSString *endUrlStr = YunKeTang_Video_video_collect;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"1" forKey:@"sctype"];
    if (collect) {//已经收藏（为取消收藏操作）
        [mutabDict setValue:@"1" forKey:@"type"];
    } else {//没有收藏 （为收藏操作）
        [mutabDict setValue:@"0" forKey:@"type"];
    }
    [mutabDict setValue:_combo_id forKey:@"source_id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    } else {
        [TKProgressHUD showError:@"请先去登陆" toView:self.view];
        return;
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            // 修改按钮状态
            _collectionButton.selected = collect;
            // 修改数据源
            NSMutableDictionary *pass = [NSMutableDictionary dictionaryWithDictionary:_originDict];
            [pass setObject:collect ? @"1" : @"0" forKey:@"isCollect"];
            _originDict = [NSDictionary dictionaryWithDictionary:pass];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//评论的配置
- (void)netWorkCourseReviewConf {
    NSString *endUrlStr = YunKeTang_Course_video_reviewConf;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            NSString *combo_comment_config = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"album_switch"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"comboCommentConfig" object:nil userInfo:@{@"config":combo_comment_config}];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

// MARK: - 加入(购买)套餐
- (void)payForCombo {
    if (!UserOathToken) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if (SWNOTEmptyDictionary(_originDict)) {
        if (![[_originDict objectForKey:@"is_buy"] integerValue]) {
            ClassAndLivePayViewController *vc = [[ClassAndLivePayViewController alloc] init];
            vc.dict = _originDict;
            vc.typeStr = @"4";
            vc.cid = [_originDict stringValueForKey:@"id"];
            vc.activityInfo = [NSDictionary dictionaryWithDictionary:_activityInfo];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

// MARK: - 获取h课程活动详情
- (void)getCourceActivityInfo {
    NSString *endUrlStr = YunKeTang_Course_Activity_Info;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_combo_id forKey:@"course_id"];
    [mutabDict setObject:@"3" forKey:@"course_type"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject] objectForKey:@"code"] integerValue] == 1) {
            if (SWNOTEmptyDictionary([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject])) {
                _activityInfo = (NSDictionary *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    [op start];
}

@end
