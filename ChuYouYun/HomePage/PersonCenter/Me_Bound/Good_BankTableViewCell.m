//
//  Good_BankTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/13.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_BankTableViewCell.h"
#import "SYG.h"

@implementation Good_BankTableViewCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 30 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 100 * WideEachUnit)];
    redView.backgroundColor = [UIColor colorWithHexString:@"#e57373"];
    redView.layer.cornerRadius = 5 * WideEachUnit;
    redView.layer.masksToBounds = YES;
    [self addSubview:redView];
    
    
    //图片
    _bankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 15 * WideEachUnit, 25 * WideEachUnit, 25 * WideEachUnit)];
    [_bankImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:Image(@"站位图")];
    [redView addSubview:_bankImageView];
    _bankImageView.hidden = YES;
    
    
    //机构
    _bankName = [[UILabel alloc] initWithFrame:CGRectMake(45 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 15 * WideEachUnit)];
    [redView addSubview:_bankName];
    _bankName.text = @"中国银行";
    _bankName.font = Font(14 * WideEachUnit);
    _bankName.textColor = [UIColor whiteColor];
    
    _bankType = [[UILabel alloc] initWithFrame:CGRectMake(45 * WideEachUnit, 33 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 12 * WideEachUnit)];
    _bankType.text = @"储存卡";
    _bankType.font = Font(12 * WideEachUnit);
    _bankType.textColor = [UIColor groupTableViewBackgroundColor];
    [redView addSubview:_bankType];
    
    _bankNumber = [[UILabel alloc] initWithFrame:CGRectMake(45 * WideEachUnit, 50 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 30 * WideEachUnit)];
    _bankNumber.text = @"66666612321312331";
    _bankNumber.font = Font(24 * WideEachUnit);
    _bankNumber.textColor = [UIColor groupTableViewBackgroundColor];
    [redView addSubview:_bankNumber];
    
}

- (void)dataSourceWith:(NSDictionary *)dict {
    NSLog(@"%@",dict);
    _bankName.text = [dict stringValueForKey:@"accounttype"];
    _bankNumber.text = [dict stringValueForKey:@"card_info_abb"];
    _bankType.text = [dict stringValueForKey:@"accountmaster" defaultValue:@"储存卡"];
}



@end
