//
//  GLTeaTableViewCell.h
//  dafengche
//
//  Created by IOS on 17/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLTeaTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *img;
@property (strong, nonatomic)  UILabel *nameLab;
@property (strong, nonatomic)  UILabel *JGLab;

@property (strong, nonatomic)  UILabel *tagLab1;
@property (strong, nonatomic)  UILabel *tagLab2;
@property (strong, nonatomic)  UILabel *tagLab3;
@property (strong, nonatomic)  UILabel *tagLab4;
@property (strong, nonatomic)  UILabel *contentLab;

@property (strong, nonatomic)  UILabel *countLab;
@property (strong, nonatomic)  UILabel *areaLab;

@property (strong ,nonatomic)  UIButton *lineButton;

@property (strong ,nonatomic)  UIView  *instView;
@property (strong ,nonatomic)  UILabel *instLabel;

@property (strong ,nonatomic)  UIView  *boundaryView;
@property (strong ,nonatomic)  UIButton *arrowsButton;
@property (strong ,nonatomic)  UIButton *instButton;
@property (strong ,nonatomic) void (^cellDict)(NSDictionary *cellDict,UIGestureRecognizer *tap);

- (void)dataWithDict:(NSDictionary *)dict;

@end
