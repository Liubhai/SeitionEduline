//
//  LotteryView.h
//  NewCCDemo
//
//  Created by cc on 2017/1/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CloseBlock)();

@interface LotteryView : UIView

-(instancetype)initWithCloseBlock:(CloseBlock)block;

-(void)myselfWin:(NSString *)code;

-(void)otherWin:(NSString *)winnerName;

@property(nonatomic,assign)NSInteger                   type;

@end
