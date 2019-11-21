//
//  AppDelegate.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "AppDelegate.h"
#import "rootViewController.h"
#import "MyViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "DLViewController.h"
#import "Reachability.h"
#import "HcdGuideView.h"
#import "BBLaunchAdMonitor.h"
#import "AdViewController.h"

#import "BigWindCar.h"
#import "SYG.h"


//网络下载
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"


//人脸识别
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "NetAccessModel.h"
#import "SVProgressHUD.h"
#import "FaceParameterConfig.h"

/// 新增
#import "LanchAnimationVC.h"
/// 机构app首页
#import "InstitutionsChooseVC.h"


#define APP_ID @""
#define SWNOTEmptyArr(X) (NOTNULL(X)&&[X isKindOfClass:[NSArray class]]&&[X count])
#define SWNOTEmptyDictionary(X) (NOTNULL(X)&&[X isKindOfClass:[NSDictionary class]]&&[[X allKeys]count])
#define SWNOTEmptyStr(X) (NOTNULL(X)&&[X isKindOfClass:[NSString class]]&&((NSString *)X).length)
#define SWToStr(X) [SingleCenterObj replaceNilStr:X nilStr:@""]
#define NOTNULL(x) ((![x isKindOfClass:[NSNull class]])&&x)
//avatar
#define SWUID [UserModel uid]
#define SWUNAME [UserModel uname]
#define SWAVATAR [UserModel avatar]
#define SWINTRO [UserModel intro]
#define IsAdminer [UserModel isAdmin]

//聊天相关的通知
#define Chat_SocketStateNotification @"socketefstatenoti"//socket的连接状态
#define Chat_UpdateNotisCountNotification @"updateMessageCountfdsafdsk231"//更新消息个数
#define Chat_ChatRoomListGetNotification @"fjnchat,,,fs"//聊天室列表
#define Chat_UpdateChatRoomTableNotification @"fixReloadTbaleViewfds"//刷新聊天室列表，参数是对应的room_id
#define Chat_UpdateChatRoomMessageNotifaction @"UpdateChatRoomMessageNotifaction" //新消息，刷新聊天室列表的显示，需要重新排序不同于上面的一个通知
#define Chat_RoomHeadChangeNotification @"jdfsaChat_roomenHad"//聊天室头像改变通知,socket发出来的
#define Chat_RoomNameChangeNotification @"roomnamebbdksf"//聊天室名字改变
#define Chat_RoomAddUserNotification @"Chat_RoomAddUserNotification"//添加了新的成员
#define Chat_QuitRoomNotification @"quit_group_roomfds77afds"//退出聊天室
#define Chat_InputingStateNotifaciton @"shuruzhuangtaigabina"//输入状态改变
#define Chat_GetRoomInfoNotification @"huoqufangjianxinxi"//获取房间信息
#define Chat_CreateGroupRoomNotification @"creatGroupRoofdsa121m"//创建群组聊天
#define Chat_SendMessageBackNotification @"fasongliaothuidiao"//发送聊天信息回调
#define Chat_SendMessageDealBackNotification @"fsdachatdeatk1"//发送的聊天消息回调本地处理完毕了
#define Chat_DeleteChatRoomChatInfoNotification @"chcakjfhdekege"//清空聊天信息
#define Chat_GetNewMessagesNotification @"jkjgetnesfff"//获取到了新的聊天信息,品种有点多，供多种玩味
#define Chat_GetMessageListNotfication @"getmessagelistss"//获取聊天的聊天记录列表
#define Chat_GetMessageLatestReloadUINotificaiton @"Chat_GetMessageLatestReloadUINotificaiton"//获得了聊天记录，用来刷
#define Chat_ReloadKeepKeyName @"goMyTableViewReloadData" //保持刷新数据后，界面保持在当前位置的一个本地化key值
#define Chat_UploadImageProgressNotification @"Chat_UploadImageProgressNotification"//上传图片的进度通知
#define Chat_RefreshChatUnreadCountNotification @"Chat_RefreshChatUnreadCountNotification"//刷新未读聊天个数
#define Chat_IsLoginRefreshRoomListNotification @"Chat_IsLoginRefreshRoomListNotification"//登录了之后刷新聊天室列表
//聊天服务器配置
#define CHAT_URL [NSString stringWithFormat:@"ws://%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"socketUrl"]]
@interface AppDelegate ()<UIActionSheetDelegate>
{

@private Reachability *hostReach;
    // 信号栏高度
    CGFloat _statusBarHeight;
    // 启动时候就有个人热点l接入
    BOOL launchStatus;

}
@property (nonatomic, copy) NSString *_iTunesLink;

@property (strong ,nonatomic)NSDictionary   *appVersionDict;
@property (strong ,nonatomic)NSString       *currentVersion;

@end

@implementation AppDelegate




