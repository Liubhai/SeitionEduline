//
//  LiveClassCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/12/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LiveClassCell.h"
#import "UIButton+WebCache.h"
#import "SYG.h"


@implementation LiveClassCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    int width;
    if (MainScreenWidth > 375) {
        
        width = 375;
    }else
    {
        width = MainScreenWidth;
    }
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 13, width / 5 * 2 - 10 + 2, 110 - 26)];
    _imageButton.userInteractionEnabled = NO;
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [self.contentView addSubview:_imageButton];
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 65, 20, 20)];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"mv"] forState:UIControlStateNormal];
    [self.contentView addSubview:_playButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + 13, 13, MainScreenWidth - width / 5 * 2 - 13, 14)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    
    _XJButton = [[UIButton alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, 13 + 14 + 5 - 2, 80, 12)];
    [self.contentView addSubview:_XJButton];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, 42 + 2, MainScreenWidth - width / 5 * 2 - 13 - 10, 30 + 5)];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.numberOfLines = 2;
    [self.contentView addSubview:_contentLabel];
    
//    _GKButton = [[UIButton alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, CGRectGetMaxY(_contentLabel.frame) + 4, 18,13)];
//    [_GKButton setBackgroundImage:[UIImage imageNamed:@"ViewSYG"] forState:UIControlStateNormal];
//    [self.contentView addSubview:_GKButton];
//    
//    _GKLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13 + 25 + 5, CGRectGetMaxY(_contentLabel.frame) + 2, 40, 15)];
//    _GKLabel.font = [UIFont systemFontOfSize:12];
//    [self.contentView addSubview:_GKLabel];
    
    _XBLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, CGRectGetMaxY(_contentLabel.frame) + 4, 200,15)];
    _XBLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_XBLabel];
    
    
}


- (void)dataWithDict:(NSDictionary *)dict {
    
    NSLog(@"%@",dict);
    NSString *urlStr = dict[@"imageurl"];
    [_imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    _titleLabel.text = dict[@"video_title"];
    
    NSString *starStr = [NSString stringWithFormat:@"10%@@2x",dict[@"video_score"]];
    [_XJButton setBackgroundImage:Image(starStr) forState:UIControlStateNormal];
    
    NSString *introStr = [self filterHTML:dict[@"video_intro"]];
    _contentLabel.text = introStr;
//    _GKLabel.text = dict[@"video_order_count"];
//    _XBLabel.text = dict[@""];
    
    NSString *MoneyStr = [NSString stringWithFormat:@"%@  育币",dict[@"t_price"]];
    NSString *XBStr = [NSString stringWithFormat:@"%@",dict[@"t_price"]];
    //变颜色
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:BasidColor range:NSMakeRange(0, XBStr.length)];
    //设置字体加错
    //    [needStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [needStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    
    [_XBLabel setAttributedText:needStr] ;
    
}


//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}



@end
