//
//  GenSeeLiveViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/8/2.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "GenSeeLiveViewController.h"
#import <PlayerSDK/PlayerSDK.h>
#import "UIColor+HTMLColors.h"
#import "TKProgressHUD.h"
#import "BigWindCar.h"
#import "TKProgressHUD+Add.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "ZhiyiHTTPRequest.h"


@interface GenSeeLiveViewController ()<GSPPlayerManagerDelegate,UIScrollViewDelegate>
{
    BOOL hasOrientation;
    UILabel *titleLab;
    UILabel *_timelab;
    
    GSPJoinParam *joinParam;
    GSPVideoView *_videoView;
    CGRect videoViewRect;//记录videoView的原始尺寸
    //存放按钮
    UIView *btnView;
    UIButton *_timerbtn;
    //参数
    NSString *_title;
    NSString *_nickName;
    NSString *_watchPassword;
    NSString *_roomNumber;
}

@property (strong, nonatomic) NSTimer *m_timer;
@property (nonatomic,assign) NSInteger index;
@property (strong ,nonatomic)NSDictionary *liveDict;

@property (nonatomic, strong) GSPPlayerManager *playerManager;
@property (nonatomic, strong) GSPChatView *chatView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
//chatView
@property (nonatomic, strong) GSPChatInputToolView *inputView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) GSPInvestigationView *investigationView;

@property (nonatomic, strong) GSPQaView *qaView;
@property (nonatomic, strong) TKProgressHUD *progressHUD;
@property (nonatomic, strong) UIAlertView *alert;


@end

@implementation GenSeeLiveViewController

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


-(void)initwithTitle:(NSString *)title nickName:(NSString *)nickName watchPassword:(NSString *)watchPassword roomNumber:(NSString *)roomNumber{
    _title = title;
    _nickName = nickName;
    _watchPassword = watchPassword;
    _roomNumber = roomNumber;
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = _title;
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}


-(void)backBtn
{
    //这里应该停止播放
    [self.playerManager leave];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    self.title = _title;
    videoViewRect = CGRectMake(0, 64, MainScreenWidth, MainScreenWidth/2);
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:back];
    //
    
    hasOrientation = NO;
    
    [self initLive];
    //    添加按钮
    [self initBtn];
    
    [self initScrollow];
    //聊天
    [self initChat];
    //投票
    [self initVote];
    //举手
    [self initHanUp];
    //问答
    [self initQastion];
    //文档
    [self initDockt];
    
    [self.view addSubview:_videoView];
    
    //    [self NetWorkGetUrl];
}

//添加按钮
-(void)initBtn{
    
    NSArray *imagArr = @[@"chat",@"toupiao",@"jushou",@"wenda",@"wendang"];
    NSArray *array = @[@"聊天",@"投票",@"举手",@"问答",@"文档"];
    btnView = [[UIView alloc]initWithFrame:CGRectMake(0, _videoView.frame.size.height + _videoView.frame.origin.y+5, MainScreenWidth,95)];
    [self.view addSubview:btnView];
    btnView.backgroundColor = [UIColor blackColor];
    for (int i=0; i<5; i++) {
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(((MainScreenWidth-47*5)/6 + 47)*i+(MainScreenWidth-47*5)/6,10, 47, 47)];
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(((MainScreenWidth-47*5)/6 + 47)*i+(MainScreenWidth-47*5)/6,65, 47,15)];
        [btnView addSubview:imgV];
        [btnView addSubview:titleLab];
        imgV.image = [UIImage imageNamed:imagArr[i]];
        titleLab.text = array[i];
        titleLab.font = [UIFont systemFontOfSize:13];
        if (i==2) {
            titleLab.frame = CGRectMake(((MainScreenWidth-47*5)/6 + 47)*i+(MainScreenWidth-47*5)/6-10,65, 67,15);
            _timelab = titleLab;
        }
        
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(((MainScreenWidth-47*5)/6 + 47)*i+(MainScreenWidth-47*5)/6,15, 47, 72)];
        btn.tag = i;
        [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:btn];
    }
}

