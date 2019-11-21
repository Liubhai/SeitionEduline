//
//  ZhiBoMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"


#import "DLViewController.h"
#import "Good_ZhiBoDetailViewController.h"
#import "ZhiBoClassViewController.h"
#import "TKZhiBoViewController.h"
#import "LiveDetailCommentViewController.h"

#import "ClassAndLivePayViewController.h"
#import "WebViewController.h"

#import "LBHProgressView.h"
#import "ZhiboDetailIntroVC.h"

#import "TeacherMainViewController.h"
#import "InstitutionMainViewController.h"

#import "GroupListPopViewController.h"



@interface ZhiBoMainViewController ()<UIScrollViewDelegate,UMSocialUIDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    UIImageView  *shareImageView;
    NSString     *shareUrl;
    CGFloat sectionHeight;
    // 活动倒计时
    NSInteger eventTime;
    NSTimer *eventTimer;
}

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UIScrollView *allScrollView;
@property (strong ,nonatomic)UIView       *navgationView;
@property (strong ,nonatomic)UILabel      *navgationTitle;
@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UIView   *mainDetailView;
@property (strong ,nonatomic)UILabel  *classTitle;
@property (strong ,nonatomic)UILabel  *studyNumber;

@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIButton *zhiBoLikeButton;
@property (strong ,nonatomic)UIButton *buyButton;
@property (strong ,nonatomic)UIButton *priceButton;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UIView *WZView;
@property (strong ,nonatomic)UIView   *allWindowView;

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *zhiBoTitle;
@property (strong ,nonatomic)NSString *imageUrl;
@property (strong ,nonatomic)NSDictionary *zhiBoDic;
@property (strong ,nonatomic)NSString *collectStr;
@property (strong ,nonatomic)NSArray  *subVcArray;

@property (strong ,nonatomic)NSString *videoUrl;
@property (strong ,nonatomic)NSString *shareLiveUrl;

@property (assign ,nonatomic)CGFloat  detailScrollHight;
@property (assign ,nonatomic)CGFloat  classScrollHight;
@property (assign ,nonatomic)CGFloat  commentScrollHight;

@property (strong ,nonatomic)UILabel         *priceLabel;
@property (strong ,nonatomic)UILabel         *ordPrice;

@property (strong ,nonatomic)NSDictionary   *serviceDict;
@property (strong, nonatomic) UIButton *serviceButton;

/// 活动(限时限量抢购)
/** 活动板块儿容器 */
@property (strong, nonatomic) UIView *activityBackView;
/** 左边价格b、活动类型整体 */
@property (strong, nonatomic) UILabel *leftPriceLabel;
/** 活动类型需要显示的时间 */
@property (strong, nonatomic) UILabel *rightTimeLabel;
/** 活动类型需要显示的时间图标 */
@property (strong, nonatomic) UIImageView *rightTimeIcon;
/** 活动版块儿右边⚡️icon */
@property (strong, nonatomic) UIImageView *rightIcon;
/** 当前活动状态 */
@property (strong, nonatomic) UILabel *rightYellowLabel;
/** 活动进行的状态进度比 */
@property (strong, nonatomic) LBHProgressView *progressView;
/** 活动打折多少 */
@property (strong, nonatomic) UILabel *discountLabel;
/** 课程活动详情信息 */
@property (strong, nonatomic) NSDictionary *activityInfo;

/** 好友助力开团参团砍价版块儿 */
/** 活动板块儿容器 */
@property (strong, nonatomic) UIView *otherActivityBackView;
/** 左边价格b、活动类型整体 */
@property (strong, nonatomic) UILabel *otherLeftPriceLabel;
/** 团购参与人数情况 */
@property (strong, nonatomic) UILabel *joinCountLabel;
/** 活动类型需要显示的时间 */
@property (strong, nonatomic) UILabel *otherRightTimeLabel;
/** 活动类型需要显示的时间图标 */
@property (strong, nonatomic) UIImageView *otherRightTimeIcon;
/** 当前活动参团 */
@property (strong, nonatomic) UIButton *otherJoinIcon;
/** 当前活动开团 */
@property (strong, nonatomic) UIButton *otherStarBtn;
/** 是砍价还是好友助力 */
@property (strong, nonatomic) UIButton *otherGroupBuyBtn;
/** 团购进度 */
@property (strong, nonatomic) UILabel *otherBuyProgressLabel;
/** 活动进行的状态进度比 */
@property (strong, nonatomic) LBHProgressView *otherProgressView;


/** 参团 好友助力 砍价等 弹框UI */
@property (strong, nonatomic) UIView *popBackView;

// 售罄后的视图
@property (strong, nonatomic) UIView *activityEndLeftView;
@property (strong, nonatomic) UIView *activityEndRightView;
@property (strong, nonatomic) UIImageView *activityEndrightIcon;
@property (strong, nonatomic) UILabel *activityEndLabel;

///新增内容
@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic, retain) UIScrollView *mainScroll;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, strong) UIView *buttonBackView;
@property (nonatomic, strong) UIButton *introButton;
@property (nonatomic, strong) UIButton *courseButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *blueLineView;

@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) ZhiboDetailIntroVC *activityWeb;
@property (nonatomic, strong) ZhiBoClassViewController *activityCommentList;
@property (nonatomic, strong) LiveDetailCommentViewController *activityQuestionList;

/** 机构和讲师移动到头部视图里面了 */
@property (strong, nonatomic) UIView *teachersHeaderBackView;
@property (strong, nonatomic) UIScrollView *teachersHeaderScrollView;
@property (strong, nonatomic) NSDictionary *schoolInfo;
@property (strong, nonatomic) NSDictionary *teacherInfoDict;

@end

@implementation ZhiBoMainViewController

-(id)initWithMemberId:(NSString *)MemberId andImage:(NSString *)imgUrl andTitle:(NSString *)title andNum:(int)num andprice:(NSString *)price
{
    if (self=[super init]) {
        _ID = MemberId;
        _zhiBoTitle = title;
        _imageUrl = imgUrl;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self netWorkLiveGetInfo];
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
    _titleLabel.text = @"讲师详情";
    _titleImage.backgroundColor = BasidColor;
    _tableView = [[LBHTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - MACRO_UI_SAFEAREA - 50 * HigtEachUnit) style:UITableViewStylePlain];
    
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
    
    [_tableView addHeaderWithTarget:self action:@selector(netWorkLiveGetInfo)];
    
    [self interFace];
    [self getNSNotification];
    [self createSubView];
//    [self addAllScrollView];
    [self addImageView];
    [self makeActivityUI];
    [self addMainDetailView];
    [self makeTeacherAndOrganizationUI];
    [self addTitleView];
    [self addControllerSrcollView];
    [self addDownView];
    [self addNav];
    [self netWorkLiveGetInfo];
    [self getCourceActivityInfo];
    [self netWorkGetThirdServiceUrl];
}

- (void)createSubView {
    if (!self.headerView) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, (280+44) * HigtEachUnit)];
        self.headerView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [shareImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    SYGView.layer.zPosition = 10;
    _navgationView = SYGView;
    _navgationView.backgroundColor = [UIColor clearColor];
    _navgationView.userInteractionEnabled = YES;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, MACRO_UI_STATUSBAR_ADD_HEIGHT+20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, MACRO_UI_STATUSBAR_ADD_HEIGHT+25,MainScreenWidth - 100, 30)];
    WZLabel.text = _zhiBoTitle;
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    _navgationTitle = WZLabel;
    _navgationTitle.hidden = YES;
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, MACRO_UI_STATUSBAR_ADD_HEIGHT+20, 50, 30)];
    [moreButton setTitle:@"..." forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    [moreButton addTarget:self action:@selector(moreButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:moreButton];
}


#pragma mark --- 接收通知
- (void)getNSNotification {
    //直播主页滚动的范围
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetailScrollHight:) name:@"Good_LiveDetailScrollHight" object:nil];
}

#pragma mark --- 添加全局的滚动视图
- (void)addAllScrollView {
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreenWidth, MainScreenHeight - 50 * WideEachUnit)];
    //    _allScrollView.pagingEnabled = YES;
    _allScrollView.delegate = self;
    _allScrollView.bounces = YES;
    _allScrollView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allScrollView.contentSize = CGSizeMake(0, MainScreenHeight * 3);
    [self.view addSubview:_allScrollView];
}

#pragma mark --- 添加图片视图
- (void)addImageView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200 * WideEachUnit)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
    [_headerView addSubview:_imageView];
}

- (void)addMainDetailView {
    _mainDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 210 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit)];
    _mainDetailView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_mainDetailView];
    
    //添加课程名字
    UILabel *classTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    classTitle.textColor = [UIColor colorWithHexString:@"#333"];
    classTitle.font = Font(18);
    classTitle.backgroundColor = [UIColor whiteColor];
    classTitle.numberOfLines = 0;
    [_mainDetailView addSubview:classTitle];
    _classTitle = classTitle;
    
    //添加学习人数
    UILabel *studyNumber = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 40 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    studyNumber.textColor = [UIColor colorWithHexString:@"#888"];
    studyNumber.font = Font(15);
    studyNumber.hidden = YES;
    [_mainDetailView addSubview:studyNumber];
    _studyNumber = studyNumber;
    
    //添加价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 80 * WideEachUnit, 40 * WideEachUnit, 70 * WideEachUnit, 20 * WideEachUnit)];
    priceLabel.textColor = [UIColor colorWithHexString:@"#f01414"];
    priceLabel.font = Font(16);
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.hidden = YES;
    [_mainDetailView addSubview:priceLabel];
    _priceLabel = priceLabel;
    
    //隔离带
    UIButton *mainLineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 70 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit)];
    mainLineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    mainLineButton.hidden = YES;
    [_mainDetailView addSubview:mainLineButton];
    [_headerView setHeight:_mainDetailView.bottom];
}


