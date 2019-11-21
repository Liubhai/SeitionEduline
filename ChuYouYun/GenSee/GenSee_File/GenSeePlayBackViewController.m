//
//  GenSeePlayBackViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/8/2.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "GenSeePlayBackViewController.h"
#import <PlayerSDK/VodPlayer.h>
#import <PlayerSDK/downItem.h>
#import <PlayerSDK/GSVodDocView.h>
#import "sys/utsname.h"
#import <AVFoundation/AVFoundation.h>
#import "SpeedSettingViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"

#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kButtonWidth      60
#define kButtonHeight     20



@interface GenSeePlayBackViewController ()<VodPlayDelegate,VodDownLoadDelegate,GSVodDocViewDelegate>

{
    CGRect videoViewRect;
    CGRect docViewRect;
    BOOL hasOrientation;
    BOOL isVideoFinished;
    float videoRestartValue;
    
    BOOL isDragging;
    
    int last;
}

@property (nonatomic, strong) NSString *vodId;
@property (nonatomic, strong) VodPlayer *vodplayer;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UISlider *progress;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIImageView *docImageView;

@property(nonatomic,assign)BOOL isDocFullMode;

@end

@implementation GenSeePlayBackViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    isVideoFinished = NO;
    videoRestartValue = 0;
    _isLivePlay = YES;
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backButton)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [self.navigationItem setTitle: @"播放中···"];
    
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIBarButtonItem *speedOption = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSpeedOption)];
    speedOption.title = @"播放速度";
    self.navigationItem.rightBarButtonItem = speedOption;
    
    //适配iOS6
    //    CGFloat y = [[UIApplication sharedApplication]statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
    //        y = 0;
    //    }
    
    CGFloat y = 0;
    
    videoViewRect = CGRectMake(0, y, kScreenWidth, kScreenWidth*3/4);
    docViewRect = CGRectMake(0,kScreenWidth*3/4 + 20 + y + kButtonHeight + 20, kScreenWidth,kScreenHeight - (kScreenWidth*3/4 + 20 + y + kButtonHeight + 20));
    
    //iOS6
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        docViewRect = CGRectMake(0,kScreenWidth*3/4 + 20 + y + kButtonHeight + 20, kScreenWidth,kScreenHeight - (kScreenWidth*3/4 + 20 + y + kButtonHeight + 20)- 70);
    }
    
    self.vodplayer.vodDocShowView.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    
    
    _pauseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenWidth*3/4 + 20 + y, kButtonWidth, kButtonHeight)];
    [_pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [_pauseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _playBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 60, kScreenWidth*3/4 + 20 + y, kButtonWidth, kButtonHeight)];
    [_playBtn setTitle:@"恢复" forState:UIControlStateNormal];
    [_playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _progress = [[UISlider alloc]initWithFrame:CGRectMake(kButtonWidth + 10,kScreenWidth*3/4 + 20 + y, kScreenWidth - 2*kButtonWidth - 20, kButtonHeight)];
    
    [self.view addSubview:_pauseBtn];
    [self.view addSubview:_playBtn];
    [self.view addSubview:_progress];
    
    [_progress addTarget:self action:@selector(doSeek:) forControlEvents:UIControlEventTouchUpInside];
    [_progress addTarget:self action:@selector(doHold:) forControlEvents:UIControlEventTouchDown];
    [_playBtn addTarget:self action:@selector(doPlay) forControlEvents:UIControlEventTouchUpInside];
    [_pauseBtn addTarget:self action:@selector(doPause) forControlEvents:UIControlEventTouchUpInside];
    
    //判断是在线播放还是离线播放(test)
    if (_isLivePlay){
        //        在线播放
        downItem *Litem = [[VodManage shareManage]findDownItem:_item.strDownloadID];
        if (Litem) {
            if (self.vodplayer) {
                [self.vodplayer stop];
                self.vodplayer = nil;
            }
            //            self.vodplayer = [[VodPlayer alloc] initPlay:self videoViewFrame:videoViewRect docViewFrame:docViewRect downitem:Litem playDelegate:self];
            //            self.vodplayer = ((AppDelegate*)[UIApplication sharedApplication].delegate).vodplayer;
            if (!self.vodplayer) {
                self.vodplayer = [[VodPlayer alloc]init];
            }
            self.vodplayer = [[VodPlayer alloc]init];
            
            self.vodplayer.playItem = Litem;
            self.vodplayer.mVideoView = [[VodGLView alloc]initWithFrame:videoViewRect];
            self.vodplayer.mVideoView.backgroundColor = [UIColor whiteColor];
            self.vodplayer.mVideoView.movieASImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:self.vodplayer.mVideoView ];
            self.vodplayer.docSwfView = [[GSVodDocView alloc]initWithFrame:docViewRect];
            [self.view addSubview:self.vodplayer.docSwfView];
            self.vodplayer.delegate = self;
            
            //            [self.vodplayer OnlinePlay:YES];
            //            self.vodplayer.docSwfView.vodDocDelegate=self;
            //
            //            self.vodplayer.docSwfView.gSDocModeType = VodScaleAspectFit;
            
            
            //            [self.vodplayer OnlinePlay:YES];
            [self.vodplayer OnlinePlay:YES audioOnly:NO];
        }
    } else {
        //        离线播放
        downItem *downitem = _item;
        if (downitem) {
            if (self.vodplayer) {
                [self.vodplayer stop];
                self.vodplayer = nil;
            }
            //            self.vodplayer = ((AppDelegate*)[UIApplication sharedApplication].delegate).vodplayer;
            if (!self.vodplayer) {
                self.vodplayer = [[VodPlayer alloc]init];
            }
            
            self.vodplayer.playItem = downitem;
            self.vodplayer.mVideoView = [[VodGLView alloc]initWithFrame:videoViewRect];
            [self.view addSubview:self.vodplayer.mVideoView ];
            self.vodplayer.docSwfView = [[GSVodDocView alloc]initWithFrame:docViewRect];
            [self.view addSubview:self.vodplayer.docSwfView];
            self.vodplayer.delegate = self;
            //            self.vodplayer.gSDocModeType = VodScaleAspectFit;
            
            [self.vodplayer OfflinePlay:YES];
        }
    }
    
    //    videoView双击全屏
    UITapGestureRecognizer *tapGestureRecogizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(totationVideoView:)];
    tapGestureRecogizer.numberOfTapsRequired = 2;
    [self.vodplayer.mVideoView addGestureRecognizer:tapGestureRecogizer];
    
    //    docView双击全屏
    UITapGestureRecognizer *tapGestureRecogizerD = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(totationDocView:)];
    tapGestureRecogizerD.numberOfTapsRequired = 2;
    [self.vodplayer.vodDocShowView addGestureRecognizer:tapGestureRecogizerD];
    
    //    ((AppDelegate*)[UIApplication sharedApplication].delegate).vodplayer = self.vodplayer;
    //    [self.vodplayer enableBackgroundMode];
    
    
    if ([self isHeadsetPluggedIn]) {
        
    }
}


