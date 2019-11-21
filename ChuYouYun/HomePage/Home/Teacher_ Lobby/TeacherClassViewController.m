//
//  TeacherClassViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/25.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "TeacherClassViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"

#import "ClassRevampCell.h"
#import "Good_ClassMainViewController.h"
#import "ZhiBoMainViewController.h"
#import "DLViewController.h"

@interface TeacherClassViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (strong ,nonatomic)UITableView  *tableView;
@property (strong ,nonatomic)UIImageView  *imageView;

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSArray  *dataArray;

//营销数据
@property (strong ,nonatomic)NSString *order_switch;

@end

@implementation TeacherClassViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
        _imageView.image = Image(@"云课堂_空数据 （小）");
        _imageView.center = CGPointMake(MainScreenWidth / 2 , 300);
        if (iPhone6) {
            _imageView.center = CGPointMake(MainScreenWidth / 2 , 200);
        } else if (iPhone6Plus) {
            _imageView.center = CGPointMake(MainScreenWidth / 2 , 280);
        } else if (iPhone5o5Co5S) {
            _imageView.center = CGPointMake(MainScreenWidth / 2 , 190);
        } else if (iPhoneX) {
            _imageView.center = CGPointMake(MainScreenWidth / 2 , 250);
        }
        [self.view addSubview:_imageView];
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
    [self netWorkConfigGetMarketStatus];
    [self netWorkTeacherGetVideoList];
}


- (void)interFace {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 100 * WideEachUnit;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}


#pragma mark --- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"cell1";
    //自定义cell类
    
    ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    NSString *type = dict[@"type"];
    [cell dataWithDict:dict withType:type];

    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    NSString *studyStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_order_count"]];
    if ([_order_switch integerValue] == 1) {
        studyStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_order_count_mark"]];
    }
    NSString *sectionStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_section_count"]];
    NSString *priceStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"t_price"]];

    if ([type integerValue] == 1) {
        cell.studyNum.text = [NSString stringWithFormat:@"%@人在学 · 共%@节",studyStr,sectionStr];
    } else if ([type integerValue] == 2) {
        cell.studyNum.text = [NSString stringWithFormat:@"%@人在学 · %@开课",studyStr,timeStr];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@",_dataArray[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    if (indexPath.section == 0) {//课程的时候
        if ([_dataArray[indexPath.row][@"type"] integerValue] == 1) {//课程
            Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
            vc.ID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"id"];
            vc.title = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
            vc.price = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"price"];
            vc.imageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
            vc.videoUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_address"];
            vc.orderSwitch = _order_switch;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([_dataArray[indexPath.row][@"type"] integerValue] == 2) {
            NSString *Cid = [NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"id"]];
            NSString *Price = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"price"];
            NSString *Title = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
            NSString *ImageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
            
            ZhiBoMainViewController *MainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
            MainVc.order_switch = _order_switch;
            [self.navigationController pushViewController:MainVc animated:YES];
        }
    }
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

#pragma mark --- 计算可以滚动的范围

- (void)getTheScrollFrame {
    
    //tableView 的总高度为 每个cell 的 高度 * 个数 + 底部试图的高度
    CGFloat allFrame = _dataArray.count * 100 * WideEachUnit + 40 - 20;
    if (_dataArray.count == 0) {
        allFrame = _dataArray.count * 100 * WideEachUnit;
    }
    NSLog(@"%lf",allFrame);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%lf",allFrame] forKey:@"frame"];
    
    //通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationTeacherClassScrollFrame" object:nil userInfo:dict];
}


#pragma mark ---网络请求
//获取讲师课程详情
- (void)netWorkTeacherGetVideoList {
    
    NSString *endUrlStr = YunKeTang_Teacher_teacher_getVideoList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"teacher_id"];
//    [mutabDict setObject:@"50" forKey:@"count"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        //        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
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
                _dataArray = [dict arrayValueForKey:@"data"];
            } else {
                _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        [self getTheScrollFrame];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//获取营销数据
- (void)netWorkConfigGetMarketStatus {
    
    NSString *endUrlStr = YunKeTang_config_getMarketStatus;
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
            _order_switch = [dict stringValueForKey:@"order_switch"];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

@end
