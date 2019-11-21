//
//  GroupTableViewCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupTableViewCell : UITableViewCell


@property (strong ,nonatomic)UIImageView *headImageView;

@property (strong ,nonatomic)UILabel *nameLabel;

@property (strong ,nonatomic)UILabel *contentlabel;

@property (strong ,nonatomic)UILabel *mixLabel;

@property (strong ,nonatomic)UILabel *member;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWithDict:(NSDictionary *)dict;

@end