#pragma mark --- 添加分类
- (void)addTitleView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mainDetailView.frame) + 10 * WideEachUnit , MainScreenWidth, 50)];
    WZView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:WZView];
    _WZView = WZView;
    
    NSArray *segmentedArray = @[@"简介",@"课表",@"点评"];
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
//    _mainSegment.momentary = NO;
    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark --- 添加底部的视图
- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit)];
    if (iPhoneX) {
        _downView.frame = CGRectMake(0, MainScreenHeight - 83, MainScreenWidth, 83);
    }
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];

    CGFloat ButtonW = MainScreenWidth / 5;
    CGFloat ButtonH = 50 * WideEachUnit;

    NSArray *titleArray = @[[NSString stringWithFormat:@"育币 %@",[_zhiBoDic stringValueForKey:@""]],@"立即解锁"];
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * ButtonW, SpaceBaside, ButtonW, ButtonH)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.titleLabel.font = Font(14 * WideEachUnit);
        button.tag = i;
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, ButtonW * 2, ButtonH / 2);
            [button setTitleColor:[UIColor colorWithHexString:@"#f01414"] forState:UIControlStateNormal];
            button.titleLabel.font = Font(12 * WideEachUnit);
            _priceButton = button;
        } else if (i == 1) {
            button.backgroundColor = BasidColor;
            button.frame = CGRectMake(3 * ButtonW, 0, ButtonW * 2, ButtonH);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = Font(16 * WideEachUnit);
            [button setTitleColor:[UIColor colorWithHexString:@"#fff"] forState:UIControlStateNormal];
            _buyButton = button;
        }
    }
    
    //添加原价
    UILabel *ordPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, ButtonH / 2, ButtonW * 2, ButtonH / 2)];
    ordPrice.textAlignment = NSTextAlignmentCenter;
    ordPrice.textColor = [UIColor colorWithHexString:@"#888"];
    ordPrice.font = Font(14 * WideEachUnit);
    [_downView addSubview:ordPrice];
    _ordPrice = ordPrice;
    
    //原价
//    [self ordPriceDeal];
    
    _serviceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, 80, 49)];
    _serviceButton.backgroundColor = [UIColor whiteColor];
    [_serviceButton setImage:Image(@"咨询") forState:0];
    [_serviceButton setTitle:@"咨询" forState:0];
    _serviceButton.titleLabel.font = Font(14);
    [_serviceButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:0];
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = _serviceButton.imageView.frame.size.width;
    CGFloat imageHeight = _serviceButton.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = _serviceButton.titleLabel.intrinsicContentSize.width;
        labelHeight = _serviceButton.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = _serviceButton.titleLabel.frame.size.width;
        labelHeight = _serviceButton.titleLabel.frame.size.height;
    }
    _serviceButton.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-0/2.0, 0, 0, -labelWidth);
    _serviceButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-0/2.0, 0);
    [_serviceButton addTarget:self action:@selector(serviceViewClick:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark --- 原价处理
- (void)ordPriceDeal {
    
    _ordPrice.text = [NSString stringWithFormat:@"%@育币",[_zhiBoDic stringValueForKey:@"v_price"]];
    _ordPrice.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_ordPrice.text attributes:attribtDic];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attribtStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_ordPrice.text length])];
    
    // 赋值
    _ordPrice.attributedText = attribtStr;
    
    
    //    //ios 10上不显示横线处理
    //    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //    if ([phoneVersion integerValue] >= 10) {
    //        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //        if ([phoneVersion integerValue] >= 10) {
    //            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:_ordPrice.text];
    //            [attribtStr setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], 　　NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, _ordPrice.text.length)];
    //            　　_ordPrice.attributedText = attribtStr;
    //        }
    //    }
    
}


#pragma mark --- 添加控制器

- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_WZView.frame),  MainScreenWidth, MainScreenHeight * 30 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [_allScrollView addSubview:_controllerSrcollView];
    
    Good_ZhiBoDetailViewController *zhiBoDetailVc= [[Good_ZhiBoDetailViewController alloc] initWithNumID:_ID WithOrderSwitch:_order_switch];
    zhiBoDetailVc.view.frame = CGRectMake(0, 10, MainScreenWidth, MainScreenHeight * 30);
    [self addChildViewController:zhiBoDetailVc];
    [_controllerSrcollView addSubview:zhiBoDetailVc.view];
    
    ZhiBoClassViewController * zhiBoClassVc = [[ZhiBoClassViewController alloc] initWithNumID:_ID];
    zhiBoClassVc.view.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight * 2 + 500);
    [self addChildViewController:zhiBoClassVc];
    [_controllerSrcollView addSubview:zhiBoClassVc.view];
    
     LiveDetailCommentViewController *zhiBoCommentVc = [[LiveDetailCommentViewController alloc] initWithNumID:_ID];
     zhiBoCommentVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight * 2 + 500);
     [self addChildViewController:zhiBoCommentVc];
     [_controllerSrcollView addSubview:zhiBoCommentVc.view];

    _subVcArray = @[zhiBoDetailVc,zhiBoClassVc,zhiBoCommentVc];
    
    [self addDetailBlock];
    [self addClassViewBlock];
    [self addCommentViewBlock];
}

#pragma mark --- 添加Bolck

- (void)addDetailBlock {//注意（因为是第一个 所以要在得到的时候就设定滚动的范围 不然会卡住）
    Good_ZhiBoDetailViewController *vc = _subVcArray[0];
    vc.detailScroll = ^(CGFloat hight) {
        _detailScrollHight = hight;
        _allScrollView.contentSize = CGSizeMake(MainScreenWidth, _detailScrollHight + 370 * WideEachUnit);
        if (iPhoneX) {
            _allScrollView.contentSize = CGSizeMake(MainScreenWidth, _detailScrollHight + 470 * WideEachUnit);
        }
    };
}

- (void)addClassViewBlock {
    ZhiBoClassViewController *vc = _subVcArray[1];
    vc.vcHight = ^(CGFloat hight) {
        _classScrollHight = hight;
    };
}

- (void)addCommentViewBlock {
    LiveDetailCommentViewController *vc = _subVcArray[2];
    vc.getCommentHight = ^(CGFloat commentHight) {
        _commentScrollHight = commentHight;
    };
}

#pragma mark --- 分段

- (void)mainChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            _allScrollView.contentSize = CGSizeMake(MainScreenWidth, _detailScrollHight + 300 * WideEachUnit);
            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth,0);
            _mainSegment.selectedSegmentIndex = 1;
            _allScrollView.contentSize = CGSizeMake(0 , _classScrollHight + CGRectGetMaxY(_WZView.frame));
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            break;
            
        default:
            break;
    }
    
}

#pragma mark --- 滚动试图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
        CGFloat bottomCellOffset = self.headerView.height - MACRO_UI_UPHEIGHT;
        if (scrollView.contentOffset.y > bottomCellOffset - 0.5) {
            _navgationView.backgroundColor = BasidColor;
            _navgationTitle.hidden = NO;
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (UIViewController *vc in self.childViewControllers) {
                    if (self.courseButton.selected) {
                        if ([vc isKindOfClass:[ZhiBoClassViewController class]]) {
                            ZhiBoClassViewController *vccomment = (ZhiBoClassViewController *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.introButton.selected) {
                        if ([vc isKindOfClass:[ZhiboDetailIntroVC class]]) {
                            ZhiboDetailIntroVC *vccomment = (ZhiboDetailIntroVC *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.commentButton.selected) {
                        if ([vc isKindOfClass:[LiveDetailCommentViewController class]]) {
                            LiveDetailCommentViewController *vccomment = (LiveDetailCommentViewController *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                }
            }
        }else{
            _navgationView.backgroundColor = [UIColor clearColor];
            _navgationTitle.hidden = YES;
            if (!self.canScroll) {//子视图没到顶部
                scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }
        }
    }
}

#pragma mark --- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonCilck {
    
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds =YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    //    [app.keyWindow makeKeyAndVisible];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WideEachUnit,55 * WideEachUnit,100 * WideEachUnit,67 * WideEachUnit)];
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    
    NSArray *imageArray = @[@"ico_collect@3x",@"class_share"];
    NSArray *titleArray = @[@"+收藏",@"分享"];
    if ([_collectStr integerValue] == 1) {
        imageArray = @[@"ic_collect_press@3x",@"class_share",@"class_down"];
        titleArray = @[@"-收藏",@"分享"];
    }
    CGFloat ButtonW = 100 * WideEachUnit;
    CGFloat ButtonH = 33 * WideEachUnit;
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0 * WideEachUnit, ButtonH * i, ButtonW, ButtonH)];
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
        button.titleLabel.font = Font(14);
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,0,0,20 * WideEachUnit);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20 * WideEachUnit, 0, 0);
        [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:button];
    }
    
}

- (void)buttonCilck:(UIButton *)button {
    if (button.tag == 0) {//收藏
        if (UserOathToken == nil) {
            [_allWindowView removeFromSuperview];
            DLViewController *DLVC = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        } else {
            [self netWorkVideoCollect];
        }
    } else if (button.tag == 1) {//分享
        [self netWorkVideoGetShareUrl];
    }
    [_allWindowView removeFromSuperview];
}

