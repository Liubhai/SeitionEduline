//
//  Good_ClassCommentTableViewCell.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/11.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_ClassCommentTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *headerImage;
@property (strong ,nonatomic)UILabel     *title;
@property (strong ,nonatomic)UILabel     *time;
@property (strong ,nonatomic)UILabel     *content;
@property (strong ,nonatomic)UIButton    *starButton;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWithDict:(NSDictionary *)dict;


@end
