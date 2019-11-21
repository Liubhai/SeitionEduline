//
//  HomeSearchCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/31.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "HomeSearchCell.h"
#import "SYG.h"


@implementation HomeSearchCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{

    
    //内容
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside * 1.5, SpaceBaside , MainScreenWidth - 40, 30)];
    [self addSubview:_contentLabel];
    _contentLabel.numberOfLines = 2;
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = Font(15);
 
}


- (void)dataSourceWith:(NSDictionary *)dict {
    
//    NSURL *url = [NSURL URLWithString:dict[@"attach"]];
//    [_headImageView sd_setImageWithURL:url placeholderImage:Image(@"站位图")];
//    
//    _titleLabel.text = dict[@"title"];

    
}


@end
