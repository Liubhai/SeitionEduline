//
//  TestChooseTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/11/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestChooseTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *questionStem;
@property (strong ,nonatomic)UIImageView *headerImageView;
@property (strong ,nonatomic)UIView      *photoView;
@property (strong ,nonatomic)UIButton *optionButton;

@property (strong ,nonatomic)NSString *currentUrl;





-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setIntroductionText:(NSString*)text;
- (void)dataWithTitle:(NSString *)title WithNumber:(NSInteger)number;
- (void)cellChangeWithType:(NSInteger)whichSubject WithArray:(NSArray *)array WithNumber:(NSInteger)indexPathRow;
- (void)cellChangeWithType:(NSInteger)whichSubject WithArray:(NSArray *)array WithNumber:(NSInteger)indexPathRow WithType:(NSString *)examType;

@end
