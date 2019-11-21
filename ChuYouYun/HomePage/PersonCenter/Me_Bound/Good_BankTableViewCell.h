//
//  Good_BankTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/11/13.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_BankTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *bankImageView;
@property (strong ,nonatomic)UILabel *bankName;
@property (strong ,nonatomic)UILabel *bankType;
@property (strong ,nonatomic)UILabel *bankNumber;
@property (strong ,nonatomic)UIButton *cancelButton;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict;

@end
