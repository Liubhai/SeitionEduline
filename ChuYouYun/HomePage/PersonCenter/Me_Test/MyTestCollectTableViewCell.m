//
//  MyTestCollectTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/26.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MyTestCollectTableViewCell.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"

@implementation MyTestCollectTableViewCell

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
    _name = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit,15 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    [self addSubview:_name];
    _name.font = Font(15 * WideEachUnit);
    _name.numberOfLines = 2;
    [self setIntroductionText:@"使用一应你带大的空间点击我么大的期"];
    _name.textColor = [UIColor colorWithHexString:@"#333"];
    
    //名字
    _time = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 45 * WideEachUnit,MainScreenWidth - 90 * WideEachUnit, 15 * WideEachUnit)];
    [self addSubview:_time];
    _time.font = Font(13 * WideEachUnit);
    _time.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _time.text = @"2017.10.10";
    
    //机构按钮
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80 * WideEachUnit, 0, 70 * WideEachUnit, 75 * WideEachUnit)];
    _rightButton.backgroundColor = [UIColor whiteColor];
    [_rightButton setBackgroundImage:Image(@"ic_more@3x") forState:UIControlStateNormal];
    [self addSubview:_rightButton];
    _rightButton.hidden = YES;
    
}

- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)type {
    
    _name.text = [Passport filterHTML:[[dict dictionaryValueForKey:@"question_info"] stringValueForKey:@"content"]];
    [self setIntroductionText:_name.text];
    _time.text = [Passport formatterTime:[dict stringValueForKey:@"ctime"]];
}


//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    
    CGRect frame = [self frame];
    
    //文本赋值
    self.name.text = text;
    //设置label的最大行数
    self.name.numberOfLines = 2;
    
    CGRect labelSize = [self.name.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15 * WideEachUnit]} context:nil];
    
    if (labelSize.size.height > 40 * WideEachUnit) {//让最大化为2排
        labelSize.size.height = 40 * WideEachUnit;
    }
    self.name.frame = CGRectMake(10 * WideEachUnit, 15 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit, labelSize.size.height);
    
    _time.frame = CGRectMake(10 * WideEachUnit, labelSize.size.height + 30 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit);
    
    frame = CGRectMake(0, 0, MainScreenWidth, labelSize.size.height + 60 * WideEachUnit);
    self.frame = frame;
    
}



@end
