//
//  TKCTOneViewController.m
//  EduClass
//
//  Created by talkcloud on 2018/10/9.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKOneViewController.h"
#import "TKOneViewController+Playback.h"
#import "TKOneViewController+ImagePicker.h"
#import "TKOneViewController+Media.h"
#import "TKOneViewController+WhiteBoard.h"

#import "TKEduSessionHandle.h"
#import <objc/message.h>

#import "TKCTListView.h" //文档、媒体、用户列表切换视图
#import "TKCTChatView.h" //聊天视图
#import "TKCTUserListView.h"//用户列表视图

//reconnection
#import "TKTimer.h"
#import "TKRCGlobalConfig.h"

#import "TKEduSessionHandle.h"

#import "TKChatMessageModel.h"

#import "sys/utsname.h"

#import "TKMediaDocModel.h"
#import "TKDocmentDocModel.h"
#import "TKProgressSlider.h"
#import <AVFoundation/AVFoundation.h>
#pragma mark 上传图片
#import "TKUploadImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "TKCTNewChatView.h"
#import "TKStuTimerView.h"
#import "TKPopView.h"
#import "TKAnswerSheetView.h"
#import "TKTimerView.h"
#import "TKDialView.h"
#import "UIView+Drag.h"
#import "TKBrushToolView.h"
#import "TKCTNetDetailView.h"

@interface TKOneViewController ()
<TKEduBoardDelegate,TKEduSessionDelegate,
UIGestureRecognizerDelegate,UIScrollViewDelegate,
CAAnimationDelegate,UIImagePickerControllerDelegate,
TKEduNetWorkDelegate,UINavigationControllerDelegate,TKPopViewDelegate,TKNativeWBPageControlDelegate>

{
    CGFloat _sStudentVideoViewHeigh;
    CGFloat _sStudentVideoViewWidth;
    CGFloat _whiteBoardTopBottomSpace;// 白板的上下间隔
    CGFloat _whiteBoardLeftRightSpace;// 左右间隔
    CGFloat _viewX;// 横屏x坐标(适配x+)
    CGRect videoOriginFrame;      // 画中画视频初始frame
    BOOL	isRemoteFullScreen;   // 收到远端的信令  全屏
}
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, assign) TKRoomType iRoomType;//当前房间类型
@property (nonatomic, assign) TKUserRoleType iUserType;//当前身份

@property (nonatomic, strong) UIView *dimView; // 作用:点击空白视图 消失课件库 花名册

@property (nonatomic, strong) TKCTListView *listView;//课件库
@property (nonatomic, strong) TKCTUserListView *userListView;//控制按钮视图
@property (nonatomic, strong) TKCTChatView *chatView;//聊天视图
@property (nonatomic, strong) TKCTNetDetailView * netDetailView;//网络质量

//@property (nonatomic, strong) TKCTControlView *controlView;//控制按钮视图

@property (nonatomic, assign) NSDictionary* iParamDic;// 加入房间参数

@property (nonatomic, strong) TKCTBaseMediaView *iScreenView;//共享桌面

@property (nonatomic, strong) NSMutableDictionary    *iPlayVideoViewDic;//播放的视频view的字典


@property (nonatomic, strong) TKCTVideoSmallView *iTeacherVideoView;//老师视频
@property (nonatomic, strong) TKCTVideoSmallView *iOurVideoView;//自己的视频

@property (nonatomic, assign) BOOL            addVideoBoard;//视频标注添加标识
@property (nonatomic, assign) BOOL            isLocalPublish;
@property (nonatomic, assign) BOOL   		  isRemindClassEnd;


@property (nonatomic, copy) NSString *currentServer;

@property (nonatomic, assign) BOOL isQuiting;

// 发生断线重连设置为YES，恢复后设置为NO
@property (nonatomic, assign) BOOL networkRecovered;

@property (nonatomic, assign) NSTimeInterval iLocalTime;
@property (nonatomic, assign) NSTimeInterval iClassStartTime;
@property (nonatomic, assign) NSTimeInterval iServiceTime;
@property (nonatomic, assign) NSTimeInterval iCurrentTime;// 当前时间
@property (nonatomic, assign) NSTimeInterval iHowMuchTimeServerFasterThenMe; // 时间差

@property(nonatomic,copy)     NSString * iRoomName;

@property (nonatomic, strong) NSTimer *iClassCurrentTimer;
@property (nonatomic, strong) NSTimer *iClassTimetimer;
@property (nonatomic, strong) TKTimer *iCheckPlayVideotimer;
//视频的宽高属性
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;// 本地移动视频手势
#pragma mark pad
//白板
@property (nonatomic, assign) BOOL iShowBefore;//yes 出现过 no 没出现过
@property (nonatomic, assign) BOOL iShow;//yes 出现过 no 没出现过

//视频
@property (nonatomic, weak)  id<TKEduRoomDelegate> iRoomDelegate;
@property (nonatomic, assign) CGPoint iStrtCrtVideoViewP;

@property (nonatomic, strong) UILabel *replyText;
@property (nonatomic,assign) CGFloat knownKeyboardHeight;
@property (nonatomic,strong ) NSArray  *iMessageList;
@property (nonatomic, strong) TKStuTimerView *stuTimer;// 学生端计时器
@property (nonatomic, strong) TKTimerView *timerView;// 计时器选择器
@property (nonatomic, strong) TKDialView *dialView;
@property (nonatomic, strong) TKBrushToolView *brushToolView; // 画笔工具


@property (nonatomic, strong) UIView   *splitScreenView;//分屏背景视图


@end

@implementation TKOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCommon];
    
    //初始化导航栏
    [self initNavigation];
    
    //初始化聊天界面
    [self initMessageView];
    
    //初始化视频视图
    [self initVideoView];
    
    //初始化白板
    [self initWhiteBoardView];
    
    [self initTapGesTureRecognizer];
    
    [self.backgroundImageView bringSubviewToFront:_iTKEduWhiteBoardView];
    
    [self initAudioSession];
    
    //初始化白板控件
    [self initWhiteBoardNativeTool];
    
    // 如果是回放，那么放上遮罩页
    if (_iSessionHandle.isPlayback == YES) {
        [self initPlaybackMaskView];
    }
    
    [_iSessionHandle  configureHUD:MTLocalized(@"HUD.EnteringClass") aIsShow:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [self addNotification];
    
    [self createTimer];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    _iSessionHandle.UIDidAppear = YES;
    NSArray *array = [_iSessionHandle.cacheMsgPool copy];
    
    for (NSDictionary *dic in array) {
        
        NSString *func = [TKUtil optString:dic Key:kTKMethodNameKey];
        
        SEL funcSel = NSSelectorFromString(func);
        
        
        NSMutableArray *params = [NSMutableArray array];
        if([[dic allKeys] containsObject:kTKParameterKey])
        {
            params = dic[kTKParameterKey];
        }
        
        if ([func isEqualToString:NSStringFromSelector(@selector(sessionManagerRoomJoined))]
            ||
            [func isEqualToString:NSStringFromSelector(@selector(sessionManagerRoomLeft))]
            ||
            [func isEqualToString:NSStringFromSelector(@selector(networkTrouble))]
            ||
            [func isEqualToString:NSStringFromSelector(@selector(networkChanged))]
            ||
            [func isEqualToString:NSStringFromSelector(@selector(sessionManagerMediaLoaded))]
            ||
            [func isEqualToString: NSStringFromSelector(@selector(sessionManagerPlaybackClearAll))]
            ||
            [func isEqualToString:NSStringFromSelector(@selector(sessionManagerPlaybackEnd))]) {
            
            ((void(*)(id,SEL))objc_msgSend)(self, funcSel);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerDidOccuredWaring:))]){
            
            TKRoomWarningCode code = (TKRoomWarningCode)[params.firstObject intValue];
            ((void(*)(id,SEL,TKRoomWarningCode))objc_msgSend)(self, funcSel,code);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerSelfEvicted:))]){
            
            NSDictionary *dict = params.firstObject;
            ((void(*)(id,SEL,NSDictionary *))objc_msgSend)(self, funcSel,dict);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerPublishStateWithUserID:publishState:))]){
            
            NSString *str = params.firstObject;
            TKPublishState state =(TKPublishState)[params.lastObject intValue];
            ((void(*)(id,SEL,NSString *,TKPublishState))objc_msgSend)(self, funcSel , str,state);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerUserJoined:InList:))]){
            
            NSString *str = params.firstObject;
            BOOL inList = [params.lastObject boolValue];
            ((void(*)(id,SEL,NSString *,BOOL))objc_msgSend)(self, funcSel , str,inList);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerAudioStateWithUserID:publishState:))]){
            
            NSString *str = params.firstObject;
            TKPublishState state =(TKPublishState)[params.lastObject intValue];
            ((void(*)(id,SEL,NSString *,TKPublishState))objc_msgSend)(self, funcSel , str,state);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerVideoStateWithUserID:publishState:))]){
            
            NSString *str = params.firstObject;
            TKPublishState state =(TKPublishState)[params.lastObject intValue];
            ((void(*)(id,SEL,NSString *,TKPublishState))objc_msgSend)(self, funcSel , str,state);
            
        }else if ([func isEqualToString:NSStringFromSelector(@selector(sessionManagerUserLeft:))]){
            
            NSString *str = params.firstObject;
            ((void(*)(id,SEL,NSString *))objc_msgSend)(self, funcSel,str);
            
        }else if ([func isEqualToString:NSStringFromSelector(@selector(sessionManagerUserChanged:Properties:fromId:))]){
            
            NSString * peerID=params[0];
            NSDictionary * properties=params[1];
            NSString * fromId= params[2];
            
            ((void(*)(id,SEL,NSString *,NSDictionary *,NSString *))objc_msgSend)(self, funcSel,peerID,properties,fromId);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerMessageReceived:fromID:extension:))]){
            NSString * message=params[0];
            NSString * peerID=params[1];
            NSDictionary * fromId= params[2];
            
            ((void(*)(id,SEL,NSString *,NSString *,NSDictionary *))objc_msgSend)(self, funcSel,message,peerID,fromId);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerRoomManagerPlaybackMessageReceived:fromID:ts:extension:))]){
            
            NSString * message=params[0];
            TKRoomUser * user=params[1];
            NSTimeInterval  ts= [params[2] doubleValue];
            NSDictionary *dict = params[3];
            ((void(*)(id,SEL,NSString *,TKRoomUser *,NSTimeInterval,NSDictionary *))objc_msgSend)(self, funcSel,message,user,ts,dict);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerDidFailWithError:))]){
            
            NSError * error = params[0];
            
            ((void(*)(id,SEL,NSError *))objc_msgSend)(self, funcSel,error);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerOnRemoteMsg:ID:Name:TS:Data:InList:))]){
            BOOL add = [params[0] boolValue];
            NSString*msgID = params[1];
            NSString*msgName = params[2];
            unsigned long ts = [params[3] unsignedIntValue];
            NSObject*data = params[4];
            BOOL inlist = [params[5] boolValue];
            
            ((void(*)(id,SEL,BOOL,NSString *,NSString *,unsigned long,NSObject *,BOOL))objc_msgSend)(self, funcSel,add,msgID,msgName,ts,data,inlist);
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerGetGiftNumber:))]){
            dispatch_block_t completion = params[0];
            
            ((void(*)(id,SEL,dispatch_block_t))objc_msgSend)(self, funcSel,completion);
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerOnShareMediaState:state:extensionMessage:))]){
            NSString *peerId = params[0];
            TKMediaState state = (TKMediaState)[params[1] intValue];
            NSDictionary *message = params[2];
            ((void(*)(id,SEL,NSString *,TKMediaState,NSDictionary*))objc_msgSend)(self, funcSel,peerId,state,message);
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerUpdateMediaStream:pos:isPlay:))]){
            NSTimeInterval duration =[params[0] doubleValue];
            NSTimeInterval pos = [params[1] doubleValue];
            BOOL isPlay = [params[2] boolValue];
            
            ((void(*)(id,SEL,NSTimeInterval,NSTimeInterval,BOOL))objc_msgSend)(self, funcSel,duration,pos,isPlay);
        }else if([func isEqualToString:NSStringFromSelector(@selector(roomManagerOnShareScreenState:state:extensionMessage:))]
                 ||
                 [func isEqualToString:NSStringFromSelector(@selector(sessionManagerOnShareFileState:state:extensionMessage:))]){
            
            NSString *peerId = params[0];
            TKMediaState state = (TKMediaState)[params[1] intValue];
            NSDictionary *message = params[3];
            
            
            ((void(*)(id,SEL,NSString *,TKMediaState,NSDictionary *))objc_msgSend)(self, funcSel,peerId,state,message);
        }else if ([func isEqualToString: NSStringFromSelector(@selector(sessionManagerReceivePlaybackDuration:))]
                  ||
                  [func isEqualToString:NSStringFromSelector(@selector(sessionManagerPlaybackUpdateTime:))]){
            NSTimeInterval duration = [params[0] doubleValue];
            
            ((void(*)(id,SEL,NSTimeInterval))objc_msgSend)(self, funcSel,duration);
        }
    }
    
    _iSessionHandle.cacheMsgPool = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.chatViewNew removeSubviews];
    if (!_iPickerController) {
        [self invalidateTimer];
    }
    [self removeNotificaton];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark Pad 初始化

