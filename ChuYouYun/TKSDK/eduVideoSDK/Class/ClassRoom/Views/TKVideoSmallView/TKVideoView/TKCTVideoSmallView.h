//
//  TKCTVideoSmallView.h
//  EduClass
//
//  Created by talkcloud on 2018/10/12.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYG.h"

@class TKEduSessionHandle,RoomUser;


typedef BOOL(^IsWhiteboardContainsSelfBlock)(void);
typedef CGRect(^ResizeVideoViewBlock)(void);
typedef CGRect(^OnRemoteMsgResizeVideoViewBlock)(CGFloat);
typedef CGPoint (^bVideoSmallViewClickeBlockType)(void);


@interface TKCTVideoSmallView : UIView

-(nonnull instancetype)initWithFrame:(CGRect)frame aVideoRole:(TKEVideoRole)aVideoRole NS_DESIGNATED_INITIALIZER;

-(nonnull instancetype)initWithCoder:(NSCoder * _Nullable)aDecode NS_DESIGNATED_INITIALIZER;


/** *  奖杯 */
//@property(strong,nonatomic)UIButton *_Nonnull iGifButton;
/** *  当前看的peerid */
@property(copy,nonatomic)NSString *_Nonnull iPeerId;
/** *  是否拖拽出去了 */
@property(assign,nonatomic)BOOL isDrag;

/** *  是否分屏 */
@property(assign,nonatomic)BOOL isSplit;

/** *  当前的用户 */
@property(strong,nonatomic)TKRoomUser *_Nullable iRoomUser;

/** *  视频tag */
@property (nonatomic, assign) NSInteger iVideoViewTag;

/** *  授权等点击事件 */
@property(strong,nonatomic)UIButton *_Nonnull iFunctionButton;
/** *  授权等点击事件 */
@property(assign,nonatomic)BOOL  isNeedFunctionButton;

@property(copy,nonatomic)bVideoSmallViewClickeBlockType  _Nullable bVideoSmallViewClickedBlock;


@property(nonatomic,copy) void(^ _Nullable splitScreenClickBlock)(TKEVideoRole aVideoRole);//分屏回调

@property(nonatomic,copy) void(^ _Nullable resetMineBlock)(TKEVideoRole aVideoRole);//恢复位置
@property(nonatomic,copy) void(^ _Nullable resetAllBlock)(TKEVideoRole aVideoRole);//全部恢复

@property(nonatomic,copy) void(^ _Nullable finishScaleBlock)(void);//分屏回调

@property (nonatomic, copy) IsWhiteboardContainsSelfBlock _Nullable isWhiteboardContainsSelfBlock;

@property (nonatomic, copy) ResizeVideoViewBlock _Nullable resizeVideoViewBlock;

@property (nonatomic, copy) CGRect(^onRemoteMsgResizeVideoViewBlock)(CGFloat scale);


@property (nonatomic, assign) CGFloat originalWidth;			//设置原始宽度
@property (nonatomic, assign) CGFloat originalHeight;			//原始高度
@property (nonatomic, assign) CGFloat currentWidth;				//当前宽度
@property (nonatomic, assign) CGFloat currentHeight;			//当前高度
@property (nonatomic, assign) CGRect  whiteBoardViewFrame;		// 此属性可控制视图改变尺寸的范围

/**
 更改用户名
 
 @param aName 用户名
 */
-(void)changeName:(NSString *_Nullable)aName;

/**
 隐藏弹出框
 */

-(void)clearVideoData;
- (void)endInBackGround:(BOOL)isInBackground;

/**
 缩放视频窗口
 
 @param scale 缩放比例
 */
- (void)changeVideoSize:(CGFloat)scale inFrame:(CGRect)rect;

/**
 隐藏视频菜单弹出框
 */
- (void)hidePopMenu;

/**
 隐藏小视频上的按钮
 
 @param isShow 是否显示
 */
- (void)maskViewChangeForPicInPicWithisShow:(BOOL)isShow;
- (void)removeAllObserver;
@end
