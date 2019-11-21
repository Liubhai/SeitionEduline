//
//  ClassCommentListVC.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "ClassCommentListVC.h"
#import "AppDelegate.h"
#import "ClassCommentListCell.h"

#import "SYG.h"
#import "YunKeTang_Api.h"
#import "TKProgressHUD+Add.h"
#import "Passport.h"
#import "DLViewController.h"

@interface ClassCommentListVC () {
    CGRect    _keyboardRect;
    NSInteger pageCount;
}

@property (strong ,nonatomic)UIImageView     *imageView;

// 评论框视图
@property (strong ,nonatomic)UIView          *allWindowView;
@property (strong ,nonatomic)UIView          *moreView;
@property (strong ,nonatomic)UITextView      *textView;

@end

@implementation ClassCommentListVC

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, _tableHeight)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeaderStatus:) name:@"comboCommentConfig" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    pageCount = 1;
    _combo_comment_config = @"1";// 0 开启  1 关闭
    _dataSource = [NSMutableArray new];
    [self makeTableView];
    [self netWorkVideoGetRender];
    [self netWorkCourseReviewConf];
}

- (void)setOriginDict:(NSDictionary *)originDict {
    _originDict = originDict;
    if (SWNOTEmptyDictionary(_originDict)) {
        [self netWorkVideoGetRender];
    }
}

// MARK: - 创建tableView
- (void)makeTableView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
    _headerView.backgroundColor = [UIColor whiteColor];
    _addCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, MainScreenWidth - 40, 60)];
    _addCommentButton.layer.masksToBounds = YES;
    _addCommentButton.layer.borderColor = RGBHex(0xF1F1F1).CGColor;
    _addCommentButton.layer.borderWidth = 0.5;
    [_headerView addSubview:_addCommentButton];
    [_addCommentButton setTitle:@"写下您的点评" forState:0];
    [_addCommentButton setTitleColor:RGBHex(0xC0BEBE) forState:0];
    [_addCommentButton setImage:Image(@"add_comment") forState:0];
    _addCommentButton.titleLabel.font = SYSTEMFONT(12);
    _addCommentButton.imageEdgeInsets = UIEdgeInsetsMake(0, 73+4/2.0, 0, -73-4/2.0);
    _addCommentButton.titleEdgeInsets = UIEdgeInsetsMake(0, -13-4/2.0, 0, 13+4/2.0);
    [_addCommentButton addTarget:self action:@selector(addCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tableHeight) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = [_combo_comment_config isEqualToString:@"0"] ? _headerView : nil;
    if ([_combo_comment_config isEqualToString:@"0"]) {
        [self.imageView setTop:60];
        [self.imageView setHeight:_tableHeight - 60];
    } else {
        [self.imageView setTop:0];
        [self.imageView setHeight:_tableHeight];
    }
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshMoreData)];
    [self.view addSubview:_tableView];
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    [_tableView reloadData];
}

- (void)footerRefreshMoreData {
    pageCount = pageCount + 1;
    [self loadMoreCommentData];
}

- (void)addCommentButtonClicked:(UIButton *)sender {
    if (!UserOathToken) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    [self addCommentView];
}

- (void)addCommentView {
    if ([[_originDict stringValueForKey:@"is_buy"] integerValue] == 0) {//没有解锁
        [TKProgressHUD showError:@"解锁之后才能评论" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds = YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit,MainScreenHeight - 210 * WideEachUnit,MainScreenWidth - 0 * WideEachUnit,210 * WideEachUnit)];
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    moreView.userInteractionEnabled = YES;
    _allWindowView.userInteractionEnabled = YES;
    _moreView = moreView;
    
    //添加
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, 80 * WideEachUnit, 20 * WideEachUnit)];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    title.font = Font(15 * WideEachUnit);
    title.text = @"评价该套餐";
    title.textAlignment = NSTextAlignmentCenter;
    [moreView addSubview:title];

    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 60 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 100 * WideEachUnit)];
    textBackView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [moreView addSubview:textBackView];
    
    //添加textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 5 * WideEachUnit, textBackView.width - 20 * WideEachUnit, 90 * WideEachUnit)];
    _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _textView.userInteractionEnabled = YES;
    [textBackView addSubview:_textView];
    
    //添加提交的按钮
    UIButton *subitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, CGRectGetMaxY(textBackView.frame) + 10 * WideEachUnit, 50 * WideEachUnit, 25 * WideEachUnit)];
    [subitButton setTitle:@"提交" forState:UIControlStateNormal];
    [subitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subitButton.backgroundColor = BasidColor;
    [subitButton addTarget:self action:@selector(netWorkVideoAddReview) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:subitButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ClassCommentListCell";
    ClassCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ClassCommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setCommentInfo:_dataSource[indexPath.row]];
    return cell;
}

// MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.cellTabelCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        self.vc.canScroll = YES;
    }
}

