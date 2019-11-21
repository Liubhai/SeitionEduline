//
//  GZTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/25.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *HeadImageButton;

@property (strong ,nonatomic)UILabel *NameLabel;

@property (strong ,nonatomic)UILabel *TextLabel;

@property (strong ,nonatomic)UILabel *fansLabel;

@property (strong ,nonatomic)UIButton *GZButton;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

-(void)setAttentionType:(NSInteger)follower following:(NSInteger)following isSelf:(BOOL)isSelf;

@end
