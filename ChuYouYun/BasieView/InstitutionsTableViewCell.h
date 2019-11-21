//
//  InstitutionsTableViewCell.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/10/22.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstitutionsTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *faceImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIView *lineView;

- (void)setInstitutionInfo:(NSDictionary *)institutionInfo;

@end
