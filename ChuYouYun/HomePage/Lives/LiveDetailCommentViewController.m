//
//  LiveDetailCommentViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/29.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "LiveDetailCommentViewController.h"
#import "SYG.h"
#import "MyHttpRequest.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "rootViewController.h"



#import "DLViewController.h"
#import "Good_ClassCommentTableViewCell.h"


@interface LiveDetailCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger Num;
    NSInteger indexPathRow;
    NSInteger indexPathSection;
    BOOL      isScene;//是否配置（人脸识别）
    CGRect    _keyboardRect;
}
@property (strong ,nonatomic)UIImageView     *imageView;

@property (strong ,nonatomic)NSString        *ID;
@property (strong ,nonnull)NSDictionary      *dict;
@property (strong ,nonatomic)NSArray         *dataArray;
@property (strong ,nonatomic)UIView          *footView;
@property (strong ,nonatomic)UIView          *moreView;

@property (strong ,nonatomic)UIView          *tableHeaderView;
@property (strong ,nonatomic)UIView          *allWindowView;
@property (strong ,nonatomic)UITextView      *textView;
@property (strong ,nonatomic)UIButton        *starButton_One;
@property (strong ,nonatomic)UIButton        *starButton_Two;
@property (strong ,nonatomic)UIButton        *starButton_There;
@property (strong ,nonatomic)UIButton        *starButton_Four;
@property (strong ,nonatomic)UIButton        *starButton_Five;

@property (strong ,nonatomic)NSString        *starStr;
@property (strong ,nonatomic)NSDictionary    *dataSource;
@property (strong ,nonatomic)NSDictionary    *liveDataSource;
@property (strong ,nonatomic)NSString        *live_switch;

@end

@implementation LiveDetailCommentViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, _tabelHeight)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

-(void)viewWillAppear:(BOOL)animated {
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self netWorkLiveGetInfo];
}

-(void)viewWillDisappear:(BOOL)animated {
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableHeaderView];
    [self addTableView];
    [self netWorkVideoGetRender];
    [self netWorkLiveGetInfo];
    [self netWorkCourseReviewConf];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    Num = 0;
    indexPathRow = 0;
    indexPathSection = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addTableHeaderView {
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * WideEachUnit)];
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    [_tableHeaderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeaderViewClick:)]];
    [self.view addSubview:_tableHeaderView];
    
    //添加
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 25 * WideEachUnit, MainScreenWidth, 16 * WideEachUnit)];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    title.font = Font(16 * WideEachUnit);
    title.text = @"点评该直播";
    title.textAlignment = NSTextAlignmentCenter;
    [_tableHeaderView addSubview:title];
    
    
    for (int i = 0 ; i < 5; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(110 * WideEachUnit + 22 * i + 10 * i, 53 * WideEachUnit, 22, 22)];
        [button setBackgroundImage:[UIImage imageNamed:@"star1@3x"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"star2@3x"] forState:UIControlStateSelected];
        //        button.tag = i + 1;
        [button addTarget:self action:@selector(addAllWindow) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView addSubview:button];
    }
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _tableHeaderView;
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}


#pragma mark  --- 表格视图

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_live_switch integerValue] == 1) {
        _tableView.frame = CGRectMake(0, -36 * WideEachUnit, MainScreenWidth, MainScreenHeight * 5);
        return 0;
    } else {
        return 40 * WideEachUnit;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40 * WideEachUnit)];
    tableHeadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //添加标题
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth - 50 * WideEachUnit, 40 * WideEachUnit)];
    sectionTitle.text = @"评论详情（0人评论）";
    sectionTitle.text = [NSString stringWithFormat:@"评论详情(%ld人评论)",_dataArray.count];
    sectionTitle.textColor = [UIColor colorWithHexString:@"333"];
    sectionTitle.font = Font(14 * WideEachUnit);
    [tableHeadView addSubview:sectionTitle];
    if ([_live_switch integerValue] == 1) {
        return nil;
    } else {
        return tableHeadView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    Good_ClassCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Good_ClassCommentTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell dataSourceWithDict:dic];
    
    CGFloat scrollHight = _tableView.contentSize.height - 40 * WideEachUnit;
    if (currentIOS >= 11.0) {
        scrollHight = _tableView.contentSize.height - 20 * WideEachUnit;
        if (iPhoneX) {
            scrollHight = _tableView.contentSize.height + 20 * WideEachUnit;
        }
    }
    return cell;
}

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

#pragma mark --- 点击事件
- (void)starButtonCilck:(UIButton *)button {
    
    NSInteger K = button.tag;
    if (K == 1) {//一颗星
        _starButton_One.selected = YES;
        _starButton_Two.selected = NO;
        _starButton_There.selected = NO;
        _starButton_Four.selected = NO;
        _starButton_Five.selected = NO;
    } else if (K == 2) {//二颗星
        _starButton_One.selected = YES;
        _starButton_Two.selected = YES;
        _starButton_There.selected = NO;
        _starButton_Four.selected = NO;
        _starButton_Five.selected = NO;
        
    }  else if (K == 3) {//三颗星
        _starButton_One.selected = YES;
        _starButton_Two.selected = YES;
        _starButton_There.selected = YES;
        _starButton_Four.selected = NO;
        _starButton_Five.selected = NO;
        
    }  else if (K == 4) {//四颗星
        _starButton_One.selected = YES;
        _starButton_Two.selected = YES;
        _starButton_There.selected = YES;
        _starButton_Four.selected = YES;
        _starButton_Five.selected = NO;
        
    }  else if (K == 5) {//五颗星
        _starButton_One.selected = YES;
        _starButton_Two.selected = YES;
        _starButton_There.selected = YES;
        _starButton_Four.selected = YES;
        _starButton_Five.selected = YES;
        
    }
    //这里取到的tag值就是评论的星级个数
    _starStr = [NSString stringWithFormat:@"%ld",K];
}

