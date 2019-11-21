//
//  GLSecondDiscountTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/9/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLSecondDiscountTableViewCell.h"
#import "UIColor+HTMLColors.h"

@implementation GLSecondDiscountTableViewCell

- (void)awakeFromNib {
    
   [self.UseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[self.UseBtn setTitleColor:[UIColor colorWithHexString:@"#74d2d4"] forState:UIControlStateNormal];
    [self.UseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.UseBtn.layer setBorderColor:[UIColor colorWithHexString:@"#74d2d4"].CGColor];
    [self.UseBtn.layer setBorderWidth:1];
    [self.UseBtn.layer setMasksToBounds:YES];
    self.UseBtn.layer.cornerRadius = 15;
    self.cateGarryLab.textColor = [UIColor colorWithHexString:@"#277779"];
    self.LimitTimelab.textColor = [UIColor colorWithHexString:@"#277779"];
//    [self.backImageView.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
//    [self.backImageView.layer setBorderWidth:0.5];
    self.FirstLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.secondLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.backLab.backgroundColor = [UIColor colorWithHexString:@"#74d2d4"];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)UserBtnCliket:(UIButton *)sender {
    
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    sender.userInteractionEnabled = YES;
    
}

@end
