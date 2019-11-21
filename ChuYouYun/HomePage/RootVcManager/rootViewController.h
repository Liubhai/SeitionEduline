//
//  rootViewController.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rootViewController : UITabBarController

@property (nonatomic, strong) UIImageView *imageView;
+(rootViewController *)sharedBaseTabBarViewController;
+(rootViewController *)destoryShared;

- (void)isHiddenCustomTabBarByBoolean:(BOOL)boolean;

- (void)rootVcIndexWithNum:(NSInteger)Num;

@end
