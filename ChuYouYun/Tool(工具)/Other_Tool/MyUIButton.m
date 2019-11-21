//
//  MyUIButton.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "MyUIButton.h"

@implementation MyUIButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setIsPressed:(BOOL)isPressed {
    _isClick = isPressed;
    if (_isClick) {
        [self setBackgroundImage:[UIImage imageNamed:@"check .png"] forState:0];
    }
    else {
        [self setBackgroundImage:[UIImage imageNamed:@"check 拷贝.png"] forState:0];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
