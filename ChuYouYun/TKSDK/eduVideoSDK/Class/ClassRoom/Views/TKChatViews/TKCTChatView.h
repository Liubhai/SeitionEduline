//
//  TKCTChatView.h
//  EduClass
//
//  Created by talkcloud on 2018/10/16.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKCTBaseView.h"
#import "TKMessageTableViewCell.h"
#import "TKChatMessageTableViewCell.h"
//#import "TKTeacherMessageTableViewCell.h"
#import "TKEduSessionHandle.h"
#import "TKChatToolView.h"

@interface TKCTChatView : TKCTBaseView
@property (nonatomic, strong) NSTimer *chatTimer;
@property (nonatomic, assign) BOOL chatTimerFlag;
@property (nonatomic, strong) NSString *lastSendChatTime;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UITableView *iChatTableView; // 聊天tableView
@property (nonatomic, strong) NSArray<TKChatMessageModel *>  *iMessageList;//聊天列表
@property (nonatomic, strong) TKChatToolView *toolView; // 聊天输入工具条
@property (nonatomic, strong) TKChatToolView *keyboardView;// 实际 聊天输入工具条
@property (nonatomic, assign) CGFloat keyboardViewHeight;
@property (nonatomic, strong) UIButton *xButton; // 全体禁言
@property (nonatomic, strong) Class chatCellClass;
@property (nonatomic, strong) Class msgCellClass;
@property (nonatomic, assign) CGFloat tTimeLabelHeigh;
@property (nonatomic, assign) CGFloat tMessageLabelWidth;
@property (nonatomic, assign) CGFloat tContentWidth;
@property (nonatomic, assign) CGFloat tTranslateLabelWidth;
- (id)initWithFrame:(CGRect)frame chatController:(NSString *)chatController;


- (void)reloadData;
//接收聊天消息
- (void)messageReceived:(NSString *)message
                 fromID:(NSString *)peerID
              extension:(NSDictionary *)extension;

- (void)shutUpAction:(UIButton *)btn;
- (void)sendMessage:(NSString *)message;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)banChat:(NSNotification *)notification;
- (void)loadNotification;
- (void)keyboardWillShow:(NSNotification*)notification;

- (void)keyboardWillHide:(NSNotification *)notification;
@end
