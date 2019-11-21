//
//  ZhiBoClassCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhiBoClassCell : UITableViewCell

@property (strong ,nonatomic)UILabel *title;
@property (strong ,nonatomic)UIButton *numberButton;
@property (strong ,nonatomic)UILabel *type;
@property (strong ,nonatomic)UILabel *priceLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;
- (void)dataWithDict:(NSDictionary *)dict WithLiveInfo:(NSDictionary *)liveInfo;

@end
