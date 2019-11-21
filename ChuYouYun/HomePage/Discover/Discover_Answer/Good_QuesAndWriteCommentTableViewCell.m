//
//  Good_QuesAndWriteCommentTableViewCell.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/25.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_QuesAndWriteCommentTableViewCell.h"
#import "SYG.h"


@implementation Good_QuesAndWriteCommentTableViewCell


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
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineButton];
    
    //头像
    _HeadImage = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 12 * WideEachUnit, 20 * WideEachUnit, 20 * WideEachUnit)];
    [_HeadImage setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    _HeadImage.layer.cornerRadius = 10 * WideEachUnit;
    _HeadImage.layer.masksToBounds = YES;
    [self addSubview:_HeadImage];
    
    //名字
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_HeadImage.frame) + 8 * WideEachUnit, 12 * WideEachUnit, MainScreenWidth - CGRectGetMaxX(_HeadImage.frame) - 100 * WideEachUnit , 15 * WideEachUnit)];
    _NameLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _NameLabel.font = Font(12 * WideEachUnit);
    _NameLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_NameLabel];
    
    
    //具体
    _JTLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_HeadImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20, 30 * WideEachUnit)];
    _JTLabel.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    _JTLabel.textColor = [UIColor colorWithHexString:@"#656565"];
    _JTLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_JTLabel];
    
    
    
    //时间
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_JTLabel.frame) + 10 * WideEachUnit, 80 * WideEachUnit, 20 * WideEachUnit)];
    _TimeLabel.textColor = [UIColor colorWithHexString:@"#666"];
    _TimeLabel.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _TimeLabel.textAlignment = NSTextAlignmentLeft;
    _TimeLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_TimeLabel];
    
    
    
    //各种
    _kinsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_JTLabel.frame) + 10 * WideEachUnit, MainScreenWidth / 2, 20 * WideEachUnit)];
    _kinsLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _kinsLabel.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _kinsLabel.textAlignment = NSTextAlignmentLeft;
    _kinsLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_kinsLabel];
    _kinsLabel.hidden = YES;
    
    //添加赞的按钮
    _praiseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80 * WideEachUnit, CGRectGetMaxY(_JTLabel.frame) + 10 * WideEachUnit, 70 * WideEachUnit, 20)];
    _praiseButton.backgroundColor = [UIColor whiteColor];
    [_praiseButton setImage:Image(@"ico_like@3x") forState:UIControlStateNormal];
    [_praiseButton setTitle:@"250" forState:UIControlStateNormal];
    [_praiseButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
    [self addSubview:_praiseButton];
    
    
    //图片
    _TPView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    
    
    //
    //    //添加灰色地带
    //    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 90 * WideEachUnit, MainScreenWidth , 10 * WideEachUnit)];
    //    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    [self addSubview:footView];
    //
}

- (void)dataWithDict:(NSDictionary *)dict {
    _NameLabel.text = @"李四";
    _TimeLabel.text = @"2018-2-10";
    _JTLabel.text = @"这是一条评论";
    _kinsLabel.text = @"155点赞.88评论";
}


@end