- (void)SYGCollect {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    if ([_collectStr intValue]==1) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"0" forKey:@"type"];
        [dic setValue:_ID forKey:@"source_id"];
        if (UserOathToken != nil) {
            [dic setObject:UserOathToken forKey:@"oauth_token"];
            [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
        } else {
            [TKProgressHUD showError:@"请先登陆" toView:self.view];
            return;
        }
        
        [manager collectLive:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
            [TKProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
            _collectStr = @"0";
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [TKProgressHUD showError:@"取消收藏失败" toView:self.view];
        }];
    }else if ([_collectStr intValue]==0){
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"1" forKey:@"type"];
        [dic setValue:_ID forKey:@"source_id"];
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
        
        [manager collectLive:dic success:^(AFHTTPRequestOperation *operation, id responseObject){
            [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
            [TKProgressHUD showSuccess:@"收藏成功" toView:self.view];
            _collectStr = @"1";
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [TKProgressHUD showError:@"收藏失败" toView:self.view];
        }];
    }
}



- (void)downButtonClick:(UIButton *)button {
    
    if (button.tag == 0) {//价格
    } else if (button.tag == 1) {//解锁
        if ([_buyButton.titleLabel.text isEqualToString:@"立即解锁"]) {
            if (UserOathToken == nil) {
                DLViewController *DLVC = [[DLViewController alloc] init];
                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
                [self.navigationController presentViewController:Nav animated:YES completion:nil];
                return;
            } else {
                ClassAndLivePayViewController *payVc = [[ClassAndLivePayViewController alloc] init];
                payVc.dict = _zhiBoDic;
                payVc.cid = _ID;
                payVc.typeStr = @"2";
                payVc.activityInfo = [NSDictionary dictionaryWithDictionary:_activityInfo];
                [self.navigationController pushViewController:payVc animated:YES];
            }
        } else if ([_buyButton.titleLabel.text isEqualToString:@"已解锁"]) {
            [TKProgressHUD showError:@"已经解锁过了" toView:self.view];
            return;
        } else if ([_buyButton.titleLabel.text isEqualToString:@"去分享"]) {
            if (SWNOTEmptyDictionary(_activityInfo)) {
                NSDictionary *myActivityInfo;
                if ([[_activityInfo objectForKey:@"user_asb"] isKindOfClass:[NSDictionary class]]) {
                    myActivityInfo = [NSDictionary dictionaryWithDictionary:[_activityInfo objectForKey:@"user_asb"]];
                }
                if (SWNOTEmptyDictionary(myActivityInfo)) {
                    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:[myActivityInfo objectForKey:@"share_url"]];
                    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:[myActivityInfo objectForKey:@"share_url"]];
                    [UMSocialSnsService presentSnsIconSheetView:self
                                                         appKey:@"574e8829e0f55a12f8001790"
                                                      shareText:_zhiBoTitle
                                                     shareImage:shareImageView.image
                                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                                       delegate:self];
                }
            }
        }
    }
}

- (void)LiveShare {
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:_shareLiveUrl];
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:_shareLiveUrl];
    //    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppId secret:SinaAppSecret RedirectURL:_shareLiveUrl];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:_zhiBoTitle
                                     shareImage:shareImageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
    
}

#pragma mark --- 通知
- (void)getDetailScrollHight:(NSNotification *)not {
    NSString *detailSrollHightStr = (NSString *)not.object;
    CGFloat detailSrollHight = [detailSrollHightStr floatValue];
    _detailScrollHight = detailSrollHight;
    _allScrollView.contentSize = CGSizeMake(MainScreenWidth, detailSrollHight + 300 * WideEachUnit);
    if (iPhoneX) {
        _allScrollView.contentSize = CGSizeMake(MainScreenWidth, detailSrollHight + 300 * WideEachUnit + 100 * WideEachUnit);
    }
}

#pragma mark --- 手势添加

