//
//  GrouListCell.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/23.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrouListCellDelegate <NSObject>

- (void)joinGroupByGroupId:(NSString *)groupID groupInfo:(NSDictionary *)groupInfo;

@end

@interface GrouListCell : UITableViewCell {
//    NSTimer *cellTimer;
//    NSInteger timeSpan;
}

@property (assign, nonatomic) id<GrouListCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *groupFace;
@property (strong, nonatomic) UILabel *groupTitle;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *timeCountDownLabel;
@property (strong, nonatomic) UIButton *groupJoinButton;
@property (strong, nonatomic) NSDictionary *groupInfo;


- (void)setGroupListInfo:(NSDictionary *)dict timeCount:(NSInteger)timeCount;

@end
