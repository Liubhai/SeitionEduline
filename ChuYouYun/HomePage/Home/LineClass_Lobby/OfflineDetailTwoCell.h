//
//  OfflineDetailTwoCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/8.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineDetailTwoCell : UITableViewCell

@property (strong ,nonatomic)UILabel      *title;
@property (strong ,nonatomic)UILabel      *detail;

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)UIView       *commentView;

@property (strong ,nonatomic)UIButton     *detailButton;//课程详情
@property (strong ,nonatomic)UIButton     *commentButton;//预约评价

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;
- (void)dataWithArray:(NSArray *)array;
- (void)dataWithAgain:(CGFloat)cellHight;

@end
