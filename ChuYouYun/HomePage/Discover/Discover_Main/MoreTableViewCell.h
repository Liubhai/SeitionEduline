//
//  MoreTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 15/12/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *SYGButton;

@property (strong ,nonatomic)UILabel *SYGLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
