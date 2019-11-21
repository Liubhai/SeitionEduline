//
//  MyMsgViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define SYGColer [UIColor colorWithRed:240.f / 255 green:240.f / 255 blue:240.f / 255 alpha:1]

#import "MyMsgViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "MData.h"
#import "MLastMessage.h"
#import "UIButton+WebCache.h"
#import "MLastMessage.h"
#import "Passport.h"
#import "SXXQViewController.h"
#import "emotionjiexi.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HTMLColors.h"
#import <UIKit/UIKit.h>
#import "GLReachabilityView.h"
#import "SYG.h"
#import "MsgCell.h"

#import "Good_MyMsgTableViewCell.h"


@interface MyMsgViewController ()<UIAlertViewDelegate>
{
    CGRect rect;
}
@end

@implementation MyMsgViewController
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
    [self netWorkMessageGetList];
}

- (void)interFace {
    rect = [UIScreen mainScreen].applicationFrame;
    self.msgArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.to_user_infoArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];
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
    WZLabel.text = @"我的私信";
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
    self.tableView.showsVerticalScrollIndicator = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //以前的 （要结合接口一起优化）
    
    static NSString *Identifier = @"Cell";
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"MsgCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        [cell.typeImg.layer setMasksToBounds:YES];
        [cell.typeImg.layer setCornerRadius:5]; //设置矩形四个圆角半径
        [cell.typeImg.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255.0/255.0, 255.0/255.0, 255.0/255.0, 1 });
        [cell.typeImg.layer setBorderColor:colorref];//边框颜色

        [cell.headBtn.layer setMasksToBounds:YES];
        [cell.headBtn.layer setCornerRadius:24.0];
        [cell.headBtn addTarget:self action:@selector(msgClick:) forControlEvents:0];
    }

    NSDictionary *msgDic = [NSDictionary dictionaryWithDictionary:[_msgArr objectAtIndex:indexPath.row]];
    NSArray *arr = [msgDic objectForKey:@"to_uid"];
    NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[_to_user_infoArr objectAtIndex:indexPath.row]];

    if ([_msgArr[indexPath.row][@"user_info"] isKindOfClass:[NSNumber class]]) {
        cell.userName.text = [NSString stringWithFormat:@""];
    } else {
        cell.userName.text = [NSString stringWithFormat:@"%@@",_msgArr[indexPath.row][@"user_info"][@"uname"]];
    }
    if (arr.count) {
        NSString *key= [arr objectAtIndex:0];

        if (![key isEqual:@""]) {

            NSString *faceUrl;
            NSDictionary *toUserInfo = [userDic objectForKey:key];
            if ([toUserInfo isEqual:[NSNumber numberWithInteger:0]]) {
                return cell;
            }

            faceUrl = [toUserInfo objectForKey:@"avatar_small"];

            cell.userName.text = [toUserInfo objectForKey:@"uname"];
//            cell.userName.text = [NSString stringWithFormat:@"%@@",_msgArr[indexPath.row][@"user_info"][@"uname"]];
            
            if ([_msgArr[indexPath.row][@"user_info"] isKindOfClass:[NSNumber class]]) {
                cell.userName.text = [NSString stringWithFormat:@""];
            } else {
                cell.userName.text = [NSString stringWithFormat:@"%@@",_msgArr[indexPath.row][@"user_info"][@"uname"]];
            }

            [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:faceUrl] forState:UIControlStateNormal placeholderImage:nil];

            cell.magDate.text = [Passport formatterDate:_magArr[indexPath.row][@"list_ctime"]];
            cell.magDate.textColor = [UIColor grayColor];
            cell.msg.text =[msgDic objectForKey:@"content"];
            NSString *str = [msgDic objectForKey:@"content"];

            cell.msg.attributedText = [emotionjiexi jiexienmojconent:str font:[UIFont systemFontOfSize:15]];
            cell.msg.textColor = [UIColor grayColor];
        } else {

        }
    }

    NSString *selfUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
