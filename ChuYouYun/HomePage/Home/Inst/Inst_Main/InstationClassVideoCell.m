//
//  InstationClassVideoCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/7.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstationClassVideoCell.h"
#import "SYG.h"


@implementation InstationClassVideoCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
//    //在每个View 上面添加东西
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 80, 80)];
//    imageView.image = Image(@"大家好");
//    imageView.layer.cornerRadius = 40;
//    imageView.layer.masksToBounds = YES;
//    [self addSubview:imageView];
//    _headerImageView = imageView;
//    
//    //名字 文本
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
//    nameLabel.text = @"石远刚";
//    nameLabel.font = Font(14);
//    [self addSubview:nameLabel];
//    _nameLabel = nameLabel;
//    
//    //内容
//    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 20, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
//    contentLabel.text = @"口语-英语生活口语100句";
//    contentLabel.font = Font(12);
//    [self addSubview:contentLabel];
//    _contentLabel = contentLabel;
//    
////    //详情
////    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 40, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
////    detailLabel.text = @"一份耕耘，一份收获";
////    detailLabel.font = Font(12);
////    detailLabel.textColor = [UIColor grayColor];
////    [self addSubview:detailLabel];
////    _contentLabel = detailLabel;
//    
//    //时间
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 60, 120, 20)];
//    timeLabel.text = @"￥228/小时";
//    timeLabel.font = Font(15);
//    timeLabel.textColor = [UIColor orangeColor];
//    [self addSubview:timeLabel];
//    _teacherLabel = timeLabel;
//    
//    //在线授课
//    UILabel *applyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, SpaceBaside + 60, 110, 20)];
//    applyLabel.text = @"可在线授课";
//    applyLabel.font = Font(12);
//    applyLabel.textAlignment = NSTextAlignmentRight;
//    applyLabel.textColor = [UIColor grayColor];
//    [self addSubview:applyLabel];
//    _applyLabel = applyLabel;
    
    
    
    //在每个View 上面添加东西
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 60)];
    imageView.image = Image(@"大家好");
    [self addSubview:imageView];
    _headerImageView = imageView;
    
    //名字 文本
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
    nameLabel.text = @"一年级语文";
    nameLabel.font = Font(14);
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    //详情
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 20, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
    detailLabel.text = @"38小时|25人班|2016-09-30开课";
    detailLabel.font = Font(12);
    detailLabel.textColor = [UIColor grayColor];
    [self addSubview:detailLabel];
    _contentLabel = detailLabel;
    
    //老师
    UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 40, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
    teacherLabel.text = @"老师：石远刚";
    teacherLabel.font = Font(13);
    teacherLabel.textColor = [UIColor grayColor];
    [self addSubview:teacherLabel];
    _teacherLabel = teacherLabel;
    
    //价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 60, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
    priceLabel.text = @"2280.00育币";
    priceLabel.font = Font(15);
    priceLabel.textColor = [UIColor orangeColor];
    [self addSubview:priceLabel];
    _priceLabel = priceLabel;
 
    //添加报名 文本
    UILabel *applyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside + CGRectGetHeight(imageView.frame), CGRectGetWidth(imageView.frame) , 20)];
    applyLabel.text = @"已报名12/15人";
    applyLabel.font = Font(12);
    applyLabel.textColor = [UIColor grayColor];
    [self addSubview:applyLabel];
    _applyLabel = applyLabel;

    
}


- (void)dataSourceWith:(NSDictionary *)dict {
    
    //    NSURL *url = [NSURL URLWithString:dict[@"attach"]];
    //    [_headImageView sd_setImageWithURL:url placeholderImage:Image(@"站位图")];
    //
    //    _titleLabel.text = dict[@"title"];
    //    _nameLabel.text = dict[@"name"];;
    
}

@end