- (void)allWindowViewClick:(UITapGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

#pragma mark --- 网络请求
//直播详情
- (void)netWorkLiveGetInfo {
    
    NSString *endUrlStr = YunKeTang_Live_live_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"live_id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret]; 
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (_tableView.isHeaderRefreshing) {
            [_tableView headerEndRefreshing];
        }
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _zhiBoDic = [dict dictionaryValueForKey:@"data"];
            } else {
                _zhiBoDic = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        if ([_zhiBoDic isEqual:[NSArray array]]) {
            return ;
        }
        [self netWorkLiveGetInfo_After];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


#pragma mark --- 网络请求的背后配置
- (void)netWorkLiveGetInfo_After {
    if (SWNOTEmptyDictionary([_zhiBoDic objectForKey:@"school_info"])) {
        _schoolInfo = [NSDictionary dictionaryWithDictionary:[_zhiBoDic objectForKey:@"school_info"]];
    }
    _videoUrl = [_zhiBoDic stringValueForKey:@"cover"];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_videoUrl]];
    _collectStr = [NSString stringWithFormat:@"%@",[_zhiBoDic stringValueForKey:@"is_collect"]];
    
    if ([_collectStr integerValue] == 0) {
        [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
    }else{
        [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
    }
    
    _classTitle.text = [_zhiBoDic stringValueForKey:@"video_title"];
    
    [_classTitle sizeToFit];
    [_classTitle setHeight:_classTitle.height];
    [_mainDetailView setHeight:_classTitle.bottom + 10];
    [_teachersHeaderBackView setTop:_mainDetailView.bottom];
    [_headerView setHeight:_teachersHeaderBackView.bottom];
    
    _ordPrice.text = [NSString stringWithFormat:@"在学%@人",[_zhiBoDic stringValueForKey:@"video_order_count"]];
    if ([_order_switch integerValue] == 1) {
        _ordPrice.text = [NSString stringWithFormat:@"在学%@人",[_zhiBoDic stringValueForKey:@"video_order_count_mark"]];
    }
    _priceLabel.text = [NSString stringWithFormat:@"育币%@",[_zhiBoDic stringValueForKey:@"price"]];
    NSString *nowPrice = [NSString stringWithFormat:@"育币 %@",[_zhiBoDic stringValueForKey:@"price"]];
    if (SWNOTEmptyDictionary(_activityInfo)) {
        NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        if ([eventType integerValue] == 6) {
            nowPrice = [NSString stringWithFormat:@"育币 %@",[[_zhiBoDic objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
        }
    }
    NSString *oldPrice = [NSString stringWithFormat:@"育币%@",[_zhiBoDic stringValueForKey:@"v_price"]];
    if ([[_zhiBoDic stringValueForKey:@"price"] floatValue] == 0) {
        nowPrice = @"免费";
        _priceLabel.text = @"免费";
        _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
    }
    NSString *priceFina = [NSString stringWithFormat:@"%@ %@",nowPrice,oldPrice];
    NSRange rangNow = [priceFina rangeOfString:nowPrice];
    NSRange rangOld = [priceFina rangeOfString:oldPrice];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceFina];
    if ([[_zhiBoDic stringValueForKey:@"price"] floatValue] == 0) {
        [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#47b37d"]} range:rangNow];
    } else {
        [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#f01414"]} range:rangNow];
    }
    [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888"]} range:rangOld];
    [_priceButton setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:priceAtt] forState:0];
    _ordPrice.centerX = _priceButton.centerX;
    NSString *numstr = [NSString stringWithFormat:@"%@",[_zhiBoDic stringValueForKey:@"is_buy"]];
    if ([numstr isEqualToString:@"1"]) {
        [_buyButton setTitle:@"已解锁" forState:UIControlStateNormal];
    }
//    [self ordPriceDeal];//处理原价
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 * HigtEachUnit - MACRO_UI_UPHEIGHT;
    [self changeEventPriceUI];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];
    [self netWorkTeacherGetInfo];
}

// MARK: - 获取讲师详情
- (void)netWorkTeacherGetInfo {
    if (!SWNOTEmptyDictionary(_zhiBoDic)) {
        return;
    }
    NSString *endUrlStr = YunKeTang_Teacher_teacher_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_zhiBoDic objectForKey:@"teacher_id"] forKey:@"teacher_id"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict =  [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _teacherInfoDict = [dict dictionaryValueForKey:@"data"];
            } else {
                _teacherInfoDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        // headimg
        [self setTeacherAndOrganizationData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//课程收藏
- (void)netWorkVideoCollect {
    
    NSString *endUrlStr = YunKeTang_Video_video_collect;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"2" forKey:@"sctype"];
    if ([_collectStr integerValue] == 1) {//已经收藏（为取消收藏操作）
        [mutabDict setValue:@"0" forKey:@"type"];
    } else {//没有收藏 （为收藏操作）
        [mutabDict setValue:@"1" forKey:@"type"];
    }
    [mutabDict setValue:_ID forKey:@"source_id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
//        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    } else {
        [TKProgressHUD showError:@"请先去登陆" toView:self.view];
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            if ([_collectStr integerValue] == 1) {
                _collectStr = @"0";
                [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
            } else {
                _collectStr = @"1";
                [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取课程分享的链接
- (void)netWorkVideoGetShareUrl {
    
    NSString *endUrlStr = YunKeTang_Video_video_getShareUrl;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"2" forKey:@"type"];
    [mutabDict setObject:_ID forKey:@"vid"];
    if (_schoolID) {
        [mutabDict setObject:_schoolID forKey:@"mhm_id"];
    }
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _shareLiveUrl = [dict stringValueForKey:@"share_url"];
            [self LiveShare];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//配置客服按钮
- (void)netWorkGetThirdServiceUrl {
    
    NSString *endUrlStr = YunKeTang_Basic_Basic_getThirdServiceUrl;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"5" forKey:@"count"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (oath_token_Str != nil) {
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _serviceDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([_serviceDict isKindOfClass:[NSArray class]]) {
        } else {
            if ([[_serviceDict stringValueForKey:@"is_open"] integerValue] == 1) {//重新加载一次
                _serviceButton.hidden = NO;
                _serviceButton.center = CGPointMake(MainScreenWidth * 2 / 5.0, 1 + 49 * HigtEachUnit / 2.0);
                [_serviceButton setRight:_buyButton.left];
//                [_buyButton setMj_x:_serviceButton.right];
//                [_buyButton setWidth:MainScreenWidth - _serviceButton.right];
                [_downView addSubview:_serviceButton];
            } else {
                _serviceButton.hidden = YES;
                [_priceButton setWidth:MainScreenWidth * 3 / 5.0];
                _ordPrice.centerX = _priceButton.centerX;
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)serviceViewClick:(UIButton *)ges {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlString = [NSString stringWithFormat:@"%@",[_serviceDict stringValueForKey:@"url"]];
    vc.titleString = @"客服";
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 活动版块儿UI
- (void)makeActivityUI {
    // 判断是不是有活动以及活动的类型并根据活动类型显示x对应的ui(也可以先布局再显示或者隐藏)
    if (_activityBackView == nil) {
        _activityBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 44)];
        _activityBackView.backgroundColor = RGBHex(0xE02620);
        [_activityBackView setTop:_imageView.bottom];
        [_headerView addSubview:_activityBackView];
        if (!SWNOTEmptyDictionary(_activityInfo)) {
            [_activityBackView setHeight:0];
            _activityBackView.hidden = YES;
        }
        
        _leftPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 0, MainScreenWidth / 2.0, 44)];
        _leftPriceLabel.textColor = [UIColor whiteColor];
        [_activityBackView addSubview:_leftPriceLabel];
        
        _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 33 - 20, 10, 33, 33)];
        _rightIcon.image = Image(@"闪电");
        [_activityBackView addSubview:_rightIcon];
        
        _rightTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rightIcon.left - 1 - 127, 0, 127, 25)];
        _rightTimeLabel.font = SYSTEMFONT(11);
        _rightTimeLabel.textColor = RGBHex(0xFAEF00);
        /// 距开售22小时:14分:17秒 限量抢购(25/60)
        _rightTimeLabel.text = @"距结束22小时:14分:17秒";
        _rightTimeLabel.textAlignment = NSTextAlignmentRight;
        [_activityBackView addSubview:_rightTimeLabel];
        
        _rightTimeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_rightTimeLabel.left - 12 - 6, 0, 12, 12)];
        _rightTimeIcon.image = Image(@"discount");
        _rightTimeIcon.centerY = _rightTimeLabel.centerY;
        [_activityBackView addSubview:_rightTimeIcon];
        
        _progressView = [[LBHProgressView alloc] initWithFrame:CGRectMake(_rightTimeLabel.right - 104, _rightTimeLabel.bottom, 104, 15)];
        _progressView.backgroundColor = RGBHex(0xF0BF1A);
        _progressView.progressTintColor = RGBHex(0xFAEF00);
        _progressView.trackTintColor = RGBHex(0xF0BF1A);
        [_progressView setProgress:0.65];
        _progressView.progressViewStyle = GGProgressViewStyleAllFillet;
        [_activityBackView addSubview:_progressView];
        
        _rightYellowLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rightTimeLabel.right - 104, _rightTimeLabel.bottom, 104, 15)];
        _rightYellowLabel.font = SYSTEMFONT(10);
        _rightYellowLabel.textColor = RGBHex(0xF12026);
        _rightYellowLabel.textAlignment = NSTextAlignmentCenter;
        _rightYellowLabel.layer.masksToBounds = YES;
        _rightYellowLabel.layer.cornerRadius = 3;
        _rightYellowLabel.text = @"已抢65%";
        [_activityBackView addSubview:_rightYellowLabel];
        _progressView.centerY = _rightYellowLabel.centerY;
        
        _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rightYellowLabel.left - 6 - 37, 0, 37, 12)];
        _discountLabel.font = SYSTEMFONT(10);
        _discountLabel.textColor = RGBHex(0xFAEF00);
        _discountLabel.layer.masksToBounds = YES;
        _discountLabel.layer.borderColor = RGBHex(0xFAEF00).CGColor;
        _discountLabel.layer.borderWidth = 0.5;
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.text = @"8.8折";
        _discountLabel.centerY = _rightYellowLabel.centerY;
        [_activityBackView addSubview:_discountLabel];
        
        /// 售罄后视图
        /**
         _activityEndLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 234 * WideEachUnit, 44)];
         _activityEndLeftView.backgroundColor = RGBHex(0xCFCFCF);
         [_activityBackView addSubview:_activityEndLeftView];
         
         _leftPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 0, MainScreenWidth / 2.0, 44)];
         _leftPriceLabel.textColor = [UIColor whiteColor];
         [_activityBackView addSubview:_leftPriceLabel];
         
         _activityEndRightView = [[UIView alloc] initWithFrame:CGRectMake(_activityEndLeftView.right, 0, MainScreenWidth - _activityEndLeftView.width, 44)];
         _activityEndRightView.backgroundColor = RGBHex(0xAAAAAA);
         [_activityBackView addSubview:_activityEndRightView];
         
         _activityEndLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - (39+37)*WideEachUnit, 0, (39+37)*WideEachUnit, 44)];
         _activityEndLabel.textAlignment = NSTextAlignmentLeft;
         _activityEndLabel.textColor = [UIColor whiteColor];
         _activityEndLabel.text = @"已售罄";
         [_activityBackView addSubview:_activityEndLabel];
         
         _activityEndrightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_activityEndLabel.left - 10 - 42*WideEachUnit, 0, 42*WideEachUnit, 38*HigtEachUnit)];
         _activityEndrightIcon.centerY = _activityEndLabel.centerY;
         [_activityBackView addSubview:_activityEndrightIcon];
         */
    }
    _leftPriceLabel.font = SYSTEMFONT(13);
    _leftPriceLabel.textColor = [UIColor whiteColor];
    NSString *activityType = @"限时打折";
    NSString *priceCount = @"育币963";
    NSString *discount = @"育币1000";
    NSString *leftPrice = [NSString stringWithFormat:@"%@%@%@",activityType,priceCount,discount];
    NSRange activityTypeRange = [leftPrice rangeOfString:activityType];
    NSRange priceRange = [leftPrice rangeOfString:priceCount];
    NSRange discountRange = [leftPrice rangeOfString:discount];
    NSMutableAttributedString *muta = [[NSMutableAttributedString alloc] initWithString:leftPrice];
    [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(19)} range:priceRange];
    [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(10),NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor whiteColor]} range:discountRange];
    _leftPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:muta];
}

