//
//  ClassDetailViewController.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BaseViewController.h"
#import "LBHTableView.h"
#import "ClassInfoDetailVC.h"
#import "ClassCourseListVC.h"
#import "ClassCommentListVC.h"

@class ClassInfoDetailVC,ClassCourseListVC,ClassCommentListVC;

@interface ClassDetailViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSString *combo_id;

@property (nonatomic, strong) LBHTableView *tableView;
@property (assign, nonatomic) BOOL canScroll;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *classTitle;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *teacherLabel;
@property (nonatomic, strong) UILabel *courseCountLabel;

@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) UIButton *collectionButton;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *introButton;
@property (nonatomic, strong) UIButton *courseButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *blueLineView;
@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) ClassInfoDetailVC *introVC;
@property (nonatomic, strong) ClassCourseListVC *courseListVC;
@property (nonatomic, strong) ClassCommentListVC *commentListVC;

@property (nonatomic, strong) NSDictionary *originDict;
@end
