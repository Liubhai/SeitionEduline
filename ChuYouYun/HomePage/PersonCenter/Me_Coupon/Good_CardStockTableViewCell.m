//
//  Good_CardStockTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/2.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_CardStockTableViewCell.h"
#import "SYG.h"

@implementation Good_CardStockTableViewCell

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
    
    //添加很线
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 20 * WideEachUnit, 100 * WideEachUnit, 30 * WideEachUnit)];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:24 * WideEachUnit];
    [self addSubview:_titleLabel];
    
    //添加类型
    _type = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 10 * WideEachUnit, 25 * WideEachUnit, 100 * WideEachUnit, 20 * WideEachUnit)];
    _type.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _type.text = @"打折卡";
    _type.layer.cornerRadius = 5 * WideEachUnit;
    _type.layer.masksToBounds = YES;
    _type.textAlignment = NSTextAlignmentCenter;
    _type.font = Font(12 * WideEachUnit);
    [self addSubview:_type];
    
    
    //添加图片
    _segmentationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270 * WideEachUnit, 0, 10 * WideEachUnit, 150 * WideEachUnit)];
    _segmentationImageView.image = Image(@"diacount@3x");
    [self addSubview:_segmentationImageView];
    
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
    
    
    //添加类型
    _useLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 60 * WideEachUnit, 200 * WideEachUnit, 30 * WideEachUnit)];
    _useLabel.backgroundColor = [UIColor whiteColor];
    _useLabel.font = Font(14 * WideEachUnit);
    _useLabel.text = @"";
    [self addSubview:_useLabel];
    
    //添加用于机构
    _insetLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 85 * WideEachUnit, 200 * WideEachUnit, 20 * WideEachUnit)];
    _insetLabel.backgroundColor = [UIColor whiteColor];
    _insetLabel.text = @"";
    _insetLabel.font = Font(15 * WideEachUnit);
    [self addSubview:_insetLabel];
    
    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit,110 * WideEachUnit,200 * WideEachUnit, 20 * WideEachUnit)];
    [self addSubview:_timeLabel];
    _timeLabel.text = @"2017.10.10";
    _timeLabel.font = Font(15 * WideEachUnit);
    _timeLabel.textColor = [UIColor colorWithHexString:@"#888"];
    
    //添加隔离带
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 150 * WideEachUnit,MainScreenWidth , 20 * WideEachUnit)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineButton];
    _lineButton = lineButton;
}


-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    //文本赋值
    self.titleLabel.text = text;
    //设置label的最大行数
    self.titleLabel.numberOfLines = 0;

    CGRect labelSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:24 * WideEachUnit]} context:nil];

    self.titleLabel.frame = CGRectMake(15 * WideEachUnit, 20 * WideEachUnit, labelSize.size.width, 30 * WideEachUnit);
    _type.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 10 * WideEachUnit, 25 * WideEachUnit, 50 * WideEachUnit, 20 * WideEachUnit);
}

- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)typeStr {
    NSLog(@"dict ----- %@  ---- %@",dict,typeStr);
    
    _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[Passport formatterDate:[dict stringValueForKey:@"ctime"]],[Passport formatterDate:[dict stringValueForKey:@"end_time"]]];

    //卡券类型【1:优惠卡;2:打折卡;5:课程卡;4:充值卡;3:会员卡;
    if ([typeStr integerValue] == 2) {//打折卡
        _use.backgroundColor = [UIColor colorWithHexString:@"#5aa4e0"];
        _type.backgroundColor = [UIColor colorWithHexString:@"#5aa4e0"];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#5aa4e0"];
        _type.text = @"打折券";
        _segmentationImageView.image = Image(@"diacount@3x");
        _useLabel.text = [NSString stringWithFormat:@"满%@育币可用",[dict stringValueForKey:@"maxprice"]];
        _insetLabel.text = [dict stringValueForKey:@"school_title"];
        
        _titleLabel.text = [NSString stringWithFormat:@"%@ 折",[dict stringValueForKey:@"discount"]];
        [self setIntroductionText:_titleLabel.text];
        NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
        [noteStr1 addAttribute:NSFontAttributeName value:Font(16 * WideEachUnit) range:NSMakeRange(_titleLabel.text.length - 1, 1)];
        [_titleLabel setAttributedText:noteStr1];
        
    } else if ([typeStr integerValue] == 3) {//会员卡
        _use.backgroundColor = [UIColor colorWithHexString:@"#ff8a65"];
        _type.backgroundColor = [UIColor colorWithHexString:@"#ff8a65"];
        _titleLabel.textColor =  [UIColor colorWithHexString:@"#ff8a65"];
        _type.text = @"会员卡";
        _segmentationImageView.image = Image(@"member@3x");
        _useLabel.text = [NSString stringWithFormat:@"%@ | %@天内有效", [[dict dictionaryValueForKey:@"vip_grade_list"] stringValueForKey:@"title"],[dict stringValueForKey:@"exp_date"]];
        _insetLabel.text = @"仅限解锁指定课程使用";
        _insetLabel.hidden = YES;
        
        _titleLabel.text = [NSString stringWithFormat:@"%@ 天",[dict stringValueForKey:@"vip_date"]];
        [self setIntroductionText:_titleLabel.text];
        NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
        [noteStr1 addAttribute:NSFontAttributeName value:Font(16 * WideEachUnit) range:NSMakeRange(_titleLabel.text.length - 1, 1)];
        [_titleLabel setAttributedText:noteStr1];
        
    } else if ([typeStr integerValue] == 5) {//课程卡
        _use.backgroundColor = [UIColor colorWithHexString:@"#8c9eff"];
        _type.backgroundColor = [UIColor colorWithHexString:@"#8c9eff"];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#8c9eff"];
        _type.text = @"课程卡";
        _titleLabel.frame = CGRectMake(20 * WideEachUnit, 20 * WideEachUnit, 170 * WideEachUnit, 30 * WideEachUnit);
        _type.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 10 * WideEachUnit, 25 * WideEachUnit, 60 * WideEachUnit, 20 * WideEachUnit);
        _insetLabel.text = @"仅限解锁指定课程使用";
        _titleLabel.text = [dict stringValueForKey:@"video_title"];
        _titleLabel.font = Font(20 * WideEachUnit);
        _segmentationImageView.image = Image(@"coursecard@3x");
    } else if ([typeStr integerValue] == 1) {//优惠券
        _use.backgroundColor = [UIColor colorWithHexString:@"#f77a7a"];
        _type.backgroundColor = [UIColor colorWithHexString:@"#f77a7a"];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#f77a7a"];
        _type.text = @"优惠券";
        _segmentationImageView.image = Image(@"coupon@3x");
        _insetLabel.text = [dict stringValueForKey:@"school_title"];
        _useLabel.text = [NSString stringWithFormat:@"满%@育币可用",[dict stringValueForKey:@"maxprice"]];
        
        _titleLabel.text = [NSString stringWithFormat:@"育币%@",[dict stringValueForKey:@"price"]];
        [self setIntroductionText:_titleLabel.text];
        NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
        [noteStr1 addAttribute:NSFontAttributeName value:Font(16 * WideEachUnit) range:NSMakeRange(0,1)];
        [_titleLabel setAttributedText:noteStr1];
    } else if ([typeStr integerValue] == 4) {
        
    }
}

@end
