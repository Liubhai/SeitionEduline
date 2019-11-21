//
//  MyLineDownClassTableViewCell.h
//  YunKeTang
//
//  Created by IOS on 2019/3/1.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLineDownClassTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *photoView;
@property (strong ,nonatomic)UILabel     *lineClass;
@property (strong ,nonatomic)UILabel     *teacher;
@property (strong ,nonatomic)UILabel     *price;
@property (strong ,nonatomic)UIImageView *mapIcon;
@property (strong ,nonatomic)UILabel     *adress;
@property (strong ,nonatomic)UILabel     *tel;
@property (strong ,nonatomic)UILabel     *orderStaus;
@property (strong ,nonatomic)UILabel     *orderTime;
@property (strong, nonatomic) UILabel *sexLabel;

@property (strong ,nonatomic)UIButton    *rightButton;
@property (strong ,nonatomic)UIButton    *completeButton;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)typeStr;
- (void)dataSourceWithTeacher:(NSDictionary *)dict WithType:(NSString *)typeStr;

@end
