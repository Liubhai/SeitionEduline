//
//  HcdGuideViewCell.m
//  HcdGuideViewDemo
//
//  Created by polesapp-hcd on 16/7/12.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "HcdGuideViewCell.h"
#import "HcdGuideView.h"
#import "SYG.h"


@interface HcdGuideViewCell()

@end

@implementation HcdGuideViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.layer.masksToBounds = YES;
    self.imageView = [[UIImageView alloc]initWithFrame:kHcdGuideViewBounds];
    self.imageView.center = CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height / 2);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.hidden = YES;
    [button setFrame:CGRectMake(0, 0, 200, 44)];
    [button setFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.layer setCornerRadius:5];
    [button.layer setBorderColor:[UIColor clearColor].CGColor];
    [button.layer setBorderWidth:1.0f];
    [button setBackgroundColor:[UIColor clearColor]];
    self.button = button;
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.button];
    
    
    if (iPhone5o5Co5S) {
        [self.button setCenter:CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height - 90)];
    } else if (iPhone6) {
        [self.button setCenter:CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height - 110)];
    } else if (iPhone6Plus) {
        [self.button setCenter:CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height - 130)];
    } else if (iPhone4SOriPhone4) {
        [self.button setCenter:CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height - 90)];
    }
    
}

@end
