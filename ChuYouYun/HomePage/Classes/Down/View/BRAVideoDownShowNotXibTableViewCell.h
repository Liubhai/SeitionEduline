//
//  BRAVideoDownShowNotXibTableViewCell.h
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRAVideoDownShowNotXibTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nNameLabel;
@property (nonatomic, strong) UILabel *mStatusLabel;
@property (nonatomic,copy) void(^br_selectedBlock)(BRAVideoDownShowNotXibTableViewCell *cell);

- (void)br_updateProgress:(float)progress;
@end

NS_ASSUME_NONNULL_END
