//
//  TKMessageTableViewCell.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *iMessageLabel;
@property (nonatomic, strong) NSString *iMessageText;
@property (nonatomic, strong) UIImageView *backgroudImageView;
@property (nonatomic, strong) UIView *bubbleView;
- (void)resetView;
- (void)setupView;
+ (CGFloat)heightFromText:(NSString *)text withLimitWidth:(CGFloat)width;
+ (CGSize)sizeFromText:(NSString *)text withLimitHeight:(CGFloat)height Font:(UIFont*)aFont;
+ (CGSize)sizeFromText:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;
+ (CGSize)sizeFromAttributedString:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;
@end