- (void)startServer
{
    // Start the server (and check for problems)
    
    NSError *error;
    if([httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}



+(AppDelegate *)delegate
{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

- (rootViewController *)rootVC
{
    return (rootViewController *)window.rootViewController;
}


#pragma mark --- 获取版本号
//获取app版本
- (void)netWorkConfigGetAppVersion {
    
    NSString *endUrlStr = YunKeTang_config_getAppVersion;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
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
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _appVersionDict = [dict dictionaryValueForKey:@"data"];
            } else {
               _appVersionDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            if ([[[_appVersionDict dictionaryValueForKey:@"ios"] stringValueForKey:@"version"] integerValue] != [_currentVersion integerValue] ) {//需要更新
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新版本，是否前往更新？" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"更新", nil];
                alert.tag = 2;
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



#pragma mark --- 获取当前版本
- (void)getCurrentVersion {
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey]; //获取项目版本号
    NSLog(@"version .. %@",version);
    _currentVersion = version;
}

#pragma mark --- 获取当前app的名字
- (void)getCurrentAPPName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"]; //获取项目名字
    NSLog(@"version .. %@",appName);
    
    //获取当前app的ID
    NSString *appID = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    //存在当地
    [[NSUserDefaults standardUserDefaults]setObject:appID forKey:@"appID"];
    [[NSUserDefaults standardUserDefaults]setObject:appName forKey:@"appName"];//这样会防止其他的app覆盖情况
    NSLog(@"--%@",AppName);
    NSLog(@"%@",APPID);
}


#pragma mark ---- alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:[[_appVersionDict dictionaryValueForKey:@"ios"] stringValueForKey:@"down_url"]];
            [[UIApplication sharedApplication] openURL:url];
        }
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self appLaunchStatusFrameJudge];
    //获取加密的KEY
    [self netInitApp];
    //延长启动图的展示时间方法
//     [NSThread sleepForTimeInterval:2.0];
    [self getHomeAllData];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    [self netWorkConfigGetAppVersion];
    [self getCurrentVersion];
    [self getCurrentAPPName];
    
    [UMSocialData setAppKey:@"574e8829e0f55a12f8001790"];

    //QQ
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:@"http://www.umeng.com/social"];
    
    //微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppId secret:SinaAppSecret RedirectURL:@"http://sns.eduline.com/sina2/callback"];
//    https://api.weibo.com/oauth2/default.html
//    http://sns.eduline.com/sina2/callback
    
    //微信
     [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:@"https://api.weixin.qq.com/cgi-bin/menu/create?access_token="];
//    $url="https://api.weixin.qq.com/cgi-bin/menu/create?access_token=".$access_token;将$url作为<pre name="code" class="html">createMenu($url,$data)的参数就ok.
    

    //注册APPID
    [WXApi registerApp:WXAppId withDescription:@"Eduline"];
    //隐藏未安装客户端的平台
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    //网络下载
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    httpServer = [[HTTPServer alloc] init];
    
    [httpServer setType:@"_http._tcp."];
    
    [httpServer setPort:12345];
    
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:webPath])
    {
        [fileManager createDirectoryAtPath:webPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [httpServer setDocumentRoot:webPath];
    
    [self startServer];
    
    self._allowRotation = NO;
    LanchAnimationVC* lanchVC = [[LanchAnimationVC alloc]init];
    
    self.window.rootViewController = lanchVC;
    [self.window makeKeyAndVisible];
    lanchVC.animationFinished = ^(BOOL successed){
        if ([Show_Config isEqualToString:@"1"]) {
            InstitutionsChooseVC* institutionsVC = [[InstitutionsChooseVC alloc]init];
            self.window.rootViewController = institutionsVC;
            [self.window makeKeyAndVisible];
            institutionsVC.institutionChooseFinished = ^(BOOL succesed) {
                self.tabbar = [rootViewController sharedBaseTabBarViewController];
                self.window.rootViewController = self.tabbar;
                [self.window makeKeyAndVisible];
            };
        } else {
            self.tabbar = [rootViewController sharedBaseTabBarViewController];
            self.window.rootViewController = self.tabbar;
            [self.window makeKeyAndVisible];
        }
        
        NSMutableArray *images = [NSMutableArray new];
        
        [images addObject:[UIImage imageNamed:@"new_ lead1.png"]];
        [images addObject:[UIImage imageNamed:@"new_ lead2.png"]];
        [images addObject:[UIImage imageNamed:@"new_ lead3.png"]];
        
        HcdGuideView *guideView = [HcdGuideView sharedInstance];
        guideView.window = self.window;
        [guideView showGuideViewWithImages:images
                            andButtonTitle:@""
                       andButtonTitleColor:[UIColor clearColor]
                          andButtonBGColor:[UIColor clearColor]
                      andButtonBorderColor:[UIColor clearColor]];
    };

    //人脸识别
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
    [SVProgressHUD appearance].defaultStyle = SVProgressHUDStyleDark;
    [[NetAccessModel sharedInstance] getAccessTokenWithAK:FACE_API_KEY SK:FACE_SECRET_KEY];
    // 注册状态栏位置消息监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameDidChange:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameWillChange:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    return NO;
}


#pragma mark --- 获取广告
- (void)NetWorkGetAd {
    
}




- (void)showAdDetail:(NSNotification *)noti
{
    NSLog(@"detail parameters:%@", noti.object);
}

- (void)showAdImageUrl:(NSNotification *)noti {
     NSLog(@"detail url:%@", noti.object);
    NSDictionary *dict = noti.object;
    AdViewController *adVc = [[AdViewController alloc] init];
//    adVc.adStr = @http://www.audi.cn/cn/web/zh.html?csref=sea_161228_145607_baidu_p_bz_1612_audi&smtid=487832398z1uo8zyln2z1pdz0zMg%3D%3D"";
    
    adVc.adStr = [NSString stringWithFormat:@"%@",dict[@"url"]];
    [self.window.rootViewController presentViewController:adVc animated:YES completion:nil];
    
}


//重写AppDelegate  handleOpenURL openURL
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

  //  return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//}

//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach

{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status == kReachableViaWWAN){
        printf("\n3g/2G\n");
    }
    else if(status == kReachableViaWiFi){
        printf("\nwifi\n");
    }else{
        printf("\n无网络\n");
    }
    
}


