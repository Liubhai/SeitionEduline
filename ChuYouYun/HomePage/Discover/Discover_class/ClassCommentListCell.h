//
//  ClassCommentListCell.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCommentListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, strong) UILabel *contentlabel;
@property (nonatomic, strong) UILabel *lineView;

@property (nonatomic, strong) UIImageView *scanImageView;
@property (nonatomic, strong) UILabel *scanCountlabel;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UILabel *commentCountlabel;
@property (nonatomic, strong) UILabel *grayLinelabel;

- (void)setCommentInfo:(NSDictionary *)dict;

@end
