//
//  MYWDTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/18.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYWDTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UILabel *personLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;

@end
