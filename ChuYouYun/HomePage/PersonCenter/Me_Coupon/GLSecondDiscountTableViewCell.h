//
//  GLSecondDiscountTableViewCell.h
//  dafengche
//
//  Created by IOS on 16/9/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UserBtnCliketBlock)(void);


@interface GLSecondDiscountTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *xiamianImg;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *backLab;
@property (weak, nonatomic) IBOutlet UILabel *HeaderTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *cateGarryLab;
@property (weak, nonatomic) IBOutlet UILabel *LimitTimelab;
@property (weak, nonatomic) IBOutlet UILabel *FirstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UIButton *UseBtn;
/** 使用优惠券按钮点击回调block */
@property (nonatomic, copy) UserBtnCliketBlock  btnClickBlock;

@end
