//
//  InstitutionsChooseVC.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/10/22.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "InstitutionsChooseVC.h"
#import "InstitutionsTableViewCell.h"


@interface InstitutionsChooseVC ()

@end

@implementation InstitutionsChooseVC

-(void)viewWillAppear:(BOOL)animated
{
    if (_fromSetingVC) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [super viewWillAppear:animated];
        self.navigationController.navigationBar.hidden = YES;
    } else {
        [super viewWillAppear:animated];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (_fromSetingVC) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:NO];
        [super viewWillDisappear:animated];
        self.navigationController.navigationBar.hidden = NO;
    } else {
        [super viewWillDisappear:animated];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.backgroundColor = BasidColor;
    [self initDataSource];
    [self makeUI];
    [self getRecommendInstitutions];
    
}

- (void)initDataSource {
    _recommendArray = [NSMutableArray new];
    _searchArray = [NSMutableArray new];
}

- (void)makeUI {
    
    _leftButton.hidden = YES;
    _lineTL.hidden = YES;
    
    // 顶部搜索框和 取消按钮
    _institutionSearch = [[SYGTextField alloc] initWithFrame:CGRectMake(15 * WideEachUnit, NavigationBarSubViewHeight, MainScreenWidth - 75, 36)];
    if (_fromSetingVC) {
        _leftButton.hidden = NO;
        _institutionSearch.frame = CGRectMake(_leftButton.right + 5, NavigationBarSubViewHeight, MainScreenWidth - (_leftButton.right + 5 + 60), 36);
    }
    _institutionSearch.placeholder = @"输入机构名称";
    _institutionSearch.font = Font(14 * WideEachUnit);
    [_institutionSearch setValue:Font(16) forKeyPath:@"_placeholderLabel.font"];
    _institutionSearch.delegate = self;
    _institutionSearch.returnKeyType = UIReturnKeySearch;
    _institutionSearch.layer.cornerRadius = 18;
    _institutionSearch.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _institutionSearch.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _institutionSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _institutionSearch.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _institutionSearch.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
    [button setImage:Image(@"yunketang_search") forState:UIControlStateNormal];
    [_institutionSearch.leftView addSubview:button];
    [_titleImage addSubview:_institutionSearch];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 0, 60, 36)];
    _cancelButton.centerY = _institutionSearch.centerY;
    [_titleImage addSubview:_cancelButton];
    [_cancelButton setTitle:@"取消" forState:0];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:0];
    _cancelButton.titleLabel.font = SYSTEMFONT(14);
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 推荐板块儿容器
    _recommendScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    [self.view addSubview:_recommendScrollView];
    
    _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _searchResultTableView.dataSource = self;
    _searchResultTableView.delegate = self;
    _searchResultTableView.showsVerticalScrollIndicator = NO;
    _searchResultTableView.showsHorizontalScrollIndicator = NO;
    _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_searchResultTableView addHeaderWithTarget:self action:@selector(reloadFirstPageData)];
    [self.view addSubview:_searchResultTableView];
    _searchResultTableView.hidden = YES;
}

- (void)cancelButtonClick {
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"institutionId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.institutionChooseFinished(YES);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuse = @"intitutionCell";
    InstitutionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
    if (!cell) {
        cell = [[InstitutionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuse];
    }
    [cell setInstitutionInfo:_searchArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[_searchArray[indexPath.row] objectForKey:@"id"]] forKey:@"institutionId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.institutionChooseFinished(YES);
}

// MARK: - 获取推荐机构列表
- (void)getRecommendInstitutions {
    NSString *endUrlStr = home_searchSchool;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    if (_institutionSearch.text.length > 0) {
       [mutabDict setObject:_institutionSearch.text forKey:@"keyword"];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict objectForKey:@"code"] integerValue] == 1) {
            [_recommendArray removeAllObjects];
            [_recommendArray addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
            [self makeRecommendInstitutionsUI];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)reloadFirstPageData {
    NSString *endUrlStr = home_searchSchool;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    if (_institutionSearch.text.length > 0) {
        [mutabDict setObject:_institutionSearch.text forKey:@"keyword"];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if (_searchResultTableView.headerRefreshing) {
            [_searchResultTableView headerEndRefreshing];
        }
        if ([[dict objectForKey:@"code"] integerValue] == 1) {
            [_searchArray removeAllObjects];
            [_searchArray addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
        }
        [_searchResultTableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (_searchResultTableView.headerRefreshing) {
            [_searchResultTableView headerEndRefreshing];
        }
    }];
    [op start];
}

// MARK: - 布局推荐机构板块儿UI
- (void)makeRecommendInstitutionsUI {
    [_recommendScrollView removeAllSubviews];
    UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, MainScreenWidth - 15, 21)];
    themeLabel.font = SYSTEMFONT(15);
    themeLabel.text = @"推荐机构";
    themeLabel.textColor = RGBHex(0x333333);
    [_recommendScrollView addSubview:themeLabel];
    CGFloat x = 15;
    CGFloat y = themeLabel.bottom + 10;
    CGFloat spaceX = 5;
    CGFloat spaceY = 10;
    CGFloat butHeight = 30;
    for (int i = 0; i<_recommendArray.count; i++) {
        NSString *institutionName = [NSString stringWithFormat:@"%@",[_recommendArray[i] objectForKey:@"title"]];
        CGFloat nameWidth = [institutionName sizeWithFont:SYSTEMFONT(15)].width + 10;
        if ((x+nameWidth)>MainScreenWidth) {
            x = 15;
            y = y + butHeight + spaceY;
        }
        UIButton *institutionButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, nameWidth, butHeight)];
        [institutionButton setTitle:institutionName forState:0];
        [institutionButton setTitleColor:RGBHex(0x333333) forState:0];
        institutionButton.titleLabel.font = SYSTEMFONT(15);
        institutionButton.layer.masksToBounds = YES;
        institutionButton.layer.cornerRadius = butHeight / 2.0;
        institutionButton.layer.borderColor = RGBHex(0xF3F3F3).CGColor;
        institutionButton.layer.borderWidth = 1;
        institutionButton.tag = i;
        [institutionButton addTarget:self action:@selector(institutionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_recommendScrollView addSubview:institutionButton];
        x = x + spaceX + nameWidth;
    }
    if ((y + butHeight)>_recommendScrollView.height) {
        _recommendScrollView.contentSize = CGSizeMake(MainScreenWidth, y + butHeight);
    }
}

- (void)institutionButtonClicked:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[_recommendArray[sender.tag] objectForKey:@"id"]] forKey:@"institutionId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.institutionChooseFinished(YES);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.institutionSearch) {
        [self.institutionSearch resignFirstResponder];
        if (self.institutionSearch.text.length > 0) {
            _recommendScrollView.hidden = YES;
            _searchResultTableView.hidden = NO;
            [_searchResultTableView headerBeginRefreshing];
        } else {
            _recommendScrollView.hidden = NO;
            _searchResultTableView.hidden = YES;
            [self getRecommendInstitutions];
        }
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
