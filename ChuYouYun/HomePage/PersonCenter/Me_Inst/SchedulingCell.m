//
//  SchedulingCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//  排课的样式

#import "SchedulingCell.h"
#import "SYG.h"
#import "Passport.h"

@implementation SchedulingCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot {
    
    
    _myClass = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside * horizontalrate, SpaceBaside * horizontalrate,(MainScreenWidth / 2 - SpaceBaside) * horizontalrate, 30 * horizontalrate)];
    [self addSubview:_myClass];
    _myClass.font = Font(15);
    _myClass.textColor = BlackNotColor;
    _myClass.text = @"你好";
    
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake((MainScreenWidth / 2 - 50) * horizontalrate, 25 * horizontalrate,100 * horizontalrate, 1 * horizontalrate)];
    lineButton.backgroundColor = [UIColor redColor];
    [self addSubview:lineButton];
    lineButton.hidden = YES;
    
    
    _myTeacher = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth / 2 + 70) * horizontalrate, SpaceBaside * horizontalrate,  (MainScreenWidth / 2 - 80) * horizontalrate, 30 * horizontalrate)];
    _myTeacher.text = @"张学友";
    _myTeacher.font = Font(15);
    _myTeacher.textColor = BlackNotColor;
    _myTeacher.textAlignment = NSTextAlignmentRight;
    [self addSubview:_myTeacher];
    
    _date = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside * horizontalrate, 50, (MainScreenWidth * 3 / 2) * horizontalrate, 30 * horizontalrate)];
    _date.text = @"10-01";
    _date.font = Font(14);
    _date.textColor = [UIColor grayColor];
    [self addSubview:_date];
    
    _number = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth / 2 + 70) * horizontalrate, 50 * horizontalrate, (MainScreenWidth / 2 - 80) * horizontalrate, 30 * horizontalrate)];
    _number.text = @"10人学习";
    _number.textColor = [UIColor grayColor];
    _number.font = Font(14);
    _number.textAlignment = NSTextAlignmentRight;
    [self addSubview:_number];
}

- (void)dataWithDict:(NSDictionary *)dict {
    
    NSLog(@"%@",dict);
    
    _myClass.text = dict[@"video_title"];
    _myTeacher.text = dict[@"teacher_name"];
    _date.text = [NSString stringWithFormat:@"%@",dict[@"start_time"]];
    _number.text = [NSString stringWithFormat:@"%@人学习",dict[@"buy_count"]];
    
    
    NSString *startTime = [Passport formatterTime:dict[@"start_time"]];
    
    NSString *startHour = [startTime substringWithRange:NSMakeRange(5, 11)];
    
    NSLog(@"%@",startHour);
    
    _date.text = startHour;

    
}


@end