- (void)subitButtonCilck:(UIButton *)button {
    [self netWorkVideoAddReview];
}

#pragma mark --- 手势
- (void)tableHeaderViewClick:(UIGestureRecognizer *)tap {
    if (!UserOathToken) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    [self addAllWindow];
}

#pragma mark --- 添加全局视图
- (void)addAllWindow {
    if (!UserOathToken) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if ([[_liveDataSource stringValueForKey:@"is_buy"] integerValue] == 0) {
        [TKProgressHUD showError:@"解锁之后才能评论" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds = YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit,MainScreenHeight - 210 * WideEachUnit,MainScreenWidth,210 * WideEachUnit)];
//    moreView.center = app.keyWindow.center;
//    moreView.center = CGPointMake(MainScreenWidth / 2, MainScreenHeight / 5 * 2);
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    moreView.userInteractionEnabled = YES;
    _allWindowView.userInteractionEnabled = YES;
    _moreView = moreView;
    
    //添加
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, 80 * WideEachUnit, 20 * WideEachUnit)];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    title.font = Font(12 * WideEachUnit);
    title.text = @"评价该直播";
//    title.textAlignment = NSTextAlignmentCenter;
    [moreView addSubview:title];
    
    for (int i = 0 ; i < 5; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100 * WideEachUnit + 22 * i + 10 * i, 10 * WideEachUnit, 22 * WideEachUnit, 22 * WideEachUnit)];
        [button setBackgroundImage:[UIImage imageNamed:@"star1@3x"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"star2@3x"] forState:UIControlStateSelected];
        button.tag = i + 1;
        [button addTarget:self action:@selector(starButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:button];
        if (i == 0) {
            _starButton_One = button;
        } else if (i == 1) {
            _starButton_Two = button;
        } else if (i == 2) {
            _starButton_There = button;
        } else if (i == 3) {
            _starButton_Four = button;
        } else if (i == 4) {
            _starButton_Five = button;
        }
    }
    
    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 70 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit, 100 * WideEachUnit)];
    textBackView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [moreView addSubview:textBackView];
    
    //添加textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0 * WideEachUnit, 180 * WideEachUnit, 100 * WideEachUnit)];
    _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [textBackView addSubview:_textView];
    
    //添加提交的按钮
    UIButton *subitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, CGRectGetMaxY(textBackView.frame) + 10 * WideEachUnit, 50 * WideEachUnit, 25 * WideEachUnit)];
    [subitButton setTitle:@"提交" forState:UIControlStateNormal];
    [subitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subitButton.backgroundColor = BasidColor;
    [subitButton addTarget:self action:@selector(subitButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:subitButton];
    
    
}

#pragma mark --- 手势
- (void)allWindowViewClick:(UIGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}


#pragma mark --- 键盘
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


#pragma mark --- 网络请求
//直播详情
- (void)netWorkLiveGetInfo {
    
    NSString *endUrlStr = YunKeTang_Live_live_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"live_id"];
    
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
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _liveDataSource = [dict dictionaryValueForKey:@"data"];
            } else {
             _liveDataSource= [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        if ([_liveDataSource isEqual:[NSArray array]]) {
            return ;
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//请求课程下的评论
- (void)netWorkVideoGetRender {
    
    NSString *endUrlStr = YunKeTang_Video_video_render;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"kzid"];
    [mutabDict setValue:@"1" forKey:@"kztype"]; // 2为专辑 1 为课程
    [mutabDict setObject:@"2" forKey:@"type"];
    
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
        if ([_dataSource isKindOfClass:[NSArray class]]) {
            _dataArray = (NSArray *)_dataSource;
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
        } else {
            _dataArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        }
        [_tableView reloadData];
        //发送通知 滚动的范围
//        CGFloat scrollHight = 0;
//        if (_dataArray.count == 0) {
//            scrollHight = 100 * WideEachUnit + 230 * WideEachUnit;
//        }
//        self.getCommentHight(scrollHight);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//课程添加评论
- (void)netWorkVideoAddReview {
    
    NSString *endUrlStr = YunKeTang_Video_video_addReview;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_ID forKey:@"kzid"];
    [mutabDict setValue:@"" forKey:@"title"];
    [mutabDict setValue:_textView.text forKey:@"content"];
    //评论星级
    [mutabDict setValue:_starStr forKey:@"score"];
    [mutabDict setValue:@"1" forKey:@"kztype"]; // 2为专辑 1 为课程
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        //        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            [_allWindowView removeFromSuperview];
            [self netWorkVideoGetRender];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            [_allWindowView removeFromSuperview];
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
            _live_switch = [dict stringValueForKey:@"live_switch"];
            if ([_live_switch integerValue] == 1) {//关
                _tableView.tableHeaderView = nil;
                [_tableView reloadData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
