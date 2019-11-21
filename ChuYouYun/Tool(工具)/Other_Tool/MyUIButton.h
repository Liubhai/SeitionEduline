//
//  MyUIButton.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyUIButton : UIButton
@property (nonatomic, assign) BOOL isClick;
- (void)setIsPressed:(BOOL)isPressed;
@end
