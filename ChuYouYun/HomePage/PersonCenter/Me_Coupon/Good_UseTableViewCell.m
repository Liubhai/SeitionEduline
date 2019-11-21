//
//  Good_UseTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/12/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_UseTableViewCell.h"
#import "SYG.h"

@implementation Good_UseTableViewCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    self.layer.cornerRadius = 5 * WideEachUnit;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    //添加底色
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 22 * WideEachUnit)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:headerView];
    
    //添加图像
    _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20 * WideEachUnit, 120 * WideEachUnit, 123 * WideEachUnit)];
    _typeImageView.image = Image(@"");
    [self addSubview:_typeImageView];
    
    
    
    
    
    //添加类型
    _type = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 18 * WideEachUnit, 30 * WideEachUnit, 20 * WideEachUnit)];
    _type.backgroundColor = [UIColor clearColor];
    _type.text = @"打折卡";
    _type.layer.cornerRadius = 5 * WideEachUnit;
    _type.layer.masksToBounds = YES;
    _type.textAlignment = NSTextAlignmentCenter;
    _type.font = Font(8 * WideEachUnit);
    [self addSubview:_type];
    _type.textColor = [UIColor colorWithHexString:@"#5aa4e0"];
    
    
    _number = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 20 * WideEachUnit, 120 * WideEachUnit, 123 * WideEachUnit)];
    _number.backgroundColor = [UIColor clearColor];
    _number.layer.cornerRadius = 5 * WideEachUnit;
    _number.layer.masksToBounds = YES;
    _number.textAlignment = NSTextAlignmentLeft;
    _number.font = Font(12 * WideEachUnit);
    _number.textColor = [UIColor whiteColor];
    [self addSubview:_number];
    
    
    
    //添加图片
    _segmentationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(130 * WideEachUnit, 20 * WideEachUnit, 10 * WideEachUnit, 123 * WideEachUnit)];
    _segmentationImageView.image = Image(@"diacount@3x");
    [self addSubview:_segmentationImageView];
    _segmentationImageView.hidden = YES;
    
    //添加按钮
    //    _useButton = [[UIButton alloc] initWithFrame:CGRectMake(280 * WideEachUnit, 0, 65 * WideEachUnit, 150 * WideEachUnit)];
    //    _useButton.backgroundColor = BasidColor;
    //    [_useButton setTitle:@"立即使用" forState:UIControlStateNormal];
    //    [self addSubview:_useButton];
    
    //添加按钮
    _use = [[UILabel alloc] initWithFrame:CGRectMake(280 * WideEachUnit, 0, 65 * WideEachUnit, 150 * WideEachUnit)];
    _use.backgroundColor = BasidColor;
    _use.text = @"立即使用";
    _use.text = @"立\n即\n使\n用";
    _use.numberOfLines = 4;
    _use.font = Font(18 * WideEachUnit);
    _use.textColor = [UIColor whiteColor];
    _use.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_use];
    _use.hidden = YES;
    
    
    //添加类型
    _useLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 * WideEachUnit, 35 * WideEachUnit, 200 * WideEachUnit, 20 * WideEachUnit)];
    _useLabel.backgroundColor = [UIColor whiteColor];
    _useLabel.font = Font(12 * WideEachUnit);
    _useLabel.text = @"满78可用";
    _useLabel.textColor = [UIColor colorWithHexString:@"#656565"];
    [self addSubview:_useLabel];
    
    //添加用于机构
    _insetLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 * WideEachUnit, 60 * WideEachUnit, 200 * WideEachUnit, 20 * WideEachUnit)];
    _insetLabel.backgroundColor = [UIColor whiteColor];
    _insetLabel.text = @"所有机构";
    _insetLabel.font = Font(12 * WideEachUnit);
    _insetLabel.textColor = [UIColor colorWithHexString:@"#656565"];
    [self addSubview:_insetLabel];
    
    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 * WideEachUnit,100 * WideEachUnit,200 * WideEachUnit, 20 * WideEachUnit)];
    [self addSubview:_timeLabel];
    _timeLabel.text = @"2017.10.10";
    _timeLabel.font = Font(10 * WideEachUnit);
    _timeLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    
    //添加按钮
    _seleButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 72 * WideEachUnit, 20 * WideEachUnit, 20 * WideEachUnit)];
    [_seleButton setImage:Image(@"choose@3x") forState:UIControlStateNormal];
    _seleButton.backgroundColor = [UIColor whiteColor];
    [self addSubview:_seleButton];
    
    //添加隔离带
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 150 * WideEachUnit,345 * WideEachUnit , 20 * WideEachUnit)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineButton];
}

- (void)dataSourceWith:(NSDictionary *)dict {
    NSLog(@"----%@",dict);
    
    _useLabel.text = [NSString stringWithFormat:@"%@可用",[dict stringValueForKey:@"maxprice"]];
    _insetLabel.text = [NSString stringWithFormat:@"%@ 所有课程可用",[dict stringValueForKey:@"video_title"]];
    _timeLabel.text = [NSString stringWithFormat:@"%@-%@",[Passport formatterDate:[dict stringValueForKey:@"stime"]],[Passport formatterDate:[dict stringValueForKey:@"etime"]]];
    if (SWNOTEmptyStr([dict stringValueForKey:@"video_title"])) {
        _insetLabel.text = [NSString stringWithFormat:@"%@ 所有课程可用",[dict stringValueForKey:@"video_title"]];
    } else {
        _insetLabel.text = [NSString stringWithFormat:@"%@ 所有课程可用",[dict stringValueForKey:@"school_title"]];
    }
    [_number setWidth:120];
    [_typeImageView setWidth:120];
    if ([[dict stringValueForKey:@"type"] integerValue] == 1) {//优惠券
        self.typeImageView.image = Image(@"dis_coupon@3x");
        _type.text = @"优惠券";
        NSString *allStr = [NSString stringWithFormat:@"育币%@",[dict stringValueForKey:@"price"]];
        NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:allStr];
        [noteStr1 addAttribute:NSFontAttributeName value:Font(30 * WideEachUnit) range:[allStr rangeOfString:[NSString stringWithFormat:@"%@",[dict stringValueForKey:@"price"]]]];
        [_number setAttributedText:noteStr1];
        CGFloat numberWidth = [_number.text sizeWithFont:Font(30 * WideEachUnit)].width + 4;
        [_number setWidth:numberWidth>120?numberWidth:120];
        [_typeImageView setWidth:_number.width];
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 2) {//打折卡
        self.typeImageView.image = Image(@"dis_diacount@3x");
        _type.text = @"打折卡";
        NSString *allStr = [NSString stringWithFormat:@"%@折",[dict stringValueForKey:@"discount"]];
        NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:allStr];
        [noteStr1 addAttribute:NSFontAttributeName value:Font(30 * WideEachUnit) range:NSMakeRange(0, allStr.length - 1)];
        [_number setAttributedText:noteStr1];
        CGFloat numberWidth = [_number.text sizeWithFont:Font(30 * WideEachUnit)].width + 4;
        [_number setWidth:numberWidth>120?numberWidth:120];
        [_typeImageView setWidth:_number.width];
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 3) {//会员卡
        self.typeImageView.image = Image(@"dis_none@3x");
        _type.text = @"会员卡";
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 4) {//充值卡
        self.typeImageView.image = Image(@"dis_coupon@3x");
        _type.text = @"充值卡";
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 5) {//课程卡
        self.typeImageView.image = Image(@"dis_course@3x");
        _type.text = @"课程卡";
    }
}


@end
