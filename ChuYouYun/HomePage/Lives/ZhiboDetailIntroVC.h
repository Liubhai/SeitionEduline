//
//  ZhiboDetailIntroVC.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/19.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BaseViewController.h"
#import "ZhiBoMainViewController.h"
#import "Good_ClassMainViewController.h"

@interface ZhiboDetailIntroVC : BaseViewController

@property (strong, nonatomic) UIScrollView *mainScroll;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) ZhiBoMainViewController *vc;
@property (strong, nonatomic) Good_ClassMainViewController *mainVC;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (assign, nonatomic) BOOL isZhibo;

@property (strong ,nonatomic)void (^detailScroll)(CGFloat hight);
-(instancetype)initWithNumID:(NSString *)ID;
-(instancetype)initWithNumID:(NSString *)ID WithOrderSwitch:(NSString *)orderSwitch;
- (void)changeMainScrollViewHeight:(CGFloat)changeHeight;

@end

