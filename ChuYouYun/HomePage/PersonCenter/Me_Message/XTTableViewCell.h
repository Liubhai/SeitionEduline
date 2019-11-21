//
//  XTTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/13.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UIButton *TXButton;

@property (strong ,nonatomic)UIView   *backView;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;
- (void)dataWithDict:(NSDictionary *)dict;

@end
