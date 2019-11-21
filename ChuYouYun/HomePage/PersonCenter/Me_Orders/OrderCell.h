//
//  OrderCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/12/5.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *schoolImage;
@property (strong ,nonatomic)UILabel *schoolName;
@property (strong ,nonatomic)UIButton *schoolButton;
@property (strong ,nonatomic)UILabel *status;
@property (strong ,nonatomic)UIImageView *headerImage;
@property (strong ,nonatomic)UILabel *name;
@property (strong ,nonatomic)UILabel *content;
@property (strong ,nonatomic)UILabel *price;
@property (strong ,nonatomic)UILabel *realPrice;
@property (strong ,nonatomic)UIButton *cancelButton;
@property (strong ,nonatomic)UIButton *actionButton;

@property (strong ,nonatomic)UIButton *rightButton;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)type;

@end
