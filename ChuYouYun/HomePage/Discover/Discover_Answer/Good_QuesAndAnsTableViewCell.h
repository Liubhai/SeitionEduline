//
//  Good_QuesAndAnsTableViewCell.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/16.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_QuesAndAnsTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *HeadImage;

@property (strong ,nonatomic)UILabel *NameLabel;

@property (strong ,nonatomic)UILabel *TimeLabel;

@property (strong ,nonatomic)UILabel *JTLabel;

@property (strong ,nonatomic)UIView *TPView;

@property (strong ,nonatomic)UILabel *PLLabel;

@property (strong ,nonatomic)UILabel *GKLabel;

@property (strong ,nonatomic)UIView *backView;

@property (strong ,nonatomic)UIButton *GKButton;

@property (strong ,nonatomic)UIButton *PLButton;

@property (strong ,nonatomic)UIView *footView;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;
- (void)dataWithDict:(NSDictionary *)dict;
- (void)imageWithArray:(NSArray *)array;

@end
