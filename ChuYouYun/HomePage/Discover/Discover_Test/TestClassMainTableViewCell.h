//
//  TestClassMainTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/25.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestClassMainTableViewCell;
@protocol TestClassMainTableViewCellDelegate <NSObject>

- (void)doButtonClick:(TestClassMainTableViewCell *)cell cellInfo:(NSDictionary *)cellDict;

@end

@interface TestClassMainTableViewCell : UITableViewCell

@property (assign, nonatomic) id<TestClassMainTableViewCellDelegate> delegate;

@property (strong, nonatomic) UILabel *typeLabel;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *personIcon;
@property (strong ,nonatomic)UILabel *personLabel;

@property (strong, nonatomic) UIImageView *subjectIcon;
@property (strong ,nonatomic)UILabel *subjectLabel;

@property (strong, nonatomic) UIImageView *doBackImage;
@property (strong, nonatomic) UIButton *doButton;
@property (strong, nonatomic) NSDictionary *classInfo;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)dataSourceWith:(NSDictionary *)dict;

@end
