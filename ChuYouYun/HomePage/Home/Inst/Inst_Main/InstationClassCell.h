//
//  InstationClassCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstationClassCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *headerImageView;

@property (strong ,nonatomic)UILabel *nameLabel;

@property (strong ,nonatomic)UILabel *typeLabel;

@property (strong ,nonatomic)UILabel *contentLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UILabel *onLine;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
