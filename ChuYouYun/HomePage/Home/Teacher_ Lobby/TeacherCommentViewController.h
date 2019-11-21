//
//  TeacherCommentViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/5/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherMainViewController.h"

@interface TeacherCommentViewController : UIViewController

@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) TeacherMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;

-(instancetype)initWithNumID:(NSString *)ID;

@end
