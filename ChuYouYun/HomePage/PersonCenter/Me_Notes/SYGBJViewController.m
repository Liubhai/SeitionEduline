//
//  SYGBJViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/4.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SYGBJViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "NBaseClass.h"
#import "SBaseClass.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "MJRefresh.h"

#import "SYGBJTableViewCell.h"
#import "Passport.h"
#import "BJXQViewController.h"
#import "myBJ.h"
#import "SYG.h"
#import "UIColor+HTMLColors.h"
#import "TKProgressHUD+Add.h"


@interface SYGBJViewController ()<UITableViewDataSource,UITableViewDelegate>
{

}
@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSMutableArray   *dataArray;

@end

@implementation SYGBJViewController

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
    [self initer];
    [self addNav];
    [self addTableView];
    [self netWorkUserNotesGetMyList:1];
}

- (void)initer {
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"我的笔记";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineLab.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
    
}

- (void)addTableView {
    self.automaticallyAdjustsScrollViewInsets = false;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 24) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 24);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

- (void)headerRerefreshing
{
    [self netWorkUserNotesGetMyList:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if ([_dataArray isEqual:[NSNull null]]) {
        return 0;
    } else {
         return self.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"SYGBJTableViewCell";
    //自定义cell类
    SYGBJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SYGBJTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    cell.BTLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"note_title"]];
    cell.SJLabel.text = _dataArray[indexPath.row][@"strtime"];
    [cell setIntroductionText:_dataArray[indexPath.row][@"note_description"]];
    cell.PLLabel.text = _dataArray[indexPath.row][@"note_comment_count"];
    cell.DZLabel.text = _dataArray[indexPath.row][@"note_help_count"];
    cell.LZLabel.text = [NSString stringWithFormat:@"源自:%@",_dataArray[indexPath.row][@"video_title"]];
    [cell changeUI];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BJXQViewController *BJXQVC = [[BJXQViewController alloc] init];
    [self.navigationController pushViewController:BJXQVC animated:YES];
    BJXQVC.headStr = _dataArray[indexPath.row][@"userface"];
    BJXQVC.nameStr = _dataArray[indexPath.row][@"uname"];
    BJXQVC.timeStr = _dataArray[indexPath.row][@"strtime"];
    BJXQVC.isOpen = _dataArray[indexPath.row][@"is_open"];
    BJXQVC.JTStr = _dataArray[indexPath.row][@"note_description"];
    BJXQVC.titleStr = _dataArray[indexPath.row][@"note_title"];
    BJXQVC.ID = _dataArray[indexPath.row][@"id"];
    BJXQVC.dict = _dataArray[indexPath.row];
    
}


#pragma mark --- 网络请求
- (void)netWorkUserNotesGetMyList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_User_notes_getMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setValue:@"50" forKey:@"count"];
    
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
                if (Num == 1) {
                    _dataArray = (NSMutableArray *) [dict arrayValueForKey:@"data"];
                } else {
                    [_dataArray addObjectsFromArray:(NSMutableArray *) [dict arrayValueForKey:@"data"]];
                }
            } else {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                } else {
                    [_dataArray addObjectsFromArray:(NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
                }
            }
        }
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
