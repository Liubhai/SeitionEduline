//
//  TKCTOneViewController.h
//  EduClass
//
//  Created by talkcloud on 2018/10/9.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKBaseViewController.h"
#import "TKImagePickerController.h"

#import "TKEduSessionHandle.h"
#import "TKMediaDocModel.h"

#import "TKPlaybackMaskView.h"
#import "TKUploadImageView.h"
#import "TKCTNavView.h"
#import "TKCTBaseMediaView.h"
#import "TKCTVideoSmallView.h"
#import "TKNativeWBPageControl.h"
//相册/相机
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TKCTNewChatView.h"

@interface TKOneViewController : TKBaseViewController
{
     // 需要移动的视频
    TKCTVideoSmallView *moveView;
}

//Handle处理类
@property (nonatomic, strong) TKEduSessionHandle *iSessionHandle;

/** controller */
@property (nonatomic, strong) TKImagePickerController *iPickerController;

/** View */
//白板视图
@property (nonatomic, strong) UIView   *iTKEduWhiteBoardView;
@property (nonatomic, strong) UIView *whiteboardBackView;

//回放
@property (nonatomic, strong) TKPlaybackMaskView *playbackMaskView;
//图片上传view
@property (nonatomic, strong) TKUploadImageView  *uploadImageView;
//导航
@property (nonatomic, strong) TKCTNavView        *navbarView;
//媒体流
@property (nonatomic, strong) TKCTBaseMediaView  *iMediaView;
//共享电影
@property (nonatomic, strong) TKCTBaseMediaView  *iFileView;

//房间属性
@property (nonatomic, strong) TKRoomJsonModel     *roomJson;


/** 其他 */
//白板分辨率 3/4.0 9/16.0
@property (nonatomic, assign) CGFloat iTKEduWhiteBoardDpi;
//navbar高度
@property (nonatomic, assign) NSInteger navbarHeight;
//图片上传进度
@property (nonatomic, assign) float   progress;
@property (nonatomic, strong) TKCTNewChatView *chatViewNew;//新聊天视图
@property (nonatomic, strong) TKNativeWBPageControl *pageControl;

/************************************************************************/
//初始化直播对象
- (instancetype)initWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                       aParamDic:(NSDictionary *)aParamDic;

//初始化点播对象
- (instancetype)initPlaybackWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                               aParamDic:(NSDictionary *)aParamDic;

- (void)prepareForLeave:(BOOL)aQuityourself;


/**UI*/
-(void)refreshUI;

- (void)calculateWhiteBoardVideoViewFrame;

- (void)refreshVideoViewFrame;

/**清理所有数据*/
- (void)clearAllData;

/**画中画*/
- (void)changeVideoFrame:(BOOL)isFull;

/**图片上传取消*/
- (void)cancelUpload;

/**隐藏花名册和课件库*/
- (void)tapOnViewToHide;
@end
