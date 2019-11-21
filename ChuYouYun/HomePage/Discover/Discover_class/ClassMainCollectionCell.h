//
//  ClassMainCollectionCell.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassMainCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UILabel *pricelabel;
@property (nonatomic, strong) UIImageView *scanIcon;
@property (nonatomic, strong) UIImageView *studyIcon;
@property (nonatomic, strong) UILabel *scanCountlabel;
@property (nonatomic, strong) UILabel *studyCountlabel;
@property (nonatomic, strong) NSIndexPath *cellIndex;

- (void)setClassMainInfo:(NSDictionary *)dict cellIndex:(NSIndexPath *)index;

@end
