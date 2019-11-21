//
//  receiveCommandViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define SYGColer [UIColor colorWithRed:240.f / 255 green:240.f / 255 blue:240.f / 255 alpha:1]

#import "receiveCommandViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "CMBaseClass.h"
#import "UIButton+WebCache.h"
#import "Passport.h"
#import "SYGCommandTableViewCell.h"
#import "emotionjiexi.h"
#import "UIColor+HTMLColors.h"
#import "GLReachabilityView.h"
#import "SYG.h"


@interface receiveCommandViewController ()
{
    NSArray *arr;
    NSString * labelStr;
    NSString * cmdStr;
    CGRect rect;
}
@end

@implementation receiveCommandViewController

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
    _titleImage.hidden = YES;
    [self interFace];
    [self addTableView];
    [self netWorkMessageComment];
}

- (void)interFace {
    rect = [UIScreen mainScreen].applicationFrame;
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"收到的评论";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 45, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineLab.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.muArr.count==0) {
    }else{
        
    }
    return self.muArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 15 + 30 + 40;

    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.sectionHeaderHeight, tableView.frame.size.width)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"SYGBJTableViewCell";
    //自定义cell类
    SYGCommandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SYGCommandTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    

    CMBaseClass *cm = [self.muArr objectAtIndex:indexPath.row];
//    NSDictionary *myDic = [NSDictionary dictionaryWithDictionary:cm.fidinfo];
    cell.myHeadImage.layer.cornerRadius = 25;
    cell.myHeadImage.layer.masksToBounds = YES;
    [cell.myHeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:_allArray[indexPath.row][@"uidinfo"][@"avatar_big"]] forState:UIControlStateNormal];

    [cell.SCButton setTitle:@"" forState:UIControlStateNormal];

    cell.myName.text = [NSString stringWithFormat:@"%@",_allArray[indexPath.row][@"uidinfo"][@"uname"]];
    NSString *name =  [[NSUserDefaults standardUserDefaults] objectForKey:@"uname"];
    cell.dayLabel.text = [Passport formatterDate:_allArray[indexPath.row][@"ctime"]];

    NSString *Info = [NSString stringWithFormat:@"%@",_allArray[indexPath.row][@"to_comment"]];
    NSString *JJ = [Passport filterHTML:Info];
//    [cell setIntroductionText:JJ];
    cell.JTLabel.text = JJ;
    [cell setIntroductionTextName:name];
    cell.GDLabel.text = cm.toComment;
    NSString *JXStr = _allArray[indexPath.row][@"info"];
    cell.GDLabel.text = JXStr;
//    cell.GDLabel.attributedText = [emotionjiexi jiexienmojconent:JXStr font:[UIFont systemFontOfSize:16]];
//    [cell setIntroductionOtherText:JXStr];
//
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self delDataAtIndex:indexPath.row];
        
        [self.muArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --- 事件处理

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)relaodWeb:(UIButton *)sender
{
//    CMBaseClass *cm = [self.muArr objectAtIndex:sender.tag];
//    NSDictionary *uidinfo = [[NSDictionary alloc]initWithDictionary:cm.uidinfo];
    
}
-(void)deleteClick:(UIButton *)btn
{
//    TextCommandCell *cell = (TextCommandCell *)[[[btn superview]superview] superview];
//    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
}

#pragma mark --- Tool

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

#pragma mark --- 网络请求
//获取消息列表
- (void)netWorkMessageComment {
    
    NSString *endUrlStr = YunKeTang_Message_message_comment;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1" forKey:@"page"];
    [mutabDict setObject:@"20" forKey:@"count"];
    
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
                _dataArr = (NSMutableArray *) [dict arrayValueForKey:@"data"];
            } else {
                _dataArr = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }

        for (int i = 0; i < _dataArr.count; i++) {
            CMBaseClass *cm =[[CMBaseClass alloc]initWithDictionary:[_dataArr objectAtIndex:i]];
            [self.muArr addObject:cm];
        }
        _allArray = _dataArr;
        if (_dataArr.count == 0) {
            self.tableView.alpha = 0;
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
            [self.view addSubview:imageView];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


-(void)reloadComand
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"5" forKey:@"count"];
    [manager reloadCommandForMe:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![[responseObject objectForKey:@"data"]isEqual:[NSNull null]]) {
            _dataArr=[NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
            for (int i=0; i<_dataArr.count; i++) {
                CMBaseClass *cm =[[CMBaseClass alloc]initWithDictionary:[_dataArr objectAtIndex:i]];
                [self.muArr addObject:cm];
            }
            _allArray = responseObject[@"data"];
            [self.tableView reloadData];
        }else
        {
            self.tableView.alpha = 0;
            
            //添加空白处理
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
            [self.view addSubview:imageView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)delDataAtIndex:(NSInteger)indexRow {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    CMBaseClass *cmb = [self.muArr objectAtIndex:indexRow];
    
    [dic setObject:cmb.internalBaseClassIdentifier forKey:@"id"];
    [manager delCommandForMe:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



@end
