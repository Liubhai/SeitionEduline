//
//  InstitutionMainViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstitutionMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"

#import "InstationClassViewController.h"
#import "InstationTeacherViewController.h"
#import "InstitutionHomeViewController.h"

#import "InstitionDiscountViewController.h"
#import "MessageSendViewController.h"
#import "DLViewController.h"
#import "ZhiBoMainViewController.h"


@interface InstitutionMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentIndex;
    CGFloat buttonW;
    CGFloat moreViewH;
    
    CGFloat basidFrame;
    CGFloat classFrame;
    CGFloat teacherFrame;
    
    NSString *offSet;
    // 新增内容
    CGFloat sectionHeight;
}
@property (strong ,nonatomic)UIView *infoView;
@property (strong ,nonatomic)UITableView *cityTableView;
@property (strong ,nonatomic)NSArray *cityDataArray;
@property (strong ,nonatomic)NSArray *subVcArray;
//@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIButton *seletedButton;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UILabel *WZLabel;

@property (strong ,nonatomic)UIButton *attentionButton;

@property (strong ,nonatomic)NSString *homeScrollHight;
@property (strong ,nonatomic)NSString *classScrollHight;
@property (strong ,nonatomic)NSString *teacherScrollHight;
@property (strong ,nonatomic)NSString *followingStr;

// 新版
@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic, retain) UIScrollView *mainScroll;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, strong) UIView *buttonBackView;
@property (nonatomic, strong) UIButton *introButton;
@property (nonatomic, strong) UIButton *courseButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *blueLineView;
/// 底部全部设置为全局变量为了好处理交互
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) InstitutionHomeViewController *activityWeb;
@property (nonatomic, strong) InstationClassViewController *activityCommentList;
@property (nonatomic, strong) InstationTeacherViewController *activityQuestionList;

@end

@implementation InstitutionMainViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self getTheClassOffSet];
    [self getTheTeacherOffSet];
    
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
    /// 新增内容
    self.canScroll = YES;
    sectionHeight = 0.01;
    _titleLabel.text = @"机构详情";
    _titleImage.backgroundColor = BasidColor;
    _tableView = [[LBHTableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, ScreenWidth, ScreenHeight - MACRO_UI_UPHEIGHT) style:UITableViewStylePlain];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBA(241, 241, 241);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    //MARK: -- iOS11适配
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
#else
#endif

    [_tableView addHeaderWithTarget:self action:@selector(netWorkSchoolGetInfo)];
    [self getTheClassFrame];
    [self getTheTeacherFrame];

    [self interFace];
//    [self createSubView];
//    [self addAllScrollView];

    [self netWorkSchoolGetInfo];

}

- (void)createSubView {
    if (!self.headerView) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * HigtEachUnit)];
        self.headerView.backgroundColor = [UIColor whiteColor];
    }
    //    [self.headerView removeAllSubviews];
    //    self.tableView.tableHeaderView = self.headerView;
    //    [self.tableView reloadData];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    currentIndex = 0;
    _imageArray = @[@"你好",@"我好",@"他好",@"你好",@"大家好"];
    _titleInfoArray = @[@"简介"];
    
    //通知
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeScrollHight:) name:@"IntHomeScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassScrollHight:) name:@"InsClassScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTeacherScrollHight:) name:@"NSNotificationInstTeacherScrollFrame" object:nil];
    
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = [UIColor clearColor];
    [_allScrollView addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
}


- (void)addAllScrollView {
    
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreenWidth, MainScreenHeight)];
    if (iPhoneX) {
        _allScrollView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 83 - 88);
    }
//    _allScrollView.pagingEnabled = YES;
    _allScrollView.delegate = self;
    _allScrollView.bounces = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allScrollView.contentSize = CGSizeMake(0, 2000);
    [self.view addSubview:_allScrollView];
}

