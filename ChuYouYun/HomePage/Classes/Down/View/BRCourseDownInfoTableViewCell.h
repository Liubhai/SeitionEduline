//
//  BRCourseDownInfoTableViewCell.h
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRCourseDownInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCourseLabel;
@property (weak, nonatomic) IBOutlet UILabel *hadDownLabel;

@end

NS_ASSUME_NONNULL_END
