//
//  EJTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/29.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EJTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *HeadImageButton;

@property (strong ,nonatomic)UILabel *nameLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UILabel *JTLabel;

@property (strong ,nonatomic)UIView *backView;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;

@end