//    if ([_msgArr[indexPath.row][@"user_info"][@"uid"] isEqualToString:selfUID]) {
//        cell.userName.text = [[[_magArr objectAtIndex:indexPath.row] dictionaryValueForKey:@"to_user_info"] stringValueForKey:@"uname" defaultValue:@""];
//        [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_magArr[indexPath.row][@"to_user_info"][@"avatar_big"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
//    } else {
//        cell.userName.text = [NSString stringWithFormat:@"%@",_msgArr[indexPath.row][@"user_info"][@"uname"]];
//        cell.userName.text = [[[_msgArr objectAtIndex:indexPath.row] dictionaryValueForKey:@"user_info"] stringValueForKey:@"uname" defaultValue:@""];
//        [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_msgArr[indexPath.row][@"user_info"][@"avatar_big"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
//    }
    
    if ([_msgArr[indexPath.row][@"user_info"] isKindOfClass:[NSNumber class]]) {
        cell.userName.text = [[[_magArr objectAtIndex:indexPath.row] dictionaryValueForKey:@"to_user_info"] stringValueForKey:@"uname" defaultValue:@""];
        [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_magArr[indexPath.row][@"to_user_info"][@"avatar_big"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    } else {
        if ([_msgArr[indexPath.row][@"user_info"][@"uid"] isEqualToString:selfUID]) {
            cell.userName.text = [[[_magArr objectAtIndex:indexPath.row] dictionaryValueForKey:@"to_user_info"] stringValueForKey:@"uname" defaultValue:@""];
            [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_magArr[indexPath.row][@"to_user_info"][@"avatar_big"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        } else {
            cell.userName.text = [NSString stringWithFormat:@"%@",_msgArr[indexPath.row][@"user_info"][@"uname"]];
            cell.userName.text = [[[_msgArr objectAtIndex:indexPath.row] dictionaryValueForKey:@"user_info"] stringValueForKey:@"uname" defaultValue:@""];
            [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_msgArr[indexPath.row][@"user_info"][@"avatar_big"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        }
    }
    
    
    
    //最后面的优化
    cell.userName.text = [[[_magArr objectAtIndex:indexPath.row] dictionaryValueForKey:@"and_user_info"] stringValueForKey:@"uname" defaultValue:@""];
    [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_magArr[indexPath.row][@"and_user_info"][@"avatar_big"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    
    cell.magDate.text = [Passport formatterDate:_magArr[indexPath.row][@"list_ctime"]];;
    cell.msg.text = [[_msgArr objectAtIndex:indexPath.row] stringValueForKey:@"content"];
    cell.msg.attributedText = [emotionjiexi jiexienmojconent:[[_msgArr objectAtIndex:indexPath.row] stringValueForKey:@"content"] font:[UIFont systemFontOfSize:15]];

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *faceUrl = nil;
    faceUrl = _magArr[indexPath.row][@"and_user_info"][@"avatar_big"];
    NSString *toUid = _magArr[indexPath.row][@"and_user_info"][@"uid"];
    SXXQViewController *SXXQVC = [[SXXQViewController alloc] initWithChatUserid: [[_magArr objectAtIndex:indexPath.row] stringValueForKey:@"list_id"] uFace:faceUrl toUserID:toUid sendToID:nil];
    [self.navigationController pushViewController:SXXQVC animated:YES];
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark --- 事件处理

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)msgClick:(UIButton *)btn {
    
}

#pragma mark --- 网络请求
//获取消息列表
- (void)netWorkMessageGetList {
    
    NSString *endUrlStr = YunKeTang_Message_message_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1"forKey:@"tab"];
    [mutabDict setObject:@"50"forKey:@"limit"];
    
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
                _magArr = (NSMutableArray *)[dict arrayValueForKey:@"data"];
            } else {
                _magArr = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        
        for (int i = 0; i<_magArr.count; i++) {
            NSDictionary *data = [_magArr objectAtIndex:i];
            NSDictionary *last = [data objectForKey:@"last_message"];
            NSDictionary *userInfo = [data objectForKey:@"to_user_info"];
            
            if (![userInfo isEqual:[NSNull null]]) {
                [self.msgArr addObject:last];
                [self.to_user_infoArr addObject:userInfo];
                [self.dataArr addObject:data];
            }
        }
        if (_msgArr.count == 0) {
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







@end
