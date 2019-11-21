//
//  Good_UseTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/12/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_UseTableViewCell : UITableViewCell


@property (strong ,nonatomic)UIImageView  *typeImageView;
@property (strong ,nonatomic)UILabel *type;
@property (strong ,nonatomic)UILabel *number;


@property (strong ,nonatomic)UILabel  *useLabel;
@property (strong ,nonatomic)UILabel  *use;
@property (strong ,nonatomic)UILabel  *insetLabel;
@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UIImageView *segmentationImageView;

@property (strong ,nonatomic)UIButton *seleButton;
@property (strong ,nonatomic)UIButton *lineButton;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict;

@end
