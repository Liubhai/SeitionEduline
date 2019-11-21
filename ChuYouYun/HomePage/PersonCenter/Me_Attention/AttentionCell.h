//
//  AttentionCell.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIMG;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userText;
@property (weak, nonatomic) IBOutlet UIButton *attentionType;
-(void)setAttentionType:(NSInteger)follower following:(NSInteger)following isSelf:(BOOL)isSelf;
@end
