//
//  Good_HonorListTableViewCell.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/29.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_HonorListTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView   *listNumberImageView;
@property (strong ,nonatomic)UIImageView   *userImageView;
@property (strong ,nonatomic)UILabel       *userName;
@property (strong ,nonatomic)UILabel       *userInfo;
@property (strong ,nonatomic)UILabel       *quesNumber;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;

@end
