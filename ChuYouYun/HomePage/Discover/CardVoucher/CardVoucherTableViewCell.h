//
//  CardVoucherTableViewCell.h
//  YunKeTang
//
//  Created by IOS on 2019/3/5.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardVoucherTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView   *backImageView;
@property (strong ,nonatomic)UIImageView   *receiveImageView;
@property (strong ,nonatomic)UILabel       *price;
@property (strong ,nonatomic)UILabel       *discountStaus;
@property (strong ,nonatomic)UILabel       *discountConditions;
@property (strong ,nonatomic)UILabel       *discountUse;
@property (strong ,nonatomic)UILabel       *time;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;

@end
