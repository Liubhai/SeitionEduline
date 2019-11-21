//
//  BaseViewController.h
//  zlydoc-iphone
//
//  Created by Ryan on 14-5-23.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>
{
    UILabel *_titleLabel;
    UIButton *_rightButton;
    UIButton *_leftButton;
    UIImageView *_titleImage;
    UIView *_lineTL;
	
}
@property (nonatomic,retain) UIButton *leftButton;
@property (nonatomic,retain) UIButton *rightButton;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIImageView *titleImage;
@property (nonatomic,retain) UIView *lineTL;

- (void)leftButtonClick:(id)sender;
- (void)rightButtonClick:(id)sender;

@end
