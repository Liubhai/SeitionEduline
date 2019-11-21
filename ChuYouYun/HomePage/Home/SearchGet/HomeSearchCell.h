//
//  HomeSearchCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/10/31.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSearchCell : UITableViewCell

@property (strong ,nonatomic)UILabel *contentLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)dataSourceWith:(NSDictionary *)dict;

@end
