//
//  Attention_StudentViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/2/27.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "Attention_StudentViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "GZTableViewCell.h"

@interface Attention_StudentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray     *dataArray;

@end

@implementation Attention_StudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self netWorkUserLineVideoGetFollowList:1];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 88 - 34 + 36);
    }
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.rowHeight = 85 * WideEachUnit;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- UITableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SYGBJTableViewCell";
    //自定义cell类
    GZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GZTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    NSDictionary *userDict = [dict dictionaryValueForKey:@"user"];
    [cell.HeadImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[userDict stringValueForKey:@"avatar_big"]] forState:UIControlStateNormal];
    cell.NameLabel.text = [userDict stringValueForKey:@"uname"];
    if ([[userDict stringValueForKey:@"info"] isEqual:[NSNull null]] && [userDict stringValueForKey:@"intro"] == nil) {
        cell.TextLabel.text = @"PHP太懒,什么都没留下";
    }else {
        cell.TextLabel.text = [userDict stringValueForKey:@"intro"];
    }
    
    
    
    //判断是否关注
    if ([_dataArray[indexPath.row][@"follow_state"][@"follower"] integerValue] == 1 && [_dataArray[indexPath.row][@"follow_state"][@"following"] integerValue] == 1) { //说明都是1 为互相关注
        [cell.GZButton setBackgroundImage:[UIImage imageNamed:@"相互关注@2x"] forState:UIControlStateNormal];
    } else {//不是互相关注的时候
        [cell.GZButton setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:UIControlStateNormal];
    }
    
    cell.fansLabel.text = [NSString stringWithFormat:@"粉丝：%@",[dict stringValueForKey:@"follow_nums"]];
    
    cell.GZButton.enabled = NO;
    cell.GZButton.hidden = YES;
    //    [cell.GZButton addTarget:self action: @selector(addtentionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.GZButton.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 网络请求
- (void)netWorkUserLineVideoGetFollowList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_User_user_getFollow;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"user" forKey:@"type"];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setObject:@"50" forKey:@"count"];
    
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
            _dataArray = (NSArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
//            _dataArray = dict[@"data"];
        }
        if (_dataArray.count == 0) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 48)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
            [self.view addSubview:imageView];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
