//
//  TeacherCommentViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TeacherCommentViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "DLViewController.h"

#import "Good_ClassCommentTableViewCell.h"





@interface TeacherCommentViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSInteger Num;
    NSInteger indexPathRow;
    NSInteger indexPathSection;
    BOOL      isScene;//是否配置（人脸识别）
}

@property (strong ,nonatomic)UITableView     *tableView;
@property (strong ,nonatomic)UIImageView     *imageView;
@property (strong ,nonatomic)UIView          *tableHeaderView;
@property (strong ,nonatomic)UIView          *allWindowView;
@property (strong ,nonatomic)UITextView      *textView;
@property (strong ,nonatomic)UIButton        *starButton_One;
@property (strong ,nonatomic)UIButton        *starButton_Two;
@property (strong ,nonatomic)UIButton        *starButton_There;
@property (strong ,nonatomic)UIButton        *starButton_Four;
@property (strong ,nonatomic)UIButton        *starButton_Five;

@property (strong ,nonatomic)NSMutableArray         *dataArray;
@property (strong ,nonatomic)NSString        *ID;
@property (strong ,nonatomic)NSString        *starStr;
@property (strong ,nonatomic)NSDictionary    *dataSource;

@property (strong ,nonatomic)NSArray         *commentArray;

@end

@implementation TeacherCommentViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, 200)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据 （小）"];
        if (iPhone6) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 230, 200, 200);
        } else if (iPhone6Plus) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 180, 200, 200);
        } else if (iPhone5o5Co5S) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 0, 200, 200);
        }
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    [self interFace];
    [self addTableHeaderView];
    [self addTableView];
//    [self netWorkVideoGetRender];
    [self netWorkTeacherGetCommentList:1];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    Num = 1;
    indexPathRow = 0;
    indexPathSection = 0;
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
    title.text = @"点评该讲师";
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
//    _tableView.rowHeight = 85 * WideEachUnit;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _tableHeaderView;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
//    [_tableView headerBeginRefreshing];
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}


- (void)headerRerefreshing {
    Num = 1;
    [self netWorkTeacherGetCommentList:Num];
}

- (void)footerRefreshing {
    Num = Num + 1;
    [self netWorkTeacherGetCommentListMore:Num];
}


#pragma mark  --- 表格视图

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;//40 * WideEachUnit;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /**
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40 * WideEachUnit)];
    tableHeadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //添加标题
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth - 50 * WideEachUnit, 40 * WideEachUnit)];
    sectionTitle.text = @"评论详情";
    sectionTitle.textColor = [UIColor colorWithHexString:@"333"];
    sectionTitle.font = Font(14 * WideEachUnit);
    [tableHeadView addSubview:sectionTitle];
    return tableHeadView;
    */
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 10 * WideEachUnit;
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (!UserOathToken) {
        [_allWindowView removeFromSuperview];
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
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
    [self netWorkTeacherAddReview];
}

