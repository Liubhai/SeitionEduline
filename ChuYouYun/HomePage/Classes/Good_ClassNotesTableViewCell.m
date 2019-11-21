//
//  Good_ClassNotesTableViewCell.m
//  YunKeTang
//
//  Created by IOS on 2019/3/19.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassNotesTableViewCell.h"
#import "SYG.h"


@implementation Good_ClassNotesTableViewCell


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
    
    //头像
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 10 * WideEachUnit, 38 * WideEachUnit, 38 * WideEachUnit)];
    _headerImage.layer.cornerRadius = 19 * WideEachUnit;
    _headerImage.layer.masksToBounds = YES;
    _headerImage.backgroundColor = [UIColor redColor];
    [self addSubview:_headerImage];
    
    //标题
    _name = [[UILabel alloc] initWithFrame:CGRectMake(60 * WideEachUnit, 15 * WideEachUnit,MainScreenWidth - 80 * WideEachUnit, 15 * WideEachUnit)];
    _name.font = Font(14 * WideEachUnit);
    _name.textColor = [UIColor colorWithHexString:@"#666"];
    _name.text = @"人与自然";
    [self addSubview:_name];
    
    //具体内容
    _content = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 52 * WideEachUnit , MainScreenWidth - 120 * WideEachUnit, 14 * WideEachUnit)];
    [self addSubview:_content];
    _content.numberOfLines = 1;
    _content.text = @"老师讲的好";
    _content.textColor = [UIColor colorWithHexString:@"#333"];
    _content.font = Font(14 * WideEachUnit);
    
    //时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_content.frame) + 10 * WideEachUnit , MainScreenWidth / 2, 10 * WideEachUnit)];
    [self addSubview:_time];
    _time.numberOfLines = 1;
    _time.text = @"50分钟";
    _time.textColor = [UIColor grayColor];
    _time.font = Font(10 * WideEachUnit);
    
    _praiseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 130 * WideEachUnit, CGRectGetMaxY(_content.frame) + 10 * WideEachUnit, 60 * WideEachUnit, 20 * WideEachUnit)];
    [_praiseButton setTitle:@"100" forState:UIControlStateNormal];
    [_praiseButton setImage:Image(@"zan@2x") forState:UIControlStateNormal];
    [_praiseButton setTitleColor:[UIColor colorWithHexString:@"#8A8A8A"] forState:UIControlStateNormal];
    _praiseButton.titleLabel.font = Font(12);
    [self addSubview:_praiseButton];

    _commentsButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70 * WideEachUnit,CGRectGetMaxY(_content.frame) + 10 * WideEachUnit , 60 * WideEachUnit, 20 * WideEachUnit)];
    [_commentsButton setTitle:@"200" forState:UIControlStateNormal];
    [_commentsButton setTitleColor:[UIColor colorWithHexString:@"#8A8A8A"] forState:UIControlStateNormal];
    _commentsButton.titleLabel.font = Font(12);
    [_commentsButton setImage:Image(@"code@2x") forState:UIControlStateNormal];
    [self addSubview:_commentsButton];
    
}

- (void)dataSourceWithDict:(NSDictionary *)dict WithType:(NSString *)type {
    if ([type integerValue] == 1) {//笔记
        NSString *urlStr = [dict stringValueForKey:@"userface"];
        [_headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        _name.text = [dict stringValueForKey:@"username"];
        _time.text = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
        _content.text = [dict stringValueForKey:@"note_description"];
        [_praiseButton setTitle:[dict stringValueForKey:@"note_help_count"] forState:UIControlStateNormal];
        [_commentsButton setTitle:[dict stringValueForKey:@"note_comment_count"] forState:UIControlStateNormal];
    } else if ([type integerValue] == 2) {//提问
        NSString *urlStr = [dict stringValueForKey:@"userface"];
        [_headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        _name.text = [dict stringValueForKey:@"username"];
        _time.text = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
        _content.text = [dict stringValueForKey:@"qst_description"];
        [_praiseButton setTitle:[dict stringValueForKey:@"qst_help_count"] forState:UIControlStateNormal];
        [_commentsButton setTitle:[dict stringValueForKey:@"qst_comment_count"] forState:UIControlStateNormal];
    }
}


-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.content.text = text;
    //设置label的最大行数
    self.content.numberOfLines = 0;
    CGSize size = CGSizeMake(MainScreenWidth - 70 * WideEachUnit, 10000);
    
    CGSize labelSize = [self.content.text sizeWithFont:self.content.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    self.content.frame = CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y, labelSize.width, labelSize.height);
    frame.size.height = labelSize.height + 70 * WideEachUnit;
    
    NSLog(@"-----%lf",labelSize.height);
    self.frame = frame;
}



@end
