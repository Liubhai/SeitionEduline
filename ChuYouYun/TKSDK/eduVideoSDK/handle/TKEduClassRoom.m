//
//  TKEduClassRoom.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduClassRoom.h"
#import "TKNavigationController.h"
#import "TKOneViewController.h"
#import "TKManyViewController.h"
#import "TKHUD.h"
#import "TKLoginViewController.h"

typedef NS_ENUM(NSInteger, EClassStatus) {
    EClassStatus_IDLE = 0, // 闲置的
    EClassStatus_CHECKING, // 获取
    EClassStatus_CONNECTING,// 连接
    EClassStatus_Finished,// 完成
};

@interface TKEduClassRoom ()<TKEduSessionClassRoomDelegate>

@property (atomic) EClassStatus classStatus;
@property (nonatomic, weak )  UIViewController *iController;
@property (nonatomic, strong) TKOneViewController * ctOneController;
@property (nonatomic, strong) TKManyViewController * ctMoreController;
@property (nonatomic, strong) TKNavigationController* iEduNavigationController;

@property (nonatomic, weak)   id<TKEduRoomDelegate> iRoomDelegate;
@property (nonatomic, strong) NSDictionary * iParam;
@property (nonatomic, assign) BOOL isFromWeb;
@property (nonatomic, assign) BOOL enterClassRoomAgain;
@property (nonatomic, copy) NSString *url;//记录进入课堂或回放的链接地址
@property (nonatomic, strong) TKAlertView *errorAlert;
@property (nonatomic, strong) NSString *defaultServer;//默认服务
@property (nonatomic, assign) BOOL isPlayback;

@end

@implementation TKEduClassRoom

+ (instancetype )shareInstance{
    
    static TKEduClassRoom *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      singleton = [[TKEduClassRoom alloc] init];
                  });
    
    return singleton;
}

- (id)init
{
    if (self = [super init]) {
        
        _isPlayback = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onRoomControllerDisappear:) name:sTKRoomViewControllerDisappear
                                                   object:nil];
    }
    return self;
}


#pragma mark - 通过链接进入教室
// change openurl
-(void)joinRoomWithUrl:(NSString*)url
{
    self.url = url;
    //此时正在课堂中,需要退出
    if (self.classStatus != EClassStatus_IDLE) {
        
        self.enterClassRoomAgain = YES;
        
        if (_roomJson.roomtype != TKRoomTypeOneToOne) {
            
            [_ctMoreController prepareForLeave:YES];
            
        }else{
            [_ctOneController prepareForLeave:YES];
        }
        
    }else{
        
        [self openUrl:self.url];
    }
}