////Navigation返回按钮方法
- (void)backButton
{
    if (self.vodplayer) {
        [self.vodplayer stop];
        self.vodplayer = nil;
        self.item = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showSpeedOption
{
    SpeedSettingViewController *svc = [[SpeedSettingViewController alloc]init];
    
    svc.vodplayer = self.vodplayer;
    
    [self presentViewController:svc animated:YES completion:nil];
    
    
}

////设置后台运行
//- (void)enterBackground
//{
//
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [session setActive:YES error:nil];
//}

//视频旋转方法
- (void)totationVideoView:(UIGestureRecognizer *)gestureRecognizer
{
    [self totationView:gestureRecognizer whichView:YES];
}

//文档旋转方法
- (void)totationDocView:(UIGestureRecognizer *)gestureRecognizer
{
    //    [self totationView:gestureRecognizer whichView:NO];
    
    
    static int tmp=0;
    if (tmp==0) {
        [self totationView:gestureRecognizer whichView:NO];
        tmp=1;
    }
    
    
    //文档全屏测试
    _isDocFullMode=!_isDocFullMode;
    
    
}

//强制旋转方法(YES:videoView全屏  NO:docView全屏)
- (void)totationView:(UIGestureRecognizer *)gestureRecognizer whichView:(BOOL) touchVideoView
{
    if (!hasOrientation) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.view.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
            if (touchVideoView) {
                self.vodplayer.mVideoView.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
                self.vodplayer.docSwfView.hidden = YES;
                
            }else{
                self.vodplayer.vodDocShowView.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
                
                //                [self.vodplayer setDocFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
                
                self.vodplayer.mVideoView.hidden = YES;
            }
            hasOrientation = YES;
            _pauseBtn.hidden = YES;
            _playBtn.hidden = YES;
            _progress.hidden = YES;
            self.navigationController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
    } else {
        [UIView animateWithDuration: 0.5 animations:^{
            self.view.transform = CGAffineTransformInvert(CGAffineTransformMakeRotation(0));
            self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            if (touchVideoView) {
                //                [self.vodplayer setVideoFrame:videoViewRect];
                
                
                self.vodplayer.mVideoView.frame = CGRectMake(0, 0, videoViewRect.size.width, videoViewRect.size.height);
                
                //    双击全屏( 调用setVideoFrame后重新设置手势 )
                UITapGestureRecognizer *tapGestureRecogizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(totationVideoView:)];
                tapGestureRecogizer.numberOfTapsRequired = 2;
                [self.vodplayer.mVideoView addGestureRecognizer:tapGestureRecogizer];
                self.vodplayer.docSwfView.hidden = NO;
            }else{
                self.vodplayer.vodDocShowView.frame = docViewRect;
                
                //                 [self.vodplayer setDocFrame:docViewRect];
                
                self.vodplayer.mVideoView.hidden = NO;
            }
            
            hasOrientation = NO;
            _pauseBtn.hidden = NO;
            _playBtn.hidden = NO;
            _progress.hidden = NO;
            //            注意显示状态栏和显示navigationbar顺序
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.navigationController.navigationBarHidden = NO;
            
        }];
    }
}

