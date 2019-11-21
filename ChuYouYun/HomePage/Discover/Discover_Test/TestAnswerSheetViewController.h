//
//  TestAnswerSheetViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/27.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TestAnswerSheetViewController : UIViewController

//总共的数据（全部的数据）
@property (strong ,nonatomic)NSDictionary         *dataSource;

//是否是由于时间到才交的试卷
@property (strong ,nonatomic)NSString             *timeIsOver;

@property (strong ,nonatomic)NSString             *contentStr;//是否继续答题（用于记录时间）
@property (strong ,nonatomic)NSString             *againStr;//这个字符串标示是否是再次挑战
@property (strong ,nonatomic)NSString             *classTestType;//主要是从课程进入的考试


//用户的答案
@property (strong ,nonatomic)NSMutableArray   *multipleUserArray;//用户的答案（单选）
@property (strong ,nonatomic)NSMutableArray   *moreMultipleUserArray;//用户的答案（du多o选）
@property (strong ,nonatomic)NSMutableArray   *judgeUserArray;//用户的答案（判断）
@property (strong ,nonatomic)NSMutableArray   *gapUserArray;//用户的答案（填空）
@property (strong ,nonatomic)NSMutableArray   *subjectivityUserArray;//用户的答案（主观）

//考试模式的信息
@property (strong ,nonatomic)NSString         *examType;

//考试或者是练习模式的时候 想关于时间的一些处理
@property (strong ,nonatomic)NSDictionary     *testDict;//试卷考试相关
@property (assign ,nonatomic)NSInteger         passTimeIng;//时间




@end
