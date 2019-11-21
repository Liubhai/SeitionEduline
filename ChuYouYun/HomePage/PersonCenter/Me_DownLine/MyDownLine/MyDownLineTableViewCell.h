//
//  MyDownLineTableViewCell.h
//  YunKeTang
//
//  Created by IOS on 2018/11/16.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDownLineTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *HeadImageButton;

@property (strong ,nonatomic)UILabel *nameLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UILabel *JTLabel;

@property (strong ,nonatomic)UILabel *attachedLabel;

@property (strong ,nonatomic)UILabel *recommendedLabel;

@property (strong ,nonatomic)UILabel *personLabel;

@property (strong ,nonatomic)UIView *backView;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;
- (void)cellWithDict:(NSDictionary *)dict WithIndexPath:(NSInteger)index;

@end
