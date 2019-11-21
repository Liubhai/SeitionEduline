//
//  TKCTMoreViewController.m
//  EduClass
//
//  Created by talkcloud on 2018/10/9.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <objc/message.h>
#import "sys/utsname.h"

#import "TKManyViewController.h"
#import "TKManyViewController+Playback.h"
#import "TKManyViewController+ImagePicker.h"
#import "TKManyViewController+Media.h"
#import "TKManyViewController+WhiteBoard.h"
#import "TKCTListView.h" //文档、媒体
#import "TKCTControlView.h"//控制按钮视图
#import "TKCTUserListView.h"//用户列表视图
#import "TKTimer.h"
#import "TKRCGlobalConfig.h"
#import "TKSplitScreenView.h"
#import "TKChatMessageModel.h"
#import "TKDocmentDocModel.h"
#import "TKProgressSlider.h"
#import "TKUploadImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "TKCTNewChatView.h"
#import "TKPopView.h"
#import "TKAnswerSheetView.h"
#import "TKDialView.h"
#import "TKToolsResponderView.h"
#import "TKTimerView.h"
#import "TKStuTimerView.h"
#import "TKBrushToolView.h"
#import "UIView+Drag.h"
#import "TKCTNetDetailView.h"

static const CGFloat sViewCap                     = 5;// 小视频间距

@interface TKManyViewController ()<TKEduBoardDelegate,TKEduSessionDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,
CAAnimationDelegate,TKEduNetWorkDelegate,TKPopViewDelegate, TKNativeWBPageControlDelegate>
{
    //视频的宽高属性
    CGFloat _screenWidth; // 横屏屏幕宽度(适配x+)
    CGFloat _viewX;// 横屏x坐标(适配x+)
    CGFloat _sBottomViewHeigh;
    CGFloat _sStudentVideoViewHeigh;
    CGFloat _sStudentVideoViewWidth;
    CGRect  videoOriginFrame;    // 画中画视频初始frame
    UIView *videoOriginSuperView; // 画中画视频初始父视图
    BOOL    isRemoteFullScreen;   // 收到远端的信令  全屏

}

// timer
@property (nonatomic, strong) NSTimer *iClassCurrentTimer;
@property (nonatomic, strong) NSTimer *iClassTimetimer;
@property (nonatomic, strong) TKTimer *iCheckPlayVideotimer;

@property (nonatomic, assign) NSTimeInterval iLocalTime;
@property (nonatomic, assign) NSTimeInterval iClassStartTime;// 上课开始时间
@property (nonatomic, assign) NSTimeInterval iServiceTime;
@property (nonatomic, assign) NSTimeInterval iHowMuchTimeServerFasterThenMe; // 时间差
@property (nonatomic, assign) NSTimeInterval iCurrentTime;// 当前时间

@property (nonatomic, strong) UIView *dimView; // 作用:点击空白视图 消失课件库 花名册
@property (nonatomic, strong) TKCTListView *listView;//课件库
@property (nonatomic, strong) TKCTUserListView *userListView;//控制按钮视图
@property (nonatomic, strong) TKCTChatView *chatView;//聊天视图
@property (nonatomic, strong) TKCTControlView *controlView;//控制按钮视图
@property (nonatomic, strong) TKCTNetDetailView * netDetailView;//网络质量

//移动
@property (nonatomic, assign) CGPoint iStrtCrtVideoViewP;
@property (nonatomic, assign) TKRoomType iRoomType;//当前房间类型
@property (nonatomic, assign) TKUserRoleType iUserType;//当前身份
@property (nonatomic, strong) TKCTBaseMediaView *iScreenView;//共享桌面
@property (nonatomic, strong) NSMutableDictionary    *iPlayVideoViewDic;// 上台用户

//视频相关
@property (nonatomic, retain) UIView   *videosBackView;//视频视图
@property (nonatomic, strong) NSMutableArray<TKCTVideoSmallView *>  *iStudentVideoViewArray;//存放学生和老师视频数组
@property (nonatomic, strong) TKSplitScreenView     *splitScreenView;//分屏背景视图
@property (nonatomic, strong) NSMutableArray<TKCTVideoSmallView *>         *iStudentSplitViewArray;  //存放学生分屏视频数组
@property (nonatomic, strong) NSMutableArray<NSString *>          *iStudentSplitScreenArray;//存放学生分屏ID数组
@property (nonatomic, strong) NSDictionary            *iScaleVideoDict;//记录缩放的视频

@property (nonatomic, assign) BOOL addVideoBoard;
@property (nonatomic, assign) BOOL isLocalPublish;
@property (nonatomic, assign) BOOL playbackEnd; //回放结束
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, assign) BOOL isQuiting;
@property (nonatomic, assign) BOOL networkRecovered;
@property (nonatomic, assign) BOOL isRemindClassEnd;
//白板
@property (nonatomic, assign) BOOL iShowBefore;//yes 出现过 no 没出现过
@property (nonatomic, assign) BOOL iShow;//yes 出现过 no 没出现过
@property (nonatomic, strong) TKBrushToolView *brushToolView; // 画笔工具

//拖动进来时的状态
@property (nonatomic, strong) NSMutableDictionary    *iMvVideoDic; // 拖动视频top left 等信息

// 发生断线重连设置为YES，恢复后设置为NO
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILabel *replyText;
@property (nonatomic, assign) CGFloat knownKeyboardHeight;
@property (nonatomic, strong) NSArray  *iMessageList;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGes;    // 记录老师视频默认长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *fullScreenVideoLongGes; // 记录老师视频播放mp4全屏长按手势

@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) TKNativeWBToolView *toolView;

// 工具箱
@property (nonatomic, strong) TKDialView *dialView;
@property (nonatomic, strong) TKToolsResponderView * responderView;
@property (nonatomic, strong) TKTimerView *timerView;// 计时器选择器
@property (nonatomic, strong) TKStuTimerView *stuTimer;// 学生端计时器


@end

@implementation TKManyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 通用初始化
    [self initCommon];
    // 初始化导航栏
    [self initNavigation];
    // 初始化小视频视图
    [self initVideosBackView];
    // 初始化白板
    [self initWhiteBoardView];
    // 初始化分屏视图
    [self initSplitScreenView];
    // 初始化聊天界面
    [self initMessageView];
    // 初始化手势
    [self initTapGesTureRecognizer];
    // 初始化音频
    [self initAudioSession];
    //初始化白板控件
    [self initWhiteBoardNativeTool];
    
    // 如果是回放，那么放上遮罩页
    if (_iSessionHandle.isPlayback == YES) {
        [self initPlaybackMaskView];
    }
    
    [self.backgroundImageView bringSubviewToFront:_iTKEduWhiteBoardView];
    
    [_iSessionHandle configureHUD:MTLocalized(@"HUD.EnteringClass") aIsShow:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    
    [self addNotification];
    
    [self createTimer];
    
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
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerAudioStateWithUserID:publishState:))]){
            
            NSString *str = params.firstObject;
            TKPublishState state =(TKPublishState)[params.lastObject intValue];
            ((void(*)(id,SEL,NSString *,TKPublishState))objc_msgSend)(self, funcSel , str,state);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerVideoStateWithUserID:publishState:))]){
            
            NSString *str = params.firstObject;
            TKPublishState state =(TKPublishState)[params.lastObject intValue];
            ((void(*)(id,SEL,NSString *,TKPublishState))objc_msgSend)(self, funcSel , str,state);
            
        }
        else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerUserJoined:InList:))]){
            
            NSString *str = params.firstObject;
            BOOL inList =[params.lastObject boolValue];
            ((void(*)(id,SEL,NSString *,BOOL))objc_msgSend)(self, funcSel , str,inList);
            
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
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (self.iMediaView) {
        [self.view bringSubviewToFront:self.iMediaView];
    }
    
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
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.chatViewNew removeSubviews];
    if (!_iPickerController) {
        [self invalidateTimer];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] removeObserver:self forKeyPath:@"idleTimerDisabled"];
}

#pragma mark - fullScreen白板全屏
-(void)whiteBoardFullScreen:(NSNotification*)aNotification{
    
    [self hiddenNavAlertView];
    
    bool isFull = [aNotification.object boolValue];

    //白板全屏隐藏
    self.chatViewNew.hidden = isFull;
    [TKEduSessionHandle shareInstance].iIsFullState = isFull;
    
    // 先移除老师视频长按手势再添加，避免混淆
    if ([self.iTeacherVideoView.gestureRecognizers containsObject:self.longGes]) {
        [self.iTeacherVideoView removeGestureRecognizer:self.longGes];
    }
    if ([self.iTeacherVideoView.gestureRecognizers containsObject:self.fullScreenVideoLongGes]) {
        [self.iTeacherVideoView removeGestureRecognizer:self.fullScreenVideoLongGes];
    }
    [self.iTeacherVideoView addGestureRecognizer:isFull ? self.fullScreenVideoLongGes:self.longGes];
    
    if (isFull) {
        
        self.splitScreenView.hidden = YES;
        CGRect tFrame = CGRectMake(_viewX, 0, _screenWidth, ScreenH);
        
        self.whiteboardBackView.frame = tFrame;
        self.whiteboardBackView.backgroundColor = UIColor.blackColor;
        self.iTKEduWhiteBoardView.frame = tFrame;
        if (self.iMediaView && !self.iMediaView.hasVideo) {
            //全屏隐藏MP3
            //            [self changeMp3ViewFrame];
            self.iMediaView.hidden = YES;
        }
        [self.backgroundImageView bringSubviewToFront:self.whiteboardBackView];
        [self.iSessionHandle.whiteBoardManager refreshWhiteBoard];
        
    }else{
        self.whiteboardBackView.backgroundColor = UIColor.clearColor;
        if (_iStudentSplitScreenArray.count>0) {
            
            self.splitScreenView.hidden = NO;
        }else{
            
            self.splitScreenView.hidden = YES;
        }
        if (self.iMediaView && !self.iMediaView.hasVideo) {
            //恢复显示MP3
            //            [self restoreMp3ViewFrame];
            self.iMediaView.hidden = NO;
        }
        [self.backgroundImageView sendSubviewToBack:self.whiteboardBackView];
        [self refreshUI];
    }
    
    
    [_navbarView hideAllButton:isFull];
}


#pragma mark - 初始化
-(void)addNotification{
    //白板全屏的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(whiteBoardFullScreen:) name:sChangeWebPageFullScreen object:nil];
    
    /** 1.先设置为外放 */
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    //    });
    /** 2.判断当前的输出源 */
    // [self routeChange:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapTable:)
                                                name:sTapTableNotification
                                              object:nil];
    
    
    //不自动锁屏
    [[UIApplication sharedApplication] addObserver:self forKeyPath:@"idleTimerDisabled" options:NSKeyValueObservingOptionNew context:nil];
    
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

- (instancetype)initWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                       aParamDic:(NSDictionary *)aParamDic

{
    
    if (self = [self init]) {
        _iRoomDelegate      = aRoomDelegate;
        _iParamDic          = aParamDic;
        _currentServer      = [aParamDic objectForKey:@"server"];
        
        _iSessionHandle = [TKEduSessionHandle shareInstance];
        _iSessionHandle.isPlayback = NO;
        _iSessionHandle.isSendLogMessage = YES;
        
        [_iSessionHandle setSessionDelegate:self aBoardDelegate:self];
    }
    return self;
}
- (instancetype)initPlaybackWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                               aParamDic:(NSDictionary *)aParamDic

{
    if (self = [self init]) {
        _iRoomDelegate      = aRoomDelegate;
        _iParamDic          = aParamDic;
        _currentServer      = [aParamDic objectForKey:@"server"];
        
        _iSessionHandle = [TKEduSessionHandle shareInstance];
        _iSessionHandle.isPlayback = YES;
        _iSessionHandle.isSendLogMessage = NO;
        
        [_iSessionHandle configurePlaybackSession:aParamDic aRoomDelegate:aRoomDelegate aSessionDelegate:self aBoardDelegate:self];
        
    }
    return self;
}
- (void)initCommon
{
    self.navigationController.navigationBar.hidden = YES;
    
    self.backgroundImageView.contentMode =  UIViewContentModeScaleToFill;
    self.backgroundImageView.sakura.image(@"ClassRoom.backgroundImage");
    
    //初始化容器
    _iStudentVideoViewArray   = [NSMutableArray array];
    _iStudentSplitScreenArray = [NSMutableArray array];
    _iStudentSplitViewArray   = [NSMutableArray array];
    _iPlayVideoViewDic        = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iScaleVideoDict          = [NSDictionary dictionary];
    
    //网络是否重新连接
    _networkRecovered   = YES;
    
    _isConnect          = NO;
    _iShow              = false;

    _roomJson 	        = [TKEduClassRoom shareInstance].roomJson;
    _iUserType          = (TKUserRoleType)_roomJson.roomrole;
    _iRoomType          = _roomJson.roomtype;
    
    //课堂中的视频分辨率
    self.iTKEduWhiteBoardDpi = [TKHelperUtil returnClassRoomDpi];
    [TKHelperUtil setVideoFormat];
    
    
    _viewX = [TKUtil isiPhoneX] ? 44 : 0;
    // 小视频尺寸
    _screenWidth             = [TKUtil isiPhoneX] ? ScreenW - 44 : ScreenW;
    _sStudentVideoViewWidth = (_screenWidth - sViewCap*Proportion*(sMaxVideo+1)) / sMaxVideo;
    _sStudentVideoViewHeigh = _sStudentVideoViewWidth * 3.0 / 4;
    _sBottomViewHeigh       = _sStudentVideoViewHeigh+ (2 * sViewCap)*Proportion;
    
    [_iSessionHandle  sessionHandleSetDeviceOrientation:(UIDeviceOrientationLandscapeLeft)];
    [TKHelperUtil phontLibraryAction];
    
    // 定时器
//    _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                        target:self
//                                                      selector:@selector(onClassTimer)
//                                                      userInfo:nil
//                                                       repeats:YES];
//    [_iClassTimetimer setFireDate:[NSDate distantFuture]];
    
}

