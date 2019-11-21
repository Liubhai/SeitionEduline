//
//  GroupMangerCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GroupMangerCell.h"
#import "SYG.h"
#import "UIButton+WebCache.h"


@implementation GroupMangerCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot {
    

    _headerButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 60, 60)];
    [self addSubview:_headerButton];
    _headerButton.layer.cornerRadius = 30;
    _headerButton.layer.masksToBounds = YES;
    
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerButton.frame) + SpaceBaside, SpaceBaside,MainScreenWidth - CGRectGetMaxX(_headerButton.frame) + SpaceBaside, 20)];
    [self addSubview:_name];
 
}

- (void)dataWithDict:(NSDictionary *)dict {
    
    NSString *urlStr = [dict stringValueForKey:@"avatar_small"];
    [_headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal];
    _name.text = [dict stringValueForKey:@"name"];
    
}


@end
