//
//  HomeLiveTableViewCell.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/10.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeLiveTableViewCell : UITableViewCell

/** 正在直播的动画 */
@property (strong, nonatomic) UIImageView *livingImageView;
/** 正在直播的文字 */
@property (strong, nonatomic) UILabel *liveStatusLabel;
/** 精确到某一天日期 */
@property (strong, nonatomic) UILabel *dayTimeLabel;
/** 精确到时分的日期 */
@property (strong, nonatomic) UILabel *secondTimeLabel;
/** 灰色小圆点 */
@property (strong, nonatomic) UIImageView *circleGrayIcon;
/** 灰色线条 */
@property (strong, nonatomic) UILabel *grayLineLabel;
/** 封面图 */
@property (strong, nonatomic) UIImageView *faceImageView;
/** 标题 */
@property (strong, nonatomic) UILabel *titleLabel;
/** 价格 */
@property (strong, nonatomic) UILabel *priceLabel;
/** 预约人数(报名人数) */
@property (strong, nonatomic) UILabel *countLabel;

- (void)setLiveInfo:(NSDictionary *)dict order_switch:(NSString *)order_switch liveTime:(NSString *)liveTime;

@end
