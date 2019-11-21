//
//  InstitutionMainViewController.h
//  dafengche
//
//  Created by 智艺创想 on 16/10/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBHTableView.h"
#import "BaseViewController.h"

@interface InstitutionMainViewController : BaseViewController

@property (strong ,nonatomic)UIScrollView *allScrollView;
@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UIScrollView *classScrollView;
@property (strong ,nonatomic)UIPageControl *pageControl;
@property (strong ,nonatomic)UIView *discountView;//优惠券视图
@property (strong ,nonatomic)UIView *segleMentView;
@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)NSArray *imageArray;
@property (strong ,nonatomic)NSArray *titleInfoArray;
@property (strong ,nonatomic)NSArray *classArray;

@property (strong ,nonatomic)NSString *myUID;
@property (strong ,nonatomic)NSString *uID;//关注时用到
@property (strong ,nonatomic)NSString *schoolID;
@property (strong ,nonatomic)NSDictionary *schoolDic;
@property (strong ,nonatomic)UIImageView *imageView;//这个是机构详情的背景图
@property (strong ,nonatomic)UILabel *schoolInfo;
@property (strong ,nonatomic)NSString *address;

@property (assign, nonatomic) BOOL canScroll;

@end