-(void)initAudioSession{
    
    //    AVAudioSession* session = [AVAudioSession sharedInstance];
    //    NSError* error;
    //    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetooth  error:&error];
    //    [session setMode:AVAudioSessionModeVoiceChat error:nil];
    //    [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    //    [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
    AVAudioSessionRouteDescription*route = [[AVAudioSession sharedInstance]currentRoute];
    for (AVAudioSessionPortDescription * desc in [route outputs]) {
        
        if ([[desc portType]isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
            _iSessionHandle.isHeadphones = NO;
            _iSessionHandle.iVolume = 1;
            //            [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        }else{
            _iSessionHandle.isHeadphones = YES;
            _iSessionHandle.iVolume = 0.5;
        }
    }
}

-(void)initNavigation
{
    self.navigationController.navigationBar.hidden = YES;
    
    self.navbarView = [[TKCTNavView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.navbarHeight) aParamDic:_iParamDic];
    [self.backgroundImageView addSubview:self.navbarView];
    
    tk_weakify(self);
    self.navbarView.leaveButtonBlock = ^{//离开课堂 （返回)
        [weakSelf.view endEditing:YES];
        [weakSelf leftButtonPress];
        
    };
    self.navbarView.classBeginBlock = ^{
        [weakSelf hiddenNavAlertView];
    };
    self.navbarView.classoverBlock = ^{//下课
        TKLog(@"下课");
        [weakSelf hiddenNavAlertView];
        [weakSelf.iSessionHandle  configureHUD:@"" aIsShow:YES];
        [weakSelf.iClassTimetimer invalidate];      // 下课后计时器销毁
        weakSelf.iClassTimetimer = nil;
        
        // 下课关闭MP3和MP4
        if (weakSelf.iSessionHandle.isPlayMedia == YES) {
            weakSelf.iSessionHandle.isPlayMedia          = NO;
            [weakSelf.iSessionHandle  sessionHandleUnpublishMedia:^(NSError * _Nonnull error) {
                
            }];
        }
        
        if(!weakSelf.roomJson.configuration.forbidLeaveClassFlag){
            
            // 下课清理聊天日志
            [weakSelf.iSessionHandle  clearMessageList];
            
            // 下课文档复位
            [weakSelf.iSessionHandle  fileListResetToDefault];
            // 下课后showpage
            //            [_iSessionHandle  docmentDefault:[_iSessionHandle  getClassOverDocument]];
            
            [weakSelf.iSessionHandle.whiteBoardManager changeDocumentWithFileID:[weakSelf.iSessionHandle  getClassOverDocument].fileid isBeginClass:weakSelf.iSessionHandle.isClassBegin isPubMsg:YES];
        }
        
        [TKEduNetManager classBeginEnd:[TKEduClassRoom shareInstance].roomJson.roomid
                             companyid:[TKEduClassRoom shareInstance].roomJson.companyid
                                 aHost:sHost
                                 aPort:sPort
                                userid:weakSelf.iSessionHandle.localUser.peerID
                                roleid:weakSelf.iSessionHandle.localUser.role == TKUserType_Teacher ? @"0" : @"1" aComplete:^int(id  _Nullable response) {
                                    
                                    [weakSelf.iSessionHandle  sessionHandleDelMsg:sClassBegin ID:sClassBegin To:sTellAll Data:@{} completion:^(NSError * _Nonnull error) {
                                    }];
                                    
                                    [weakSelf.iSessionHandle configureHUD:@"" aIsShow:NO];
                                    
                                    return 0;
                                }aNetError:^int(id  _Nullable response) {
                                    
                                    [weakSelf.iSessionHandle configureHUD:@"" aIsShow:NO];
                                    
                                    return 0;
                                }];
    };
    
    // 花名册
    self.navbarView.memberButtonClickBlock = ^(UIButton *sender) {
        
        if (sender.selected) {
            
            weakSelf.navbarView.showRedDot = NO;
            [weakSelf hiddenNavAlertView];
            
            //花名册：宽 7/10  高 9/10
            CGFloat showHeight = ScreenH - TKNavHeight;
            CGFloat showWidth  = fmaxf(ScreenW*(6/10.0), 485);
            CGFloat x = (ScreenW-showWidth)/2.0;
            //            CGFloat y = (ScreenH-showHeight)/2.0;
            CGFloat y = weakSelf.navbarView.height;
            
            weakSelf.dimView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.width - showWidth, showHeight)];
            weakSelf.dimView.backgroundColor = UIColor.clearColor;
            UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(tapOnViewToHide)];
            [weakSelf.dimView addGestureRecognizer:tapG];
            [weakSelf.view addSubview:weakSelf.dimView];
            
            weakSelf.userListView = [[TKCTUserListView alloc]initWithFrame:CGRectMake(x,y,showWidth,showHeight) userList:nil];
            [weakSelf.userListView show:weakSelf.view];
            weakSelf.userListView.dismissBlock = ^{
                weakSelf.navbarView.memberButton.selected = NO;
                weakSelf.userListView = nil;
            };
            
        }else{
            
            [weakSelf tapOnViewToHide];
            
        }
    };
    
    self.navbarView.coursewareButtonClickBlock = ^(UIButton * sender) {
        //课件库按钮
        if (sender.selected) {
            if (!weakSelf.listView) {
                
                [weakSelf hiddenNavAlertView];
                
                
                //文件列表：            宽 7/10  高 9/10
                CGFloat showHeight = ScreenH - TKNavHeight;
                CGFloat showWidth = fmaxf(ScreenW * (6/10.0), 500);
                CGFloat x = (ScreenW-showWidth)/2.0;
                //                CGFloat y = (ScreenH-showHeight)/2.0;
                CGFloat y = weakSelf.navbarView.height;
                
                weakSelf.dimView = [[UIView alloc] initWithFrame:CGRectMake(0, y, weakSelf.view.width - showWidth, showHeight)];
                weakSelf.dimView.backgroundColor = UIColor.clearColor;
                UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(tapOnViewToHide)];
                [weakSelf.dimView addGestureRecognizer:tapG];
                [weakSelf.view addSubview:weakSelf.dimView];
                
                weakSelf.listView = [[TKCTListView alloc]initWithFrame:CGRectMake(x,y, showWidth, showHeight) andTitle:@"dd" from:nil];
                [weakSelf.listView show:weakSelf.view];
                weakSelf.listView.dismissBlock = ^{
                    
                    weakSelf.navbarView.coursewareButton.selected = NO;
                    weakSelf.listView = nil;
                };
            }
        }else{
            [weakSelf tapOnViewToHide];
        }
    };
    
    self.navbarView.messageButtonClickBlock = ^(UIButton *sender) {//聊天视图
        
        if (sender.selected) {
            
            if (!weakSelf.chatView) {
                
                [weakSelf hiddenNavAlertView];
                
                //聊天弹框：           宽 8/10  高 10/10
                CGFloat showHeight = fmaxf(ScreenH * (6/10.0), 300);
                CGFloat showWidth = ScreenW * (6/10.0);
                CGFloat x = (ScreenW-showWidth)/2.0;
                CGFloat y = (ScreenH-showHeight)/2.0;
                
                weakSelf.chatView = [[TKCTChatView alloc]initWithFrame:CGRectMake(x,y,showWidth,showHeight) chatController:nil];
                weakSelf.chatView.dismissBlock = ^{
                    
                    weakSelf.navbarView.messageButton.selected = NO;
                    weakSelf.chatView = nil;
                };
                [weakSelf.chatView show:weakSelf.view];
                
                if (weakSelf.iSessionHandle.unReadMessagesArray.count>0) {
                    
                    [weakSelf.iSessionHandle.unReadMessagesArray removeAllObjects];
                }
                // 解决录制问题 聊天窗口问题
                if (weakSelf.iSessionHandle.localUser.role == TKUserType_Teacher && weakSelf.iSessionHandle.isClassBegin == YES) {
                    
                    [weakSelf.iSessionHandle sessionHandlePubMsg:@"ChatShow" ID:@"ChatShow" To:sTellNone Data:@{} Save:YES completion:^(NSError * _Nonnull error) {}];
                }
                [weakSelf.navbarView buttonRefreshUI];
            }
        }else{
            if (weakSelf.chatView) {
                [weakSelf.chatView hidden];
                weakSelf.chatView = nil;
            }
            // 解决录制问题 聊天窗口问题
            if (weakSelf.iSessionHandle.localUser.role == TKUserType_Teacher && weakSelf.iSessionHandle.isClassBegin == YES) {
                [weakSelf.iSessionHandle sessionHandleDelMsg:@"ChatShow" ID:@"ChatShow" To:sTellNone Data:@{} completion:nil];
            }
        }
    };
    
    self.navbarView.controlButtonClickBlock = ^(UIButton *sender) {//控制视图
    };
    
    self.navbarView.toolBoxButtonClickBlock = ^(UIButton *sender) {
        //点击工具箱不隐藏聊天
        //        [weakSelf.chatViewNew hide:YES];
        [weakSelf hiddenNavBarViewActionView];
        //        [weakSelf.iSessionHandle.whiteBoardManager showToolbox:sender.selected];
        TKPopView *popview = [TKPopView showPopViewAddedTo:weakSelf.view pointingAtView:sender];
        popview.popViewType = TKPopViewType_ToolBox;
        popview.delegate = weakSelf;
    };
    
    self.navbarView.netStateBlock = ^(CGFloat centerX) {
        
        [weakSelf hiddenNavBarViewActionView];
        weakSelf.netDetailView = [TKCTNetDetailView showDetailViewWithPoint:CGPointMake(centerX, TKNavHeight) diss:^{
            
            [weakSelf.navbarView.netTipView changeDetailSignImage:NO];
            [weakSelf.netDetailView removeFromSuperview];
            weakSelf.netDetailView = nil;
        }];
        [weakSelf.netDetailView changeDetailData:weakSelf.navbarView.netTipView.netState];
    };
}
- (instancetype)initWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                       aParamDic:(NSDictionary *)aParamDic
                       
{
    if (self = [self init]) {
        _iRoomDelegate      = aRoomDelegate;
        _iParamDic          = aParamDic;
        _currentServer      = [aParamDic objectForKey:@"server"];
        
        _iSessionHandle = [TKEduSessionHandle shareInstance] ;
        _iSessionHandle.isPlayback = NO;
        _iSessionHandle.isSendLogMessage = YES;
        
        [_iSessionHandle setSessionDelegate:self aBoardDelegate:self ];
    }
    return self;
}

// 回放初始化接口
- (instancetype)initPlaybackWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                               aParamDic:(NSDictionary *)aParamDic

{
    if (self = [self init]) {
        _iRoomDelegate      = aRoomDelegate;
        _iParamDic          = aParamDic;
        _currentServer      = [aParamDic objectForKey:@"server"];
        
        _iSessionHandle = [TKEduSessionHandle shareInstance] ;
        _iSessionHandle.isPlayback = YES;
        _iSessionHandle.isSendLogMessage = NO;

        [_iSessionHandle configurePlaybackSession:aParamDic aRoomDelegate:aRoomDelegate aSessionDelegate:self aBoardDelegate:self];
    }
    return self;
}

//初始化
- (void)initCommon
{
    self.backgroundImageView.contentMode =  UIViewContentModeScaleToFill;
    self.backgroundImageView.sakura.image(@"ClassRoom.backgroundImage");

    _isConnect 			= NO;
    _networkRecovered   = YES;
    _iShow              = NO;
    _roomJson           = [TKEduClassRoom shareInstance].roomJson;
    _iUserType          = _roomJson.roomrole;
    _iRoomType 			= _roomJson.roomtype;
    _viewX 				= [TKUtil isiPhoneX] ? 44 : 0;
    
    //课堂中的视频分辨率
    self.iTKEduWhiteBoardDpi = 3/4.0;// 视频框固定尺寸
    [TKHelperUtil setVideoFormat];
    
    self.navbarHeight = IS_IPHONE ? 45 : 60; //sH * 0.4;
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenVideoLongPressClick:)];
    _longPressGesture.minimumPressDuration = 0.2f;
    
    // 位置计算
    [self calculateWhiteBoardVideoViewFrame];
    // tabbar view 去掉了
    _iSessionHandle.bottomHeight = 0;
    
    // 定时器
//    _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                        target:self
//                                                      selector:@selector(onClassTimer)
//                                                      userInfo:nil
//                                                       repeats:YES];
//    [_iClassTimetimer setFireDate:[NSDate distantFuture]];
    
}
//MARK: 初始化聊天界面
- (void)initMessageView
{
    float _height = fmaxf(ScreenH * (6/10.0), 300);
    float _width = ScreenW * (1/3.0);
    
    self.chatViewNew = [[TKCTNewChatView alloc] initWithFrame:CGRectMake(0, 0, _width, _height) chatController:nil];
    self.chatViewNew.x = 15;
    self.chatViewNew.y = self.view.height - _height - 30.0f / 768 * ScreenH;
    [self.view addSubview:self.chatViewNew];
    [self.chatViewNew setBadgeNumber:_iSessionHandle.unReadMessagesArray.count];
    __weak typeof(self) __self = self;
    self.chatViewNew.messageBtnClickBlock = ^(UIButton * _Nonnull sender) {
        if (sender.selected) {
            [__self hiddenNavAlertView];
            if (_iSessionHandle.unReadMessagesArray.count>0) {
                [__self.iSessionHandle.unReadMessagesArray removeAllObjects];
            }
            [__self.chatViewNew setBadgeNumber:__self.iSessionHandle.unReadMessagesArray.count];
            
            // 解决录制问题 聊天窗口问题
            if (__self.iSessionHandle.localUser.role == TKUserType_Teacher && __self.iSessionHandle.isClassBegin == YES) {
                
                [__self.iSessionHandle sessionHandlePubMsg:@"ChatShow" ID:@"ChatShow" To:sTellNone Data:@{} Save:YES completion:^(NSError * _Nonnull error) {}];
            }
        }else{
            // 解决录制问题 聊天窗口问题
            if (__self.iSessionHandle.localUser.role == TKUserType_Teacher && __self.iSessionHandle.isClassBegin == YES) {
                [__self.iSessionHandle sessionHandleDelMsg:@"ChatShow" ID:@"ChatShow" To:sTellNone Data:@{} completion:nil];
            }
        }
    };
    //进教室的时候聊天窗口打开
    [self.chatViewNew hide:NO];
    
    [self.chatViewNew setUserRoleType:TKUserType_Student];
}
-(void)initVideoView{
    
    
    CGFloat tVideoX = ScreenW - _sStudentVideoViewWidth - (_viewX) - _whiteBoardLeftRightSpace;
//    CGFloat tVideoX = CGRectGetMaxX(_whiteboardBackView.frame);

    CGFloat tVideoY = self.navbarHeight + _whiteBoardTopBottomSpace;
    
    //老师
    {
        {
            self.iTeacherVideoView= ({
                
                TKCTVideoSmallView *tTeacherVideoView = [[TKCTVideoSmallView alloc]initWithFrame:CGRectMake(tVideoX, tVideoY, _sStudentVideoViewWidth, _sStudentVideoViewHeigh) aVideoRole:TKEVideoRoleTeacher];
                tTeacherVideoView.whiteBoardViewFrame = _iTKEduWhiteBoardView.frame;
                tTeacherVideoView.iVideoViewTag = -1;
                
                tTeacherVideoView;
                
            });
            
        }
        
    }
    
    [self.view addSubview:self.iTeacherVideoView];
    //学生
    {
        
        self.iOurVideoView= ({
            
            TKCTVideoSmallView *tOurVideoView = [[TKCTVideoSmallView alloc]initWithFrame:CGRectMake(tVideoX,CGRectGetMaxY(self.iTeacherVideoView.frame), _sStudentVideoViewWidth, _sStudentVideoViewHeigh) aVideoRole:TKEVideoRoleOur];
            
            tOurVideoView.whiteBoardViewFrame = _iTKEduWhiteBoardView.frame;
            tOurVideoView.iVideoViewTag = -2;
            
            tOurVideoView;
            
        });
        [self.view addSubview:self.iOurVideoView];
    }
    
    // 1v1 显示对方, 1vM 显示老师, (巡课 1v1学生 1vM老师)
    moveView = _iUserType == TKUserType_Student ? _iTeacherVideoView : _iOurVideoView;
}

-(void)initWhiteBoardView{
    
    
    CGFloat x		= _viewX + _whiteBoardLeftRightSpace;
    CGFloat y		= self.navbarHeight + _whiteBoardTopBottomSpace;
    CGFloat width	= ScreenW - _viewX - _sStudentVideoViewWidth  - 2 * _whiteBoardLeftRightSpace;
    CGFloat height	= 2 * _sStudentVideoViewHeigh;
    
    CGRect tFrame	= CGRectMake(x, y, width, height);

    // 白板背景图
    _whiteboardBackView = [[UIView alloc] initWithFrame:tFrame];
    
    tFrame = CGRectMake(0, 0, width, height);
    _iSessionHandle.whiteBoardManager.colourid = _iParamDic[@"colourid"];
    _iTKEduWhiteBoardView = [_iSessionHandle.whiteBoardManager createWhiteBoardWithFrame:tFrame
                                                                       loadComponentName:TKWBMainContentComponent
                                                                       loadFinishedBlock:^{
                                 
                                 [_iSessionHandle.whiteBoardManager sendCacheInformation:_iSessionHandle.msgList];
                             }];
    _iTKEduWhiteBoardView.backgroundColor = [[UIColor colorWithRed:7 / 255.0f green:1 / 255.0f blue:23 / 255.0f alpha:1] colorWithAlphaComponent:0.3f];
    _iSessionHandle.whiteboardView = _iTKEduWhiteBoardView;
    
    [_whiteboardBackView addSubview:_iTKEduWhiteBoardView];
    [self.backgroundImageView addSubview:_whiteboardBackView];
    
}
// 创建翻页工具
- (void)initWhiteBoardNativeTool
{
    _pageControl = [[TKNativeWBPageControl alloc] init];
    _pageControl.hidden = NO;
    _pageControl.whiteBoardControl  = self;
    _pageControl.mg_canDrag         = YES;
    _pageControl.mg_bounces         = NO;
    _pageControl.mg_isAdsorb        = NO;
   
    if (_iUserType != TKUserType_Teacher) {
        
        if (_roomJson.configuration.isHiddenPageFlip || !_roomJson.configuration.canPageTurningFlag)
        {
            _pageControl.disenablePaging    = YES;
        }
    }
    
    _whiteboardBackView.userInteractionEnabled = YES;
    [_whiteboardBackView addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_whiteboardBackView.mas_bottom).offset(0);
        make.centerX.equalTo(_whiteboardBackView.mas_centerX);
    }];
    
    [_pageControl setTotalPage:1 currentPage:1];
    
    tk_weakify(self);
    [_iSessionHandle.whiteBoardManager setPageControlBlock:^(int currentPage, int totalPage, BOOL showOnWeb) {
        [weakSelf.pageControl setTotalPage:totalPage currentPage:currentPage];
        weakSelf.pageControl.showZoomBtn = !showOnWeb;
    }];
    
    // 是否显示课件备注
    _pageControl.showMark = (_iUserType == TKUserType_Teacher && _roomJson.configuration.coursewareRemarkFlag) ? : NO;
    
    if (_pageControl.showMark) {
        
        [_iSessionHandle.whiteBoardManager setPageControlMarkBlock:^(NSDictionary * dict) {
            weakSelf.pageControl.remarkDict = dict;
        }];
    }
    
}


-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(whiteBoardFullScreen:) name:sChangeWebPageFullScreen object:nil];
    /** 1.先设置为外放 */
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    //    });
    /** 2.判断当前的输出源 */
    // [self routeChange:nil];
    
   
    [[UIApplication sharedApplication] addObserver:self forKeyPath:@"idleTimerDisabled" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapTable:)
                                                name:sTapTableNotification
                                              object:nil];
    
    //拍摄照片、选择照片上传
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhotos:)
                                                 name:sTakePhotosUploadNotification
                                               object:sTakePhotosUploadNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhotos:)
                                                 name:sChoosePhotosUploadNotification
                                               object:sChoosePhotosUploadNotification];
    
    //收到远端pubMsg消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomWhiteBoardOnRemotePubMsg:) name:TKWhiteBoardOnRemotePubMsgNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPageBeforeClass) name:sShowPageBeforeClass object:nil];
}

- (void)showPageBeforeClass
{
    [_pageControl resetBtnStates];
}

#pragma mark - fullScreen 白板全屏
-(void)whiteBoardFullScreen:(NSNotification*)aNotification{
    
    // 隐藏工具栏
    [self hiddenNavAlertView];
    
    bool isFull = [aNotification.object boolValue];
    
    //白板恢复时聊天界面收起状态
    //白板全屏隐藏
    self.chatViewNew.hidden = isFull;
    
    _iSessionHandle.iIsFullState = isFull;

    if (self.iMediaView && !self.iMediaView.hasVideo) {
        //全屏隐藏MP3
        self.iMediaView.hidden = isFull;
    }
    self.iOurVideoView.hidden		= isFull;
    self.iTeacherVideoView.hidden	= isFull;
    
    if (isFull) {
        
        _whiteboardBackView.frame	= CGRectMake(_viewX, 0, [TKUtil isiPhoneX]?ScreenW-44:ScreenW, ScreenH);
        _iTKEduWhiteBoardView.frame = CGRectMake(0, 0, _whiteboardBackView.width, _whiteboardBackView.height);

        [self.backgroundImageView bringSubviewToFront:self.whiteboardBackView];
        [self.iSessionHandle.whiteBoardManager refreshWhiteBoard];
        
    }else{

        [self.backgroundImageView sendSubviewToBack:self.whiteboardBackView];
        
        [self refreshUI];
    }
    
    [_navbarView hideAllButton:isFull];
}
- (void)restoreMp3ViewFrame
{
    if (!self.iMediaView.hasVideo) {
        
        // mp3 view 老师带有进度条 frame不同
        if (CGRectGetWidth(_iMediaView.frame) == CGRectGetHeight(_iMediaView.frame)) {
            self.iMediaView.x = CGRectGetMinX(self.view.frame) + 10;
            self.iMediaView.y = self.whiteboardBackView.y + 5;
        } else {
            //老师
            self.iMediaView.x = CGRectGetMinX(self.view.frame) + 10;
            self.iMediaView.y = self.whiteboardBackView.y + 5;
            
        }
    }
}

