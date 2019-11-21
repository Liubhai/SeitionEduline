//
//  MyExerciseTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/26.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MyExerciseTableViewCell.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"

@implementation MyExerciseTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    //标题
    _name = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit,15 * WideEachUnit,MainScreenWidth - 90 * WideEachUnit, 15 * WideEachUnit)];
    [self addSubview:_name];
    _name.text = @"使用一应";
    _name.font = Font(15 * WideEachUnit);
    _name.textColor = [UIColor colorWithHexString:@"#333"];
    
    //名字
    _time = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 45 * WideEachUnit,MainScreenWidth - 90 * WideEachUnit, 15 * WideEachUnit)];
    [self addSubview:_time];
    _time.font = Font(13 * WideEachUnit);
    _time.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _time.text = @"你是你上午我问问我我等你过个";
    
    //机构按钮
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 0, 50 * WideEachUnit, 75 * WideEachUnit)];
    _rightButton.backgroundColor = [UIColor whiteColor];
    [_rightButton setTitleColor:BasidColor forState:UIControlStateNormal];
    _rightButton.titleLabel.font = Font(18 * WideEachUnit);
    [self addSubview:_rightButton];
}

- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)type {

    _name.text = [[dict dictionaryValueForKey:@"paper_info"] stringValueForKey:@"exams_paper_title"];
    _time.text = [Passport formatterTime:[dict stringValueForKey:@"update_time"]];

    if ([type integerValue] == 1) {
        if ([[dict stringValueForKey:@"progress"] integerValue] == 100) {//就是已经答完的
            if ([[dict stringValueForKey:@"status"] integerValue] == 1) {
                NSString *score = [NSString stringWithFormat:@"%@分",[dict stringValueForKey:@"score"]];
                [_rightButton setTitle:score forState:UIControlStateNormal];
            } else if ([[dict stringValueForKey:@"status"] integerValue] == 0) {
                [_rightButton setTitle:@"正在阅卷" forState:UIControlStateNormal];
                _rightButton.frame = CGRectMake(MainScreenWidth - 80 * WideEachUnit, 0, 70 * WideEachUnit, 75 * WideEachUnit);
                _rightButton.titleLabel.font = Font(14 * WideEachUnit);
            }

            [_rightButton setImage:Image(@"") forState:UIControlStateNormal];
        } else {//还没有答案
            [_rightButton setImage:Image(@"undown@3x") forState:UIControlStateNormal];
            [_rightButton setTitle:nil forState:UIControlStateNormal];
            
        }
    } else if ([type integerValue] == 2) {
        NSString *score = [NSString stringWithFormat:@"%@分",[dict stringValueForKey:@"score"]];
        [_rightButton setTitle:score forState:UIControlStateNormal];
        if ([[dict stringValueForKey:@"progress"] integerValue] == 100) {
            if ([[dict stringValueForKey:@"status"] integerValue] == 0) {
                 [_rightButton setTitle:@"正在阅卷" forState:UIControlStateNormal];
                _rightButton.frame = CGRectMake(MainScreenWidth - 80 * WideEachUnit, 0, 70 * WideEachUnit, 75 * WideEachUnit);
                _rightButton.titleLabel.font = Font(14 * WideEachUnit);
            }
        }
    } else if ([type integerValue] == 3) {//错题
        NSString *wrong_count = [NSString stringWithFormat:@"%@题",[dict stringValueForKey:@"wrong_count"]];
        [_rightButton setTitle:wrong_count forState:UIControlStateNormal];
    }
}

@end
