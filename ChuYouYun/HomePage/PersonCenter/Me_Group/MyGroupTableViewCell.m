//
//  MyGroupTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/9.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MyGroupTableViewCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"

@implementation MyGroupTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _groupImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 60, 60)];
    [self addSubview:_groupImageView];
    _groupImageView.backgroundColor = [UIColor whiteColor];
    _groupImageView.layer.cornerRadius = 30;
    _groupImageView.layer.masksToBounds = YES;
    
    _groupName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_groupImageView.frame) + SpaceBaside, SpaceBaside, 200, 30)];
    [self addSubview:_groupName];
    _groupName.text = @"学习小组";
    _groupName.font = Font(16);
    _groupName.backgroundColor = [UIColor whiteColor];
    
    
    _numberRefresh = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_groupName.frame) + SpaceBaside + SpaceBaside / 2, SpaceBaside, 90, 20)];
    [self addSubview:_numberRefresh];
    _numberRefresh.layer.cornerRadius = 10;
    _numberRefresh.layer.masksToBounds = YES;
    _numberRefresh.text = @"  99更新";
    _numberRefresh.backgroundColor = [UIColor colorWithRed:31.f / 225 green:190.f / 255 blue:210.f / 255 alpha:1];
    _numberRefresh.hidden = YES;
    
    
    _allNumberPerson = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_groupImageView.frame) + SpaceBaside,40,MainScreenWidth - 150, 30)];
    [self addSubview:_allNumberPerson];
    _allNumberPerson.text = @"总人数 123456";
    _allNumberPerson.font = Font(12);
    _allNumberPerson.textColor = [UIColor grayColor];
    
    
    _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 20, 60, 40)];
    [_actionButton setTitle:@". . ." forState:UIControlStateNormal];
    _actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_actionButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [self addSubview:_actionButton];
    
}



- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)type {
//    [self setIntroductionText:@"学习小组"];
    NSLog(@"%@",dict);
    NSString *urlStr = [dict stringValueForKey:@"logourl"];
    [_groupImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    
    _groupName.text = [dict stringValueForKey:@"name"];
    NSString *person = [NSString stringWithFormat:@"成员：%@",[dict stringValueForKey:@"membercount"]];
    NSString *post = [NSString stringWithFormat:@"帖子：%@",[dict stringValueForKey:@"threadcount"]];
    _allNumberPerson.text = [NSString stringWithFormat:@"%@     %@",person,post];
    
    
}


-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    self.groupName.text = text;
    //设置label的最大行数
    self.groupName.numberOfLines = 1;
    
    CGRect labelSize = [self.groupName.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    self.groupName.frame = CGRectMake(self.groupName.frame.origin.x, self.groupName.frame.origin.y,labelSize.size.width, 30);
    _numberRefresh.frame = CGRectMake(CGRectGetMaxX(_groupName.frame) + SpaceBaside, SpaceBaside + SpaceBaside / 2 , 90, 20);
}



@end
