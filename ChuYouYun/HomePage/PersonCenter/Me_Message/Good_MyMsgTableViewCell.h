//
//  Good_MyMsgTableViewCell.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_MyMsgTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView   *headerImageView;
@property (strong ,nonatomic)UILabel       *name;
@property (strong ,nonatomic)UILabel       *time;
@property (strong ,nonatomic)UILabel       *content;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;
- (void)dataWithDict:(NSDictionary *)dict;

@end