- (void) changeMp3ViewFrame {
    
    // mp3 view 老师带有进度条 frame不同
    if (CGRectGetWidth(_iMediaView.frame) == CGRectGetHeight(_iMediaView.frame)) {
        self.iMediaView.frame = CGRectMake(CGRectGetMinX(self.view.frame) + 10,
                                           CGRectGetMaxY(self.whiteboardBackView.frame) - CGRectGetHeight(_iMediaView.frame) - (IS_PAD ? 60 : 40),
                                           CGRectGetWidth(_iMediaView.frame),
                                           CGRectGetHeight(_iMediaView.frame));
    } else {
        //老师
        self.iMediaView.frame = CGRectMake(CGRectGetMinX(self.whiteboardBackView.frame) + (CGRectGetWidth(self.iTKEduWhiteBoardView.frame) - CGRectGetWidth(_iMediaView.frame)) / 2,
                                           CGRectGetMaxY(self.whiteboardBackView.frame) - CGRectGetHeight(_iMediaView.frame) - (IS_PAD ? 80 : 60),
                                           CGRectGetWidth(_iMediaView.frame),
                                           CGRectGetHeight(_iMediaView.frame));
    }
}

-(void)refreshUI{
    
    if (self.iPickerController) {
        return;
    }
    [self refreshWhiteBoard:YES];
    [self refreshVideoViewFrame];
}

- (void)refreshVideoViewFrame {
    
//    CGFloat tVideoX = ScreenW - _sStudentVideoViewWidth - ([TKUtil isiPhoneX] ? 44 : 0) - _whiteBoardLeftRightSpace;
    CGFloat tVideoX = CGRectGetMaxX(_whiteboardBackView.frame);
    CGFloat tVideoY = self.navbarHeight + _whiteBoardTopBottomSpace;

    //老师
    self.iTeacherVideoView.frame = CGRectMake(tVideoX, tVideoY, _sStudentVideoViewWidth, _sStudentVideoViewHeigh);
    //学生
    self.iOurVideoView.frame = CGRectMake(tVideoX,CGRectGetMaxY(self.iTeacherVideoView.frame), _sStudentVideoViewWidth, _sStudentVideoViewHeigh);
    
    // whiteboard
//    [self refreshUI];
    _whiteboardBackView.y      = _iTeacherVideoView.y;
}

- (void)calculateWhiteBoardVideoViewFrame {
    
    /*
     w h whiteboard 宽高    H W 可用屏幕 宽高  分辨率 dpi
     h = W * 3dpi / (3 + 2dpi)
     w = H / dpi
     */
    
    CGFloat useScWidth = ([TKUtil isiPhoneX] ? ScreenW - 44 : ScreenW);
    CGFloat useScHeight = ScreenH - self.navbarHeight - 2 * 10;

    CGFloat dpiHeight = useScWidth * 3 * self.iTKEduWhiteBoardDpi / (3 + 2 * self.iTKEduWhiteBoardDpi);
    CGFloat dpiWidth;
    
    if (dpiHeight <= useScHeight) {
        //
        dpiWidth = dpiHeight / self.iTKEduWhiteBoardDpi;
        _sStudentVideoViewWidth = useScWidth - dpiWidth;
        _sStudentVideoViewHeigh = dpiHeight / 2;
        _whiteBoardLeftRightSpace = 0;
        _whiteBoardTopBottomSpace = (useScHeight - dpiHeight) / 2 + 10;
    } else {
        //
        dpiHeight = useScHeight;
        dpiWidth  = dpiHeight / self.iTKEduWhiteBoardDpi;
        _sStudentVideoViewHeigh = dpiHeight / 2;
        _sStudentVideoViewWidth = _sStudentVideoViewHeigh / (3 / 4.0);
        _whiteBoardLeftRightSpace = (useScWidth - dpiWidth - _sStudentVideoViewWidth) / 2;
        _whiteBoardTopBottomSpace = 10;
    }
    
    _whiteboardBackView.width = useScWidth - _sStudentVideoViewWidth;
    _whiteboardBackView.height= _sStudentVideoViewHeigh * 2;
    
    _iTKEduWhiteBoardView.size = _whiteboardBackView.size;
    [[TKWhiteBoardManager shareInstance] refreshWhiteBoard];
    NSLog(@"ScreenW%@, _whiteboardBackView:%@, _iTKEduWhiteBoardView:%@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(_whiteboardBackView.frame), NSStringFromCGRect(_iTKEduWhiteBoardView.frame));
    //白板的实际宽，高
//    CGFloat whiteboardHeight = ScreenH - self.navbarHeight - 2 * 10;
//    CGFloat whiteboardWidth = whiteboardHeight / self.iTKEduWhiteBoardDpi;
//    _sStudentVideoViewHeigh = whiteboardHeight / 2;
//    _sStudentVideoViewWidth = _sStudentVideoViewHeigh / 0.75;
//
//
//    CGFloat width = ([TKUtil isiPhoneX] ? ScreenW - 44 : ScreenW);
//    _whiteBoardLeftRightSpace = (width - whiteboardWidth - _sStudentVideoViewWidth - 20)/2;
//    _whiteBoardTopBottomSpace = 10;
}



#pragma mark - 工具栏 点击事件
- (void)popView:(TKPopView *)popView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TKPopView dismissForView:self.view];
    
    if (indexPath.item == 0) {// 答题器
        
        NSString *msgID = [NSString stringWithFormat:@"Question_%@",_roomJson.roomid];
        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:@"Question"
                                                             ID:msgID
                                                             To:sTellAll
                                                           Data:@"{\"action\":\"open\"}"
                                                           Save:YES
                                                     completion:nil];
        
        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:@"AnswerDrag"
                                                             ID:@"AnswerDrag"
                                                             To:sTellAllExpectSender
                                                           Data: @"{\"percentLeft\":0.5,\"percentTop\":0,\"isDrag\":true}"
                                                           Save:YES
                                                     completion:nil];
        
    }else if (indexPath.item == 1) {// 转盘
        
        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:@"dial"
                                                             ID:@"dialMesg"
                                                             To:sTellAll
                                                           Data:@{@"rotationAngle":[NSString stringWithFormat:@"rotate(0deg)"],
                                                                  @"isShow":@"true"}
                                                           Save:YES
                                                     completion:nil];
        
    }else if (indexPath.item == 2) {// 计时器
  
        // 计时器
        NSArray *timerArray = @[@0,@5,@0,@0];
        
        NSDictionary *dataDic = @{
                                  @"isStatus":@NO,
                                  @"sutdentTimerArry":timerArray,
                                  @"isShow":@YES,
                                  @"isRestart":@NO
                                  };
        
        NSString *str = [TKUtil dictionaryToJSONString:dataDic];
        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sTimer ID:@"timerMesg" To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        
    }else if (indexPath.item == 3) {// 小白板
        
        //老师端点击小白板，prepare状态下老师直接显示
        [[TKRoomManager instance] pubMsg:@"BlackBoard_new"
                                   msgID:@"BlackBoard_new"
                                    toID:@"__all"
                                    data:@{@"blackBoardState" : @"_prepareing", @"currentTapKey" : @"blackBoardCommon", @"currentTapPage" : @(1)}
                                    save:YES
                           extensionData:@{@"associatedMsgID" : @"ClassBegin"}
                              completion:nil];
    }
}

- (void)popViewWasHidden:(TKPopView *)popView
{
    self.navbarView.toolBoxButton.selected = !self.navbarView.toolBoxButton.selected;
}

- (void)tapOnViewToHide
{
    if (self.listView) {
        [self.view addSubview:self.listView];
        self.navbarView.coursewareButton.selected = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.navbarView.coursewareButton.selected = NO;
        });
        [self.listView hidden];
        self.listView = nil;
    }
    if (self.userListView) {
        [self.view addSubview:self.userListView];
        self.navbarView.memberButton.selected = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.navbarView.memberButton.selected = NO;
        });
        [self.userListView hidden];
        self.userListView = nil;
    }
    
    [_dimView removeFromSuperview];
    _dimView = nil;
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (self.iMediaView) {
        [self.view bringSubviewToFront:self.iMediaView];
    }
    
    //fix bug:mp3挡住媒体库 花名册
    if (self.dimView) {
        [self.view bringSubviewToFront:self.dimView];
    }
    
    if (self.listView) {
        [self.view bringSubviewToFront:self.listView];
    }
    
    if (self.userListView) {
        [self.view bringSubviewToFront:self.userListView];
    }
    
    if (_iSessionHandle.isPlayback) {
        [self.view bringSubviewToFront:self.playbackMaskView];
    }
}

- (void)hiddenNavAlertView{
    
    // 隐藏弹框页
    [self hiddenNavBarViewActionView];
    // 隐藏工具箱
    [self controlTabbarToolBoxBtn:NO];
}

- (void) hiddenNavBarViewActionView {
    
    if (self.chatView) {
        [self.chatView hidden];
        self.navbarView.messageButton.selected = NO;
        self.chatView = nil;
    }
    
//    if (self.listView) {
//        [self.listView hidden];
//        self.navbarView.coursewareButton.selected = NO;
//        self.listView = nil;
//    }
//
//    if (self.userListView) {
//        [self.userListView hidden];
//        self.navbarView.memberButton.selected = NO;
//        self.userListView = nil;
//    }
    
    [self tapOnViewToHide];
}

- (void) controlTabbarToolBoxBtn:(BOOL)isSelected {
    
    if (isSelected == self.navbarView.toolBoxButton.selected) {
        return;
    }
    
    // 隐藏工具箱
    [_iSessionHandle.whiteBoardManager showToolbox:isSelected];
    self.navbarView.toolBoxButton.selected = isSelected;
}


-(void)refreshWhiteBoard:(BOOL)hasAnimate{
    
    if (_iSessionHandle.isPicInPic) {
        [self changeVideoFrame:NO];
    }
    
//    CGFloat whiteboardHeight = ScreenH - self.navbarHeight - 2 * 10;
//    _sStudentVideoViewHeigh = whiteboardHeight / 2;
//    _sStudentVideoViewWidth = _sStudentVideoViewHeigh / 0.75;
//
//    CGFloat x        = _viewX;
//    CGFloat y        = self.navbarHeight + 10;
//    CGFloat width    = ScreenW - _viewX - _sStudentVideoViewWidth - ([TKUtil isiPhoneX] ?33  : 0);
//    CGFloat height   = whiteboardHeight;
    
    CGFloat x        = _viewX + _whiteBoardLeftRightSpace;
    CGFloat y        = self.navbarHeight + _whiteBoardTopBottomSpace;
    CGFloat width    = ScreenW - _viewX - _sStudentVideoViewWidth  - 2 * _whiteBoardLeftRightSpace;
    CGFloat height    = 2 * _sStudentVideoViewHeigh;

    
    CGRect tFrame    = CGRectMake(x, y, width, height);
    
    CGRect iTKEduWhiteBoardViewFrame = CGRectMake(0, 0, width, height);
    
    if (hasAnimate) {
        [UIView animateWithDuration:0.1 animations:^{
            
            self.whiteboardBackView.frame = tFrame;
            self.iTKEduWhiteBoardView.frame = iTKEduWhiteBoardViewFrame;
            
        } completion:^(BOOL finished) {
             [_iSessionHandle.whiteBoardManager refreshWhiteBoard];
        }];
    }else{
        
        self.whiteboardBackView.frame = tFrame;
        self.iTKEduWhiteBoardView.frame = iTKEduWhiteBoardViewFrame;

        [_iSessionHandle.whiteBoardManager refreshWhiteBoard];
    }
    // MP3图标位置变化,但是MP4的位置不需要变化
    if (self.iMediaView && !self.iMediaView.hasVideo) {
        [self restoreMp3ViewFrame];
    }
}

- (void)createTimer {
    
    if (!_iCheckPlayVideotimer) {
        __weak typeof(self)weekSelf = self;
        _iCheckPlayVideotimer = [[TKTimer alloc]initWithTimeout:0.5 repeat:YES completion:^{
            __strong typeof(self)strongSelf = weekSelf;
            
            [strongSelf checkPlayVideo];
            
            
        } queue:dispatch_get_main_queue()];
        
        [_iCheckPlayVideotimer start];
        
        
    }
    
}

- (TKAnswerSheetView *)answerSheetForView:(UIView *)view
{
    TKAnswerSheetView *answerSheet = nil;
    view = _iSessionHandle.whiteBoardManager.contentView;
    
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[TKAnswerSheetView class]]) {
            answerSheet = (TKAnswerSheetView *)subview;
            [view bringSubviewToFront:answerSheet];
            return answerSheet;
        }
    }
    
    if (!answerSheet) {
        answerSheet = [[TKAnswerSheetView alloc] init];
        [view addSubview:answerSheet];
        [answerSheet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.centerY.equalTo(view.mas_centerY);
        }];
    }
    
    return answerSheet;
}

#pragma mark - 播放
-(void)playVideo:(TKRoomUser*)user {
    
//    [self.iSessionHandle delUserPlayAudioArray:user];
    
    TKCTVideoSmallView* viewToSee = nil;
    if (user.role == TKUserType_Teacher)
        viewToSee = self.iTeacherVideoView;
    
    else if ((_iRoomType == TKRoomTypeOneToOne && user.role == TKUserType_Student) ||(_iRoomType == TKRoomTypeOneToOne && user.role == TKUserType_Patrol)) {
        viewToSee = _iOurVideoView;
    }
    
    
    if (viewToSee && viewToSee.iRoomUser == nil) {
        
        [self myPlayVideo:user aVideoView:viewToSee completion:^(NSError *error) {
            
            if (!error) {
                [self.iPlayVideoViewDic setObject:viewToSee forKey:user.peerID];
                if (self.iSessionHandle.iIsFullState) {//如果文档处于全屏模式下则不进行刷新界面
                    return;
                }
                [self refreshUI];
            }
        }];
    }
}

-(void)unPlayVideo:(TKRoomUser *)user {
    
    TKCTVideoSmallView* viewToSee = nil;
    if (user.role == TKUserType_Teacher)
        viewToSee = self.iTeacherVideoView;
    
    else if (_iRoomType == TKRoomTypeOneToOne && user.role == TKUserType_Student) {
        viewToSee = _iOurVideoView;
    }
    
    
    
    if (viewToSee && viewToSee.iRoomUser != nil && [viewToSee.iRoomUser.peerID isEqualToString:user.peerID]) {
        
        __weak typeof(self)weekSelf = self;
        NSMutableDictionary *tPlayVideoViewDic = self.iPlayVideoViewDic;

        [self myUnPlayVideo:user aVideoView:viewToSee completion:^(NSError *error) {
            
            [tPlayVideoViewDic removeObjectForKey:user.peerID];
            
            __strong typeof(weekSelf) strongSelf =  weekSelf;
            
            
            if (!self.iSessionHandle.iIsFullState) {
                [strongSelf refreshUI];
            }
            
        }];
    }
}

-(void)myUnPlayVideo:(TKRoomUser *)aRoomUser aVideoView:(TKCTVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
    [self.iSessionHandle sessionHandleUnPlayVideo:aRoomUser.peerID completion:^(NSError *error) {
        
        //更新uiview
        [aVideoView clearVideoData];
        completion(error);
    }];
}
-(void)myPlayVideo:(TKRoomUser *)aRoomUser aVideoView:(TKCTVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
    
    [_iSessionHandle sessionHandlePlayVideo:aRoomUser.peerID renderType:(TKRenderMode_adaptive) window:aVideoView completion:^(NSError *error) {
        
        aVideoView.iPeerId        = aRoomUser.peerID;
        aVideoView.iRoomUser      = aRoomUser;
        //        if ([aRoomUser.peerID isEqualToString:_iSessionHandle.localUser.peerID]) {
        //            [aVideoView changeName:[NSString stringWithFormat:@"%@(%@)",aRoomUser.nickName,MTLocalized(@"Role.Me")]];
        //        }else if (aRoomUser.role == UserType_Teacher){
        //            [aVideoView changeName:[NSString stringWithFormat:@"%@(%@)",aRoomUser.nickName,MTLocalized(@"Role.Teacher")]];
        //        }else{
        [aVideoView changeName:aRoomUser.nickName];
        //        }
        
        //进入后台的提示
        BOOL isInBackGround = [aRoomUser.properties[sIsInBackGround] boolValue];
        
        [aVideoView endInBackGround:isInBackGround];
        
        TKLog(@"----play:%@  playerID:%@ ",aRoomUser.nickName, aVideoView.iPeerId);
        completion(error);
    }];
    
    
}

-(void)initTapGesTureRecognizer{
    UITapGestureRecognizer* tapTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTable:)];
    tapTableGesture.delegate = self;
    [self.backgroundImageView addGestureRecognizer:tapTableGesture];
}

-(void)leftButtonPress{
    if (_isQuiting) {return;}
    [self tapTable:nil];
    
    
    TKAlertView *alert = [[TKAlertView alloc]initForWarningWithTitle:MTLocalized(@"Prompt.prompt") contentText:MTLocalized(@"Prompt.Quite") leftTitle:MTLocalized(@"Prompt.Cancel") rightTitle:MTLocalized(@"Prompt.OK")];
    [alert show];
    alert.rightBlock = ^{
        _isQuiting = YES;
        [self prepareForLeave:YES];
    };
    alert.lelftBlock = ^{
        _isQuiting = NO;
    };
    
}

