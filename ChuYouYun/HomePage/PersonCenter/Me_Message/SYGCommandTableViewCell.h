//
//  SYGCommandTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/15.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGCommandTableViewCell : UITableViewCell



@property (strong, nonatomic) UIButton *myHeadImage;

@property (strong ,nonatomic)UILabel *myName;

@property (strong ,nonatomic)UIButton *SCButton;

@property (strong ,nonatomic)UILabel *dayLabel;

@property (strong ,nonatomic)UILabel *JTLabel;

@property (strong ,nonatomic)UIView *otherView;

@property (strong ,nonatomic)UIButton *otherImage;

@property (strong ,nonatomic)UILabel *HFLabel;

@property (strong ,nonatomic)UILabel *GDLabel;

@property (strong ,nonatomic)UILabel *PLNameLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;
-(void)setIntroductionOtherText:(NSString*)text;
-(void)setIntroductionTextName:(NSString*)text;

@end
