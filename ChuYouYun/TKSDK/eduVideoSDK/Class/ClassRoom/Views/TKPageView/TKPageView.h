//
//  TKPageView.h
//  EduClass
//
//  Created by lyy on 2018/5/9.
//  Copyright © 2018年 talkcloud. All rights reserved.
//  翻页

#import <UIKit/UIKit.h>
#import "SYG.h"


@interface TKPageView : UIView

@property (nonatomic, copy) void(^currentSelectPageNum)(NSInteger num);

@property (nonatomic, copy) void(^dismissBlock)();


- (void)setTotalPages:(int)totalPages;
//显示视图
- (void)showOnView:(UIButton *)view totalPages:(int)totalPages pageShowType:(TKPageShowType)type;
//隐藏视图
- (void)dissMissView;

@end
