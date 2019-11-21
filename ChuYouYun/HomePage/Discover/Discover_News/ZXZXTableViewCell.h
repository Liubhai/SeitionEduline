//
//  ZXZXTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXZXTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *imageButton;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UILabel *readLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UILabel *JTLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
