//
//  TeacherClassViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/25.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherMainViewController.h"

@interface TeacherClassViewController : UIViewController

@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) TeacherMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;

-(instancetype)initWithNumID:(NSString *)ID;

@end
