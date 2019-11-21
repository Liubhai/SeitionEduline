//
//  TestGapTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/11/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestGapTableViewCell : UITableViewCell

@property (strong ,nonatomic)UITextField *answerTextField;
@property (strong ,nonatomic)UILabel     *numberLabel;
@property (strong ,nonatomic)UIView      *answerView;
@property (assign ,nonatomic)NSInteger   indexPath;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithArray:(NSArray *)array WithNumber:(NSInteger)indexPath;

@end
