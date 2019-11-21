//
//  DDChatCell.h
//  ChuYouYun
//
//  Created by 赛新科技 on 2017/5/17.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDChatCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 计算cell 的高度 */
+ (CGFloat)heightOfCellWithMessage:(NSString *)message;

- (void)showMessage:(NSString *)message fromSelf:(BOOL)fromSelf title:(NSString *)title;

@end