-(void)initAudioSession{
    
    AVAudioSessionRouteDescription*route = [[AVAudioSession sharedInstance]currentRoute];
    for (AVAudioSessionPortDescription * desc in [route outputs]) {
        
        if ([[desc portType]isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
            _iSessionHandle.isHeadphones = NO;
            _iSessionHandle.iVolume = 1;
            
        }else{
            _iSessionHandle.isHeadphones = YES;
            _iSessionHandle.iVolume = 0.5;
        }
    }
    
}

-(void)initNavigation {
    
    self.navbarView = [[TKCTNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, TKNavHeight) aParamDic:_iParamDic];
    [self.backgroundImageView addSubview:self.navbarView];
    
    tk_weakify(self);
    
    //离开课堂 （返回)
    self.navbarView.leaveButtonBlock = ^{
        [weakSelf.view endEditing:YES];
        [weakSelf leftButtonPress];
    };
    // 上课
    self.navbarView.classBeginBlock = ^{
        [weakSelf hiddenNavAlertView];
    };
    //下课
    self.navbarView.classoverBlock = ^{
        
        [weakSelf hiddenNavAlertView];
        
        [weakSelf.iClassTimetimer invalidate];
        weakSelf.iClassTimetimer = nil;
    };
    // 花名册
    self.navbarView.memberButtonClickBlock = ^(UIButton *sender) {
        
        if (sender.selected) {
            
            [weakSelf hiddenNavAlertView];
            //花名册：宽 7/10  高 9/10
            CGFloat showHeight = ScreenH - TKNavHeight;
            CGFloat showWidth  = fmaxf(ScreenW*(6/10.0), 485);
            CGFloat x = (ScreenW-showWidth)/2.0;
            CGFloat y = TKNavHeight;
            
            weakSelf.dimView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.width - showWidth, showHeight)];
            weakSelf.dimView.backgroundColor = UIColor.clearColor;
            UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(tapOnViewToHide)];
            [weakSelf.dimView addGestureRecognizer:tapG];
            [weakSelf.view addSubview:weakSelf.dimView];
            
            weakSelf.userListView = [[TKCTUserListView alloc]initWithFrame:CGRectMake(x,y,showWidth,showHeight) userList:nil];
            
            
            weakSelf.userListView.dismissBlock = ^{
                weakSelf.navbarView.memberButton.selected = NO;
                weakSelf.userListView = nil;
            };
            [weakSelf.userListView show:weakSelf.view];
            
        }else{
            [weakSelf tapOnViewToHide];
        }
    };
    
    //课件库按钮
    self.navbarView.coursewareButtonClickBlock = ^(UIButton * sender) {
        if (sender.selected) {
            if (!weakSelf.listView) {
                
                [weakSelf hiddenNavAlertView];
                
                //文件列表：            宽 7/10  高 9/10
                CGFloat showHeight = ScreenH - TKNavHeight;
                CGFloat showWidth = fmaxf(ScreenW * (6/10.0), 500);
                CGFloat x = (ScreenW-showWidth)/2.0;
                //                CGFloat y = (ScreenH-showHeight)/2.0;
                CGFloat y = TKNavHeight;
                
                weakSelf.dimView = [[UIView alloc] initWithFrame:CGRectMake(0, y, weakSelf.view.width - showWidth, showHeight)];
                weakSelf.dimView.backgroundColor = UIColor.clearColor;
                UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(tapOnViewToHide)];
                [weakSelf.dimView addGestureRecognizer:tapG];
                [weakSelf.view addSubview: weakSelf.dimView];
                
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
    
    //    self.navbarView.messageButtonClickBlock = ^(UIButton *sender) {//聊天视图
    //
    //        if (sender.selected) {
    //
    //            if (!weakSelf.chatView) {
    //
    //                [weakSelf hiddenNavAlertView];
    //
    //                //聊天弹框：           宽 8/10  高 10/10
    //                CGFloat showHeight = fmaxf(ScreenH * (6/10.0), 300);
    //                CGFloat showWidth = ScreenW * (6/10.0);
    //                CGFloat x = (ScreenW-showWidth)/2.0;
    //                CGFloat y = (ScreenH-showHeight)/2.0;
    //
    //                weakSelf.chatView = [[TKCTChatView alloc]initWithFrame:CGRectMake(x,y,showWidth,showHeight) chatController:nil];
    //                weakSelf.chatView.dismissBlock = ^{
    //
    //                    weakSelf.navbarView.messageButton.selected = NO;
    //                    weakSelf.chatView = nil;
    //                };
    //                [weakSelf.chatView show:weakSelf.view];
    //
    //                if (_iSessionHandle.unReadMessagesArray.count>0) {
    //
    //                    [weakSelf.iSessionHandle.unReadMessagesArray removeAllObjects];
    //                }
    //                [weakSelf.navbarView buttonRefreshUI];
    //
    //
    //            }
    //        }else{
    //            if (weakSelf.chatView) {
    //                [weakSelf.chatView hidden];
    //                weakSelf.chatView = nil;
    //
    //            }
    //        }
    //    };
    
    self.navbarView.controlButtonClickBlock = ^(UIButton *sender) {//控制视图
        [weakSelf hiddenNavBarViewActionView];
        if (!weakSelf.controlView) {
            weakSelf.controlView = [[TKCTControlView alloc] init];
        }
        
        TKPopView *popview = [TKPopView showPopViewAddedTo:weakSelf.view pointingAtView:sender];
        popview.popViewType = TKPopViewType_AllControl;
        popview.delegate = weakSelf;
    };
    
    self.navbarView.toolBoxButtonClickBlock = ^(UIButton *sender) {
        
        [weakSelf hiddenNavBarViewActionView];
        
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


- (void)initMessageView
{
    float _width = IS_PAD ? ScreenW * (1 / 3.0) : ScreenW * (1 / 3.0);
    float _margin = IS_PAD ? 10 : 0;
    self.chatViewNew = [[TKCTNewChatView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(self.navbarView.frame) + _sBottomViewHeigh - _margin,
                                                                         _width,
                                                                         ScreenH - (self.navbarView.height + _sBottomViewHeigh))
                                               chatController:nil];
    self.chatViewNew.x = 15;
    [self.backgroundImageView addSubview:self.chatViewNew];
    [self.backgroundImageView bringSubviewToFront:self.splitScreenView];
    
    [self.chatViewNew setBadgeNumber:_iSessionHandle.unReadMessagesArray.count];
    tk_weakify(self);
    self.chatViewNew.messageBtnClickBlock = ^(UIButton * _Nonnull sender) {
        if (sender.selected) {
            [weakSelf hiddenNavAlertView];
            if (_iSessionHandle.unReadMessagesArray.count>0) {
                [weakSelf.iSessionHandle.unReadMessagesArray removeAllObjects];
            }
            [weakSelf.chatViewNew setBadgeNumber:weakSelf.iSessionHandle.unReadMessagesArray.count];
        }
    };
    
    self.chatViewNew.hideComplete = ^{
        [weakSelf.view bringSubviewToFront: weakSelf.whiteboardBackView];
    };
    //进教室的时候聊天窗口打开
    [self.chatViewNew hide:NO];
    
    [self.chatViewNew setUserRoleType:TKUserType_Student];
    
}

- (void)initWhiteBoardView
{
    CGFloat x        = _viewX;
    CGFloat y        = CGRectGetMaxY(self.videosBackView.frame);
    CGFloat width    = _screenWidth;
    CGFloat height   = ScreenH - CGRectGetMaxY(self.videosBackView.frame);
    
    CGRect tFrame    = CGRectMake(x, y, width, height);
    
    // 白板背景图
    _whiteboardBackView = [[UIView alloc] initWithFrame:tFrame];
    
    tFrame = [self whiteBoardChangeWithFrame:CGRectMake(x, 0, width, height)];
    
    _iSessionHandle.whiteBoardManager.colourid = _iParamDic[@"colourid"];
    _iTKEduWhiteBoardView = [_iSessionHandle.whiteBoardManager createWhiteBoardWithFrame:tFrame loadComponentName:TKWBMainContentComponent loadFinishedBlock:^{
        
        [_iSessionHandle.whiteBoardManager sendCacheInformation:_iSessionHandle.msgList];
    }];
    _iTKEduWhiteBoardView.backgroundColor     = [UIColor clearColor];
    _iSessionHandle.whiteboardView            = _iTKEduWhiteBoardView;
    
    [_whiteboardBackView addSubview:_iTKEduWhiteBoardView];
    [self.backgroundImageView addSubview:_whiteboardBackView];
    
//    [self refreshWhiteBoard:NO];
    
}

- (void)initSplitScreenView
{
    
    CGRect tFrame = self.iTKEduWhiteBoardView.frame;
    self.splitScreenView = [[TKSplitScreenView alloc] initWithFrame:tFrame];
    [self.backgroundImageView addSubview:self.splitScreenView];
    self.splitScreenView.hidden = YES;
}

-(void)initVideosBackView {
    
    // 小视频组 背景View
    self.videosBackView = ({
        
        UIView *tBottomView = [[UIView alloc]initWithFrame:CGRectMake(_viewX,
                                                                      CGRectGetMaxY(self.navbarView.frame),
                                                                      _screenWidth,
                                                                      _sBottomViewHeigh)];
        tBottomView.sakura.backgroundColor(@"ClassRoom.bottomViewBackGroundColor");
        tBottomView.sakura.alpha(@"ClassRoom.bottomViewBackGroundAlpha");
        
        tBottomView;
    });
    [self.backgroundImageView addSubview:self.videosBackView];
    
    CGFloat tCap     = sViewCap * Proportion;
    
    // 初始化 老师小视频
    [self initTeacherVideoView];
    
    [self.iStudentVideoViewArray addObject:self.iTeacherVideoView];//先插入老师的视图
    
    for (NSInteger i = 0; i < sMaxVideo - 1; i++) {
        
        TKCTVideoSmallView *studentVideoView = [[TKCTVideoSmallView alloc] initWithFrame:CGRectMake(tCap*2 + _sStudentVideoViewWidth,
                                                                                                    tCap + _videosBackView.y,
                                                                                                    _sStudentVideoViewWidth,
                                                                                                    _sStudentVideoViewHeigh)
                                                                              aVideoRole:TKEVideoRoleOther];
        
        studentVideoView.whiteBoardViewFrame = self.iTKEduWhiteBoardView.frame;
        studentVideoView.iVideoViewTag       = i;
        
        tk_weakify(self);
        studentVideoView.finishScaleBlock = ^{
            //缩放之后发布一下位移
            if (weakSelf.iUserType == TKUserType_Teacher) {
                [weakSelf sendMoveVideo:weakSelf.iPlayVideoViewDic aSuperFrame:weakSelf.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
            }
            
        };
        //分屏按钮回调
        __weak typeof(TKCTVideoSmallView *) wtOurVideoBottomView = studentVideoView;
        studentVideoView.splitScreenClickBlock = ^(TKEVideoRole aVideoRole) {
            //学生分屏开始
            [weakSelf beginTKSplitScreenView:wtOurVideoBottomView];
            
            NSArray *videoArray = [NSArray arrayWithArray:weakSelf.iStudentVideoViewArray];
            NSArray *array         = [NSArray arrayWithArray:weakSelf.iStudentSplitScreenArray];
            
            for (TKCTVideoSmallView *view in videoArray) {
                BOOL isbool = [self.iStudentSplitScreenArray containsObject: view.iRoomUser.peerID];
                if (view.isDrag && !view.isSplit && !isbool && array.count>0) {
                    [self.iStudentSplitScreenArray addObject:view.iRoomUser.peerID];
                    [self beginTKSplitScreenView:view];
                }
            }
        };
        
        // 恢复位置 - 全部恢复
        studentVideoView.resetMineBlock = ^(TKEVideoRole aVideoRole) {
            [weakSelf popViewResetWithView:wtOurVideoBottomView isResetAll:NO];
        };
        studentVideoView.resetAllBlock = ^(TKEVideoRole aVideoRole) {
            [weakSelf popViewResetWithView:wtOurVideoBottomView isResetAll:YES];
        };
        // 添加长按手势
        UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
        longGes.minimumPressDuration = 0.2;
        [studentVideoView addGestureRecognizer:longGes];
        
        // 缩放手势
        UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
        [studentVideoView addGestureRecognizer:pinchGR];

        
        [self.iStudentVideoViewArray addObject:studentVideoView];
        
    }
}

-(void)initTeacherVideoView
{
    //老师
    self.iTeacherVideoView= ({
        TKCTVideoSmallView *tTeacherVideoView = [[TKCTVideoSmallView alloc] initWithFrame:CGRectMake(0,
                                                                                                     0,
                                                                                                     _sStudentVideoViewWidth,
                                                                                                     _sStudentVideoViewHeigh)
                                                                               aVideoRole:TKEVideoRoleTeacher];
        
        tTeacherVideoView.whiteBoardViewFrame             = self.iTKEduWhiteBoardView.frame;
        tTeacherVideoView.iVideoViewTag                 = -1;
        
        tTeacherVideoView;
    });
    
    tk_weakify(self);
    self.iTeacherVideoView.finishScaleBlock = ^{
        //缩放之后发布一下位移
        if (weakSelf.iUserType == TKUserType_Teacher) {
            [weakSelf sendMoveVideo:weakSelf.iPlayVideoViewDic aSuperFrame:weakSelf.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
        }
        
    };
    self.iTeacherVideoView.splitScreenClickBlock = ^(TKEVideoRole aVideoRole) {
        //学生分屏开始
        [weakSelf beginTKSplitScreenView:weakSelf.iTeacherVideoView];
        
        NSArray *videoArray = [NSArray arrayWithArray:weakSelf.iStudentVideoViewArray];
        NSArray *array = [NSArray arrayWithArray:weakSelf.iStudentSplitScreenArray];
        for (TKCTVideoSmallView *view in videoArray) {
            BOOL isbool = [weakSelf.iStudentSplitScreenArray containsObject: view.iRoomUser.peerID];
            if (view.isDrag && !view.isSplit && !isbool && array.count>0) {
                [weakSelf.iStudentSplitScreenArray addObject:view.iRoomUser.peerID];
                [weakSelf beginTKSplitScreenView:view];
            }
        }
    };
    
    // 恢复位置 - 全部恢复
    self.iTeacherVideoView.resetMineBlock = ^(TKEVideoRole aVideoRole) {
        [weakSelf popViewResetWithView:weakSelf.iTeacherVideoView isResetAll:NO];
    };
    self.iTeacherVideoView.resetAllBlock = ^(TKEVideoRole aVideoRole) {
        [weakSelf popViewResetWithView:weakSelf.iTeacherVideoView isResetAll:YES];
    };
    
    
    // 添加长按手势
    // 老师视频默认长按手势
    UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    longGes.minimumPressDuration = 0.2;
    self.longGes = longGes;
    
    // 老师视频mp4全屏长按手势
    UILongPressGestureRecognizer * fullScreenVideoLongGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreenVideoLongPressClick:)];
    fullScreenVideoLongGes.minimumPressDuration = 0.2;
    self.fullScreenVideoLongGes = fullScreenVideoLongGes;
    
    [self.iTeacherVideoView addGestureRecognizer:longGes];
    
}
-(void)initTapGesTureRecognizer{
    UITapGestureRecognizer* tapTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTable:)];
    tapTableGesture.delegate = self;
    [self.backgroundImageView addGestureRecognizer:tapTableGesture];
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
    
    _pageControl.disenablePaging = NO;
    if (_iUserType != TKUserType_Teacher) {
        
        if (_roomJson.configuration.isHiddenPageFlip || !_roomJson.configuration.canPageTurningFlag)
        {
            _pageControl.disenablePaging	= YES;
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


- (void)createTimer {
    
    if (!_iCheckPlayVideotimer) {
        __weak typeof(self)weekSelf = self;
        _iCheckPlayVideotimer = [[TKTimer alloc] initWithTimeout:0.5 repeat:YES completion:^{
            __strong typeof(self)strongSelf = weekSelf;
            
            [strongSelf checkPlayVideo];
        } queue:dispatch_get_main_queue()];
        
        [_iCheckPlayVideotimer start];
    }
    
}

- (TKAnswerSheetView *)answerSheetForView:(UIView *)view
{
    TKAnswerSheetView *answerSheet = nil;
    view = _whiteboardBackView;
    
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


#pragma mark - 导航栏 工具箱弹窗
- (void)popViewResetWithView:(TKCTVideoSmallView *)aVideoView isResetAll:(BOOL)isResetAll {
    
    if (isResetAll) {
        
        [self.iSessionHandle sessionHandleDelMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAllExpectSender Data:@{} completion:^(NSError * _Nonnull error) {
        }];
        
        NSArray *sArray = [NSArray arrayWithArray:self.iStudentSplitViewArray];
        for (TKCTVideoSmallView *view in sArray) {
            
            view.isSplit = YES;
            [self beginTKSplitScreenView:view];
        }
        
        //将拖拽的视频还原
        for (TKCTVideoSmallView *view  in self.iStudentVideoViewArray) {
            
            [self updateMvVideoForPeerID:view.iPeerId];
            view.isDrag = NO;
        }
        
        [self sendMoveVideo:self.iPlayVideoViewDic aSuperFrame:self.iTKEduWhiteBoardView.frame allowStudentSendDrag:NO];
        self.splitScreenView.hidden = YES;
        [self refreshVideosBackView];
    } else {
        
        if (aVideoView.isDrag) {
            
            //将拖拽的视频还原
            for (TKCTVideoSmallView *view  in self.iStudentVideoViewArray) {
                
                if ([view.iRoomUser.peerID isEqualToString:aVideoView.iRoomUser.peerID]) {
                    
                    [self updateMvVideoForPeerID:view.iPeerId];
                    view.isDrag = NO;
                }
            }
            [self sendMoveVideo:self.iPlayVideoViewDic aSuperFrame:self.iTKEduWhiteBoardView.frame allowStudentSendDrag:NO];
            [self refreshVideosBackView];
            
        } else if (aVideoView.isSplit) {
            
            aVideoView.isSplit = YES;
            [self beginTKSplitScreenView:aVideoView];
        }
    }
}

- (void)popView:(TKPopView *)popView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [TKPopView dismissForView:self.view];
    
    switch (popView.popViewType) {
            
        case TKPopViewType_ToolBox:
        {
            if (indexPath.item == TKToolBoxAnswer) {
                
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
                
                
            }
            else if (indexPath.item == TKToolBoxDial) {
                
                [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:@"dial"
                                                                     ID:@"dialMesg"
                                                                     To:sTellAll
                                                                   Data:@{@"rotationAngle":[NSString stringWithFormat:@"rotate(0deg)"],
                                                                          @"isShow":@"true"}
                                                                   Save:YES
                                                             completion:nil];
                
            }
            else if (indexPath.item == TKToolBoxResponder) {
                
                if (_roomJson.configuration.assistantCanPublish
                    && [TKEduClassRoom shareInstance].roomJson.roomtype == TKRoomTypeOneToOne) {
                    //如果允许助教上台对应item == 3 其实是小白板
                    [[TKRoomManager instance] pubMsg:@"BlackBoard_new"
                                               msgID:@"BlackBoard_new"
                                                toID:@"__all"
                                                data:@{@"blackBoardState" : @"_prepareing", @"currentTapKey" : @"blackBoardCommon", @"currentTapPage" : @(1)}
                                                save:YES
                                       extensionData:@{@"associatedMsgID" : @"ClassBegin"}
                                          completion:nil];
                    
                    return;
                }
                
                
                if (self.responderView) {
                    return;
                }
                
                //是否显示//开始抢答//如果有人抢答，显示抢到的用户名
                NSDictionary * dict = @{@"isShow":@YES,
                                        @"begin":@NO,
                                        @"userAdmin":@""
                                        };
                NSString * str = [TKUtil dictionaryToJSONString:dict];
                [_iSessionHandle sessionHandlePubMsg:sQiangDaQi ID:sQiangDaQiMesg To:sTellAll Data:str Save:YES AssociatedMsgID:sClassBegin AssociatedUserID:nil expires:0 completion:nil];
                
            }
            else if (indexPath.item == TKToolBoxTimer) {
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
                
            }
            else if (indexPath.item == TKToolBoxSmallWhiteBoard) {
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
            break;
            
        case TKPopViewType_AllControl:
        {
            if (indexPath.item == 0) {
                //全体发言
                [self.controlView speecheButtonClick:nil];
                
            }else if (indexPath.item == 1) {
                //全体静音
                [self.controlView MuteButtonClick:nil];
                
            }else if (indexPath.item == 2) {
                //全体奖励
                [self.controlView rewardButtonClick:nil];
                
            }else if (indexPath.item == 3) {
                //全体复位
                [self.controlView resetButtonClick:nil];
                [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAllExpectSender Data:@{} completion:^(NSError * _Nonnull error) {
                }];
                
                NSArray *sArray = [NSArray arrayWithArray:self.iStudentSplitViewArray];
                for (TKCTVideoSmallView *view in sArray) {
                    
                    view.isSplit = YES;
                    [self beginTKSplitScreenView:view];
                }
                
                //将拖拽的视频还原
                for (TKCTVideoSmallView *view  in self.iStudentVideoViewArray) {
                    
                    [self updateMvVideoForPeerID:view.iPeerId];
                    view.isDrag = NO;
                }
                
                [self sendMoveVideo:self.iPlayVideoViewDic aSuperFrame:self.iTKEduWhiteBoardView.frame allowStudentSendDrag:NO];
                self.splitScreenView.hidden = YES;
                [self refreshVideosBackView];
                
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)popViewWillHidden:(TKPopView *)popView
{
    self.navbarView.toolBoxButton.selected = NO;
    self.navbarView.controlButton.selected = NO;
}

#pragma mark - 视频相关操作
// 分屏/取消分屏
- (void)beginTKSplitScreenView:(TKCTVideoSmallView*)videoView{
    
    if (!videoView.isSplit) {
        
        [self.backgroundImageView bringSubviewToFront:_splitScreenView];
        self.splitScreenView.frame = self.whiteboardBackView.frame;
        
        //在_iStudentVideoViewArray 中删除视图
        NSArray *videoArray = [NSArray arrayWithArray:_iStudentVideoViewArray];
        
        for (TKCTVideoSmallView *view in videoArray) {
            
            if (view.iVideoViewTag == videoView.iVideoViewTag) {
                
                [_iStudentVideoViewArray removeObject:view];
                
            }
        }
        
        [_iStudentSplitViewArray addObject:videoView];
        _splitScreenView.hidden = NO;
        videoView.isSplit = YES;
        [_splitScreenView addVideoSmallView:videoView];
        BOOL isbool = [_iStudentSplitScreenArray containsObject: videoView.iRoomUser.peerID];
        if (!isbool) {
            [_iStudentSplitScreenArray addObject:videoView.iRoomUser.peerID];
            
        }
        
        self.splitScreenView.backgroundColor = UIColor.blackColor;
        
    }else{//取消分屏
        
        
        [_iStudentVideoViewArray addObject:videoView];
        
        [_iStudentSplitScreenArray removeObject:videoView.iRoomUser.peerID];
        
        [_splitScreenView deleteVideoSmallView:videoView];
        
        [_iStudentSplitViewArray removeObject:videoView];
        
        if (_iStudentSplitScreenArray.count<=0) {
            _splitScreenView.hidden = YES;
        }
        [self sendMoveVideo:_iPlayVideoViewDic aSuperFrame:_iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
        
        videoView.isSplit = NO;
        
        self.splitScreenView.backgroundColor = UIColor.clearColor;
        
        // 只看老师和自己时 学生显示老师拖到课件上的人的音视频，恢复后不在显示
        if (_roomJson.configuration.onlyMeAndTeacherVideo && _iSessionHandle.localUser.role == TKUserType_Student) {
            
            if (videoView.iRoomUser.role != TKUserType_Teacher && ![videoView.iRoomUser.peerID isEqualToString:_iSessionHandle.localUser.peerID]) {
                    
                [self unPlayVideo:videoView.iRoomUser.peerID];
            }
        }
    }
    
    videoView.isDrag = NO;
    
    
    if (_iUserType == TKUserType_Teacher) {
        NSString *str = [TKUtil dictionaryToJSONString:@{@"userIDArry":_iStudentSplitScreenArray}];
        [_iSessionHandle sessionHandlePubMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAllExpectSender Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        
    }
    
    [self refreshVideosBackView];
}

- (void)cancelSplitScreen:(NSMutableArray *)array {
    if (_iStudentSplitScreenArray.count>array.count) {
        
        __block NSMutableArray *difObject = [NSMutableArray arrayWithCapacity:10];
        //找到arr2中有,arr1中没有的数据
        [_iStudentSplitScreenArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *number1 = obj;//[obj objectAtIndex:idx];
            __block BOOL isHave = NO;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([number1 isEqual:obj]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave) {
                [difObject addObject:obj];
            }
        }];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *number1 = obj;//[obj objectAtIndex:idx];
            __block BOOL isHave = NO;
            [_iStudentSplitScreenArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([number1 isEqual:obj]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave) {
                [difObject addObject:obj];
            }
        }];
        
        for (NSString *peerID in difObject) {
            
            NSArray *sArray = [NSArray arrayWithArray:_iStudentSplitViewArray];
            for (TKCTVideoSmallView *view in sArray) {
                
                if([view.iRoomUser.peerID isEqualToString:peerID]){
                    view.isSplit = YES;
                    [self beginTKSplitScreenView:view];
                }
            }
        }
    }
}

// 画中画
- (void)changeVideoFrame:(BOOL)isFull {
    
    if (isFull == _iSessionHandle.isPicInPic) return;//相同消息不执行
    _iSessionHandle.isPicInPic = isFull;
    
    if (isFull) {
        
        // 缓存尺寸
        videoOriginFrame = _iTeacherVideoView.frame;//相同状态重复调用 本方法 会导致数据存储错误
        
        _iTeacherVideoView.hidden = NO;
        videoOriginSuperView = _iTeacherVideoView.superview;
        
        // 固定画中画 宽高 （老师拖拽视频放大后全屏，画中画 过大）
        _iTeacherVideoView.width = _sStudentVideoViewWidth;
        _iTeacherVideoView.height = _sStudentVideoViewHeigh;
        _iTeacherVideoView.x = ScreenW - _iTeacherVideoView.width - 5.;
        _iTeacherVideoView.y = ScreenH - _iTeacherVideoView.height - 5.;
        
        [[UIApplication sharedApplication].keyWindow addSubview: _iTeacherVideoView];
        
        if (!_iTeacherVideoView.iRoomUser.hasVideo ||
            (_iTeacherVideoView.iRoomUser.publishState != TKUser_PublishState_BOTH && _iTeacherVideoView.iRoomUser.publishState != TKUser_PublishState_VIDEOONLY) ||
            _iSessionHandle.isOnlyAudioRoom) {
            // 无视频不显示画中画 || 纯音频教室不显示画中画
            _iTeacherVideoView.hidden = YES;
        }
        
    } else {
        
        _iTeacherVideoView.hidden = NO;
        [_iTeacherVideoView removeFromSuperview];
        
        videoOriginSuperView = videoOriginSuperView ?: self.backgroundImageView;
        _iTeacherVideoView.frame = videoOriginFrame;
        [videoOriginSuperView addSubview: _iTeacherVideoView];
        
        [self refreshVideosBackView];
    }
    
    [_iTeacherVideoView maskViewChangeForPicInPicWithisShow:isFull];
    
    // 导航栏的按钮 显示/隐藏 操作
    [_navbarView hideAllButton:isFull];
}

/**
 发送视频的位置
 
 @param aPlayVideoViewDic 位置存储字典
 @param aSuperFrame 父视图
 */
-(void)sendMoveVideo:(NSDictionary *)aPlayVideoViewDic aSuperFrame:(CGRect)aSuperFrame allowStudentSendDrag:(BOOL)isSendDrag{
    
    CGRect superFrame = CGRectMake(0, CGRectGetMaxY(self.videosBackView.frame), ScreenW, ScreenH - CGRectGetMaxY(self.videosBackView.frame));
    
    NSMutableDictionary *tVideosDic = @{}.mutableCopy;
    for (NSString *tKey in aPlayVideoViewDic) {
        
        TKCTVideoSmallView *tVideoView = [aPlayVideoViewDic objectForKey:tKey];
        CGFloat tX = CGRectGetWidth(superFrame) - CGRectGetWidth(tVideoView.frame);
        CGFloat tY = CGRectGetHeight(superFrame)-CGRectGetHeight(tVideoView.frame);
        CGFloat tLeft = (CGRectGetMinX(tVideoView.frame)-CGRectGetMinX(superFrame))/tX;
        CGFloat tTop  = (CGRectGetMinY(tVideoView.frame)-CGRectGetMinY(superFrame))/tY;
        
        if (tLeft < 0) tLeft = 0;
        if (tLeft > 1) tLeft = 1;
        if (tTop < 0) tTop = 0;
        if (tTop > 1) tTop = 1;
        
        if(tVideoView.isSplit){
            tLeft = 0;
            tTop = 0;
        }
        
        NSDictionary *tDic = @{@"percentTop":@(tTop),@"percentLeft":@(tLeft),@"isDrag":@(tVideoView.isDrag)};
        if ((tVideoView.iRoomUser.role == TKUserType_Student) || (tVideoView.iRoomUser.role == TKUserType_Assistant) || (tVideoView.iRoomUser.role == TKUserType_Teacher) ) {
            [tVideosDic setObject:tDic forKey:tVideoView.iPeerId?tVideoView.iPeerId:@""];
        }
        
    }
    NSDictionary *tDic =   @{@"otherVideoStyle":tVideosDic};
    
    self.iMvVideoDic = [NSMutableDictionary dictionaryWithDictionary:tVideosDic];
    if (_iSessionHandle.localUser.role == TKUserType_Teacher || isSendDrag) {
        [_iSessionHandle publishVideoDragWithDic:tDic To:sTellAllExpectSender];
    }
    
}

// 拖拽实现方法
-(void)moveVideo:(NSDictionary *)aMvVideoDic{

    //bug修复
    //当台上的视频完全被拖到白板上后，白板frame会变化，此时白板上的视频view也应该相应的根据白板frame变化 做相应调整
    //之前的方法执行顺序 moveVideo ——> refreshVideosBackView ——> stretchWhiteBoardAreaWithPlayCount。耦合度太高。并且有死循环的危险。
    //临时解决办法：在收到 moveVideo时，先让白板frame变化，然后在执行moveVideo
    
    NSDictionary * copyAMuVideoDic = [aMvVideoDic copy];
    for (NSString *peerId in copyAMuVideoDic) {
        NSDictionary *obj = [copyAMuVideoDic objectForKey:peerId];
        BOOL isDrag = [[obj objectForKey:@"isDrag"]boolValue];
        //对返回的数据做NSNull值判断
        if([[obj objectForKey:@"percentTop"] isKindOfClass:[NSNull class]]){
            return;
        }
        if([[obj objectForKey:@"percentLeft"] isKindOfClass:[NSNull class]]){
            return;
        }
        CGFloat top = [[obj objectForKey:@"percentTop"]floatValue];
        CGFloat left = [[obj objectForKey:@"percentLeft"]floatValue];
        if (top < 0) top = 0;
        if (top > 1) top = 1;
        if (left < 0) left = 0;
        if (left > 1) left = 1;
        
        TKCTVideoSmallView *tVideoView = [self.iPlayVideoViewDic objectForKey:peerId];
        if (tVideoView) {
            tVideoView.isDrag = isDrag;
        }
    }
    [self refreshVideosBackView];

    
    for (NSString *peerId in copyAMuVideoDic) {
        NSDictionary *obj = [copyAMuVideoDic objectForKey:peerId];
        BOOL isDrag = [[obj objectForKey:@"isDrag"]boolValue];
        //对返回的数据做NSNull值判断
        if([[obj objectForKey:@"percentTop"] isKindOfClass:[NSNull class]]){
            return;
        }
        if([[obj objectForKey:@"percentLeft"] isKindOfClass:[NSNull class]]){
            return;
        }
        CGFloat top = [[obj objectForKey:@"percentTop"]floatValue];
        CGFloat left = [[obj objectForKey:@"percentLeft"]floatValue];
        if (top < 0) top = 0;
        if (top > 1) top = 1;
        if (left < 0) left = 0;
        if (left > 1) left = 1;
        
        TKCTVideoSmallView *tVideoView = [self.iPlayVideoViewDic objectForKey:peerId];
        
        // 只看老师和自己时 学生显示老师拖到课件上的人的音视频，恢复后不在显示
        if (_roomJson.configuration.onlyMeAndTeacherVideo && _iSessionHandle.localUser.role == TKUserType_Student) {
            
            TKRoomUser * user = [_iSessionHandle.roomMgr getRoomUserWithUId:peerId];
            
            if (user && !tVideoView && isDrag && user.publishState > 0) {
                
                for (TKCTVideoSmallView *view in self.iStudentVideoViewArray) {
                    if(view.iVideoViewTag == -1){// 老师
                        continue;
                    }
                    if([view.iRoomUser.peerID isEqualToString:peerId]) {
                        tVideoView = view;
                        break;
                    }
                    else if(view.iRoomUser == nil) {
                        tVideoView = view;
                        break;
                    }
                }
                
                if (tVideoView) {
                    [self playVideo:user view:tVideoView];
                }
                
            }  else if (user && tVideoView && !isDrag && !tVideoView.isSplit) {
                
                if (user.role != TKUserType_Teacher && ![peerId isEqualToString:_iSessionHandle.localUser.peerID]) {
                    
                    tVideoView.isDrag = isDrag;
                    [self unPlayVideo:tVideoView.iRoomUser.peerID];
                    tVideoView = nil;
                }
            }
        }
        
        if (tVideoView) {
            
            tVideoView.isDrag = isDrag;
            if (isDrag) {
                
                CGFloat tX = ScreenW - CGRectGetWidth(tVideoView.frame);
                CGFloat tY = ScreenH - CGRectGetMaxY(self.videosBackView.frame)-CGRectGetHeight(tVideoView.frame);
                tVideoView.frame = CGRectMake(tX*left, CGRectGetMaxY(self.videosBackView.frame)+ tY*top, CGRectGetWidth(tVideoView.frame), CGRectGetHeight(tVideoView.frame));
                
                CGFloat w =((ScreenW-sMaxVideo*sViewCap)/ sMaxVideo);
                CGFloat h = (w /4.0 * 3.0)+(w /4.0 * 3.0)/sMaxVideo;
                
                if (!tVideoView.isSplit && tVideoView.currentWidth<tVideoView.originalWidth) {
                    
                    tVideoView.frame = CGRectMake(tX*left, CGRectGetMaxY(self.videosBackView.frame) + tY*top, w, h);
                }
                
            }
            
        }
    }
}

- (void)sScaleVideo:(NSDictionary *)peerIdToScaleDic{
    
    NSArray *peerIdArray = peerIdToScaleDic.allKeys;
    
    for (NSString *peerId in peerIdArray) {
        NSDictionary *scaleDict = [peerIdToScaleDic objectForKey:peerId];
        
        CGFloat scale = [scaleDict[@"scale"] floatValue];
        
        TKCTVideoSmallView *videoView = [self videoViewForPeerId:peerId];
        
        if (videoView && videoView.isDrag == YES) {
            [videoView changeVideoSize:scale inFrame:_iTKEduWhiteBoardView.frame];
        }
    }
}

- (void)sVideoSplitScreen:(NSMutableArray *)array{
    
    NSArray *svArr = [NSArray arrayWithArray:_iStudentVideoViewArray];
    
    for (TKCTVideoSmallView *videoView in svArr) {
        for (NSString *peerId in array) {
            
            if ([peerId isEqualToString:videoView.iRoomUser.peerID]) {
                
                [self beginTKSplitScreenView:videoView];
                
            }
        }
    }
}
// 根据分辨率调整 itkeduwhiteboard.frame
- (CGRect)whiteBoardChangeWithFrame:(CGRect)frame {
//    return frame;
    if (self.iTKEduWhiteBoardDpi <= 0) {
        return frame;
    }
    
    CGRect reFrame;
    
    CGFloat width  = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat dpiWidth  = 0;
    CGFloat dpiHeight = width * self.iTKEduWhiteBoardDpi;
    CGFloat space = 0;
    
    
    if (height >= dpiHeight) {
        
        dpiWidth = width;
        reFrame = CGRectMake(frame.origin.x, frame.origin.y, dpiWidth, dpiHeight);
    } else {
        
        dpiHeight = height;
        dpiWidth = dpiHeight / self.iTKEduWhiteBoardDpi;
        space = (width - dpiWidth) / 2;
        reFrame = CGRectMake(frame.origin.x + space, frame.origin.y, dpiWidth, dpiHeight);
    }
    //    NSLog(@"*******%@", NSStringFromCGRect(reFrame));
    return reFrame;
}

#pragma mark - 导航栏
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
    
    if (self.controlView) {
        [self.controlView hidden];
        self.navbarView.controlButton.selected = NO;
        self.controlView = nil;
    }
    [self tapOnViewToHide];
}
- (void)controlTabbarToolBoxBtn:(BOOL)isSelected {
    
    if (self.navbarView.toolBoxButton.selected != isSelected) {
        
        [_iSessionHandle.whiteBoardManager showToolbox:isSelected];
        self.navbarView.toolBoxButton.selected = isSelected;
    }
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

#pragma mark - 刷新
-(void)refreshUI{
    
    @autoreleasepool {
        if (self.iPickerController) {
            return;
        }
        
        [self refreshWhiteBoard:YES];
        
        [self sScaleVideo:self.iScaleVideoDict];
        [self moveVideo:self.iMvVideoDic];
        [self sVideoSplitScreen:self.iStudentSplitScreenArray];
    }
}

// 刷新小视图布局
-(void)refreshVideosBackView{
    
    // 记录正在播放的个数来固定位置
    int playingCount = 0;
    
    TKCTVideoSmallView *iteacherView;
    NSMutableArray        *noTeacherArray     = [NSMutableArray array];
    
    for (TKCTVideoSmallView *view in self.iStudentVideoViewArray) {
        if(view.iRoomUser) {
            if (view.iVideoViewTag == -1) { // 老师
                iteacherView = view;
            }
            else {
                [noTeacherArray addObject:view];
            }
            if (!view.isDrag) {
                playingCount++;
            }
        }
    }
    
    //将老师视频放到第一位
    [self.iStudentVideoViewArray enumerateObjectsUsingBlock:^(TKCTVideoSmallView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.iVideoViewTag == -1 && idx != 0) {
            [self.iStudentVideoViewArray exchangeObjectAtIndex:idx withObjectAtIndex:0];
            *stop = YES;
        }
    }];
    
    // 是否需要拉伸白板
    [self stretchWhiteBoardAreaWithPlayCount:playingCount];
    
    // 小视频上边距
    CGFloat tCap                = self.videosBackView.y + (self.videosBackView.height - _sStudentVideoViewHeigh)/2;
    CGFloat tleft               = sViewCap * Proportion;// 左边距
    __block CGFloat left        = 0;
    __block BOOL tStdOutBottom     = NO;
    
    //根据视频个数将视频平分在工具栏（始终居中平分）
    if((playingCount%2)==1)//奇数
    {
        left = self.videosBackView.width/2 - _sStudentVideoViewWidth/2 - tleft*((playingCount - 1)/2) - _sStudentVideoViewWidth*((playingCount - 1)/2);
    }
    else//偶数
    {
        left = self.videosBackView.width/2 - _sStudentVideoViewWidth*(playingCount/2) - tleft*(playingCount/2) + tleft/2;
    }
    
    // 排序小视频配置项
    BOOL sortArr = [TKEduClassRoom shareInstance].roomJson.configuration.sortSmallVideo;
    if (noTeacherArray.count > 1 && sortArr) {
        
        __block NSMutableArray *sortArray = [NSMutableArray array];
        [TKSortTool sortByPeerIDWithArray:noTeacherArray sortTheValueOfBlock:^(id returnValue) {
            //将老师视频放在第一位
            if (iteacherView) {
                [sortArray addObject:iteacherView];
            }
            [sortArray addObjectsFromArray:returnValue];
            
            [noTeacherArray removeAllObjects];
            for (TKCTVideoSmallView *view in sortArray) {
                
                if (view.iRoomUser) {
                    
                    if (!view.isSplit && view.isDrag == NO) {//判断是否分屏
                        [self.backgroundImageView addSubview:view];
                        view.alpha  = 1;
                        view.frame = CGRectMake(left, tCap, _sStudentVideoViewWidth, _sStudentVideoViewHeigh);
                        left += tleft + _sStudentVideoViewWidth;
                        
                    }else{
                        //这里的MaxY > MinY的条件 没看懂，我觉得这个条件会始终成立
                        BOOL isEndMvToScrv = ((CGRectGetMaxY(view.frame) > CGRectGetMinY(self.videosBackView.frame)));
                        if (!view.superview) {
                            [self.backgroundImageView addSubview:view];
                        }
                        if (isEndMvToScrv) {
                            
                            view.isDrag = YES;
                            tStdOutBottom = YES;
                            continue;
                        }
                        view.isDrag = NO;
                        view.alpha  = 1;
                        view.frame = CGRectMake(left, tCap, _sStudentVideoViewWidth, _sStudentVideoViewHeigh);
                        left += tleft + _sStudentVideoViewWidth;
                        
                    }
                    
                }
                else {
                    [view removeFromSuperview];
                }
                
                if(view.iRoomUser.peerID){
                    
                    [self.iPlayVideoViewDic setObject:view forKey:view.iRoomUser.peerID];
                }
                
            }
        }];
    }
    else {
        
        int i = 1;
        
        /**这里有问题：每次有人进出房间，都会导致SmallView的addSubview到父视图上*/
        
        for (TKCTVideoSmallView *view in self.iStudentVideoViewArray) {

            
            if (view.iRoomUser) {
                i++;
                if (view.isSplit== NO && view.isDrag == NO) {//判断是否分屏
                    [self.backgroundImageView addSubview:view];
                    view.alpha  = 1;
                    view.frame = CGRectMake(left, tCap, _sStudentVideoViewWidth, _sStudentVideoViewHeigh);
                    left += tleft + _sStudentVideoViewWidth;
                    
                }else{
                    //这里的MaxY > MinY的条件 没看懂，我觉得这个条件会始终成立
                    BOOL isEndMvToScrv = ((CGRectGetMaxY(view.frame) > CGRectGetMinY(self.videosBackView.frame)));
                    if (!view.superview) {
                        [self.backgroundImageView addSubview:view];
                    }
                    if (isEndMvToScrv) {
                        
                        view.isDrag = YES;
                        tStdOutBottom = YES;
                        continue;
                    }
                    view.isDrag = NO;
                    view.alpha  = 1;
                    view.frame = CGRectMake(left, tCap, _sStudentVideoViewWidth, _sStudentVideoViewHeigh);
                    left += tleft + _sStudentVideoViewWidth;
                    
                }
            }else {
                [view removeFromSuperview];
            }
            
            if(view.iRoomUser.peerID){
                
                [self.iPlayVideoViewDic setObject:view forKey:view.iRoomUser.peerID];
            }
            
        }
    }
    
    // pc端老师下台 上面的逻辑判断 没把老师加进去
    if (!self.iTeacherVideoView.iRoomUser) {
        [self.iTeacherVideoView removeFromSuperview];
    }
    
    _iSessionHandle.iStdOutBottom = tStdOutBottom;
    if (_iSessionHandle.iIsFullState) {
        [self.backgroundImageView bringSubviewToFront:self.whiteboardBackView];
    }else{
        [self.backgroundImageView sendSubviewToBack:self.whiteboardBackView];
    }
    
    if (self.iMediaView) {
        [self.backgroundImageView bringSubviewToFront:self.iMediaView];
    }
}
// 拉伸白板
- (void)stretchWhiteBoardAreaWithPlayCount:(NSInteger)playingCount
{
    // 视频全部拖到课件板后 拉伸白板区域
    if (playingCount == 0) {
        
        CGFloat tHeight                 = ScreenH - self.navbarView.bottomY;
        
        self.videosBackView.height      = 0;
        CGRect tFrame                   = CGRectMake(_viewX, self.navbarView.bottomY, _screenWidth, tHeight);
        self.whiteboardBackView.frame    = tFrame;
        self.iTKEduWhiteBoardView.frame = CGRectMake(_viewX, 0, _screenWidth, tHeight);
        
//        [_iSessionHandle.whiteBoardManager setWhiteBoardFrame:CGRectMake(_viewX, 0, _screenWidth, tHeight)];
        [_iSessionHandle.whiteBoardManager refreshWhiteBoard];
        
        
    }
    
    else if (self.videosBackView.height == 0) {
        
        self.videosBackView.height      = _sBottomViewHeigh;
        CGFloat tHeight                 = ScreenH - self.videosBackView.bottomY;
        CGRect tFrame					= CGRectMake(_viewX, CGRectGetMaxY(self.videosBackView.frame), _screenWidth, tHeight);
        self.whiteboardBackView.frame   = tFrame;
        
//        tFrame = [self whiteBoardChangeWithFrame:CGRectMake(_viewX, 0, _screenWidth, tHeight)];
        self.iTKEduWhiteBoardView.frame = CGRectMake(tFrame.origin.x, 0, tFrame.size.width, tFrame.size.height);
        
//        [_iSessionHandle.whiteBoardManager setWhiteBoardFrame:self.iTKEduWhiteBoardView.frame];
        [_iSessionHandle.whiteBoardManager refreshWhiteBoard];
        _splitScreenView.frame = tFrame;
    }
    self.splitScreenView.frame = self.whiteboardBackView.frame;
}
- (void)refreshWhiteBoard:(BOOL)hasAnimate {
    
    if (_iSessionHandle.isPicInPic) {
        [self changeVideoFrame:NO];
    }
    CGFloat x        = _viewX;
    CGFloat y        = CGRectGetMaxY(self.videosBackView.frame);
    CGFloat width    = _screenWidth;
    CGFloat height   = ScreenH - CGRectGetMaxY(self.videosBackView.frame);
    
    CGRect tFrame    = CGRectMake(x, y, width, height);
    
    // 去掉了判断1对1
    self.videosBackView.hidden = NO;
    
    [self.backgroundImageView bringSubviewToFront:self.whiteboardBackView];
    
    if (hasAnimate) {
        [UIView animateWithDuration:0.1 animations:^{
           
            // 白板背景图
            _whiteboardBackView.frame = tFrame;
            
            _iTKEduWhiteBoardView.frame = _whiteboardBackView.bounds;
           
            
            if (self.iMvVideoDic && self.iStudentSplitViewArray.count<=0) {
                [self moveVideo:self.iMvVideoDic];//视频位置会乱掉所以注释掉了

            }
            [_iSessionHandle.whiteBoardManager refreshWhiteBoard];
        } completion:^(BOOL finished) {
            //MP3图标位置变化,但是MP4的位置不需要变化
            if (!self.iMediaView.hasVideo) {
                [self restoreMp3ViewFrame];
            }
            
            //白板经过全屏——>恢复全屏后 需要判断pagecontrol的frame是否超出白板，如果超出重新设置约束
            if (CGRectGetMaxY(self.pageControl.frame) > CGRectGetHeight(_whiteboardBackView.frame)) {
                [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(_whiteboardBackView.mas_bottom).offset(0);
                    make.centerX.equalTo(_whiteboardBackView.mas_centerX);
                }];

            }
        }];
    }else{
        
        // 白板背景图
        _whiteboardBackView.frame = tFrame;
        
        _iTKEduWhiteBoardView.frame = _whiteboardBackView.bounds;
        
        if (!self.iMediaView.hasVideo) {
            [self restoreMp3ViewFrame];
        }
        [_iSessionHandle.whiteBoardManager refreshWhiteBoard];
        
        if (self.iMvVideoDic) {

            [self moveVideo:self.iMvVideoDic];

        }
    }
    [self refreshVideosBackView];
    self.splitScreenView.frame = self.whiteboardBackView.frame;
    
}

#pragma mark - 播放视频
-(void)playVideo:(TKRoomUser*)user {
    
    // 最大视频数判断
    if (_iSessionHandle.onPlatformNum >= sMaxVideo) {
        return;
    }
    // 低功耗设备 和配置项  只观看老师和自己的视频音频
    if ( (![TKUtil  deviceisConform] || _roomJson.configuration.onlyMeAndTeacherVideo) && //  配置项
        _iSessionHandle.roomMgr.localUser.role == TKUserType_Student && // 本地是学生
        user.role != TKUserType_Teacher && // 不是老师
        ![user.peerID isEqualToString: _iSessionHandle.roomMgr.localUser.peerID]) { // 不是自己
        
        return;
        
    }
    
    // 查找可用 VideoSmallview
    TKCTVideoSmallView * vsView = nil;
    
    if (user.role == TKUserType_Teacher) {
        
        vsView = self.iTeacherVideoView;
        
    } else {
        
        for (TKCTVideoSmallView *view in self.iStudentVideoViewArray) {
            if(view.iVideoViewTag == -1){// 老师
                continue;
            }
            if([view.iRoomUser.peerID isEqualToString:user.peerID]) {
                vsView = view;
                break;
            }
            else if(view.iRoomUser == nil) {
                vsView = view;
                break;
            }
        }
    }
    
    [self playVideo:user view:vsView];
}

- (void) playVideo:(TKRoomUser*)user view:(TKCTVideoSmallView *)vsView {

    if (vsView) {
        
        [_iSessionHandle sessionHandlePlayVideo:user.peerID
                                     renderType:(TKRenderMode_adaptive)
                                         window:vsView completion:^(NSError *error)
         {
             if (!error) {
                 
                 vsView.iPeerId        = user.peerID;
                 vsView.iRoomUser      = user;
                 [vsView changeName:user.nickName];
                 //进入后台的提示
                 [vsView endInBackGround:[user.properties[sIsInBackGround] boolValue]];
                 
                 [_iPlayVideoViewDic setObject:vsView forKey:user.peerID];
                 _iSessionHandle.onPlatformNum = _iPlayVideoViewDic.count;
                 
                 //如果文档处于全屏模式下则不进行刷新界面
                 if (!_iSessionHandle.iIsFullState) {
                     [self refreshUI];
                 }
             }
         }];
        
        [_iSessionHandle sessionHandlePlayAudio:user.peerID completion:^(NSError *error) {
            //这个block根本不回调
        }];
    }
}

-(void)unPlayVideo:(NSString *)peerID {
    
    TKCTVideoSmallView* vsView = nil;
    // 老师
    if ([peerID isEqualToString:self.iTeacherVideoView.iPeerId]){
        vsView = self.iTeacherVideoView;
    }
    else{
        for (TKCTVideoSmallView* view in self.iStudentVideoViewArray) {
            if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:peerID]) {
                vsView = view;
                break;
            }
        }
        // 继续在分屏视频数组中寻找
        if (vsView == nil) {
            NSArray *splitA = [NSArray arrayWithArray:self.splitScreenView.videoSmallViewArray];
            for (TKCTVideoSmallView* view in splitA) {
                if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:peerID]) {
                    vsView = view;
                    break;
                }
            }
        }
    }
    if (vsView) {
        
        __weak typeof(self)weekSelf = self;

        for (NSString *peer in _iStudentSplitScreenArray) {
            if([peerID isEqualToString:peer]) {
                vsView.isSplit = YES;
                [self beginTKSplitScreenView:vsView];
            }
        }
        [_iSessionHandle sessionHandleUnPlayVideo:peerID completion:^(NSError *error) {
            //更新
            if (!error) {
               
                [_iPlayVideoViewDic removeObjectForKey:peerID];
                _iSessionHandle.onPlatformNum = _iPlayVideoViewDic.count;
                
                __strong typeof(weekSelf) strongSelf =  weekSelf;
                
                [vsView clearVideoData];
                
                [vsView removeFromSuperview];

                // 更新UI
                [strongSelf updateMvVideoForPeerID:peerID];
                
                if (!self.iSessionHandle.iIsFullState)[strongSelf refreshUI];

            }
        }];

        [_iSessionHandle sessionHandleUnPlayAudio:peerID completion:^(NSError *error) {
            
        }];
    }
}

-(void)updateMvVideoForPeerID:(NSString *)aPeerId {
    
    NSDictionary *tVideoViewDic = (NSDictionary*) [_iMvVideoDic objectForKey:aPeerId];
    NSMutableDictionary *tVideoViewDicNew = [NSMutableDictionary dictionaryWithDictionary:tVideoViewDic];
    [tVideoViewDicNew setObject:@(NO) forKey:@"isDrag"];
    [tVideoViewDicNew setObject:@(0) forKey:@"percentTop"];
    [tVideoViewDicNew setObject:@(0) forKey:@"percentLeft"];
    [_iMvVideoDic setObject:tVideoViewDicNew forKey:aPeerId];
}


-(void)leftButtonPress{
    if (_isQuiting) {return;}
    [self tapTable:nil];
    
    TKAlertView *alert = [[TKAlertView alloc]initForWarningWithTitle:MTLocalized(@"Prompt.prompt") contentText:MTLocalized(@"Prompt.Quite") leftTitle:MTLocalized(@"Prompt.Cancel") rightTitle:MTLocalized(@"Prompt.OK")];
    [alert show];
    tk_weakify(self);
    alert.rightBlock = ^{
        weakSelf.isQuiting = YES;
        [weakSelf prepareForLeave:YES];
    };
    alert.lelftBlock = ^{
        weakSelf.isQuiting = NO;
    };
    
}

//如果是自己退出，则先掉leftroom。否则，直接退出。
-(void)prepareForLeave:(BOOL)aQuityourself
{    _isQuiting = NO;
    _iSessionHandle.iIsJoined = NO;
    
    [self tapTable:nil];
    [self.navbarView destory];
    self.navbarView = nil;
    [_chatView dismissAlert];
    [self.chatViewNew hide:YES];
    
    [_controlView dismissAlert];
    [_listView dismissAlert];
    
    [_iSessionHandle configureHUD:@"" aIsShow:NO];
    
    [_iSessionHandle configurePlayerRoute:NO isCancle:YES];
    [_iSessionHandle delUserStdntAndTchr:_iSessionHandle.localUser];
    [_iSessionHandle delUser:_iSessionHandle.localUser];
    
    
    [self invalidateTimer];
    
#if TARGET_IPHONE_SIMULATOR
#else
    [[UIDevice currentDevice] setProximityMonitoringEnabled: NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
#endif
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    if (aQuityourself) {
        [self unPlayVideo:_iSessionHandle.localUser.peerID];         // 进入教室不点击上课就退出，需要关闭自己视频
        [_iSessionHandle sessionHandleLeaveRoom:NO Completion:^(NSError * _Nonnull error) {
            TKLog(@"退出房间错误: %@", error);
        }];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
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
            
            [self clearAllData];
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
    [TKEduNetManager getGiftinfo:_roomJson.roomid aParticipantId: _roomJson.roomid  aHost:sHost aPort:sPort aGetGifInfoComplete:^(id  _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int result = 0;
            result = [[response objectForKey:@"result"]intValue];
            if (!result || result == -1) {
                
                NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                int giftnumber = 0;
                for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                    if (_iUserType != TKUserType_Teacher && _roomJson.roomid) {
                        NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                        if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:_roomJson.roomid]) {
                            giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
                            break;
                        }
                    }
                }
                
                self.iSessionHandle.localUser.properties[sGiftNumber] = @(giftnumber);
                
                if (completion) {
                    completion();
                }
            }
        });
        
    } aGetGifInfoError:^int(NSError * _Nullable aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion();
            }
            
        });
        return 1;
    }];
    
}

