//
//  Good_QuesAndCommentDetailViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/19.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_QuesAndCommentDetailViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"

#import "Good_QuesAndWriteCommentViewController.h"

@interface Good_QuesAndCommentDetailViewController ()

@property (strong ,nonatomic)UIScrollView   *scrollView;
@property (strong ,nonatomic)UIView         *headerView;
@property (strong ,nonatomic)UIView         *commentView;
@property (strong ,nonatomic)UIView         *downView;
@property (strong ,nonatomic)UIButton       *attentionButton;
@property (strong ,nonatomic)UILabel        *info;
@property (strong ,nonatomic)UILabel        *detail;

@property (strong ,nonatomic)NSArray        *dataArray;
@property (strong ,nonatomic)NSString       *nameStr;


@end

@implementation Good_QuesAndCommentDetailViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self addScrollVoew];
    [self addHeaderView];
    [self addCommentView];
    [self addDownView];
//    [self addTableView];
//    [self addDownView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"评论详情";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
}

- (void)addScrollVoew {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 44 * WideEachUnit)];
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_scrollView];
}

- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 55 * WideEachUnit)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_headerView];
    
    //添加标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, MainScreenWidth - 30 * WideEachUnit, 55 * WideEachUnit)];
    title.text = [_dict stringValueForKey:@"description"];
    title.font = [UIFont boldSystemFontOfSize:18 * WideEachUnit];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    [_scrollView addSubview:title];
    
}

- (void)addCommentView {
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame) + 10 * WideEachUnit, MainScreenWidth, 300 * WideEachUnit)];
    _commentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_commentView];
    
    //添加头像
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 20 * WideEachUnit, 60 * WideEachUnit, 60 * WideEachUnit)];
    headerImageView.image = Image(@"你好");
    headerImageView.layer.cornerRadius = 30 * WideEachUnit;
    headerImageView.layer.masksToBounds = YES;
    NSString *urlStr = [_dict stringValueForKey:@"headimg"];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    [_commentView addSubview:headerImageView];
    
    //添加名字
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(85 * WideEachUnit, 25 * WideEachUnit,MainScreenWidth - 100 * WideEachUnit, 20 * WideEachUnit)];
    Name.text = [_dict stringValueForKey:@"name"];
    Name.textColor = [UIColor colorWithHexString:@"#333"];
    Name.text = @"王二";
    Name.font = Font(13 * WideEachUnit);
    [_commentView addSubview:Name];
    _nameStr = _dict[@"name"];
    
    //添加关注的按钮
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80 * WideEachUnit, 30 * WideEachUnit, 70 * WideEachUnit, 30 * WideEachUnit)];
    [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    _attentionButton.titleLabel.font = Font(13 * WideEachUnit);
    [_attentionButton setTitleColor:BasidColor forState:UIControlStateNormal];
    _attentionButton.layer.borderWidth = 1;
    _attentionButton.layer.borderColor = BasidColor.CGColor;
    _attentionButton.backgroundColor = [UIColor whiteColor];
    _attentionButton.layer.cornerRadius = 2 * WideEachUnit;
    [_commentView addSubview:_attentionButton];
    
    //添加介绍
    _info = [[UILabel alloc] initWithFrame:CGRectMake(85 * WideEachUnit, 50 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 20 * WideEachUnit)];
    if ([_dict[@"label"] isEqual:[NSNull null]] || _dict[@"label"] == nil ) {
        _info.text = @"";
    } else {
        //        [self setIntroductionText:_teacherDic[@"label"]];
    }
    
    //    _teacherInfo.textAlignment = NSTextAlignmentCenter;
    
    if ([_info.text isEqual:[NSNull null]] || _dict[@"label"] == nil) {
        
    } else {
        _info.font = Font(13 * WideEachUnit);
    }
    
    if ([_info.text isEqual:[NSNull null]] || _dict[@"label"] == nil) {
    } else {
        _info.textColor = [UIColor whiteColor];
    }
    [_commentView addSubview:_info];
    _info.font = Font(13);
    _info.text = @"0个课程  0人关注";
    _info.textColor = [UIColor colorWithHexString:@"#888"];
    
    //添加详情
    _detail = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 70 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 20 * WideEachUnit)];
    _detail.text = @"网易帐号中心是网易帐号的管理中心,可在这里对帐号资料、密码、密保等信息进行修改和管理";
    _detail.font = Font(13 * WideEachUnit);
    _detail.textColor = [UIColor colorWithHexString:@"#666"];
    [_commentView addSubview:_detail];
    
    //设置label的最大行数
    _detail.numberOfLines = 0;
    if ([_detail.text isEqual:[NSNull null]]) {
        _detail.frame = CGRectMake(50 * WideEachUnit,130 * WideEachUnit,MainScreenWidth - 100 * WideEachUnit,30 * WideEachUnit);
        return;
    }
    
    CGRect labelSize = [_detail.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 100 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    _detail.frame = CGRectMake(15 * WideEachUnit,95 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit,labelSize.size.height);
    _detail.backgroundColor = [UIColor whiteColor];
    
    
    //添加时间
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_detail.frame) + 15 * WideEachUnit,MainScreenWidth - 100 * WideEachUnit, 15 * WideEachUnit)];
    time.text = [_dict stringValueForKey:@"name"];
    time.textColor = [UIColor colorWithHexString:@"#888"];
    time.font = Font(15 * WideEachUnit);
    time.text = @"2018-9-10";
    [_commentView addSubview:time];
    
    _commentView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame) + 10 * WideEachUnit, MainScreenWidth, CGRectGetMaxY(time.frame) + 20 * WideEachUnit);
    
}

- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 44 * WideEachUnit, MainScreenWidth, 44 * WideEachUnit)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    CGFloat buttonW = MainScreenWidth / 2;
    CGFloat buttonH = 44 * WideEachUnit;
    NSArray *titleArray = @[@"2588",@"2000"];
    NSArray *imageArray = @[@"ico_like@3x",@"ico_comments@3x"];
    //添加按钮
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonW * i, 0, buttonW, buttonH)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
    }
    
    //添加分割线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, 0, 1, 44 * WideEachUnit)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];
}

#pragma mark --- 事件点击
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonCilck:(UIButton *)button {
    Good_QuesAndWriteCommentViewController *vc = [[Good_QuesAndWriteCommentViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
