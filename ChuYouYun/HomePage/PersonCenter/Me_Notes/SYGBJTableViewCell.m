//
//  SYGBJTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/4.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SYGBJTableViewCell.h"
#import "SYG.h"

@implementation SYGBJTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    self.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1];
    
    
    //添加全体View
    _ALLView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _ALLView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_ALLView];
    
    //标题
    _BTLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth, 20)];
    _BTLabel.font = [UIFont systemFontOfSize:17];
    [_ALLView addSubview:_BTLabel];
    
    //来自哪里
    _LZLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, MainScreenWidth - 100, 20)];
    _LZLabel.font = [UIFont systemFontOfSize:12];
    _LZLabel.textColor = [UIColor colorWithRed:147.f / 255 green:147.f / 255 blue:147.f / 255 alpha:1];
    [_ALLView addSubview:_LZLabel];
    _LZLabel.hidden = YES;
    
    //具体
    _JTLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, MainScreenWidth, 50)];
    _JTLabel.font = [UIFont systemFontOfSize:15];
    _JTLabel.textColor = [UIColor colorWithRed:92.f / 255 green:92.f / 255 blue:92.f / 255 alpha:1];
    [_ALLView addSubview:_JTLabel];
    
    
    //添加view
    _GZView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, MainScreenWidth, 35)];
    _GZView.backgroundColor = [UIColor whiteColor];
    [_ALLView addSubview:_GZView];
    
    //添加分割线
    UILabel *FGLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    FGLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_GZView addSubview:FGLabel];
    
    //时间
    _SJLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 100 - 10, 34)];
    _SJLabel.font = [UIFont systemFontOfSize:12];
    _SJLabel.textColor = [UIColor colorWithRed:147.f / 255 green:147.f / 255 blue:147.f / 255 alpha:1];
    _SJLabel.textAlignment = NSTextAlignmentRight;
    _SJLabel.frame = CGRectMake(10, 1, MainScreenWidth - 20, 34);
    _SJLabel.textAlignment = NSTextAlignmentLeft;
    [_GZView addSubview:_SJLabel];
    
    //添加中间分割线
//    UILabel *ZJLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 0.5, 4, 1, 30)];
//    ZJLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    ZJLabel.hidden = YES;
//    [_GZView addSubview:ZJLabel];
    
//    //添加底分割线
//    UILabel *DBLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, MainScreenWidth, 1)];
//    DBLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [_GZView addSubview:DBLabel];

    
    //添加评论按钮
    _PLButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 4 - 20, 8, 20, 20)];
    [_PLButton setBackgroundImage:[UIImage imageNamed:@"笔记评论@2x"] forState:UIControlStateNormal];
    [_GZView addSubview:_PLButton];
    
    //添加评论人数
    _PLLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 4 + 5, 8, MainScreenWidth / 4 - 5, 20)];
    _PLLabel.textColor = [UIColor colorWithRed:99.f / 255 green:99.f / 255 blue:99.f / 255 alpha:1];
    [_GZView addSubview:_PLLabel];
    
    //添加点赞按钮
    _DZButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 4 * 3 - 20, 8, 20, 20)];
    [_DZButton setBackgroundImage:[UIImage imageNamed:@"笔记点赞@2x"] forState:UIControlStateNormal];
    [_GZView addSubview:_DZButton];
    
    //添加点赞人数
    _DZLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 4 * 3 + 5, 8, MainScreenWidth / 4 - 5, 20)];
    _DZLabel.textColor = [UIColor colorWithRed:99.f / 255 green:99.f / 255 blue:99.f / 255 alpha:1];
    [_GZView addSubview:_DZLabel];

    
}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.JTLabel.text = text;
    //设置label的最大行数
    self.JTLabel.numberOfLines = 2;
    CGSize size = CGSizeMake(MainScreenWidth - 20, 1000);
    
    CGSize labelSize = [self.JTLabel.text sizeWithFont:self.JTLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    self.JTLabel.frame = CGRectMake(self.JTLabel.frame.origin.x, self.JTLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    NSLog(@"-----%lf",labelSize.height);
    
    //这个判断 解决了cell点击的时候会出现横线
    if (labelSize.height > 50) {
        frame.size.height = labelSize.height + 40 + 55 + 10 + 10 - 5 - 5 - 1;
    } else if (labelSize.height > 20 && labelSize.height < 50){
        frame.size.height = 35 + 40 + 55 + 10 + 10 - 5 - 5 - 1 - 20;
    } else {
         frame.size.height = 18 + 40 + 55 + 10 + 10 - 5 - 5 - 1 - 20;
    }
    
    //计算出自适应的高度
//    frame.size.height = labelSize.height + 40 + 55 + 10 + 10 - 5 - 5 - 1;
//    _HLabel.frame = CGRectMake(0, CGRectGetMaxY(_JTLabel.frame), MainScreenWidth, 1);
    _LZLabel.frame = CGRectMake(10, CGRectGetMaxY(_JTLabel.frame) + 5, MainScreenWidth  - 120, 20);
    _SJLabel.frame = CGRectMake(10,1 , 110, 34);
    _GZView.frame = CGRectMake(0, CGRectGetMaxY(_JTLabel.frame) + 5 + 10, MainScreenWidth, 35);
    _ALLView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_GZView.frame) + 5);
    self.frame = frame;
}

- (void)changeUI {
    CGFloat zanlableWidth = [_DZLabel.text sizeWithFont:_DZLabel.font].width + 2;
    CGFloat commentLabelWidth = [_PLLabel.text sizeWithFont:_PLLabel.font].width + 2;
    
    [_DZLabel setWidth:zanlableWidth];
    [_DZLabel setMj_x:MainScreenWidth - 10 - zanlableWidth];
    
    [_DZButton setMj_x:_DZLabel.left - _DZButton.width - 2];
    
    [_PLLabel setWidth:commentLabelWidth];
    [_PLLabel setMj_x:_DZButton.left - 5 - commentLabelWidth];
    
    [_PLButton setMj_x:_PLLabel.left - _PLButton.width - 2];
}

@end
