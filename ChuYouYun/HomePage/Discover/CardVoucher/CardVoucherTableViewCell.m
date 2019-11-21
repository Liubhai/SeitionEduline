//
//  CardVoucherTableViewCell.m
//  YunKeTang
//
//  Created by IOS on 2019/3/5.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "CardVoucherTableViewCell.h"
#import "SYG.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"


@implementation CardVoucherTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}

//初始化控件
-(void)initLayuot{
    
    
    //添加线
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 15 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit, 106 * WideEachUnit)];
    _backImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backImageView];
    
    //头像
    _receiveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 15 * WideEachUnit, 44 * WideEachUnit, 44 * WideEachUnit)];
    _receiveImageView.layer.cornerRadius = 20 * WideEachUnit;
    _receiveImageView.layer.masksToBounds = YES;
    _receiveImageView.backgroundColor = [UIColor redColor];
    _receiveImageView.image = Image(@"站位图");
    [_backImageView addSubview:_receiveImageView];
    
    //名字
    _price = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, 15 * WideEachUnit, MainScreenWidth / 4 , 30 * WideEachUnit)];
    _price.textColor = [UIColor colorWithHexString:@"#666"];
    _price.font = Font(12 * WideEachUnit);
    _price.backgroundColor = [UIColor whiteColor];
    [_backImageView addSubview:_price];
    
    //时间
    _discountStaus = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_price.frame) + 10 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth / 4 - 15 * WideEachUnit, 30 * WideEachUnit)];
    _discountStaus.textColor = [UIColor colorWithHexString:@"#666"];
    _discountStaus.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _discountStaus.textAlignment = NSTextAlignmentLeft;
    _discountStaus.backgroundColor = [UIColor whiteColor];
    [_backImageView addSubview:_discountStaus];
    
    //具体
    _discountConditions = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_price.frame) + 10 * WideEachUnit, 45 * WideEachUnit, MainScreenWidth / 4 - 15 * WideEachUnit, 30 * WideEachUnit)];
    _discountConditions.textColor = [UIColor colorWithHexString:@"#666"];
    _discountConditions.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _discountConditions.textAlignment = NSTextAlignmentLeft;
    _discountConditions.backgroundColor = [UIColor whiteColor];
    [_backImageView addSubview:_discountConditions];
    
    //回答
    _discountUse = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_price.frame) + 10 * WideEachUnit, 65 * WideEachUnit, MainScreenWidth / 4 - 15 * WideEachUnit, 30 * WideEachUnit)];
    _discountUse.textColor = [UIColor colorWithHexString:@"#666"];
    _discountUse.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _discountUse.textAlignment = NSTextAlignmentLeft;
    _discountUse.backgroundColor = [UIColor whiteColor];
    [_backImageView addSubview:_discountUse];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit,130 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 14 * WideEachUnit)];
    _time.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    _time.textColor = [UIColor colorWithHexString:@"#656565"];
    _time.backgroundColor = [UIColor whiteColor];
    _time.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_time];
    
    
}


- (void)dataWithDict:(NSDictionary *)dict {
    
    _price.text = [NSString stringWithFormat:@"%@育币",[dict stringValueForKey:@"price"]];
    if ([[dict stringValueForKey:@"status"] integerValue] == 1) {
        _discountStaus.text = @"优惠券";
    } else if ([[dict stringValueForKey:@"status"] integerValue] == 2) {
        _discountStaus.text = @"打折卡";
    } else if ([[dict stringValueForKey:@"status"] integerValue] == 3) {
        _discountStaus.text = @"会员卡";
    } else if ([[dict stringValueForKey:@"status"] integerValue] == 4) {
        _discountStaus.text = @"充值卡";
    } else if ([[dict stringValueForKey:@"status"] integerValue] == 5) {
        _discountStaus.text = @"课程卡";
    }
    _discountConditions.text = [dict stringValueForKey:@""];
    _discountUse.text = [NSString stringWithFormat:@"%@", [dict stringValueForKey:@"school_title"]];
    _discountUse.text = @"仅限指定的机构使用";
    
}


@end