// MARK: - 为活动详情ui赋值
- (void)setActivityData {
    if (SWNOTEmptyDictionary(_activityInfo)) {
        _activityBackView.hidden = NO;
        [_activityBackView setHeight:44];
        [_activityBackView setTop:_imageView.bottom];
        [_mainDetailView setTop:_activityBackView.bottom];
        [_teachersHeaderBackView setTop:_mainDetailView.bottom];
        [_headerView setHeight:_teachersHeaderBackView.bottom];
        NSString *activityType = @"";
        NSString *priceCount = @"";
        NSString *discount = @"";
        if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
            activityType = [[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"text"];
        } else {
            activityType = @"即将开售";
        }
        
        if (SWNOTEmptyDictionary(_zhiBoDic)) {
            priceCount = [NSString stringWithFormat:@"%@",[[_zhiBoDic objectForKey:@"mz_price"] objectForKey:@"eprice"]];
            discount = [NSString stringWithFormat:@"%@",[[_zhiBoDic objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
            NSString *nowPrice = [NSString stringWithFormat:@"育币 %@",[_zhiBoDic stringValueForKey:@"price"]];
            NSString *oldPrice = [NSString stringWithFormat:@"育币%@",[_zhiBoDic stringValueForKey:@"v_price"]];
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                oldPrice = discount;
            }
            if ([[_zhiBoDic stringValueForKey:@"price"] floatValue] == 0) {
                nowPrice = @"免费";
            }
            NSString *priceFina = [NSString stringWithFormat:@"%@ %@",nowPrice,oldPrice];
            NSRange rangNow = [priceFina rangeOfString:nowPrice];
            NSRange rangOld = [priceFina rangeOfString:oldPrice];
            NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceFina];
            if ([[_zhiBoDic stringValueForKey:@"price"] floatValue] == 0) {
                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#47b37d"]} range:rangNow];
            } else {
                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#f01414"]} range:rangNow];
            }
            [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888"]} range:rangOld];
            [_priceButton setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:priceAtt] forState:0];
        }
        
        NSString *leftPrice = [NSString stringWithFormat:@"%@%@%@",activityType,priceCount,discount];
        NSRange priceRange = [leftPrice rangeOfString:priceCount];
        NSRange discountRange = [leftPrice rangeOfString:discount];
        NSMutableAttributedString *muta = [[NSMutableAttributedString alloc] initWithString:leftPrice];
        [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(19)} range:priceRange];
        [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(10),NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor whiteColor]} range:discountRange];
        _leftPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:muta];
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a= [dat timeIntervalSince1970];
        NSString *etime = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"end_time"]];
        NSString *stime = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"start_time"]];
        NSString *spanTime = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"timespan"]];
        eventTime = [spanTime integerValue];
        [eventTimer invalidate];
        eventTimer = nil;
        
        _discountLabel.hidden = YES;
        // 限时还是限量
        NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        [_progressView setProgress:0];
        // 1 限时打折 2 抢购(不限时不限量) 3 限量秒杀(不限时) 4 限时抢购(不限量) 5 秒杀(限时限量)
        if ([eventType integerValue] == 1) {
            _discountLabel.hidden = NO;
            _discountLabel.text = [NSString stringWithFormat:@"%@折",[_activityInfo objectForKey:@"discount"]];
            _rightTimeIcon.image = Image(@"discount");
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                _rightTimeLabel.text = [NSString stringWithFormat:@"距结束%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[spanTime integerValue]]];
            } else {
                _rightTimeLabel.text = [NSString stringWithFormat:@"距开售%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[spanTime integerValue]]];
            }
            eventTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eventTimerDown) userInfo:nil repeats:YES];
        } else if ([eventType integerValue] == 2) {
            _rightTimeIcon.image = Image(@"fire");
            if (eventTime>0) {
                if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                    _rightTimeLabel.text = [NSString stringWithFormat:@"距结束%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[spanTime integerValue]]];
                } else {
                    _rightTimeLabel.text = [NSString stringWithFormat:@"距开售%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[spanTime integerValue]]];
                }
                eventTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eventTimerDown) userInfo:nil repeats:YES];
            } else {
                _rightTimeLabel.text = @"长期活动";
            }
        } else if ([eventType integerValue] == 3) {
            _rightTimeIcon.image = Image(@"fire");
            _rightTimeLabel.text = [NSString stringWithFormat:@"限量抢购(%@/%@)",[_activityInfo objectForKey:@"rest_count"],[_activityInfo objectForKey:@"total_count"]];
        } else if ([eventType integerValue] == 4) {
            _rightTimeIcon.image = Image(@"fire");
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                _rightTimeLabel.text = [NSString stringWithFormat:@"距结束%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[spanTime integerValue]]];
            } else {
                _rightTimeLabel.text = [NSString stringWithFormat:@"距开售%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[spanTime integerValue]]];
            }
            eventTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eventTimerDown) userInfo:nil repeats:YES];
        } else if ([eventType integerValue] == 5) {
            _rightTimeIcon.image = Image(@"timer");
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                _rightTimeLabel.text = [NSString stringWithFormat:@"距结束%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[spanTime integerValue]]];
            } else {
                _rightTimeLabel.text = [NSString stringWithFormat:@"距开售%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[spanTime integerValue]]];
            }
            eventTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eventTimerDown) userInfo:nil repeats:YES];
        }
        
        if ([eventType integerValue] == 3 || [eventType integerValue] == 5) {
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                [_progressView setProgress:[[_activityInfo objectForKey:@"rest_count"] integerValue] / [[_activityInfo objectForKey:@"total_count"] integerValue] * 1.0];
                _rightYellowLabel.text = [NSString stringWithFormat:@"已抢%@",[_activityInfo objectForKey:@"progress"]];
            } else {
                [_progressView setProgress:0];
                _rightYellowLabel.text = @"即将开售";
            }
        } else {
            [_progressView setProgress:0];
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                _rightYellowLabel.text = [NSString stringWithFormat:@"%@人已参与",@([[_activityInfo objectForKey:@"rest_count"] integerValue])];
            } else {
                _rightYellowLabel.text = @"即将开售";
            }
        }
        
        CGFloat widthRight = [_rightTimeLabel.text sizeWithFont:_rightTimeLabel.font].width + 4;
        [_rightTimeLabel setWidth:widthRight];
        [_rightTimeLabel setRight:_rightIcon.left];
        [_rightTimeIcon setRight:_rightTimeLabel.left];
        
        self.tableView.tableHeaderView = self.headerView;
        [self.tableView reloadData];
    }
}

- (void)changeEventPriceUI {
    if (SWNOTEmptyDictionary(_zhiBoDic) && SWNOTEmptyDictionary(_activityInfo)) {
        NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        if ([eventType integerValue] == 6) {
            NSString *activityType = @"";
            NSString *priceCount = @"";
            NSString *discount = @"";
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                activityType = [[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"text"];
            } else {
                activityType = @"即将开售";
            }
            if (SWNOTEmptyDictionary(_zhiBoDic)) {
                priceCount = [NSString stringWithFormat:@"%@育币",[[_zhiBoDic objectForKey:@"mz_price"] objectForKey:@"eprice"]];
                discount = [NSString stringWithFormat:@"%@育币",[[_zhiBoDic objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
                NSString *nowPrice = [NSString stringWithFormat:@"育币 %@",[_zhiBoDic stringValueForKey:@"price"]];
                NSString *oldPrice = [NSString stringWithFormat:@"育币%@",[_zhiBoDic stringValueForKey:@"v_price"]];
                if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                    oldPrice = discount;
                }
                if ([[_zhiBoDic stringValueForKey:@"price"] floatValue] == 0) {
                    nowPrice = @"免费";
                }
                NSString *priceFina = [NSString stringWithFormat:@"%@ %@",nowPrice,oldPrice];
                NSRange rangNow = [priceFina rangeOfString:nowPrice];
                NSRange rangOld = [priceFina rangeOfString:oldPrice];
                NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceFina];
                if ([[_zhiBoDic stringValueForKey:@"price"] floatValue] == 0) {
                    [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#47b37d"]} range:rangNow];
                } else {
                    [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#f01414"]} range:rangNow];
                }
                [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888"]} range:rangOld];
                [_priceButton setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:priceAtt] forState:0];
            }
            
            NSString *leftPrice = [NSString stringWithFormat:@"%@%@%@",activityType,priceCount,discount];
            NSRange priceRange = [leftPrice rangeOfString:priceCount];
            NSRange discountRange = [leftPrice rangeOfString:discount];
            NSMutableAttributedString *muta = [[NSMutableAttributedString alloc] initWithString:leftPrice];
            [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(19)} range:priceRange];
            [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(10),NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor whiteColor]} range:discountRange];
            _otherLeftPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:muta];
            if ([[_zhiBoDic objectForKey:@"is_buy"] integerValue] == 1) {
                [_otherActivityBackView setHeight:0];
                _otherActivityBackView.hidden = YES;
                [_otherActivityBackView setTop:_imageView.bottom];
                [_mainDetailView setTop:_otherActivityBackView.bottom];
                [_teachersHeaderBackView setTop:_mainDetailView.bottom];
                [_headerView setHeight:_teachersHeaderBackView.bottom];
                [eventTimer invalidate];
                eventTimer = nil;
            }
            [self setJoinGroupActivityInfoData];
        } else {
            NSString *activityType = @"";
            NSString *priceCount = @"";
            NSString *discount = @"";
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                activityType = [[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"text"];
            } else {
                activityType = @"即将开售";
            }
            if (SWNOTEmptyDictionary(_zhiBoDic)) {
                priceCount = [NSString stringWithFormat:@"%@",[[_zhiBoDic objectForKey:@"mz_price"] objectForKey:@"eprice"]];
                discount = [NSString stringWithFormat:@"%@",[[_zhiBoDic objectForKey:@"mz_price"] objectForKey:@"oriPrice"]];
            }
            NSString *leftPrice = [NSString stringWithFormat:@"%@%@%@",activityType,priceCount,discount];
            NSRange priceRange = [leftPrice rangeOfString:priceCount];
            NSRange discountRange = [leftPrice rangeOfString:discount];
            NSMutableAttributedString *muta = [[NSMutableAttributedString alloc] initWithString:leftPrice];
            [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(19)} range:priceRange];
            [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(10),NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor whiteColor]} range:discountRange];
            _leftPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:muta];
        }
    }
}

- (void)eventTimerDown {
    eventTime--;
    if (eventTime<=0) {
        [self getCourceActivityInfo];
        [eventTimer invalidate];
        eventTimer = nil;
    } else {
        NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
        if ([eventType integerValue] == 6) {
            NSDictionary *myActivityInfo;
            if ([[_activityInfo objectForKey:@"user_asb"] isKindOfClass:[NSDictionary class]]) {
                myActivityInfo = [NSDictionary dictionaryWithDictionary:[_activityInfo objectForKey:@"user_asb"]];
            }
            if (SWNOTEmptyDictionary(myActivityInfo)) {
                _otherRightTimeLabel.text = [NSString stringWithFormat:@"距结束%@",[YunKeTang_Api_Tool timeChangeWithSeconds:eventTime]];
            } else {
                if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                    _otherRightTimeLabel.text = [NSString stringWithFormat:@"距结束%@",[YunKeTang_Api_Tool timeChangeWithSeconds:eventTime]];
                } else {
                    _otherRightTimeLabel.text = [NSString stringWithFormat:@"距开售%@",[YunKeTang_Api_Tool timeChangeWithSeconds:eventTime]];
                }
            }
        } else {
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                _rightTimeLabel.text = [NSString stringWithFormat:@"距结束%@",[YunKeTang_Api_Tool timeChangeWithSeconds:eventTime]];
            } else {
                _rightTimeLabel.text = [NSString stringWithFormat:@"距开售%@",[YunKeTang_Api_Tool timeChangeWithSeconds:eventTime]];
            }
        }
        
    }
}

