//
//  UIView+Utils.h
//  MVVM-demo
//
//  Created by shen_gh on 16/4/13.
//  Copyright © 2016年 申冠华. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define horizontalrate MainScreenWidth/375
#define verticalrate  MainScreenHeight/667

#import <UIKit/UIKit.h>
#import "UIColor+HTMLColors.h"
#import "SYG.h"
@interface UIView (Utils)

//宽度
- (CGFloat)current_w;

//高度
- (CGFloat)current_h;

//当前view.frame的x、y、x+宽、y+高
- (CGFloat)current_x;
- (CGFloat)current_y;
- (CGFloat)current_x_w;
- (CGFloat)current_y_h;
- (void)setCenterX:(CGFloat)centerX;
@end
