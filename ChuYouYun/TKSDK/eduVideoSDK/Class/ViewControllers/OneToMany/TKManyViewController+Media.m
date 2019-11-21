//
//  TKManyViewController+Media.m
//  EduClass
//
//  Created by maqihan on 2018/11/20.
//  Copyright © 2018 talkcloud. All rights reserved.
//

#import "TKManyViewController+Media.h"
#import <objc/runtime.h>
#import "TKMediaDocModel.h"
#import <TKWhiteBoard/TKMediaMarkView.h>
#import "Masonry.h"

@implementation TKManyViewController (Media)

/**用户媒体流发布状态 变化回调*/
- (void)sessionManagerOnShareMediaState:(NSString *)peerId state:(TKMediaState)state extensionMessage:(NSDictionary *)message{
   
    [self.view endEditing:YES];
    
    if (state) {
        [self.iSessionHandle configurePlayerRoute:NO isCancle:NO];
        [self.iSessionHandle configureHUD:@"" aIsShow:NO];
        
        [self.iSessionHandle.whiteBoardManager unpublishNetworkMedia:nil];
        //peerid设置为空，不设置本地的page变量
        [self.iSessionHandle configurePage:false isSend:NO to:sTellAll peerID:@""];
        self.iSessionHandle.isPlayMedia = YES;

        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        BOOL hasVideo = false;
        if([message objectForKey:@"video"]){
            hasVideo = [message[@"video"] boolValue];
        }
        
        objc_setAssociatedObject(self, @selector(sessionManagerOnShareMediaState:state:extensionMessage:), @(hasVideo), OBJC_ASSOCIATION_RETAIN);

        //进入视频隐藏聊天按钮，退出视频显示聊天按钮
        self.chatViewNew.hidden = hasVideo;
        //进入视频，未收起则收起；音频不需要收起
        if (hasVideo) {
            [self.chatViewNew.keyboardView.inputField resignFirstResponder];
            [self.chatViewNew hide:YES];
            [self tapOnViewToHide];
        }
        
        if (!hasVideo) {
            //TODO: - mp3模式下_iMediaView坐标有变化，顶部紧贴白板
            CGFloat mp3height = IS_PAD ? 91 : 91;
            CGFloat mp3Width = IS_PAD ? 363 : 363;
            //iphone或者ipad统一大小，按比例的话手机太小了
            frame = CGRectMake(CGRectGetMinX(self.view.frame) + 10,
                               /*CGRectGetMaxY(self.iTKEduWhiteBoardView.frame) - mp3height - (IS_PAD ? 60 : 45)*/self.whiteboardBackView.y + 5,
                               /*CGRectGetWidth(self.iTKEduWhiteBoardView.frame) - 20*/mp3Width, mp3height);
            if ([TKEduSessionHandle shareInstance].localUser.role== TKUserType_Patrol || [TKEduSessionHandle shareInstance].localUser.role== TKUserType_Student || ([TKEduSessionHandle shareInstance].localUser.role ==  TKUserType_Playback)) {
                
                frame.size.width = mp3height;
            }
            [TKEduSessionHandle shareInstance].iIsPlaying = YES;
            if ([TKEduSessionHandle shareInstance].iPreMediaDocModel) {
                [TKEduSessionHandle shareInstance].iCurrentMediaDocModel = [TKEduSessionHandle shareInstance].iPreMediaDocModel;
                [TKEduSessionHandle shareInstance].iPreMediaDocModel = nil;
            }
            else {
                
            }
        }
        
        // 播放的MP4前，先移除掉上一个MP4窗口
        if (self.iMediaView) {
            [self.iMediaView removeFromSuperview];
            self.iMediaView = nil;
        }
        
        TKCTBaseMediaView *tMediaView = [[TKCTBaseMediaView alloc] initWithMediaPeerID:peerId extensionMessage:message frame:frame];
        self.iMediaView = tMediaView;
        
        // 如果是回放，需要将播放视频窗口放在回放遮罩页下
        if (self.iSessionHandle.isPlayback == YES) {
            [self.view insertSubview:self.iMediaView belowSubview:self.playbackMaskView];
//            videoOriginFrame = self.iTeacherVideoView.frame;// 画中画开始的地方 进行了缓存，此处多余 2018-12-11
        } else {
            [self.backgroundImageView addSubview:self.iMediaView];
            [self.backgroundImageView bringSubviewToFront: self.iMediaView];
//            videoOriginFrame = self.iTeacherVideoView.frame;
        }
        
        // 黑一下
        if ([TKEduSessionHandle shareInstance].iCurrentMediaDocModel == nil) {
            if (message[@"fileid"] && [message[@"fileid"] integerValue]) {
                
                [TKEduSessionHandle shareInstance].iCurrentMediaDocModel= [TKMediaDocModel new];
                [TKEduSessionHandle shareInstance].iCurrentMediaDocModel.fileid = [NSNumber numberWithInteger: [message[@"fileid"] integerValue]];
            }
        }
        [[TKEduSessionHandle shareInstance] sessionHandlePlayMediaFile:peerId renderType:0 window:tMediaView completion:^(NSError *error) {
            
            [self.iMediaView setVideoViewToBack];
            if (hasVideo) {
                
                [self.iMediaView loadLoadingView];
            }
            
        }];
        
        
    }
    else{
        BOOL hasVideo = ((NSNumber *)objc_getAssociatedObject(self, @selector(sessionManagerOnShareMediaState:state:extensionMessage:))).boolValue;
        if (hasVideo) {
            self.chatViewNew.hidden = NO;
            [self tapOnViewToHide];
        }
        objc_setAssociatedObject(self, @selector(sessionManagerOnShareMediaState:state:extensionMessage:), nil, OBJC_ASSOCIATION_RETAIN);
        
        //媒体流停止后需要删除sVideoWhiteboard
        [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sVideoWhiteboard ID:sVideoWhiteboard To:sTellAll Data:@{} completion:nil];
        [[TKEduSessionHandle shareInstance]configurePage:[TKEduSessionHandle shareInstance].iIsCanPage isSend:NO to:sTellAll peerID:@""];
        
        [TKEduSessionHandle shareInstance].isPlayMedia = NO;
        [[TKEduSessionHandle shareInstance] configureHUD:@"" aIsShow:NO];
        
        
        [[TKEduSessionHandle shareInstance] sessionHandleUnPlayMediaFile:peerId completion:nil];
        [self.iMediaView deleteWhiteBoard];
        
        [self.iMediaView removeFromSuperview];
        self.iMediaView = nil;
        [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
        if ( [TKEduSessionHandle shareInstance].isChangeMedia) {
            
            [TKEduSessionHandle shareInstance].isChangeMedia = NO;
            TKMediaDocModel *tMediaDocModel =  [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
            NSString *tNewURLString2 = [TKUtil absolutefileUrl:tMediaDocModel.swfpath
                                                         webIp:sHost
                                                       webPort:sPort];
            
            BOOL tIsVideo = [TKUtil isVideo:tMediaDocModel.filetype];
            
            NSString * toID = [TKEduSessionHandle shareInstance].isClassBegin ? sTellAll : [TKEduSessionHandle shareInstance].localUser.peerID;
            
            NSString *fileID = [NSString stringWithFormat:@"%@",tMediaDocModel.fileid];
            [[TKEduSessionHandle shareInstance] sessionHandlePublishMedia:tNewURLString2
                                                                 hasVideo:tIsVideo
                                                                   fileid:fileID
                                                                 filename:tMediaDocModel.filename
                                                                     toID:toID
                                                                    block:nil];
            
        }
        
        [TKEduSessionHandle shareInstance].iCurrentMediaDocModel = nil;
        [TKEduSessionHandle shareInstance].iIsPlaying = NO;
        
        // 画中画
        if (self.roomJson.configuration.coursewareFullSynchronize &&
            self.iSessionHandle.iIsFullState == NO &&
            self.iSessionHandle.isPicInPic) {
            
            [self changeVideoFrame:NO];
        }
    }
}

/**更新媒体流的信息回调*/
- (void)sessionManagerUpdateMediaStream:(NSTimeInterval)duration pos:(NSTimeInterval)pos isPlay:(BOOL)isPlay{
    
    [self.iMediaView updatePlayUI:isPlay];
    [self.iMediaView update:pos total:duration isPlay:isPlay];
    
    if (self.iSessionHandle.iIsPlaying != isPlay) {
        self.iSessionHandle.iIsPlaying = isPlay;
    }
}

/**媒体流加载出第一帧画面回调*/
- (void)sessionManagerMediaLoaded
{
    if (self.iMediaView) {
        [self.iMediaView hiddenLoadingView];
    }
    if (self.iFileView) {
        [self.iFileView hiddenLoadingView];
    }
}

@end
