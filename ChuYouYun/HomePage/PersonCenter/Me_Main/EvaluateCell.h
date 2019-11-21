//
//  EvaluateCell.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/11/21.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EvaluateCell : UITableViewCell

@property (strong, nonatomic) UIImageView *starImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *fromLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *commentCountLabel;
@property (strong, nonatomic) UIImageView *commentCountImage;
@property (strong, nonatomic) UIView *lineView;

- (void)setEvaluateListCellInfo:(NSDictionary *)questionInfo typeString:(NSString *)typeString;

@end

NS_ASSUME_NONNULL_END
