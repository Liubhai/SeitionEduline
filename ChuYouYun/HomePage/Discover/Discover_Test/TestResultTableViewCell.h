//
//  TestResultTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/10/16.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestResultTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *Number;
@property (strong ,nonatomic)UIImageView *headerImageView;
@property (strong ,nonatomic)UILabel *name;
@property (strong ,nonatomic)UILabel *time;
@property (strong ,nonatomic)UILabel *sorce;



-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict WithNumber:(NSInteger)number;

@end
