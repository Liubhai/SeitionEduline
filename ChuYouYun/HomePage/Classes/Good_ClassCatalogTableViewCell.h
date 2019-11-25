//
//  Good_ClassCatalogTableViewCell.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/11.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"

@interface Good_ClassCatalogTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView      *lockImageView;
@property (strong ,nonatomic)UIImageView      *palyImage;
@property (strong ,nonatomic)UILabel          *title;
@property (strong ,nonatomic)UILabel          *time;
@property (strong ,nonatomic)UIButton         *isLookButton;
@property (strong ,nonatomic)UIButton         *downButton;
@property (strong ,nonatomic)UILabel          *size;
@property (strong ,nonatomic)UILabel          *freeLabel;
@property (strong ,nonatomic)UAProgressView   *progressView;

//课时解锁
@property (strong ,nonatomic)NSString         *buyString;
@property (strong ,nonatomic)NSDictionary     *cellDict;
@property (strong ,nonatomic)NSDictionary     *liveInfo;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWithDict:(NSDictionary *)dict withBuyString:(NSString *)buyString WithLiveInfo:(NSDictionary *)liveInfo;
- (void)dataSourceWithDict:(NSDictionary *)dict withType:(NSString *)type;
- (void)dataSourceWithDict:(NSDictionary *)dict withType:(NSString *)type withProgress:(CGFloat)progress;

@end
