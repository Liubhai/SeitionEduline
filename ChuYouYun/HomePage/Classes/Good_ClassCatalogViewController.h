//
//  Good_ClassCatalogViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Good_ClassMainViewController.h"

@interface Good_ClassCatalogViewController : UIViewController

@property (assign, nonatomic) BOOL isClassCourse;// 是否是班级课列表

@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) Good_ClassMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (strong ,nonatomic)NSDictionary    *videoInfoDict;//这个课程的详情

@property (strong ,nonatomic)UITableView     *tableView;
//学习记录那边传进来的课时id
@property (strong, nonatomic)NSString *sid;
@property (assign, nonatomic) BOOL canPlayRecordVideo;

@property (strong ,nonatomic)void (^vcHight)(CGFloat hight);
@property (strong ,nonatomic)void (^didSele)(NSString *seleStr);
@property (strong ,nonatomic)void (^videoDataSource)(NSDictionary *videoDataSource);
-(instancetype)initWithNumID:(NSString *)ID;

@end
