//
//  GroupDetailTableViewCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosView.h"


@interface GroupDetailTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *HeadImage;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UILabel *contentLabel;

@property (strong ,nonatomic)UILabel *NameLabel;

@property (strong ,nonatomic)UILabel *TimeLabel;

@property (strong ,nonatomic)UILabel *JTLabel;

@property (strong ,nonatomic)UIView *TPView;

@property (strong ,nonatomic)UILabel *PLLabel;

@property (strong ,nonatomic)UILabel *GKLabel;

@property (strong ,nonatomic)UIView *backView;

@property (strong ,nonatomic)UIButton *GKButton;

@property (strong ,nonatomic)UIButton *PLButton;

@property (strong ,nonatomic)UIButton *setButton;

@property (strong ,nonatomic)PhotosView *photosView;

@property (strong ,nonatomic)UIView *downView;



-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;

- (void)imageWithArray:(NSArray *)array;

@end
