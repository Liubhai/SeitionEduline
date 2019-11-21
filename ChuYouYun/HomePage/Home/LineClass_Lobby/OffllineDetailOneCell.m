//
//  OffllineDetailOneCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/7.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "OffllineDetailOneCell.h"
#import "SYG.h"


@implementation OffllineDetailOneCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
//    self.backgroundColor = [UIColor whiteColor];


    _title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    _title.textColor = [UIColor blackColor];
    _title.backgroundColor = [UIColor whiteColor];
    [self addSubview:_title];
    
    
    _teacher = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 47 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _teacher.textColor = [UIColor blackColor];
    _teacher.font = Font(12 * WideEachUnit);
    _teacher.textColor = [UIColor colorWithHexString:@"#656565"];
    _teacher.backgroundColor = [UIColor whiteColor];
    [self addSubview:_teacher];
    
    
    _person = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 72 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _person.textColor = [UIColor blackColor];
    _person.font = Font(12 * WideEachUnit);
    _person.textColor = [UIColor colorWithHexString:@"#656565"];
    _person.backgroundColor = [UIColor whiteColor];
    [self addSubview:_person];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 99 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _time.font = Font(12 * WideEachUnit);
    _time.backgroundColor = [UIColor whiteColor];
    _time.textColor = [UIColor colorWithHexString:@"#656565"];
    [self addSubview:_time];
    
    _adress = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 126 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _adress.font = Font(12 * WideEachUnit);
    _adress.backgroundColor = [UIColor whiteColor];
    _adress.textColor = [UIColor colorWithHexString:@"#656565"];
    [self addSubview:_adress];
    
    
    _discounts = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 161 * WideEachUnit, 60 * WideEachUnit, 20 * WideEachUnit)];
    _discounts.font = Font(14 * WideEachUnit);
    _discounts.backgroundColor = [UIColor whiteColor];
    _discounts.text = @"优惠价：";
    _discounts.textColor = [UIColor colorWithHexString:@"#fe575f"];
    [self addSubview:_discounts];
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_discounts.frame), 161 * WideEachUnit, MainScreenWidth - CGRectGetMaxX(_discounts.frame) - 20 * WideEachUnit, 20 * WideEachUnit)];
    _price.font = Font(20 * WideEachUnit);
    _price.backgroundColor = [UIColor whiteColor];
    _price.textColor = [UIColor colorWithHexString:@"#fe575f"];
    [self addSubview:_price];
    

    
    
//    _time = [[UILabel alloc] initWithFrame:CGRectMake(190 * WideEachUnit, 88 * WideEachUnit, MainScreenWidth - 210 * WideEachUnit, 15 * WideEachUnit)];
//    _time.font = Font(12 * WideEachUnit);
//    _time.backgroundColor = [UIColor brownColor];
//    _time.textColor = [UIColor colorWithHexString:@"#656565"];
//    [self addSubview:_time];
}

- (void)dataWithDict:(NSDictionary *)dict {
    
    _title.text = [dict stringValueForKey:@"course_name"];
    _teacher.text = [NSString stringWithFormat:@"主讲人：%@",[dict stringValueForKey:@"teacher_name"]];
    _person.text = [NSString stringWithFormat:@"已报名：%@",[dict stringValueForKey:@"course_order_count"]];
    NSString *beginStr = [Passport formatterDate:[dict stringValueForKey:@"listingtime"]];
    NSString *endStr = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    _time.text = [NSString stringWithFormat:@"开课时间：%@ ~ %@",beginStr,endStr];
    
    _adress.text = [NSString stringWithFormat:@"上课地点：%@",[dict stringValueForKey:@"teach_areas"]];
    _price.text = [NSString stringWithFormat:@"育币 %@",[dict stringValueForKey:@"course_price"]];
    
}



@end