//恢复播放
- (void)doPlay
{
    if (self.vodplayer) {
        [self.vodplayer resume];
    }
    [self.navigationItem setTitle: @"播放中···"];
}

//暂停播放
- (void)doPause
{
    if (self.vodplayer) {
        [self.vodplayer pause];
    }
    [self.navigationItem setTitle: @"暂停中···"];
}

- (void)OnChat:(NSArray *)chatArray
{
    
}

- (void)doHold:(UISlider*)slider
{
    isDragging = YES;
}
//滑动条监听方法
- (void)doSeek:(UISlider*)slider
{
    //    播放结束
    if (isVideoFinished) {
        if (_isLivePlay) {
                [self.vodplayer OnlinePlay:NO audioOnly:NO];
//            [self.vodplayer OnlinePlay:NO];
            
        } else {
            [self.vodplayer OfflinePlay:NO];
        }
        
        //        [self.vodplayer setVideoFrame:videoViewRect];
        //    双击全屏( 调用setVideoFrame后重新设置手势 )
        UITapGestureRecognizer *tapGestureRecogizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(totationVideoView:)];
        tapGestureRecogizer.numberOfTapsRequired = 2;
        [self.vodplayer.mVideoView addGestureRecognizer:tapGestureRecogizer];
    }
    float duratino = slider.value;
    videoRestartValue = slider.value;
    [self.vodplayer seekTo:duratino];
    
    //    NSLog(@"DO SEEK!!!!! %d", duratino);
}

#pragma mark -VodPlayDelegate
//初始化VodPlayer代理
- (void)onInit:(int)result haveVideo:(BOOL)haveVideo duration:(int)duration docInfos:(NSDictionary *)docInfos
{
    
    [self.vodplayer getChatAndQalistAction];
    
    _progress.maximumValue = duration;
    _progress.minimumValue = 0;
    
    
    //    播放结束
    if (isVideoFinished) {
        isVideoFinished = NO;
        //    从设定好的位置开始
        [self.vodplayer seekTo:videoRestartValue];
    }
    
    
    
    [self.vodplayer getChatListWithPageIndex:1];
    [self.vodplayer getQaListWithPageIndex:1];
}


/*
 *获取聊天列表
 *@chatList   列表数据 (sender: 发送者  text : 聊天内容   time： 聊天时间)
 *
 */
- (void)vodRecChatList:(NSArray*)chatList more:(BOOL)more currentPageIndex:(int)pageIndex
{
    
}

/*
 *获取问题列表
 *@qaList   列表数据 （answer：回答内容 ; answerowner：回答者 ; id：问题id ;qaanswertimestamp:问题回答时间 ;question : 问题内容  ，questionowner:提问者 questiontimestamp：提问时间）
 *
 */
- (void)vodRecQaList:(NSArray*)qaList more:(BOOL)more currentPageIndex:(int)pageIndex
{
    
}

//进度条定位播放，如快进、快退、拖动进度条等操作回调方法
- (void) onSeek:(int) position
{
    isDragging = NO;
    [_progress setValue:position animated:YES];
}

//进度回调方法
- (void)onPosition:(int)position
{
    if (isDragging) {
        return;
    }
    
    [_progress setValue:position animated:YES];
}

- (void)onVideoStart
{
    
}



//播放完成停止通知，
- (void)onStop{
    isVideoFinished = YES;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"播放结束" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}


#pragma mark --

- (void)docVodViewOpenFinishSuccess:(GSVodDocPage*)page
{
    
    NSLog(@"*********\n");
    
}


@end
