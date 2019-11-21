//
//  TKZhiBoViewController.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/8/22.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "TKZhiBoViewController.h"
#import "SYG.h"
#import "MyHttpRequest.h"
#import "TKProgressHUD+Add.h"
#import "ZhiBoClassCell.h"
#import "BigWindCar.h"
#import "AppDelegate.h"
#import "rootViewController.h"

#import "DLViewController.h"
#import "ClassAndLivePayViewController.h"

//拓课云
#import <AudioToolbox/AudioToolbox.h>
#import "TKEduClassRoom.h"

@interface TKZhiBoViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    BOOL islivePlay;
    NSInteger _indexPathRow;
}
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSDictionary *liveInfo;
@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *HDtitle;
@property (strong ,nonatomic)NSString *HDnickName;
@property (strong ,nonatomic)NSString *HDwatchPassword;
@property (strong ,nonatomic)NSString *HDroomNumber;

@property (assign ,nonatomic)BOOL isBuyZhiBo;
//@property (strong ,nonatomic) VodDownLoader *voddownloader;
@property (strong ,nonatomic)NSDictionary *playLiveBackDic;
//@property (strong ,nonatomic)GenSeePlayBackViewController *genseePlayBackVc;


@property (assign, nonatomic) NSInteger                 liveType;
@property (strong ,nonatomic) NSDictionary *CCDict;

//CC
//@property (strong ,nonatomic)PlayParameter  *playParameter;
//@property (strong ,nonatomic)RequestData    *requestData;

@property (strong ,nonatomic)NSDictionary *VHDict;

//小班课
//@property (strong ,nonatomic)CC_LoadingView  *loadingView;
//@property (assign, nonatomic) CCRole role;//角色
//@property (assign, nonatomic) BOOL isLandSpace;//是否横屏
//@property (strong ,nonatomic)NSDictionary  *classRoomDict;//小班课的字典
@property (strong ,nonatomic)UIAlertView   *alter;

@property (strong ,nonatomic)NSDictionary  *dataSource;

//拓课云
@property (strong ,nonatomic)NSDictionary   *TKDict;
@property (strong, nonatomic) NSString      *defaultServer;//默认服务

@end

@implementation TKZhiBoViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth,_tabelHeight)];
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
    [self netWorkLiveGetInfo];
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
    [self addTableView];
    [self netWorkLiveGetInfo];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _isBuyZhiBo = NO;
}


- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark ---- UITableVieDataSoruce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"LiveDetailOneCell";
    //自定义cell类
    ZhiBoClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[ZhiBoClassCell alloc] initWithReuseIdentifier:CellID];
    }
    [cell.numberButton setTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1] forState:UIControlStateNormal];
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict WithLiveInfo:_liveInfo];
    //吧滚动的范围传到主页去
    CGFloat tableHight = _dataArray.count * _tableView.rowHeight;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    _indexPathRow = indexPath.row;
    if ([[[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"note"] isEqualToString:@"已结束"]) {
        [TKProgressHUD showError:@"该课时已结束" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    // 这里应该判断是否已经登录
    if (UserOathToken == nil) {
        //没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }else{
        if (_isBuyZhiBo == YES) {
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            _HDnickName = [defaults objectForKey:@"uname"];
            //参数
            _HDtitle = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"subject"];
            NSString *ID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"live_id"];
            NSString *secitonID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"section_id"];
            [self netWorkLiveGetCatalogWithSection:secitonID WithID:ID];
        } else {//提示课时购买
            
            NSDictionary *cellDict = [_dataArray objectAtIndex:indexPath.row];
            if ([[_liveInfo stringValueForKey:@"price"] floatValue] == 0) {//免费的（但是还是需要添加订单）
                if ([[cellDict stringValueForKey:@"is_buy"] integerValue] == 1) {//已经购买
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    _HDnickName = [defaults objectForKey:@"uname"];
                    //参数
                    _HDtitle = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"subject"];
                    NSString *ID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"live_id"];
                    NSString *secitonID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"section_id"];
                    [self netWorkLiveGetCatalogWithSection:secitonID WithID:ID];
                } else {//没有购买
                    [TKProgressHUD showError:@"请先购买本直播才能观看" toView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
            } else {
                if ([[cellDict stringValueForKey:@"is_buy"] integerValue] == 1) {//已经购买
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    _HDnickName = [defaults objectForKey:@"uname"];
                    //参数
                    _HDtitle = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"subject"];
                    NSString *ID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"live_id"];
                    NSString *secitonID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"section_id"];
                    [self netWorkLiveGetCatalogWithSection:secitonID WithID:ID];
                } else {//没有购买
                    if ([[cellDict stringValueForKey:@"course_hour_price"] floatValue] == 0) {
                        [TKProgressHUD showError:@"请先购买本直播才能观看" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    } else {
                        [self gotoBuyLive];
                    }
                }
            }
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

