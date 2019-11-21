//
//  GZViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/15.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "GZViewController.h"
#import "AttentionCell.h"
#import "UIButton+WebCache.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "MyUIButton.h"
#import "ZhiyiHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "ATData.h"
#import "MJRefresh.h"
#import "GZTableViewCell.h"
#import "MessageSendViewController.h"
#import "SYG.h"



#import "ZFDownloadManager.h"


@interface GZViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    BOOL isAttention;
    BOOL isAttentionType;
    CGRect rect;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSArray     *dataArray;

@end

@implementation GZViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
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
    WZLabel.text = @"关注";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNav];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 36) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    isAttentionType = YES;
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //关注标志
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

- (void)headerRerefreshing
{
    [self netWorkUserFollowingList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

//关注其他用户
-(void)attention
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    ATData *atd = [[ATData alloc]init];
    atd = [self.muArr objectAtIndex:self.row];
    [dic setObject:atd.uid forKey:@"user_id"];
    [manager userAttention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *msg = [responseObject objectForKey:@"msg"];
        
        if ([msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"关注成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)cancelAttention
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    ATData *atd = [[ATData alloc]init];
    atd = [self.muArr objectAtIndex:self.row];
    [dic setObject:atd.uid forKey:@"user_id"];
    [manager cancelUserAttention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"99%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"取消关注成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];

            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.muArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ATData *adt = [self.muArr objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"SYGBJTableViewCell";
    //自定义cell类
    GZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GZTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    [cell.HeadImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:adt.avatarSmall] forState:UIControlStateNormal];
    cell.NameLabel.text = adt.uname;
    NSLog(@"----%@",adt.intro);
    if ([adt.intro isEqual:[NSNull null]] || adt.intro == nil) {
        cell.TextLabel.text = @"PHP太懒,什么都没留下";
    }else {
        cell.TextLabel.text = adt.intro;
    }

    //判断是否关注
    if ([_arr[indexPath.row][@"follow_state"][@"follower"] integerValue] == 1 && [_arr[indexPath.row][@"follow_state"][@"following"] integerValue] == 1) { //说明都是1 为互相关注
        [cell.GZButton setBackgroundImage:[UIImage imageNamed:@"相互关注@2x"] forState:UIControlStateNormal];
    } else {//不是互相关注的时候
        [cell.GZButton setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:UIControlStateNormal];
    }

    cell.GZButton.enabled = NO;
    [cell.GZButton addTarget:self action: @selector(addtentionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.GZButton.tag = indexPath.row;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    ATData *adt = [self.muArr objectAtIndex:indexPath.row];
    NSDictionary *attentionType = adt.followState;
    isAttention = [[attentionType objectForKey:@"follower"] integerValue];
    
    self.row = indexPath.row;
    NSString *str;
    if (isAttention == YES) {
        str = @"取消关注";
    }else
    {
        str = @"取消关注";
    }
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"私信" otherButtonTitles:str, nil];
    action.delegate = self;
    [action showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ATData *ad = [[ATData alloc]init];
    ad = [self.muArr objectAtIndex:self.row];
    if (buttonIndex == 0)
    {
        
        MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
        MSVC.TID = ad.uid;
        MSVC.name = ad.uname;
        [self.navigationController pushViewController:MSVC animated:YES];

        
        
    }else if (buttonIndex == 1)
    {
        NSMutableDictionary *followStateDic = [NSMutableDictionary dictionaryWithDictionary:ad.followState];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.row inSection:0];
        AttentionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        isAttention = [[followStateDic objectForKey:@"follower"] integerValue];
        
        ad.followState = nil;
        [followStateDic setValue:@"1" forKey:@"follower"];
        ad.followState = followStateDic;
        [_muArr replaceObjectAtIndex:self.row withObject:ad];
        
        [cell setAttentionType:1 following:[[followStateDic objectForKey:@"following"] integerValue] isSelf:NO];
        //            [self attention];
        [self cancelAttention];
        
        //删除关注列表里面的cell
        [self.muArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSIndexSet * set =[NSIndexSet indexSetWithIndex:indexPath.section];
        //NSIndexSet－－索引集合
        [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
    }
}

-(void)headClick:(UIButton *)btn
{
    
}
-(void)addtentionClick:(MyUIButton*)btn
{
    BOOL pressed = YES;
    [btn setIsPressed:pressed];
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

#pragma mark --- 网络请求
//获取用户关注列表
- (void)netWorkUserFollowingList {
    
    NSString *endUrlStr = YunKeTang_User_user_followingList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:UserID forKey:@"user_id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
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
            _dataArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        }
        if (_dataArray.count == 0) {
            self.tableView.alpha = 0;
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
            NSMutableArray *uArr = [[NSMutableArray alloc]initWithCapacity:0];
            for (int i = 0; i < _dataArray.count; i++) {
                ATData *atd = [[ATData alloc]initWithDictionary:[_dataArray objectAtIndex:i]];
                [uArr addObject:atd];
            }
            self.muArr = [NSMutableArray arrayWithArray:uArr];
            [self.tableView reloadData];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


////添加关注
//- (void)netWorkUseFollow {
//
//    NSString *endUrlStr = YunKeTang_User_user_follow;
//    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
//
//    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
//    if ([userID isEqualToString:_uID]) {//说明是自己
//        [TKProgressHUD showError:@"不能关注自己" toView:self.view];
//        return;
//    }
//    if (_uID == nil) {
//        [TKProgressHUD showError:@"不能关注自己的机构" toView:self.view];
//        return;
//    } else {
//        if ([_myUID integerValue] == [_uID integerValue]) {
//            [TKProgressHUD showError:@"不能关注自己的机构" toView:self.view];
//            return;
//        } else {
//            [mutabDict setObject:_uID forKey:@"user_id"];
//        }
//    }
//
//    NSString *oath_token_Str = nil;
//    if (UserOathToken) {
//        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
//    }
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
//    [request setHTTPMethod:NetWay];
//    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
//    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
//    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
//
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
//        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
//            [TKProgressHUD showSuccess:@"关注成功" toView:self.view];
//            [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
//            return ;
//        } else {
//            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
//        }
//
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//    }];
//    [op start];
//}
//
//
////取消关注
//- (void)netWorkUseUnFollow {
//
//    NSString *endUrlStr = YunKeTang_User_user_unfollow;
//    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
//
//    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [mutabDict setValue:_uID forKey:@"user_id"];
//    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
//    if ([userID isEqualToString:_uID]) {//说明是自己
//        [TKProgressHUD showError:@"不能关注自己" toView:self.view];
//        return;
//    }
//
//    NSString *oath_token_Str = nil;
//    if (UserOathToken) {
//        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
//    } else {
//        DLViewController *DLVC = [[DLViewController alloc] init];
//        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
//        [self.navigationController presentViewController:Nav animated:YES completion:nil];
//        return;
//    }
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
//    [request setHTTPMethod:NetWay];
//    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
//    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
//    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
//
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
//        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
//            [TKProgressHUD showSuccess:@"取消关注成功" toView:self.view];
//            [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
//            return ;
//        } else {
//            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
//        }
//
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//    }];
//    [op start];
//}


@end