-(void)openUrl:(NSString*)aString{
    
    aString = [aString stringByRemovingPercentEncoding];
    
    NSArray *tParamArray = [aString componentsSeparatedByString:@"?"];
    if ([tParamArray count]>1) {
        // 回放
        if ([tParamArray[0] containsString:@"replay"]) {
            _isPlayback = YES;
            // 该链接是回放连接
            NSArray *tParamArray2 = [[tParamArray objectAtIndex:1] componentsSeparatedByString:@"&"];
            NSMutableDictionary *tDic = @{}.mutableCopy;
            
            for (int i = 0; i<[tParamArray2 count]; i++) {
                NSArray *tArray= [[tParamArray2 objectAtIndex:i] componentsSeparatedByString:@"="];
                NSString *tKey = [tArray objectAtIndex:0];
                NSString *tValue = [tArray objectAtIndex:1];
                [tDic setValue:tValue forKey:tKey];
            }
            
            // 截取host的服务器地址段
            NSString *server = [NSString stringWithFormat:@"%@", [[[tDic objectForKey:@"host"] componentsSeparatedByString:@"."] firstObject]];
            if (server) {
                [tDic setValue:server forKey:@"server"];
                self.defaultServer = server;
            }
            
            NSString *type = tDic[@"type"];
            if (!type || type.length==0) {
                [tDic setObject:@"3" forKey:@"type"];
            }
            
            // 链接进入的 角色类型字段 是 logintype 不是 userrole 需要添加  user role
            if (![tDic.allKeys containsObject:@"userrole"] && tDic[@"logintype"]) {
                [tDic setObject:tDic[@"logintype"] forKey:@"userrole"];
            }
            
            TKLoginViewController <TKEduRoomDelegate>*loginVC = (TKLoginViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            
            [self joinPlaybackRoomWithParamDic:tDic ViewController:loginVC Delegate:loginVC isFromWeb:YES];
        }
        // 链接
        else {
            _isPlayback = NO;
            NSArray *tParamArray2 = [[tParamArray objectAtIndex:1] componentsSeparatedByString:@"&"];
            NSMutableDictionary *tDic = @{}.mutableCopy;
            
            for (int i = 0; i<[tParamArray2 count]; i++) {
                NSArray *tArray= [[tParamArray2 objectAtIndex:i] componentsSeparatedByString:@"="];
                
                NSString *tKey = [tArray objectAtIndex:0];
                NSString *tValue = [tArray objectAtIndex:1];
                [tDic setValue:tValue forKey:tKey];
                
            }
            
            // 截取host的服务器地址段
            NSString *server = [NSString stringWithFormat:@"%@", [[[tDic objectForKey:@"host"] componentsSeparatedByString:@"."] firstObject]];
            if (server) {
                [tDic setValue:server forKey:@"server"];
                self.defaultServer = server;
            }
            [tDic setObject:@(3) forKey:@"clientType"];
            
            // 链接进入的 角色类型字段 是 logintype 不是 userrole 需要添加  user role
            if (![tDic.allKeys containsObject:@"userrole"] && tDic[@"logintype"]) {
                [tDic setObject:tDic[@"logintype"] forKey:@"userrole"];
            }
            
            TKLoginViewController <TKEduRoomDelegate>*loginVC = (TKLoginViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [self joinRoomWithParamDic:tDic ViewController:loginVC Delegate:loginVC isFromWeb:YES];
        }
        
    }
    else{
        
        TKAlertView *alert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.prompt") contentText:MTLocalized(@"Prompt.prompt") confirmTitle:MTLocalized(@"Prompt.Know")];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [alert show];
        });
        
    }
}

#pragma mark - 回放进入教室
- (int)joinPlaybackRoomWithParamDic:(NSDictionary *)paramDic
                     ViewController:(UIViewController*)controller
                           Delegate:(id<TKEduRoomDelegate>)delegate
                          isFromWeb:(BOOL)isFromWeb
{
/*
 格式:
 {
 colourid = purple;
 domain = gx1;
 host = "democn.talk-cloud.net";
 layout = 0;
 path = "demo.talk-cloud.net:8081/AC278A9B-BDC9-45F5-B90C-4ED843046D48-1238514125/";
 serial = 1238514125;
 server = democn;
 skinId = "beyond_default";
 skinResource = "";
 tplId = beyond;
 type = 0;
 }
 */
    
    // 精简
//    paramDic = @{
//                 @"clientType" : @3,
//                 @"host" : @"global.talk-cloud.net",
//                 @"path" : @"global.talk-cloud.net:8081/2636e2d0-0d61-4ccc-8d91-79e737fff188-375603898/",
//                 @"playback": @1,
//                 @"port" : @"443",
//                 @"serial" : @"375603898",
//                 @"type":@3,
//                 };
    return [[TKEduClassRoom shareInstance] enterPlaybackClassRoomWithParamDic:paramDic ViewController:controller Delegate:delegate isFromWeb:isFromWeb];
}