//请求套餐下的评论
- (void)netWorkVideoGetRender {
    pageCount = 1;
    if (!SWNOTEmptyDictionary(_originDict)) {
        return;
    }
    NSString *combo_id = [NSString stringWithFormat:@"%@",[_originDict objectForKey:@"id"]];
    if (!SWNOTEmptyStr(combo_id)) {
        return;
    }
    NSString *endUrlStr = album_getCommentList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:combo_id forKey:@"album_id"];
    [mutabDict setObject:@"20" forKey:@"count"];
    [mutabDict setObject:@(pageCount) forKey:@"page"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (oath_token_Str != nil) {
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict objectForKey:@"code"] integerValue]) {
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
        }
        if (_dataSource.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        if (_dataSource.count<10) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        NSLog(@"11111");
    }];
    [op start];
}

// MARK: - 上拉加载更多评论数据
- (void)loadMoreCommentData {
    if (!SWNOTEmptyDictionary(_originDict)) {
        return;
    }
    NSString *combo_id = [NSString stringWithFormat:@"%@",[_originDict objectForKey:@"id"]];
    if (!SWNOTEmptyStr(combo_id)) {
        return;
    }
    NSString *endUrlStr = album_getCommentList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:combo_id forKey:@"album_id"];
    [mutabDict setObject:@"20" forKey:@"count"];
    [mutabDict setObject:@(pageCount) forKey:@"page"];
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (oath_token_Str != nil) {
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict objectForKey:@"code"] integerValue]) {
            NSArray *pass = [NSArray arrayWithArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
            [_dataSource addObjectsFromArray:pass];
            if (pass.count<10) {
                [_tableView setFooterHidden:YES];
            } else {
                [_tableView setFooterHidden:NO];
            }
        } else {
            pageCount--;
        }
        if (_dataSource.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        NSLog(@"11111");
        pageCount--;
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    }];
    [op start];
}

//套餐评论的配置
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
            _combo_comment_config = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"album_switch"]];
            _tableView.tableHeaderView = [_combo_comment_config isEqualToString:@"0"] ? _headerView : nil;
            if ([_combo_comment_config isEqualToString:@"0"]) {
                [self.imageView setTop:60];
                [self.imageView setHeight:_tableHeight - 60];
            } else {
                [self.imageView setTop:0];
                [self.imageView setHeight:_tableHeight];
            }
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

// MARK: - 详情页请求到了套餐评论开启与否的数据之后发通知过来改变ui
- (void)changeHeaderStatus:(NSNotification *)notice {
    _combo_comment_config = [NSString stringWithFormat:@"%@",[notice.userInfo objectForKey:@"config"]];
    _tableView.tableHeaderView = [_combo_comment_config isEqualToString:@"0"] ? _headerView : nil;
    if ([_combo_comment_config isEqualToString:@"0"]) {
        [self.imageView setTop:60];
        [self.imageView setHeight:_tableHeight - 60];
    } else {
        [self.imageView setTop:0];
        [self.imageView setHeight:_tableHeight];
    }
    [_tableView reloadData];
}

// MARK: - 评论视图背景点击事件
- (void)allWindowViewClick {
    [_textView removeFromSuperview];
    _textView = nil;
    [_moreView removeFromSuperview];
    _moreView = nil;
    [_allWindowView removeFromSuperview];
    _allWindowView = nil;
}

// MARK: - 键盘通知
- (void)keyboardWillShow:(NSNotification *)notif {
    if(![self.textView isFirstResponder]) {
        return;
    }
    NSDictionary *userInfo = [notif userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyboardRect = [aValue CGRectValue];
    CGFloat y = _keyboardRect.size.height;
    CGFloat x = _keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",(int)y);
    NSLog(@"键盘宽度是  %d",(int)x);
    [UIView animateWithDuration:0.25 animations:^{
        _moreView.frame = CGRectMake(0, MainScreenHeight - 210 * WideEachUnit - y, MainScreenWidth, 210 * WideEachUnit);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [UIView animateWithDuration:0.25 animations:^{
        _moreView.frame = CGRectMake(0, MainScreenHeight - 210 * WideEachUnit, MainScreenWidth, 210 * WideEachUnit);
    }];
}

// MARK: - 提交套餐评论
- (void)netWorkVideoAddReview {
    if (!SWNOTEmptyDictionary(_originDict)) {
        return;
    }
    NSString *combo_id = [NSString stringWithFormat:@"%@",[_originDict objectForKey:@"id"]];
    if (!SWNOTEmptyStr(combo_id)) {
        return;
    }
    NSString *endUrlStr = album_addReview;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:combo_id forKey:@"album_id"];
    [mutabDict setValue:_textView.text forKey:@"content"];
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
        [self allWindowViewClick];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            [self netWorkVideoGetRender];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            [self netWorkVideoGetRender];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [self allWindowViewClick];
        [TKProgressHUD showError:@"评论失败" toView:[UIApplication sharedApplication].keyWindow];
        NSLog(@"%@",error);
        NSLog(@"11111");
    }];
    [op start];
}

@end
