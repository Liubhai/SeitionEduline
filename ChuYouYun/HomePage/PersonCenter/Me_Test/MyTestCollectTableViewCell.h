//
//  MyTestCollectTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/26.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTestCollectTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *name;
@property (strong ,nonatomic)UILabel *time;

@property (strong ,nonatomic)UIButton *rightButton;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)type;

@end
