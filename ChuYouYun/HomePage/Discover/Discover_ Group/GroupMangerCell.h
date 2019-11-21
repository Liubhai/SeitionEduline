//
//  GroupMangerCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMangerCell : UITableViewCell

@property (strong ,nonatomic)UIButton *headerButton;
@property (strong ,nonatomic)UILabel *name;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;
@end
