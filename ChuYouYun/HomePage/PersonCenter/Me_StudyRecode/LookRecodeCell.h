//
//  LookRecodeCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/12/5.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookRecodeCell : UITableViewCell

@property (strong ,nonatomic)UILabel *timeLabel;
@property (strong ,nonatomic)UILabel *nameLabel;
@property (strong ,nonatomic)UILabel *titleLabel;
@property (strong ,nonatomic)UIButton *seleButton;
@property (strong ,nonatomic)UIButton *lineButton;



-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict;

@end