//如果是自己退出，则先掉leftroom。否则，直接退出。
-(void)prepareForLeave:(BOOL)aQuityourself
{
    [self tapTable:nil];
    [self.navbarView destory];
    self.navbarView = nil;
    [self.chatView dismissAlert];
    [self.chatViewNew hide:YES];
    [self.listView dismissAlert];
    
    [_iSessionHandle configureHUD:@"" aIsShow:NO];
    
    [self invalidateTimer];
    
#if TARGET_IPHONE_SIMULATOR
#else
    [[UIDevice currentDevice] setProximityMonitoringEnabled: NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
#endif
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    if ([UIApplication sharedApplication].statusBarHidden) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
#pragma clang diagnostic pop
        
    }
    
    
    if (aQuityourself) {
        [self unPlayVideo:_iSessionHandle.localUser];         // 进入教室不点击上课就退出，需要关闭自己视频
        [_iSessionHandle sessionHandleLeaveRoom:NO Completion:^(NSError * _Nonnull error) {
            TKLog(@"退出房间错误: %@", error);
        }];
    }

    [self dismissViewControllerAnimated:YES completion:^{
        // change openurl
        if (self.networkRecovered == NO) {
            [TKUtil showMessage:MTLocalized(@"Error.WaitingForNetwork")];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:sTKRoomViewControllerDisappear object:nil];
    }];
}

#pragma mark - TKEduSessionDelegate
- (void)sessionManagerDidOccuredWaring:(TKRoomWarningCode)code {
    
    if (_iSessionHandle.isPlayback == YES)
        return;
    
    switch (code) {
        case TKRoomWarning_RequestAccessForVideo_Failed:
        {
            TKAlertView *alert = [[TKAlertView alloc]initWithTitle:@"" contentText:MTLocalized(@"Prompt.NeedCamera") confirmTitle:MTLocalized(@"Prompt.Sure")];
            [alert show];
        }
            break;
        case TKRoomWarning_RequestAccessForAudio_Failed:
            
            break;
        case TKRoomWarning_ReConnectSocket_ServerChanged:{
            
            self.networkRecovered = NO;
            self.currentServer = nil;
            
            [_iSessionHandle configureHUD:MTLocalized(@"State.Reconnecting") aIsShow:YES];
            
            [_iSessionHandle configureDraw:false isSend:NO to:sTellAll peerID:_iSessionHandle.localUser.peerID];
            
            [_iSessionHandle clearAllClassData];
            
            [self quitClearData];
            break;
        }
        default:
            break;
    }
}

- (void)sessionManagerDidFailWithError:(NSError *)error {}
// 获取礼物数
- (void)sessionManagerGetGiftNumber:(void(^)())completion {
    
    // 老师断线重连不需要获取礼物
    if (_iSessionHandle.localUser.role == TKUserType_Teacher || _iSessionHandle.localUser.role == TKUserType_Assistant ||
        _iSessionHandle.isPlayback == YES) {
        if (completion) {
            completion();
        }
        return;
    }
    
    // 学生断线重连需要获取礼物
    [TKEduNetManager getGiftinfo:_roomJson.roomid
                  aParticipantId:_roomJson.thirdid
                           aHost:sHost
                           aPort:sPort
             aGetGifInfoComplete:^(id  _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int result = 0;
            result = [[response objectForKey:@"result"]intValue];
            if (!result || result == -1) {
                
                NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                int giftnumber = 0;
                for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                    if (![_roomJson.thirdid isEqualToString:@"0"] && _roomJson.thirdid) {
                        NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                        if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:_roomJson.thirdid]) {
                            giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
                            break;
                        }
                    }
                }
                
                self.iSessionHandle.localUser.properties[sGiftNumber] = @(giftnumber);
                
                if (completion) {
                    completion();
                }
                
                //[_iSessionHandle  joinEduClassRoomWithParam:_iParamDic aProperties:@{sGiftNumber:@(giftnumber)}];
            }
        });
        
    } aGetGifInfoError:^int(NSError * _Nullable aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion();
            }
            
            //[_iSessionHandle  joinEduClassRoomWithParam:_iParamDic aProperties:nil];
        });
        return 1;
    }];
    
}

//自己进入课堂
- (void)sessionManagerRoomJoined{

    //移动端本机时间不对的话，能进入教室但是看不见课件,需退出课堂
    //    [self judgeDeviceTime];
    //回放直接隐藏聊天界面
//    self.chatViewNew.hidden = _iSessionHandle.isPlayback;
    //根据角色类型选择隐藏聊天按钮
    [self.chatViewNew setUserRoleType:[TKEduSessionHandle shareInstance].localUser.role];
    
    self.isConnect = NO;
    [_iSessionHandle  sessionHandleSetDeviceOrientation:(UIDeviceOrientationLandscapeLeft)];
    
    if (_iUserType == TKUserType_Teacher) {
        [_iSessionHandle.msgList removeAllObjects];
    }
    
    
    // 主动获取奖杯数目
    [self getTrophyNumber];
    
    
    self.networkRecovered = YES;
    
    bool isConform = [TKUtil  deviceisConform];
    if (_iSessionHandle.localUser.role == TKUserType_Teacher) {
        if (!isConform) {
            NSString *str = [TKUtil dictionaryToJSONString:@{@"lowconsume":@YES, @"maxvideo":@(2)}];
            [_iSessionHandle sessionHandlePubMsg:sLowConsume ID:sLowConsume To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        } else {
            NSString *str = [TKUtil dictionaryToJSONString:@{@"lowconsume":@NO, @"maxvideo":_roomJson.maxvideo}];
            [_iSessionHandle sessionHandlePubMsg:sLowConsume ID:sLowConsume To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        }
    }
    
    
    // 低能耗老师进入一对多房间，进行提示
    if (!isConform && _iSessionHandle.localUser.role == TKUserType_Teacher && _iRoomType != TKRoomTypeOneToOne) {
        NSString *message = [NSString stringWithFormat:@"%@", MTLocalized(@"Prompt.devicetPrompt")];
        TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:_iSessionHandle.localUser.peerID
                                                                                   aTouid:_iSessionHandle.localUser.peerID
                                                                             iMessageType:TKMessageTypeMessage
                                                                                 aMessage:message
                                                                                aUserName:_iSessionHandle.localUser.nickName
                                                                                    aTime:[TKUtil currentTimeToSeconds]];
        [_iSessionHandle  addOrReplaceMessage:chatMessageModel];
    }
    
    // 如果断网之前在后台，回到前台时的时候需要发送回到前台的信令
    if ([_iSessionHandle.localUser.properties objectForKey:@"isInBackGround"] &&
        [[_iSessionHandle.localUser.properties objectForKey:@"isInBackGround"] boolValue] == YES &&
        _iSessionHandle.localUser.role == TKUserType_Student &&
        _iSessionHandle.roomMgr.inBackground == NO) {
        
        [_iSessionHandle  sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(NO) completion:nil];
    }
    
    _iSessionHandle.iIsJoined = YES;

    bool tIsTeacherOrAssis  = (_iSessionHandle.localUser.role ==TKUserType_Teacher || _iSessionHandle.localUser.role ==TKUserType_Assistant);
    //巡课不能翻页
    if (_iSessionHandle.localUser.role == TKUserType_Patrol || _iSessionHandle.isPlayback) {
        [_iSessionHandle configurePage:false isSend:NO to:sTellAll peerID:_iSessionHandle.localUser.peerID];
        
    }else {
        
        // 翻页权限根据配置项设置
        [_iSessionHandle configurePage:tIsTeacherOrAssis?true:_roomJson.configuration.canPageTurningFlag isSend:NO to:sTellAll peerID:_iSessionHandle.localUser.peerID];
    }
    TKLog(@"tlm-----myjoined 时间: %@", [TKUtil currentTimeToSeconds]);
#if TARGET_IPHONE_SIMULATOR
#else
    [[UIDevice currentDevice] setProximityMonitoringEnabled: NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
#endif
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    _iTKEduWhiteBoardView.hidden = NO;
    
    _iUserType       = _iSessionHandle.localUser.role;
    _iRoomType       = _roomJson.roomtype;
    _isQuiting       = NO;
    
    _iCurrentTime = [[NSDate date]timeIntervalSince1970];
    
    BOOL meHasVideo = _iSessionHandle.localUser.hasVideo;
    BOOL meHasAudio = _iSessionHandle.localUser.hasAudio;
   
    

    [_iSessionHandle configureHUD:@"" aIsShow:NO];
    if(!meHasVideo){
      
        TKLog(@"没有视频");
    }
    if(!meHasAudio){
        
        TKLog(@"没有音频");
    }
    
    
    [_iSessionHandle addUserStdntAndTchr:_iSessionHandle.localUser];
    [_iSessionHandle addUser:_iSessionHandle.localUser];
    
    [_iSessionHandle configureHUD:@"" aIsShow:NO];
    
    TKLog(@"tlm----- 课堂加载完成时间: %@", [TKUtil currentTimeToSeconds]);
    
    [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:_iSessionHandle.localUser.peerID Data:@"" Save:NO AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
    

    //是否是自动上课
    if (_roomJson.configuration.autoStartClassFlag == YES &&
        _iSessionHandle.isClassBegin == NO &&
        _iSessionHandle.localUser.role == TKUserType_Teacher) {
        
        // 只有手动点击上下课时传 userid roleid
        [TKEduNetManager classBeginStar:_roomJson.roomid companyid:_roomJson.companyid aHost:sHost aPort:sPort userid:nil roleid:nil aComplete:^int(id  _Nullable response) {
            
            
            
            NSString *str = [TKUtil dictionaryToJSONString:@{@"recordchat":@YES}];
            //[_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true completion:nil];
            [_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
            [_iSessionHandle configureHUD:@"" aIsShow:NO];
            
            return 0;
        }aNetError:^int(id  _Nullable response) {
            
            [_iSessionHandle configureHUD:@"" aIsShow:NO];
            
            return 0;
        }];
    }
    //如果是上课的状态则不进行推流的任何操作
    if(_iSessionHandle.isClassBegin && _iUserType != TKUserType_Teacher){
        return;
    }
    // 进入房间就可以播放自己的视频
    if (_iUserType != TKUserType_Patrol && _iSessionHandle.isPlayback == NO) {
        _isLocalPublish = false;
        if (_roomJson.configuration.beforeClassPubVideoFlag) {//发布视频
            [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKPublishStateBOTH) completion:^(NSError *error) {
                
            }];
        }else{//显示本地视频不发布
            _isLocalPublish = true;
            _iSessionHandle.localUser.publishState =(TKPublishState) TKPublishStateLocalNONE;
            [_iSessionHandle  addPublishUser:_iSessionHandle.localUser];

            [_iSessionHandle  configurePlayerRoute:NO isCancle:NO];
            [self playVideo:_iSessionHandle.localUser];
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:tkUserListNotification
                                                        object:nil];
}

//自己离开课堂
- (void)sessionManagerRoomLeft {
    TKLog(@"-----roomManagerRoomLeft");
    _isQuiting = NO;
    _iSessionHandle.iIsJoined = NO;
    [_iSessionHandle configurePlayerRoute:NO isCancle:YES];
    [_iSessionHandle delUserStdntAndTchr:_iSessionHandle.localUser];
    [_iSessionHandle delUser:_iSessionHandle.localUser];
    [_iSessionHandle configureHUD:@"" aIsShow:NO];

    //清理数据
    [self quitClearData];
    
    [_iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
    [_iSessionHandle.whiteBoardManager clearAllData];
    
    [_iSessionHandle clearAllClassData];
    
    _iSessionHandle.roomMgr = nil;
    [TKEduSessionHandle destroy];
    _iSessionHandle = nil;

    [self prepareForLeave:NO];
}

//用户进入
- (void)sessionManagerUserJoined:(TKRoomUser *)user InList:(BOOL)inList {
    
    TKLog(@"1------otherJoined:%@ peerID:%@",user.nickName,user.peerID);
    
    if (inList) {
        // 角色相同 踢人
        if ((_iSessionHandle.localUser.role == user.role && user.role == TKUserType_Teacher) ||
            (_iSessionHandle.localUser.role == user.role && user.role == TKUserType_Student)) {
            
            if (_iRoomType == TKRoomTypeOneToOne) {
                
                [_iSessionHandle sessionHandleEvictUser:user.peerID evictReason:nil completion:nil];
            }
        }
    }

    [_iSessionHandle addUser:user];
    
    //巡课不提示
    NSString *userRole;
    switch (user.role) {
        case TKUserType_Teacher:
            userRole = MTLocalized(@"Role.Teacher");
            break;
        case TKUserType_Student:
            userRole = MTLocalized(@"Role.Student");
            break;
        case TKUserType_Assistant:
            userRole = MTLocalized(@"Role.Assistant");
            break;
        default:
            break;
    }
    if (user.role !=TKUserType_Patrol) {
        TKChatMessageModel *tModel = [[TKChatMessageModel alloc]initWithFromid:0 aTouid:0 iMessageType:TKMessageTypeMessage aMessage:[NSString stringWithFormat:@"%@(%@)%@",user.nickName,userRole, MTLocalized(@"Action.EnterRoom")] aUserName:nil aTime:[TKUtil currentTime]];
        [_iSessionHandle addOrReplaceMessage:tModel];
    }
    BOOL tISpclUser = (user.role !=TKUserType_Student && user.role !=TKUserType_Teacher);
    if (tISpclUser) {
        [_iSessionHandle addSecialUser:user];
        
    }else{
        [_iSessionHandle addUserStdntAndTchr:user];
        
    }
    
    // 提示在后台的学生
    if (_iUserType == TKUserType_Teacher || _iUserType == TKUserType_Assistant || _iUserType == TKUserType_Patrol) {
        if ([user.properties objectForKey:sIsInBackGround] != nil &&
            [[user.properties objectForKey:sIsInBackGround] boolValue] == YES) {
            NSString *deviceType = [user.properties objectForKey:@"devicetype"];
            NSString *message = [NSString stringWithFormat:@"%@ (%@) %@", user.nickName, deviceType, MTLocalized(@"Prompt.HaveEnterBackground")];
            TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:user.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:TKMessageTypeMessage aMessage:message aUserName:user.nickName aTime:[TKUtil currentTime]];
            [_iSessionHandle  addOrReplaceMessage:chatMessageModel];
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:tkUserListNotification
                                                        object:nil];

}
//用户离开
- (void)sessionManagerUserLeft:(NSString *)peerId {
    
    TKRoomUser *user = [_iSessionHandle.roomMgr getRoomUserWithUId:peerId];
    
    if (!peerId || !user) {
        return;
    }
    
    [self unPlayVideo:user];
    
    BOOL tIsMe = [[NSString stringWithFormat:@"%@",user.peerID] isEqualToString:[NSString stringWithFormat:@"%@",_iSessionHandle.localUser.peerID]];
    
    NSString *userRole;
    switch (user.role) {
        case TKUserType_Teacher:
            userRole = MTLocalized(@"Role.Teacher");
            break;
        case TKUserType_Student:
            userRole = MTLocalized(@"Role.Student");
            break;
        case TKUserType_Assistant:
            userRole = MTLocalized(@"Role.Assistant");
            break;
        default:
            break;
    }
    
    if (user.role != TKUserType_Patrol && !tIsMe) {
        TKChatMessageModel *tModel = [[TKChatMessageModel alloc]initWithFromid:0 aTouid:0 iMessageType:TKMessageTypeMessage aMessage:[NSString stringWithFormat:@"%@(%@)%@",user.nickName,userRole, MTLocalized(@"Action.ExitRoom")] aUserName:nil aTime:[TKUtil currentTime]];
        [_iSessionHandle addOrReplaceMessage:tModel];
    }
    
    //去掉助教等特殊身份
    BOOL tISpclUser = (user.role !=TKUserType_Student && user.role !=TKUserType_Teacher);
    if (tISpclUser)
    {
        [_iSessionHandle delSecialUser:user];
    }
    else {
        [_iSessionHandle delUserStdntAndTchr:user];
    }
    [_iSessionHandle  delUser:user];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:tkUserListNotification
                                                        object:nil];
    
}
// 被踢
-(void) sessionManagerSelfEvicted:(NSDictionary *)reason{
    int rea;
    reason = [TKUtil processDictionaryIsNSNull:reason];
    
    if([[reason allKeys] containsObject:@"reason"]){
        rea = [reason[@"reason"] intValue];
    }else{
        rea = 0;
    }
    
    NSString * reaStr = rea==1?MTLocalized(@"Prompt.stuHasKicked"):MTLocalized(@"KickOut.Repeat");
    
    TKAlertView * alter = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.prompt") contentText:reaStr confirmTitle:MTLocalized(@"Prompt.OK")];
    [alter show];
    alter.rightBlock = ^{
        
        if (_iPickerController) {
            [_iPickerController dismissViewControllerAnimated:YES completion:^{
                
                //                [self showMessage:rea==1?MTLocalized(@"KickOut.SentOutClassroom"):MTLocalized(@"KickOut.Repeat")];
                _iPickerController = nil;
                //            [self prepareForLeave:NO];
                [self sessionManagerRoomLeft];
            }];
        }else{
            //            [self showMessage:rea==1?MTLocalized(@"KickOut.SentOutClassroom"):MTLocalized(@"KickOut.Repeat")];
            //        [self prepareForLeave:NO];
            
            [self sessionManagerRoomLeft];
            TKLog(@"---------SelfEvicted");
        }
    };
}

- (void)sessionManagerOnAudioVolumeWithPeerID:(NSString *)peeID volume:(int)volume{
    NSDictionary *dict = @{@"volume":@(volume)};
    [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"%@%@",sVolume,peeID] object:dict];
}

// 网络状态
- (void)sessionManagerOnAVStateWithPeerID:(NSString *)peerID state:(id)state {
    
    if (self.navbarView.netTipView && [peerID isEqualToString:_iSessionHandle.localUser.peerID]) {
        [self.navbarView.netTipView changeNetTipState:state];
    }
    
    if (self.netDetailView && [peerID isEqualToString:_iSessionHandle.localUser.peerID]) {
        [self.netDetailView changeDetailData:state];
    }
}

//观看视频
- (void)sessionManagerVideoStateWithUserID:(NSString *)peerID publishState:(TKMediaState)state{
    
    if (_iSessionHandle.isPicInPic && [peerID isEqualToString:moveView.iRoomUser.peerID]) {
        moveView.hidden = !state;
    }
    
    TKRoomUser *user = [_iSessionHandle.roomMgr getRoomUserWithUId:peerID];
    
    if (!user) {
        return;
    }
    
    if (state == TKMedia_Unpulished){
        
        if (user.publishState == TKUser_PublishState_NONE){
            
            [_iSessionHandle delePublishUser:user];
            
            if (!(_iSessionHandle.localUser.role == TKUserType_Teacher && _iSessionHandle.isClassBegin == NO && user.role == TKUserType_Teacher)) {
                // 老师发布的视频下课不取消播放
                [self unPlayVideo:user];
            }
        }
        
        
//        if ((_iSessionHandle.localUser.role == TKUserType_Teacher) && _iMvVideoDic) {
//            NSDictionary *tMvVideoDic = @{@"otherVideoStyle":_iMvVideoDic};
//            [_iSessionHandle  publishVideoDragWithDic:tMvVideoDic To:sTellAllExpectSender];
//        }
        
        if (_iSessionHandle.iHasPublishStd == NO && !_iSessionHandle.iIsFullState) {
            [self refreshUI];
        }
    }
    else {

        if (user.publishState > TKUser_PublishState_NONE &&
            ![self.iPlayVideoViewDic objectForKey:user.peerID] &&
            user.role != TKUserType_Patrol)
        {
            
            [self playVideo:user];
            
//            if (user.publishState == 1) {
//                [self.iSessionHandle addOrReplaceUserPlayAudioArray:user];
//            }
        }
        
        
    }
    
}

//播放音频
- (void)sessionManagerAudioStateWithUserID:(NSString *)peerID publishState:(TKMediaState)state {
    TKRoomUser *user = [_iSessionHandle.roomMgr getRoomUserWithUId:peerID];
    
    if (!user) {
        return;
    }
    if (state == TKMedia_Unpulished){
        
        if (user.publishState == TKUser_PublishState_NONE){
            
            [_iSessionHandle delePublishUser:user];
            
            if (!(_iSessionHandle.localUser.role == TKUserType_Teacher &&
                  _iSessionHandle.isClassBegin == NO &&
                  user.role == TKUserType_Teacher))
            {
                // 老师发布的视频下课不取消播放
                [self unPlayVideo:user];
            }
        }
        [_iSessionHandle sessionHandleUnPlayAudio:peerID completion:^(NSError * _Nonnull error) {
            
        }];
//
//        if ((_iSessionHandle.localUser.role == TKUserType_Teacher) && _iMvVideoDic) {
//            NSDictionary *tMvVideoDic = @{@"otherVideoStyle":_iMvVideoDic};
//            [_iSessionHandle  publishVideoDragWithDic:tMvVideoDic To:sTellAllExpectSender];
//        }
        
        if (_iSessionHandle.iHasPublishStd == NO && !_iSessionHandle.iIsFullState) {
            [self refreshUI];
        }
    }else {
        
        if (user.publishState > TKUser_PublishState_NONE &&
            ![self.iPlayVideoViewDic objectForKey:user.peerID] &&
            user.role != TKUserType_Patrol)
        {
            
            
            [self playVideo:user];
            // 播放音频
            [_iSessionHandle sessionHandlePlayAudio:user.peerID completion:nil];
        }
    }
    
    
}


//用户信息变化
- (void)sessionManagerUserChanged:(TKRoomUser *)user Properties:(NSDictionary*)properties fromId:(NSString *)fromId
{
    
    TKLog(@"sessionManagerUserChanged_%@", properties);
    
    NSInteger tGiftNumber = 0;
    if ([properties objectForKey:sGiftNumber]) {
        tGiftNumber = [[properties objectForKey:sGiftNumber]integerValue];
        
    }
    if ([properties objectForKey:sCandraw]){
        
        bool canDraw = [[properties objectForKey:sCandraw] boolValue];
        if ([_iSessionHandle.localUser.peerID isEqualToString:user.peerID] &&
            _iSessionHandle.localUser.role == TKUserType_Student) {
            
            if (_iSessionHandle.iIsCanDraw != canDraw) {
                
                [_iSessionHandle configureDraw:canDraw isSend:NO to:sTellAll peerID:user.peerID];
                // 翻页权限：1.有画笔权限，则可以翻页 2.无画笔权限根据配置项
                [_iSessionHandle configurePage:canDraw?true:_roomJson.configuration.canPageTurningFlag isSend:NO to:sTellAll peerID:user.peerID];
            }
        }
        if (canDraw) {
            if (user.role == TKUserType_Student && ![self.iPlayVideoViewDic objectForKey:user.peerID]) {
                [self playVideo:user];
            }
            if (_roomJson.configuration.canPageTurningFlag) {
                _pageControl.disenablePaging = NO;
            }
        }
        else {
            
            _pageControl.disenablePaging = YES;
        }
        
        // 授权画笔
        if(_iUserType == TKUserType_Teacher) {
            self.brushToolView.hidden    = NO;
        }
        else if(_iUserType == TKUserType_Patrol) { // 巡课
            self.brushToolView.hidden    = YES;
        }
        else {
            self.brushToolView.hidden = !canDraw;
            [self.brushToolView hideSelectorView];
            
        }
    }
    BOOL isRaiseHand = NO;
    if ([properties objectForKey:sRaisehand]) {
        //如果没做改变的话，就不变化
        
        isRaiseHand  = [[properties objectForKey:sRaisehand]boolValue];
        
        // 当用户状态发生变化，用户列表状态也要发生变化
        for (TKRoomUser *u in [_iSessionHandle  userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setValue:@(isRaiseHand) forKey:sRaisehand];
                
                break;
            }
        }
        // 如果是上课 并且花名册显示中 更新
        if ([_iSessionHandle  isClassBegin] && _userListView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:tkUserListNotification object:nil];
        }
    }
    
    if ([properties objectForKey:sPublishstate]) {
        
        PublishState tPublishState = (PublishState)[[properties objectForKey:sPublishstate] integerValue];

        if (tPublishState == TKPublishStateNONE ) {

            if ([self.iPlayVideoViewDic objectForKey:user.peerID]) {

                [self unPlayVideo:user];
            }
            
        }
        else if(user.role != TKUserType_Patrol && ![self.iPlayVideoViewDic objectForKey:user.peerID]) {
            [self playVideo:user];
        }
        
    }
    
    //更改上台后的举手按钮样式
    if (_iUserType == TKUserType_Student && [_iSessionHandle.localUser.peerID isEqualToString:user.peerID]) {
        
        if (isRaiseHand) {
            if (_iSessionHandle.localUser.publishState > 0) {
                [self.navbarView setHandButtonState:YES];
            }
        } else {
            [self.navbarView setHandButtonState:NO];
        }
        
        
    }
    
    if ([properties objectForKey:sDisableAudio]) {
        // 修改TKEduSessionHandle中iUserList中用户的属性
        for (TKRoomUser *u in [_iSessionHandle  userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                u.disableAudio = [[properties objectForKey:sDisableAudio] boolValue];
                
                
                break;
            }
        }
    }
    
    if ([properties objectForKey:sDisableVideo]) {
        for (TKRoomUser *u in [_iSessionHandle  userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                u.disableVideo = [[properties objectForKey:sDisableVideo] boolValue];
                
                
                break;
            }
        }
    }
    
    if ([properties objectForKey:sUdpState]) {
        NSInteger updState = [[properties objectForKey:sUdpState] integerValue];
        // 用户列表的属性进行变更
        for (TKRoomUser *u in [_iSessionHandle  userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setObject:@(updState) forKey:sUdpState];
                
                break;
            }
        }
    }
    
    if ([properties objectForKey:sServerName]) {
        
        if ([user.peerID isEqualToString:_iSessionHandle.localUser.peerID] &&
            ![fromId isEqualToString:_iSessionHandle.localUser.peerID]) {
            
            // 其他用户修改自己的服务器
            NSString *serverName = [NSString stringWithFormat:@"%@", [properties objectForKey:sServerName]];
            if (serverName != nil) {
                TKLog(@"助教协助修改了服务器地址:%@", serverName);
                [self changeServer:serverName];
                
                
                NSError *error = [NSError errorWithDomain:@"" code:TKRoomWarning_ReConnectSocket_ServerChanged userInfo:nil];
                
                [self sessionManagerDidFailWithError:error];
            }
            
        }
        
    }
    if ([properties objectForKey:sPrimaryColor]) {//画笔颜色
        
        // 当用户状态发生变化，用户列表状态也要发生变化
        for (TKRoomUser *u in [_iSessionHandle  userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setValue:[properties objectForKey:sPrimaryColor] forKey:sPrimaryColor];
                
                break;
            }
        }
    }
    
    if ([properties objectForKey:sDisablechat]) {
        
        if ([_iSessionHandle.localUser.peerID isEqualToString:user.peerID] ||
            _iSessionHandle.localUser.role == TKUserType_Patrol) {// 学生过多时，会导致巡课刷新多次而影响性能，后续需处理
            
            BOOL disableChat = [properties[sDisablechat] boolValue];
            NSDictionary *dict = @{@"isBanSpeak":@(disableChat)};
            [[NSNotificationCenter defaultCenter]postNotificationName:sEveryoneBanChat object:dict];
        }
    }

    NSDictionary *dict = @{sRaisehand:[properties objectForKey:sRaisehand]?[properties objectForKey:sRaisehand]:@(isRaiseHand),
                           sPublishstate:[properties objectForKey:sPublishstate]?[properties objectForKey:sPublishstate]:@(user.publishState),
                           sCandraw:[properties objectForKey:sCandraw]?[properties objectForKey:sCandraw]:@(user.canDraw),
                           sGiftNumber:@(tGiftNumber),
                           sDisableAudio:[properties objectForKey:sDisableAudio]?@([[properties objectForKey:sDisableAudio] boolValue]):@(user.disableAudio),
                           sDisableVideo:[properties objectForKey:sDisableVideo]?@([[properties objectForKey:sDisableVideo] boolValue]):@(user.disableVideo),
                           sPrimaryColor:[properties objectForKey:sPrimaryColor]?[properties objectForKey:sPrimaryColor]:[UIColor blackColor],
                           sFromId:fromId
                           };
    NSMutableDictionary *tDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    [tDic setValue:[properties objectForKey:sPrimaryColor] forKey:sPrimaryColor];
    [tDic setValue:user forKey:sUser];
    [self.navbarView buttonRefreshUI];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"%@%@",sRaisehand,user.peerID] object:tDic];
    [[NSNotificationCenter defaultCenter]postNotificationName:sDocListViewNotification object:nil];
    
    if ([properties objectForKey:sIsInBackGround]) {
        BOOL isInBackground = [[properties objectForKey:sIsInBackGround] boolValue];
        
        // 发送通知告诉视频控件后台状态
        NSDictionary *dict = @{sIsInBackGround:[properties objectForKey:sIsInBackGround]};
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@%@",sIsInBackGround,user.peerID] object:nil userInfo:dict];
        
        
        
        // 当用户发生前后台切换，用户列表状态也要发生变化
        for (TKRoomUser *u in [_iSessionHandle  userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setObject:[properties objectForKey:sIsInBackGround] forKey:sIsInBackGround];
                
                break;
            }
        }
        
        if (_iUserType == TKUserType_Teacher || _iUserType == TKUserType_Assistant || _iUserType == TKUserType_Patrol) {
            NSString *deviceType = [user.properties objectForKey:@"devicetype"];
            NSString *content;
            if (isInBackground) {
                content = MTLocalized(@"Prompt.HaveEnterBackground");
            } else {
                content = MTLocalized(@"Prompt.HaveBackForground");
            }
            NSString *message = [NSString stringWithFormat:@"%@ (%@) %@", user.nickName, deviceType, content];
            TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:user.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:TKMessageTypeMessage aMessage:message aUserName:user.nickName aTime:[TKUtil currentTime]];
            [_iSessionHandle  addOrReplaceMessage:chatMessageModel];
            if (_chatView) {
                [_chatView reloadData];
            }
            [self.chatViewNew reloadData];
        }
        
    }
    
    //yibo:可以实时看到人员离开进入消息，不知道要不要
    if (self.chatViewNew) {
        [self.chatViewNew reloadData];
    }
    
}


