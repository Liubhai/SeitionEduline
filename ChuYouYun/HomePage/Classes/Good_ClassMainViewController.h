//
//  Good_ClassMainViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBHTableView.h"
#import "BaseViewController.h"

@class AVCVideoConfig;

@interface Good_ClassMainViewController : BaseViewController

@property (strong ,nonatomic)NSString         *ID;
/** 是不是活动(由列表传入) */
@property (assign, nonatomic) BOOL isEvent;
/// 学习记录里面传过来的课时id
@property (strong, nonatomic) NSString *sid;
@property (strong ,nonatomic)NSString         *videoTitle;
@property (strong ,nonatomic)NSString         *imageUrl;
@property (strong ,nonatomic)NSString         *price;
@property (strong ,nonatomic)NSString         *videoUrl;
@property (strong ,nonatomic)NSString         *schoolID;

//营销数据的标识
@property (strong ,nonatomic)NSString         *orderSwitch;
@property (assign, nonatomic) BOOL canScroll;

/** 视频播放了之后整个外部tableview就不允许滚动了 */
@property (assign, nonatomic) BOOL canScrollAfterVideoPlay;

@property (nonatomic, strong) AVCVideoConfig *config;

@property (assign, nonatomic) BOOL isClassNew;//是不是班级课

@property (strong ,nonatomic)UIView   *videoView;//视频的地方

@end