-(void)initLive{
    //创建直播管理实例
    _playerManager = [[GSPPlayerManager alloc]init];
    _playerManager.delegate = self;
    
    //新建直播参数，用于匹配响应直播
    
    joinParam = [GSPJoinParam new];
    NSString *domain1 = _domain;
    
    
//    NSString *string = domain1;
//    NSRange startRange = [string rangeOfString:@"https://"];
//    NSRange  endRange = [string rangeOfString:@"/webcast"];;
//    if ([_typeStr integerValue] == 9) {
////        endRange = [string rangeOfString:@"/webcast"];
//    } else {
//        endRange = [string rangeOfString:@"/training"];
//    }
//    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
//    NSString *result = [string substringWithRange:range];
//    NSLog(@"%@",result);
    
    NSString *result = @"zhiyicx.gensee.com";
    
    
    joinParam.domain = result;
    if ([_typeStr integerValue] == 9) {
        joinParam.serviceType = GSPServiceTypeWebcast;
    } else {
        joinParam.serviceType = GSPServiceTypeTraining;
    }
    joinParam.roomNumber = _roomNumber;
    joinParam.nickName = _nickName;
    joinParam.watchPassword = _watchPassword;
    //进入账号
    joinParam.loginName = _account;
    NSLog(@"---%@",joinParam.loginName);
    
    joinParam.loginPassword = _roomNumber;
    //将显示视频的view绑定到直播管理类中
    _videoView = [[GSPVideoView alloc]initWithFrame:videoViewRect];
    self.playerManager.videoView = _videoView;
    //
    _videoView.contentMode = UIViewContentModeScaleAspectFit;
    //加入直播
    [_playerManager joinWithParam:joinParam];
    
    [self.view addSubview:_videoView];
    //    [_playerManager enableVideo:YES];
    //[_playerManager enableAudio:YES];
    //双击 全屏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rotationVideoView:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [_videoView addGestureRecognizer:tapGestureRecognizer];
    
    
    
}
-(void)initScrollow{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, btnView.frame.size.height+btnView.frame.origin.y, MainScreenWidth, MainScreenHeight- btnView.frame.size.height-btnView.frame.origin.y)];
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(MainScreenWidth*4,MainScreenHeight- btnView.frame.size.height-btnView.frame.origin.y);
    [self.view addSubview:self.scrollView];
}
//聊天
-(void)initChat{
    
    _chatView = [[GSPChatView alloc]initWithFrame:CGRectMake(0,0, MainScreenWidth,self.scrollView.frame.size.height-52)];
    
    [self.scrollView addSubview:_chatView];
    _inputView= [[GSPChatInputToolView alloc]initWithViewController:self combinedChatView:_chatView combinedQaView:nil isChatMode:YES];
    
    [self.view addSubview:_inputView];
    
    self.playerManager.chatView = _chatView;
    
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideChatView:)];
    [_chatView addGestureRecognizer:_tapGestureRecognizer];
    
    [self.playerManager enableBackgroundMode];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
    
    
    if  ([self isHeadsetPluggedIn])
    {
        
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        [audioSession setActive:YES error:nil];
        
    }
    else
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        
        [audioSession setActive:YES error:nil];
        
    }
    
    
}
//投票
-(void)initVote{
    
    //投票
    self.investigationView = [[GSPInvestigationView alloc]initWithFrame:CGRectMake(MainScreenWidth*1, 0,MainScreenWidth, self.scrollView.frame.size.height)];
    //self.investigationView.translatesAutoresizingMaskIntoConstraints = NO;
    self.playerManager.investigationView = self.investigationView;
    [self.scrollView addSubview:self.investigationView];
    
}
//举手
-(void)initHanUp{
    _index = 60;
    
}

//问答
-(void)initQastion{
    
    //问答
    self.qaView = [[GSPQaView alloc]initWithFrame:CGRectMake(MainScreenWidth*2,0, MainScreenWidth, self.scrollView.frame.size.height-52)];
    //_qView.playerManager = self.playerManager;
    [_qaView addObserver:self forKeyPath:@"QAtitleArray" options:NSKeyValueObservingOptionNew context:nil];
    self.playerManager.qaView = self.qaView;
    
    [self.scrollView addSubview:self.qaView];
}
//文档
-(void)initDockt{
    //文档
    GSPDocView *docView = [[GSPDocView alloc]initWithFrame:CGRectMake(MainScreenWidth*3, 0,MainScreenWidth, self.scrollView.frame.size.height)];
    self.playerManager.docView = docView;
    [self.scrollView addSubview:docView];
}
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            NSLog(@"Headphone/Line plugged in");
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            NSLog(@"Headphone/Line was pulled. Stopping player....");
            
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
            
            [audioSession setActive:YES error:nil];
            
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - chatView

- (void)hideChatView:(UIGestureRecognizer *)recognizer {
    
    [_inputView hideUserListView];
    _tapGestureRecognizer = nil;
    
    [self.view endEditing:YES];
}