- (void)addInfoView {
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * HigtEachUnit)];
    _infoView.backgroundColor = [UIColor redColor];
    [self.headerView addSubview:_infoView];
    
    //背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_infoView.bounds];
    imageView.image = Image(@"my_bg100");
    [_infoView addSubview:imageView];
    _imageView = imageView;
    
    //机构头像
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 20 * HigtEachUnit, 60 * WideEachUnit, 60 * HigtEachUnit)];
    headerImageView.image = Image(@"你好");
    headerImageView.layer.cornerRadius = 6 * WideEachUnit;
    headerImageView.layer.masksToBounds = YES;
    NSString *urlStr = [_schoolDic stringValueForKey:@"cover"];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    [_infoView addSubview:headerImageView];
    
    
    
    //添加名字
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(90 * WideEachUnit, 30 * HigtEachUnit,MainScreenWidth - 100 * WideEachUnit, 16 * HigtEachUnit)];
    Name.text = [_schoolDic stringValueForKey:@"title"];
    Name.textColor = [UIColor colorWithHexString:@"#fff"];
    Name.font = Font(16 * WideEachUnit);
    [_infoView addSubview:Name];
    
    
    //添加介绍
    _schoolInfo = [[UILabel alloc] initWithFrame:CGRectMake(90 * WideEachUnit, 55 * HigtEachUnit, MainScreenWidth - 100 * WideEachUnit, 20 * HigtEachUnit)];
//    [self setIntroductionText:[_schoolDic stringValueForKey:@"type"]];
    _schoolInfo.font = Font(12 * WideEachUnit);
    _schoolInfo.textColor = [UIColor colorWithHexString:@"#fff"];
    _schoolInfo.text = @"0个课程    0人关注";
    NSString *video_count = [[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"video_count"];
    NSString *teacher_count = [[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"teacher_count"];
    _schoolInfo.text = [NSString stringWithFormat:@"%@个课程 | %@位讲师",video_count,teacher_count];
    [_infoView addSubview:_schoolInfo];
    
    
    //添加关注的按钮
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80 * WideEachUnit, 30 * HigtEachUnit, 70 * WideEachUnit, 30 * HigtEachUnit)];
    if ([_followingStr integerValue] == 0) {
        [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    } else {
        [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    _attentionButton.titleLabel.font = Font(13 * WideEachUnit);
    [_attentionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_attentionButton setImage:Image(@"icon_focus@3x") forState:UIControlStateNormal];
    _attentionButton.backgroundColor = [UIColor whiteColor];
    _attentionButton.layer.cornerRadius = 15 * WideEachUnit;
    [_attentionButton addTarget:self action:@selector(attentionButtonButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:_attentionButton];
    _attentionButton.hidden = YES;
    
    
    
    //添加粉丝、浏览、评价的界面
    UIView *kinsOfView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_schoolInfo.frame), MainScreenWidth, 40)];
    kinsOfView.backgroundColor = [UIColor clearColor];
    [_infoView addSubview:kinsOfView];
    kinsOfView.hidden = YES;
    
    NSArray *buttonArray = @[@"浏览",@"粉丝"];
    
    CGFloat labelW = 100 * WideEachUnit;
    CGFloat labelH = 20;
    CGFloat buttonW = 100 * WideEachUnit;
    CGFloat buttonH = 20;
    
    NSString *Str0 = [NSString stringWithFormat:@"%@",[[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"view_count"]];
//    NSString *Str1 = [NSString stringWithFormat:@"%@",[[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"comment_score"]];
    NSString *Str2 = [NSString stringWithFormat:@"%@",[[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"follower_count"]];
    
    NSArray *titleArray = @[Str0,Str2];
    
    
    for (int i = 0 ; i < buttonArray.count ; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelW, 0, labelW, labelH)];
        if (i == 0) {
            label.frame = CGRectMake(MainScreenWidth / 2 - labelW, 0, labelW, labelH);
        } else {
            label.frame = CGRectMake(MainScreenWidth / 2, 0, labelW, labelH);
        }
        label.text = titleArray[i];
        label.font = Font(12);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [kinsOfView addSubview:label];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * buttonW, 20, buttonW, buttonH)];
        if (i == 0) {
            button.frame = CGRectMake(MainScreenWidth / 2 - labelW, 20, labelW, labelH);
        } else {
            button.frame = CGRectMake(MainScreenWidth / 2, 20, labelW, labelH);
        }
        [button setTitle:buttonArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = Font(12);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [kinsOfView addSubview:button];
    }
    
}

