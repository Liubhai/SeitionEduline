//
//  TKPlaybackMaskView.m
//  EduClassPad
//
//  Created by MAC-MiNi on 2017/9/11.
//  Copyright © 2017年 beijing. All rights reserved.
//


#import "TKPlaybackMaskView.h"
#import "TKProgressSlider.h"
#import "TKEduSessionHandle.h"

#define ThemeKP(args) [@"ClassRoom.PlayBack." stringByAppendingString:args]

@interface TKPlaybackMaskView ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isSlidering;
//@property (nonatomic, assign) BOOL isSliderState; // slider 可用状态;

@property (nonatomic, assign) NSTimeInterval seekInterval;
@property (nonatomic, assign) NSTimeInterval acceptSeekTime;

@property (nonatomic, assign) NSTimeInterval lastSyncTime;


@property (nonatomic, strong) UIView *bottmView;//工具条
@property (nonatomic, strong) UIView *toolView;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, assign) NSTimeInterval duration;//当前时间

@property (nonatomic, assign) NSTimeInterval lastTime;//结束时间

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UIButton         *audioButton;
@property (nonatomic, strong) TKProgressSlider *audioslider;//声音控制条

@property (nonatomic, strong) UIButton         *speedButton;//倍速

@end

@implementation TKPlaybackMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isSlidering = NO;
        self.seekInterval = 2;
        self.acceptSeekTime = 0;
        [self setupViews:frame];
    }
    return self;
}

- (void)setupViews:(CGRect)frame {
    
    CGFloat tBottmViewWH = 60;
    CGFloat tViewCap = 8;
    
    
    //控制条背景图
    self.toolView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, frame.size.height-tBottmViewWH-10, frame.size.width-20, tBottmViewWH)];
        view.sakura.backgroundColor(ThemeKP(@"toolBackgroundColor"));
        view.sakura.alpha(ThemeKP(@"toolBackgroundAlpha"));
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = tBottmViewWH/2.0;
        [self addSubview:view];
        view;
    });
    
    
    //bottonBar
    self.bottmView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-tBottmViewWH-10, self.size.width, tBottmViewWH)];
    self.bottmView.backgroundColor = [UIColor clearColor];

    [self addSubview:self.bottmView];
    
    //播放按钮
    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, tBottmViewWH, tBottmViewWH)];
//    self.playButton
    self.playButton.sakura.image(ThemeKP(@"playBtnPauseImage"),UIControlStateSelected);
    self.playButton.sakura.image(ThemeKP(@"playBtnPlayImage"),UIControlStateNormal);
    
    [self.playButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottmView addSubview:self.playButton];
    
    //名称
    CGFloat tProgressSliderW = CGRectGetWidth(self.bottmView.frame) - CGRectGetMaxX(self.playButton.frame)-tViewCap-180;
//    CGFloat tProgressSliderW = self.bottmView.width*0.5;

    //进度滑块
    self.iProgressSlider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(self.playButton.rightX + tViewCap,
                                                                              0,
                                                                              tProgressSliderW,
                                                                              tBottmViewWH)];
    self.iProgressSlider.sakura.minimumTrackTintColor(ThemeKP(@"sliderMinimumTrackTintColor"));
    self.iProgressSlider.sakura.maximumTrackTintColor(ThemeKP(@"sliderMaximumTrackTintColor"));
    [self.iProgressSlider setThumbImage:[TKTheme imageWithPath:ThemeKP(@"sliderControlImage")] forState:UIControlStateNormal];
    
    self.iProgressSlider.continuous = NO;
    // 滑动
    [self.iProgressSlider addTarget:self
                             action:@selector(progressValueChange:)
                   forControlEvents:UIControlEventValueChanged];
    // 点击
    UITapGestureRecognizer* tapProgressViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProgressView:)];
    tapProgressViewGesture.delegate = self;
    [self addGestureRecognizer:tapProgressViewGesture];
//    
    [self.bottmView addSubview:self.iProgressSlider];
    
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iProgressSlider.rightX+5, (tBottmViewWH-25)/2.0, 150, 25)];
    self.timeLabel.text = @"00:00/00:00";
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottmView addSubview:self.timeLabel];
    
    //菊花
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activity setCenter:self.center];//指定进度轮中心点
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    self.activity.hidesWhenStopped = YES;
    [self addSubview:self.activity];
    
    
    self.speedButton = ({
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:MTLocalized(@"Button.playbackSpeed") forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(speedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottmView addSubview:button];
        button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(self.bottmView.width-50, 0, 50, tBottmViewWH);
        button.hidden = YES;
        button;
        
    });
    
    self.audioButton = ({
        // 声音开关按钮
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.timeLabel.rightX+5, (tBottmViewWH-25)/2.0, 25, 25)];
        button.sakura.image(ThemeKP(@"voiceBtnSelectedImage"),UIControlStateSelected);
        button.sakura.image(ThemeKP(@"voiceBtnNormalImage"),UIControlStateNormal);
        [button addTarget:self action:@selector(audioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottmView addSubview:button];
        button.hidden = YES;
        button;
        
    });
    self.audioslider = ({
        //声道滑块
        TKProgressSlider *slider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(self.audioButton.rightX+5, 25, self.speedButton.leftX-(self.audioButton.rightX+5), 25)];
        slider.sakura.minimumTrackTintColor(ThemeKP(@"sliderMinimumTrackTintColor"));
        slider.sakura.maximumTrackTintColor(ThemeKP(@"sliderMaximumTrackTintColor"));
        [slider setThumbImage:[TKTheme imageWithPath:ThemeKP(@"sliderControlImage")] forState:UIControlStateNormal];
        
        slider.enabled = YES;
        slider.value = 1;
        [slider addTarget:self action:@selector(audioVolumChange:) forControlEvents:UIControlEventValueChanged];
        //    [self addSubview:selflignment = NSTextAlignmentLeft;
        [self.bottmView addSubview:slider];
        slider.hidden = YES;
        slider;
        
    });
    
   
    
}

