//
//  AttentionCell.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "AttentionCell.h"

@implementation AttentionCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setAttentionType:(NSInteger)follower following:(NSInteger)following isSelf:(BOOL)isSelf
{
    if (isSelf == YES) {
        if (follower == 1&&following ==1) {
            [self.attentionType setBackgroundImage:[UIImage imageNamed:@"相互关注@2x"] forState:0];
        }if (follower == 1&&following ==0) {
            [self.attentionType setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:0];
        }if (follower == 0&&following ==0) {
            [self.attentionType setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:0];
        }
    }else
    {
        if (follower == 1&&following ==1) {
            [self.attentionType setBackgroundImage:[UIImage imageNamed:@"相互关注@2x"] forState:0];
        }if (follower == 1&&following ==0) {
            [self.attentionType setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:0];
        }if (follower == 0&&following ==0) {
            [self.attentionType setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:0];
        }

    }
    
}


@end
