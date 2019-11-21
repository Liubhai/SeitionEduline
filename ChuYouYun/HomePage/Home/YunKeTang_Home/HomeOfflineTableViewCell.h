//
//  HomeOfflineTableViewCell.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/11.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeOfflineTableViewCell : UITableViewCell

/** 封面图 */
@property (strong, nonatomic) UIImageView *faceImageView;
/** 标题 */
@property (strong, nonatomic) UILabel *titleLabel;
/** 价格 */
@property (strong, nonatomic) UILabel *priceLabel;
/** 预约人数(报名人数) */
@property (strong, nonatomic) UILabel *countLabel;

- (void)setOfflineInfo:(NSDictionary *)dict order_switch:(NSString *)order_switch;

@end
