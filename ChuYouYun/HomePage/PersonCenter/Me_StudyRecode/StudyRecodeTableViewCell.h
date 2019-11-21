//
//  StudyRecodeTableViewCell.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/12.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StudyRecodeTableViewCellDelegate <NSObject>

- (void)editingButtonClick:(UIButton *)sender;

@end

@interface StudyRecodeTableViewCell : UITableViewCell

@property (assign, nonatomic) id<StudyRecodeTableViewCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *courseLabel;
@property (strong, nonatomic) UIImageView *timeIcon;
@property (strong, nonatomic) UILabel *studyTimeLabel;
@property (strong, nonatomic) UIButton *editingButton;

- (void)setStudyRecodeInfo:(NSDictionary *)studyInfo editing:(BOOL)editing selected:(BOOL)selected;

@end