- (int)enterPlaybackClassRoomWithParamDic:(NSDictionary*)paramDic
                           ViewController:(UIViewController*)controller
                                 Delegate:(id<TKEduRoomDelegate>)delegate
                                isFromWeb:(BOOL)isFromWeb {
    
    if (_classStatus != EClassStatus_IDLE)
    {
        return -1;//正在开会
    }
    
    _classStatus 	= EClassStatus_CHECKING;
    _iController    = controller;
    _iRoomDelegate  = delegate;
    _iParam         = paramDic;
    _isFromWeb      = isFromWeb;
    
    TKUserRoleType uType = [_iParam[@"userrole"] intValue];
    NSString   *pwd  = _iParam[@"password"];
    if ((uType == TKUserType_Teacher && !pwd && pwd.length == 0) && !isFromWeb) {

        [self reportFail:TKErrorCode_CheckRoom_NeedPassword aDescript:@""];
        return -1;
    }

    //获取room.json数据
    [TKEduNetManager getRoomJsonWithPath:paramDic[@"path"] Complete:^int(id  _Nullable response) {
        
        if (response) {
            _classStatus = EClassStatus_CONNECTING;
            int ret = 0;
            TKLog(@"tlm-----checkRoom 进入房间之前的时间: %@", [TKUtil currentTimeToSeconds]);
            ret = [[response objectForKey:@"result"] intValue];
            if (ret == 0) {
                
                NSDictionary *tRoom = [response objectForKey:@"room"];
                if (tRoom) {

                    _roomJson 		   = [[TKRoomJsonModel alloc] initWithDictionary:tRoom
                                                                      isPlayback:_isPlayback];
                    _roomJson.roomrole = [_iParam[@"userrole"] intValue] ?: TKUserType_Teacher;
                    _roomJson.maxvideo = [TKUtil deviceisConform] ? _roomJson.maxvideo : @"2";
                    
                }
                
                
                _enterClassRoomAgain = NO;
                
                // skins
                NSDictionary *dicSkins = [response objectForKey:@"skins"][@"ios"];
                NSString * colourid = dicSkins[@"colourid"];
                if (!colourid) {
                    colourid = response[@"room"][@"colourid"];
                }
                [self enterPlaybackRootViewControllerWithTplId:nil SkinId:nil colourid:colourid];
                
            }
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _enterClassRoomAgain = NO;
                [self enterPlaybackRootViewControllerWithTplId:nil SkinId:nil colourid:nil];
            });
            
            
            
        }
        return 0;
    } aNetError:^int(id  _Nullable response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            _enterClassRoomAgain = NO;
            [self enterPlaybackRootViewControllerWithTplId:nil SkinId:nil colourid:nil];
        });

        return -1;
    }];
    
    //默认返回0
    return 0;
}

#pragma mark - 普通进入教室
- (int)joinRoomWithParamDic:(NSDictionary*)paramDic
            ViewController:(UIViewController*)controller
                  Delegate:(id<TKEduRoomDelegate>)delegate
                 isFromWeb:(BOOL)isFromWeb
{
    return  [[TKEduClassRoom shareInstance] enterClassRoomWithParamDic:paramDic ViewController:controller Delegate:delegate isFromWeb:isFromWeb];
    
}
    
- (int)enterClassRoomWithParamDic:(NSDictionary*)paramDic
                  ViewController:(UIViewController*)controller
                        Delegate:(id<TKEduRoomDelegate>)delegate
                       isFromWeb:(BOOL)isFromWeb
{

    // 学生被T 3分钟内不能登录判断
    if ([self studentWithKick:paramDic]) {
        return 0;
    }
    
    TKLog(@"tlm----- 进入房间之前的时间: %@", [TKUtil currentTimeToSeconds]);
    if (_classStatus != EClassStatus_IDLE) {
        
        return -1;
    }
    _classStatus 	 = EClassStatus_CHECKING;
    _iController     = controller;
    _iRoomDelegate   = delegate;
    _iParam          = paramDic;
    _isFromWeb       = isFromWeb;
    
    //除了学生可以没有密码，其他身份都需要密码
    TKUserRoleType uType = [_iParam[@"userrole"] intValue];// logintype????
    NSString   *pwd  = _iParam[@"password"];

    if (((uType == TKUserType_Teacher || uType == TKUserType_Patrol) && !pwd && pwd.length == 0) &&
        !isFromWeb) {
        [self reportFail:TKErrorCode_CheckRoom_NeedPassword aDescript:@""];
        return -1;
    }
    else{
        
        [TKHUD showAtView:_iController.view message:MTLocalized(@"HUD.EnteringClass") hudType:TKHUDLoadingTypeGifImage];
    }

    [[TKEduSessionHandle shareInstance] configureSession:paramDic aClassRoomDelgate:self aRoomDelegate:delegate];
    
    //默认返回0
    return  0;
}

