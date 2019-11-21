//
//  GZTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/25.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#import "GZTableViewCell.h"
#import "SYG.h"

@implementation GZTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _HeadImageButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    _HeadImageButton.layer.cornerRadius = 30;
    _HeadImageButton.layer.masksToBounds = YES;
    [self addSubview:_HeadImageButton];
    
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, MainScreenWidth - 110, 20)];
    _NameLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_NameLabel];
    
    _TextLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, MainScreenWidth - 130, 15)];
    _TextLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_TextLabel];
    
    
    _fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 55, MainScreenWidth - 110, 15)];
    _fansLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_fansLabel];
    
    _GZButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 15, 50, 30)];
    [self addSubview:_GZButton];
    
}


-(void)setAttentionType:(NSInteger)follower following:(NSInteger)following isSelf:(BOOL)isSelf
{
    if (isSelf == YES) {
        if (follower == 1&&following ==1) {
            [self.GZButton setBackgroundImage:[UIImage imageNamed:@"相互关注@2x"] forState:0];
        }if (follower == 1&&following ==0) {
            [self.GZButton setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:0];
        }if (follower == 0&&following ==0) {
            [self.GZButton setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:0];
        }
    } else {
        if (follower == 1&&following ==1) {
            [self.GZButton setBackgroundImage:[UIImage imageNamed:@"相互关注@2x"] forState:0];
        }if (follower == 1&&following ==0) {
            [self.GZButton setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:0];
        }if (follower == 0&&following ==0) {
            [self.GZButton setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:0];
        }
        
    }
    
}






@end
