//
//  ClassSearchGoodViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/28.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassSearchGoodViewController : UIViewController

@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIView *rankView;//排序的试图
@property (strong ,nonatomic)UIView * screenView;//筛选视图
@property (strong ,nonatomic)UIButton *allCateButton;
@property (strong ,nonatomic)UILabel *allCate;
@property (strong ,nonatomic)UIButton *allRankButton;
@property (strong ,nonatomic)UILabel *allRank;


@property (strong ,nonatomic)UIScrollView *screenScrollView;//筛选的滚动视图

@property (strong ,nonatomic)UIButton *selectedOne;
@property (strong ,nonatomic)UIButton *selectedTwo;
@property (strong ,nonatomic)UIButton *selectedThere;
@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)NSString *typeStr;
@property (strong ,nonatomic)NSString *screeningStr;
@property (strong ,nonatomic)NSString *searchStr;
@property (strong ,nonatomic)UITextField *searchText;
@property (strong ,nonatomic)NSString *cate_ID;//总分类跳过来的
@property (strong ,nonatomic)NSString *cateStr;//总分类过来的关键字

@property (strong ,nonatomic)NSString *classType;//区分课程 还是直播课
@property (strong ,nonatomic)NSString *orderStr;

@property (strong ,nonatomic)NSString *currentVipId;//当前会员的ID


//判断是否是在最外面的洁面
@property (strong ,nonatomic)NSString     *typeTagStr;


@end
