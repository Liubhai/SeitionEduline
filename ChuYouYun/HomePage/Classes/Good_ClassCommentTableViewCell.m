//
//  Good_ClassCommentTableViewCell.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/11.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassCommentTableViewCell.h"
#import "SYG.h"

@implementation Good_ClassCommentTableViewCell


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
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 10 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit)];
    _headerImage.layer.cornerRadius = 15 * WideEachUnit;
    _headerImage.layer.masksToBounds = YES;
    _headerImage.backgroundColor = [UIColor redColor];
    [self addSubview:_headerImage];
    
    //标题
    _title = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 15 * WideEachUnit,MainScreenWidth - 80 * WideEachUnit, 15 * WideEachUnit)];
    _title.font = Font(14 * WideEachUnit);
    _title.textColor = [UIColor colorWithHexString:@"#666"];
    _title.text = @"人与自然";
    [self addSubview:_title];
    
    //时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 40 * WideEachUnit , MainScreenWidth - 120 * WideEachUnit, 10 * WideEachUnit)];
    [self addSubview:_time];
    _time.numberOfLines = 1;
    _time.text = @"50分钟";
    _time.textColor = [UIColor grayColor];
    _time.font = Font(10 * WideEachUnit);
    
    //具体内容
    _content = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 62 * WideEachUnit , MainScreenWidth - 120 * WideEachUnit, 14 * WideEachUnit)];
    [self addSubview:_content];
    _content.numberOfLines = 1;
    _content.text = @"老师讲的好";
    _content.textColor = [UIColor colorWithHexString:@"#333"];
    _content.font = Font(14 * WideEachUnit);
    
    //试看
    _starButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, 25 * WideEachUnit, 80 * WideEachUnit, 14 * WideEachUnit)];
    _starButton.backgroundColor = [UIColor whiteColor];
//    [_starButton setTitle:@"可试看" forState:UIControlStateNormal];
    [_starButton setBackgroundImage:Image(@"104@2x") forState:UIControlStateNormal];
    [_starButton setTitleColor:[UIColor colorWithHexString:@"#25b882"] forState:UIControlStateNormal];
    _starButton.titleLabel.font = Font(12 * WideEachUnit);
    [self addSubview:_starButton];
}

- (void)dataSourceWithDict:(NSDictionary *)dict {
    NSString *urlStr = [dict stringValueForKey:@"userface"];
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    _title.text = [dict stringValueForKey:@"username"];
    _time.text = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    _content.text = [dict stringValueForKey:@"review_description"];
    NSString *starStr = [NSString stringWithFormat:@"10%@@2x",[dict stringValueForKey:@"star"]];
    [_starButton setBackgroundImage:Image(starStr) forState:UIControlStateNormal];
    [self setIntroductionText:[dict stringValueForKey:@"review_description"]];
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