#pragma mark - 倍速
- (void)speedButtonClicked:(UIButton *)sender {
}

#pragma mark - 静音
- (void)audioButtonClicked:(UIButton *)sender{
    
}
#pragma mark - 声音控制
- (void)audioVolumChange:(TKProgressSlider *)slider{
    
}
- (void)playOrPauseAction:(UIButton *)sender {
    if (sender.selected == NO) {
        [[TKEduSessionHandle shareInstance] playback];
        sender.selected = YES;
    } else {
        [[TKEduSessionHandle shareInstance] pausePlayback];
        sender.selected = NO;
    }
    [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];

    //在播放录制件的过程中，如果有答题卡（会涉及到本地定时器），点击暂停应关闭计时器
    //object：YES 表示暂停 NO表示播放中
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimerStateDuringPlaybackNotification" object:@(!sender.selected)];
}
- (void)setSlideringState{
    self.isSlidering = YES;
}
#pragma mark - 播放 控制
// 手势
- (void)tapProgressView: (UIGestureRecognizer *)gesture{
    
    //    if (gesture.state != UIGestureRecognizerStateBegan)
    //        return;
    
    
    // 隐藏状态 直接显示
    if (self.bottmView.hidden) {
        [self showTool];
        return;
    }
    
//    if (self.isSliderState) {
//
//        self.isSliderState = NO;
        CGPoint point = [gesture locationInView:self.iProgressSlider];
        // 点击滑块
        if ([self.iProgressSlider pointInside:point withEvent:nil]) {
            
            float value = (self.iProgressSlider.maximumValue - self.iProgressSlider.minimumValue)
            *
            (point.x / self.iProgressSlider.width);
            
            [self.iProgressSlider setValue:value];
            [self progressValueChange:self.iProgressSlider];
            
        }
        else {
            [self showTool];
        }
//    }
    
    
    //    NSLog(@"%d, %@", isClickSlider, NSStringFromCGPoint(point));
}
// 播放进度滑块
- (void)progressValueChange:(TKProgressSlider *)slider {
    
    //TKLog(@"&&&playback: seek, %f", self.iProgressSlider.sliderPercent);
//    if (!self.isSliderState)
//        return;
    if (self.iProgressSlider.value < 0) {
        self.iProgressSlider.value = 0;
    }
    
    if (self.iProgressSlider.value > 1) {
        self.iProgressSlider.value = 1;
    }
    NSTimeInterval pos = floor(self.iProgressSlider.value * self.duration);
    
    if (NSDate.date.timeIntervalSince1970 - self.acceptSeekTime < self.seekInterval) {
        return;
    }
    
    if (self.seekInterval > 0) {
        self.acceptSeekTime = NSDate.date.timeIntervalSince1970;
        [[TKEduSessionHandle shareInstance] seekPlayback:pos];
        if (!self.playButton.selected) {
            
            [[TKEduSessionHandle shareInstance] playback];
            self.playButton.selected = YES;
        }
        NSLog(@"tk-------------滑动!");
    }
    self.isSlidering = NO;
}

- (void)update:(NSTimeInterval)current
{
    if (self.playButton.selected == NO) {
        return;
    }
    
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    //liyanyan
//    if (!self.iProgressSlider.isSliding) {
  
    if (!self.isSlidering) {
        self.iProgressSlider.value = current/self.duration;
    }
    
    if (current!=self.lastTime) {
        [self.activity stopAnimating];
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self formatPlayTime:current/1000], isnan(self.duration)?@"00:00":[self formatPlayTime:self.duration/1000]];
        
    } else {
        
        if (current < self.duration) {
            [self.activity startAnimating];
        }
        
    }
    
    self.lastTime = current;
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    if(now - self.lastSyncTime > 1) {
        self.lastSyncTime = now;
    }
//    self.isSliderState = YES;
    //[[TKEduSessionHandle shareInstance]configurePlayerRoute: NO isCancle:NO];
}

- (NSString *)formatPlayTime:(NSTimeInterval)duration {
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
//    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
    if (hour > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hour, minute, secend];
    }
    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
}

- (void)playbackEnd {
    //TKLog(@"&&&playback: end");
    
    self.playButton.selected = NO;
    self.iProgressSlider.value = 0;
    [[TKEduSessionHandle shareInstance] seekPlayback:0];
    [[TKEduSessionHandle shareInstance] pausePlayback];
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", @"00:00", [self formatPlayTime:self.duration/1000]];
}

- (void)getPlayDuration:(NSTimeInterval)duration {
    //TKLog(@"&&&playback: get duration");
    
    if (self.playButton.selected == YES) {
        // 播放状态断线重连，进行seek
        NSTimeInterval pos = self.iProgressSlider.value * self.duration;
        [[TKEduSessionHandle shareInstance] seekPlayback:pos];
    } else {
        if (self.iProgressSlider.value > 0.001) {
            // 暂停状态断线重连，进行seek，然后再pause
            NSTimeInterval pos = self.iProgressSlider.value * self.duration;
            [[TKEduSessionHandle shareInstance] seekPlayback:pos];
            [[TKEduSessionHandle shareInstance] pausePlayback];
        } else {
            // 正常状态
            self.duration = duration;
            self.playButton.selected = YES;
            [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
        }
    }
}

- (void)showTool{
    self.bottmView.hidden = !self.bottmView.hidden;
    self.toolView.hidden = !self.toolView.hidden;
}

@end
