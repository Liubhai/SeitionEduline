//
//  MySlider.m
//  NewCCDemo
//
//  Created by cc on 2016/12/15.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "MySlider.h"

@implementation MySlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.y= rect.origin.y-10;
    rect.origin.x= rect.origin.x-10;
    rect.size.height= rect.size.height+20;
    rect.size.width= rect.size.width+20;
    return [super thumbRectForBounds:bounds trackRect:rect value:value];
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    
    return CGRectMake(0, 0, bounds.size.width, 5);
}

@end
