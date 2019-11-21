//
//  presedView.m
//  弹出框的封装
//
//  Created by 智艺创想 on 16/12/30.
//  Copyright © 2016年 SYG. All rights reserved.
//

#import "presedView.h"
#import "SYG.h"


@interface presedView()

@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIView *superView;

@end
@implementation presedView


-(instancetype)initWithFrame:(CGRect)frame WithView:(UIView *)superView{
    
    _superView = superView;
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor yellowColor];
    
    [self addAllView];
    return self;
}


- (void)addAllView {
    
    UIView *allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,MainScreenWidth,MainScreenHeight)];
    allView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
    [_superView addSubview:allView];
    _allView = allView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [allView addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [_allView removeFromSuperview];
    [self removeFromSuperview];
}

@end
