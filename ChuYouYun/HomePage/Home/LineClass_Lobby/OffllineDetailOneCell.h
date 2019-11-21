//
//  OffllineDetailOneCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/7.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffllineDetailOneCell : UITableViewCell

@property (strong ,nonatomic)UILabel      *title;
@property (strong ,nonatomic)UILabel      *teacher;
@property (strong ,nonatomic)UILabel      *person;
@property (strong ,nonatomic)UILabel      *price;
@property (strong ,nonatomic)UILabel      *time;
@property (strong ,nonatomic)UILabel      *discounts;
@property (strong ,nonatomic)UILabel      *adress;

//@property (strong ,nonatomic)UIButton     *onlineButton;//在线咨询
//@property (strong ,nonatomic)UIButton     *orderButton;//预约课程

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;

@end
