//
//  SYGBJTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/4.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGBJTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *BTLabel;

@property (strong ,nonatomic)UILabel *SJLabel;

@property (strong ,nonatomic)UILabel *JTLabel;

@property (strong ,nonatomic)UIButton *PLButton;

@property (strong ,nonatomic)UIButton *DZButton;

@property (strong ,nonatomic)UILabel *PLLabel;

@property (strong ,nonatomic)UILabel *DZLabel;

@property (strong ,nonatomic)UIView *ALLView;

@property (strong ,nonatomic)UILabel *HLabel;

@property (strong ,nonatomic)UIView *GZView;

@property (strong ,nonatomic)UILabel *LZLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;

- (void)changeUI;

@end
