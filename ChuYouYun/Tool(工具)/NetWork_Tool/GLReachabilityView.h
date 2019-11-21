//
//  GLReachabilityView.h
//  ChuYouYun
//
//  Created by IOS on 16/5/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLReachabilityView : UIView

@property (nonatomic,strong) UIView *popview;

+(BOOL) isConnectionAvailable;

+(UIView *)popview;

@end
