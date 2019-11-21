//
//  Good_ManagementCardTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/11/13.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_ManagementCardTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *bankName;
@property (strong ,nonatomic)UIButton *cancelButton;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict;

@end
