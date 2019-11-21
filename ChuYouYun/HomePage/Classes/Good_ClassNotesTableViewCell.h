//
//  Good_ClassNotesTableViewCell.h
//  YunKeTang
//
//  Created by IOS on 2019/3/19.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_ClassNotesTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *headerImage;
@property (strong ,nonatomic)UILabel     *name;
@property (strong ,nonatomic)UILabel     *title;
@property (strong ,nonatomic)UILabel     *time;
@property (strong ,nonatomic)UILabel     *content;
@property (strong ,nonatomic)UIButton    *praiseButton;
@property (strong ,nonatomic)UIButton    *commentsButton;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWithDict:(NSDictionary *)dict WithType:(NSString *)type;

@end