#pragma MARK --- 事件处理
- (void)gotoBuyLive {
    ClassAndLivePayViewController *payVc = [[ClassAndLivePayViewController alloc] init];
    payVc.dict = _liveInfo;
    payVc.cellDict = [_dataArray objectAtIndex:_indexPathRow];
    payVc.cid = _ID;
    payVc.typeStr = @"2";
    [self.navigationController pushViewController:payVc animated:YES];
}

#pragma mark --- 网络请求

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
                dict = [dict dictionaryValueForKey:@"data"];
            } else {
                dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            if ([dict isEqual:[NSArray array]]) {
                return ;
            }
            _liveInfo = dict;
            _dataArray = [dict arrayValueForKey:@"sections"];
            if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {
                _isBuyZhiBo = YES;
            } else {
                _isBuyZhiBo = NO;
            }
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
            [_tableView reloadData];
        } else {
            return ;
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//直播详情
- (void)netWorkLiveGetCatalogWithSection:(NSString *)secitonID WithID:(NSString *)ID {
    
    NSString *endUrlStr = YunKeTang_Live_live_getCatalog;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:ID forKey:@"live_id"];
    [mutabDict setValue:secitonID forKey:@"section_id"];
    
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([[dict stringValueForKey:@"type"] integerValue] == 1) {//gensee
                [TKProgressHUD showError:@"不支持直播类型" toView:[UIApplication sharedApplication].keyWindow];
                return ;
                BOOL isPlayBack = NO;
                for (NSString *keyStr in [dict allKeys]) {
                    if ([keyStr isEqualToString:@"livePlayback"]) {//回放
                        isPlayBack = YES;
                    }
                }
                if (isPlayBack == NO) {
                    //                    NSDictionary *bodyDict = [dict dictionaryValueForKey:@"body"];
                    //                    NSString *title = _HDtitle;
                    //                    NSString *name = [bodyDict stringValueForKey:@"account"];
                    //                    NSString *pwd = [bodyDict stringValueForKey:@"pwd"];
                    //                    NSString *number = [bodyDict stringValueForKey:@"number"];
                    //                    GenSeeLiveViewController *vc = [[GenSeeLiveViewController alloc] init];
                    //                    [vc initwithTitle:title nickName:name watchPassword:pwd roomNumber:number];
                    //                    vc.account = name;
                    //                    vc.domain = [bodyDict stringValueForKey:@"domain"];
                    //                    [self.navigationController pushViewController:vc animated:YES];
                } else if (isPlayBack == YES) {
                    NSDictionary *livePlaybackDict = dict[@"body"];
                    
                    NSString *string = dict[@"live_url"];
                    NSRange startRange = [string rangeOfString:@"https://"];
                    NSRange endRange = [string rangeOfString:@"/training"];
                    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                    NSString *result = [string substringWithRange:range];
                    NSLog(@"%@",result);
                    
                    //                    [_voddownloader addItem:result number:livePlaybackDict[@"number"] loginName:_HDnickName vodPassword:livePlaybackDict[@"token"] loginPassword:livePlaybackDict[@"number"] downFlag:0 serType:@"training" oldVersion:NO kToken:nil customUserID:0];
                }
            } else if ([[dict stringValueForKey:@"type"] integerValue] == 4) {//CC
                //                if ([dict[@"body"][@"is_live"] integerValue] == 1) {//直播
                //                    [self useCCLive:dict[@"body"]];
                //                } else if ([dict[@"body"][@"is_live"] integerValue] == 0){//回放
                //                    _CCDict = dict[@"body"];
                //                    [self CCPlayBack];
                //                }
            } else if ([[dict stringValueForKey:@"type"] integerValue] == 8) {//拓课云
                _TKDict = [dict dictionaryValueForKey:@"body"];
                
                if ([[_TKDict stringValueForKey:@"is_live"] integerValue] == 1) {
                    [self TKJoin];
                } else {
                    [self TKPlayBack];
                }
            } else {
                [TKProgressHUD showError:@"不支持直播类型" toView: [UIApplication sharedApplication].keyWindow];
                return ;
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            return ;
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

#pragma mark --- GenSee

#pragma mark --- CC

- (void)useCCLive:(NSDictionary *)dict {//CC 直播
    NSLog(@"----%@",dict);
    _CCDict = dict;
    NSString *strUserId = [dict stringValueForKey:@"userid"];
    NSString *strRoomId = [dict stringValueForKey:@"roomid"];
    NSString *strViewName = @"用户";
    NSString *strToken = [dict stringValueForKey:@"join_pwd"];
    
    BOOL haveEmpty = false;
    
    
    if (strUserId == nil || strUserId.length == 0) {
        haveEmpty = true;
    }
    if (strRoomId == nil || strRoomId.length == 0) {
        haveEmpty = true;
    }
    if (strViewName == nil || strViewName.length == 0) {
        haveEmpty = true;
    }
    if (strToken == nil || strToken.length == 0) {
        haveEmpty = true;
    }
    
    if (haveEmpty == false) {
    }
    
    if (haveEmpty == false) {
        
        UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
        returnButtonItem.title = @"返回";
        self.navigationItem.backBarButtonItem = returnButtonItem;
        
        if (self.liveType == 0) {
            //            RequestData *requestData = [[RequestData alloc] initOnlyLoginWithUserId:strUserId RoomId:strRoomId ViewerName:strViewName ViewerToken:strToken security:YES];
            //            requestData.delegate = self;
            
        } else if(self.liveType == 1) {
            //            RequestDataPlayBack *requestDataPlayBack = [[RequestDataPlayBack alloc] initOnlyLoginWithUserId:strUserId RoomId:strRoomId Liveid:strLevelId Viewername:strViewName Viewertoken:strToken security:YES];
            //            requestDataPlayBack.delegate = self;
        }
        
        //        PlayParameter *parameter = [[PlayParameter alloc] init];
        //        parameter.userId = strUserId;
        //        parameter.roomId = strRoomId;
        //        parameter.viewerName = strViewName;
        //        parameter.token = strToken;
        //        parameter.security = YES;
        //        parameter.viewercustomua = @"viewercustomua";
        //        _requestData = [[RequestData alloc] initLoginWithParameter:parameter];
        //        _requestData.delegate = self;
        //
    }
}

#pragma mark --- CC 直播代理方法

#pragma mark - CCPushDelegate
//@optional
/**
 *    @brief    请求成功
 */
//-(void)loginSucceedPlay {
//    NSLog(@"%@",_CCDict);
//
//    NSString *strUserId = [_CCDict stringValueForKey:@"userid"];
//    NSString *strRoomId = [_CCDict stringValueForKey:@"roomid"];
//    NSString *strViewName = _HDnickName;
//    NSString *strToken = [_CCDict stringValueForKey:@"join_pwd"];
//
//    PlayForPCVC *playVc = [[PlayForPCVC alloc] initWithRoomId:strRoomId WithUserId:strUserId WithViewerName:strViewName WithToken:strToken];
//    [self presentViewController:playVc animated:YES completion:nil];
//}
//
//-(void)loginFailed:(NSError *)error reason:(NSString *)reason {
//    NSString *message = nil;
//    if (reason == nil) {
//        message = [error localizedDescription];
//    } else {
//        message = reason;
//    }
//
//    [MBProgressHUD showError:message toView:self.view];
//}
//
//#pragma mark -- CC 回放
//- (void)CCPlayBack {
//    NSLog(@"%@",_CCDict);
//    PlayParameter *parameter = [[PlayParameter alloc] init];
//    parameter.userId = [_CCDict stringValueForKey:@"userid"];
//    parameter.roomId = [_CCDict stringValueForKey:@"roomid"];
//    parameter.liveid = [_CCDict stringValueForKey:@"livePlayback"];
//
//
//    parameter.viewerName = _HDnickName;
//    parameter.token = [_CCDict stringValueForKey:@"join_pwd"];
//    parameter.security = YES;
//
//    NSLog(@"%@",parameter.viewerName);
//    NSLog(@"%@",parameter.userId);
//    NSLog(@"%@",parameter.roomId);
//    NSLog(@"%@",parameter.liveid);
//    NSLog(@"%@",parameter.token);
//
//    RequestDataPlayBack *requestDataPlayBack = [[RequestDataPlayBack alloc] initLoginWithParameter:parameter];
//    requestDataPlayBack.delegate = self;
//}
//
//#pragma mark -- CC回放的代理方法
////@optional
///**
// *    @brief    请求成功
// */
//-(void)loginSucceedPlayBack {
//
//    NSString *userID = [_CCDict stringValueForKey:@"userid"];
//    NSString *roomID = [_CCDict stringValueForKey:@"roomid"];
//    NSString *liveID = [_CCDict stringValueForKey:@"livePlayback"];
//    NSString *name = _HDnickName;
//    NSString *token = [_CCDict stringValueForKey:@"join_pwd"];
//
//    PlayBackVC *playBackVC = [[PlayBackVC alloc] initWithRoomId:roomID WithUserId:userID WithViewerName:name WithToken:token withLiveID:liveID];
//    [self presentViewController:playBackVC animated:YES completion:nil];
//}
//


#pragma mark --- 微吼直播

- (void)VHPlayer {
    
}

#pragma mark --- CC  小班课

//移除警告框
- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


//拓课云
- (void)TKJoin {
    
    
    if ([[_TKDict stringValueForKey:@"role"] integerValue] == 2) {//学生
        // 学生被T 3分钟内不能登录
        id idTime = [[NSUserDefaults standardUserDefaults] objectForKey:TKKickTime];
        if (idTime && [idTime isKindOfClass:NSDate.class]) {
            NSDate *time = (NSDate *)idTime;
            NSDate *curTime = [NSDate date];
            NSTimeInterval delta = [curTime timeIntervalSinceDate:time]; // 计算出相差多少秒
            
            if (delta < 60 * 3) {
                
                NSString *content =  MTLocalized(@"Prompt.kick");
                TKAlertView *alert = [[TKAlertView alloc] initWithTitle:MTLocalized(@"Prompt.prompt") contentText:content confirmTitle:MTLocalized(@"Prompt.Know")];
                [alert show];
                return;
            }else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:TKKickTime];
            }
        }
    }
    
    /**登陆教室*/
    if ([TKUtil isDomain:sHost] == YES) {
        NSArray *array = [sHost componentsSeparatedByString:@"."];
        self.defaultServer = [NSString stringWithFormat:@"%@", array[0]];
    } else {
        self.defaultServer = @"global";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[_TKDict stringValueForKey:@"roomid"] forKey:@"serial"];
    [parameters setObject:sHost forKey:@"host"];
    [parameters setObject:sPort forKey:@"port"];
    [parameters setObject:[_TKDict stringValueForKey:@"account"] forKey:@"nickname"];
    [parameters setObject:[_TKDict stringValueForKey:@"role"] forKey:@"userrole"];
    [parameters setObject:self.defaultServer forKey:@"server"];
    [parameters setObject:@"3" forKey:@"clientType"];
    
    if ([[_TKDict stringValueForKey:@"role"] integerValue] != 2) {
        [parameters setValue:[_TKDict stringValueForKey:@"pwd"] forKey:@"password"];
    }
    [parameters setValue:[_TKDict stringValueForKey:@"pwd"] forKey:@"password"];
    //    NSString *tRoomIDString = [self.roomidView.inputView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //
    //    NSMutableDictionary *parameters = @{
    //                                        @"serial"    :tRoomIDString,
    //                                        @"host"      :sHost,
    //                                        @"port"      :sPort,
    //                                        @"nickname"  :self.nicknameView.inputView.text,
    //                                        @"userrole"  :@(self.role),
    //                                        @"server"    :self.defaultServer,
    //                                        @"clientType":@(3)
    //
    //                                        }.mutableCopy;
    //
    //#if DEBUG
    //
    //#ifdef SERVER_ClassID
    //    [parameters setValue:SERVER_ClassID forKey:@"serial"];
    //#endif
    //
    //#ifdef Class_NickName
    //    [parameters setValue:Class_NickName forKey:@"nickname"];
    //#endif
    //
    //#ifdef SERVER_ClassPwd
    //    if (self.role != 2) {
    //
    //        [parameters setValue:SERVER_ClassPwd forKey:@"password"];
    //    }
    //#endif
    //
    //#endif
    //
    //
    //    [[TKEduClassRoom shareInstance] joinRoomWithParamDic:parameters ViewController:self Delegate:self isFromWeb:NO];
    
    [[TKEduClassRoom shareInstance] joinRoomWithParamDic:parameters ViewController:self Delegate:self isFromWeb:NO];
    
}

