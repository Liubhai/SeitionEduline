//
//  Good_ThirdBoundTableViewCell.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/12/28.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Good_ThirdBoundTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *iconImageView;
@property (strong ,nonatomic)UILabel *typeName;
@property (strong ,nonatomic)UILabel *type;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
