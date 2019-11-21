//
//  ZXZXTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//
//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#import "ZXZXTableViewCell.h"
#import "SYG.h"

@implementation ZXZXTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 13, MainScreenWidth / 5 * 2 - 10 + 2, 110 - 26)];
    _imageButton.userInteractionEnabled = NO;
    [self addSubview:_imageButton];

    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + 13, 13, MainScreenWidth - MainScreenWidth / 5 * 2 - 13 - 10, 16)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_titleLabel];
    
    //阅读
    _readLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + 13, 29 + 55, 100, 15)];
    _readLabel.textColor = [UIColor colorWithRed:147.f / 255 green:147.f / 255 blue:147.f / 255 alpha:1];
    _readLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_readLabel];

    
    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 140, 29 + 55, 130, 15)];
    _timeLabel.textColor = [UIColor colorWithRed:147.f / 255 green:147.f / 255 blue:147.f / 255 alpha:1];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_timeLabel];

    
    //具体
    _JTLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 5 * 2 + 13, 29, MainScreenWidth - MainScreenWidth / 5 * 2 - 13 - 10, 62)];
    _JTLabel.font = [UIFont systemFontOfSize:13];
    _JTLabel.numberOfLines = 2;
    [self addSubview:_JTLabel];

    
}



@end
