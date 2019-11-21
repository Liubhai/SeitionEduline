//
//  MyDownLineTableViewCell.m
//  YunKeTang
//
//  Created by IOS on 2018/11/16.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "MyDownLineTableViewCell.h"
#import "SYG.h"


@implementation MyDownLineTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    self.backgroundColor = [UIColor whiteColor];
    CGFloat space = 0.5;
    CGFloat laeblWidth = (MainScreenWidth - 10 * space) / 5;
    CGFloat labelHight = 40 * WideEachUnit;
    NSArray *titleArray = @[@"会员昵称",@"注册时间",@"推荐层级",@"附带收入",@"推荐人数"];
    for (int i = 0 ; i < 5 ; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(laeblWidth * i + space, 0, laeblWidth, labelHight)];
        [self addSubview:label];
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(12);
        label.textColor = BlackNotColor;
        label.text = titleArray[i];
        if (i == 0) {
            _nameLabel = label;
        } else if (i == 1) {
            _timeLabel = label;
        } else if (i == 2) {
            _recommendedLabel = label;
        } else if (i ==3) {
            _attachedLabel = label;
        } else if (i == 4) {
            _personLabel = label;
        }
    }
}

- (void)cellWithDict:(NSDictionary *)dict WithIndexPath:(NSInteger)index{
    if (index != 0) {
        _nameLabel.text = [dict stringValueForKey:@"uname"];
        _timeLabel.text = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
        _attachedLabel.text = [NSString stringWithFormat:@"%@育币", [dict stringValueForKey:@"num"]];
        if ([[dict stringValueForKey:@"level"] integerValue] == 1) {
             _recommendedLabel.text = @"一级推荐";
        } else if ([[dict stringValueForKey:@"level"] integerValue] == 2) {
             _recommendedLabel.text = @"二级推荐";
        }
        _personLabel.text = [dict stringValueForKey:@"userCount"];
        
        _nameLabel.font = Font(10);
        _timeLabel.font = Font(10);
        _attachedLabel.font = Font(10);
        _recommendedLabel.font = Font(10);
        _personLabel.font = Font(10);
    }
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
