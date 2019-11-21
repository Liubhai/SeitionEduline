//
//  Good_integParticularsTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/10/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_integParticularsTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *name;
@property (strong ,nonatomic)UILabel *time;
@property (strong ,nonatomic)UILabel *money;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)type;

@end