#pragma mark --- 手势
- (void)tableHeaderViewClick:(UIGestureRecognizer *)tap {
    if (!UserOathToken) {
        [_allWindowView removeFromSuperview];
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    [self addAllWindow];
}

#pragma mark --- 添加全局视图
- (void)addAllWindow {
    if (!UserOathToken) {
        [_allWindowView removeFromSuperview];
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
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
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WideEachUnit,44 * WideEachUnit,200 * WideEachUnit,210 * WideEachUnit)];
    moreView.center = app.keyWindow.center;
    moreView.center = CGPointMake(MainScreenWidth / 2, MainScreenHeight / 3);
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    moreView.userInteractionEnabled = YES;
    _allWindowView.userInteractionEnabled = YES;
    
    //添加
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, 180 * WideEachUnit, 12 * WideEachUnit)];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    title.font = Font(12 * WideEachUnit);
    title.text = @"评价该讲师";
    title.textAlignment = NSTextAlignmentCenter;
    [moreView addSubview:title];
    
    for (int i = 0 ; i < 5; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20 * WideEachUnit + 22 * i + 10 * i, 35 * WideEachUnit, 22 * WideEachUnit, 22 * WideEachUnit)];
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
    
    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 * WideEachUnit, 200 * WideEachUnit, 100 * WideEachUnit)];
    textBackView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [moreView addSubview:textBackView];
    
    //添加textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 5 * WideEachUnit, 180 * WideEachUnit, 90 * WideEachUnit)];
    _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [textBackView addSubview:_textView];
    
    //添加提交的按钮
    UIButton *subitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textBackView.frame), 200 * WideEachUnit, 40 * WideEachUnit)];
    [subitButton setTitle:@"提交" forState:UIControlStateNormal];
    [subitButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [subitButton addTarget:self action:@selector(subitButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:subitButton];
    
    
}

#pragma mark --- 手势
- (void)allWindowViewClick:(UIGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

#pragma mark --- 网络请求
//获取讲师评论列表
- (void)netWorkTeacherGetCommentList:(NSInteger)num {

    NSString *endUrlStr = YunKeTang_Teacher_teacher_getCommentList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_ID forKey:@"teacher_id"];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setValue:@"10" forKey:@"count"];
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
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[dict arrayValueForKey:@"data"]];
            } else {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:(NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        [_tableView headerEndRefreshing];
        if (_dataArray.count<10) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        [_tableView reloadData];
        //发送通知 滚动的范围
        CGFloat scrollHight = _tableView.contentSize.height - 40 * WideEachUnit;
        NSString *hightStr = [NSString stringWithFormat:@"%lf",scrollHight];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TeacherCommentScrollHight" object:hightStr];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

#pragma mark --- 网络请求
//获取讲师评论列表
- (void)netWorkTeacherGetCommentListMore:(NSInteger)num {
    
    NSString *endUrlStr = YunKeTang_Teacher_teacher_getCommentList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_ID forKey:@"teacher_id"];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setValue:@"10" forKey:@"count"];
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
        NSArray *newArray;
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                newArray = [dict arrayValueForKey:@"data"];
            } else {
                newArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject];
            }
            if (newArray == 0) {
                Num = Num - 1;
            }
            [_dataArray addObjectsFromArray:newArray];
        } else {
            Num = Num - 1;
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        [_tableView footerEndRefreshing];
        if (newArray.count<10) {
            [_tableView setFooterHidden:YES];
        } else {
            [_tableView setFooterHidden:NO];
        }
        [_tableView reloadData];
        //发送通知 滚动的范围
        CGFloat scrollHight = _tableView.contentSize.height - 40 * WideEachUnit;
        NSString *hightStr = [NSString stringWithFormat:@"%lf",scrollHight];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TeacherCommentScrollHight" object:hightStr];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



//讲师添加评论
- (void)netWorkTeacherAddReview {
    
    NSString *endUrlStr = YunKeTang_Teacher_teacher_addReview;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_ID forKey:@"teacher_id"];
    [mutabDict setValue:@"" forKey:@"title"];
    [mutabDict setValue:_textView.text forKey:@"content"];
    //评论星级
    [mutabDict setValue:_starStr forKey:@"score"];
    [mutabDict setValue:@"0" forKey:@"is_secret"];
    
//    [mutabDict setValue:_ID forKey:@"kzid"];
//    [mutabDict setValue:@"" forKey:@"title"];
//    [mutabDict setValue:_textView.text forKey:@"content"];
//    //评论星级
//    [mutabDict setValue:_starStr forKey:@"score"];
    [mutabDict setValue:@"4" forKey:@"kztype"]; // 2为专辑 1 为课程
    
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            [_allWindowView removeFromSuperview];
            [self netWorkTeacherGetCommentList:1];
        } else {
            [_allWindowView removeFromSuperview];
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


@end
