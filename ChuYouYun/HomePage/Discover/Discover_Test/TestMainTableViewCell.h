//
//  TestMainTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/25.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestMainTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *headImageView;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UILabel *contentLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UILabel *sizeLabel;

@property (strong ,nonatomic)UILabel *typeLabel;

@property (strong ,nonatomic)UILabel *downLabel;

@property (strong ,nonatomic)UIButton *downButton;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)dataSourceWith:(NSDictionary *)dict;

@end
