//
//  Good_ClassCommentView.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/28.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassCommentView.h"
#import "SYG.h"

@interface Good_ClassCommentView ()

@property (strong ,nonatomic)UIView            *starView;
@property (strong ,nonatomic)NSDictionary      *dict;
@property (strong ,nonatomic)NSString          *ID;
@property (assign ,nonatomic)CGRect            frame;

@property (strong ,nonatomic)UIButton          *subitButton;

@end

@implementation Good_ClassCommentView

-(instancetype)initWithFrame:(CGRect)frame WithID:(NSString *)ID {
    _dict = [NSDictionary dictionary];
    _ID = ID;
    //    CGRect frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    if (self = [super initWithFrame:frame]) {
        [self interFace];
        [self addStarView];
        [self netWork];
    }
    return self;
}

- (void)interFace {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.backgroundColor = [UIColor redColor];
}

- (void)addStarView {
    _starView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, 100, MainScreenWidth, 300 * WideEachUnit)];
    _starView.backgroundColor = [UIColor redColor];
//    _starView.center = self.center;
    [self addSubview:_starView];
    
    
    //添加标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 * WideEachUnit, 300 * WideEachUnit, 20 * WideEachUnit)];
    title.text = @"荣誉证书";
    title.textColor = [UIColor colorWithHexString:@"#888"];
    title.font = Font(16);
    title.textAlignment = NSTextAlignmentCenter;
    [_starView addSubview:title];
    
    //添加文本
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 80 * WideEachUnit, 200 * WideEachUnit, 20 * WideEachUnit)];
    name.text = @"雷锋：同志";
    name.textColor = [UIColor colorWithHexString:@"#888"];
    name.font = Font(14);
    [_starView addSubview:name];
    
    //添加具体文本
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 100 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 20 * WideEachUnit)];
    content.text = @"数学计算器在学习中提供的便利性非常大，有些考研的考生在数学考研的时候会有这样的疑问，考研数学究竟可不可以带数学计算器进入考场参加考试，答案是不可以的，但对于一些自";
    content.textColor = [UIColor colorWithHexString:@"#888"];
    content.font = Font(14);
    [_starView addSubview:content];
    
    
    //所属机构
    UILabel *inst = [[UILabel alloc] initWithFrame:CGRectMake(270 * WideEachUnit, 200 * WideEachUnit, 60 * WideEachUnit, 20 * WideEachUnit)];
    inst.text = @"中科曙光";
    inst.textColor = [UIColor colorWithHexString:@"#888"];
    inst.font = Font(14);
    [_starView addSubview:inst];
    
    
    //所属机构
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(250 * WideEachUnit, 220 * WideEachUnit, 80 * WideEachUnit, 20 * WideEachUnit)];
    time.text = @"2018-9-10";
    time.textColor = [UIColor colorWithHexString:@"#888"];
    time.textAlignment = NSTextAlignmentRight;
    time.font = Font(14);
    [_starView addSubview:time];
    
}

#pragma mark --- 按钮点击
- (void)backButtonCilck {
//    [self removeAllSubviews];
    [self removeFromSuperview];
}

- (void)netWork {
}


@end
