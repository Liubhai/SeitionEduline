//
//  GroupTableViewCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"

@implementation GroupTableViewCell

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
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 15 * WideEachUnit, 80 * WideEachUnit, 80 * WideEachUnit)];
//    _headImageView.layer.masksToBounds = YES;
//    _headImageView.layer.cornerRadius = 25;
    [self addSubview:_headImageView];
    
    //标题
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 * WideEachUnit, 15 * WideEachUnit,MainScreenWidth - 80 * WideEachUnit, 20 * WideEachUnit)];
    [self addSubview:_nameLabel];
    
    //内容
    _contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(110 * WideEachUnit, 40 * WideEachUnit , MainScreenWidth - 120 * WideEachUnit, 35 * WideEachUnit)];
    [self addSubview:_contentlabel];
    _contentlabel.numberOfLines = 2;
    _contentlabel.textColor = [UIColor grayColor];
    _contentlabel.font = Font(13 * WideEachUnit);
    
    //贴子和成员
    _mixLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 * WideEachUnit, 80 * WideEachUnit,(MainScreenWidth - 110 * WideEachUnit - 2 * SpaceBaside * WideEachUnit) / 2, 15 * WideEachUnit)];
    [self addSubview:_mixLabel];
    _mixLabel.textColor = [UIColor grayColor];
    _mixLabel.font = Font(13);
    
    _member = [[UILabel alloc] initWithFrame:CGRectMake(110 * WideEachUnit + (MainScreenWidth - 110 * WideEachUnit - 2 * SpaceBaside * WideEachUnit) / 2 , 80 * WideEachUnit,(MainScreenWidth - 110 * WideEachUnit - 2 * SpaceBaside * WideEachUnit) / 2, 15 * WideEachUnit)];
    [self addSubview:_member];
    _member.textColor = [UIColor grayColor];
    _member.font = Font(13 * WideEachUnit);
    
    
    
}

- (void)dataSourceWithDict:(NSDictionary *)dict {

    _nameLabel.text = [dict stringValueForKey:@"name"];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"logourl"]];
    NSLog(@"--%@",urlStr);
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"站位图"]];
    _contentlabel.text = [dict stringValueForKey:@"intro"];
    _mixLabel.text = [NSString stringWithFormat:@"成员：%@",[dict stringValueForKey:@"membercount"]];
    _member.text = [NSString stringWithFormat:@"贴子：%@",[dict stringValueForKey:@"threadcount"]];
 
}

@end
