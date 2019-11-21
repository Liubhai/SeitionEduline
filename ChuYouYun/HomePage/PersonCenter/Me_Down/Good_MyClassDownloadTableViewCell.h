//
//  Good_MyClassDownloadTableViewCell.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/2.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_MyClassDownloadTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *palyImage;
@property (strong ,nonatomic)UILabel     *title;
@property (strong ,nonatomic)UILabel     *time;
@property (strong ,nonatomic)UIButton     *isLookButton;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWithDict:(NSDictionary *)dict;
- (void)dataSourceWithDict:(NSDictionary *)dict withType:(NSString *)type;

@end