- (void)sessionManagerMessageReceived:(NSString *)message
                               fromID:(NSString *)peerID
                            extension:(NSDictionary *)extension{
    //当聊天视图存在的时候，显示聊天内容。否则存储在未读列表中
    if (_chatView || self.chatViewNew.leftBtn.selected) {
//        [_chatView messageReceived:message fromID:peerID extension:extension];
        [self.chatViewNew messageReceived:message fromID:peerID extension:extension];
        
    }else{
        
         /* {
         msg = "\U963f\U9053\U592b";
         type = 0;
         } */
        
        NSString *tDataString = [NSString stringWithFormat:@"%@",message];
        NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *type = [tDataDic objectForKey:@"type"];
        
        NSString *time = [tDataDic objectForKey:@"time"];
        NSString *msgtype = @"";
        if([[tDataDic allKeys]  containsObject: @"msgtype"]){
            msgtype = [tDataDic objectForKey:@"msgtype"];
        }
        // 问题信息不显示 0 聊天， 1 提问
        if ([type integerValue] != 0) {
            return;
        }
        //接收到pc端发送的图片不进行显示
        if ([msgtype isEqualToString:@"onlyimg"]) {
            return;
        }
        NSString *msg = [tDataDic objectForKey:@"msg"];
        
        NSString *tMyPeerId = _iSessionHandle.localUser.peerID;
        //自己发送的收不到
        if (!peerID) {
            peerID = _iSessionHandle.localUser.peerID;
        }
        BOOL isMe = [peerID isEqualToString:tMyPeerId];
        BOOL isTeacher = [extension[@"role"] intValue] == TKUserType_Teacher?YES:NO;
        
        TKMessageType tMessageType = (isMe)?TKMessageTypeMe:(isTeacher?TKMessageTypeTeacher:TKMessageTypeOtherUer);
        
        TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:extension[@"nickname"] aTime:time];
        
        [_iSessionHandle.unReadMessagesArray addObject:tChatMessageModel];
        
        
        [_iSessionHandle  addOrReplaceMessage:tChatMessageModel];
        [self.chatViewNew setBadgeNumber:_iSessionHandle.unReadMessagesArray.count];
        
    }
    
    [self.navbarView buttonRefreshUI];
}

//进入会议失败,重连
- (void)sessionManagerOnConnectionLost{
    self.networkRecovered = NO;
    self.currentServer = nil;
    
    [_iSessionHandle configureHUD:MTLocalized(@"State.Reconnecting") aIsShow:YES];
    [_iSessionHandle configureDraw:false isSend:NO to:sTellAll peerID:_iSessionHandle.localUser.peerID];
    
    [self.iSessionHandle clearAllClassData];
    
    if (self.isConnect) {
        return;
    }
    
    self.isConnect = YES;
    [_iSessionHandle.whiteBoardManager roomWhiteBoardOnDisconnect:nil];
    [self.iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
    
    
    
    [self clearVideoViewData:self.iTeacherVideoView];
    [self clearVideoViewData:self.iOurVideoView];
    
    [self.iPlayVideoViewDic removeAllObjects];
    _iSessionHandle.onPlatformNum = 0;
    
    // 播放的MP4前，先移除掉上一个MP4窗口
    
    _iSessionHandle.iCurrentMediaDocModel = nil;
    [_iSessionHandle.msgList removeAllObjects];
    if (self.iMediaView) {
        [self.iMediaView deleteWhiteBoard];
        [self.iMediaView removeFromSuperview];
        self.iMediaView = nil;
    }
    
    if (self.iScreenView) {
        [self.iScreenView removeFromSuperview];
        self.iScreenView = nil;
    }
    
    if (self.navbarView.netTipView) {
        [self.navbarView.netTipView changeDetailSignImage:NO];
    }
    if (self.netDetailView) {
        [self.netDetailView removeFromSuperview];
        self.netDetailView = nil;
    }
    
    //fix bug:全员奖励页面是显示在windows上的，如果网断了，退出教室，view还没消失
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSEnumerator *subviewsEnum = [window.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:NSClassFromString(@"TKTrophyView")]) {
            
            [subview removeFromSuperview];
        }
    }
    
    [_pageControl resetBtnStates];
    
    //上下课按钮设置为“上课”
    [_navbarView.beginAndEndClassButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
}

- (void)sessionManagerIceStatusChanged:(NSString*)state ofUser:(TKRoomUser *)user {
    TKLog(@"------IceStatusChanged:%@ nickName:%@",state,user.nickName);
}