#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segleMentView.frame) + 10,  MainScreenWidth, MainScreenHeight * 3 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [_allScrollView addSubview:_controllerSrcollView];

    InstitutionHomeViewController * instHomeVc= [[InstitutionHomeViewController alloc]init];
    instHomeVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:instHomeVc];
    instHomeVc.address = _address;
    [_controllerSrcollView addSubview:instHomeVc.view];
    
    InstationClassViewController * classVc = [[InstationClassViewController alloc]init];
    classVc.view.frame = CGRectMake(MainScreenWidth, -64, MainScreenWidth, MainScreenHeight * 1 + 500);
    [self addChildViewController:classVc];
    [_controllerSrcollView addSubview:classVc.view];
    
    InstationTeacherViewController * teacherVc = [[InstationTeacherViewController alloc]init];
    teacherVc.view.frame = CGRectMake(MainScreenWidth * 2, -64, MainScreenWidth, MainScreenHeight * 20 + 500);
    [self addChildViewController:teacherVc];
    [_controllerSrcollView addSubview:teacherVc.view];
    
    //添加通知(通知所传达的地方必须要已经实体化，不然就不会相应通知的方法)
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_schoolID forKey:@"school_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationInstitionSchoolID" object:nil userInfo:dict];
    
    _subVcArray = @[instHomeVc,classVc,teacherVc];
    [self addClassBolck];
    [self addTeacherBolck];
}

- (void)addClassBolck {
    InstationClassViewController *vc = _subVcArray[1];
    vc.scollHight = ^(CGFloat hight) {
        _classScrollHight = [NSString stringWithFormat:@"%lf",hight];
    };
}

- (void)addTeacherBolck {
    InstationTeacherViewController *vc = _subVcArray[2];
    vc.scrollHight = ^(CGFloat hight) {
        _teacherScrollHight = [NSString stringWithFormat:@"%lf",hight];
    };
}


- (void)addDiscountView  {
    _discountView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_classScrollView.frame) + 10, MainScreenWidth, 40)];
    _discountView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:_discountView];
    
    //添加标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0, MainScreenWidth - SpaceBaside * 2, 40)];
    titleLabel.text = @"优惠券";
    [_discountView addSubview:titleLabel];
    
    //添加更多课程
    UIButton *moreClassButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
//    [moreClassButton setImage:Image(@"考试右") forState:UIControlStateNormal];
    moreClassButton.backgroundColor = [UIColor clearColor];
    [moreClassButton setTitleColor:BasidColor forState:UIControlStateNormal];
    moreClassButton.titleLabel.font = Font(16);
    [_discountView addSubview:moreClassButton];
    [moreClassButton addTarget:self action:@selector(discountMoreButtonClick) forControlEvents:UIControlEventTouchUpInside];

    
}

