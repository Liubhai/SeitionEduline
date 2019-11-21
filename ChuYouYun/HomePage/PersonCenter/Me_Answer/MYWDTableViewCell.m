//
//  MYWDTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/18.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "MYWDTableViewCell.h"
#import "SYG.h"

@implementation MYWDTableViewCell

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
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 60)];
    _titleLabel.font = Font(17);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    
    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, MainScreenWidth - 10 - 100, 20)];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.textColor = [UIColor colorWithRed:128.f / 255 green:128.f / 255 blue:128.f / 255 alpha:1];
    [self addSubview:_timeLabel];
    

    //人
    _personLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, 70,110, 20)];
    _personLabel.font = [UIFont systemFontOfSize:15];
    _personLabel.textColor = [UIColor colorWithRed:128.f / 255 green:128.f / 255 blue:128.f / 255 alpha:1];
    _personLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_personLabel];
    
    
    
    
    
}



@end