// 共享屏幕
- (void)sessionManagerOnShareScreenState:(NSString *)peerId state:(TKMediaState)state{
    
    if (state) {
        if (self.iScreenView) {
            [self.iScreenView removeFromSuperview];
            self.iScreenView = nil;
        }
        
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        TKCTBaseMediaView *tScreenView = [[TKCTBaseMediaView alloc] initScreenShare:frame];
        _iScreenView = tScreenView;
        
        if (_iSessionHandle.isPlayback == YES) {
            [self.view insertSubview:_iScreenView belowSubview:self.playbackMaskView];
        } else {
            [self.view addSubview:_iScreenView];
        }
        
        [_iSessionHandle  sessionHandlePlayScreen:peerId renderType:TKRenderMode_fit window:_iScreenView completion:nil];
        
    }else{
        __weak typeof(self) wself = self;
        [_iSessionHandle  sessionHandleUnPlayScreen:peerId completion:^(NSError *error) {
            
            [wself.iScreenView removeFromSuperview];
            wself.iScreenView = nil;
        }];
    }
    
}

// 共享文件
- (void)sessionManagerOnShareFileState:(NSString *)peerId state:(TKMediaState)state extensionMessage:(NSDictionary *)message{
    if (state) {
        if (self.iFileView) {
            [self.iFileView removeFromSuperview];
            self.iFileView = nil;
        }
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        TKCTBaseMediaView *tFilmView = [[TKCTBaseMediaView alloc] initFileShare:frame];
        _iFileView = tFilmView;
        [_iFileView loadLoadingView];
        
        if (_iSessionHandle.isPlayback == YES) {
            [self.view insertSubview:_iFileView belowSubview:self.playbackMaskView];
        } else {
            [self.view addSubview:_iFileView];
        }
        [_iSessionHandle  sessionHandlePlayFile:peerId renderType:TKRenderMode_fit window:_iFileView completion:^(NSError *error) {
            if( _iSessionHandle.localUser.role != TKUserType_Teacher){
                [_iFileView loadWhiteBoard];
            }
        }];
        
    }else{
        //媒体流停止后需要删除sVideoWhiteboard
        [_iSessionHandle  sessionHandleDelMsg:sVideoWhiteboard ID:sVideoWhiteboard To:sTellAll Data:@{} completion:nil];
        
        __weak typeof(self) wself = self;
        
        [_iSessionHandle  sessionHandleUnPlayFile:peerId completion:^(NSError *error) {
            
            [wself.iFileView deleteWhiteBoard];
            [_iSessionHandle.msgList removeAllObjects];
            [wself.iFileView removeFromSuperview];
            wself.iFileView = nil;
            
        }];
    }
}

//相关信令 pub
- (void)sessionManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist{
    
    TKLog(@"sessionManagerOnRemoteMsg msgName:%@ msgID:%@ add:%d data:%@",msgName,msgID,add,data);

    //添加
    if ([msgName isEqualToString:sClassBegin]) {
        
        _iSessionHandle.isClassBegin = add;
        _iSessionHandle.whiteBoardManager.isBeginClass = add;
        [self.navbarView refreshUI:add];
        
        // 上课
        if (add) {
            
            [self onRemoteMsgWithClassBegin:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
            
        }
        // 下课
        else {
            [self onRemoteMsgWithClassEnd:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
            
        }
        [self.navbarView buttonRefreshUI];
        
    }
    // 更新时间
    else if ([msgName isEqualToString:sUpdateTime]) {
        
        [self onRemoteMsgWithUpdateTime:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        
    }
    //翻页
    else if ([msgName isEqualToString:sShowPage]) {
        [_pageControl resetBtnStates];
    }
    // 全体静音
    else if ([msgName isEqualToString:sMuteAudio]){
        
        [self onRemoteMsgWithMuteAudio:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        
    }
    // 流错误
    else if ([msgName isEqualToString:sStreamFailure]){
        
        [self onRemoteMsgWithStreamFailure:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        
    }
    // 更改服务器
    else if ([msgName isEqualToString:sChangeServerArea]) {
        
        
    }
    // 视频标注回调
    else if ([msgName isEqualToString:sVideoWhiteboard]) {
        
        [self onRemoteMsgWithVideoWhiteboard:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
    }
    // 全体禁言
    else if([msgName isEqualToString:sEveryoneBanChat]){
        
        [self onRemoteMsgWithEveryoneBanChat:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        
    }
    
    // 分屏回调 **** 与 全屏信令重名 屏蔽了全屏消息 ****
//    else if ([msgName isEqualToString:sWBFullScreen]){
    
//        [self onRemoteMsgWithVideoSplitScreen:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        
//    }
    
    // 音频教室
    else if([msgName isEqualToString:sOnlyAudioRoom]){
        _iSessionHandle.isOnlyAudioRoom = add;
        [[NSNotificationCenter defaultCenter] postNotificationName:sInOnlyAudioRoom object:nil];
    }
    // 白板全屏(同步)
    else if ([msgName isEqualToString: sWBFullScreen]) {
        
        [self onRemoteMsgWithWBFullScreen:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
    
    }
    // 工具箱 转盘
    else if([msgName isEqualToString:@"dial"] ){// || [msgName isEqualToString:@"DialDrag"] 不响应拖拽
        
        NSDictionary *dataDic = [self convertWithData:data];
        if (add) {
            if (!_dialView) {
                
                UIView * toolBV = _iSessionHandle.whiteBoardManager.contentView;
                _dialView = [[TKDialView alloc] init];
                [_dialView setAngle:dataDic[@"rotationAngle"]];
                [toolBV addSubview:_dialView];
                [_dialView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(toolBV.mas_centerX);
                    make.centerY.equalTo(toolBV.mas_centerY);
                }];
            }
            else if (![dataDic[@"isShow"] boolValue]) {// 开始旋转转盘
                
                [_dialView startWithAngle:dataDic[@"rotationAngle"]];
            }
        }
        else {
            [_dialView removeFromSuperview];
            _dialView = nil;
        }
        
    } else if ([msgName isEqualToString:@"Question"]){
        //答题器
        NSDictionary *dict = [self convertWithData:data];
        
        if ([[dict valueForKey:@"action"] isEqualToString:@"open"]) {
            
            if (_iSessionHandle.localUser.role != TKUserType_Student) {
                //老师
                TKAnswerSheetView *answerSheet = [self answerSheetForView:self.view];
                answerSheet.viewType = TKAnswerSheetType_Setup;
            }else{
                TKAnswerSheetView *answerSheet = [self answerSheetForView:self.view];
                [answerSheet removeFromSuperview];
            }
            
        }else if ([[dict valueForKey:@"action"] isEqualToString:@"start"]){
            
            [[TKAnswerSheetData shareInstance] resetData];
            
            if (_iSessionHandle.localUser.role != TKUserType_Student) {
                //老师
                TKAnswerSheetView *answerSheet = [self answerSheetForView:self.view];
                answerSheet.viewType = TKAnswerSheetType_Detail;
                answerSheet.dict = dict;
                [answerSheet showTimeWithTimeStamp:[NSString stringWithFormat:@"%lu",ts]];
                answerSheet.state = TKAnswerSheetState_Start;
                
            }else{
                //学生
                TKAnswerSheetView *answerSheet = [self answerSheetForView:self.view];
                answerSheet.viewType = TKAnswerSheetType_Submit;
                answerSheet.dict     = dict;
            }
            
            
        }else if ([[dict valueForKey:@"action"] isEqualToString:@"end"]){
            //答题结束 清理数据
//            [[TKAnswerSheetData shareInstance] resetData];
            [TKAnswerSheetData shareInstance].quesID  = [dict objectForKey:@"quesID"];

        }else if (!add){
            TKAnswerSheetView *answerSheet = [self answerSheetForView:self.view];
            [answerSheet removeFromSuperview];
            //答题结束 清理数据
//            [[TKAnswerSheetData shareInstance] resetData];
        }
        
        
    } else if ([msgName isEqualToString:@"PublishResult"]){
        //答题器公布的结果
        NSDictionary *dict = [self convertWithData:data];
        if (_iSessionHandle.localUser.role != TKUserType_Student) {
            //老师
            TKAnswerSheetView *answerSheet = [self answerSheetForView:self.view];
            answerSheet.viewType = TKAnswerSheetType_Detail;
            answerSheet.dict = dict;
            NSString *time = [NSString stringWithFormat:@"%lld",[dict[@"ansTime"] longLongValue]];
            [answerSheet showTimeWithTimeStamp:time];
            if ([[dict objectForKey:@"hasPub"] boolValue]) {
                answerSheet.state = TKAnswerSheetState_Release;
            }else{
                answerSheet.state = TKAnswerSheetState_End;
            }
            
        }else{
            //学生
            TKAnswerSheetView *answerSheet = [self answerSheetForView:self.view];
            answerSheet.viewType = TKAnswerSheetType_Detail;
            answerSheet.dict = dict;
            
            if ([[dict objectForKey:@"hasPub"] boolValue]) {
                answerSheet.state = TKAnswerSheetState_Release;
            }else{
                answerSheet.state = TKAnswerSheetState_End;
            }
        }
        if (!add){
            TKAnswerSheetView *answerSheet = [self answerSheetForView:self.view];
            [answerSheet removeFromSuperview];
            //答题结束 清理数据
            [[TKAnswerSheetData shareInstance] resetData];
        }
    }
    else if ([msgName isEqualToString:@"GetQuestionCount"]){
        //答题器获取答案
        //因为这个信令缺少 value 字段所以GetQuestionCount的数据只能通过通知获取 roomWhiteBoardOnRemotePubMsg
    }
    
    else if ([msgName isEqualToString:@"ChatShow"] && _iSessionHandle.isPlayback == YES) {
        if (add == YES) {
            [_chatView show];
        }
        else {
            [_chatView hidden];
        }
        [self.chatViewNew hide:!add];
        
    }
    else if([msgName isEqualToString:@"BlackBoard_new"] && add == YES){
        [self.chatViewNew hide:YES];
    }else if ([msgName isEqualToString:sTimer]) {// 计时器
        [self showTimerWithAdd:add andData:data receiveMsgTime:ts];
    }
   
    
}


#pragma mark - 计时器
- (void)showTimerWithAdd:(BOOL)add  andData:(NSObject *)data receiveMsgTime:(long)time {
    
    if (add) {
        
        NSDictionary *dataDic = @{};
        if ([data isKindOfClass:[NSString class]]) {
            NSString *tDataString = [NSString stringWithFormat:@"%@",data];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            dataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            dataDic = (NSDictionary *)data;
        }
        BOOL isStatus = [dataDic[@"isStatus"] boolValue];
        BOOL isRestart = [dataDic[@"isRestart"] boolValue];
        BOOL isShow = [dataDic[@"isShow"] boolValue];
        NSArray *timerArray = dataDic[@"sutdentTimerArry"];
        NSInteger minute = [[NSString stringWithFormat:@"%@%@", timerArray[0], timerArray[1]] integerValue];
        NSInteger second = [[NSString stringWithFormat:@"%@%@", timerArray[2], timerArray[3]] integerValue];
        
        if (_iSessionHandle.localUser.role == TKUserType_Teacher ||
            _iSessionHandle.localUser.role == TKUserType_Patrol)
        {
            
            if (!_timerView) {
                // 计时器
                
                UIView * toolBV = _iSessionHandle.whiteBoardManager.contentView;
                
                _timerView = [[TKTimerView alloc] init];
                [toolBV addSubview:_timerView];
                
                [_timerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(toolBV.mas_centerX);
                    make.centerY.equalTo(toolBV.mas_centerY);
                }];
            }
            
            
            if (isStatus && !isRestart) {// 开始倒计时
                [self.timerView startTimerCountdownWithMinute:(long)minute second:(long)second receiveMsgTime:time];
            }else if (!isStatus && !isRestart) {//暂停
                [self.timerView pauseTimerWithTimerArray:timerArray];
            }else if (!isStatus && isRestart) {// 重新开始
                [self.timerView stopCountDown];
            }
        }
        
        
        if (_iSessionHandle.localUser.role == TKUserType_Student && !isShow) {
            if (!_stuTimer) {
                
                UIView * contentView = _iSessionHandle.whiteBoardManager.contentView;
                _stuTimer = [[TKStuTimerView alloc] init];
                [contentView addSubview:_stuTimer];
                
                [_stuTimer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(contentView.mas_centerX);
                    make.centerY.equalTo(contentView.mas_centerY);
                }];
            }
            
            if (isStatus && !isRestart) {// 开始倒计时
                [self.stuTimer startCountdownWithMinute:(long)minute second:(long)second receiveMsgTime:time];
            }else if (!isStatus && !isRestart) {//暂停
                [self.stuTimer pauseTimerWithTimerArray:timerArray];
            }else if (!isStatus && isRestart) {// 重新开始
                [self.stuTimer startCountdownWithMinute:(long)minute second:(long)second receiveMsgTime:time];
                [self.stuTimer pauseTimerWithTimerArray:timerArray];
            }
        }
    }else {
        if (_stuTimer) {
            // 关闭y计时器
            [_stuTimer removeFromSuperview];
            _stuTimer = nil;
        }
        if (_timerView) {
            // 关闭y计时器
            [_timerView removeFromSuperview];
            _timerView = nil;
        }
    }
    
}

#pragma mark - 远程信令处理方法
- (void)onRemoteMsgWithClassBegin:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    [self invalidateClassCurrentTime];
    
    if (self.iOurVideoView.hidden) {
        self.iOurVideoView.hidden = NO;
    }
    
    if (self.iTeacherVideoView.hidden) {
        self.iTeacherVideoView.hidden = NO;
    }
    
    // 白板退出全屏
    [[NSNotificationCenter defaultCenter] postNotificationName:sChangeWebPageFullScreen object:@(NO)];

    _iSessionHandle.isClassBegin 	= YES;
    _iClassStartTime 				= ts;
    
    // 上课之前将自己的音视频关掉
    if (!_roomJson.configuration.autoOpenAudioAndVideoFlag && _isLocalPublish) {
        _iSessionHandle.localUser.publishState = TKUser_PublishState_NONE;
        [self unPlayVideo:_iSessionHandle.localUser];
    }
    
    if (_iUserType == TKUserType_Student && _roomJson.configuration.beforeClassPubVideoFlag &&!_roomJson.configuration.autoOpenAudioAndVideoFlag) {
        
        if (_iSessionHandle.localUser.publishState != TKUser_PublishState_NONE) {
            _isLocalPublish = false;
            [_iSessionHandle  sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKUser_PublishState_NONE) completion:nil];
        }
    }else if(_iUserType == TKUserType_Student && !_isLocalPublish &&!_roomJson.configuration.autoOpenAudioAndVideoFlag){
        if (_iSessionHandle.localUser.publishState != TKUser_PublishState_NONE) {
            _isLocalPublish = false;
            [_iSessionHandle  sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKUser_PublishState_NONE) completion:nil];
        }
    }
    
    if (_iSessionHandle.isPlayMedia && _iUserType == TKUserType_Teacher) {
        
        [_iSessionHandle  sessionHandleUnpublishMedia:nil];
        
    }
    
    if (_iUserType == TKUserType_Teacher && _iSessionHandle.isPlayback == NO) {
        
        if (_iSessionHandle.localUser.publishState != TKPublishStateBOTH) {
            _isLocalPublish = false;
            [_iSessionHandle  sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKPublishStateBOTH) completion:nil];
        }
    }
    
    if ((self.playbackMaskView.iProgressSlider.value < 0.01 && _iSessionHandle.isPlayback == YES && self.playbackMaskView.playButton.isSelected == YES) ||
        _iSessionHandle.isPlayback == NO) {
        [TKUtil showMessage:MTLocalized(@"Class.Begin")];
    }
    
    if (!_iSessionHandle.isPlayback && !_roomJson.configuration.beforeClassPubVideoFlag && _iSessionHandle.isPlayback == NO) {
        if (_iUserType==TKUserType_Teacher || (_iUserType==TKUserType_Student && _roomJson.configuration.autoOpenAudioAndVideoFlag)) {
            
            if (_iSessionHandle.localUser.publishState != TKPublishStateBOTH) {
                _isLocalPublish = false;
                [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKPublishStateBOTH) completion:^(NSError *error) {
                    
                }];
            }
            
        }
    }else if(_iUserType==TKUserType_Teacher && _roomJson.configuration.autoOpenAudioAndVideoFlag && _iSessionHandle.isPlayback == NO){
        if (_iSessionHandle.localUser.publishState != TKPublishStateBOTH) {
            _isLocalPublish = false;
            [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKPublishStateBOTH) completion:^(NSError *error) {
                
            }];
        }
    }else if(_iUserType == TKUserType_Student &&_roomJson.configuration.autoOpenAudioAndVideoFlag  && _iSessionHandle.isPlayback == NO){
        if (_iSessionHandle.localUser.publishState != TKPublishStateBOTH) {
            _isLocalPublish = false;
            [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKPublishStateBOTH) completion:^(NSError *error) {
                
            }];
        }
    }
    

    
    
    
    //  涂鸦权限:
    //	1. 1v1学生根据配置项设置
    //	2. 其他情况，没有涂鸦权限
    //	3. 非老师断线重连不可涂鸦。
    //  4. 发送:1 1v1 学生发送 2 学生发送，老师不发送
    
    //如果是1v1并且是学生角色
    BOOL tIsTeacherOrAssis  = _iUserType==TKUserType_Teacher || _iUserType == TKUserType_Assistant;
    BOOL isStdAndRoomOne	= _iRoomType == TKRoomTypeOneToOne && _iSessionHandle.localUser.role == TKUserType_Student;
    BOOL isCanDraw			= isStdAndRoomOne ? _roomJson.configuration.canDrawFlag : tIsTeacherOrAssis;
    [_iSessionHandle configureDraw:isCanDraw
                            isSend:isStdAndRoomOne ? YES : !tIsTeacherOrAssis
                                to:sTellAll
                            peerID:_iSessionHandle.localUser.peerID];
    self.brushToolView.hidden = !isCanDraw;
    
    //如果是学生需要重新设置翻页
    [_iSessionHandle configurePage:_roomJson.configuration.canDrawFlag?true:_roomJson.configuration.canPageTurningFlag isSend:NO to:sTellAll peerID:isStdAndRoomOne?_iSessionHandle.localUser.peerID:@""];
    
    
    [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:_iSessionHandle.localUser.peerID Data:@"" Save:false AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:^(NSError *error) {
        
    }];
    
    [self startClassBeginTimer];
    
    [self refreshUI];
}

