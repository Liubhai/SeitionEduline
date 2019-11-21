//
//  TopicXXTableViewCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicXXTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *title;
@property (strong ,nonatomic)UILabel *content;
@property (strong ,nonatomic)UIButton *setButton;
@property (strong ,nonatomic)UILabel *name;
@property (strong ,nonatomic)UILabel *time;
@property (strong ,nonatomic)UILabel *comtent;
@property (strong ,nonatomic)UILabel *look;

@property (strong ,nonatomic)UIView *photoView;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UIView *backView;

@property (strong ,nonatomic)UIButton *GKButton;
@property (strong ,nonatomic)UILabel *GKLabel;
@property (strong ,nonatomic)UIButton *PLButton;
@property (strong ,nonatomic)UILabel *PLLabel;

@property (strong ,nonatomic)NSDictionary *dict;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
//给用户介绍赋值并且实现自动换行
//-(void)setIntroductionText:(NSString*)text;
- (void)imageWithArray:(NSArray *)array;
- (void)dataSourceWith:(NSDictionary *)dic;
- (void)cellWithOutImage;

@end