// MARK - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifireAC =@"ActivityListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifireAC];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifireAC];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return sectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_bg == nil) {
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, sectionHeight)];
        _bg.backgroundColor = [UIColor whiteColor];
    } else {
        _bg.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight);
    }
    if (sectionHeight>1) {
        if (_commentButton == nil) {
            self.introButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth/3.0, 50 * HigtEachUnit)];
            self.courseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/3.0, 0, MainScreenWidth/3.0, 50 * HigtEachUnit)];
            self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth*2/3.0, 0, MainScreenWidth/3.0, 50 * HigtEachUnit)];
            [self.introButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.courseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.commentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.introButton setTitle:@"简介" forState:0];
            [self.courseButton setTitle:@"课程" forState:0];
            [self.commentButton setTitle:@"讲师" forState:0];
            
            self.introButton.titleLabel.font = SYSTEMFONT(15);
            self.courseButton.titleLabel.font = SYSTEMFONT(15);
            self.commentButton.titleLabel.font = SYSTEMFONT(15);
            
            [self.introButton setTitleColor:[UIColor blackColor] forState:0];
            [self.courseButton setTitleColor:[UIColor blackColor] forState:0];
            [self.commentButton setTitleColor:[UIColor blackColor] forState:0];
            
            [self.introButton setTitleColor:BasidColor forState:UIControlStateSelected];
            [self.courseButton setTitleColor:BasidColor forState:UIControlStateSelected];
            [self.commentButton setTitleColor:BasidColor forState:UIControlStateSelected];
            
            self.introButton.selected = YES;
            
            self.blueLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 * HigtEachUnit, MainScreenWidth / 5.0, 1.5 * HigtEachUnit)];
            self.blueLineView.backgroundColor = BasidColor;
            self.blueLineView.centerX = self.introButton.centerX;
            
            UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 46 * HigtEachUnit, MainScreenWidth, 0.5 * HigtEachUnit)];
            grayLine.backgroundColor = GBLINECOLOR;
            
            [_bg addSubview:self.introButton];
            [_bg addSubview:self.courseButton];
            [_bg addSubview:self.commentButton];
            [_bg addSubview:self.blueLineView];
            [_bg addSubview:grayLine];
        }
        
        if (self.mainScroll == nil) {
            self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,46.5 * HigtEachUnit, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit)];
            self.mainScroll.contentSize = CGSizeMake(MainScreenWidth*3, 0);
            self.mainScroll.pagingEnabled = YES;
            self.mainScroll.showsHorizontalScrollIndicator = NO;
            self.mainScroll.showsVerticalScrollIndicator = NO;
            self.mainScroll.bounces = NO;
            self.mainScroll.delegate = self;
            [_bg addSubview:self.mainScroll];
        } else {
            self.mainScroll.frame = CGRectMake(0,46.5 * HigtEachUnit, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
        }
        if (_activityWeb == nil) {
            _activityWeb = [[InstitutionHomeViewController alloc] init];
            _activityWeb.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _activityWeb.vc = self;
            _activityWeb.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            [self.mainScroll addSubview:_activityWeb.view];
            [self addChildViewController:_activityWeb];
        } else {
            _activityWeb.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _activityWeb.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
        }
        
        if (_activityCommentList == nil) {
            _activityCommentList = [[InstationClassViewController alloc] init];
            _activityCommentList.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _activityCommentList.vc = self;
            _activityCommentList.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            [self.mainScroll addSubview:_activityCommentList.view];
            [self addChildViewController:_activityCommentList];
        } else {
            _activityCommentList.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            _activityCommentList.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
        }
        
        if (_activityQuestionList == nil) {
            _activityQuestionList = [[InstationTeacherViewController alloc] init];
            _activityQuestionList.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _activityQuestionList.vc = self;
            _activityQuestionList.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            [self.mainScroll addSubview:_activityQuestionList.view];
            [self addChildViewController:_activityQuestionList];
        } else {
            _activityQuestionList.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            _activityQuestionList.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_schoolID forKey:@"school_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationInstitionSchoolID" object:nil userInfo:dict];
    }
    return _bg;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)buttonClick:(UIButton *)sender{
    
    if (sender == self.introButton) {
        [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == self.courseButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth, 0) animated:YES];
    } else if (sender == self.commentButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 2, 0) animated:YES];
    }
}

#pragma mark --- 滚动试图

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScroll) {
        if (scrollView.contentOffset.x <= 0) {
            self.blueLineView.centerX = self.introButton.centerX;
            self.introButton.selected = YES;
            self.courseButton.selected = NO;
            self.commentButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.blueLineView.centerX = self.commentButton.centerX;
            self.commentButton.selected = YES;
            self.introButton.selected = NO;
            self.courseButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.blueLineView.centerX = self.courseButton.centerX;
            self.courseButton.selected = YES;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
        }
    } if (scrollView == self.tableView) {
        CGFloat bottomCellOffset = self.headerView.height;
        if (scrollView.contentOffset.y >= bottomCellOffset) {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (UIViewController *vc in self.childViewControllers) {
                    if (self.courseButton.selected) {
                        if ([vc isKindOfClass:[InstationClassViewController class]]) {
                            InstationClassViewController *vccomment = (InstationClassViewController *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.introButton.selected) {
                        if ([vc isKindOfClass:[InstitutionHomeViewController class]]) {
                            InstitutionHomeViewController *vccomment = (InstitutionHomeViewController *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.commentButton.selected) {
                        if ([vc isKindOfClass:[InstationTeacherViewController class]]) {
                            InstationTeacherViewController *vccomment = (InstationTeacherViewController *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                }
            }
        }else{
            if (!self.canScroll) {//子视图没到顶部
                scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }
        }
    }
}

- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_infoView.frame), MainScreenWidth, 50)];
    WZView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:WZView];
    _segleMentView = WZView;
    
    NSArray *segmentedArray = @[@"简介",@"课程",@"讲师"];
    _mainSegment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _mainSegment.frame = CGRectMake(0,SpaceBaside,MainScreenWidth, 30);

    //文字设置
    NSMutableDictionary *attDicNormal = [NSMutableDictionary dictionary];
    attDicNormal[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    attDicNormal[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#888"];
    NSMutableDictionary *attDicSelected = [NSMutableDictionary dictionary];
    attDicSelected[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    attDicSelected[NSForegroundColorAttributeName] = BasidColor;
    [_mainSegment setTitleTextAttributes:attDicNormal forState:UIControlStateNormal];
    [_mainSegment setTitleTextAttributes:attDicSelected forState:UIControlStateSelected];
    _mainSegment.selectedSegmentIndex = 0;
    _mainSegment.backgroundColor = [UIColor whiteColor];
    [WZView addSubview:_mainSegment];
    
    _mainSegment.tintColor = [UIColor whiteColor];
    _mainSegment.momentary = NO;
    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
    basidFrame = CGRectGetMaxY(_mainSegment.frame);
    
}

- (void)addInstationMore {
    [self addMoreView];
}

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
//    [self.view insertSubview:_allView belowSubview:_downView];

    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    
    moreViewH = _titleInfoArray.count * 40 + 5 * (_titleInfoArray.count - 1);
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(buttonW, MainScreenHeight, buttonW, moreViewH);
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(buttonW, MainScreenHeight - 50 - moreViewH, buttonW, moreViewH);
        //在view上面添加东西
        for (int i = 0 ; i < _titleInfoArray.count ; i ++) {
            
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setTitle:_titleInfoArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
//            button.tag = [_SYGArray[i][@"exam_category_id"] integerValue];
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
        }
        
        //添加中间的分割线
        for (int i = 0; i < _titleInfoArray.count; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , buttonW, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buyView addSubview:XButton];
        }
    }];
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(buttonW, MainScreenHeight, buttonW, moreViewH);
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
}

