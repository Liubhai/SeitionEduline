//
//  MoreTableViewCell.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/12/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _SYGButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    [self addSubview:_SYGButton];
    
    _SYGLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 30)];
    [self addSubview:_SYGLabel];
    
}


@end
