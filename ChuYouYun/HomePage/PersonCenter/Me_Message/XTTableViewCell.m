//
//  XTTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/13.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "XTTableViewCell.h"
#import "SYG.h"

@implementation XTTableViewCell

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{

    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 60 * WideEachUnit)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    //介绍
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 12 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 15 * WideEachUnit)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [_backView addSubview:_titleLabel];

    
    //日期
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, MainScreenWidth - 40, 15)];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#666"];
    _timeLabel.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    [_backView addSubview:_timeLabel];
    
    _TXButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 14, 8, 8)];
    _TXButton.backgroundColor = [UIColor redColor];
    _TXButton.layer.cornerRadius = 4;
    [_backView addSubview:_TXButton];
    
}

//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.titleLabel.text = text;
    //设置label的最大行数
    self.titleLabel.numberOfLines = 0;
    
    CGRect labelSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 60 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, MainScreenWidth - 60 * WideEachUnit, labelSize.size.height);
    
    _timeLabel.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_titleLabel.frame) + 30 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit);
    _backView.frame = CGRectMake(15 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, labelSize.size.height + 70 * WideEachUnit);
    frame.size.height = labelSize.size.height + 85 * WideEachUnit;
    self.frame = frame;
}

- (void)dataWithDict:(NSDictionary *)dict {
    NSString *bodyStr = [Passport filterHTML:[dict stringValueForKey:@"body"]];
    [self setIntroductionText:bodyStr];
    _timeLabel.text = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    if ([[dict stringValueForKey:@"is_read"] integerValue] == 1) {
        _TXButton.hidden = YES;
    } else {
        _TXButton.hidden = NO;
    }
}


@end