//自己进入课堂
- (void)sessionManagerRoomJoined {
    
    NSLog(@"sessionManagerRoomJoined %@", _iSessionHandle.localUser.peerID);
    
    _isConnect					= NO;
    _isQuiting					= NO;
    _networkRecovered			= YES;
    _iSessionHandle.iIsJoined	= YES;
    _iTKEduWhiteBoardView.hidden= NO;
    _iCurrentTime = [[NSDate date]timeIntervalSince1970];
    //回放直接隐藏聊天界面
    //    self.chatViewNew.hidden = _iSessionHandle.isPlayback;
    //根据角色类型选择隐藏聊天按钮
    [self.chatViewNew setUserRoleType:[TKEduSessionHandle shareInstance].localUser.role];
    
    // 主动获取奖杯数目
    [self getTrophyNumber];
    
    bool isConform = [TKUtil deviceisConform];
    if (_iUserType == TKUserType_Teacher) {
        
        [_iSessionHandle.msgList removeAllObjects];
        if (!isConform) {
            NSString *str = [TKUtil dictionaryToJSONString:@{@"lowconsume":@YES, @"maxvideo":@(2)}];
            [_iSessionHandle sessionHandlePubMsg:sLowConsume ID:sLowConsume To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        } else {
            NSString *str = [TKUtil dictionaryToJSONString:@{@"lowconsume":@NO, @"maxvideo":@(_roomJson.maxvideo.intValue)}];
            [_iSessionHandle sessionHandlePubMsg:sLowConsume ID:sLowConsume To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        }
    }
    
    // 低能耗老师进入一对多房间，进行提示
    if (!isConform && _iSessionHandle.localUser.role == TKUserType_Teacher && _iRoomType != TKRoomTypeOneToOne) {
        NSString *message = [NSString stringWithFormat:@"%@", MTLocalized(@"Prompt.devicetPrompt")];
        TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:_iSessionHandle.localUser.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:TKMessageTypeMessage aMessage:message aUserName:_iSessionHandle.localUser.nickName aTime:[TKUtil currentTimeToSeconds]];
        [_iSessionHandle  addOrReplaceMessage:chatMessageModel];
        
    }
    
    // 如果断网之前在后台，回到前台时的时候需要发送回到前台的信令
    if ([_iSessionHandle.localUser.properties objectForKey:@"isInBackGround"] &&
        [[_iSessionHandle.localUser.properties objectForKey:@"isInBackGround"] boolValue] == YES &&
        _iSessionHandle.localUser.role == TKUserType_Student &&
        _iSessionHandle.roomMgr.inBackground == NO) {
        
        [_iSessionHandle  sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(NO) completion:nil];
    }
    
    bool tIsTeacherOrAssis  = (_iSessionHandle.localUser.role ==TKUserType_Teacher || _iSessionHandle.localUser.role ==TKUserType_Assistant);
    //巡课不能翻页
    if (_iSessionHandle.localUser.role == TKUserType_Patrol || _iSessionHandle.isPlayback) {
        [_iSessionHandle configurePage:false isSend:NO to:sTellAll peerID:_iSessionHandle.localUser.peerID];
    }else {
        
        // 翻页权限根据配置项设置
        [_iSessionHandle configurePage:tIsTeacherOrAssis?true:_roomJson.configuration.canPageTurningFlag
                                isSend:NO
                                    to:sTellAll
                                peerID:_iSessionHandle.localUser.peerID];
        
    }
    TKLog(@"tlm-----myjoined 时间: %@", [TKUtil currentTimeToSeconds]);
#if TARGET_IPHONE_SIMULATOR
#else
    [[UIDevice currentDevice] setProximityMonitoringEnabled: NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
#endif
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
//    _iUserType       = (TKUserType)_iSessionHandle.localUser.role;
//    _iRoomType       = _roomJson.roomtype;

    [_iSessionHandle addUserStdntAndTchr:_iSessionHandle.localUser];
    [_iSessionHandle addUser:_iSessionHandle.localUser];
    
    [_iSessionHandle configureHUD:@"" aIsShow:NO];
    
    [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:_iSessionHandle.localUser.peerID Data:@"" Save:NO AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
    

    
    //是否是自动上课
    if (_roomJson.configuration.autoStartClassFlag == YES &&
        _iSessionHandle.isClassBegin == NO &&
        _iSessionHandle.localUser.role == TKUserType_Teacher) {
        
        // 只有手动点击上下课时传 userid roleid
        [TKEduNetManager classBeginStar:_roomJson.roomid companyid:_roomJson.companyid aHost:sHost aPort:sPort userid:nil roleid:nil aComplete:^int(id  _Nullable response) {
            
            
            NSString *str = [TKUtil dictionaryToJSONString:@{@"recordchat":@YES}];
            [_iSessionHandle  sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
            [_iSessionHandle configureHUD:@"" aIsShow:NO];
            
            return 0;
        }aNetError:^int(id  _Nullable response) {
            
            [_iSessionHandle configureHUD:@"" aIsShow:NO];
            
            return 0;
        }];
    }
    
    if(_iSessionHandle.isClassBegin == NO || _iUserType == TKUserType_Teacher){
        
        // 进入房间就可以播放自己的视频
        if (_iUserType != TKUserType_Patrol && _iSessionHandle.isPlayback == NO) {
            
            if (_roomJson.configuration.beforeClassPubVideoFlag) {//发布视频(告诉所有人)
                
                _isLocalPublish = NO;
                
                NSInteger i = _iTeacherVideoView.iRoomUser ? sMaxVideo : 6;
                if (_iPlayVideoViewDic.count < i) {
                    [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID
                                                            Publish:TKPublishStateBOTH
                                                         completion:nil];
                }
            } else {//显示本地视频不发布
                
                _isLocalPublish = YES;
                _iSessionHandle.localUser.publishState = TKPublishStateLocalNONE;
                [_iSessionHandle  configurePlayerRoute:NO isCancle:NO];
                [self playVideo:_iSessionHandle.localUser];
            }
        }
    }
}

//自己离开课堂
- (void)sessionManagerRoomLeft {
    
    _isQuiting = NO;
    _iSessionHandle.iIsJoined = NO;
    [_iSessionHandle configurePlayerRoute:NO isCancle:YES];
    [_iSessionHandle delUserStdntAndTchr:_iSessionHandle.localUser];
    [_iSessionHandle delUser:_iSessionHandle.localUser];
    [_iSessionHandle configureHUD:@"" aIsShow:NO];
    
    // 清理数据
    [self quitClearData];
    
    [_iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
    [_iSessionHandle.whiteBoardManager clearAllData];
    _iSessionHandle.whiteBoardManager = nil;
    [_iSessionHandle clearAllClassData];
    _iSessionHandle.roomMgr = nil;
    [TKEduSessionHandle destroy];
    
    _iSessionHandle = nil;
    [self prepareForLeave:NO];
}

//用户进入
- (void)sessionManagerUserJoined:(TKRoomUser *)user InList:(BOOL)inList {
    
    // 提示用户进入信息(巡课不提示)
    if (user.role != TKUserType_Patrol) {
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
        TKChatMessageModel *tModel = [[TKChatMessageModel alloc]initWithFromid:0 aTouid:0
                                                                  iMessageType:TKMessageTypeMessage
                                                                      aMessage:[NSString stringWithFormat:@"%@(%@)%@",user.nickName,userRole, MTLocalized(@"Action.EnterRoom")]
                                                                     aUserName:nil
                                                                         aTime:[TKUtil currentTime]];
        [_iSessionHandle addOrReplaceMessage:tModel];
    }
    
    // 提示用户进入信息(后台的学生)
    if (_iUserType == TKUserType_Teacher || _iUserType == TKUserType_Assistant || _iUserType == TKUserType_Patrol) {
        
        if ([user.properties objectForKey:sIsInBackGround] != nil &&
            [[user.properties objectForKey:sIsInBackGround] boolValue] == YES) {
            
            NSString *deviceType = [user.properties objectForKey:@"devicetype"];
            NSString *message = [NSString stringWithFormat:@"%@ (%@) %@", user.nickName, deviceType, MTLocalized(@"Prompt.HaveEnterBackground")];
            TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:user.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:TKMessageTypeMessage aMessage:message aUserName:user.nickName aTime:[TKUtil currentTime]];
            [_iSessionHandle  addOrReplaceMessage:chatMessageModel];
            
        }
    }
    if (inList) {
        // 踢人
        if (_iSessionHandle.localUser.role == user.role && user.role == TKUserType_Teacher) {
            
            [_iSessionHandle sessionHandleEvictUser:user.peerID evictReason:nil completion:nil];
            return;
        }
        // 允许助教上台的1对1房间 ,  会创建一对多的房间显示.
        else if(_iSessionHandle.localUser.role == user.role && user.role == TKUserType_Student &&_iRoomType == TKRoomTypeOneToOne) {
            
            [_iSessionHandle sessionHandleEvictUser:user.peerID evictReason:nil completion:nil];
            return;
        }
        
    }
    // 房间用户
    BOOL tISpclUser = (user.role !=TKUserType_Student && user.role != TKUserType_Teacher);
    if (tISpclUser) {
        [_iSessionHandle addSecialUser:user];
        
    }else{
        [_iSessionHandle addUserStdntAndTchr:user];
    }
    [_iSessionHandle addUser:user];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:tkUserListNotification object:nil];
    
    // 上台
    if (user.publishState > TKPublishStateNONE) {
        [self playVideo:user];
    }
    
//    //自动上课逻辑
//    if (_iRoomType == TKRoomTypeOneToOne && _iSessionHandle.isClassBegin == NO) {
//
//        if ((_iUserType == TKUserType_Teacher && user.role == TKUserType_Student) ||
//            (_iUserType == TKUserType_Student && user.role == TKUserType_Teacher))
//        {
//            [_navbarView.beginAndEndClassButton setSelected:YES];
//            [_navbarView.beginAndEndClassButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//            
//        }
//    }

}

//用户离开
- (void)sessionManagerUserLeft:(NSString *)peerID {
    
    TKRoomUser *user = [_iSessionHandle getUserWithPeerId:peerID];
    
    if (!peerID || !user) {
        return;
    }
    
//    [self unPlayVideo:peerID];
    
    BOOL tIsMe = [[NSString stringWithFormat:@"%@",peerID] isEqualToString:[NSString stringWithFormat:@"%@",_iSessionHandle.localUser.peerID]];
    
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
    {[_iSessionHandle delSecialUser:user];}
    else
    {[_iSessionHandle delUserStdntAndTchr:user];}
    [_iSessionHandle  delUser:user];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:tkUserListNotification
                                                        object:nil];
    
    // 检查是否是演讲人离开
    NSArray * peerArr = [NSArray arrayWithArray:_iStudentSplitScreenArray];
    if (_iSessionHandle.localUser.role == TKUserType_Teacher && [peerArr containsObject:peerID]) {
        [_iStudentSplitScreenArray removeObject:user.peerID];
        
        NSString *str = [TKUtil dictionaryToJSONString:@{@"userIDArry":_iStudentSplitScreenArray}];
        
        [_iSessionHandle sessionHandlePubMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
    }
    [self refreshVideosBackView];
}

// 被踢
-(void)sessionManagerSelfEvicted:(NSDictionary *)reason {
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
                
                //[self showMessage:rea==1?MTLocalized(@"KickOut.SentOutClassroom"):MTLocalized(@"KickOut.Repeat")];
                _iPickerController = nil;
                [self sessionManagerRoomLeft];
            }];
        }else{
            //[self showMessage:rea==1?MTLocalized(@"KickOut.SentOutClassroom"):MTLocalized(@"KickOut.Repeat")];
            [self sessionManagerRoomLeft];
            TKLog(@"---------SelfEvicted");
        }
    };
}
//用户的音频音量大小变化的回调
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

