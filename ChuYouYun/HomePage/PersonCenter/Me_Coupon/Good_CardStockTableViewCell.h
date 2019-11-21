//
//  Good_CardStockTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/11/2.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_CardStockTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *titleLabel;
@property (strong ,nonatomic)UILabel *type;
@property (strong ,nonatomic)UIButton *useButton;
@property (strong ,nonatomic)UILabel  *useLabel;
@property (strong ,nonatomic)UILabel  *use;
@property (strong ,nonatomic)UILabel  *insetLabel;
@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UIImageView *segmentationImageView;

@property (strong ,nonatomic)UIButton *seleButton;
@property (strong ,nonatomic)UIButton *lineButton;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)typeStr;

@end
