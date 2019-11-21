//
//  SearchTeacherCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/11.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "SearchTeacherCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"


@implementation SearchTeacherCell


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
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 80, 80)];
    
    _headImageView.image = Image(@"你好");
    _headImageView.layer.cornerRadius = 40;
    _headImageView.layer.masksToBounds = YES;
    [self addSubview:_headImageView];
    
    //名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_headImageView.frame) + SpaceBaside, SpaceBaside,MainScreenWidth - 110, 20)];
    [self addSubview:_nameLabel];
    _nameLabel.text = @"石远刚";
    
    //课程相关
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, SpaceBaside,95, 20)];
    [self addSubview:_numLabel];
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.textColor = [UIColor grayColor];
    _numLabel.font = Font(14);
    _numLabel.text = @"相关课程：2";
    
    //内容
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_headImageView.frame) + SpaceBaside, 40 , MainScreenWidth - 100, 50)];
    [self addSubview:_contentLabel];
    _contentLabel.numberOfLines = 3;
    _contentLabel.textColor = BlackNotColor;
    _contentLabel.font = Font(13);
    _contentLabel.text = @"教学经验丰富，从事教育事业多年，让每个学生成长了许多，是个幽默的老师，职业素质也不错。";
    
}


- (void)dataSourceWith:(NSDictionary *)dict {
    
    NSURL *url = [NSURL URLWithString:dict[@"headimg"]];
    [_headImageView sd_setImageWithURL:url placeholderImage:Image(@"站位图")];
    
//    _titleLabel.text = dict[@"title"];

    if ([dict[@"inro"] isEqual:[NSNull null]]) {
        _contentLabel.text = @"暂无详情";
    } else {
        _contentLabel.text = dict[@"inro"];
    }
    _nameLabel.text = dict[@"name"];
    _numLabel.text = [NSString stringWithFormat:@"相关课程：%@",dict[@"video_count"]];
    
}


@end