- (void)onRemoteMsgWithClassEnd:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
	
    //重置距离下课还有5分钟的提醒项
    _isRemindClassEnd = NO;
    
    if (self.iOurVideoView.hidden) {
        self.iOurVideoView.hidden = NO;
    }
    
    if (self.iTeacherVideoView.hidden) {
        self.iTeacherVideoView.hidden = NO;
    }
    
    //未到下课时间： 老师点下课 —> 下课后不离开教室 _iSessionHandle.roomMgr.forbidLeaveClassFlag->下课时间到，课程结束，一律离开
    if (_roomJson.configuration.forbidLeaveClassFlag &&  _roomJson.configuration.endClassTimeFlag) {
        _iClassCurrentTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                               target:self
                                                             selector:@selector(onClassCurrentTimer)
                                                             userInfo:nil
                                                              repeats:YES];
        [_iClassCurrentTimer setFireDate:[NSDate date]];
    }
    
    //下课
    _iSessionHandle.isClassBegin = NO;
    [TKUtil showMessage:MTLocalized(@"Class.Over")];
    
    // 隐藏授权 画笔 相机按钮
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TKTabbarViewHideICON" object:@{sCandraw: @(NO)}];
    
    BOOL isStdAndRoomOne = ((TKRoomType)_roomJson.roomtype  == TKRoomTypeOneToOne && _iSessionHandle.localUser.role == TKUserType_Student);
    //liyanyan
    //             [_iSessionHandle.iBoardHandle setAddPagePermission:false];
    bool tIsTeacherOrAssis  = (_iSessionHandle.localUser.role ==TKUserType_Teacher || _iSessionHandle.localUser.role == TKUserType_Assistant);
    [_iSessionHandle  configureDraw:isStdAndRoomOne?_roomJson.configuration.canDrawFlag:false isSend:isStdAndRoomOne?YES:!tIsTeacherOrAssis to:sTellAll peerID:_iSessionHandle.localUser.peerID];
    //BOOL isStd = (_iSessionHandle.localUser.role == UserType_Student);
    //如果是1v1学生需要重新设置翻页
    [_iSessionHandle configurePage:_roomJson.configuration.canPageTurningFlag isSend:NO to:sTellAll peerID:isStdAndRoomOne?_iSessionHandle.localUser.peerID:@""];
    
    
    [self refreshUI];
    [self invalidateClassBeginTime];
    
    [self tapTable:nil];
    if (_iSessionHandle.localUser.role ==TKUserType_Teacher) {
        /*删除所有信令的消息，从服务器上*/
//        if(!_roomJson.configuration.forbidLeaveClassFlag){
            [_iSessionHandle sessionHandleDelMsg:sAllAll ID:sAllAll To:sTellNone Data:@{} completion:nil];
//        }
    }
    
    // 非老师身份下课后退出教室
    if (_iUserType != TKUserType_Teacher && !_roomJson.configuration.forbidLeaveClassFlag) {//下课是否允许离开教室
        
        [self prepareForLeave:YES];
        
    }else if(_iUserType == TKUserType_Teacher && !_roomJson.configuration.forbidLeaveClassFlag){
        if(!_roomJson.configuration.beforeClassPubVideoFlag){
            _isLocalPublish = false;
            [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID  Publish:TKPublishStateNONE completion:^(NSError *error) {
            }];
        }
        
    }
}

- (void)onRemoteMsgWithUpdateTime:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
	
    if (add) {
        //防止ts是毫秒单位
        if (ts/10000000000 > 0) {
            ts = ts / 1000;
        }
        
        _iServiceTime = ts;
        _iLocalTime   = _iServiceTime - _iClassStartTime;
        
        _iHowMuchTimeServerFasterThenMe = ts - [[NSDate date] timeIntervalSince1970];
        
        if (![_iClassTimetimer isValid]) {
            _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(onClassTimer)
                                                              userInfo:nil
                                                               repeats:YES];
            [_iClassTimetimer setFireDate:[NSDate date]];
            
        }
    }
}

- (void)onRemoteMsgWithMuteAudio:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    int tPublishState = _iSessionHandle.localUser.publishState;
    NSString *tPeerId = _iSessionHandle.localUser.peerID;
    _iSessionHandle.isMuteAudio = add ?true:false;
    _isLocalPublish = false;
    if (tPublishState != TKPublishStateVIDEOONLY) {
        [_iSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:(tPublishState)+(_iSessionHandle.isMuteAudio ?(-TKPublishStateAUDIOONLY):(TKPublishStateAUDIOONLY)) completion:^(NSError *error) {
            
        }];
    }else{
        [_iSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:(_iSessionHandle.isMuteAudio ?(TKPublishStateNONE):(TKPublishStateAUDIOONLY)) completion:^(NSError *error) {
            
        }];
    }
}

- (void)onRemoteMsgWithStreamFailure:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    // 收到用户发布失败的消息
    NSDictionary *tDataDic = @{};
    if ([data isKindOfClass:[NSString class]]) {
        NSString *tDataString = [NSString stringWithFormat:@"%@",data];
        NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
        tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        tDataDic = (NSDictionary *)data;
    }
    
    NSString *tPeerId = [tDataDic objectForKey:@"studentId"];
    NSInteger failureType = [tDataDic objectForKey:@"failuretype"]?[[tDataDic objectForKey:@"failuretype"] integerValue] : 0;
    
    // 如果这个发布失败的用户是自己点击上台的，需要对自己进行上台失败错误原因进行提示。
    //        if ([[[_iSessionHandle pendingUserDic] allKeys] containsObject:tPeerId]) {
    if ([_iSessionHandle getUserWithPeerId:tPeerId].role == TKUserType_Teacher){
        
        switch (failureType) {
            case 1:
                [TKUtil showMessage:MTLocalized(@"Prompt.StudentUdpOnStageError")];
                break;
                
            case 2:
                [TKUtil showMessage:MTLocalized(@"Prompt.StudentTcpError")];
                break;
                
            case 3:
                [TKUtil showMessage:MTLocalized(@"Prompt.exceeds")];
                break;
                
            case 4:
            {
                
                [TKUtil showMessage:[NSString stringWithFormat:@"%@%@",[_iSessionHandle  localUser].nickName,MTLocalized(@"Prompt.BackgroundCouldNotOnStage")]];//拼接上用户名
                break;
            }
            case 5:
                [TKUtil showMessage:MTLocalized(@"Prompt.StudentUdpError")];
                break;
                
            default:
                break;
        }
    }
}

- (void)onRemoteMsgWithVideoSplitScreen:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    //白板全屏状态下不执行分屏回调
    if (_iSessionHandle.iIsFullState) {
        return;
    }

    
//    [self tapTable:nil];
    NSDictionary *tDataDic = [self convertWithData:data];

    if (![tDataDic objectForKey:@"isTeacher"]) {
        return;
    }
    
    if (add) {
        [self.view addSubview:self.splitScreenView];
        
        //分屏视频 按4 ； 3显示
        CGRect frame ;
        CGFloat width  = self.splitScreenView.frame.size.width;
        CGFloat height = self.splitScreenView.frame.size.height;

        if (height / width >= 3.0 / 4) {
            frame = CGRectMake(0, (height - width * 3.0 / 4)/2, width, width * 3.0 / 4);
        }else{
            frame = CGRectMake((width - height * 4.0 / 3)/2, 0, height * 4.0 / 3, height);
        }
        
        self.iTeacherVideoView.frame = frame;
        [self.view bringSubviewToFront:self.iTeacherVideoView];
        
    }else{
        [self.splitScreenView removeFromSuperview];
        self.splitScreenView = nil;
        
//        CGFloat tVideoX = ScreenW - _sStudentVideoViewWidth - (_viewX) - _whiteBoardLeftRightSpace;
        CGFloat tVideoX = CGRectGetMaxX(_whiteboardBackView.frame);
        CGFloat tVideoY = self.navbarHeight + _whiteBoardTopBottomSpace;
        self.iTeacherVideoView.frame = CGRectMake(tVideoX, tVideoY, _sStudentVideoViewWidth, _sStudentVideoViewHeigh);
    }
}


- (void)onRemoteMsgWithVideoWhiteboard:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {

    _addVideoBoard = add;
    
    if (add) {
        if (_iMediaView) {//媒体
            
            [_iMediaView loadWhiteBoard];
            
        }
        if (_iFileView) {//电影
            
            [_iFileView loadWhiteBoard];
        }
    }else{
        if (_iMediaView){//媒体
            [_iSessionHandle.msgList removeAllObjects];
            
            [_iMediaView hiddenVideoWhiteBoard];
        }
        if (_iFileView){
            [_iSessionHandle.msgList removeAllObjects];
            [_iFileView hiddenVideoWhiteBoard];
        }
    }
}

- (void)onRemoteMsgWithEveryoneBanChat:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {

    _iSessionHandle.isAllShutUp = add;
    if (add && inlist && _iSessionHandle.localUser.role == TKUserType_Student) {//如果是全体禁言并且后进入课堂
        
        [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sDisablechat Value:@(true) completion:nil];
        
    }
    
    NSMutableDictionary *tDic = [NSMutableDictionary dictionary];
    [tDic setValue:@(add) forKey:@"isBanSpeak"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:sEveryoneBanChat object:tDic];
    
    TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:nil aTouid:nil iMessageType:TKMessageTypeMessage aMessage:add?MTLocalized(@"Prompt.BanChatInView"):MTLocalized(@"Prompt.CancelBanChatInView") aUserName:_iSessionHandle.localUser.nickName aTime:[TKUtil currentTime]];
    
    [_iSessionHandle  addOrReplaceMessage:chatMessageModel];
    
    if (_chatView) {
        [_chatView reloadData];
    }
    
    [self.chatViewNew reloadData];
}

- (void)onRemoteMsgWithWBFullScreen:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    if (_roomJson.configuration.coursewareFullSynchronize) {
    
        /* stream_video 不处理 */
        NSDictionary *dic = [self convertWithData:data];
        
        if ([dic[@"fullScreenType"] isEqualToString:@"courseware_file"]) {
            
            _pageControl.fullScreen.selected = isRemoteFullScreen = add;
            [[NSNotificationCenter defaultCenter] postNotificationName:sChangeWebPageFullScreen object:@(add)];
            [self changeVideoFrame:add];
            
        } else if ([dic[@"fullScreenType"] isEqualToString:@"stream_media"]) {
            
            [self changeVideoFrame:add];
        }
    }
}

// 画中画
- (void)changeVideoFrame:(BOOL)isFull {
    
    if (!moveView) return;
    if (isFull == _iSessionHandle.isPicInPic) return;//相同消息不执行
    
    _iSessionHandle.isPicInPic = isFull;
    if (isFull) {
        
        // 缓存尺寸
        videoOriginFrame = moveView.frame;
        
        moveView.hidden = NO;
        moveView.x = ScreenW - moveView.width - 5.;
        
//        if (_iSessionHandle.isPlayMedia) {
            //如果在播放音频 那么需要移动位置
//            moveView.y = ScreenH - moveView.height - 100;

            moveView.frame = CGRectMake(ScreenW - 0.7*CGRectGetWidth(moveView.frame), ScreenH - 0.7*CGRectGetHeight(moveView.frame), 0.7*CGRectGetWidth(moveView.frame), 0.7*CGRectGetHeight(moveView.frame));
            
//        }else{
//            moveView.y = ScreenH - moveView.height - 5;
//        }
        
        [[UIApplication sharedApplication].keyWindow addSubview: moveView];
        
        
        [moveView addGestureRecognizer:_longPressGesture];
        
        if (!moveView.iRoomUser.hasVideo ||
            (moveView.iRoomUser.publishState != TKUser_PublishState_BOTH && moveView.iRoomUser.publishState != TKUser_PublishState_VIDEOONLY) ||
            _iSessionHandle.isOnlyAudioRoom) {
            // 无视频不显示画中画
            moveView.hidden = YES;
        }
        
    } else {
        
        moveView.hidden = NO;
        [moveView removeFromSuperview];
        
        moveView.frame = videoOriginFrame;
        [self.view addSubview: moveView];
        
        [moveView removeGestureRecognizer:_longPressGesture];
        
        if (self.iMediaView) {
            [self.backgroundImageView bringSubviewToFront:self.iMediaView];
        }
    }
    
    [_navbarView hideAllButton:isFull];
    // 隐藏小视频上的按钮 屏蔽操作
    [moveView maskViewChangeForPicInPicWithisShow:isFull];
}
#pragma mark - 设备检测
- (void)noCamera {
    
    TKAlertView *alert = [[TKAlertView alloc]initWithTitle:@"" contentText:MTLocalized(@"Prompt.NeedCamera") confirmTitle:MTLocalized(@"Prompt.Sure")];
    [alert show];
}

- (void)noMicrophone {
    TKAlertView *alert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.NeedMicrophone.Title") contentText:MTLocalized(@"Prompt.NeedMicrophone") confirmTitle:MTLocalized(@"Prompt.Sure")];
    [alert show];
}

- (void)noCameraAndNoMicrophone {
    
    TKAlertView *alert = [[TKAlertView alloc]initWithTitle:@"" contentText:MTLocalized(@"Prompt.NeedCameraNeedMicrophone") confirmTitle:MTLocalized(@"Prompt.Sure")];
    [alert show];
}


