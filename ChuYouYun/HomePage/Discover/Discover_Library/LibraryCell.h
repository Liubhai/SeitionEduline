//
//  LibraryCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/10/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFFileModel.h"

@interface LibraryCell : UITableViewCell


@property (strong ,nonatomic)UIImageView *headImageView;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UILabel *sizeLabel;

@property (strong ,nonatomic)UILabel *typeLabel;

@property (strong ,nonatomic)UILabel *downLabel;

@property (strong ,nonatomic)UIButton *downButton;



-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)dataSourceWith:(NSDictionary *)dict;
- (void)dataWithModel:(ZFFileModel *)Model withState:(NSString *)state;


@end
