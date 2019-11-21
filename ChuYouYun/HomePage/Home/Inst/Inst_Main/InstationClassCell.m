//
//  InstationClassCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstationClassCell.h"
#import "SYG.h"


@implementation InstationClassCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{

    //在每个View 上面添加东西
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 80, 80)];
    imageView.image = Image(@"大家好");
    imageView.layer.cornerRadius = 40;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    _headerImageView = imageView;
    
    //名字 文本
    UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
    teacherLabel.text = @"石远刚";
    teacherLabel.font = Font(14);
    [self addSubview:teacherLabel];
    _nameLabel = teacherLabel;
    
    //名字 文本
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 20, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
    nameLabel.text = @"口语-英语生活口语100句";
    nameLabel.font = Font(12);
    [self addSubview:nameLabel];
    _typeLabel = nameLabel;
    
    //详情
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 40, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
    detailLabel.text = @"一份耕耘，一份收获";
    detailLabel.font = Font(12);
    detailLabel.textColor = [UIColor grayColor];
    [self addSubview:detailLabel];
    _contentLabel = detailLabel;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 60, 120, 20)];
    timeLabel.text = @"228育币/小时";
    timeLabel.font = Font(15);
    timeLabel.textColor = [UIColor orangeColor];
    [self addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    //在线授课
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, SpaceBaside + 60, 110, 20)];
    lineLabel.text = @"可在线授课";
    lineLabel.font = Font(12);
    lineLabel.textAlignment = NSTextAlignmentRight;
    lineLabel.textColor = [UIColor grayColor];
    [self addSubview:lineLabel];
    _onLine = lineLabel;
  
}


- (void)dataSourceWith:(NSDictionary *)dict {
    
//    NSURL *url = [NSURL URLWithString:dict[@"attach"]];
//    [_headImageView sd_setImageWithURL:url placeholderImage:Image(@"站位图")];
//    
//    _titleLabel.text = dict[@"title"];
//    _nameLabel.text = dict[@"name"];;
    
}

@end
