//
//  Good_ThirdBoundTableViewCell.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/12/28.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ThirdBoundTableViewCell.h"
#import "SYG.h"

@implementation Good_ThirdBoundTableViewCell


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
    
    //图片
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit)];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:Image(@"站位图")];
    [self addSubview:_iconImageView];
    
    
    //机构
    _typeName = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 30 * WideEachUnit)];
    [self addSubview:_typeName];
    _typeName.text = @"中国银行";
    _typeName.font = Font(14 * WideEachUnit);
    _typeName.textColor = [UIColor colorWithHexString:@"#333"];
    
    _type = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 80 * WideEachUnit, 10 * WideEachUnit, 60 * WideEachUnit, 30 * WideEachUnit)];
    _type.text = @"储存卡";
    _type.font = Font(12 * WideEachUnit);
    _type.textColor = [UIColor colorWithHexString:@"#888"];
    _type.textAlignment = NSTextAlignmentRight;
    [self addSubview:_type];
}

- (void)dataSourceWith:(NSDictionary *)dict {
//    NSLog(@"%@",dict);
//    _bankName.text = [dict stringValueForKey:@"accounttype"];
//    _bankNumber.text = [dict stringValueForKey:@"card_info_abb"];
//    _bankType.text = [dict stringValueForKey:@"accountmaster" defaultValue:@"储存卡"];
}


@end
