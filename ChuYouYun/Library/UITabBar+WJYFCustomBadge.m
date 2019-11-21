//
//  UITabBar+WJYFCustomBadge.m
//  wojiayoufu
//
//  Created by 我家有福 on 15/11/22.
//  Copyright © 2015年 我家有福. All rights reserved.
//

#import "UITabBar+WJYFCustomBadge.h"
#import "UIColor+HTMLColors.h"

#define TabbarItemNums 4.0    //tabbar的数量
@implementation UITabBar (WJYFCustomBadge)
//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;//圆形
    badgeView.backgroundColor = [UIColor colorWithHexString:@"#f96650"];//颜色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, [UIScreen mainScreen].bounds.size.width*0.028, [UIScreen mainScreen].bounds.size.width*0.028);//圆形大小为10
    [self addSubview:badgeView];
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
