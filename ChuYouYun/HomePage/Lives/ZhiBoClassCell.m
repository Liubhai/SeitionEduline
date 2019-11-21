//
//  ZhiBoClassCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoClassCell.h"
#import "SYG.h"


@implementation ZhiBoClassCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _numberButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 13, 24, 24)];
    _numberButton.titleLabel.font = Font(16);
    _numberButton.backgroundColor = BasidColor;
    [_numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_numberButton];
    _numberButton.layer.cornerRadius = 12;
    _numberButton.layer.masksToBounds = YES;
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, MainScreenWidth - 190, 30)];
    _title.textColor = [UIColor colorWithHexString:@"#333"];
    _title.font = Font(13);
    [self addSubview:_title];
    
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, 15,50, 20)];
    _priceLabel.textColor = BasidColor;
    _priceLabel.layer.borderWidth = 1;
    _priceLabel.font = Font(12);
    _priceLabel.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _priceLabel.layer.cornerRadius = 3;
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLabel];
    
    _type = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 10, 60, 30)];
    _type.font = Font(13);
    _type.textColor = [UIColor colorWithHexString:@"#333"];
    _type.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_type];
    
}

- (void)dataWithDict:(NSDictionary *)dict {
    _title.text = [dict stringValueForKey:@"title"];
    if ([[dict stringValueForKey:@"note"] isEqualToString:@"观看回放"]) {
        _type.text = @"观看回放";
    } else if ([[dict stringValueForKey:@"note"] isEqualToString:@"未开始"]){
        _type.text = @"未开始";
    } else {
        _type.text = @"直播中";
    }
}

- (void)dataWithDict:(NSDictionary *)dict WithLiveInfo:(NSDictionary *)liveInfo{
    
    _title.text = [dict stringValueForKey:@"title"];
    if ([[dict stringValueForKey:@"note"] isEqualToString:@"观看回放"]) {
        _type.text = @"观看回放";
    } else if ([[dict stringValueForKey:@"note"] isEqualToString:@"未开始"]){
        _type.text = @"未开始";
    } else if ([[dict stringValueForKey:@"note"] isEqualToString:@"已结束"]){
        _type.text = @"已结束";
    } else {
        _type.text = @"直播中";
    }
    
    if ([[liveInfo stringValueForKey:@"is_buy"] integerValue] == 1) {//已经解锁整个直播
        _priceLabel.text = @"已购";
        _priceLabel.textColor = [UIColor colorWithHexString:@"#888"];
        _priceLabel.layer.borderColor = [UIColor colorWithHexString:@"#888"].CGColor;
    } else {//要收费
        if ([[liveInfo stringValueForKey:@"price"] floatValue] == 0) {
            if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {//已经解锁
                _priceLabel.hidden = NO;
                _priceLabel.text = @"已购";
                _priceLabel.textColor = [UIColor colorWithHexString:@"#888"];
                _priceLabel.layer.borderColor = [UIColor colorWithHexString:@"#888"].CGColor;
            } else {
                 _priceLabel.hidden = YES;
            }
        } else {
            if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {//已经解锁
                _priceLabel.text = @"已购";
                _priceLabel.textColor = [UIColor colorWithHexString:@"#888"];
                _priceLabel.layer.borderColor = [UIColor colorWithHexString:@"#888"].CGColor;
            } else {
                _priceLabel.text = [NSString stringWithFormat:@"%d育币",[[dict stringValueForKey:@"course_hour_price"] integerValue]];
                _priceLabel.textColor = [UIColor redColor];
                _priceLabel.layer.borderColor = [UIColor redColor].CGColor;
                if ([[dict stringValueForKey:@"course_hour_price"] floatValue] == 0) {
                    _priceLabel.hidden = YES;
                }
            }
        }
    }
}




@end