#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"TKTextViewInternal"] ||  [NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"] ||
        [touch.view.superview isKindOfClass:[UICollectionViewCell class]])
    {
        return NO;
    }
    else
    {
        
        [self tapTable:nil];
        return !_iSessionHandle.iIsCanDraw;
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

- (void)tapTable:(UIGestureRecognizer *)gesture
{
    [[NSNotificationCenter defaultCenter]postNotificationName:stouchMainPageNotification object:nil];

    [_iTeacherVideoView hidePopMenu];
    [_iOurVideoView hidePopMenu];
}
// 小视频本地移动
- (void)fullScreenVideoLongPressClick:(UIGestureRecognizer *)longGes {
    
    TKCTVideoSmallView * currentVedioView = (TKCTVideoSmallView *)longGes.view;
    
    if (UIGestureRecognizerStateBegan == longGes.state) {
        self.iStrtCrtVideoViewP  = [longGes locationInView:currentVedioView];
    }
    
    if (UIGestureRecognizerStateChanged == longGes.state) {
        //为了与老代码保持一致，在手势变化的时候判断
        //按道理来讲在手势结束后判断是否超出范围最为合理
        CGRect videoViewFrame = currentVedioView.frame;
        
        CGPoint point = [longGes locationInView:self.view];
        videoViewFrame.origin.x = point.x - self.iStrtCrtVideoViewP.x;
        videoViewFrame.origin.y = point.y - self.iStrtCrtVideoViewP.y;
        
        if (CGRectGetMinX(videoViewFrame) < CGRectGetMinX(self.view.frame)) {
            videoViewFrame.origin.x = 0;
        }
        
        if (CGRectGetMaxX(videoViewFrame) > CGRectGetMaxX(self.view.frame)) {
            videoViewFrame.origin.x =  CGRectGetMaxX(self.view.frame) - CGRectGetWidth(currentVedioView.frame);
        }
        
        if (CGRectGetMinY(videoViewFrame) < CGRectGetMinY(self.view.frame)) {
            videoViewFrame.origin.y = 0;
        }
        
        if (CGRectGetMaxY(videoViewFrame) > CGRectGetMaxY(self.view.frame)) {
            videoViewFrame.origin.y = CGRectGetMaxY(self.view.frame) - CGRectGetHeight(currentVedioView.frame);
        }
        
        currentVedioView.frame = videoViewFrame;
    }
}


#pragma mark - 计时器
-(void)checkPlayVideo{

    BOOL tHaveRaiseHand = NO;
    BOOL tIsMuteAudioState = YES;
    
    for (TKRoomUser *usr in [_iSessionHandle userStdntAndTchrArray]) {
        BOOL tBool = [[usr.properties objectForKey:@"raisehand"]boolValue];
        if (tBool && !tHaveRaiseHand) {
            tHaveRaiseHand = YES;
        }
        if ((usr.publishState == TKPublishStateAUDIOONLY || usr.publishState == TKPublishStateBOTH) &&usr.role != TKUserType_Teacher && tIsMuteAudioState) {
            
            tIsMuteAudioState = NO;
        }
        
    }
    
    if (_iUserType == TKUserType_Teacher) {
        _iSessionHandle.isMuteAudio 	= tIsMuteAudioState;
        _iSessionHandle.isunMuteAudio 	= !tIsMuteAudioState;
    }
}


- (void)onClassCurrentTimer{
    
    if(!_iHowMuchTimeServerFasterThenMe)
        return;

    _iCurrentTime = [[NSDate date]timeIntervalSince1970] + _iHowMuchTimeServerFasterThenMe;
    
    NSTimeInterval interval = _roomJson.endtime -_iCurrentTime;
    NSInteger time = interval;
    //（1）未到下课时间： 老师点下课 —> 下课后不离开教室forbidLeaveClassFlag—>提前5分钟给出提示语（老师、助教）—>下课时间到，课程结束，一律离开
    if( !_iSessionHandle.isClassBegin &&
       _roomJson.configuration.forbidLeaveClassFlag){
        
        //距下课不足5min点击下课后给提示"X分钟后课堂结束，请合理安排时间哦".  只需要提示一次！！！
        if (time < 300 && _iSessionHandle.localUser.role == TKUserType_Teacher) {
            if (!objc_getAssociatedObject(_iClassCurrentTimer, @selector(onClassCurrentTimer))) {
                int minuts = (int)time / 60;
                [TKUtil showMessage:[NSString stringWithFormat:@"%d%@",minuts,MTLocalized(@"Prompt.ClassEndTime")]];
                objc_setAssociatedObject(_iClassCurrentTimer, @selector(onClassCurrentTimer), @"showOnce", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        
        if (time==300 && _iSessionHandle.localUser.role == TKUserType_Teacher) {
            [TKUtil showMessage:[NSString stringWithFormat:@"5%@",MTLocalized(@"Prompt.ClassEndTime")]];
        }
        if (time<=0) {
            [TKUtil showMessage:MTLocalized(@"Prompt.ClassEnd")];
            [self prepareForLeave:YES];
        }
    }
}

-(void)onClassTimer {
    
    //此处主要用于检测上课过程中进入后台后无法返回前台的状况
    BOOL isBackground = [_iSessionHandle.roomMgr.localUser.properties[sIsInBackGround] boolValue];
    if(([UIApplication sharedApplication].applicationState == UIApplicationStateActive) && isBackground){
        [_iSessionHandle  sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(NO) completion:nil];
        _iSessionHandle.roomMgr.inBackground = NO;
    }
    
    if(!_iHowMuchTimeServerFasterThenMe)
        return;
    
    _iCurrentTime = [[NSDate date]timeIntervalSince1970] + _iHowMuchTimeServerFasterThenMe;
    
    if ( _roomJson.configuration.endClassTimeFlag) {
        
        //fix bug:TALK-6798 回放会导致退出教室
        //如果是回放 结束时间要比当前时间小
        if (_iSessionHandle.isPlayback) {
            return;
        }
        
        NSTimeInterval interval = _roomJson.endtime -_iCurrentTime;
        NSInteger time = interval;
        //(2)未到下课时间： 老师未点下课->下课时间到->课程结束，一律离开
        //(3)到下课时间->提前5分钟给出提示语（老师，助教）->课程结束，一律离开
        if ((time <=300 && time > 0)
            && !_isRemindClassEnd) {
            //设置20秒的容差
            _isRemindClassEnd = YES;
            
            int ratio = (int)(time/60);
            int remainder = time % 60;
            
            if (ratio == 0 && remainder>0) {
                
                [TKUtil showClassEndMessage:[NSString stringWithFormat:@"%d%@",remainder,MTLocalized(@"Prompt.ClassEndTimeseconds")]];
            }else if(ratio>0){
                
                [TKUtil showClassEndMessage:[NSString stringWithFormat:@"%d%@",ratio,MTLocalized(@"Prompt.ClassEndTime")]];
            }
        }
        if (time<=0) {
            [TKUtil showMessage:MTLocalized(@"Prompt.ClassEnd")];
            [self prepareForLeave:YES];
        }
    }
    
    
    //设置当前时间
    if(!_iSessionHandle.isPlayback){
        [self.navbarView setTime:_iLocalTime];
        
    }
    _iLocalTime ++;
    
}

-(void)invalidateClassBeginTime{
    
    if (_iClassTimetimer) {
        [_iClassTimetimer invalidate];
        _iLocalTime = 0;
        _iClassTimetimer = nil;
    }
    
}

- (void)invalidateClassCurrentTime{
    if (_iClassCurrentTimer) {
        
        objc_setAssociatedObject(_iClassCurrentTimer, @selector(onClassCurrentTimer), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [_iClassCurrentTimer invalidate];
        _iClassCurrentTimer = nil;
    }
}

-(void)startClassBeginTimer{
    _iLocalTime = 0;
    [_iClassTimetimer setFireDate:[NSDate date]];
}

#pragma mark - PubMsg/DelMsg 答题器
- (void)roomWhiteBoardOnRemotePubMsg:(NSNotification *)notification
{
    NSDictionary *message = [notification.userInfo objectForKey:TKWhiteBoardNotificationUserInfoKey];
    NSString *name   = [message objectForKey:@"name"];
    
    if ([name isEqualToString:@"GetQuestionCount"]){
        //老师收到学生的答题
        if (_iSessionHandle.localUser.role != TKUserType_Student) {
            //老师
            TKAnswerSheetView *answerSheet = [self answerSheetForView:self.view];
            answerSheet.dict = message;
        }
    }
}


#pragma mark- 收到点击相机/相册的通知
- (void)uploadPhotos:(NSNotification *)notify
{
    if ([notify.object isEqualToString:sTakePhotosUploadNotification]) {
        //拍照上传
        [self chooseAction:1 delay:NO];
    }else if ([notify.object isEqualToString:sChoosePhotosUploadNotification]){
        //从图库上传
        [self chooseAction:0 delay:YES];
    }
}

- (void)cancelUpload
{
    [self removProgressView];
    
}

- (void)uploadProgress:(int)req totalBytesSent:(int64_t)totalBytesSent bytesTotal:(int64_t)bytesTotal{
    float progress = totalBytesSent/bytesTotal;
    [_uploadImageView setProgress:progress];
}

- (void)uploadFileResponse:(id _Nullable )Response req:(int)req{
    if (Response == nil && req == -1) {
        [TKUtil showMessage:MTLocalized(@"UploadPhoto.Error")];
    }
    else if (!req && [Response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tFileDic = (NSDictionary *)Response;
        TKDocmentDocModel *tDocmentDocModel = [[TKDocmentDocModel alloc]init];
        [tDocmentDocModel setValuesForKeysWithDictionary:tFileDic];
        [tDocmentDocModel dynamicpptUpdate];
        tDocmentDocModel.filetype = @"jpeg";
        [_iSessionHandle  addOrReplaceDocmentArray:tDocmentDocModel];
        [_iSessionHandle.whiteBoardManager addDocumentWithFile:[TKModelToJson getObjectData:tDocmentDocModel]];
        [_iSessionHandle  addDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender];
        [_iSessionHandle  publishtDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender aTellLocal:YES];
        [self removProgressView];
        [_iSessionHandle  sessionHandleEnableVideo:YES];
        
    } else {
        TKLog(@"error - image update - %@", Response);
    }
}

- (void)getMeetingFileResponse:(id _Nullable )Response{
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([@"idleTimerDisabled" isEqualToString:keyPath] && _iSessionHandle.iIsJoined && ![[change objectForKey:@"new"]boolValue]) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    
}

- (void)changeServer:(NSString *)server {
    if ([server isEqualToString:self.currentServer]) {
        return;
    }
    self.currentServer = server;
    [[NSUserDefaults standardUserDefaults] setObject:self.currentServer forKey:@"server"];
}

#pragma mark Private
//判断设备时间
- (void)judgeDeviceTime  {
    NSTimeInterval time = [TKUtil getNowTimeTimestamp];
    TKRoomJsonModel *property = _roomJson;
    [TKEduNetManager systemtime:self.iParamDic Complete:^int(id  _Nullable response) {
        double timeDiff = property.endtime -time;
        
        NSString *systemtime = [TKUtil getData:response[@"time"]];
        NSString *devicetime = [TKUtil getData:[NSString stringWithFormat:@"%f",time]];
        
        if (timeDiff < 0 && ![systemtime isEqualToString:devicetime]) {
            [TKUtil showMessage:MTLocalized(@"Prompt.TimeError")];
            [self prepareForLeave:YES];
        }
        return 0;
    } aNetError:^int(id  _Nullable response) {
        
        return 0;
    }];
}

// 获取礼物数
- (void)getTrophyNumber {
    // 老师不需要获取礼物
    if (_iSessionHandle.localUser.role != TKUserType_Student || _iSessionHandle.isPlayback == YES) {
        return;
    }
    
    // 学生断线重连需要获取礼物
    [TKEduNetManager getGiftinfo:_roomJson.roomid aParticipantId:_roomJson.thirdid  aHost:sHost aPort:sPort aGetGifInfoComplete:^(id  _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int result = 0;
            result = [[response objectForKey:@"result"]intValue];
            if (!result || result == -1) {
                
                NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                int giftnumber = 0;
                for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                    if (![_roomJson.thirdid isEqualToString:@"0"] && _roomJson.thirdid) {
                        NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                        if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:_roomJson.thirdid]) {
                            giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
                            break;
                        }
                    }
                }
                
                self.iSessionHandle.localUser.properties[sGiftNumber] = @(giftnumber);
                [_iSessionHandle sessionHandleChangeUserProperty:self.iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sGiftNumber Value:@(giftnumber) completion:nil];
            }
        });
        
    } aGetGifInfoError:^int(NSError * _Nullable aError) {
        TKLog(@"获取奖杯数量失败");
        return -1;
    }];
    
}
#pragma mark - 白板 控制
- (void)prePage
{
    
    [_iSessionHandle wbSessionManagerPrePage];
    //翻页收起画笔工具
    if (_brushToolView.hidden == NO) {
        
        [_brushToolView hideSelectorView];
    }
    
}
- (void)nextPage
{
    
    [_iSessionHandle wbSessionManagerNextPage];
    //翻页收起画笔工具
    if (_brushToolView.hidden == NO) {
        
        [_brushToolView hideSelectorView];
    }
}
- (void)turnToPage:(NSNumber *)pageNum
{
    
    [_iSessionHandle wbSessionManagerTurnToPage:pageNum.intValue];
    //翻页收起画笔工具
    if (_brushToolView.hidden == NO) {
        
        [_brushToolView hideSelectorView];
    }
}
- (void)enlarge
{
    [_iSessionHandle wbSessionManagerEnlarge];
}
- (void)narrow
{
    [_iSessionHandle wbSessionManagerNarrow];
}

- (void)fullScreen:(BOOL)isSelected
{
//    if ([TKRoomManager instance].localUser.role != TKUserType_Patrol) {// 巡课不可操作
    
        if (_iUserType == TKUserType_Student && isRemoteFullScreen) { // 学生在收到全屏 不可操作
            return;
        }
        
        BOOL coursewareFullSynchronize = _roomJson.configuration.coursewareFullSynchronize;
        if (_iUserType == TKUserType_Teacher && coursewareFullSynchronize && _iSessionHandle.isClassBegin) {
            
            // 老师需同步到其他端
            [_iSessionHandle sessionHandleFullScreenSend:!isSelected];
        } else {
            
            // 本地 (学生 自己的操作 || 关闭课件全屏同步)
            _pageControl.fullScreen.selected = isSelected = !isSelected;
            [[NSNotificationCenter defaultCenter] postNotificationName:sChangeWebPageFullScreen object:@(isSelected)];
        }
//    }
    
    //全屏结束放大状态并重置按钮状态
    [_iSessionHandle wbSessionManagerResetEnlarge];
    [_pageControl resetBtnStates];
}
#pragma mark - 清理
- (void)clearAllData{
    
    [self.iSessionHandle.whiteBoardManager changeDocumentWithFileID:_iSessionHandle.whiteBoard.fileid isBeginClass:_iSessionHandle.isClassBegin isPubMsg:YES];
    
    [self.iSessionHandle.whiteBoardManager disconnect:nil];
    
    [self.iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
  /*
    //将分屏的数据删除
    for (TKCTVideoSmallView *view in self.iStudentSplitViewArray) {
        view.isDrag = NO;
        [self.iStudentVideoViewArray addObject:view];
    }
    [self.iStudentSplitViewArray removeAllObjects];
    
    for (TKCTVideoSmallView *view in self.iStudentVideoViewArray) {
        [self clearVideoViewData:view];
    }
    
    if(self.iStudentVideoViewArray.count !=0){
        
        TKCTVideoSmallView *iview = (TKCTVideoSmallView *)self.iStudentVideoViewArray[0];
        
        for (int i=0; i<self.iStudentVideoViewArray.count; i++) {
            
            TKCTVideoSmallView *view = (TKCTVideoSmallView *)self.iStudentVideoViewArray[i];
            if (view.iRoomUser && iview.iVideoViewTag !=-1) {
                
                [self.iStudentVideoViewArray exchangeObjectAtIndex:i withObjectAtIndex:0];
                
            }
        }
    }
    */
    [self.iPlayVideoViewDic removeAllObjects];
    _iSessionHandle.onPlatformNum = 0;
    
    // 播放的MP4前，先移除掉上一个MP4窗口
    _iSessionHandle.iCurrentMediaDocModel = nil;
    [_iSessionHandle.msgList removeAllObjects];
    if (self.iMediaView) {
        [self.iMediaView deleteWhiteBoard];
        [self.iMediaView removeFromSuperview];
        self.iMediaView = nil;
    }
    
    if (self.iScreenView) {
        [self.iScreenView removeFromSuperview];
        self.iScreenView = nil;
    }
    
    /*
    [self.splitScreenView deleteAllVideoSmallView];
    
    [self.iStudentSplitScreenArray removeAllObjects];
    
    self.splitScreenView.hidden = YES;
    */
    //fix bug:全员奖励页面是显示在windows上的，如果网断了，退出教室，view还没消失
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSEnumerator *subviewsEnum = [window.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:NSClassFromString(@"TKTrophyView")]) {
            [subview removeFromSuperview];
        }
    }
    
    //网络断开连接 清理掉所有小工具，防止在网络断开过程中 老师关闭了小工具 导致关闭的信令没接收到
    
    //1.关闭答题卡
    TKAnswerSheetView *answerSheet = [self answerSheetForView:self.view];
    [answerSheet removeFromSuperview];
    answerSheet = nil;
    
    /*
    //2.关闭抢答器
    self.responderView.hidden = YES;
    [self.responderView removeFromSuperview];
    self.responderView = nil;
    */
    
    //3关闭计时器
    [_stuTimer removeFromSuperview];
    _stuTimer = nil;
    
    [_timerView removeFromSuperview];
    _timerView = nil;
    
    //4关闭转盘
    [_dialView removeFromSuperview];
    _dialView = nil;
    
    //5.关闭小白板
    [_iSessionHandle.whiteBoardManager.nativeWhiteBoardView hideMiniBoardView];
}


- (void)quitClearData {
    
    [_iSessionHandle configureDraw:false isSend:NO to:sTellAll peerID:_iSessionHandle.localUser.peerID];
    [_iSessionHandle.whiteBoardManager roomWhiteBoardOnDisconnect:nil];
    [_iSessionHandle clearAllClassData];
    [_iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
    [self clearVideoViewData:_iTeacherVideoView];
    [self clearVideoViewData:_iOurVideoView];
    [_iPlayVideoViewDic removeAllObjects];
    
    // 播放的MP4前，先移除掉上一个MP4窗口
    if (self.iMediaView) {
        [self.iMediaView removeFromSuperview];
        self.iMediaView = nil;
    }
    
    if (self.iScreenView) {
        [self.iScreenView removeFromSuperview];
        self.iScreenView = nil;
    }
    
    [moveView removeFromSuperview];
    
    if (self.navbarView.netTipView) {
        [self.navbarView.netTipView changeDetailSignImage:NO];
    }
    if (self.netDetailView) {
        [self.netDetailView removeFromSuperview];
        self.netDetailView = nil;
    }
    
    /**暂时这么解决s双重奖杯*/
    [_iTeacherVideoView removeAllObserver];
    [_iOurVideoView removeAllObserver];
}

- (void)clearVideoViewData:(TKCTVideoSmallView *)videoView {
    videoView.isDrag = NO;
    if (videoView.iRoomUser != nil) {
        [self myUnPlayVideo:videoView.iRoomUser aVideoView:videoView completion:^(NSError *error) {
            TKLog(@"清理视频窗口完成!");
        }];
    } else {
        [videoView clearVideoData];
    }
}

- (void)invalidateTimer {
    if (_iCheckPlayVideotimer) {
        [_iCheckPlayVideotimer invalidate];
        _iCheckPlayVideotimer = nil;
    }
    [self invalidateClassCurrentTime];
}
- (void)removProgressView {
    if (_uploadImageView) {
        [_uploadImageView removeFromSuperview];
        _uploadImageView = nil;
        _iPickerController = nil;
    }
}

- (NSDictionary *)convertWithData:(id)data
{
    NSDictionary *dataDic = @{};
    if ([data isKindOfClass:[NSString class]]) {
        NSString *tDataString = [NSString stringWithFormat:@"%@",data];
        NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
        dataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    }
    else if ([data isKindOfClass:[NSDictionary class]]) {
        dataDic = (NSDictionary *)data;
    }
    return dataDic;
}

-(void)removeNotificaton{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] removeObserver:self forKeyPath:@"idleTimerDisabled"];
}

#pragma mark - 懒加载
//创建画笔工具
- (TKBrushToolView *)brushToolView {
    
    if (_iSessionHandle.isPlayback == YES) {
        return nil;
    }
    
    if (_brushToolView == nil) {
        
        _brushToolView = [[TKBrushToolView alloc] init];
        _brushToolView.hidden    = YES;
        [_whiteboardBackView addSubview:_brushToolView];
        [_brushToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_whiteboardBackView.mas_right);
            make.top.equalTo(_whiteboardBackView.mas_top);
        }];
    }
    
    return _brushToolView;
}


- (UIView *)splitScreenView
{
    if (!_splitScreenView) {
        _splitScreenView = [[UIView alloc] init];
        _splitScreenView.backgroundColor = [UIColor blackColor];
    }
    _splitScreenView.frame = self.view.bounds;
    
    return _splitScreenView;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"roomController----dealloc");
}
- (void)didReceiveMemoryWarning {
    
}

@end
