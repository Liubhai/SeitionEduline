//
//  ShopDetailCommentTableViewCell.h
//  YunKeTang
//
//  Created by IOS on 2019/3/6.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailCommentTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView   *photoImageView;
@property (strong ,nonatomic)UILabel       *userName;
@property (strong ,nonatomic)UILabel       *time;
@property (strong ,nonatomic)UILabel       *comment;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;
- (void)dataWithDict:(NSDictionary *)dict;

@end
