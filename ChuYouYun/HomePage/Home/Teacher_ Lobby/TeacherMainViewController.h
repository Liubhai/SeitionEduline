//
//  TeacherMainViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/5/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LBHTableView.h"

@interface TeacherMainViewController : BaseViewController

@property (assign, nonatomic) BOOL canScroll;

-(instancetype)initWithNumID:(NSString *)ID;

@end
