//
//  LBHTableView.m
//  ThinkSNS（探索版）
//
//  Created by 刘邦海 on 2017/11/9.
//  Copyright © 2017年 zhiyicx. All rights reserved.
//

#import "LBHTableView.h"

@implementation LBHTableView

/**
 同时识别多个手势
 
 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