#pragma mark - checkRoom 回调
- (void)sessionRoomManagerDidOccuredWaring:(TKRoomWarningCode)code{
    
    if (_classStatus == EClassStatus_Finished) {
        return;
    }
    
    if (code == TKRoomWarning_CheckRoom_Completed) {

        
        _roomJson          = [[TKRoomJsonModel alloc] initWithDictionary:[TKRoomManager instance].getRoomProperty
                                                              isPlayback:_isPlayback];
        _roomJson.roomrole = [_iParam[@"userrole"] intValue] ?: TKUserType_Teacher;
        _roomJson.maxvideo = [TKUtil deviceisConform] ? _roomJson.maxvideo : @"2";
        [TKRoomManager instance].localUser.role = (TKUserRoleType)_roomJson.roomrole;
        
        

        // 下载发奖杯 音频
        // 自定义奖杯和声音
        for (NSDictionary *dic in _roomJson.trophy) {
            
            NSString *trophyIconURL = [NSString stringWithFormat:@"http://%@",[TKUtil optString:_iParam Key:@"host"]];
            [TKEduNetManager downLoadTaskToSandboxWithHost:trophyIconURL
                                                   taskDic:dic
                                                  complete:^int(id  _Nullable response) {
                                                      return 0;
                                                  } aNetError:^int(id  _Nullable response) {
                                                      return 0;
                                                  }];
            
        }
        
        //checkroom 成功
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // change openurl
            _enterClassRoomAgain = NO;
            
            // 课堂为1vn课堂或者 允许助教上下台的需进入一对多的界面
            [self initRootViewControllerWithRoomProperty:_roomJson];
            
        });
    }
}

-(void)sessionClassRoomDidOccuredError:(NSError *)error{
    
    if (_classStatus == EClassStatus_Finished) {
        return;
    }
    
    [self reportFail:error.code aDescript:@""];

}
- (void)initRootViewControllerWithRoomProperty:(TKRoomJsonModel *)property {

    NSString *tplId 	= _roomJson.tplId;//模板id
    NSString *skinId 	= _roomJson.skinId;//皮肤id
    NSString *colourid  = _roomJson.colourid;
    
    [self enterRootViewControllerWithTplId:tplId SkinId:skinId colourid:colourid];
}

- (void)enterRootViewControllerWithTplId:(NSString *)tplId SkinId:(NSString *)skinId colourid:(NSString *)colourid {

    // colour id 非字符串统一处理
    if (![colourid isKindOfClass:[NSString class]]) {
        colourid = @"0";
    }
    
    if([colourid isEqualToString:TKBlackSkin]) {
        [TXSakuraManager shiftSakuraWithName:TKBlackSkin type:TXSakuraTypeMainBundle];
    } else {
        // 默认（未指定或指定默认）
        [TXSakuraManager shiftSakuraWithName:TKCartoonSkin type:TXSakuraTypeMainBundle];
    }
    
    [TKHUD hideForView:_iController.view];
    UIViewController *viewController;
    // 配置项 允许助教上台,  创建一对多教室
    if(_roomJson.roomtype != TKRoomTypeOneToOne || _roomJson.configuration.assistantCanPublish) {
        
        _ctMoreController = [[TKManyViewController alloc] initWithDelegate:_iRoomDelegate aParamDic:_iParam];
        viewController = _ctMoreController;
        
    } else {
        
        _ctOneController = [[TKOneViewController alloc] initWithDelegate:_iRoomDelegate aParamDic:_iParam];
        viewController = _ctOneController;
        
    }
    
    /**内存泄漏*/
    _iEduNavigationController = [[TKNavigationController alloc] initWithRootViewController:viewController];
    _iEduNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [_iController presentViewController:_iEduNavigationController animated:YES completion:^{

        _classStatus = EClassStatus_Finished;
    }];
}
- (void)enterPlaybackRootViewControllerWithTplId:(NSString *)tplId SkinId:(NSString *)skinId colourid:(NSString *)colourid {
    
    // colour id 非字符串统一处理
    if (![colourid isKindOfClass:[NSString class]]) {
        colourid = @"0";
    }
    
    if([colourid isEqualToString:TKBlackSkin]) {
        [TXSakuraManager shiftSakuraWithName:TKBlackSkin type:TXSakuraTypeMainBundle];
    } else {
        // 默认（未指定或指定默认）
        [TXSakuraManager shiftSakuraWithName:TKCartoonSkin type:TXSakuraTypeMainBundle];
    }
    
    UIViewController *viewController;
    
    if(_roomJson.roomtype != TKRoomTypeOneToOne || _roomJson.configuration.assistantCanPublish) {
        
        //只允许1vN
        _ctMoreController = [[TKManyViewController alloc] initPlaybackWithDelegate:_iRoomDelegate aParamDic:_iParam];
        viewController = _ctMoreController;
    }
    else {
        
        _ctOneController = [[TKOneViewController alloc] initPlaybackWithDelegate:_iRoomDelegate aParamDic:_iParam];
        viewController = _ctOneController;
    }

    
    _iEduNavigationController = [[TKNavigationController alloc] initWithRootViewController:viewController];
    [TKHUD hideForView:_iController.view];
    _iEduNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [_iController presentViewController:_iEduNavigationController animated:YES completion:^{
        
        _classStatus = EClassStatus_Finished;
    }];
}

