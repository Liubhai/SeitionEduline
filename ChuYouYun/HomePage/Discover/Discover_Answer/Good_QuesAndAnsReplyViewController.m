//
//  Good_QuesAndAnsReplyViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/16.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_QuesAndAnsReplyViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "Good_QuesAndAnsTableViewCell.h"
#import "Good_QuesAndAnsDetailViewController.h"
#import "DLViewController.h"

@interface Good_QuesAndAnsReplyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView  *tableView;
@property (strong ,nonatomic)UIImageView  *imageView;

@property (strong ,nonatomic)NSString            *ID;
@property (strong ,nonatomic)NSString            *questionType;
@property (strong ,nonatomic)NSMutableArray      *dataArray;
@property (assign ,nonatomic)NSInteger            number;

@end

@implementation Good_QuesAndAnsReplyViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -30, MainScreenWidth, MainScreenHeight - 64)];
        _imageView.image = Image(@"云课堂_空数据.png");
    }
    return _imageView;
}

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self netWorkWenGetList:1];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getQuestionCateDict:) name:@"NSNotificationQuestionCateDict" object:nil];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 44 * WideEachUnit) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 88 - 44 * WideEachUnit);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
    if (currentIOS >= 11) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    
    [_tableView addHeaderWithTarget:self action:@selector(tableViewHeader)];
    [_tableView addFooterWithTarget:self action:@selector(tableViewFooter)];
}


#pragma mark --- fresh

- (void)tableViewHeader {
    _number = 1;
    [self netWorkWenGetList:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)tableViewFooter {
    _number ++;
    [self netWorkWenGetList:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

#pragma mark --- UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 16;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = nil;
    cellStr = [NSString stringWithFormat:@"Reply-%ld",indexPath.row];
    Good_QuesAndAnsTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[Good_QuesAndAnsTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [cell dataWithDict:dict];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Good_QuesAndAnsDetailViewController *vc = [[Good_QuesAndAnsDetailViewController alloc] init];
    vc.dict = [_dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 通知
- (void)getQuestionCateDict:(NSNotification *)not {
    NSDictionary *dict = (NSDictionary *)not.object;
    _questionType = [dict stringValueForKey:@"zy_wenda_category_id"];
    [self netWorkWenGetList:1];
}

#pragma mark --- 网络请求
- (void)netWorkWenGetList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_WenDa_wenda_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"3" forKey:@"type"];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setObject:@"20" forKey:@"count"];
    if (_questionType) {
        [mutabDict setObject:_questionType forKey:@"wdtype"];
    }
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *)[dict arrayValueForKey:@"data"];
                } else {
                    [_dataArray addObjectsFromArray:(NSMutableArray *)[dict arrayValueForKey:@"data"]];
                }
            } else {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                } else {
                    [_dataArray addObjectsFromArray:(NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
                }
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        if (_dataArray.count == 0) {
            [_tableView addSubview:self.imageView];
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