- (void)makeGroupBuyUI {
    if (_otherActivityBackView == nil) {
        _otherActivityBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 44)];
        _otherActivityBackView.backgroundColor = RGBHex(0xE02620);
        [_otherActivityBackView setTop:_imageView.bottom];
        [_headerView addSubview:_otherActivityBackView];
        if (!SWNOTEmptyDictionary(_activityInfo)) {
            [_otherActivityBackView setHeight:0];
            _otherActivityBackView.hidden = YES;
        }
        
        _otherLeftPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 0, MainScreenWidth / 2.0, 44)];
        _otherLeftPriceLabel.textColor = [UIColor whiteColor];
        [_otherActivityBackView addSubview:_otherLeftPriceLabel];
        
        _otherBuyProgressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_otherLeftPriceLabel.left, _otherLeftPriceLabel.bottom, 10, 10)];
        _otherBuyProgressLabel.textColor = [UIColor whiteColor];
        _otherBuyProgressLabel.font = SYSTEMFONT(10);
        [_otherActivityBackView addSubview:_otherBuyProgressLabel];
        _otherBuyProgressLabel.hidden = YES;
        
        _otherProgressView = [[LBHProgressView alloc] initWithFrame:CGRectMake(_otherBuyProgressLabel.right + 8, 0, 104, 15)];
        _otherProgressView.backgroundColor = RGBHex(0xF0BF1A);
        _otherProgressView.progressTintColor = RGBHex(0xFAEF00);
        _otherProgressView.trackTintColor = RGBHex(0xF0BF1A);
        [_otherProgressView setProgress:0.65];
        _otherProgressView.progressViewStyle = GGProgressViewStyleAllFillet;
        _otherProgressView.centerY = _otherBuyProgressLabel.centerY;
        [_otherActivityBackView addSubview:_otherProgressView];
        _otherProgressView.hidden = YES;
        
        _otherRightTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 127 - 10, 0, 127, 13)];
        _otherRightTimeLabel.font = SYSTEMFONT(11);
        _otherRightTimeLabel.textColor = RGBHex(0xFAEF00);
        /// 距开售22小时:14分:17秒 限量抢购(25/60)
        _otherRightTimeLabel.text = @"距结束22小时:14分:17秒";
        _otherRightTimeLabel.textAlignment = NSTextAlignmentRight;
        [_otherActivityBackView addSubview:_otherRightTimeLabel];
        
        _otherRightTimeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_otherRightTimeLabel.left - 12 - 6, 0, 12, 12)];
        _otherRightTimeIcon.image = Image(@"timer");
        _otherRightTimeIcon.centerY = _otherRightTimeLabel.centerY;
        [_otherActivityBackView addSubview:_otherRightTimeIcon];
        
        _otherStarBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 20 - 80, (_otherActivityBackView.height - 30) / 2.0, 80, 30)];
        [_otherStarBtn setTitle:@"开团" forState:0];
        [_otherStarBtn setTitleColor:RGBHex(0xF12026) forState:0];
        _otherStarBtn.backgroundColor = RGBHex(0xFBF259);
        _otherStarBtn.titleLabel.font = SYSTEMFONT(13);
        _otherStarBtn.layer.masksToBounds = YES;
        _otherStarBtn.layer.cornerRadius = 3;
        [_otherStarBtn addTarget:self action:@selector(starGroupActivity) forControlEvents:UIControlEventTouchUpInside];
        [_otherActivityBackView addSubview:_otherStarBtn];
        [_otherStarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_otherJoinIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        _otherJoinIcon = [[UIButton alloc] initWithFrame:CGRectMake(_otherStarBtn.left - 80 - 10, (_otherActivityBackView.height - 30) / 2.0, 80, 30)];
        [_otherJoinIcon setTitle:@"参团" forState:0];
        [_otherJoinIcon setTitleColor:RGBHex(0xF12026) forState:0];
        _otherJoinIcon.backgroundColor = RGBHex(0xFBF259);
        _otherJoinIcon.titleLabel.font = SYSTEMFONT(13);
        _otherJoinIcon.layer.masksToBounds = YES;
        _otherJoinIcon.layer.cornerRadius = 3;
        [_otherJoinIcon addTarget:self action:@selector(joinGroupActivity) forControlEvents:UIControlEventTouchUpInside];
        [_otherActivityBackView addSubview:_otherJoinIcon];
        
        _otherGroupBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 20 - 100, (_otherActivityBackView.height - 30) / 2.0, 100, 30)];
        [_otherGroupBuyBtn setTitle:@"好友助力" forState:0];
        [_otherGroupBuyBtn setTitleColor:RGBHex(0xF12026) forState:0];
        _otherGroupBuyBtn.backgroundColor = RGBHex(0xFBF259);
        _otherGroupBuyBtn.titleLabel.font = SYSTEMFONT(13);
        _otherGroupBuyBtn.layer.masksToBounds = YES;
        _otherGroupBuyBtn.layer.cornerRadius = 3;
        [_otherGroupBuyBtn addTarget:self action:@selector(bargainOrFriendHelpClick) forControlEvents:UIControlEventTouchUpInside];
        [_otherActivityBackView addSubview:_otherGroupBuyBtn];
        _otherGroupBuyBtn.hidden = YES;
    }
}

