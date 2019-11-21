//
//  TKCTMoreViewController.h
//  EduClass
//
//  Created by talkcloud on 2018/10/9.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKBaseViewController.h"
#import "TKImagePickerController.h"
#import "TKMediaDocModel.h"
#import "TKPlaybackMaskView.h"
#import "TKCTBaseMediaView.h"
#import "TKCTVideoSmallView.h"
#import "TKCTNavView.h"
#import "TKUploadImageView.h"

//相册/相机
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TKCTNewChatView.h"
#import "TKNativeWBPageControl.h"

@interface TKManyViewController : TKBaseViewController

//Handle处理类
@property (nonatomic, strong) TKEduSessionHandle *iSessionHandle;

//视频
@property (nonatomic, weak)  id<TKEduRoomDelegate> iRoomDelegate;

/** controller */
@property (nonatomic, strong) TKImagePickerController *iPickerController;

// 房间属性
@property (nonatomic, strong) TKRoomJsonModel     *roomJson;
@property (nonatomic, assign) NSDictionary* iParamDic;// 加入房间参数
@property (nonatomic, copy) NSString *currentServer;
/** View */
//白板视图 组件
@property (nonatomic, strong) UIView   *iTKEduWhiteBoardView;
@property (nonatomic, strong) UIView *whiteboardBackView;

//回放
@property (nonatomic, strong) TKPlaybackMaskView *playbackMaskView;
//媒体流
@property (nonatomic, strong) TKCTBaseMediaView  *iMediaView;
//老师视频
@property (nonatomic, strong) TKCTVideoSmallView *iTeacherVideoView;
//共享电影
@property (nonatomic, strong) TKCTBaseMediaView  *iFileView;
//自定义顶部view
@property (nonatomic, strong) TKCTNavView        *navbarView;
//图片上传view
@property (nonatomic, strong) TKUploadImageView  *uploadImageView;

/** 其他 */
//白板分辨率 3/4.0 9/16.0
@property (nonatomic, assign) CGFloat iTKEduWhiteBoardDpi;
//图片上传进度
@property (nonatomic, assign) float   progress;

@property (nonatomic, strong) TKCTNewChatView *chatViewNew;//新聊天视图

@property (nonatomic, strong) TKNativeWBPageControl *pageControl;// 翻页控制
/************************************************************************/

//初始化直播对象
- (instancetype)initWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                       aParamDic:(NSDictionary *)aParamDic;


//初始化点播对象
- (instancetype)initPlaybackWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                               aParamDic:(NSDictionary *)aParamDic;

-(void)prepareForLeave:(BOOL)aQuityourself;

/**清理所有数据*/
- (void)clearAllData;

/**画中画*/
- (void)changeVideoFrame:(BOOL)isFull;

/**刷新白板*/
-(void)refreshWhiteBoard:(BOOL)hasAnimate;

/**UI*/
-(void)refreshUI;

/**图片上传取消*/
- (void)cancelUpload;

/**隐藏花名册和课件库*/
- (void)tapOnViewToHide;


@end