//用户视频状态变化
- (void)sessionManagerVideoStateWithUserID:(NSString *)peerID publishState:(TKMediaState)state{
    
    TKRoomUser *user = [_iSessionHandle.roomMgr getRoomUserWithUId:peerID];
    if (!user || user.role == TKUserType_Patrol) {
        return;
    }
    TKLog(@"sessionManagerVideoStateWithUserID %@", user.nickName);
    if (_iSessionHandle.isPicInPic && user.role == TKUserType_Teacher) {
        if (self.iTeacherVideoView.superview != [UIApplication sharedApplication].keyWindow && TKMedia_Pulished) {
            [[UIApplication sharedApplication].keyWindow addSubview:_iTeacherVideoView];
        }
        self.iTeacherVideoView.hidden = !state;
    }
    if (state == TKMedia_Pulished){
    	// 台下用户才需要play 上台.
        if (![self.iPlayVideoViewDic objectForKey:user.peerID]) {
            
            [self playVideo:user];
        }
    }
    else {
        if (user.publishState == TKUser_PublishState_NONE){
        
            [_iSessionHandle delePublishUser:user];
            
            // 老师发布的视频下课不取消播放
            if (user.role != TKUserType_Teacher && _iSessionHandle.isClassBegin != NO) {
                
                return;
            }
            [self unPlayVideo:peerID];
            
        }
    }
    
    if (_iSessionHandle.localUser.role == TKUserType_Teacher && _iMvVideoDic) {
        NSDictionary *tMvVideoDic = @{@"otherVideoStyle":_iMvVideoDic};
        [_iSessionHandle publishVideoDragWithDic:tMvVideoDic To:sTellAllExpectSender];
    }
    
    if (_iSessionHandle.iHasPublishStd == NO && !_iSessionHandle.iIsFullState) {
        [self refreshUI];
    }
    
        
    
}

