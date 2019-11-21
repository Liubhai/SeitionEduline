//
//  Good_integParticularsTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/10/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_integParticularsTableViewCell.h"
#import "SYG.h"


@implementation Good_integParticularsTableViewCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    
    //名字
    _name = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 18 * WideEachUnit)];
    [self addSubview:_name];
    _name.font = Font(18 * WideEachUnit);
    _name.backgroundColor = [UIColor whiteColor];
    _name.textColor = [UIColor colorWithHexString:@"#333"];
    
    //时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 43 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 12 * WideEachUnit)];
    [self addSubview:_time];
    _time.font = Font(12 * WideEachUnit);
    _time.backgroundColor = [UIColor whiteColor];
    _time.textColor = [UIColor colorWithHexString:@"#888"];
    
    
    //钱
    _money = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, 25 * WideEachUnit, 75 * WideEachUnit, 20 * WideEachUnit)];
    [self addSubview:_money];
    _money.font = Font(18 * WideEachUnit);
    _money.backgroundColor = [UIColor whiteColor];
    _money.textColor = [UIColor colorWithHexString:@"#888"];
    _money.textAlignment = NSTextAlignmentRight;
    
}

- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)type {
    
    _name.text = [dict stringValueForKey:@"note"];
    _time.text = [Passport getTime:[dict stringValueForKey:@"ctime"]];
    _time.text = [_time.text substringToIndex:_time.text.length - 4];
    
    if ([type integerValue] == 1) {//余额
        if ([[dict stringValueForKey:@"type"] isEqualToString:@"充值"]) {
            _money.text = [NSString stringWithFormat:@"+%@",[dict stringValueForKey:@"num"]];
            _money.textColor = [UIColor colorWithHexString:@"#47b37d"];
        } else if ([[dict stringValueForKey:@"type"] isEqualToString:@"消费"]) {
            _money.text = [NSString stringWithFormat:@"-%@",[dict stringValueForKey:@"num"]];
            _money.textColor = [UIColor colorWithHexString:@"#333"];
        }
    } else if ([type integerValue ] == 2) {//收入
        if ([[dict stringValueForKey:@"type"] isEqualToString:@"增加积分"]) {
            _money.text = [NSString stringWithFormat:@"+%@",[dict stringValueForKey:@"num"]];
            _money.textColor = [UIColor colorWithHexString:@"#47b37d"];
        } else if ([[dict stringValueForKey:@"type"] isEqualToString:@"消费"]) {
            _money.text = [NSString stringWithFormat:@"-%@",[dict stringValueForKey:@"num"]];
            _money.textColor = [UIColor colorWithHexString:@"#333"];
        }
        
    } else if ([type integerValue] == 3) {//积分
        NSLog(@"%@",dict[@"type"]);
        if ([[dict stringValueForKey:@"type"] isEqualToString:@"增加积分"] || [[dict stringValueForKey:@"type"] isEqualToString:@"充值"]) {
            _money.text = [NSString stringWithFormat:@"+%ld",[[dict stringValueForKey:@"num"] integerValue]];
            _money.textColor = [UIColor colorWithHexString:@"#47b37d"];
        } else if ([[dict stringValueForKey:@"type"] isEqualToString:@"扣除积分"]) {
            _money.text = [NSString stringWithFormat:@"-%ld",[[dict stringValueForKey:@"num"] integerValue]];
            _money.textColor = [UIColor colorWithHexString:@"#333"];
        }
    }
    _money.hidden = NO;
    if ([[dict stringValueForKey:@"type"] isEqualToString:@"消费"] || [[dict stringValueForKey:@"type"] isEqualToString:@"冻结"] || [[dict stringValueForKey:@"type"] isEqualToString:@"扣除积分"] || [[dict stringValueForKey:@"type"] isEqualToString:@"冻结扣除"]) {
        _money.textColor = [UIColor colorWithHexString:@"#333"];
        _money.text = [NSString stringWithFormat:@"-%@",[NSString stringWithFormat:@"%@",[dict stringValueForKey:@"num"]]];
        if ([[dict stringValueForKey:@"type"] isEqualToString:@"冻结扣除"]) {
            if ([_name.text containsString:@"提现成功"]) {
                _money.hidden = NO;
                _money.textColor = [UIColor colorWithHexString:@"#47b37d"];
                _money.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dict stringValueForKey:@"num"]]];
            } else if ([_name.text containsString:@"提现失败"] || [_name.text containsString:@"取消提现"] || [_name.text containsString:@"提现成功"]) {
                _money.hidden = YES;
            }
        }
    } else {
        _money.textColor = [UIColor colorWithHexString:@"#47b37d"];
        _money.text = [NSString stringWithFormat:@"+%@",[dict stringValueForKey:@"num"]];
        if ([[dict stringValueForKey:@"type"] isEqualToString:@"解冻"]) {
            if ([_name.text containsString:@"管理员解冻"]) {
                _money.hidden = NO;
            } else if ([_name.text containsString:@"提现成功"]) {
                _money.hidden = NO;
                _money.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"num"]];
            } else {
                _money.hidden = YES;
            }
        }
    }

}


@end
