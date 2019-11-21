//
//  InstitutionListCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/10/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstitutionListCell : UITableViewCell


@property (strong ,nonatomic)UIImageView *headImageView;

@property (strong ,nonatomic)UILabel *nameLabel;

@property (strong ,nonatomic)UILabel *personNumber;

@property (strong ,nonatomic)UIButton *XJButton;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UILabel *contentlabel;

@property (strong ,nonatomic)UILabel *downLabel;

@property (strong ,nonatomic)UILabel *addressLabel;

@property (strong ,nonatomic)UILabel *classLabel;

@property (strong ,nonatomic)UILabel *studyLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)dataSourceWith:(NSDictionary *)dict;

@end
