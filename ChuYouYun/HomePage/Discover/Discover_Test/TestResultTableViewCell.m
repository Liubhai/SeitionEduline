//
//  TestResultTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/10/16.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestResultTableViewCell.h"
#import "SYG.h"


@implementation TestResultTableViewCell



-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    
    //添加标题
    _Number = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 15 * WideEachUnit,30 * WideEachUnit, 30 * WideEachUnit)];
    _Number.font = [UIFont systemFontOfSize:15 * WideEachUnit];
    _Number.numberOfLines = 1;
    _Number.textColor = BasidColor;
    [self addSubview:_Number];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40 * WideEachUnit, 15 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit)];
    _headerImageView.layer.cornerRadius = 15 * WideEachUnit;
    _headerImageView.layer.masksToBounds = YES;
    [self addSubview:_headerImageView];
    
    //添加人数
    _name = [[UILabel alloc] initWithFrame:CGRectMake(80 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth / 2 - 80 * WideEachUnit, 30 * WideEachUnit)];
    _name.textColor = BlackNotColor;
    _name.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    [self addSubview:_name];
    
    //作答
    _time = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 140 * WideEachUnit, 15 * WideEachUnit, 60 * WideEachUnit, 30 * WideEachUnit)];
    _time.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _time.textAlignment = NSTextAlignmentCenter;
    _time.textColor = [UIColor colorWithHexString:@"#888"];
    [self addSubview:_time];
    
    //添加是否参加考试
    _sorce = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 70 * WideEachUnit, 15 * WideEachUnit, 60 * WideEachUnit, 30 * WideEachUnit)];
    _sorce.textColor = BasidColor;
    _sorce.font = Font(12 * WideEachUnit);
    _sorce.textAlignment = NSTextAlignmentRight;
    [self addSubview:_sorce];
    
    
}

- (void)dataWithDict:(NSDictionary *)dict WithNumber:(NSInteger)number {

    _Number.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"rank_nomber"]];
    NSString *urlStr = [dict stringValueForKey:@"userface"];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    _name.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"username"]];
    _time.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"anser_time"]];
    if ([[dict stringValueForKey:@"anser_time"] integerValue] > 3600) {//小时
        NSInteger hour = [[dict stringValueForKey:@"anser_time"] integerValue] / 3600;
        NSInteger mins = [[dict stringValueForKey:@"anser_time"] integerValue] % 3600 / 60;
        NSInteger seind = [[dict stringValueForKey:@"anser_time"] integerValue] % 3600 / 60 % 60;
        _time.text = [NSString stringWithFormat:@"%ld:%ld’%ld‘’",hour,mins,seind];
    } else if ([[dict stringValueForKey:@"anser_time"] integerValue] > 60) {
        NSInteger mins = [[dict stringValueForKey:@"anser_time"] integerValue] / 60;
        NSInteger seind = [[dict stringValueForKey:@"anser_time"] integerValue] / 60 % 60;
        _time.text = [NSString stringWithFormat:@"%ld‘%ld‘’",mins,seind];
    } else {
        _time.text = [NSString stringWithFormat:@"%@‘’",[dict stringValueForKey:@"anser_time"]];
    }
    _sorce.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"score"]];
    
}


@end
