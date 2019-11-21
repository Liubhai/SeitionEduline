//
//  TestCurrentViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/26.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TestCurrentViewController : BaseViewController

@property (strong ,nonatomic)NSDictionary    *testDict;

@property (strong ,nonatomic)NSString        *examsType;
@property (strong ,nonatomic)NSDictionary    *dataSource;//考试所有的数据
@property (strong ,nonatomic)NSString        *continueStr;//这个字符串是来标示是否是在继续答题

@property (strong ,nonatomic)NSString        *errorsFag;//这个是专门用作标示错题解析的一个字符串 （主要是用于错题解析的时候试卷返回的题目的总数为考试题的总输而不是错题集的总数）（错题重做也用到这个标识符）

@property (strong ,nonatomic)NSString        *classTestType;//主要是从课程里面进来的时候需要

@end