- (void)TKPlayBack {
    
    /**登陆教室*/
    if ([TKUtil isDomain:sHost] == YES) {
        NSArray *array = [sHost componentsSeparatedByString:@"."];
        self.defaultServer = [NSString stringWithFormat:@"%@", array[0]];
    } else {
        self.defaultServer = @"global";
    }
    
    NSString *path = [_TKDict stringValueForKey:@"livePlayback"];
    NSArray *pathArray = [path componentsSeparatedByString:@"//"];
    NSString *twoStr = [pathArray objectAtIndex:1];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[_TKDict stringValueForKey:@"roomid"] forKey:@"serial"];
    [parameters setObject:sHost forKey:@"host"];
    [parameters setObject:sPort forKey:@"port"];
    [parameters setObject:twoStr forKey:@"path"];
    //    [parameters setObject:@"https://global.talk-cloud.net/5686c2dc-1002-4e28-a869-25e79cb3446a-583890717/" forKey:@"path"];
    //    [parameters setObject:[_TKDict stringValueForKey:@"account"] forKey:@"nickname"];
    [parameters setObject:@"1" forKey:@"playback"];
    [parameters setObject:@"3" forKey:@"clientType"];
    [parameters setObject:@"3" forKey:@"type"];
    
    
    //    paramDic = @{
    //                 @"clientType" : @3,
    //                 @"host" : @"global.talk-cloud.net",
    //                 @"path" : @"global.talk-cloud.net:8081/2636e2d0-0d61-4ccc-8d91-79e737fff188-375603898/",
    //                 @"playback": @1,
    //                 @"port" : @"443",
    //                 @"serial" : @"375603898",
    //                 @"type":@3,
    //                 };
    
    if ([[_TKDict stringValueForKey:@"role"] integerValue] != 2) {
        [parameters setValue:[_TKDict stringValueForKey:@"pwd"] forKey:@"password"];
    }
    [parameters setValue:[_TKDict stringValueForKey:@"pwd"] forKey:@"password"];
    
    //    [[TKEduClassRoom shareInstance] joinRoomWithParamDic:parameters ViewController:self Delegate:self isFromWeb:NO];
    [[TKEduClassRoom shareInstance] joinPlaybackRoomWithParamDic:parameters ViewController:self Delegate:self isFromWeb:NO];
    
}


@end
