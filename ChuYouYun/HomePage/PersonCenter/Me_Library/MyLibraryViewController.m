//
//  MyLibraryViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/10.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "MyLibraryViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MyHttpRequest.h"
#import "MJRefresh.h"


#import "ZFDownloadManager.h"
#import "GLNetWorking.h"
#import "TKProgressHUD+Add.h"


#import "LibraryCell.h"


@interface MyLibraryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSString *downUrl;
@property (strong ,nonatomic)NSString *downName;
@property (strong ,nonatomic)NSString *downExtension;

@end

@implementation MyLibraryViewController

#pragma mark --- 懒加载
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
    [self interFace];
    [self addNav];
    [self addTableView];
    [self netWorkUserDocGetMyList];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"我的文库";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        
    }
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 38) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88 + 38);
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 90 * WideEachUnit;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }

}

#pragma mark --- 刷新

- (void)headerRerefreshings
{
    //    [self reachGO];
    //    [self requestData:1];
    [self netWorkUserDocGetMyList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    //    _numder++;
    //    [self requestData:_numder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}


#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.05;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LibraryCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict];
    
    cell.typeLabel.hidden = YES;
    cell.timeLabel.frame = CGRectMake(CGRectGetMaxX(cell.headImageView.frame) + 10, 50 * WideEachUnit, MainScreenWidth - 2 * SpaceBaside, 20 * WideEachUnit);
    
    [cell.downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.downButton.tag = indexPath.row;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark --- 事件监听
- (void)buttonCilck:(UIButton *)button {
    
    
}

- (void)downButtonClick:(UIButton *)button {
    _downUrl = _dataArray[button.tag][@"attach"];
    _downName = _dataArray[button.tag][@"title"];
    _downExtension = _dataArray[button.tag][@"attach_info"][@"extension"];
    [self isSureDown];
}


#pragma mark --- 提醒框
- (void)isSureDown {
    
    NSString *messageStr = [NSString stringWithFormat:@"确定要下载该文库？"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16 * WideEachUnit]
                  range:NSMakeRange(0, messageStr.length)];
    [alertController setValue:hogan forKey:@"attributedMessage"];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self downButtonClick];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark --- 下载

-(void)downButtonClick{
    if ([[GLNetWorking isConnectionAvailable] isEqualToString:@"4G"] || [[GLNetWorking isConnectionAvailable] isEqualToString:@"3G"] || [[GLNetWorking isConnectionAvailable] isEqualToString:@"2G"]) {
        UIAlertView *_downAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"如果您正在使用2G/3G/4G,如果继续运营商可能会收取流量费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_downAlertView show];
        });
    } else {
        [self downLoadVideo];
    }
}

-(void)downLoadVideo{
    
    NSString *imageStr = @"PPT@3x";
    UIImage *image = nil;
    if ([_downExtension isEqualToString:@"ppt"] || [_downExtension isEqualToString:@"pptx"]) {
        imageStr = @"PPT@3x";
    } else if ([_downExtension isEqualToString:@"excel"]) {
        imageStr = @"excel";
    } else if ([_downExtension isEqualToString:@"pdf"]) {
        imageStr = @"PDF@3x";
    } else if ([_downExtension isEqualToString:@"word"]) {
        imageStr = @"WORD@3x";
    } else if ([_downExtension isEqualToString:@"txt"]) {
        imageStr = @"txt@3x";
    } else if ([_downExtension isEqualToString:@"docx"]) {
        imageStr = @"WORD@3x";
    } else if ([_downExtension isEqualToString:@"zip"]) {
        imageStr = @"ZIP@3x";
    } else if ([_downExtension isEqualToString:@"jpg"]) {
        imageStr = @"ZIP@3x";
    } else {
        imageStr = @"PPT@3x";
    }
    image = Image(imageStr);
    
    
    NSString *libriyName = [NSString stringWithFormat:@"%@.%@",_downName,_downExtension];
    
    if (!_downUrl.length) {
        [TKProgressHUD showError:@"下载地址为空" toView:self.view];
        return ;
    }
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:_downUrl filename:libriyName fileimage:image];
    //设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 1;

    //保存到本地
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:_downUrl forKey:libriyName];
    [defaults synchronize];
    
}
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self downLoadVideo];
    }else
        return;
}


#pragma mark --- 网络请求
- (void)netWorkUserDocGetMyList {
    
    NSString *endUrlStr = YunKeTang_User_doc_getMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"0" forKey:@"doc_category_id"];
    [mutabDict setValue:@"1" forKey:@"page"];
    [mutabDict setValue:@"100" forKey:@"count"];
    
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
        _dataArray = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if (_dataArray.count == 0) {
            //添加空白处理
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//文库兑换
- (void)netWorkDocExchange:(NSString *)docID {
    
    NSString *endUrlStr = YunKeTang_Doc_doc_exchange;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:docID forKey:@"doc_id"];
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
            [TKProgressHUD showError:@"兑换成功" toView:self.view];
            [self netWorkUserDocGetMyList];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}




@end
