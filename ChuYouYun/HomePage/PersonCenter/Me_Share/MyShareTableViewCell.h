//
//  MyShareTableViewCell.h
//  YunKeTang
//
//  Created by IOS on 2019/2/26.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyShareTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *photoView;
@property (strong ,nonatomic)UILabel     *name;
@property (strong ,nonatomic)UILabel     *urlLabel;
@property (strong ,nonatomic)UILabel     *time;

@property (strong ,nonatomic)UIButton *rightButton;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataSourceWith:(NSDictionary *)dict;

@end
