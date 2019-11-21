//
//  Good_ManagementCardTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/13.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_ManagementCardTableViewCell.h"
#import "SYG.h"

@implementation Good_ManagementCardTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //机构
    _bankName = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 30 * WideEachUnit)];
    [self addSubview:_bankName];
    _bankName.text = @"";
    _bankName.font = Font(16 * WideEachUnit);
    _bankName.backgroundColor = [UIColor whiteColor];
    
    //取消
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90, SpaceBaside, 80 * WideEachUnit, 30 * WideEachUnit)];
    [_cancelButton setTitle:@"解除绑定" forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = Font(16 * WideEachUnit) ;
    _cancelButton.layer.borderColor = BasidColor.CGColor;
    [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#d04c4c"] forState:UIControlStateNormal];
    [self addSubview:_cancelButton];
    
}

- (void)dataSourceWith:(NSDictionary *)dict {
    NSLog(@"%@",dict);
    
    _bankName.text = [dict stringValueForKey:@"accounttype" defaultValue:@""];
    
}

@end
