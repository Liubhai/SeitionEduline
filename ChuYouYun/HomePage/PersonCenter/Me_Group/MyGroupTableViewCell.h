//
//  MyGroupTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/8/9.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGroupTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *groupImageView;
@property (strong ,nonatomic)UILabel *groupName;
@property (strong ,nonatomic)UILabel *numberRefresh;
@property (strong ,nonatomic)UILabel *allNumberPerson;
@property (strong ,nonatomic)UILabel *allPostNumber;
@property (strong ,nonatomic)UIButton *actionButton;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)type;

@end