//用户音频状态变化
- (void)sessionManagerAudioStateWithUserID:(NSString *)peerID publishState:(TKMediaState)state {
    TKRoomUser *user = [_iSessionHandle.roomMgr getRoomUserWithUId:peerID];
    
    if (!user || user.role == TKUserType_Patrol) {
        return;
    }
    
    if (state == TKMedia_Pulished)
    {
        // 台下 -> 开启音频 -> 上台
        if (![self.iPlayVideoViewDic objectForKey:user.peerID]) {
            [self playVideo:user];
        }
    }
    else
    {
        if (user.publishState == TKUser_PublishState_NONE){
            
            [_iSessionHandle delePublishUser:user];
            
            if (!(_iSessionHandle.localUser.role == TKUserType_Teacher &&
                  _iSessionHandle.isClassBegin == NO &&
                  user.role == TKUserType_Teacher)) {
                // 老师发布的视频下课不取消播放
                [self unPlayVideo:peerID];
            }
        }
        
        if ((_iSessionHandle.localUser.role == TKUserType_Teacher) && _iMvVideoDic) {
            NSDictionary *tMvVideoDic = @{@"otherVideoStyle":_iMvVideoDic};
            [_iSessionHandle  publishVideoDragWithDic:tMvVideoDic To:sTellAllExpectSender];
        }
        
        if (_iSessionHandle.iHasPublishStd == NO && !_iSessionHandle.iIsFullState) {
            [self refreshUI];
        }
    }
    
}

