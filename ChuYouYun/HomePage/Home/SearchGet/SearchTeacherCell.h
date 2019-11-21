//
//  SearchTeacherCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/11.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTeacherCell : UITableViewCell

@property (strong ,nonatomic)UIImageView *headImageView;
@property (strong ,nonatomic)UILabel *nameLabel;
@property (strong ,nonatomic)UILabel *contentLabel;
@property (strong ,nonatomic)UILabel *numLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)dataSourceWith:(NSDictionary *)dict;

@end
