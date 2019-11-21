//
//  ClassCourseListCell.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCourseListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *courseTimeLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UIView *lineView;

- (void)setCourseInfo:(NSDictionary *)dict;

@end

