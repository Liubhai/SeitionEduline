//
//  TKWhiteBoardHandle.h
//  TKWhiteBoard
//
//  Created by lyy on 2018/5/24.
//  Copyright © 2018年 MAC-MiNi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "TKWhiteBoardManagerDelegate.h"
#import <TKRoomSDK/TKRoomSDK.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^loadFinishedBlock) (void);
typedef void(^WebViewTerminateBlock)(void);


@protocol TKWhiteBoardHandleDelegate <NSObject>

@required
//文档控制按钮状态更新
- (void)onWhiteBoardHandleStateUpdate:(NSDictionary *)message;
//退出视频标注
- (void)onWhiteBoardHandleExitAnnotation:(NSString *)message;
//白板全屏回调
- (void)onWhiteBoardHandleFullScreen:(BOOL)isFull;
//房间链接成功msglist回调
- (void)onWhiteBoardHandleOnRoomConnectedMsglist:(NSDictionary *)msgList;
//播放ppt内部MP3
- (void)onJsPlayMedia:(NSDictionary *)msg;

@end



@interface TKWhiteBoardHandel : NSObject

@property (nonatomic, copy) WebViewTerminateBlock _Nullable WebViewTerminateBlock;//webview崩溃回调
@property (nonatomic, weak) id<TKWhiteBoardHandleDelegate> delegate;

@property (nonatomic, strong) WKWebView *webView;

- (void)setClassBegin:(BOOL)isBegin;

- (WKWebView *)createWhiteBoardWithFrame:(CGRect)frame
                         loadComponentName:(NSString *)loadComponentName
                         loadFinishedBlock:(loadFinishedBlock)loadFinishedBlock;


/**
 向js发送消息

 @param signalingName 信令名称
 @param message 消息
 */
- (void)sendSignalMessageToJS:(NSString *)signalingName message:(id)message;


/**
 向js发送消息

 @param message 消息
 */
- (void)sendMessageToJS:(NSString *)message;


/**
 向js发送动作指令

 @param action 动作
 @param cmd 消息
 */
- (void)sendAction:(NSString *)action command:(NSDictionary *)cmd;

/*
 房间链接成功
 */
- (void)whiteBoardOnRoomConnectedUserlist:(NSNumber *)code response:(NSDictionary *)response;

/**
 发送缓存消息

 @param array 缓存消息
 */
- (void)sendCacheInformation:(NSMutableArray *)array;

/**
 刷新界面
 */
- (void)refreshWhiteBoardWithFrame:(CGRect)frame;

/**
 销毁
 */
- (void)destory;

/**
 重新加载webview
 */
- (void)webViewreload;

/**
 链接房间 预加载 都成功之后 发送预加载缓存
 */
- (void)afterConnectToRoomAndPreloadingFished;
- (void)stopPlayMp3;

NS_ASSUME_NONNULL_END
@end
