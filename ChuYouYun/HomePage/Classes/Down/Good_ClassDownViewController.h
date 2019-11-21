//
//  Good_ClassDownViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/2.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface Good_ClassDownViewController : BaseViewController

@property (strong ,nonatomic)NSMutableDictionary  *videoDataSource;
@property (strong ,nonatomic)NSString             *ID;
@property (strong ,nonatomic)NSString             *isDown;
@property (strong ,nonatomic)NSString             *orderSwitch;
@property (assign, nonatomic) BOOL isClassCourse;

@end