- (BOOL)shouldAutorotate {
    
    return NO;
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}
- (void)rotationVideoView:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];//收起键盘
    //强制旋转
    if (!hasOrientation) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            _videoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            hasOrientation = YES;
            //self.chatView.hidden = YES;
            self.navigationController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformInvert(CGAffineTransformMakeRotation(0));
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            _videoView.frame = videoViewRect;
            hasOrientation = NO;
            self.chatView.hidden = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            self.navigationController.navigationBarHidden = YES;
        }];
    }
}

-(void)change:(UIButton *)sender{
    [self.view endEditing:YES];//收起键盘
    [_inputView setHidden:YES];
    [UIView animateWithDuration:0.2 animations:^{
        //self.lineLab.frame = frame;
        //[sender setTitleColor:[UIColor colorWithHexString:@"#ffbb2d"] forState:UIControlStateNormal];
        
        if (sender.tag==0) {
            
            _inputView= [[GSPChatInputToolView alloc]initWithViewController:self combinedChatView:_chatView combinedQaView:nil isChatMode:YES];
            
            [self.view addSubview:_inputView];
            self.scrollView.contentOffset = CGPointMake(MainScreenWidth * (sender.tag), 0);
            
        }else if (sender.tag==3){
            
            _inputView= [[GSPChatInputToolView alloc]initWithViewController:self combinedChatView:nil combinedQaView:self.qaView isChatMode:NO];
            
            [self.view addSubview:_inputView];
            self.scrollView.contentOffset = CGPointMake(MainScreenWidth * (sender.tag-1), 0);
            
        }else if (sender.tag==2){
            
            //计时器
            self.m_timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_m_timer forMode:NSRunLoopCommonModes];
            if (self.playerManager) {
                [self.playerManager handup:YES];
            }
            _timerbtn = sender;
            [_inputView setHidden:YES];
        }
        else if (sender.tag==1){
            
            self.scrollView.contentOffset = CGPointMake(MainScreenWidth * (sender.tag), 0);
            
        }else{
            
            self.scrollView.contentOffset = CGPointMake(MainScreenWidth * (sender.tag-1), 0);
            [_inputView setHidden:YES];
        }
    }];
}

-(void)timerEvent{
    
    _index--;
    if (_index == 0) {
        
        [self.playerManager handup:NO];
        _timerbtn.enabled = YES;
        [self stopTimer];
        _index=60;
        
    }else{
        
        _timerbtn.enabled = NO;
        NSString *text = [NSString stringWithFormat:@"%ld",(long)_index];
        _timelab.text = [NSString stringWithFormat:@"举手(%@)",text];
    }
}

//关闭定时器
-(void)stopTimer{
    
    if (self.m_timer) {
        [self.m_timer invalidate];
        self.m_timer = nil;
        _timelab.text = @"举手";
    }
}

