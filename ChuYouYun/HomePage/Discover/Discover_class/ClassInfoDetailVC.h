//
//  ClassInfoDetailVC.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassDetailViewController.h"

@class ClassDetailViewController;

@interface ClassInfoDetailVC : BaseViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong, nonatomic) ClassDetailViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (nonatomic, assign) CGFloat tableHeight;

@property (nonatomic, strong) NSDictionary *originDict;

@end
