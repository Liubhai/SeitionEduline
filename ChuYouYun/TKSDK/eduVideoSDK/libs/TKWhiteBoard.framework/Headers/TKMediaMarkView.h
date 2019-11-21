//
//  TKMediaMarkView.h
//  TKWhiteBoard
//
//  Created by 周洁 on 2019/1/17.
//  Copyright © 2019 MAC-MiNi. All rights reserved.
//	视频标注

#import <UIKit/UIKit.h>
//#import "DrawView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKMediaMarkView : UIView

@property (nonatomic, strong) DrawView *mediaMarkDrawView;
@property (nonatomic, strong) DrawView *mediaMarkRTDrawView;
@property (nonatomic, strong) UIButton *exitBtn;
@property (nonatomic, strong) UIButton *eraserBtn;
@property (nonatomic, strong) NSNumber *videoRatio;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
