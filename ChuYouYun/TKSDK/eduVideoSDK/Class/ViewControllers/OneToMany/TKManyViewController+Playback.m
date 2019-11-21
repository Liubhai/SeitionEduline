//
//  TKManyViewController+Playback.m
//  EduClass
//
//  Created by 李合意 on 2018/11/19.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKManyViewController+Playback.h"

@implementation TKManyViewController (Playback)

#pragma mark - Playback

- (void)initPlaybackMaskView {
    self.playbackMaskView = [[TKPlaybackMaskView alloc] initWithFrame:CGRectMake(0,
                                                                                 TKNavHeight,
                                                                                 ScreenW,
                                                                                 ScreenH-TKNavHeight)];
    [self.view addSubview:self.playbackMaskView];
    
    //在播放录制件的时候 也能操作消息 但是不能发送消息
    CGRect frame = [self.chatViewNew convertRect:self.chatViewNew.leftBtn.frame toView:self.playbackMaskView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [self.playbackMaskView insertSubview:button atIndex:0];
    
}

- (void)buttonAction
{
    [self.chatViewNew showMessageView:self.chatViewNew.leftBtn];
}

#pragma mark - Manager Delegate
- (void)sessionManagerRoomManagerPlaybackMessageReceived:(NSString *)message
                                                  fromID:(NSString *)peerID
                                                      ts:(NSTimeInterval)ts
                                               extension:(NSDictionary *)extension{
    //当聊天视图存在的时候，显示聊天内容。否则存储在未读列表中
//    if (self.chatViewNew.leftBtn.selected) {
        //        [_chatView messageReceived:message fromID:peerID extension:extension];
        //        [self.messageView messageReceived:message fromID:peerID extension:extension];
//        [self.chatViewNew messageReceived:message fromID:peerID extension:extension];
//        return;
//    }
    
    NSString *tDataString = [NSString stringWithFormat:@"%@",message];
    NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    NSNumber *type = [tDataDic objectForKey:@"type"];
    
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
    NSString *tMyPeerId = self.iSessionHandle.localUser.peerID;
    //自己发送的收不到
    if (!peerID) {
        peerID = self.iSessionHandle.localUser.peerID;
    }
    
    NSString * nickNameStr = extension[@"nickname"];
    NSInteger role         = [extension[@"role"] intValue];
    if (nickNameStr.length == 0) {
        TKRoomUser * user = [self.iSessionHandle getUserWithPeerId:peerID];
        nickNameStr = user.nickName;
        role     = user.role;
    }
    
    BOOL isMe = [peerID isEqualToString:tMyPeerId];
    BOOL isTeacher =  role == TKUserType_Teacher?YES:NO;
    TKMessageType tMessageType = (isMe)?TKMessageTypeMe:(isTeacher?TKMessageTypeTeacher:TKMessageTypeOtherUer);
    TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:nickNameStr aTime:[TKUtil timestampToFormatString:ts]];
    
    [self.iSessionHandle addOrReplaceMessage:tChatMessageModel];
    
    [self.chatViewNew reloadData];
}

- (void)sessionManagerReceivePlaybackDuration:(NSTimeInterval)duration {
    [self.playbackMaskView getPlayDuration:duration];
}

- (void)sessionManagerPlaybackUpdateTime:(NSTimeInterval)time {
    [self.playbackMaskView update:time];
    if (time <= 1500.0) {
        //播放前 需要清理view
        //时间不准，所以认为小于1.5秒的时间都认为重新开始了播放
        [self clearAllData];
    }
}

- (void)sessionManagerPlaybackClearAll {
    
    [[TKEduSessionHandle shareInstance] clearMessageList];
    [[TKEduSessionHandle shareInstance].whiteBoardManager resetWhiteBoardAllData];
    
    //播放回放时，进度条向回拖动，清理所有小工具
    [self clearAllData];
}

- (void)sessionManagerPlaybackEnd {

    [self.playbackMaskView playbackEnd];
}
@end
