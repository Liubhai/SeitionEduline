//
//  RollcallView.h
//  NewCCDemo
//
//  Created by cc on 2017/1/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CloseBtnClicked)();

typedef void(^LotteryBtnClicked)();

@interface RollcallView : UIView

-(instancetype) initWithDuration:(NSInteger)duration closeblock:(CloseBtnClicked)closeblock lotteryblock:(LotteryBtnClicked)lotteryblock ;

@end