// MARK: - 处理拼团等活动的数据
- (void)setJoinGroupActivityInfoData {
    if (SWNOTEmptyDictionary(_activityInfo)) {
        _otherActivityBackView.hidden = NO;
        [_otherActivityBackView setHeight:44];
        [_otherActivityBackView setTop:_imageView.bottom];
        [_mainDetailView setTop:_otherActivityBackView.bottom];
        [_teachersHeaderBackView setTop:_mainDetailView.bottom];
        [_headerView setHeight:_teachersHeaderBackView.bottom];
        
        _otherRightTimeIcon.hidden = NO;
        _otherStarBtn.enabled = YES;
        _otherJoinIcon.enabled = YES;
        [_otherStarBtn setBackgroundColor:RGBHex(0xFBF259)];
        [_otherJoinIcon setBackgroundColor:RGBHex(0xFBF259)];

        NSString *activityType = @"";
        NSString *priceCount = @"";
        NSString *discount = @"";
        if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
            activityType = [[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"text"];
        } else {
            activityType = @"即将开售";
        }
        if (SWNOTEmptyDictionary(_zhiBoDic)) {
            priceCount = [NSString stringWithFormat:@"%@育币",[[_zhiBoDic objectForKey:@"mz_price"] objectForKey:@"eprice"]];
            discount = [NSString stringWithFormat:@"%@育币",[[_zhiBoDic objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
            NSString *nowPrice = [NSString stringWithFormat:@"育币 %@",[_zhiBoDic stringValueForKey:@"price"]];
            NSString *oldPrice = [NSString stringWithFormat:@"育币%@",[_zhiBoDic stringValueForKey:@"v_price"]];
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                oldPrice = discount;
            }
            if ([[_zhiBoDic stringValueForKey:@"price"] floatValue] == 0) {
                nowPrice = @"免费";
            }
            NSString *priceFina = [NSString stringWithFormat:@"%@ %@",nowPrice,oldPrice];
            NSRange rangNow = [priceFina rangeOfString:nowPrice];
            NSRange rangOld = [priceFina rangeOfString:oldPrice];
            NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceFina];
            if ([[_zhiBoDic stringValueForKey:@"price"] floatValue] == 0) {
                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#47b37d"]} range:rangNow];
            } else {
                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#f01414"]} range:rangNow];
            }
            [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888"]} range:rangOld];
            [_priceButton setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:priceAtt] forState:0];
        }
        
        NSString *leftPrice = [NSString stringWithFormat:@"%@%@%@",activityType,priceCount,discount];
        NSRange priceRange = [leftPrice rangeOfString:priceCount];
        NSRange discountRange = [leftPrice rangeOfString:discount];
        NSMutableAttributedString *muta = [[NSMutableAttributedString alloc] initWithString:leftPrice];
        [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(19)} range:priceRange];
        [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(10),NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor whiteColor]} range:discountRange];
        _otherLeftPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:muta];
        
        
        NSString *spanTime = [NSString stringWithFormat:@"%@",[_activityInfo objectForKey:@"timespan"]];
        eventTime = [spanTime integerValue];
        [eventTimer invalidate];
        eventTimer = nil;
        
        [_otherProgressView setProgress:0];
        _rightTimeIcon.image = Image(@"timer");
        if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
            _otherRightTimeLabel.text = [NSString stringWithFormat:@"距结束%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[spanTime integerValue]]];
        } else {
            _otherRightTimeLabel.text = [NSString stringWithFormat:@"距开售%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[spanTime integerValue]]];
        }
        eventTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(eventTimerDown) userInfo:nil repeats:YES];
        NSDictionary *myActivityInfo;
        if ([[_activityInfo objectForKey:@"user_asb"] isKindOfClass:[NSDictionary class]]) {
            myActivityInfo = [NSDictionary dictionaryWithDictionary:[_activityInfo objectForKey:@"user_asb"]];
        }
        if (SWNOTEmptyDictionary(myActivityInfo)) {
            if ([[myActivityInfo objectForKey:@"is_refund"] integerValue] == 1) {
                // 不显示
                [_otherActivityBackView setHeight:0];
                _otherActivityBackView.hidden = YES;
                [_otherActivityBackView setTop:_imageView.bottom];
                [_mainDetailView setTop:_otherActivityBackView.bottom];
                [_teachersHeaderBackView setTop:_mainDetailView.bottom];
                [_headerView setHeight:_teachersHeaderBackView.bottom];
                [eventTimer invalidate];
                eventTimer = nil;
                return;
            }
            NSString *myActivityLimitTime = [NSString stringWithFormat:@"%@",[myActivityInfo objectForKey:@"timespan"]];
            eventTime = [myActivityLimitTime integerValue];
            _otherRightTimeLabel.text = [NSString stringWithFormat:@"距结束%@",[YunKeTang_Api_Tool timeChangeWithSeconds:[myActivityLimitTime integerValue]]];
            [_otherRightTimeLabel setTop:7];
            _otherRightTimeIcon.centerY = _otherRightTimeLabel.centerY;
            _otherProgressView.hidden = NO;
            _otherBuyProgressLabel.hidden = NO;
            _otherBuyProgressLabel.text = [NSString stringWithFormat:@"参与团购(%@/%@)人",[myActivityInfo objectForKey:@"join_count"],[myActivityInfo objectForKey:@"total_count"]];
            NSString *joinCount = [NSString stringWithFormat:@"%@",[myActivityInfo objectForKey:@"join_count"]];
            NSString *totalCount = [NSString stringWithFormat:@"%@",[myActivityInfo objectForKey:@"total_count"]];
            [_otherProgressView setProgress:[joinCount floatValue] / [totalCount floatValue]];
            _otherJoinIcon.hidden = YES;
            _otherStarBtn.hidden = YES;
            [_otherBuyProgressLabel setTop:_otherActivityBackView.height - 16];
            CGFloat otherBuyProgressLabelWidth = [_otherBuyProgressLabel.text sizeWithFont:_otherBuyProgressLabel.font].width + 2;
            [_otherBuyProgressLabel setWidth:otherBuyProgressLabelWidth];
            [_otherProgressView setRight:_otherStarBtn.right];
            [_otherBuyProgressLabel setRight:_otherProgressView.left - 8];
            _otherProgressView.centerY = _otherBuyProgressLabel.centerY;
            if ([[myActivityInfo objectForKey:@"faild"] integerValue] == 1) {
                // 团购失败
                [_otherRightTimeLabel setTop:0];
                _otherRightTimeLabel.text = @"拼团失败,退款中...";
                _otherRightTimeIcon.centerY = _otherRightTimeLabel.centerY;
                _otherRightTimeIcon.hidden = YES;
                _otherProgressView.hidden = YES;
                _otherBuyProgressLabel.hidden = YES;
                _otherJoinIcon.hidden = NO;
                _otherStarBtn.hidden = NO;
                
                [_otherJoinIcon setHeight:20];
                [_otherStarBtn setHeight:20];
                [_otherStarBtn setTop:_otherRightTimeLabel.bottom + 5.5];
                [_otherJoinIcon setTop:_otherRightTimeLabel.bottom + 5.5];
                _otherStarBtn.enabled = NO;
                _otherJoinIcon.enabled = NO;
                [_otherStarBtn setBackgroundColor:RGBHex(0xC0C0C0)];
                [_otherJoinIcon setBackgroundColor:RGBHex(0xC0C0C0)];
                [eventTimer invalidate];
                eventTimer = nil;
            } else {
                [_buyButton setTitle:@"去分享" forState:0];
            }
        } else {
            [_otherRightTimeLabel setTop:0];
            _otherRightTimeIcon.centerY = _otherRightTimeLabel.centerY;
            _otherProgressView.hidden = YES;
            _otherBuyProgressLabel.hidden = YES;
            _otherJoinIcon.hidden = NO;
            _otherStarBtn.hidden = NO;
            
            [_otherJoinIcon setHeight:20];
            [_otherStarBtn setHeight:20];
            [_otherStarBtn setTop:_otherRightTimeLabel.bottom + 5.5];
            [_otherJoinIcon setTop:_otherRightTimeLabel.bottom + 5.5];
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 0) {
                _otherJoinIcon.hidden = YES;
                _otherStarBtn.hidden = YES;
                _otherRightTimeLabel.centerY = _otherLeftPriceLabel.centerY;
                _otherRightTimeIcon.centerY = _otherLeftPriceLabel.centerY;
            } else {
                _otherJoinIcon.hidden = NO;
                _otherStarBtn.hidden = NO;
                [_otherRightTimeLabel setTop:SWNOTEmptyDictionary(myActivityInfo) ? 7 : 0];
                _otherRightTimeIcon.centerY = _otherRightTimeLabel.centerY;
            }
        }
        
        CGFloat widthRight = [_otherRightTimeLabel.text sizeWithFont:_otherRightTimeLabel.font].width + 4;
        [_otherRightTimeLabel setWidth:widthRight];
        [_otherRightTimeLabel setRight:_otherStarBtn.right];
        [_otherRightTimeIcon setRight:_otherRightTimeLabel.left];
        
    }
    if ([[_zhiBoDic objectForKey:@"is_buy"] integerValue] == 1) {
        [_otherActivityBackView setHeight:0];
        _otherActivityBackView.hidden = YES;
        [_otherActivityBackView setTop:_imageView.bottom];
        [_mainDetailView setTop:_otherActivityBackView.bottom];
        [_teachersHeaderBackView setTop:_mainDetailView.bottom];
        [_headerView setHeight:_teachersHeaderBackView.bottom];
        [eventTimer invalidate];
        eventTimer = nil;
    }
}

// MARK: - 参团
- (void)joinGroupActivity {
    if (!UserOathToken) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
        
    } else {
        [TKProgressHUD showError:@"活动还未开始" toView:self.view];
        return;
    }
    GroupListPopViewController *vc = [[GroupListPopViewController alloc] init];
    vc.activityInfo = [NSDictionary dictionaryWithDictionary:_activityInfo];
    vc.courseType = @"2";
    if (SWNOTEmptyDictionary(_activityInfo)) {
        if (SWNOTEmptyArr([_activityInfo objectForKey:@"asb"])) {
            vc.dataSource = [NSMutableArray arrayWithArray:[_activityInfo objectForKey:@"asb"]];
        } else {
            [TKProgressHUD showError:@"还没有相关团购活动" toView:self.view];
            return;
        }
    } else {
        [TKProgressHUD showError:@"还没有相关团购活动" toView:self.view];
        return;
    }
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
    //    // 如果没有团可供参与 就提示去开团
    //    if (SWNOTEmptyDictionary(_activityInfo)) {
    //        NSArray *asb = [NSArray arrayWithArray:[_activityInfo objectForKey:@"asb"]];
    //        if (SWNOTEmptyArr(asb)) {
    //            GroupListPopViewController *vc = [[GroupListPopViewController alloc] init];
    //            vc.activityInfo = [NSDictionary dictionaryWithDictionary:_activityInfo];
    //            [self.view addSubview:vc.view];
    //            [self addChildViewController:vc];
    //        } else {
    //            [TKProgressHUD showError:@"没有团可参与,可以去开团" toView:self.view];
    //        }
    //    }
}

// MARK: - 开团
- (void)starGroupActivity {
    if (!UserOathToken) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
        
    } else {
        [TKProgressHUD showError:@"活动还未开始" toView:self.view];
        return;
    }
    ClassAndLivePayViewController *vc = [[ClassAndLivePayViewController alloc] init];
    vc.dict = _zhiBoDic;
    vc.typeStr = @"2";
    vc.cid = [_zhiBoDic stringValueForKey:@"id"];
    vc.activityInfo = [NSDictionary dictionaryWithDictionary:_activityInfo];
    vc.isBuyAlone = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: - 砍价或者好友助力
- (void)bargainOrFriendHelpClick {
    
}

- (void)makeBargainOrFriendHelpUI {
    if (_popBackView == nil) {
        _popBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        _popBackView.backgroundColor = [UIColor colorWithRGB:000000 alpha:0.5];
        [self.view addSubview:_popBackView];
    }
    [_popBackView removeAllSubviews];
    // 白色框
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 60, 340)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 6;
    whiteView.center = CGPointMake(_popBackView.width / 2.0, _popBackView.height / 2.0);
    [_popBackView addSubview:whiteView];
    // 头像
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    headerImage.backgroundColor = [UIColor redColor];
    headerImage.layer.masksToBounds = YES;
    headerImage.layer.cornerRadius = 50;
    headerImage.center = CGPointMake(_popBackView.width / 2.0, whiteView.top);
    [_popBackView addSubview:headerImage];
    // 助力砍价情况
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60 - 3, whiteView.width - 30, 36)];
    detailLabel.textColor = RGBHex(0x5D5D5D);//E02620
    detailLabel.font = SYSTEMFONT(13);
    detailLabel.text = @"好友助力或者是砍价情况,多少人砍价多少了,好友助力多少了";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.numberOfLines = 0;
    [whiteView addSubview:detailLabel];
    // 邀请好友砍价、好友助力
    UIButton *inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, detailLabel.bottom + 12, 280, 33)];
    inviteButton.backgroundColor = RGBHex(0x00c514);
    [inviteButton setTitleColor:[UIColor whiteColor] forState:0];
    inviteButton.titleLabel.font = SYSTEMFONT(16);
    inviteButton.layer.masksToBounds = YES;
    inviteButton.layer.cornerRadius = 6;
    [inviteButton setTitle:@"邀请好友砍价" forState:0];
    inviteButton.centerX = whiteView.width / 2.0;
    [whiteView addSubview:inviteButton];
    // 助力砍价详情
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(0, inviteButton.bottom + 7, whiteView.width, 30)];
    detail.textColor = RGBHex(0x818384);
    detail.font = SYSTEMFONT(11);
    detail.textAlignment = NSTextAlignmentCenter;
    detail.text = @"好友砍价详情";
    [whiteView addSubview:detail];
    // 分割线
    UIView *fengeView = [[UIView alloc] initWithFrame:CGRectMake(0, detail.bottom, whiteView.width - 30, 2)];
    fengeView.backgroundColor = RGBHex(0xEEEEEE);
    fengeView.centerX = whiteView.width / 2.0;
    [whiteView addSubview:fengeView];
    // 参与人的详情
    UIScrollView *menberScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, fengeView.bottom, whiteView.width, whiteView.height - fengeView.bottom)];
    [whiteView addSubview:menberScrollView];
    [self makeMenBerUI:menberScrollView];
    // 关闭按钮
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, whiteView.bottom + 25, 36, 36)];
    closeButton.centerX = _popBackView.width / 2.0;
    [closeButton setImage:Image(@"close") forState:0];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_popBackView addSubview:closeButton];
}

