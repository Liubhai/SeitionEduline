//
//  EJTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/29.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "EJTableViewCell.h"
#import "SYG.h"

@implementation EJTableViewCell

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
    //添加整个VIew
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, MainScreenWidth - 10, 400)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    _backView = backView;
    
    //头像
    _HeadImageButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [_HeadImageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [backView addSubview:_HeadImageButton];
    
    //名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10,MainScreenWidth - 220, 20)];
    _nameLabel.textColor = [UIColor lightGrayColor];
    [backView addSubview:_nameLabel];
    
    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 150, 10, 140, 20)];
    _timeLabel.textColor = [UIColor colorWithRed:147.f / 255 green:147.f / 255 blue:147.f / 255 alpha:1];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:_timeLabel];
    
    //具体
    _JTLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, MainScreenWidth - 70 , 100)];
    _JTLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:_JTLabel];
    
    
}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.JTLabel.text = text;
    //设置label的最大行数
    self.JTLabel.numberOfLines = 0;
    
    CGRect labelSize = [self.JTLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    
    self.JTLabel.frame = CGRectMake(self.JTLabel.frame.origin.x, self.JTLabel.frame.origin.y, MainScreenWidth - 80, labelSize.size.height);
    _backView.frame = CGRectMake(5, 5, MainScreenWidth - 10, labelSize.size.height + 40 + 10);
    _backView.layer.cornerRadius = 3;
    frame.size.height = labelSize.size.height + 40 + 10;

      self.frame = frame;
}


@end