- (void)onRoomControllerDisappear:(NSNotification*)__unused notif
{
    _iEduNavigationController = nil;
    _ctOneController = nil;
    _ctMoreController = nil;
    
    _classStatus = EClassStatus_IDLE;
    _iRoomDelegate = nil;
    _iController = nil;
    // change openurl
    
    //如果是因为再次进入而产生的退出，则需要重新进入
    if ( self.enterClassRoomAgain) {
        [self joinRoomWithUrl:self.url];
        
    }
}

#pragma mark 提示弹窗
- (void)reportFail:(TKRoomErrorCode)ret  aDescript:(NSString *)aDescript
{
    
    if(_iRoomDelegate)
    {
        bool report            = true;
        NSString *alertMessage = nil;
        switch (ret) {
            case TKErrorCode_CheckRoom_ServerOverdue: {//3001  服务器过期
                alertMessage = MTLocalized(@"Error.ServerExpired");
                //alertMessage = @"服务器过期";
            }
                break;
            case TKErrorCode_CheckRoom_RoomFreeze: {//3002  公司被冻结
                alertMessage = MTLocalized(@"Error.CompanyFreeze");
                //alertMessage = @"公司被冻结";
            }
                break;
            case TKErrorCode_CheckRoom_RoomDeleteOrOrverdue: //3003  房间被删除或过期
            case TKErrorCode_CheckRoom_RoomNonExistent: {//4007 房间不存在 房间被删除或者过期
                alertMessage = MTLocalized(@"Error.RoomDeletedOrExpired");
                // alertMessage = @"房间被删除或者过期";
            }
                break;
            case TKErrorCode_CheckRoom_RequestFailed:
                alertMessage = MTLocalized(@"Error.WaitingForNetwork");
                break;
            case TKErrorCode_CheckRoom_PasswordError: {//4008  房间密码错误
                alertMessage = MTLocalized(@"Error.PwdError");
                //                 alertMessage = @"房间密码错误";
            }
                break;
                
            case TKErrorCode_CheckRoom_WrongPasswordForRole: {//4012  密码与角色不符
                alertMessage = MTLocalized(@"Error.PwdError");
                //alertMessage = @"房间密码错误";
            }
                break;
                
            case TKErrorCode_CheckRoom_RoomNumberOverRun: {//4103  房间人数超限
                alertMessage = MTLocalized(@"Error.MemberOverRoomLimit");
                //alertMessage = @"房间人数超限";
            }
                break;
                
            case TKErrorCode_CheckRoom_NeedPassword: {//4110  该房间需要密码，请输入密码
                alertMessage = MTLocalized(@"Error.NeedPwd");
                //                 alertMessage = @"该房间需要密码，请输入密码";
            }
                break;
                
            case TKErrorCode_CheckRoom_RoomPointOverrun: {//4112  企业点数超限
                alertMessage = MTLocalized(@"Error.pointOverRun");
                //                 alertMessage = @" 企业点数超限";
            }
                break;
            case TKErrorCode_CheckRoom_RoomAuthenError: {//4109
                alertMessage = MTLocalized(@"Error.AuthIncorrect");
                //                 alertMessage = @"认证错误";
            }
                break;
                
            default:{
                report = YES;
                //alertMessage = aDescript;
                alertMessage = [NSString stringWithFormat:@"%@(%ld)",MTLocalized(@"Error.WaitingForNetwork"),(long)ret];
                
                break;
            }
                
        }
        
        
        if (ret == TKErrorCode_CheckRoom_NeedPassword || ret == TKErrorCode_CheckRoom_PasswordError ||  ret ==  TKErrorCode_CheckRoom_WrongPasswordForRole)
        {//密码弹出
            
            
            [TKHUD hideForView:_iController.view];
            
            if (self.errorAlert) {
                [self.errorAlert dismissAlert];
                self.errorAlert = nil;
            }
            
            self.errorAlert = [[TKAlertView alloc] initWithInputTitle:MTLocalized(@"Prompt.prompt")
                                                                style:ret
                                                                tplID:[TXSakuraManager getSakuraCurrentName]
                                                             userrole:[[_iParam objectForKey:@"userrole"] intValue]
                                                         confirmTitle:MTLocalized(@"Prompt.OK")];
            
            [self.errorAlert show];
            
            NSDictionary *tDict = _iParam;
            BOOL tIsFromWeb = _isFromWeb;
            
            tk_weakify(self);
            self.errorAlert.confirmBlock = ^(NSString *password) {
                
                NSMutableDictionary *tHavePasswordDic = [NSMutableDictionary dictionaryWithDictionary:tDict];
                [tHavePasswordDic setObject:password forKey:@"password"];
                [[TKEduClassRoom shareInstance] joinRoomWithParamDic:tHavePasswordDic ViewController:weakSelf.iController Delegate:weakSelf.iRoomDelegate isFromWeb:tIsFromWeb];
                
            };

        }else{
            
            
            [TKHUD hideForView:_iController.view];
            
            if (self.errorAlert) {
                [self.errorAlert dismissAlert];
                self.errorAlert = nil;
            }
            self.errorAlert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.prompt") contentText:alertMessage confirmTitle:MTLocalized(@"Prompt.OK")];
            [self.errorAlert show];
           
            
            [[TKEduSessionHandle shareInstance].whiteBoardManager resetWhiteBoardAllData];
            [[TKEduSessionHandle shareInstance].whiteBoardManager clearAllData];
            [TKEduSessionHandle shareInstance].whiteBoardManager = nil;
            [[TKEduSessionHandle shareInstance] clearAllClassData];
            [TKEduSessionHandle destroy];
            
            
            
        }
        if (report)
        {
            if ([_iRoomDelegate respondsToSelector:@selector(onEnterRoomFailed:Description:)]) {
                [(id<TKEduRoomDelegate>)_iRoomDelegate onEnterRoomFailed:ret Description:alertMessage];
            }
            _classStatus = EClassStatus_IDLE;
            
        }
    }
}
// 学生被踢 3分钟不能进入房间检查
- (int)studentWithKick:(NSDictionary *)paramDic {
    
    if ([paramDic[@"userrole"] intValue] != TKUserType_Student) {

        return NO;
    }
    
    id idTime = [[NSUserDefaults standardUserDefaults] objectForKey:TKKickTime];
    NSString *room = [[NSUserDefaults standardUserDefaults] objectForKey:TKKickRoom];

    
    if (!room.length) {
        return NO;
    }
    
    if (!idTime) {
        return NO;
    }
    
    NSString *tString = @"";
    if ([idTime isKindOfClass:NSDate.class]) {
        NSDate *time = (NSDate *)idTime;
        NSDate *curTime = [NSDate date];
        NSTimeInterval delta = [curTime timeIntervalSinceDate:time]; // 计算出相差多少秒
        
        if (delta < 60 * 3) {
            //当前房间
            NSDictionary *roomDict = [TKRoomManager instance].getRoomProperty;
            NSString *currnetRoom = roomDict[@"serial"];

            if ([room isEqualToString: currnetRoom]) {
                tString = MTLocalized(@"Prompt.kick");
            }
            
        }else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey: TKKickTime];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey: TKKickRoom];
        }
    }

    
    if (!tString.length) {
        
        TKAlertView *alert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.prompt") contentText:tString confirmTitle:MTLocalized(@"Prompt.Know")];
        [alert show];
        
        return YES;
    }
    return NO;
}


@end
