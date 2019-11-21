//
//  TKWhiteBroadManager.h
//  TKWhiteBroad
//
//  Created by MAC-MiNi on 2018/4/9.
//  Copyright © 2018年 MAC-MiNi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TKWhiteBoardManagerDelegate.h"
#import <TKRoomSDK/TKRoomManager.h>
#import "TKWhiteBoardView.h"
#import "TKWhiteBoardHandel.h"
#import "TKMediaMarkView.h"
#import "TKWBRoomJson.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^loadFinishedBlock) (void);
typedef void(^pageControlBlock)(int currentPage, int totalPage, BOOL showOnWeb);
typedef void(^pageControlMarkBlock)(NSDictionary *);

typedef NSArray* _Nullable (^WebContentTerminateBlock)(void);
typedef NS_ENUM(NSUInteger, TKWhiteBoardErrorCode) {
    TKError_OK,
    TKError_Bad_Parameters,
};

typedef NS_ENUM(NSInteger, TKBrushToolType)
{
    TKBrushToolTypeMouse   = 100,
    TKBrushToolTypeLine    = 10,
    TKBrushToolTypeText    = 20,
    TKBrushToolTypeShape   = 30,
    TKBrushToolTypeEraser  = 50,
};


@interface TKWhiteBoardManager : NSObject
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) BOOL isBeginClass;// 是否已上课
@property (nonatomic, assign) BOOL UIDidAppear;//页面加载完成, 是否需要缓存标识
@property (nonatomic, assign) BOOL isConnectToRoom; //教室链接成功
@property (nonatomic, assign) BOOL preloadingFished;//预加载文档标识
// 以下两者都执行完，开始预加载
@property (nonatomic, assign) BOOL isUpdateWebAddressInfo;//文档服务器地址，web地址，备份地址 上传
@property (nonatomic, assign) BOOL isOnpageFinish;//白板初始化finish

@property (nonatomic, strong) TKWBRoomJson * tkRoomProperty;// 房间属性

@property (nonatomic, strong) NSString *currentFileId;//当前文档id
@property (nonatomic, strong) NSMutableArray *cacheMsgPool;//缓存数据
@property (nonatomic, strong) NSMutableArray *preLoadingFileCacheMsgPool;//预加载文档缓存数据

@property (nonatomic, strong) NSDictionary *configration;//配置项

@property (nonatomic, strong) TKWhiteBoardView *nativeWhiteBoardView;
@property (nonatomic, strong) TKMediaMarkView *__nullable mediaMarkView;
@property (nonatomic, strong) TKWhiteBoardHandel *documentBoard;//文档及标注

@property (nonatomic, copy) WebContentTerminateBlock _Nullable webContentTerminateBlock;//webview内存过高白屏回调
@property (nonatomic, copy) pageControlBlock pageControlBlock;
@property (nonatomic, copy) pageControlMarkBlock pageControlMarkBlock;// 课件备注

@property (nonatomic, strong) NSString * colourid;// 皮肤ID
@property (nonatomic, assign) float fileRatio;

/**
 单例
 */
+ (instancetype)shareInstance;
/**
 销毁白板
 */
+ (void)destroy;

/**
 注册白板
 */
- (void)registerDelegate:(id<TKWhiteBoardManagerDelegate>)delegate configration:(NSDictionary *)config;


//创建白板视图
- (UIView *)createWhiteBoardWithFrame:(CGRect)frame
                    loadComponentName:(NSString *)loadComponentName
                    loadFinishedBlock:(loadFinishedBlock)loadFinishedBlock;


//发送缓存的消息
- (void)sendCacheInformation:(NSMutableArray *)array;


//更新地址
- (void)updateWebAddressInfo;

/**
 创建小白板
 @param companyid 公司id
 @return 返回白板数据
 */
- (NSDictionary *)createWhiteBoard:(NSNumber *)companyid;


/**
 添加文档
 
 @param file 文档
 */
- (void)addDocumentWithFile:(NSDictionary *)file;
/**
 添加文档
 
 @param file 文档
 */
- (void)delDocumentFile:(NSDictionary *)file;

/**
 设置默认文档
 */
- (void)setTheCurrentDocumentFileID:(NSString *)fileId;

/**
 给白板发送预加载的文档
 */
- (void)sendPreLoadingFile;

//切换文档
- (int)changeDocumentWithFileID:(NSString *)fileId isBeginClass:(BOOL)isBeginClass isPubMsg:(BOOL)isPubMsg;

/**
 是否显示工具箱
 
 @param isShow ture显示  false 不显示
 */
- (void)showToolbox:(BOOL)isShow;

/**
 是否显示画笔工具
 
 @param isShow 是否显示
 */
- (void)choosePen:(BOOL)isShow;

/**
 是否显示自定义奖杯
 
 @param isShow 是否显示
 */
- (void)showCustomTrophy:(BOOL)isShow;

///**
// 打开备注
// */
//- (void)openDocumentRemark;
//
///**
// 关闭备注
// */
//- (void)closeDocumentRemark;

/**
 重置白板所有的数据
 */
- (void)resetWhiteBoardAllData;

// 刷新白板
- (void)refreshWhiteBoard;

// 刷新 webview scrollview offset (键盘消失 webview 不弹回)
- (void)refreshWBWebViewOffset:(CGPoint) point;

//关闭动态ppt视频播放
- (void)unpublishNetworkMedia:(id _Nullable)data;

//断开连接
- (void)disconnect:(NSString *_Nullable)reason;

/**
 删除白板界面
 
 @param loadComponentName 白板类型
 */
- (void)deleteView:(NSString *)loadComponentName;

/**
 房间失去连接
 
 @param reason 原因
 */
- (void)roomWhiteBoardOnDisconnect:(NSString * _Nullable)reason;

/**
 清空所有数据
 */
- (void)clearAllData;


/**
 重新加载白板  @此方法仅供白板测试使用
 */
- (void)webViewreload;

- (void)playbackPlayAndPauseController:(BOOL)play;

- (void)playbackSeekCleanup;

- (void)setPageParameterForPhoneForRole:(int)aRole;

- (void)setAddPagePermission:(bool)aPagePermission;

#pragma mark - 画笔控制
- (void)brushToolsDidSelect:(TKBrushToolType)BrushToolType;
- (void)didSelectDrawType:(int)type color:(NSString *)hexColor widthProgress:(float)progress;

#pragma mark - 页面控制
- (void)setPageControlBlock:(pageControlBlock)block;
- (void)setPageControlMarkBlock:(pageControlMarkBlock)block;

/**
 课件 上一页
 */
- (void)whiteBoardPrePage;

/**
 课件 下一页
 */
- (void)whiteBoardNextPage;

/**
 课件 跳转页

 @param pageNum 页码
 */
- (void)whiteBoardTurnToPage:(int)pageNum;

/**
 白板 放大
 */
- (void)whiteBoardEnlarge;

/**
 白板 缩小
 */
- (void)whiteBoardNarrow;

/**
 白板 放大重置
 */
- (void)whiteBoardResetEnlarge;

/**
 视频标注恢复
 */
- (void)recoveryMediaMark;


NS_ASSUME_NONNULL_END
@end
