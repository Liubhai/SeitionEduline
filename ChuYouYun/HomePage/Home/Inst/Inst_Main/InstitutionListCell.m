//
//  InstitutionListCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstitutionListCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"
#import "Passport.h"


@implementation InstitutionListCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //头像
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, 12.5 * WideEachUnit, 60 * WideEachUnit, 60 * WideEachUnit)];

    _headImageView.image = Image(@"机构");
    [self addSubview:_headImageView];
    
    //名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 * WideEachUnit,12.5 * WideEachUnit,MainScreenWidth - 120, 16 * WideEachUnit)];
    [self addSubview:_nameLabel];
    _nameLabel.font = Font(16 * WideEachUnit);
    _nameLabel.textColor = [UIColor colorWithHexString:@"#333"];
    _nameLabel.text = @"阳光学院";
    
    //贴子和成员
    _downLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 10 - 150, 40 * WideEachUnit,150, 10 * WideEachUnit)];
    [self addSubview:_downLabel];
    _downLabel.textColor = [UIColor colorWithHexString:@"#888"];
    _downLabel.font = Font(10 * WideEachUnit);
    _downLabel.textAlignment = NSTextAlignmentRight;
    _downLabel.centerY = _nameLabel.centerY;
    
    _personNumber = [[UILabel alloc] initWithFrame:CGRectMake(200, SpaceBaside, 50, 20)];
    [self addSubview:_personNumber];
    _personNumber.textColor = [UIColor grayColor];
    _personNumber.hidden = YES;
    
    _XJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100 * WideEachUnit, 12.5 * WideEachUnit, 80 * WideEachUnit, 12 * WideEachUnit)];
    [_XJButton setBackgroundImage:Image(@"104@2x") forState:UIControlStateNormal];
    [self addSubview:_XJButton];
    _XJButton.hidden = YES;
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 35,MainScreenWidth - 80, 15)];
    [self addSubview:_titleLabel];
    _titleLabel.text = @"领域：幼儿教育、幼儿中心";
    _titleLabel.font = Font(14);
    _titleLabel.textColor = BlackNotColor;
    _titleLabel.hidden = YES;
    
    //内容
    _contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(80 * WideEachUnit, 40 * WideEachUnit , MainScreenWidth - 110 * WideEachUnit, 12 * WideEachUnit)];
    [self addSubview:_contentlabel];
    _contentlabel.numberOfLines = 1;
    _contentlabel.textColor = [UIColor colorWithHexString:@"#656565"];
    _contentlabel.font = Font(12 * WideEachUnit);
    _contentlabel.text = @"微信公众平台,给个人、企业和组织提供业务服务与用户管理能力的全新服务平台。";
}


-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.nameLabel.text = text;
    //设置label的最大行数
    self.nameLabel.numberOfLines = 0;
    
    CGRect labelSize = [self.nameLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];

    self.nameLabel.frame = CGRectMake(80 * WideEachUnit, SpaceBaside, labelSize.size.width, 20);
    if (labelSize.size.width > MainScreenWidth - 150) {
         self.nameLabel.frame = CGRectMake(80 * WideEachUnit, SpaceBaside,MainScreenWidth - 150, 20);
    }
    NSLog(@"%lf",labelSize.size.width);
//    _XJButton.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + SpaceBaside, SpaceBaside + 4, 80, 12);
    _personNumber.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 3, SpaceBaside, 100, 20);
    self.frame = frame;
}

- (void)dataSourceWith:(NSDictionary *)dict {
    NSLog(@"%@",dict);
    if (dict == nil) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[dict stringValueForKey:@"cover"]];
    [_headImageView sd_setImageWithURL:url placeholderImage:Image(@"站位图")];
    

    if ([dict[@"info"] isEqual:[NSNull null]]) {
        _contentlabel.text = @"";
    } else {
        _contentlabel.text = dict[@"info"];
    }
    [self setIntroductionText:dict[@"title"]];
    _personNumber.text = [NSString stringWithFormat:@"(%@人)",[[dict dictionaryValueForKey:@"count"] stringValueForKey:@"follower_count"]];

    NSString *starStr = [NSString stringWithFormat:@"%@",[[dict dictionaryValueForKey:@"count"] stringValueForKey:@"comment_star"]];
//    [_XJButton setBackgroundImage:Image(starStr) forState:UIControlStateNormal];
    
//    //添加灰色的星星
//    CGFloat buttonH = 15 * WideEachUnit;
//    CGFloat buttonW = 15 * WideEachUnit;
//    for (int i = 0 ; i < 5 ; i ++) {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100 * WideEachUnit +  buttonW * i, 12.5 * WideEachUnit, buttonW, buttonH)];
//        [button setImage:Image(@"star1@3x") forState:UIControlStateNormal];
//        [self addSubview:button];
//    }
//
//    for (int i = 0 ; i < [starStr integerValue] ; i ++) {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100 * WideEachUnit + buttonW * i, 12.5 * WideEachUnit, buttonW, buttonH)];
//        [button setImage:Image(@"star2@3x") forState:UIControlStateNormal];
//        [self addSubview:button];
//    }
    
    NSString *locationStr = [dict stringValueForKey:@"location"];
    NSString *videoNumStr = [[dict dictionaryValueForKey:@"count"] stringValueForKey:@"video_count"];
    NSString *teacherNumStr = [[dict dictionaryValueForKey:@"count"] stringValueForKey:@"teacher_count"];
    
    if ([locationStr isEqualToString:@""]) {
        locationStr = @"暂无地址";
        _downLabel.text = [NSString stringWithFormat:@"%@ | %@门课程 | %@位讲师",locationStr,videoNumStr,teacherNumStr];
    } else {
        _downLabel.text = [NSString stringWithFormat:@"%@ | %@门课程 | %@位讲师",locationStr,videoNumStr,teacherNumStr];
    }
    
    _downLabel.text = [NSString stringWithFormat:@"%@课程 | %@讲师",videoNumStr,teacherNumStr];
//    _downLabel.hidden = YES;
    
}

@end
