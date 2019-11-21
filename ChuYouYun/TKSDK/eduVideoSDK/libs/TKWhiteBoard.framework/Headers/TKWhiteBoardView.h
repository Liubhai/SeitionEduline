//
//  WhiteBoardView.h
//  WhiteBoard
//
//  Created by macmini on 14/11/7.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "TKWBRoomJson.h"
#import "TKWhiteBoardEnum.h"

@protocol WhiteBoardDelegate;
@class DrawView;
@class WhiteBoardFile;
@class WhiteBoard;
@class DocShowView;
@class TKWBRoomProperty;
@class TKMiniWhiteBoardView;
@class TKNativeWBSelectorView;
@class TKNativeWBToolView;


typedef enum
{
    TKWorkModeViewer = 0,       //只能观看 不能标记 隐藏工具条
    TKWorkModeControllor = 1,   //操作状态
} TKWorkMode;


@protocol TKWhiteBoardViewDelegate <NSObject>


- (void)miniWhiteBoardAddDrawWithFileID:(NSString *)fileID shapeID:(NSString *)shapeID shapeData:(NSData *)shapeData;

@end

@interface TKWhiteBoardView : NSObject
@property (nonatomic, weak) id<TKWhiteBoardViewDelegate>wbViewDelegate;
@property (nonatomic, strong) DrawView* drawView;
@property (nonatomic, strong) DocShowView * fileView;
@property (nonatomic, strong) NSDictionary *baseDictionary;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *webaddress;
@property (nonatomic, weak)	  UIView *contentView;
@property (nonatomic, strong) TKMiniWhiteBoardView *miniWB;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NSMutableDictionary *fileDictionary;
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*classFileList;
@property (nonatomic, assign) BOOL showOnWeb;
@property (nonatomic) NSInteger pagecount; // 总页码
@property (nonatomic) NSInteger currentPage; // 当前页码
//@property (nonatomic, strong) TKNativeWBSelectorView *selectorView;
@property (nonatomic, strong) TKNativeWBToolView *toolView;
@property (nonatomic, strong) NSDictionary *remarkDict;
@property (nonatomic, strong) NSString *fileid;
//记录刚进入教室 老师的画笔状态，
@property (nonatomic, assign) BOOL selectMouse;

//创建原生绘制白板
- (instancetype)initWithBackView:(UIView *)view
                         webView:(WKWebView *)webView
                        degelate:(id<TKWhiteBoardViewDelegate>)delegate;

//接收配置项消息
- (void)setConfiguration:(TKWBRoomJson *)roomJson;

//更新 上下台状态 && 授权状态
- (void)updateProperty:(NSDictionary *)dictionary;

//设置工作模式
- (void)setWorkMode:(TKWorkMode)mode;

/**
 *   进入房间成功之后执行所有预加载信令信息
 */
- (void)afterConnectToRoomAndPreloadingFished;

/*
 房间链接成功
 */
- (void)whiteBoardOnRoomConnectedUserlist:(NSNumber *)code response:(NSDictionary *)response;


//收到白板信令
- (void)receiveWhiteBoardMessage:(NSMutableDictionary *)dictionary isDelMsg:(BOOL)isDel;

//下课清理数据
- (void)clearAfterClass;

//web课件画布更新ratio
- (void)updateWebRatio:(float)ratio;

// 更新页码
- (void)setTotalPage:(NSInteger)total currentPage:(NSInteger)currentPage;

//MARK: 放大
- (void)enlarge;

//MARK: 缩小
- (void)narrow;

//MARK: 设置具体放大值
- (void)resetEnlargeValue:(float)value;

//MARK: 恢复视频标注
- (void)recoveryMediaMark;

//断网后需要隐藏小白板
- (void)hideMiniBoardView;

// 画笔工具选择
- (void)wbToolViewDidSelect:(TKNativeToolType)type fromRemote:(BOOL)isFromRemote;

// 画笔颜色选择面板
- (void)didSelectDrawType:(int)type color:(NSString *)hexColor widthProgress:(float)progress;

@end

