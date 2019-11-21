//
//  InstationClassVideoCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/7.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstationClassVideoCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *headerImageView;//图像

@property (strong ,nonatomic)UILabel *nameLabel;//名字

@property (strong ,nonatomic)UILabel *priceLabel;

@property (strong ,nonatomic)UILabel *contentLabel;//内容

@property (strong ,nonatomic)UILabel *teacherLabel;//老师

@property (strong ,nonatomic)UILabel *applyLabel;//报名


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
