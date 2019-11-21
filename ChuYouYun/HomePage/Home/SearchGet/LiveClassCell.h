//
//  LiveClassCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/12/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveClassCell : UITableViewCell

@property (strong ,nonatomic)UIButton *imageButton;

@property (strong ,nonatomic)UIButton *playButton;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UIButton *XJButton;

@property (strong ,nonatomic)UILabel *contentLabel;

@property (strong ,nonatomic)UILabel *XBLabel;

@property (strong ,nonatomic)UIButton *GKButton;

@property (strong ,nonatomic)UILabel *GKLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;


@end
