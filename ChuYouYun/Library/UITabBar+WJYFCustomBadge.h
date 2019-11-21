//
//  UITabBar+WJYFCustomBadge.h
//  wojiayoufu
//
//  Created by 我家有福 on 15/11/22.
//  Copyright © 2015年 我家有福. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (WJYFCustomBadge)
///显示小红点
- (void)showBadgeOnItemIndex:(int)index;
///隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index;
@end