- (void)SYGButton:(UIButton *)button {
    [self miss];
    
    //这里应该要设置偏移量
    _controllerSrcollView.contentOffset = CGPointMake(0, 0);
    
}


#pragma mark --- 事件监听

- (void)moreButtonClick:(UIButton *)button {
    
}

- (void)discountMoreButtonClick {
    
    InstitionDiscountViewController *discountVc = [[InstitionDiscountViewController alloc] init];
    discountVc.schoolID = _schoolID;
    [self.navigationController pushViewController:discountVc animated:YES];
    
}

- (void)mainChange:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
             _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            _allScrollView.contentSize = CGSizeMake(0 , [_homeScrollHight floatValue] + 250);
            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0 , [_classScrollHight floatValue] + 350);
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0, [_teacherScrollHight floatValue] + 240);
            break;
            
        default:
            break;
    }
    
}

//添加私信或者电话
- (void)addPhoneOrMessage {
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"私信" otherButtonTitles:@"呼叫", nil];
    action.delegate = self;
    [action showInView:self.view];

}


- (void)attentionButtonButtonCilck:(UIButton *)button {
    NSString *title = button.titleLabel.text;
    if ([title isEqualToString:@"取消关注"]) {
        [self netWorkUseUnFollow];
    } else if ([title isEqualToString:@"关注"]) {
        [self netWorkUseFollow];
    }
}


#pragma mark --- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){//私信
        [self sendMessage];

    }else if (buttonIndex == 1){//呼叫
        [self CallPhone];
    }
}

-(void)CallPhone{

    NSString *phoneStr = [_schoolDic stringValueForKey:@"phone"];
    NSLog(@"----%@",phoneStr);
    if (phoneStr == nil || [phoneStr isEqualToString:@""]) {
        [TKProgressHUD showError:@"电话号码为空，不能拨打" toView:self.view];
        return;
    }
    NSMutableString *phoneString = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneString]]];
    [self.view addSubview:callWebView];
    
}

- (void)sendMessage {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
    MSVC.TID = _uID;
    MSVC.name = [_schoolDic stringValueForKey:@"title"];
    [self.navigationController pushViewController:MSVC animated:YES];

}

#pragma mark --- 文本自适应

-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _schoolInfo.text = text;
    //设置label的最大行数
    _schoolInfo.numberOfLines = 0;
    
    CGRect labelSize = [_schoolInfo.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    _schoolInfo.frame = CGRectMake(50,130,MainScreenWidth - 100,labelSize.size.height);
    _infoView.frame = CGRectMake(0, 0, MainScreenWidth, 170 + labelSize.size.height );
    
    //重新添加背景 不然会变形
    _imageView.frame = CGRectStandardize(_infoView.frame);
}

