//
//  ClassRevampCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/2/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassRevampCell : UITableViewCell

@property (strong ,nonatomic)UIButton *imageButton;

@property (strong ,nonatomic)UIButton *playButton;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UIButton *audition;

@property (strong ,nonatomic)UILabel *teacherLabel;

@property (strong ,nonatomic)UILabel *studyNum;

@property (strong ,nonatomic)UILabel *kinsOf;

@property (strong ,nonatomic)UILabel *XBLabel;

@property (strong ,nonatomic)UIButton *GKButton;

@property (strong ,nonatomic)UILabel *GKLabel;

@property (strong ,nonatomic)UILabel *OrderLabel;

@property (strong ,nonatomic)UIButton *logoLiveOrClassButton;
@property (strong ,nonatomic)UIButton *isBuyButton;

@property (strong, nonatomic) UIButton *activityType;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict withType:(NSString *)type;
- (void)dataWithDict:(NSDictionary *)dict withType:(NSString *)type withOrderSwitch:(NSString *)orderSwitch;
/** 套餐 */
- (void)comboDataWithDict:(NSDictionary *)dict withType:(NSString *)type withOrderSwitch:(NSString *)orderSwitch;


@end