//用户信息变化
- (void)sessionManagerUserChanged:(TKRoomUser *)user Properties:(NSDictionary*)properties fromId:(NSString *)fromId {
    
    TKLog(@"sessionManagerUserChanged - properties %@ - fromid - %@", [properties description], fromId);
    
    NSInteger tGiftNumber = 0;
    if ([properties objectForKey:sGiftNumber]) {
        
        tGiftNumber = [[properties objectForKey:sGiftNumber]integerValue];
    }
    
    if ([properties objectForKey:sCandraw]){
        
        BOOL canDraw = [[properties objectForKey:sCandraw] boolValue];
        if ([_iSessionHandle.localUser.peerID isEqualToString:user.peerID] &&
            _iSessionHandle.localUser.role == TKUserType_Student) {
            
            if (_iSessionHandle.iIsCanDraw != canDraw) {
                
                [_iSessionHandle configureDraw:canDraw isSend:NO to:sTellAll peerID:user.peerID];

            }
        }
        if (canDraw) {
            if (user.role == TKUserType_Student && ![self.iPlayVideoViewDic objectForKey:user.peerID]) {
                [self playVideo:user];
            }
        }
        // 授权画笔
        if(_iUserType == TKUserType_Teacher) {
            self.brushToolView.hidden    = NO;
        }
        else if(_iUserType == TKUserType_Patrol) { // 巡课
            self.brushToolView.hidden    = YES;
        }
        else {
            if ([_iSessionHandle.localUser.peerID isEqualToString:user.peerID] ) {
                self.brushToolView.hidden = !canDraw;
                [self.brushToolView hideSelectorView];
            }
        }
        
        /*
         两个配置项：
         1.允许学生翻页 2.禁止学生翻页，两者不可能同时勾选
         当1为YES， 学生可以本地翻页，授权后可以同步翻页（每次翻页会发送信令，其他学生能同步）
         当2为YES， 学生不可以本地翻页，授权后不可以同步翻页（每次翻页会发送信令，其他学生能同步）
         当1和2为都为No， 学生不可以本地翻页，授权后可以同步翻页（每次翻页会发送信令，其他学生能同步）
         */
        if (user.role == TKUserType_Student
            && [_iSessionHandle.localUser.peerID isEqualToString:user.peerID]){
            
//            if (_roomJson.configuration.canPageTurningFlag) {
//                _pageControl.disenablePaging = !canDraw;
//            }
            
            if (_roomJson.configuration.isHiddenPageFlip){
                _pageControl.disenablePaging = YES;
            }
            
            if (!_roomJson.configuration.isHiddenPageFlip && !_roomJson.configuration.canPageTurningFlag){
                _pageControl.disenablePaging = !canDraw;
            }

        }
    }
    // 举手
    BOOL isRaiseHand = NO;
    if ([properties objectForKey:sRaisehand]) {
        //如果没做改变的话，就不变化
        
        isRaiseHand  = [[properties objectForKey:sRaisehand] boolValue];
        self.navbarView.showRedDot = isRaiseHand;
        [self.navbarView showHandsupTips:isRaiseHand];
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
            //当为老师时
            if (_iSessionHandle.localUser.role == TKUserType_Teacher){
                // 分屏
                if([_iStudentSplitScreenArray containsObject:user.peerID])
                {
                    [_iStudentSplitScreenArray removeObject:user.peerID];
                    
                    NSString *str = [TKUtil dictionaryToJSONString:@{@"userIDArry":_iStudentSplitScreenArray}];
                    
                    [_iSessionHandle sessionHandlePubMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
                }
            }
            else if (_iSessionHandle.localUser.role == TKUserType_Student) {// 下台删除 抢答器
                if (self.responderView) {
                    [self.responderView removeFromSuperview];
                    self.responderView = nil;
                }
            }
            if ([self.iPlayVideoViewDic objectForKey:user.peerID]) {
                
                [self unPlayVideo:user.peerID];
            }
        }

    }
    
    //更改上台后的举手按钮样式
    if (_iUserType == TKUserType_Student && [_iSessionHandle.localUser.peerID isEqualToString:user.peerID]) {
        
        if (isRaiseHand) {
            if (_iSessionHandle.localUser.publishState > TKUser_PublishState_NONE) {
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
    
    if ([properties objectForKey:sServerName]) {//更改服务器
        
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
    
    
    if ([properties objectForKey:sPrimaryColor]) {//画笔颜色值
        
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
            [[NSNotificationCenter defaultCenter] postNotificationName:sEveryoneBanChat object:dict];
        }
    }
    
    NSDictionary *dict = @{
                           sRaisehand:[properties objectForKey:sRaisehand]?[properties objectForKey:sRaisehand]:@(isRaiseHand),
                           
                           sPublishstate:[properties objectForKey:sPublishstate]?[properties objectForKey:sPublishstate]:@(user.publishState),
                           sCandraw:[properties objectForKey:sCandraw]?[properties objectForKey:sCandraw]:@(user.canDraw),
                           sGiftNumber:@(tGiftNumber),
                           sDisableAudio:[properties objectForKey:sDisableAudio]?@([[properties objectForKey:sDisableAudio] boolValue]):@(user.disableAudio),
                           sDisableVideo:[properties objectForKey:sDisableVideo]?@([[properties objectForKey:sDisableVideo] boolValue]):@(user.disableVideo),
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
            if (self.chatViewNew) {
                [self.chatViewNew reloadData];
            }
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
        //        [self.messageView messageReceived:message fromID:peerID extension:extension];
        [self.chatViewNew messageReceived:message fromID:peerID extension:extension];
        
    }else{
        
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
        
        //        TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:user.peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:user.nickName aTime:[NSString stringWithFormat:@"%f",[TKUtil getNowTimeTimestamp]]];
        
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
    [self clearAllData];
    
    [_pageControl resetBtnStates];
    
    //上下课按钮设置为“上课”
    [_navbarView.beginAndEndClassButton setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
}

// 共享屏幕
- (void)sessionManagerOnShareScreenState:(NSString *)peerId state:(TKMediaState)state {
    
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
        
        [_iSessionHandle  sessionHandlePlayScreen:peerId renderType:0 window:_iScreenView completion:nil];
        
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
        [_iSessionHandle  sessionHandlePlayFile:peerId renderType:0 window:_iFileView completion:^(NSError *error) {
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
- (void)sessionManagerIceStatusChanged:(NSString*)state ofUser:(TKRoomUser *)user {
    TKLog(@"------IceStatusChanged:%@ nickName:%@",state,user.nickName);
}

//相关信令 pub
- (void)sessionManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist{
    
    TKLog(@"TKManyView sessionManagerOnRemoteMsg======> msgName:%@ msgID:%@ add:%d data:%@",msgName,msgID,add,data);
    
    add = (BOOL)add;
    if ([msgName isEqualToString:sClassBegin]) {
        
        _iSessionHandle.isClassBegin = add;
        _iSessionHandle.whiteBoardManager.isBeginClass = add;
        
        [self.navbarView refreshUI:add];
        
        // 上课
        if (add == YES) {
            
            [self onRemoteMsgWithClassBegin:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        }
        // 下课
        else{
            
            [self onRemoteMsgWithClassEnd:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        }
        
        // 刷新navbar
        [self.navbarView buttonRefreshUI];
        [self refreshUI];
        [self.pageControl setup];
    }
    // 更新时间
    else if ([msgName isEqualToString:sUpdateTime]) {
        
        if (add) {
            [self onRemoteMsgWithUpdateTime:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        }
        
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
        
        [self onRemoteMsgWithStreamFailure:add ID:msgID Name:msgID TS:ts Data:data InList:inlist];
        
    }
    // 拖拽回调
    else if ([msgName isEqualToString:sVideoDraghandle]){
        
        [self onRemoteMsgWithVideoDraghandle:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
    }
    // 更改服务器
    else if ([msgName isEqualToString:sChangeServerArea]){
        
    }
    // pc双击视频响应 只做响应
    else if ([msgName isEqualToString:sDoubleClickVideo]){
        
        [self onRemoteMsgWithDoubleClickVideo:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        
    }
    // 分屏回调
    else if ([msgName isEqualToString:sVideoSplitScreen]){
        
        [self onRemoteMsgWithVideoSplitScreen:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        
    }
    // 缩放回调
    else if ([msgName isEqualToString:sVideoZoom]) {
        
        [self onRemoteMsgWithVideoZoom:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
    }
    // 视频标注回调
    else if ([msgName isEqualToString:sVideoWhiteboard]){
        
        [self onRemoteMsgWithVideoWhiteboard:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
    }
    // 大并发教室
    else if ([msgName isEqualToString:sBigRoom]) {
        
        _iSessionHandle.bigRoom = YES;
    }
    // 全体禁言
    else if([msgName isEqualToString:sEveryoneBanChat]){
        
        [self onRemoteMsgWithEveryoneBanChat:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
    }
    // 音频教室
    else if([msgName isEqualToString:sOnlyAudioRoom]){
        _iSessionHandle.isOnlyAudioRoom = add;
        [[NSNotificationCenter defaultCenter] postNotificationName:sInOnlyAudioRoom object:nil];
        
    }
    // 白板全屏(同步)
    else if ([msgName isEqualToString:sWBFullScreen]) {
        
        [self onRemoteMsgWithWBFullScreen:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
    }
    // 小白板
    else if([msgName isEqualToString:@"BlackBoard_new"] && add == YES){
        [self.chatViewNew hide:YES];
    }
    // 工具箱 转盘
    else if([msgName isEqualToString:@"dial"] ){
        
        NSDictionary *dataDic = [self convertWithData:data];
        if (add) {
            if (!_dialView) {
                
                UIView * toolBV = _whiteboardBackView;
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
        
    }
    else if ([msgName isEqualToString:sTimer]) {// 计时器
        [self onRemoteMsgWithShowTimerWithAdd:add andData:data receiveMsgTime:ts];
        
    }
    // 抢答器
    else if ([msgName isEqualToString:sQiangDaQi] || [msgName isEqualToString:sQiangDaZhe] || [msgName isEqualToString:sResponderDrag]) {
        
        [self onRemoteMsgWithResponderView:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
    }
    else if ([msgName isEqualToString:@"Question"]){
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
            [[TKAnswerSheetData shareInstance] resetData];
        }
        
        
    }
    else if ([msgName isEqualToString:@"PublishResult"]){
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
}

- (void)handleAnswerSheet
{
    
}

#pragma mark - 远程信令处理方法
- (void)onRemoteMsgWithClassBegin:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    [self invalidateClassCurrentTime];
    
    // 白板退出全屏
    if (_iSessionHandle.iIsFullState == YES) {
        // 本地
        [[NSNotificationCenter defaultCenter] postNotificationName:sChangeWebPageFullScreen object:@(NO)];
    }
    
    // 上课之前将自己的音视频关掉
    if (_roomJson.configuration.autoOpenAudioAndVideoFlag == NO && _isLocalPublish == YES) {
        
        _iSessionHandle.localUser.publishState = TKUser_PublishState_NONE;
        [self unPlayVideo:_iSessionHandle.localUser.peerID];
        
    }
    
    if (_iUserType == TKUserType_Student && _roomJson.configuration.autoOpenAudioAndVideoFlag == NO ) {
        
        if (_roomJson.configuration.beforeClassPubVideoFlag == YES || _isLocalPublish == NO) {
            
            if (_iSessionHandle.localUser.publishState != TKPublishStateNONE ) {
                
                _isLocalPublish = NO;
                [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKPublishStateNONE) completion:nil];
            }
        }
    }
    
    if (_iUserType == TKUserType_Teacher && _iSessionHandle.isPlayback == NO)
    {
        
        if (_iSessionHandle.localUser.publishState != TKPublishStateBOTH)
        {
            _isLocalPublish = false;
            [_iSessionHandle  sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKPublishStateBOTH) completion:nil];
        }
        
    }
    if (_iSessionHandle.isPlayback == YES)
    {
        
        if ((self.playbackMaskView.iProgressSlider.value < 0.01 && self.playbackMaskView.playButton.isSelected == YES) ||
            _iSessionHandle.isPlayback == NO) {
            [TKUtil showMessage:MTLocalized(@"Class.Begin")];
        }
    }
    else
    {
        if (_roomJson.configuration.beforeClassPubVideoFlag == NO) {
            if (_iUserType == TKUserType_Teacher || (_iUserType == TKUserType_Student && _roomJson.configuration.autoOpenAudioAndVideoFlag)) {
                
                if (_iSessionHandle.localUser.publishState != TKPublishStateBOTH) {
                    _isLocalPublish = false;
                    [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKPublishStateBOTH) completion:nil];
                }
                
            }
        }
        else if(_iUserType == TKUserType_Teacher && _roomJson.configuration.autoOpenAudioAndVideoFlag){
            if (_iSessionHandle.localUser.publishState != TKPublishStateBOTH) {
                _isLocalPublish = false;
                [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKPublishStateBOTH) completion:nil];
            }
        }
        else if(_iUserType == TKUserType_Student && _roomJson.configuration.autoOpenAudioAndVideoFlag){
            if (_iSessionHandle.localUser.publishState != TKPublishStateBOTH) {
                _isLocalPublish = false;
                [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(TKPublishStateBOTH) completion:nil];
            }
        }
    }
    
    _iClassStartTime = ts;
    bool tIsTeacherOrAssis  = (_iUserType==TKUserType_Teacher || _iUserType == TKUserType_Assistant);
    
    //如果是1v1并且是学生角色
    BOOL isStdAndRoomOne = (_iRoomType == TKRoomTypeOneToOne && (_iSessionHandle.localUser.role == TKUserType_Student));
    
    /*
     涂鸦权限:
     1.1v1学生根据配置项设置
     2.其他情况，没有涂鸦权限
     3 非老师断线重连不可涂鸦。
     发送:1 1v1 学生发送 2 学生发送，老师发送
     */
    [_iSessionHandle configureDraw:isStdAndRoomOne? _roomJson.configuration.canDrawFlag : tIsTeacherOrAssis
                            isSend:YES
                                to:sTellAll
                            peerID:_iSessionHandle.localUser.peerID];
    if (tIsTeacherOrAssis) {
        [self.brushToolView setHidden:NO];
    }
    
    
    //如果是学生需要重新设置翻页
    [_iSessionHandle configurePage: _roomJson.configuration.canDrawFlag ?true:_roomJson.configuration.canPageTurningFlag isSend:NO to:sTellAll peerID:isStdAndRoomOne?_iSessionHandle.localUser.peerID:@""];
    
    [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:_iSessionHandle.localUser.peerID Data:@"" Save:false AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:^(NSError *error) {
        
    }];
    
    [self startClassBeginTimer];
    
}

- (void)onRemoteMsgWithClassEnd:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    //未到下课时间： 老师点下课 —> 下课后不离开教室 _iSessionHandle.roomMgr.forbidLeaveClassFlag->下课时间到，课程结束，一律离开
    if (_roomJson.configuration.forbidLeaveClassFlag && _roomJson.configuration.endClassTimeFlag) {
        _iClassCurrentTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                               target:self
                                                             selector:@selector(onClassCurrentTimer)
                                                             userInfo:nil
                                                              repeats:YES];
        [_iClassCurrentTimer setFireDate:[NSDate date]];
    }
    
    //重置距离下课还有5分钟的提醒项
    _isRemindClassEnd = NO;
    [TKUtil showMessage:MTLocalized(@"Class.Over")];
    
    // 隐藏授权 画笔 相机按钮
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TKTabbarViewHideICON" object:@{sCandraw: @(NO)}];
    
    BOOL isStdAndRoomOne = (_roomJson.roomtype == TKRoomTypeOneToOne && _iSessionHandle.localUser.role == TKUserType_Student);
    
    [_iSessionHandle configureDraw:isStdAndRoomOne?_roomJson.configuration.canDrawFlag:false isSend:YES to:sTellAll peerID:_iSessionHandle.localUser.peerID];
    
    //如果是1v1学生需要重新设置翻页
    [_iSessionHandle configurePage:_roomJson.configuration.canPageTurningFlag isSend:NO to:sTellAll peerID:isStdAndRoomOne?_iSessionHandle.localUser.peerID:@""];
    
    //将所有全屏的视频还原
    [self cancelSplitScreen:nil];
    //将所有拖拽的视频还原
    for (TKCTVideoSmallView *view  in self.iStudentVideoViewArray) {
        [self updateMvVideoForPeerID:view.iPeerId];
        view.isDrag = NO;
    }
    [self sendMoveVideo:self.iPlayVideoViewDic aSuperFrame:self.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
    
    [self refreshUI];
    [self invalidateClassBeginTime];
    
    [self tapTable:nil];
    if (_iSessionHandle.localUser.role ==TKUserType_Teacher) {
        /*删除所有信令的消息，从服务器上*/
//        if(!_roomJson.configuration.forbidLeaveClassFlag){
        //通知服务器清除 工具箱数据
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
    
    //防止ts是毫秒单位
    if (ts/10000000000 > 0) {
        ts = ts / 1000;
    }
    
    _iServiceTime = ts;
    _iLocalTime   = _iServiceTime - _iClassStartTime;
    _iHowMuchTimeServerFasterThenMe = ts - [[NSDate date] timeIntervalSince1970];

    
//    if (_iSessionHandle.isClassBegin) {
    
        if (![_iClassTimetimer isValid]) {
            
            _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(onClassTimer)
                                                              userInfo:nil
                                                               repeats:YES];
            [_iClassTimetimer setFireDate:[NSDate date]];
            
        }
        
//    }
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
    NSDictionary *tDataDic = [self convertWithData:data];
    NSString *tPeerId = [tDataDic objectForKey:@"studentId"];
    NSInteger failureType = [tDataDic objectForKey:@"failuretype"]?[[tDataDic objectForKey:@"failuretype"] integerValue] : 0;
    
    // 如果这个发布失败的用户是自己点击上台的，需要对自己进行上台失败错误原因进行提示。(只有助教)
    if ([_iSessionHandle getUserWithPeerId:tPeerId].role == TKUserType_Assistant){
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
                [TKUtil showMessage:[NSString stringWithFormat:@"%@%@",[_iSessionHandle  localUser].nickName,MTLocalized(@"Prompt.BackgroundCouldNotOnStage")]];//拼接上用户名
                break;
            case 5:
                [TKUtil showMessage:MTLocalized(@"Prompt.StudentUdpError")];
                break;
            default:
                break;
        }
    }
}

- (void)onRemoteMsgWithVideoDraghandle:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    for (TKCTVideoSmallView * view in _iStudentVideoViewArray) {
        [view hidePopMenu];
    }
    //分屏模式下取消functionView的显示
    for (TKCTVideoSmallView * view in _iStudentSplitViewArray) {
        [view hidePopMenu];
    }
    
    if(_iStudentSplitScreenArray.count>0 || _iSessionHandle.iIsFullState){
        return;
    }
    
    NSDictionary *tDataDic = [self convertWithData:data];
    NSDictionary *tMvVideoDic = [tDataDic objectForKey:@"otherVideoStyle"];
    _iMvVideoDic = [NSMutableDictionary dictionaryWithDictionary:tMvVideoDic];
    if(_iUserType == TKUserType_Student && inlist){
        
        [self updateMvVideoForPeerID:_iSessionHandle.localUser.peerID];
    }
    
    [self moveVideo:tMvVideoDic];
    
    
}

- (void)onRemoteMsgWithDoubleClickVideo:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    [self tapTable:nil];
    NSDictionary *tDataDic = [self convertWithData:data];
    
    // 白板上的拖拽视频还原
    for (TKCTVideoSmallView *view in self.iStudentVideoViewArray) {
        
        [self updateMvVideoForPeerID:view.iPeerId];
        view.isDrag = NO;
    }
    
    [self moveVideo:self.iMvVideoDic];
    
    // 移除原来的分屏视频
    if (_iStudentSplitViewArray.count) {
        
        NSArray *sArray = [NSArray arrayWithArray:_iStudentSplitViewArray];
        for (TKCTVideoSmallView *view in sArray) {
            view.isSplit = YES;
            [self beginTKSplitScreenView:view];
        }
    }

    //白板全屏状态下不执行分屏回调
    if (_iSessionHandle.iIsFullState) {
        return;
    }
    
    //{doubleId:,isScreen:}     // doubleId-peerID
    BOOL isScreen 		= [[tDataDic objectForKey:@"isScreen"] boolValue];
    NSString * doubleId = [NSString stringWithFormat:@"%@", [tDataDic objectForKey:@"doubleId"]];
    
    //双击的用户 可能没在台上
    TKCTVideoSmallView * tVideoView = [self.iPlayVideoViewDic objectForKey:doubleId];
    // 只看老师和自己时 学生显示老师拖到课件上的人的音视频，恢复后不在显示
    if (_roomJson.configuration.onlyMeAndTeacherVideo && _iSessionHandle.localUser.role == TKUserType_Student) {
        
        TKRoomUser * user = [_iSessionHandle.roomMgr getRoomUserWithUId:doubleId];
        
        if (user && !tVideoView && isScreen) {
            
            for (TKCTVideoSmallView *view in self.iStudentVideoViewArray) {
                if(view.iVideoViewTag == -1){// 老师
                    continue;
                }
                if([view.iRoomUser.peerID isEqualToString:doubleId]) {
                    tVideoView = view;
                    break;
                }
                else if(view.iRoomUser == nil) {
                    tVideoView = view;
                    break;
                }
            }
            
            if (tVideoView) {

                tVideoView.iRoomUser = user;
                [self beginTKSplitScreenView:tVideoView];
                [self playVideo:user view:tVideoView];
                return;
            }
        }
    }
    
    if (!tVideoView) {
        return;//（低功耗设备）
    }

    // 分屏隐藏白板
//    _iSessionHandle.whiteBoardManager.contentView.hidden = isScreen;
    if (isScreen && doubleId) {
        [_iStudentSplitScreenArray addObjectsFromArray:@[doubleId]];
    }
    
    [self sVideoSplitScreen:_iStudentSplitScreenArray];
    [_splitScreenView refreshSplitScreenView];
    
    /**
     在分屏回调中只返回了分屏用户的 iPeerId ，而在拖拽回调中返回了isDrag，
     所以在发生拖拽行为时，进行分屏操作需要将_iMvVideoDic内的isDrag置为NO
     */
    for (NSString *peerId in _iMvVideoDic.allKeys) {
        [self updateMvVideoForPeerID:peerId];
    }
}

- (void)onRemoteMsgWithVideoSplitScreen:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    [self tapTable:nil];
    NSDictionary *tDataDic = [self convertWithData:data];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:tDataDic[@"userIDArry"]];
    
    //取消全屏的操作
    [self cancelSplitScreen:array];
    
    _iStudentSplitScreenArray = array;
    //白板全屏状态下不执行分屏回调
    if (_iSessionHandle.iIsFullState) {
        return;
    }
    [self sVideoSplitScreen:_iStudentSplitScreenArray];
    [_splitScreenView refreshSplitScreenView];
    
    /**
     在分屏回调中只返回了分屏用户的 iPeerId ，而在拖拽回调中返回了isDrag，
     所以在发生拖拽行为时，进行分屏操作需要将_iMvVideoDic内的isDrag置为NO
     */
    for (NSString *peerId in _iMvVideoDic.allKeys) {
        [self updateMvVideoForPeerID:peerId];
    }
}

- (void)onRemoteMsgWithVideoZoom:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    // 视频缩放
    NSDictionary *tDataDic = [self convertWithData:data];
    
    // 数据格式：{"ScaleVideoData":{"ffefbe63-50ae-4959-a872-3dd38397988d":{"scale":1.7285714285714286}}}
    NSDictionary *peerIdToScaleDic = [tDataDic objectForKey:@"ScaleVideoData"];
    _iScaleVideoDict = peerIdToScaleDic;
    
    //白板全屏状态下不执行缩放回调
    if (_iSessionHandle.iIsFullState) {
        return;
    }
    [self sScaleVideo:peerIdToScaleDic];
    
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
    chatMessageModel.iMessageTypeColor = add ? UIColor.redColor : UIColor.whiteColor;
    
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
            
            [TKEduSessionHandle shareInstance].iIsFullState = add;
            [self changeVideoFrame:add];
        }
    }
}
#pragma mark - 计时器
- (void)onRemoteMsgWithShowTimerWithAdd:(BOOL)add andData:(NSObject *)data receiveMsgTime:(long)time {
    
    if (add) {
        
        NSDictionary *dataDic	= [self convertWithData:data];
        
        BOOL isStatus			= [dataDic[@"isStatus"] boolValue];
        BOOL isRestart			= [dataDic[@"isRestart"] boolValue];
        BOOL isShow				= [dataDic[@"isShow"] boolValue];
        NSArray *timerArray		= dataDic[@"sutdentTimerArry"];
        
        NSInteger minute = [[NSString stringWithFormat:@"%@%@", timerArray[0], timerArray[1]] integerValue];
        NSInteger second = [[NSString stringWithFormat:@"%@%@", timerArray[2], timerArray[3]] integerValue];
        
        if (_iSessionHandle.localUser.role == TKUserType_Teacher ||
            _iSessionHandle.localUser.role == TKUserType_Patrol) {
            
            if (!_timerView) {
                
                _timerView = [[TKTimerView alloc] init];
                [_whiteboardBackView addSubview:_timerView];
                
                [_timerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_whiteboardBackView.mas_centerX);
                    make.centerY.equalTo(_whiteboardBackView.mas_centerY);
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
        else if (_iSessionHandle.localUser.role == TKUserType_Student && !isShow) {
            if (!_stuTimer) {
                UIView * contentView = _whiteboardBackView;
                
                _stuTimer = [[TKStuTimerView alloc] init];
                [_whiteboardBackView addSubview:_stuTimer];
                
                [_stuTimer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(_whiteboardBackView.mas_centerX);
                    make.centerY.equalTo(_whiteboardBackView.mas_centerY);
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (void)onRemoteMsgWithResponderView:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist {
    
    NSDictionary *dataDic = [self convertWithData:data];
    
    if ([msgName isEqualToString:sQiangDaQi]) {
        
        if (add) {
            
            if (!self.responderView) {
                
                UIView * toolBV = _whiteboardBackView;
                _responderView = [[TKToolsResponderView alloc] init];
                _responderView.center = CGPointMake(toolBV.width / 2, toolBV.height / 2);
                [toolBV addSubview:_responderView];
                [_responderView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(toolBV.mas_centerX);
                    make.centerY.equalTo(toolBV.mas_centerY);
                }];
            }
            [self.responderView receiveShowResponderViewWith:dataDic];
            
        } else {
            
            self.responderView.hidden = YES;
            [self.responderView removeFromSuperview];
            self.responderView = nil;
        }
        
    } else if ([msgName isEqualToString:sQiangDaZhe]) {
        
        if (self.responderView) {
            NSArray * arr = [msgID componentsSeparatedByString:@"_"];
            [self.responderView receiveResponderUser:dataDic peerid:[arr lastObject]];
        }
        
    } else if ([msgName isEqualToString:sResponderDrag]) {
        
    }
}


- (void)restoreMp3ViewFrame
{
    // mp3 view 老师带有进度条 frame不同
    if (!self.iMediaView.hasVideo) {
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

- (void)changeMp3ViewFrame {
    
    // mp3 view 老师带有进度条 frame不同
    if (CGRectGetWidth(_iMediaView.frame) == CGRectGetHeight(_iMediaView.frame)) {
        self.iMediaView.frame = CGRectMake(CGRectGetMinX(self.view.frame) + 10,
                                           CGRectGetMaxY(self.iTKEduWhiteBoardView.frame) - CGRectGetHeight(_iMediaView.frame) - (IS_PAD ? 60 : 40),
                                           CGRectGetWidth(_iMediaView.frame),
                                           CGRectGetHeight(_iMediaView.frame));
    } else {
        //老师
        self.iMediaView.frame = CGRectMake(CGRectGetMinX(self.iTKEduWhiteBoardView.frame) + (CGRectGetWidth(self.iTKEduWhiteBoardView.frame) - CGRectGetWidth(_iMediaView.frame)) / 2,
                                           CGRectGetMaxY(self.iTKEduWhiteBoardView.frame) - CGRectGetHeight(_iMediaView.frame) - (IS_PAD ? 80 : 60),
                                           CGRectGetWidth(_iMediaView.frame),
                                           CGRectGetHeight(_iMediaView.frame));
    }
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

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"TKTextViewInternal"] ||  [NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"] || [touch.view.superview isKindOfClass:[UICollectionViewCell class]])
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:stouchMainPageNotification object:nil];
    
    [_iStudentVideoViewArray makeObjectsPerformSelector:@selector(hidePopMenu)];
    [_iStudentSplitViewArray makeObjectsPerformSelector:@selector(hidePopMenu)];
    
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)gestureRecognizer
{
    TKCTVideoSmallView * smallView = (TKCTVideoSmallView *)gestureRecognizer.view;

    // 巡课不允许缩放
    if ([TKEduSessionHandle shareInstance].localUser.role == TKUserType_Patrol) {
        return;
    }
    
    if (![TKEduSessionHandle shareInstance].iIsCanDraw ) {
        return;
    }
    
    // 没有拖出去不允许缩放
    if (smallView.isDrag == NO) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan
        || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint center = smallView.center;
        CGRect newframe = smallView.frame;
        CGFloat height = newframe.size.height * gestureRecognizer.scale;
        CGFloat width = newframe.size.width * gestureRecognizer.scale;
        
        if (width < smallView.originalWidth) {
            // 无法缩小至比初始化大小还小
            return;
        }
        
        // 保证不超出白板
        
        if (height >= CGRectGetHeight(self.iTKEduWhiteBoardView.frame)) {
            return;
        }
        
        if (width >= CGRectGetWidth(self.iTKEduWhiteBoardView.frame)) {
            return;
        }
        
        
        smallView.frame = CGRectMake(center.x - width/2.0, center.y - height/2.0, width, height);
        
        gestureRecognizer.scale = 1;
        
        // 只有老师发送缩放信令
        if ([TKEduSessionHandle shareInstance].localUser.role == TKUserType_Teacher) {
            NSDictionary *tDict = @{@"ScaleVideoData":
                                        @{smallView.iRoomUser.peerID:
                                              @{@"scale":@(width/smallView.originalWidth)}
                                          }
                                    };
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sVideoZoom ID:sVideoZoom To:sTellAllExpectSender Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        smallView.frame = [smallView resizeVideoViewInFrame];
        smallView.center = self.whiteboardBackView.center;
        // 只有老师发送缩放信令
        if ([TKEduSessionHandle shareInstance].localUser.role == TKUserType_Teacher) {
            NSDictionary *tDict = @{@"ScaleVideoData":
                                        @{smallView.iRoomUser.peerID:
                                              @{@"scale":@(smallView.frame.size.width/smallView.originalWidth)}
                                          }
                                    };
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sVideoZoom ID:sVideoZoom To:sTellAllExpectSender Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        }
    }
}


- (void)longPressClick:(UIGestureRecognizer *)longGes
{
    
    TKCTVideoSmallView * currentBtn = (TKCTVideoSmallView *)longGes.view;
    
    // 用于判断是否开启音频（拖入白板打开音频，在白板中拖动不改变音频状态）
    BOOL isDrag = currentBtn.isDrag;
    
    //未开始上课禁止拖动视频
    if (!_iSessionHandle.isClassBegin) {
        return;
    }
    
    // 巡课不能拖视频
    if (self.iUserType == TKUserType_Patrol || _iSessionHandle.localUser.role == TKUserType_Patrol) {
        return;
    }
    
    // 学生只能在授权下拖拽自己的视频
    if (self.iUserType == TKUserType_Student) {
        if (!_iSessionHandle.iIsCanDraw) {
            return;
        }
    }
    
    // 分屏模式不允许拖动
    if (self.iStudentSplitScreenArray.count) {
        return;
    }
    
    //判断视图是否处于分屏状态，如果是分屏状态则不可以拖动
    for (NSString *peerID in self.iStudentSplitScreenArray) {
        if ([peerID isEqualToString:currentBtn.iRoomUser.peerID] ) {
            return;
        }
    }
    if ((_iSessionHandle.localUser.role == TKUserType_Student)) {
        
        CGFloat tCurBtnCenterX = currentBtn.center.x;
        CGFloat tCurBtnCenterY = currentBtn.center.y;
        //边界
        CGFloat tEdgLeft = currentBtn.width / 2.0;
        CGFloat tEdgRight= [UIScreen mainScreen].bounds.size.width - currentBtn.width / 2.0;
        
        CGFloat tEdgBtm =  ScreenH - CGRectGetHeight(currentBtn.frame)/2.0;
        CGFloat tEdgTp = CGRectGetMaxY(self.videosBackView.frame) + CGRectGetHeight(currentBtn.frame)/2.0;
        
        if ((tCurBtnCenterX <= tEdgLeft) || (tCurBtnCenterX >= tEdgRight) || (tCurBtnCenterY <= tEdgTp) || (tCurBtnCenterY >= tEdgBtm)) {
            return;
        }
    }
    //把白板放到最下边
    [self.backgroundImageView sendSubviewToBack:self.iTKEduWhiteBoardView];
    
    //拖拽视频后如果未放大需要初始化到7个均分的大小 所以以放大后计算边界 向右向下放大
    CGFloat w = currentBtn.currentWidth;
    CGFloat h = currentBtn.currentHeight;
    if (!currentBtn.isSplit && currentBtn.currentWidth<currentBtn.originalWidth) {
        w =((ScreenW-sMaxVideo*sViewCap)/ sMaxVideo);
        h = (w /4.0 * 3.0)+(w /4.0 * 3.0)/sMaxVideo;
    }
    
    if (UIGestureRecognizerStateBegan == longGes.state) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iStrtCrtVideoViewP  = [longGes locationInView:currentBtn];
        }];
    }
    if (UIGestureRecognizerStateChanged == longGes.state) {
        //移动距离
        CGPoint newP = [longGes locationInView:currentBtn];
        CGFloat movedX = newP.x - self.iStrtCrtVideoViewP.x;
        CGFloat movedY = newP.y - self.iStrtCrtVideoViewP.y;
        CGFloat tCurBtnCenterX = currentBtn.center.x+ movedX;
        CGFloat tCurBtnCenterY = currentBtn.center.y + movedY;
        //边界
        //拖拽视频后如果未放大需要初始化到7个均分的大小 所以以放大后计算边界 向右向下放大
        // 视频区下拖动 区域限制
        CGFloat tEdgLeft  = w/2.0;
        CGFloat tEdgRight = ScreenW - w/2.0;
        CGFloat tEdgBtm   = ScreenH - h/2.0;
        CGFloat tEdgTp    = CGRectGetMaxY(self.videosBackView.frame) - h/2.0;
        
        // 只有在白板区域的视频 学生才可以拖动 且只能在白板区拖动
        if ((_iSessionHandle.localUser.role == TKUserType_Student)) {
            tEdgTp = CGRectGetMaxY(self.videosBackView.frame) + h/2.0;
        }
        BOOL isOverEdgLR = (tCurBtnCenterX <= tEdgLeft) || (tCurBtnCenterX >= tEdgRight) || (tCurBtnCenterY <= tEdgTp) || (tCurBtnCenterY >= tEdgBtm);
        BOOL isOverEdgTD = (tCurBtnCenterY <= tEdgTp) || (tCurBtnCenterY >= tEdgBtm);
        if (isOverEdgLR) {
            tCurBtnCenterX =  tCurBtnCenterX - movedX;
        }
        if (isOverEdgTD) {
            tCurBtnCenterY = tCurBtnCenterY - movedY;
        }
        currentBtn.center = CGPointMake(tCurBtnCenterX, tCurBtnCenterY);
    }
    // 手指松开之后 进行的处理
    if (UIGestureRecognizerStateEnded == longGes.state) {
        
        BOOL isEndEdgMvToScrv = ((currentBtn.center.y> CGRectGetMinY(self.videosBackView.frame)) &&(CGRectGetMaxY(currentBtn.frame) < CGRectGetMinY(self.videosBackView.frame)));
        BOOL isEndMvToScrv = ((CGRectGetMinY(currentBtn.frame) > CGRectGetMaxY(self.videosBackView.frame)));
        
        currentBtn.isDrag = YES;
        [UIView animateWithDuration:0.2 animations:^{
            currentBtn.alpha     = 1.0f;
            currentBtn.transform = CGAffineTransformIdentity;
            if (isEndEdgMvToScrv ) {
                
                currentBtn.frame= CGRectMake(CGRectGetMinX(currentBtn.frame), CGRectGetMinY(self.videosBackView.frame)-CGRectGetHeight(currentBtn.frame), CGRectGetWidth(currentBtn.frame), CGRectGetHeight(currentBtn.frame));
            }else if(isEndMvToScrv) {
                TKLog(@"isEndMvToScrv 拖动");
            }else {
                currentBtn.isDrag = NO;
            }
            
            //拖拽视频后如果未放大需要初始化到7个均分的大小 放大方向-上下左右
            if (!currentBtn.isSplit && currentBtn.currentWidth<currentBtn.originalWidth) {
                currentBtn.frame= CGRectMake(CGRectGetMidX(currentBtn.frame) - w/2, CGRectGetMidY(currentBtn.frame) - h/2, w, h);
            }
            
            //拖动视频的时候判断下视频是否有分屏状态的
            if(self.iStudentSplitScreenArray.count>0){
                
                [self beginTKSplitScreenView:currentBtn];
                return;
            }
            
            [self refreshVideosBackView];
            [self sendMoveVideo:self.iPlayVideoViewDic aSuperFrame:self.iTKEduWhiteBoardView.frame allowStudentSendDrag:NO];
            
        }];
        
        
        // 如果拖拽到白板区域 并且音频是关闭状态 需要将音频打开
        if (CGRectContainsRect(self.whiteboardBackView.frame,currentBtn.frame) && !isDrag) {
            if(currentBtn.iPeerId.length){
                //音频关闭时打开音频
                TKPublishState state = currentBtn.iRoomUser.publishState;
                if (state == TKUser_PublishState_BOTH || state == TKUser_PublishState_VIDEOONLY) {
                    state = TKUser_PublishState_BOTH;
                } else if (state == TKUser_PublishState_AUDIOONLY ||
                           state == TKUser_PublishState_NONE ||
                           state == TKUser_PublishState_UNKown ||
                           state == TKPublishStateLocalNONE ||
                           state == TKPublishStateNONEONSTAGE) {
                    state = TKUser_PublishState_AUDIOONLY;
                }
                [_iSessionHandle  sessionHandleChangeUserPublish:currentBtn.iPeerId Publish:state completion:nil];
            }
        }
    }
    
}

// 播放mp4全屏长按视频
- (void)fullScreenVideoLongPressClick:(UIGestureRecognizer *)longGes {
    
    TKCTVideoSmallView * currentVedioView = (TKCTVideoSmallView *)longGes.view;
    
    if (UIGestureRecognizerStateBegan == longGes.state) {
        self.iStrtCrtVideoViewP  = [longGes locationInView:currentVedioView];
    }
    
    if (UIGestureRecognizerStateChanged == longGes.state) {
        //为了与老代码保持一致，在手势变化的时候判断
        //按道理来讲在手势结束后判断是否超出范围最为合理
        CGRect videoViewFrame = currentVedioView.frame;
        
        CGPoint point = [longGes locationInView:self.iTKEduWhiteBoardView];
        videoViewFrame.origin.x = point.x - self.iStrtCrtVideoViewP.x;
        videoViewFrame.origin.y = point.y - self.iStrtCrtVideoViewP.y;
        
        if (CGRectGetMinX(videoViewFrame) < CGRectGetMinX(self.iTKEduWhiteBoardView.frame)) {
            videoViewFrame.origin.x = 0;
        }
        
        if (CGRectGetMaxX(videoViewFrame) > CGRectGetMaxX(self.iTKEduWhiteBoardView.frame)) {
            videoViewFrame.origin.x =  CGRectGetMaxX(self.iTKEduWhiteBoardView.frame) - CGRectGetWidth(currentVedioView.frame);
        }
        
        if (CGRectGetMinY(videoViewFrame) < CGRectGetMinY(self.iTKEduWhiteBoardView.frame)) {
            videoViewFrame.origin.y = 0;
        }
        
        if (CGRectGetMaxY(videoViewFrame) > CGRectGetMaxY(self.iTKEduWhiteBoardView.frame)) {
            videoViewFrame.origin.y = CGRectGetMaxY(self.iTKEduWhiteBoardView.frame) - CGRectGetHeight(currentVedioView.frame);
        }
        
        currentVedioView.frame = videoViewFrame;
    }
    // 手指松开之后 进行的处理
    if (UIGestureRecognizerStateEnded == longGes.state) {
        
        [UIView animateWithDuration:0.2 animations:^{
            currentVedioView.alpha     = 1.0f;
            currentVedioView.transform = CGAffineTransformIdentity;
            
            [self sendMoveVideo:self.iPlayVideoViewDic aSuperFrame:self.iTKEduWhiteBoardView.frame allowStudentSendDrag:NO];
        }];
    }
}



- (void)checkPlayVideo{
    
    BOOL tHaveRaiseHand = NO;
    BOOL tIsMuteAudioState = YES;
    
    for (TKRoomUser *usr in [_iSessionHandle userStdntAndTchrArray]) {
        BOOL tBool = [[usr.properties objectForKey:@"raisehand"] boolValue];
        if (tBool && !tHaveRaiseHand) {
            tHaveRaiseHand = YES;
        }
        if ((usr.publishState == TKPublishStateAUDIOONLY || usr.publishState == TKPublishStateBOTH) && usr.role != TKUserType_Teacher && tIsMuteAudioState) {
            
            tIsMuteAudioState = NO;
        }
    }
    
    if (_iUserType == TKUserType_Teacher) {
        
        _iSessionHandle.isMuteAudio     = tIsMuteAudioState;
        _iSessionHandle.isunMuteAudio   = !tIsMuteAudioState;
        
        [self.controlView refreshUI];
    }
}
-(void)onClassReady{
    
    if(!_iHowMuchTimeServerFasterThenMe)
        return;
    
    if (!_iSessionHandle.isClassBegin && _iUserType == TKUserType_Teacher) {
        
        _iCurrentTime = [[NSDate date] timeIntervalSince1970] + _iHowMuchTimeServerFasterThenMe;
        
        if ((int)((_iCurrentTime*1000 -_roomJson.begintime*1000)/1000)>=-60 &&
            ((int)((_iCurrentTime*1000 -_roomJson.begintime*1000)/1000)< 0 &&
             !_iShowBefore)) {
                
                _iShowBefore = YES;
            }
        else if(((int)(_iCurrentTime*1000 -_roomJson.begintime*1000)/1000)/60>=1 &&
                !_iShow &&(_iCurrentTime-_roomJson.begintime)>0 ){
            
            _iShow = YES;
            
            
        }
        
    }
    
}

- (void)onClassCurrentTimer{
    
    if(!_iHowMuchTimeServerFasterThenMe)
        return;
    
    _iCurrentTime = [[NSDate date]timeIntervalSince1970] + _iHowMuchTimeServerFasterThenMe;
    
    NSTimeInterval interval = _roomJson.endtime -_iCurrentTime;
    NSInteger time = interval;
    //（1）未到下课时间： 老师点下课 —> 下课后不离开教室forbidLeaveClassFlag—>提前5分钟给出提示语（老师、助教）—>下课时间到，课程结束，一律离开
    if( !_iSessionHandle.isClassBegin && _roomJson.configuration.forbidLeaveClassFlag){
        
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
    /*
     按下课时间结束课堂配置项的说明：
     1.未到下课时间,下课后离开教室的课堂,老师点击下课,就按正常的,老师留下,其他学生一律离开
     2.未到下课时间,下课后不离开教室的课堂,老师点击下课后,所有人都没有离开,到了下课时间的前5分钟老师跟助教的页面给出提示语,下课时间到后,所有人一律离开
     3.未到下课时间,老师没有点击下课,下课时间一到,所有人离开
     4.未到下课时间,老师没有点击下课,老师离开教室10分钟,课程结束,所有人离开
     5.到了下课时间,提前5分钟给出提示语,时间到一律离开（点击上课）
     6.点击上课后,未到下课时间,提前5分钟给提示语,到时间所有人离开
     7.点击上课后,距离下课时间不到5分钟,剩几分钟下课就提示几分钟
     8.已经时间到期的课堂,进入课堂提示课堂过期
     9.助教也显示
     */
    
    //此处主要用于检测上课过程中进入后台后无法返回前台的状况
    BOOL isBackground = [_iSessionHandle.roomMgr.localUser.properties[sIsInBackGround] boolValue];
    if(([UIApplication sharedApplication].applicationState == UIApplicationStateActive) && isBackground){
        [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(NO) completion:nil];
        _iSessionHandle.roomMgr.inBackground = NO;
    }
    
    if(!_iHowMuchTimeServerFasterThenMe)
        return;
    
    _iCurrentTime = [[NSDate date]timeIntervalSince1970] + _iHowMuchTimeServerFasterThenMe;
    
    if (_roomJson.configuration.endClassTimeFlag) {
        //fix 回放会导致退出教室
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
            
//            NSInteger mimute = time/60 > 0 ? time/60 : time%60;
//            [TKUtil showMessage:[NSString stringWithFormat:@"%ld%@", mimute, MTLocalized(@"Prompt.ClassEndTime")]];
//
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
        //相机
        [self chooseAction:1 delay:NO];
    }else if ([notify.object isEqualToString:sChoosePhotosUploadNotification]){
        //相册
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
        
        [_iSessionHandle addDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender];
        
        [_iSessionHandle  publishtDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender aTellLocal:YES];
        [self removProgressView];
        [_iSessionHandle sessionHandleEnableVideo:YES];
        
    } else {
        TKLog(@"error - image update - %@", Response);
    }
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


#pragma mark Public
- (TKCTVideoSmallView *)videoViewForPeerId:(NSString *)peerId {
    if (peerId == nil) {
        return nil;
    }
    if ([self.iTeacherVideoView.iRoomUser.peerID isEqualToString:peerId]) {
        return self.iTeacherVideoView;
    }
    for (TKCTVideoSmallView *view in self.iStudentVideoViewArray) {
        if ([view.iRoomUser.peerID isEqualToString:peerId]) {
            
            return view;
        }
    }
    return nil;
}

#pragma mark Private
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
//判断设备时间
- (void)judgeDeviceTime  {
    
    NSTimeInterval time = [TKUtil getNowTimeTimestamp];
    [TKEduNetManager systemtime:self.iParamDic Complete:^int(id  _Nullable response) {
        double timeDiff = _roomJson.endtime - time;
        
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
    [TKEduNetManager getGiftinfo:_roomJson.roomid aParticipantId: _roomJson.thirdid  aHost:sHost aPort:sPort aGetGifInfoComplete:^(id  _Nullable response) {
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

#pragma mark - 清理
- (void)clearAllData{
    
    [self.iSessionHandle.whiteBoardManager changeDocumentWithFileID:_iSessionHandle.whiteBoard.fileid isBeginClass:_iSessionHandle.isClassBegin isPubMsg:YES];
    
    [self.iSessionHandle.whiteBoardManager disconnect:nil];
    
    [self.iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
    
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
    
    [self.iPlayVideoViewDic removeAllObjects];
    _iSessionHandle.onPlatformNum = 0;
    
    for (NSString *peerId in _iMvVideoDic.allKeys) {
        [self updateMvVideoForPeerID:peerId];
    }
    
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
    [self.splitScreenView deleteAllVideoSmallView];
    
    [self.iStudentSplitScreenArray removeAllObjects];
    
    self.splitScreenView.hidden = YES;
    
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
    
    //2.关闭抢答器
    self.responderView.hidden = YES;
    [self.responderView removeFromSuperview];
    self.responderView = nil;

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
    
    if (self.navbarView.netTipView) {
        [self.navbarView.netTipView changeDetailSignImage:NO];
    }
    if (self.netDetailView) {
        [self.netDetailView removeFromSuperview];
        self.netDetailView = nil;
    }
}

- (void)clearVideoViewData:(TKCTVideoSmallView *)videoView {
    videoView.isDrag = NO;
    if (videoView.iRoomUser != nil) {
  
        [_iSessionHandle sessionHandleUnPlayVideo:videoView.iRoomUser.peerID completion:^(NSError *error) {
            //断网重连后 非iOS端的视频流是空的 所以error不为空
            //Error Domain=com.talkcloud Code=104 "Unplaying stream not found !!"
            //UserInfo={NSLocalizedDescription=Unplaying stream not found !!}
            
            //更新uiview
            [videoView clearVideoData];
            [videoView removeFromSuperview];
        }];
    } else {
        [videoView clearVideoData];
        [videoView removeFromSuperview];
    }
}
- (void)quitClearData {
    [_iSessionHandle configureDraw:false isSend:NO to:sTellAll peerID:_iSessionHandle.localUser.peerID];
    
    [_iSessionHandle.whiteBoardManager roomWhiteBoardOnDisconnect:nil];
    
    [_iSessionHandle clearAllClassData];
    
    [_iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
    
    [self clearVideoViewData:_iTeacherVideoView];
    
    for (TKCTVideoSmallView *view in _iStudentVideoViewArray) {
        [self clearVideoViewData:view];
    }
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
    
    //将分屏的数据删除
    for (TKCTVideoSmallView *view in _iStudentSplitViewArray) {
        [self clearVideoViewData:view];
    }
    
    if (self.navbarView.netTipView) {
        [self.navbarView.netTipView changeDetailSignImage:NO];
    }
    if (self.netDetailView) {
        [self.netDetailView removeFromSuperview];
        self.netDetailView = nil;
    }
    
    [_splitScreenView deleteAllVideoSmallView];
    [_iStudentSplitScreenArray removeAllObjects];
    
    /**暂时这么解决s双重奖杯*/
    for (TKCTVideoSmallView *samllView in self.iStudentVideoViewArray) {
        [samllView removeAllObserver];
    }
    
    [_iStudentVideoViewArray removeAllObjects];
    _iStudentVideoViewArray = nil;
    
    
}
- (void)invalidateTimer {
    if (_iCheckPlayVideotimer) {
        [_iCheckPlayVideotimer invalidate];
        _iCheckPlayVideotimer = nil;
    }
    [self invalidateClassBeginTime];
    [self invalidateClassCurrentTime];
}

- (void)removProgressView {
    if (_uploadImageView) {
        [_uploadImageView removeFromSuperview];
        _uploadImageView = nil;
        _iPickerController = nil;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"roomController----dealloc");
}
- (void)didReceiveMemoryWarning {
    
}

#pragma mark - 白板控制
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
    
        if (_iUserType != TKUserType_Teacher && isRemoteFullScreen) { // 学生 巡课 在收到全屏 不可操作
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
    
    //全屏结束放大状态并重置按钮状态
    [_iSessionHandle wbSessionManagerResetEnlarge];
    [_pageControl resetBtnStates];
//    }
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


@end
