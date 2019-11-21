//
//  SchedulingCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//  排课的样式

#import <UIKit/UIKit.h>

@interface SchedulingCell : UITableViewCell

@property (strong, nonatomic)UILabel *myClass;
@property (strong, nonatomic)UILabel *myTeacher;
@property (strong, nonatomic)UILabel *date;
@property (strong, nonatomic)UILabel *number;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;

@end
