//
//  OfflineMainTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineMainTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView  *imagePhotoView;
@property (strong ,nonatomic)UILabel      *title;
@property (strong ,nonatomic)UILabel      *price;
@property (strong ,nonatomic)UILabel      *time;
@property (strong ,nonatomic)UILabel      *adress;

@property (strong ,nonatomic)UIButton     *onlineButton;//在线咨询
@property (strong ,nonatomic)UIButton     *orderButton;//预约课程

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;

@end
