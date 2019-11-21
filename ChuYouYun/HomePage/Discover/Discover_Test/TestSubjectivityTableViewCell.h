//
//  TestSubjectivityTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/11/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestSubjectivityTableViewCell : UITableViewCell

@property (strong ,nonatomic)UITextView *answerTextView;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