//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
//    return YES;
//    return [UMSocialSnsService handleOpenURL:url];
//}

//使用第三方登录需要重写下面两个方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
        if ([url.host isEqualToString:@"safepay"]) {
            return YES;
        }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            return YES;
        }
    }
    return result;
 }


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return  [UMSocialSnsService handleOpenURL:url];
}



- (void)applicationWillResignActive:(UIApplication *)application
{

//    [self NetWorkGetAd];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [httpServer stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self startServer];
    //从其他的地方回来进入前台
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPWillEnterForeground" object:@"1"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (__allowRotation == YES) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark --- 请求加密的KEY

- (void)netInitApp {
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [dict setObject:ggg forKey:@"hextime"];
    [dict setObject:tokenStr forKey:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",EncryptUrl,YunKeTang_config_initApp];
    
    [manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject stringValueForKey:@"code"] integerValue] == 1) {
            NSMutableDictionary *dict = responseObject[@"data"];
            NSDictionary *mcryptKeyDict = [dict dictionaryValueForKey:@"mcryptKey"];
            [[NSUserDefaults standardUserDefaults]setObject:[mcryptKeyDict stringValueForKey:@"mcrypt_key"] forKey:@"App_Key"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

// MARK: - 首页新接口 一并返回所有数据
- (void)getHomeAllData {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"edulineHomeData"] != nil) {
        return;
    }
    NSString *endUrlStr = YunKeTang_App_Home_allData;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"edulineHomeData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEdulineHomeData" object:nil];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

// 信号栏位置已经改变
- (void)statusBarFrameDidChange:(NSNotification*)notification
{
    if (_statusBarHeight == 40) {
//        [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight = [UIScreen mainScreen].bounds.size.height;
        [rootViewController sharedBaseTabBarViewController].imageView.bottom = [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight - 20;
        
    } else if (_statusBarHeight == 20) {
//        [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight = [UIScreen mainScreen].bounds.size.height;
        [rootViewController sharedBaseTabBarViewController].imageView.bottom = [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight;
    }
//    [rootViewController destoryShared];
//    self.tabbar = [rootViewController sharedBaseTabBarViewController];
//    self.window.rootViewController = self.tabbar;
    
//    [self.window makeKeyAndVisible];
}
// 信号栏高度即将改变
- (void)statusBarFrameWillChange:(NSNotification*)notification
{
    CGRect frame = [[notification.userInfo objectForKey:@"UIApplicationStatusBarFrameUserInfoKey"] CGRectValue];
    _statusBarHeight = frame.size.height;
    if (_statusBarHeight == 40) {
//        [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight = [UIScreen mainScreen].bounds.size.height;
        [rootViewController sharedBaseTabBarViewController].imageView.bottom = [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight - 20;
    } else if (_statusBarHeight == 20) {
//        [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight = [UIScreen mainScreen].bounds.size.height;
        [rootViewController sharedBaseTabBarViewController].imageView.bottom = [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight;
    }
}

- (void)appLaunchStatusFrameJudge {
    _statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (_statusBarHeight == 40) {
        launchStatus = YES;
        [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight = [UIScreen mainScreen].bounds.size.height;
        [rootViewController sharedBaseTabBarViewController].imageView.bottom = [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight - 20;

    } else if (_statusBarHeight == 20) {
        [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight = [UIScreen mainScreen].bounds.size.height;
        [rootViewController sharedBaseTabBarViewController].imageView.bottom = [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight;
    }
}

@end