//问答代理
- (void)playerManager:(GSPPlayerManager *)playerManager didSelfLeaveFor:(GSPLeaveReason)reason {
    NSString *reasonStr = nil;
    switch (reason) {
        case GSPLeaveReasonEjected:
            reasonStr = NSLocalizedString(@"被踢出直播", @"");
            break;
        case GSPLeaveReasonTimeout:
            reasonStr = NSLocalizedString(@"超时", @"");
            break;
        case GSPLeaveReasonClosed:
            reasonStr = NSLocalizedString(@"直播关闭", @"");
            break;
        case GSPLeaveReasonUnknown:
            reasonStr = NSLocalizedString(@"位置错误", @"");
            break;
        default:
            break;
    }
    if (reasonStr != nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"退出直播", @"") message:reasonStr delegate:self cancelButtonTitle:NSLocalizedString(@"知道了", @"") otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark --- 代理

- (void)playerManagerWillReconnect:(GSPPlayerManager *)playerManager {
    _progressHUD = [[TKProgressHUD alloc] initWithView:_qaView];
    _progressHUD.labelText = NSLocalizedString(@"断线重连", @"");
    [self.view addSubview:_progressHUD];
    [_progressHUD show:YES];
}

-(void)playerManager:(GSPPlayerManager *)playerManager didReceiveSelfJoinResult:(GSPJoinResult)joinResult{
    NSString *result = @"";
    switch (joinResult) {
        case GSPJoinResultCreateRtmpPlayerFailed:
            result = NSLocalizedString(@"创建直播实例失败", @"");
            break;
        case GSPJoinResultJoinReturnFailed:
            result = NSLocalizedString(@"调用加入直播失败", @"");
            break;
        case GSPJoinResultNetworkError:
            result = NSLocalizedString(@"网络错误", @"");
            break;
        case GSPJoinResultUnknowError:
            result = NSLocalizedString(@"未知错误", @"");
            break;
        case GSPJoinResultParamsError:
            result = NSLocalizedString(@"参数错误", @"");
            break;
        case GSPJoinResultOK:
            result = @"加入成功";
            break;
        case GSPJoinResultCONNECT_FAILED:
            result = NSLocalizedString(@"连接失败", @"");
            break;
        case GSPJoinResultTimeout:
            result = NSLocalizedString(@"连接超时", @"");
            break;
        case GSPJoinResultRTMP_FAILED:
            result = NSLocalizedString(@"链接媒体服务器失败", @"");
            break;
        case GSPJoinResultTOO_EARLY:
            result = NSLocalizedString(@"直播尚未开始", @"");
            break;
        case GSPJoinResultLICENSE:
            result = NSLocalizedString(@"人数已满", @"");
            break;
        default:
            result = NSLocalizedString(@"错误", @"");
            break;
    }
    
    //用于断线重连
    if (_progressHUD != nil) {
        [_progressHUD hide:YES];
        _progressHUD = nil;
    }
    
    UIAlertView *alertView;
    if ([result isEqualToString:@"加入成功"]) {
        
        [_playerManager enableVideo:YES];
        //[_playerManager enableAudio:YES];
        
    } else {
        alertView = [[UIAlertView alloc] initWithTitle:result message:NSLocalizedString(@"请退出重试", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了", @"") otherButtonTitles:nil];
        [self.view addSubview:alertView];
        [alertView show];
    }
}

- (void)playerManager:(GSPPlayerManager *)playerManager didUserJoin:(GSPUserInfo *)userInfo {
    //用于断线重连
    if (_progressHUD != nil) {
        [_progressHUD hide:YES];
        _progressHUD = nil;
    }
}



- (void)playerManager:(GSPPlayerManager *)playerManager  didReceiveMediaInvitation:(GSPMediaInvitationType)type action:(BOOL)on
{
    [_alert dismissWithClickedButtonIndex:1 animated:YES];
    
    if (GSPMediaInvitationTypeAudioOnly == type) {
        
        if (on) {
            
            if (!_alert) {
                _alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"直播间邀请您语音对话", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"拒绝", nil) otherButtonTitles:NSLocalizedString(@"接受", nil), nil];
                _alert.tag = 999;
                
            }
            
            [_alert show];
            
            
        }
        else
        {
            [playerManager activateMicrophone:NO];
            
            [playerManager acceptMediaInvitation:NO type:type];
            
            
        }
    }
}



//直播未开始返回
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999 && buttonIndex == 1) {
        
        [self.playerManager activateMicrophone:YES];
        [self.playerManager acceptMediaInvitation:YES type:GSPMediaInvitationTypeAudioOnly];
        
    }
    else if (alertView.tag == 999 && buttonIndex == 0) {
        [self.playerManager acceptMediaInvitation:NO type:GSPMediaInvitationTypeAudioOnly];
    }
}



- (void)dealloc {
    [self.playerManager leave];
}


#pragma mark ---- 网络请求

//- (void)NetWorkGetUrl {
//
//    BigWindCar *manager = [BigWindCar manager];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
//
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
//        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
//        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
//    }
//
//    [dic setValue:_ID forKey:@"live_id"];
//    [dic setValue:_secitonID forKey:@"section_id"];
//
//    [manager BigWinCar_getLiveUrl:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"======  %@",responseObject);
//        NSString *msg = responseObject[@"msg"];
//        //        if ([responseObject[@"code"] integerValue] != 1) {
//        //            [TKProgressHUD showError:msg toView:self.view];
//        //        } else {
//        //            [TKProgressHUD showSuccess:@"申请成功" toView:self.view];
//        //            [self.navigationController popToRootViewControllerAnimated:YES];
//        //        }
//        if ([responseObject[@"code"] integerValue] == 1) {
//            _liveDict = responseObject[@"data"];
//            [self initLive];
//
//            [self initBtn];
//
//            [self initScrollow];
//            //聊天
//            [self initChat];
//            //投票
//            [self initVote];
//            //举手
//            [self initHanUp];
//            //问答
//            [self initQastion];
//            //文档
//            [self initDockt];
//
//            [self.view addSubview:_videoView];
//        } else {
//            [TKProgressHUD showError:msg toView:self.view];
//        }
//
//
//
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
//}
//


@end