#pragma mark --- 通知

- (void)getTheClassFrame {
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(getTheClassFrame:) name:@"NSNotificationInstClassScrollFrame" object:nil];
    
}

- (void)getTheClassFrame:(NSNotification *)Not {
    NSLog(@"%@",Not.userInfo);
    classFrame = [Not.userInfo[@"frame"] floatValue];
    
}

- (void)getTheTeacherFrame {
    
    
}

- (void)getTheClassOffSet {
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(getTheClassOffSet:) name:@"NSNotificationInsClassOffSet" object:nil];
    
    if (offSet) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * [offSet integerValue], 0);
        offSet = nil;
    }
}

- (void)getTheClassOffSet:(NSNotification *)Not {
    offSet = Not.userInfo[@"offSet"];
}

- (void)getTheTeacherOffSet {
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(getTheTeacherOffSet:) name:@"NSNotificationInsTeacherOffSet" object:nil];
    
    if (offSet) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * [offSet integerValue], 0);
        offSet = nil;
    }
}

- (void)getTheTeacherOffSet:(NSNotification *)Not {
    offSet = Not.userInfo[@"offSet"];
}

- (void)getHomeScrollHight:(NSNotification *)not {
    _homeScrollHight = (NSString *)not.object;
    _allScrollView.contentSize = CGSizeMake(0 , [_homeScrollHight floatValue] + 250);
}

- (void)getClassScrollHight:(NSNotification *)not {
    _classScrollHight = (NSString *)not.object;
    _allScrollView.contentSize = CGSizeMake(0 , [_classScrollHight floatValue] + 350);
}

- (void)getTeacherScrollHight:(NSNotification *)not {
    NSLog(@"%@",not.userInfo);
    NSDictionary *dict = not.userInfo;
    _teacherScrollHight = [dict stringValueForKey:@"frame"];
    NSLog(@"---gaodu%@",_teacherScrollHight);
    _allScrollView.contentSize = CGSizeMake(0 , [_teacherScrollHight floatValue] + 240);
}

#pragma mark --- 网络请求
//获取机构详情
- (void)netWorkSchoolGetInfo {
    
    NSString *endUrlStr = YunKeTang_School_school_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];

    if (_schoolID == nil) {
        return;
    } else {
        [mutabDict setObject:_schoolID forKey:@"school_id"];
    }
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
//        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([_tableView isHeaderRefreshing]) {
            [_tableView headerEndRefreshing];
        }
        _schoolDic = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        _WZLabel.text = [_schoolDic stringValueForKey:@"title"];
        _classArray = [_schoolDic arrayValueForKey:@"recommend_list"];
        _followingStr = [[_schoolDic dictionaryValueForKey:@"follow_state"] stringValueForKey:@"following"];
        sectionHeight =  MainScreenHeight - MACRO_UI_UPHEIGHT;
        [self createSubView];
        [self addInfoView];
//        [self addNav];
//        [self addWZView];
//        [self addControllerSrcollView];
        _tableView.tableHeaderView = _headerView;
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    [op start];
}


//添加关注
- (void)netWorkUseFollow {
    
    NSString *endUrlStr = YunKeTang_User_user_follow;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    if ([userID integerValue] == [_uID integerValue]) {//说明是自己
        [TKProgressHUD showError:@"不能关注自己" toView:self.view];
        return;
    }
    if (_uID == nil) {
        [TKProgressHUD showError:@"不能关注自己的机构" toView:self.view];
        return;
    } else {
        if ([_myUID integerValue] == [_uID integerValue]) {
            [TKProgressHUD showError:@"不能关注自己的机构" toView:self.view];
            return;
        } else {
            [mutabDict setObject:_uID forKey:@"user_id"];
        }
    }
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"关注成功" toView:self.view];
            [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            return ;
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//取消关注
- (void)netWorkUseUnFollow {
    
    NSString *endUrlStr = YunKeTang_User_user_unfollow;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_uID forKey:@"user_id"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    if ([userID integerValue] == [_uID integerValue]) {//说明是自己
        [TKProgressHUD showError:@"不能关注自己" toView:self.view];
        return;
    }
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"取消关注成功" toView:self.view];
            [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            return ;
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





@end