- (void)closeButtonClick {
    [_popBackView removeAllSubviews];
    [_popBackView removeFromSuperview];
    _popBackView = nil;
}

- (void)makeMenBerUI:(UIScrollView *)scroll {
    CGFloat width1 = 36.0;
    CGFloat leftRightSpace = 15.0;
    CGFloat menberSpace = (scroll.width - leftRightSpace * 2 - width1 * 5) / 4.0;
    CGFloat topSpace = 10.0;
    CGFloat menberTop = 30.0;
    CGFloat moneyWidth = scroll.width / 5.0;
    for (int i = 0; i<10; i++) {
        UIImageView *face = [[UIImageView alloc] initWithFrame:CGRectMake(leftRightSpace + (i % 5) * (width1 + menberSpace), topSpace + (i/5) * (menberTop + width1), width1, width1)];
        face.backgroundColor = [UIColor blueColor];
        [scroll addSubview:face];
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake((i % 5) * moneyWidth, face.bottom, moneyWidth, 26)];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.text = @"23元";
        moneyLabel.font = SYSTEMFONT(10);
        [scroll addSubview:moneyLabel];
    }
}


// MARK: - 获取课程活动详情
- (void)getCourceActivityInfo {
    NSString *endUrlStr = YunKeTang_Course_Activity_Info;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"course_id"];
    [mutabDict setObject:@"2" forKey:@"course_type"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    __weak ZhiBoMainViewController *wekself = self;
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject] objectForKey:@"code"] integerValue] == 1) {
            if (SWNOTEmptyDictionary([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject])) {
                _activityInfo = (NSDictionary *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject];
                if (SWNOTEmptyDictionary(_activityInfo) && SWNOTEmptyDictionary([_activityInfo objectForKey:@"event_type_info"])) {
                    NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
                    if ([eventType integerValue] == 6) {
                        [self makeGroupBuyUI];
                        [self setJoinGroupActivityInfoData];
                        return;
                    }
                    if ([[_activityInfo allKeys] containsObject:@"event_id"]) {
                        [wekself setActivityData];
                    }
                }
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    [op start];
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
            [self.courseButton setTitle:@"课表" forState:0];
            [self.commentButton setTitle:@"点评" forState:0];
            
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
            _activityWeb = [[ZhiboDetailIntroVC alloc] initWithNumID:_ID WithOrderSwitch:_order_switch];
            _activityWeb.isZhibo = YES;
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
            _activityCommentList = [[ZhiBoClassViewController alloc] initWithNumID:_ID];
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
            _activityQuestionList = [[LiveDetailCommentViewController alloc] initWithNumID:_ID];
            _activityQuestionList.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _activityQuestionList.vc = self;
            _activityQuestionList.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            [self.mainScroll addSubview:_activityQuestionList.view];
            [self addChildViewController:_activityQuestionList];
        } else {
            _activityQuestionList.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            _activityQuestionList.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
        }
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

// MARK: - 机构和讲师头像信息滚动视图
- (void)makeTeacherAndOrganizationUI {
    if (_teachersHeaderBackView == nil) {
        _teachersHeaderBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainDetailView.bottom, MainScreenWidth, 59)];
        [_headerView addSubview:_teachersHeaderBackView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
        line.backgroundColor = RGBHex(0xEEEEEE);
        [_teachersHeaderBackView addSubview:line];
        
        _teachersHeaderScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, line.bottom, MainScreenWidth, 54)];
        _teachersHeaderScrollView.showsVerticalScrollIndicator = NO;
        _teachersHeaderScrollView.showsHorizontalScrollIndicator = NO;
        [_teachersHeaderBackView addSubview:_teachersHeaderScrollView];
        
        UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, _teachersHeaderScrollView.bottom, MainScreenWidth, 4)];
        downLine.backgroundColor = RGBHex(0xEEEEEE);
        [_teachersHeaderBackView addSubview:downLine];
        
        [_teachersHeaderBackView setHeight:0];
        _teachersHeaderBackView.hidden = YES;
    }
}

// MARK: - 机构讲师信息赋值
- (void)setTeacherAndOrganizationData {
    if (SWNOTEmptyDictionary(_schoolInfo)) {
        [_teachersHeaderBackView setTop:_mainDetailView.bottom];
        [_teachersHeaderBackView setHeight:59];
        _teachersHeaderBackView.hidden = NO;
        UIImageView *schoolFace = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 40, 40)];
        UITapGestureRecognizer *schoolTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(instViewClick:)];
        [schoolFace addGestureRecognizer:schoolTap];
        schoolFace.userInteractionEnabled = YES;
        schoolFace.layer.masksToBounds = YES;
        schoolFace.layer.cornerRadius = 20;
        schoolFace.clipsToBounds = YES;
        schoolFace.contentMode = UIViewContentModeScaleAspectFill;
        [schoolFace sd_setImageWithURL:[NSURL URLWithString:[_schoolInfo objectForKey:@"cover"]] placeholderImage:Image(@"站位图")];
        [_teachersHeaderScrollView addSubview:schoolFace];
        UILabel *schoolName = [[UILabel alloc] initWithFrame:CGRectMake(schoolFace.right + 5, 15, 0, 14)];
        schoolName.textColor = RGBHex(0x505050);
        schoolName.font = SYSTEMFONT(13);
        schoolName.text = [NSString stringWithFormat:@"%@",[_schoolInfo objectForKey:@"title"]];
        [_teachersHeaderScrollView addSubview:schoolName];
        UILabel *schoolOwn = [[UILabel alloc] initWithFrame:CGRectMake(schoolFace.right + 5, schoolName.bottom, 0, 18)];
        schoolOwn.text = @"所属机构";
        schoolOwn.textColor = RGBHex(0x929292);
        schoolOwn.font = SYSTEMFONT(10);
        [_teachersHeaderScrollView addSubview:schoolOwn];
        CGFloat schoolnameWidth = [schoolName.text sizeWithFont:schoolName.font].width + 4;
        CGFloat schoolOwnWidth = [schoolOwn.text sizeWithFont:schoolOwn.font].width + 4;
        [schoolName setWidth:schoolnameWidth];
        [schoolOwn setWidth:schoolOwnWidth];
        if (SWNOTEmptyDictionary(_teacherInfoDict)) {
            UIImageView *teacherFace = [[UIImageView alloc] initWithFrame:CGRectMake(schoolnameWidth > schoolOwnWidth ? (schoolName.right + 20) : (schoolOwn.right + 20), 7, 40, 40)];
            UITapGestureRecognizer *teacherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teacherViewClick:)];
            [teacherFace addGestureRecognizer:teacherTap];
            teacherFace.userInteractionEnabled = YES;
            teacherFace.layer.masksToBounds = YES;
            teacherFace.layer.cornerRadius = 20;
            teacherFace.clipsToBounds = YES;
            teacherFace.contentMode = UIViewContentModeScaleAspectFill;
            [teacherFace sd_setImageWithURL:[NSURL URLWithString:[_teacherInfoDict objectForKey:@"headimg"]] placeholderImage:Image(@"站位图")];
            [_teachersHeaderScrollView addSubview:teacherFace];
            UILabel *teacherName = [[UILabel alloc] initWithFrame:CGRectMake(teacherFace.right + 5, 15, 0, 14)];
            teacherName.textColor = RGBHex(0x505050);
            teacherName.font = SYSTEMFONT(13);
            teacherName.text = [NSString stringWithFormat:@"%@",[_teacherInfoDict objectForKey:@"name"]];
            [_teachersHeaderScrollView addSubview:teacherName];
            UILabel *taecherOwn = [[UILabel alloc] initWithFrame:CGRectMake(teacherFace.right + 5, teacherName.bottom, 0, 18)];
            taecherOwn.text = @"主讲老师";
            taecherOwn.textColor = RGBHex(0x929292);
            taecherOwn.font = SYSTEMFONT(10);
            [_teachersHeaderScrollView addSubview:taecherOwn];
            CGFloat teacherNameWidth = [teacherName.text sizeWithFont:teacherName.font].width + 4;
            CGFloat taecherOwnWidth = [taecherOwn.text sizeWithFont:taecherOwn.font].width + 4;
            [teacherName setWidth:teacherNameWidth];
            [taecherOwn setWidth:taecherOwnWidth];
        }
    }
    [_headerView setHeight:_teachersHeaderBackView.bottom];
    _tableView.tableHeaderView = _headerView;
    [_tableView reloadData];
}

// MARK: - 讲师点击事件
- (void)teacherViewClick:(UIGestureRecognizer *)ges {
    if (SWNOTEmptyDictionary(_zhiBoDic)) {
        TeacherMainViewController *vc = [[TeacherMainViewController alloc] initWithNumID:[_zhiBoDic objectForKey:@"teacher_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// MARK: - 机构点击事件
- (void)instViewClick:(UIGestureRecognizer *)ges {
    if (SWNOTEmptyDictionary(_schoolInfo)) {
        InstitutionMainViewController *vc = [[InstitutionMainViewController alloc] init];
        vc.schoolID = [NSString stringWithFormat:@"%@",[_schoolInfo objectForKey:@"school_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
