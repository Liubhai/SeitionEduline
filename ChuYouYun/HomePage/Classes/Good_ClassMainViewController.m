//
//  Good_ClassMainViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "ZFDownloadManager.h"
#import "ZFDownloadingCell.h"
#import "ZFDownloadedCell.h"

#import "WMPlayer.h"

#import "ZhiboDetailIntroVC.h"

#import "Good_ClassDetailViewController.h"
#import "Good_ClassCatalogViewController.h"
#import "Good_ClassCommentViewController.h"
#import "Good_ClassServiceViewController.h"
#import "Good_ClassDownViewController.h"
#import "DLViewController.h"
#import "ClassAndLivePayViewController.h"
#import "ClassNeedTestViewController.h"
#import "VideoMarqueeViewController.h"
#import "Good_ClassNotesViewController.h"
#import "Good_ClassAskQuestionsViewController.h"
#import "TestCurrentViewController.h"


#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"


#import <AliyunPlayerSDK/AliVcMediaPlayer.h>
#import <AliyunVodPlayerSDK/AliyunVodDownLoadManager.h>
#import "AliyunVodPlayerView.h"

#import <BCEDocumentReader/BCEDocumentReader.h>
#import "WebViewController.h"

#import "LBHProgressView.h"

#import "TeacherMainViewController.h"
#import "InstitutionMainViewController.h"
#import "GroupListPopViewController.h"


@import MediaPlayer;
@interface Good_ClassMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,UMSocialUIDelegate,AliyunVodPlayerViewDelegate,BCEDocumentReaderDelegate, UITableViewDelegate, UITableViewDataSource> {
    CGRect   playerFrame;
    WMPlayer *wmPlayer;
    BOOL     isShouleVedio;//是否应该缓存视频
    BOOL     isWebViewBig;//文档 是否放大
    BOOL     isTextViewBig;//文本视图放大
    BOOL     isVideoExit;
    BOOL     isExitTestView;
    CGFloat  detailSrollHight;
    CGFloat  catalogScrollHight;
    CGFloat  commentScrollHight;
    CGFloat  notesScrollHight;
    CGFloat  askScrollHight;
    CGFloat  scrollContentY;
    
    // 新增内容
    CGFloat sectionHeight;
    // 活动倒计时
    NSInteger eventTime;
    NSTimer *eventTimer;
}

@property (strong ,nonatomic)UIView   *navigationView;
@property (strong ,nonatomic)UIView   *videoView;//视频的地方
@property (strong ,nonatomic)UIView   *mainDetailView;
@property (strong ,nonatomic)UILabel  *videoTitleLabel;
@property (strong ,nonatomic)UILabel  *classTitle;
@property (strong ,nonatomic)UILabel  *studyNumber;

@property (strong ,nonatomic)UIScrollView *allScrollView;
@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UIScrollView *classScrollView;
@property (strong ,nonatomic)UIImageView  *videoCoverImageView;
@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIView *segleMentView;
@property (strong ,nonatomic)UILabel *teacherInfo;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UIButton *attentionButton;
@property (strong ,nonatomic)UIButton *backButton;
@property (strong ,nonatomic)UIButton *moreButton;
@property (strong ,nonatomic)UIButton *buyButton;
@property (strong ,nonatomic)UIButton *playButton;
@property (strong ,nonatomic)UIView   *allWindowView;
@property (strong ,nonatomic)UIWindow *appWindow;
@property (strong ,nonatomic)UIImageView *shareImageView;

@property (strong ,nonatomic)UIWebView *webView;
@property (strong ,nonatomic)UITextView *textView;
@property (strong ,nonatomic)AVAudioPlayer *musicPlayer;

@property (strong ,nonatomic)NSDictionary  *videoDataSource;
@property (strong ,nonatomic)NSDictionary  *serviceDict;
@property (strong ,nonatomic)NSDictionary  *videoDict;
@property (strong ,nonatomic)NSDictionary  *notifitonDic;
@property (strong ,nonatomic)NSString      *shareVideoUrl;
@property (strong ,nonatomic)NSTimer       *timer;
@property (strong ,nonatomic)NSTimer       *popupTimer;
@property (strong ,nonatomic)NSString      *collectStr;
@property (strong ,nonatomic)NSString      *serviceOpen;

@property (assign, nonatomic)NSInteger       timeNum;
@property (strong ,nonatomic)NSArray         *subVcArray;
@property (strong ,nonatomic)UILabel         *priceLabel;
@property (strong ,nonatomic)UILabel         *ordPrice;

//配置是否登录能看免费课程
@property (strong ,nonatomic)NSString        *free_course_opt;
@property (assign ,nonatomic)NSInteger       popupTime;
@property (strong ,nonatomic)NSDictionary    *marqueeDict;
@property (strong ,nonatomic)NSString        *marqueeOpenStr;
//下载数据相关
@property (nonatomic, strong)ZFDownloadManager  *downloadManage;
@property (strong ,nonatomic)NSDictionary       *ailDownDict;
@property (strong ,nonatomic)NSDictionary       *seleCurrentDict;



@property (strong ,nonatomic)AliVcMediaPlayer   *mediaPlayer;
@property (nonatomic,strong, nullable)AliyunVodPlayerView *playerView;
//控制锁屏
@property (nonatomic, assign)BOOL isLock;
@property (nonatomic, assign)BOOL isStatusHidden;

//百度文档
@property (strong ,nonatomic)BCEDocumentReader   *reader;
@property (strong ,nonatomic)NSDictionary        *baiDuDocDict;

///新增内容
@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic, retain) UIScrollView *mainScroll;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, strong) UIView *buttonBackView;
@property (nonatomic, strong) UIButton *introButton;
@property (nonatomic, strong) UIButton *courseButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *questionButton;
@property (nonatomic, strong) UIView *blueLineView;

/// 底部全部设置为全局变量为了好处理交互
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) ZhiboDetailIntroVC *activityWeb;
@property (nonatomic, strong) Good_ClassCatalogViewController *activityCommentList;
@property (nonatomic, strong) Good_ClassCommentViewController *activityQuestionList;
@property (nonatomic, strong) Good_ClassNotesViewController *notesList;
@property (nonatomic, strong) Good_ClassAskQuestionsViewController *questionList;
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

/** 机构和讲师移动到头部视图里面了 */
@property (strong, nonatomic) UIView *teachersHeaderBackView;
@property (strong, nonatomic) UIScrollView *teachersHeaderScrollView;
@property (strong, nonatomic) NSDictionary *schoolInfo;
@property (strong, nonatomic) NSDictionary *teacherInfoDict;

// 售罄后的视图
//@property (strong, nonatomic) UIView *activityEndLeftView;
//@property (strong, nonatomic) UIView *activityEndRightView;
//@property (strong, nonatomic) UIImageView *activityEndrightIcon;
//@property (strong, nonatomic) UILabel *activityEndLabel;
/** 点播课程活动详情信息 */
@property (strong, nonatomic) NSDictionary *activityInfo;
@end

@implementation Good_ClassMainViewController

#pragma mark --- 懒加载
//-(WMPlayer *)wmPlayer {//视频和音频视图
//    if (!_wmPlayer) {
//        _wmPlayer = [[WMPlayer alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit) videoURLStr:nil];
//        [_videoView addSubview:self.wmPlayer];
//    }
//    return _wmPlayer;
//}

-(UIWebView *)webView {//文档视图
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 30 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit,210 * WideEachUnit)];
    }
    return _webView;
}

-(UITextView *)textView {//文本视图
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 0 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit,210 * WideEachUnit)];
    }
    return _textView;
}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self netWorkVideoGetInfoChangeStatus];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [self releaseWMPlayer];//移除播放器
    [self AliPlayerDealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    /// 新增内容
    self.canScroll = YES;
    self.canScrollAfterVideoPlay = YES;
    sectionHeight = 0.01;
    _titleLabel.text = @"课程详情";
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
    
    [_tableView addHeaderWithTarget:self action:@selector(netWorkVideoGetInfo)];
    
    [self interFace];
    [self addShareImageView];
    [self addNotification];
    [self createSubView];
    //    [self addAllScrollView];
    [self addInfoView];
    [self makeActivityUI];
    [self addMainDetailView];
    [self makeTeacherAndOrganizationUI];
    [self addNav];
    //    [self addWZView];
    //    [self addControllerSrcollView];
    //    [self addClassCatalogVcBolck];
    //    [self addCommentVcBolck];
    [self addDownView];
    [self netWorkVideoGetInfo];
    if (_isEvent) {
    }
    // 上架时候暂时不处理活动
    [self getCourceActivityInfo];
    [self netWorkVideoGetFreeTime];
    [self netWorkConfigGetVideoKey];
    [self netWorkConfigFreeCourseLoginSwitch];
    [self netWorkGetThirdServiceUrl];
    [self netWorkVideoGetMarquee];
}

- (void)leftButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AilYunPlayerStop" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    SYGView.layer.zPosition = 10;
    _navigationView = SYGView;
    _navigationView.backgroundColor = [UIColor clearColor];
    _navigationView.userInteractionEnabled = YES;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, MACRO_UI_STATUSBAR_ADD_HEIGHT+20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    _backButton = backButton;
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, MACRO_UI_STATUSBAR_ADD_HEIGHT+25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"课程详情";//_videoTitle;
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    _videoTitleLabel = WZLabel;
    _videoTitleLabel.hidden = YES;
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, MACRO_UI_STATUSBAR_ADD_HEIGHT+20, 50, 30)];
    [moreButton setTitle:@"..." forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    [moreButton addTarget:self action:@selector(moreButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:moreButton];
    _moreButton = moreButton;
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    isWebViewBig = NO;
    isTextViewBig = NO;
    isVideoExit = NO;
    isExitTestView = NO;
}

- (void)addShareImageView {
    _shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [_shareImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
}
- (void)addNotification {
    
    
    //添加通知 (课程详情传过来)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetailHight:) name:@"Good_ClassDetailHight" object:nil];
    //添加通知 (课程评论传过来)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentHight:) name:@"Good_ClassCommentHight" object:nil];
    
    //添加通知 (课程目录传过来)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVideoDataSource:) name:@"NotificationVideoDataSource" object:nil];
    
    //旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    //答题正确
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TheAnswerRight:) name:@"TheAnswerRight" object:nil];
    
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AilYunPlayerEnd:) name:@"AilYunPlayerPlayEnd" object:nil];
    
    
}

- (void)addAllScrollView {
    
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreenWidth * 10, MainScreenHeight - 50 * WideEachUnit)];
    //    _allScrollView.pagingEnabled = YES;
    _allScrollView.delegate = self;
    _allScrollView.bounces = YES;
    _allScrollView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allScrollView.contentSize = CGSizeMake(0, 10000);
    [self.view addSubview:_allScrollView];
    
}

- (void)addInfoView {
    
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 210 * HigtEachUnit)];
    _videoView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_videoView];
    
    
    //背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_videoView.bounds];
    imageView.image = Image(@"视频播放2");
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
    [_videoView addSubview:imageView];
    _videoCoverImageView = imageView;
    
    
    //添加提醒文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 80 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    label.text = @"上次观看至哪里";
    //    label.text = @"开始学习";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = Font(16 * WideEachUnit);
    label.textAlignment = NSTextAlignmentCenter;
    [_videoCoverImageView addSubview:label];
    label.hidden = YES;
    
    //添加按钮
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60 * WideEachUnit, 110, 120 * WideEachUnit, 24 * WideEachUnit)];
    [_playButton setImage:Image(@"ico_start@3x") forState:UIControlStateNormal];
    _playButton.backgroundColor = [UIColor clearColor];
    //    _playButton.center = _videoView.center;
    [_videoView addSubview:_playButton];
    _playButton.hidden = YES;
    
}

- (void)addMainDetailView {
    _mainDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, _activityBackView.bottom, MainScreenWidth, 50 * HigtEachUnit)];
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
    
    [_headerView setHeight:_mainDetailView.bottom];
}

- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mainDetailView.frame) + 10 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit)];
    WZView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:WZView];
    _segleMentView = WZView;
    
    //    NSArray *titleArray = @[@"详情",@"目录",@"点评"];
    //    _mainSegment = [[UISegmentedControl alloc] initWithItems:titleArray];
    //    _mainSegment.frame = CGRectMake(2 * SpaceBaside * WideEachUnit,SpaceBaside * WideEachUnit,MainScreenWidth - 4 * SpaceBaside * WideEachUnit, 30 * WideEachUnit);
    //    _mainSegment.selectedSegmentIndex = 0;
    //    [_mainSegment setTintColor:BasidColor];
    //    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
    //    [WZView addSubview:_mainSegment];
    
    
    NSArray *segmentedArray = @[@"简介",@"目录",@"点评"];
    if ([_serviceOpen integerValue] == 1) {
        //        segmentedArray = @[@"详情",@"目录",@"点评",@"客服"];
        segmentedArray = @[@"简介",@"目录",@"点评",@"笔记",@"提问"];
    } else {
        segmentedArray = @[@"简介",@"目录",@"点评",@"笔记",@"提问"];
    }
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
    
}


- (void)addControllerSrcollView {
    return;
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segleMentView.frame) + 10 * WideEachUnit,  MainScreenWidth, MainScreenHeight * 30 + 500 * WideEachUnit)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 5,0);
    [_allScrollView addSubview:_controllerSrcollView];
    
    Good_ClassDetailViewController *classDetailVc= [[Good_ClassDetailViewController alloc] initWithNumID:_ID];
    classDetailVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight * 30);
    [self addChildViewController:classDetailVc];
    [_controllerSrcollView addSubview:classDetailVc.view];
    
    Good_ClassCatalogViewController *classCatalogVc = [[Good_ClassCatalogViewController alloc] initWithNumID:_ID];
    classCatalogVc.view.frame = CGRectMake(MainScreenWidth * 1, 0, MainScreenWidth, MainScreenHeight * 2 + 500 * WideEachUnit);
    [self addChildViewController:classCatalogVc];
    [_controllerSrcollView addSubview:classCatalogVc.view];
    
    Good_ClassCommentViewController *classCommentVc = [[Good_ClassCommentViewController alloc] initWithNumID:_ID];
    classCommentVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight * 10 + 500 * WideEachUnit);
    [self addChildViewController:classCommentVc];
    [_controllerSrcollView addSubview:classCommentVc.view];
    
    
    Good_ClassNotesViewController *classNotesVc = [[Good_ClassNotesViewController alloc] initWithNumID:_ID];
    classNotesVc.view.frame = CGRectMake(MainScreenWidth * 3, 0, MainScreenWidth, MainScreenHeight * 10 + 500 * WideEachUnit);
    [self addChildViewController:classNotesVc];
    [_controllerSrcollView addSubview:classNotesVc.view];
    
    Good_ClassAskQuestionsViewController *classAskVc = [[Good_ClassAskQuestionsViewController alloc] initWithNumID:_ID];
    classAskVc.view.frame = CGRectMake(MainScreenWidth * 4, 0, MainScreenWidth, MainScreenHeight * 10 + 500 * WideEachUnit);
    [self addChildViewController:classAskVc];
    [_controllerSrcollView addSubview:classAskVc.view];
    
    
    if ([_serviceOpen integerValue] == 1) {
        //        Good_ClassServiceViewController *classServiceVc = [[Good_ClassServiceViewController alloc] initWithNumID:_ID];
        //        classServiceVc.view.frame = CGRectMake(MainScreenWidth * 3, 0, MainScreenWidth, MainScreenHeight * 10 + 500 * WideEachUnit);
        //        [self addChildViewController:classServiceVc];
        //        [_controllerSrcollView addSubview:classServiceVc.view];
        //        _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 4,0);
        _subVcArray = @[classDetailVc,classCatalogVc,classCommentVc,classNotesVc,classAskVc];
    } else {
        _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 5,0);
        _subVcArray = @[classDetailVc,classCatalogVc,classCommentVc,classNotesVc,classAskVc];
    }
    
    
    
    //    [self addClassDetailVcBolck];
    [self addClassCatalogVcBolck];
    [self addCommentVcBolck];
    [self addNoteVcBolck];
    [self addAskVcBolck];
    [self addClassCatalogVcDataSourceBolck];
    [self addClassCatalogVcDidSeleBolck];
}


- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50 * HigtEachUnit - MACRO_UI_SAFEAREA , MainScreenWidth, 50 * HigtEachUnit + MACRO_UI_SAFEAREA)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];
    
    
    CGFloat ButtonW = MainScreenWidth / 5;
    //    buttonW = ButtonW;
    CGFloat ButtonH = 50 * HigtEachUnit;
    
    NSArray *title = @[@"关注",@"立即解锁"];
    NSArray *image = @[@"机构关注@2x",@"机构信息@2x"];
    if ([_videoDict[@"follow_state"][@"following"] integerValue] == 0) {
        image = @[@"icon_focus@3x",@"icon_message@3x"];
        title = @[@"关注",@"私信"];
    } else {
        image = @[@"机构关注@2x",@"icon_message@3x"];
        title = @[@"已关注",@"私信"];
    }
    
    title = @[[NSString stringWithFormat:@"育币 %@",_price],@"立即解锁"];
    if ([_price floatValue] == 0) {
        title = @[@"免费",@"立即解锁"];
    }
    
    for (int i = 0 ; i < title.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * ButtonW, SpaceBaside, ButtonW, ButtonH)];
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.titleLabel.font = Font(14 * WideEachUnit);
        button.tag = i;
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, ButtonW * 2, ButtonH / 2);
            [button setTitleColor:[UIColor colorWithHexString:@"#f01414"] forState:UIControlStateNormal];
            if ([_price floatValue] == 0) {
                [button setTitleColor:[UIColor colorWithHexString:@"#47b37d"] forState:UIControlStateNormal];
            }
            button.titleLabel.font = Font(12 * WideEachUnit);
            _attentionButton = button;
            
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
    
    _ordPrice.text = [NSString stringWithFormat:@"育币%@",[_videoDataSource stringValueForKey:@"v_price"]];
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

#pragma mark --- 滚动试图

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    // 因为video的尺寸一直在变 所以后面就不能用video的尺寸来滚动的范围
//    CGFloat contentCrorX = _controllerSrcollView.contentOffset.x;
//    if (contentCrorX < MainScreenWidth) {
//        _mainSegment.selectedSegmentIndex = 0;
//        if (currentIOS >= 11.0) {
//            _allScrollView.contentSize = CGSizeMake(0, detailSrollHight + 210 * WideEachUnit + 200 * WideEachUnit + 10 * WideEachUnit);
//        } else {
//            _allScrollView.contentSize = CGSizeMake(0 * WideEachUnit , detailSrollHight + 210 * WideEachUnit + 200 * WideEachUnit + 10 * WideEachUnit);
//        }
//    } else if (contentCrorX < 2 * MainScreenWidth) {
//        _mainSegment.selectedSegmentIndex = 1;
////        _allScrollView.contentSize = CGSizeMake(0, catalogScrollHight + CGRectGetMaxY(_videoView.frame) + 150 * WideEachUnit);// 因为这句代码video的尺寸一直在变 所以是不可以的
//        _allScrollView.contentSize = CGSizeMake(0, catalogScrollHight + 210 * WideEachUnit + 150 * WideEachUnit + (MACRO_UI_SAFEAREA + MACRO_UI_LIUHAI_HEIGHT) * WideEachUnit);
//    }  else if (contentCrorX < 3 * MainScreenWidth) {
//        _mainSegment.selectedSegmentIndex = 2;
//        _allScrollView.contentSize = CGSizeMake(0 , commentScrollHight + 210 * WideEachUnit + 160 * WideEachUnit + 100 * WideEachUnit + 30 * WideEachUnit);// 100 * WideEachUnit 是tabeView 的头部
//    } else if (contentCrorX < 4 * MainScreenWidth) {
//        _mainSegment.selectedSegmentIndex = 3;
//        _allScrollView.contentSize = CGSizeMake(0 , notesScrollHight + 210 * WideEachUnit + 160 * WideEachUnit + 100 * WideEachUnit + 30 * WideEachUnit - 140 * WideEachUnit);
//    } else if (contentCrorX < 5 * MainScreenWidth) {
//        _mainSegment.selectedSegmentIndex = 4;
//        _allScrollView.contentSize = CGSizeMake(0 , askScrollHight + 210 * WideEachUnit + 160 * WideEachUnit + 100 * WideEachUnit + 30 * WideEachUnit - 140 * WideEachUnit);
//    }
//
//
//    //设置顶部滚动的导航栏
//    CGFloat contentCrorY = _allScrollView.contentOffset.y;
//    scrollContentY = contentCrorY;
//    NSLog(@"Y----%lf",contentCrorY);
//    NSLog(@"----%lf",CGRectGetMaxY(_mainDetailView.frame));
//
//    if (!isVideoExit) {//没有播放视频
//        if (contentCrorY > CGRectGetMaxY(_mainDetailView.frame)) {//出现
//            _navigationView.backgroundColor = BasidColor;
//            _videoTitleLabel.textColor = [UIColor whiteColor];
//            [_allScrollView bringSubviewToFront:_navigationView];
//            _navigationView.frame = CGRectMake(0, contentCrorY, MainScreenWidth, 64);
//            _segleMentView.frame = CGRectMake(0, contentCrorY + 64, MainScreenWidth, 50 * WideEachUnit);
//            [_allScrollView bringSubviewToFront:_segleMentView];
//        } else {
//            _navigationView.backgroundColor = [UIColor clearColor];
//            _videoTitleLabel.textColor = [UIColor clearColor];
//            _navigationView.frame = CGRectMake(0, 0, MainScreenWidth, 64);
//            _segleMentView.frame = CGRectMake(0,CGRectGetMaxY(_mainDetailView.frame) + 10 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit);
//            [_allScrollView bringSubviewToFront:_segleMentView];
//        }
//    } else {//有播放视频
//        if (contentCrorY > 70 * WideEachUnit) {
//            _navigationView.backgroundColor = [UIColor clearColor];
//            _videoTitleLabel.textColor = [UIColor clearColor];
//            _navigationView.frame = CGRectMake(0, contentCrorY, MainScreenWidth, 64);
//            [_allScrollView bringSubviewToFront:_videoView];
//            [_allScrollView bringSubviewToFront:_navigationView];
//            _videoView.frame = CGRectMake(0, contentCrorY, MainScreenWidth, 210 * WideEachUnit);
//            _segleMentView.frame = CGRectMake(0,contentCrorY + 210 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit);
//            [_allScrollView bringSubviewToFront:_segleMentView];
//        } else {
//            _navigationView.backgroundColor = [UIColor clearColor];
//            _videoTitleLabel.textColor = [UIColor clearColor];
//            _navigationView.frame = CGRectMake(0, contentCrorY, MainScreenWidth, 64);
//            [_allScrollView bringSubviewToFront:_videoView];
//            [_allScrollView bringSubviewToFront:_navigationView];
//            _videoView.frame = CGRectMake(0, contentCrorY + 0 * WideEachUnit, MainScreenWidth, 210 * WideEachUnit);
//            _segleMentView.frame = CGRectMake(0,CGRectGetMaxY(_mainDetailView.frame) + 10 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit);
////            if (currentIOS >= 11.0) {
////                _mainDetailView.frame = CGRectMake(0, CGRectGetMaxY(_videoView.frame) + 10 * WideEachUnit, MainScreenWidth, 70 * WideEachUnit);
////            }
//            [_allScrollView bringSubviewToFront:_segleMentView];
//        }
//    }
//
//
//
//}


- (void)mainChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            //            _allScrollView.contentSize = CGSizeMake(0 , detailSrollHight + CGRectGetMaxY(_videoView.frame) + 100 * WideEachUnit);
            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 1, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0, catalogScrollHight + CGRectGetMaxY(_videoView.frame) + 210 * WideEachUnit);
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            _allScrollView.contentSize = CGSizeMake(0, commentScrollHight + CGRectGetMaxY(_videoView.frame) + 70 * WideEachUnit);
            //设置滚动的范围
            break;
        case 3:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 3, 0);
            _allScrollView.contentSize = CGSizeMake(0, notesScrollHight + CGRectGetMaxY(_videoView.frame) + 70 * WideEachUnit);
            //设置滚动的范围
            break;
        case 4:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 4, 0);
            _allScrollView.contentSize = CGSizeMake(0, askScrollHight + CGRectGetMaxY(_videoView.frame) + 70 * WideEachUnit);
            //设置滚动的范围
            break;
            
        default:
            break;
    }
    
}



#pragma mark -- 事件监听
- (void)backPressed {
    [self releaseWMPlayer];
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AilYunPlayerStop" object:nil];
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
    _allWindowView = allWindowView;
    _appWindow = app.keyWindow;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WideEachUnit,55 * WideEachUnit,100 * WideEachUnit,100 * WideEachUnit)];
    moreView.frame = CGRectMake(MainScreenWidth - 120 * WideEachUnit,55 * WideEachUnit,100 * WideEachUnit,100 * WideEachUnit);
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    
    NSArray *imageArray = @[@"ico_collect@3x",@"class_share",@"class_down"];
    NSArray *titleArray = @[@"+收藏",@"分享",@"下载"];
    if ([_collectStr integerValue] == 1) {
        imageArray = @[@"ic_collect_press@3x",@"class_share",@"class_down"];
        titleArray = @[@"-收藏",@"分享",@"下载"];
    }
    CGFloat ButtonW = 100 * WideEachUnit;
    CGFloat ButtonH = 33 * WideEachUnit;
    for (int i = 0 ; i < 3 ; i ++) {
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
    if (UserOathToken == nil) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        [_allWindowView removeFromSuperview];
        return;
    }
    if (button.tag == 0) {//收藏
        [self netWorkVideoCollect];
    } else if (button.tag == 1) {//分享
        [self netWorkVideoGetShareUrl];
    } else if (button.tag == 2) {//下载
        if ([[_videoDataSource stringValueForKey:@"is_buy"] integerValue] == 1) {
            Good_ClassDownViewController *vc = [[Good_ClassDownViewController alloc] init];
            vc.ID = _ID;
            vc.orderSwitch = _orderSwitch;
            vc.videoDataSource = (NSMutableDictionary *) _videoDataSource;
            vc.isClassCourse = _isClassNew;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [_allWindowView removeFromSuperview];
            [TKProgressHUD showError:@"解锁之后才能下载课程" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
    }
    [_allWindowView removeFromSuperview];
}

- (void)downButtonClick:(UIButton *)button {
    if (!UserOathToken) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if (button.tag == 1) {//解锁
        if ([_buyButton.titleLabel.text isEqualToString:@"已解锁"]) {
        } else if ([_buyButton.titleLabel.text isEqualToString:@"立即解锁"]) {
            ClassAndLivePayViewController *vc = [[ClassAndLivePayViewController alloc] init];
            vc.dict = _videoDataSource;
            if (_isClassNew) {
                vc.typeStr = @"5";
            } else {
                vc.typeStr = @"1";
            }
            vc.cid = [_videoDataSource stringValueForKey:@"id"];
            vc.activityInfo = [NSDictionary dictionaryWithDictionary:_activityInfo];
            [self.navigationController pushViewController:vc animated:YES];
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
                                                      shareText:[NSString stringWithFormat:@"%@",_videoTitle]
                                                     shareImage:_shareImageView.image
                                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                                       delegate:self];
                }
            }
        }
    }
}

#pragma mark --- 分享相关
- (void)VideoShare {
    NSLog(@"%@  %@",_videoTitle,_shareVideoUrl);
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:_shareVideoUrl];
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:_shareVideoUrl];
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppId secret:SinaAppSecret RedirectURL:_shareVideoUrl];
//    UMShareToSina
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:[NSString stringWithFormat:@"%@",_videoTitle]
                                     shareImage:_shareImageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
}

#pragma mark --- bolck

- (void)addClassDetailVcBolck {
    Good_ClassDetailViewController *vc = _subVcArray[0];
    vc.vcHight = ^(CGFloat hight) {
        detailSrollHight = hight;
    };
}

- (void)addClassCatalogVcBolck {
    Good_ClassCatalogViewController *vc = _subVcArray[1];
    vc.vcHight = ^(CGFloat hight) {
        catalogScrollHight = hight;
    };
}

- (void)addCommentVcBolck {
    Good_ClassCommentViewController *vc = _subVcArray[2];
    vc.vcHight = ^(CGFloat hight) {
        commentScrollHight = hight;
        NSLog(@"-----%lf",hight);
    };
}

- (void)addNoteVcBolck {
    Good_ClassNotesViewController *vc = _subVcArray[3];
    vc.vcHight = ^(CGFloat hight) {
        notesScrollHight = hight;
        NSLog(@"-----%lf",hight);
    };
}

- (void)addAskVcBolck {
    Good_ClassAskQuestionsViewController *vc = _subVcArray[4];
    vc.vcHight = ^(CGFloat hight) {
        askScrollHight = hight;
        NSLog(@"-----%lf",hight);
    };
}

- (void)addClassCatalogVcDataSourceBolck {
    Good_ClassCatalogViewController *vc = _subVcArray[1];
    __weak Good_ClassMainViewController *wekself = self;
    vc.videoDataSource = ^(NSDictionary *videoDataSource) {
        wekself.seleCurrentDict = videoDataSource;
        if ([[videoDataSource stringValueForKey:@"is_baidudoc"] integerValue] == 1) {
            [wekself netWorkVideoGetBaiduDocReadToken];
            //            [self addBaiDuDoc];
            return ;
        }
        if ([[videoDataSource stringValueForKey:@"video_type"] integerValue] == 6) {//考试
            if ([[wekself.seleCurrentDict stringValueForKey:@"lock"] integerValue] != 1) {
                return ;
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"考试提示" message:@"是否现在前去考试？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [wekself netWorkExamsGetPaperInfo];
                }];
                [alertController addAction:sureAction];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                return ;
            }
        }
        //判断是否需要弹题出来
        isExitTestView = NO;
        [wekself judgeNeedTest];
        if ([[videoDataSource stringValueForKey:@"video_address"] rangeOfString:YunKeTang_EdulineOssCnShangHai].location != NSNotFound) {
            wekself.ailDownDict = videoDataSource;
            if ([[wekself.ailDownDict stringValueForKey:@"type"] integerValue] == 4) {//阿里的文档
                if ([[wekself.ailDownDict stringValueForKey:@"price"] floatValue] == 0) {
                    if ([wekself.free_course_opt integerValue] == 1) {//还是需要登录
                        if (!UserOathToken) {
                            DLViewController *vc = [[DLViewController alloc] init];
                            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
                            [wekself.navigationController presentViewController:Nav animated:YES completion:nil];
                            return;
                        }
                    } else if ([wekself.free_course_opt integerValue] == 0) {
                        
                    }
                }
                wekself.videoUrl = [wekself.ailDownDict stringValueForKey:@"video_address"];
                [wekself addWebView];
            } else {
                [wekself addAliYunPlayer];
            }
            return ;
        } else {
            //            [self getVideoDataSource:videoDataSource];
            wekself.ailDownDict = videoDataSource;
            wekself.notifitonDic = videoDataSource;
            wekself.videoUrl = [wekself.notifitonDic stringValueForKey:@"video_address"];
            [wekself dealKindsOfType:videoDataSource];
        }
    };
}

- (void)addClassCatalogVcDidSeleBolck {
    Good_ClassCatalogViewController *vc = _subVcArray[1];
    vc.didSele = ^(NSString *seleStr) {
        [self releaseWMPlayer];
        [self AliPlayerDealloc];
    };
}


#pragma mark --- 通知（处理事情）

- (void)getDetailHight:(NSNotification *)not {
    NSString *scollHightStr = (NSString *)not.object;
    CGFloat scollHight = [scollHightStr floatValue];
    if ([MoreOrSingle integerValue] == 1) {
        scollHight = scollHight + 40 * WideEachUnit;
    }
    detailSrollHight = scollHight;
    _allScrollView.contentSize = CGSizeMake(0 , scollHight + CGRectGetMaxY(_videoView.frame) + 190 * WideEachUnit);
}

- (void)getCommentHight:(NSNotification *)not {
    NSString *scollHightStr = (NSString *)not.object;
    CGFloat scollHight = [scollHightStr floatValue];
    commentScrollHight = scollHight;
    if ([scollHightStr floatValue] < 10 * WideEachUnit) {//说明没有
        commentScrollHight = MainScreenWidth - CGRectGetMaxY(_videoView.frame) + 100 * WideEachUnit;
    }
}

- (void)becomeActive{
    NSLog(@"播放器状态:%ld",(long)self.playerView.playerViewState);
    if (self.playerView && self.playerView.playerViewState == AliyunVodPlayerStatePause){
        [self.playerView start];
    }
    if (wmPlayer.player) {
        [wmPlayer.player play];
    }
}

- (void)resignActive{
    if (self.playerView){
        [self.playerView pause];
    }
    if (wmPlayer.player) {
        [wmPlayer.player pause];
    }
}


//得到传值过来的处理
- (void)getVideoDataSource:(NSDictionary *)dict {
    _videoDict = dict;
    _videoUrl = [_videoDict stringValueForKey:@"video_address"];
    
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer setFireDate:[NSDate distantPast]];
    
    
    _notifitonDic = dict;
    _videoUrl = [_notifitonDic stringValueForKey:@"video_address"];
    
    //将之前的移除
    if (wmPlayer != nil|| wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
    }
    [_textView removeFromSuperview];
    [_webView removeFromSuperview];
    
    if (_reader != nil && _reader.superview != nil) {
        [_reader removeFromSuperview];
        _reader = nil;
    }
    
    //配置数据的处理
    if (UserOathToken) {//登录的时候
        
    } else {//未登录的时候
        if ([_free_course_opt integerValue] == 1) {//即使免费的也需要登录
            DLViewController *vc = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
    }
    
    if ([_notifitonDic stringValueForKey:@"type"] == nil) {
        [TKProgressHUD showError:@"暂时不支持" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 1) {//视频
        if ( [[_videoDataSource stringValueForKey:@"is_buy"] integerValue] != 0) {//解锁了的
            [_timer invalidate];
            self.timer = nil;
        } else {
            if ([[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了单课时
                [_timer invalidate];
                self.timer = nil;
            } else {
                if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1) {//免费看
                    [_timer invalidate];
                    self.timer = nil;
                } else {//试看。受限制
                    if (_timeNum == 0) {
                        [TKProgressHUD showError:@"需先解锁此课程" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    } else {
                        self.timer = nil;
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoTimeMonitor) userInfo:nil repeats:YES];
                    }
                }
            }
        }
        [self addPlayer];
        
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 2) {//音频
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了的
        }else {//没有解锁
            [TKProgressHUD showError:@"解锁才能听此音频" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        
        [self addPlayer];
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 3) {//文本
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了的
        }else {//没有解锁
            [TKProgressHUD showError:@"解锁才能看此文本" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addTextView];
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 4) {//文档
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了的
        }else {//没有解锁
            [TKProgressHUD showError:@"解锁才能看此文档" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addWebView];
    }
}

// 移除上一个播放的内容
- (void)removePassView {
    //将之前的移除
    if (wmPlayer != nil|| wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
    }
    
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
    [_textView removeFromSuperview];
    [_webView removeFromSuperview];
    
    if (_reader != nil && _reader.superview != nil) {
        [_reader removeFromSuperview];
        _reader = nil;
    }
}

- (void)dealKindsOfType:(NSDictionary *)dict {
    _videoDict = dict;
    _videoUrl = [_videoDict stringValueForKey:@"video_address"];
    
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer setFireDate:[NSDate distantPast]];
    
    
    _notifitonDic = dict;
    _videoUrl = [_notifitonDic stringValueForKey:@"video_address"];
    
    //将之前的移除
    if (wmPlayer != nil|| wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
    }
    
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
    [_textView removeFromSuperview];
    [_webView removeFromSuperview];
    
    if (_reader != nil && _reader.superview != nil) {
        [_reader removeFromSuperview];
        _reader = nil;
    }
    
    //配置数据的处理
    if (UserOathToken) {//登录的时候
        
    } else {//未登录的时候
        if ([_free_course_opt integerValue] == 1) {//即使免费的也需要登录
            DLViewController *vc = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
    }
    
    if ([_notifitonDic stringValueForKey:@"type"] == nil) {
        [TKProgressHUD showError:@"暂时不支持" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 1) {//视频
        if ( [[_videoDataSource stringValueForKey:@"is_buy"] integerValue] != 0) {//解锁了的
            [_timer invalidate];
            self.timer = nil;
        } else {
            if ([[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了单课时
                [_timer invalidate];
                self.timer = nil;
            } else {
                if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1) {//免费看
                    [_timer invalidate];
                    self.timer = nil;
                } else {//试看。受限制
                    if (_timeNum == 0) {
                        [TKProgressHUD showError:@"需先解锁此课程" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    } else {
                        self.timer = nil;
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoTimeMonitorAndAliPlayer) userInfo:nil repeats:YES];
                    }
                }
            }
        }
        [self addAliYunPlayer];
        
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 2) {//音频
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了的
        }else {//没有解锁
            [TKProgressHUD showError:@"解锁才能听此音频" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        
        [self addAliYunPlayer];
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 3) {//文本
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了的
        }else {//没有解锁
            [TKProgressHUD showError:@"解锁才能看此文本" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addTextView];
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 4) {//文档
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了的
        }else {//没有解锁
            [TKProgressHUD showError:@"解锁才能看此文档" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addWebView];
    }
}

- (void)AilYunPlayerEnd:(NSNotification *)not {
    NSString *notStr = (NSString *)not.object;
    if ([notStr integerValue] == 100) {
        
    }
}

- (void)TheAnswerRight:(NSNotification *)not {
    [_playerView resume];
}

#pragma mark --- 播放器的相关设置

// 支持设备自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}

// 支持横竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        //        _wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    //在这里设置提醒试看试图的大小 （跟着视频大小的变化一起变化）
    _imageView.frame = CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (currentIOS >= 11.0) {
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.view.frame.size.width - 40);
            make.width.mas_equalTo(self.view.frame.size.height);
            
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(-80);
            make.width.mas_equalTo(self.view.frame.size.height - 80);
            make.left.mas_equalTo(30);
        } else {
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.view.frame.size.width-40);
            make.width.mas_equalTo(self.view.frame.size.height);
        }
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
}

-(void)toNormal{
    [wmPlayer removeFromSuperview];
    __weak Good_ClassMainViewController *wekself = self;
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        wmPlayer.playerLayer.frame = wmPlayer.bounds;
        
        //设置提醒试图的大小
        wekself.imageView.frame = CGRectMake(0, 0, playerFrame.size.width, playerFrame.size.height);
        
        [_videoView addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}


-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toNormal];
    }
}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer == nil|| wmPlayer.superview == nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                [self toNormal];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}


-(void)releaseWMPlayer{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
    
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer = nil;
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    wmPlayer.videoURLStr = nil;
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    
}

-(void)dealloc{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"player deallco");
}


- (void)AliPlayerDealloc {
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
}


#pragma mark --- 添加播放器或者文本视图
- (void)addPlayer { //视频和音频
    [self AliPlayerDealloc];
    isVideoExit = NO;
    [_imageView removeFromSuperview];
    _imageView = nil;
    if (_videoUrl == nil) {
        return;
    }
    if (wmPlayer!=nil||wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
    }
    [_textView removeFromSuperview];
    [_webView removeFromSuperview];
    
    playerFrame = CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit);
    wmPlayer = [[WMPlayer alloc] initWithFrame:playerFrame videoURLStr:_videoUrl];
    wmPlayer.closeBtn.hidden = YES;
    [_videoView addSubview:wmPlayer];
    
    wmPlayer.closeBtn.hidden = YES;
    [wmPlayer.player play];
    wmPlayer.playOrPauseBtn.selected = NO;
    
    //设置尺寸
    [_allScrollView bringSubviewToFront:_videoView];
    _videoView.frame = CGRectMake(0, scrollContentY, MainScreenWidth, 210 * WideEachUnit);
    isVideoExit = YES;
    //隐藏最上面的导航栏 (设置为透明色)
    _navigationView.backgroundColor = [UIColor clearColor];
    _videoTitleLabel.textColor = [UIColor clearColor];
    [_allScrollView bringSubviewToFront:_navigationView];
    
    
    //    //添加视频投屏
    //    MPVolumeView *volume = [[MPVolumeView alloc] initWithFrame:CGRectMake(MainScreenWidth - 100 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit)];
    //    volume.showsVolumeSlider = NO;
    //    volume.backgroundColor = [UIColor redColor];
    //    [volume sizeToFit];
    //    [wmPlayer addSubview:volume];
    
}

- (void)addAliYunPlayer {
    if (wmPlayer!=nil||wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
    }
    
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
    
    
    //    [self onFinishWithAliyunVodPlayerView:_playerView];
    
    //把之前的时间移除
    [_timer invalidate];
    self.timer = nil;
    
    //配置数据的处理
    if (UserOathToken) {//登录的时候
        
    } else {//未登录的时候
        if ([_free_course_opt integerValue] == 1) {//即使免费的也需要登录
            DLViewController *vc = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
    }
    
    //添加顺序播放
    if ([[_videoDataSource stringValueForKey:@"is_order"] integerValue] == 1) {
        if ([[_seleCurrentDict stringValueForKey:@"lock"] integerValue] == 1) {//可以播放
            
        } else {//不可以播放
            [TKProgressHUD showError:@"该课时暂时无法观看" toView:self.view];
            return;
        }
    }
    
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat topHeight = 0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ) {
        width = ScreenWidth;
        height = ScreenWidth * 9 / 16.0;
        topHeight = 20;
    }else{
        width = ScreenWidth;
        height = ScreenHeight;
        topHeight = 20;
    }
    
    /// 在此之前需要处理全屏权限
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = YES;
    
    /****************UI播放器集成内容**********************/
    _playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,topHeight, width, height) andSkin:AliyunVodPlayerViewSkinRed];
    _playerView.frame = CGRectMake(0, 0, _videoView.frame.size.width, _videoView.frame.size.height);
    
    //        _playerView.circlePlay = YES;
    _playerView.delegate = self;
    [_playerView setDelegate:self];
    [_playerView setAutoPlay:YES];
    
    [_playerView setPrintLog:YES];
    
    _playerView.isScreenLocked = false;
    _playerView.fixedPortrait = false;
    self.isLock = self.playerView.isScreenLocked||self.playerView.fixedPortrait?YES:NO;
    
    
    [_videoView addSubview:_playerView];
    NSURL *url = [NSURL URLWithString:_ailDownDict[@"video_address"]];
    [self.playerView playViewPrepareWithURL:url];
    self.playerView.userInteractionEnabled = YES;
    NSString *learn_record = [NSString stringWithFormat:@"%@",[_ailDownDict objectForKey:@"learn_record"]];
    if ([learn_record integerValue] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recodeNumChange" object:nil userInfo:@{@"recodeNum":learn_record}];
        [self.playerView edulineSeekToTime:[learn_record integerValue]];
    }
    
    
    //设置尺寸
    [_allScrollView bringSubviewToFront:_videoView];
    _videoView.frame = CGRectMake(0, scrollContentY, MainScreenWidth, 210 * WideEachUnit);
    isVideoExit = YES;
    //隐藏最上面的导航栏 (设置为透明色)
    _navigationView.backgroundColor = [UIColor clearColor];
    _videoTitleLabel.textColor = [UIColor clearColor];
    [_allScrollView bringSubviewToFront:_navigationView];
    
    //判断跑马灯
    [self detectionMarquee];
    
    if ([[_ailDownDict stringValueForKey:@"type"] integerValue] == 1) {//视频
        if ( [[_videoDataSource stringValueForKey:@"is_buy"] integerValue] != 0) {//解锁了的
            [_timer invalidate];
            self.timer = nil;
        } else {
            if ([[_ailDownDict stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了单课时
                [_timer invalidate];
                self.timer = nil;
            } else {
                if ([[_ailDownDict stringValueForKey:@"is_free"] integerValue] == 1) {//免费看
                    [_timer invalidate];
                    self.timer = nil;
                } else {//试看。受限制
                    if (_timeNum == 0) {
                        [TKProgressHUD showError:@"需先解锁此课程" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    } else {
                        self.timer = nil;
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoTimeMonitorAndAliPlayer) userInfo:nil repeats:YES];
                    }
                }
            }
        }
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 2) {//音频
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了的
        }else {//没有解锁
            [TKProgressHUD showError:@"解锁才能听此音频" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 3) {//文本
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了的
        }else {//没有解锁
            [TKProgressHUD showError:@"解锁才能看此文本" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addTextView];
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 4) {//文档
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁了的
        }else {//没有解锁
            [TKProgressHUD showError:@"解锁才能看此文档" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addWebView];
    }
}

- (void)addTextView {//文本
    isVideoExit = NO;
    self.textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_videoView addSubview:self.textView];
    
    NSString *textStr = [Passport filterHTML:_videoUrl];
    self.textView.text = textStr;
    self.textView.editable = NO;
    self.textView.userInteractionEnabled = YES;
    isTextViewBig = NO;
    
    //添加手势
    [self.textView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textClick:)]];
    isVideoExit = YES;
}

- (void)addWebView {//文档
    isVideoExit = NO;
    [_webView removeFromSuperview];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth,MainScreenHeight / 2)];
    //    if (iPhone4SOriPhone4) {
    //        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);
    //    } else if (iPhone5o5Co5S) {
    //        _webView.frame = CGRectMake(0, 70, MainScreenWidth, MainScreenWidth*3/5);
    //    } else if (iPhone6) {
    //        _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, 210 * WideEachUnit);
    //    } else if (iPhone6Plus) {
    //        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
    //    } else if (iPhoneX) {
    //        _webView.frame = CGRectMake(0, 88, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
    //    }
    _webView.frame = CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit);
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_videoView addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate = self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    url = [NSURL URLWithString:_videoUrl];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    isWebViewBig = NO;
    isVideoExit = YES;
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fakeTapGestureHandler:)];
    [tapGestureRecognizer setDelegate:self];
    [_webView.scrollView addGestureRecognizer:tapGestureRecognizer];
}

//百度文档
- (void)addBaiDuDoc {
    
    _canScroll = YES;
    [_tableView setContentOffset:CGPointZero animated:YES];
    [self tableViewCanNotScroll];
    
    //将之前的移除
    if (wmPlayer != nil|| wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
    }
    
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
    [_textView removeFromSuperview];
    [_webView removeFromSuperview];
    
    [_timer invalidate];
    self.timer = nil;
    
    if (self.reader == nil) {
        self.reader = [[BCEDocumentReader alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit)];
        self.reader.delegate = self;
        [self.view addSubview:self.reader];
    }
    [self.view bringSubviewToFront:_navigationView];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[_baiDuDocDict stringValueForKey:@"docId"] forKey:BDocPlayerSDKeyDocID];
    [dict setObject:[_baiDuDocDict stringValueForKey:@"token"] forKey:BDocPlayerSDKeyToken];
    [dict setObject:[_baiDuDocDict stringValueForKey:@"host"] forKey:BDocPlayerSDKeyHost];
    [dict setObject:[_baiDuDocDict stringValueForKey:@"format"] forKey:BDocPlayerSDKeyDocType];
    [dict setObject:[_seleCurrentDict stringValueForKey:@"title"] forKey:BDocPlayerSDKeyDocTitle];
    [dict setObject:@"1" forKey:BDocPlayerSDKeyPageNumber];
    [dict setObject:@"6" forKey:BDocPlayerSDKeyTotalPageNum];
    
    
    NSError* error;
    [self.reader loadDoc:dict error:&error];
    
    
    
}

- (void)docLoadingStart:(NSError*)error {
    
}

- (void)docLoadingEnded:(NSError*)error {
    
}


#pragma mark --- 手势添加

- (void)allWindowViewClick:(UITapGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

- (void)fakeTapGestureHandler:(UITapGestureRecognizer *)tap {
    __weak Good_ClassMainViewController *wekself = self;
    isWebViewBig = !isWebViewBig;
    if (isWebViewBig == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            wekself.webView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
            [wekself.view addSubview:wekself.webView];
            //方法 隐藏导航栏
            wekself.navigationController.navigationBar.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            wekself.webView.frame = CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit);
            [wekself.videoView addSubview:wekself.webView];
            wekself.navigationController.navigationBar.hidden = YES;
        }];
    }
}

//文本手势
- (void)textClick:(UITapGestureRecognizer *)tap {
    __weak Good_ClassMainViewController *wekself = self;
    isTextViewBig = !isTextViewBig;
    if (isTextViewBig == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            wekself.textView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
            [wekself.view addSubview:wekself.textView];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            wekself.textView.frame = CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit);
            [wekself.videoView addSubview:wekself.textView];
        }];
    }
}


#pragma mark --- 播放器的时间监听
- (void)videoTimeMonitor {
    if (_videoDataSource == nil) {
        
    } else {
        if ([[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0) {
            return;
        }
    }
    if ([[_videoDataSource stringValueForKey:@"is_free"] integerValue] == 1) {//如果免费
        return;
    }
    //监听播放时间
    CMTime cmTime = wmPlayer.player.currentTime;
    float videoDurationSeconds = CMTimeGetSeconds(cmTime);
    
    if (videoDurationSeconds  > _timeNum) {
        [wmPlayer.player pause];
        wmPlayer.playOrPauseBtn.selected = YES;//这句代码是暂停播放后播放按钮显示为暂停状态
        
        if (_imageView == nil || _imageView.subviews == nil) {
            //判断当前的播放器是小屏还是全屏
            if (wmPlayer.isFullscreen == YES) {//全屏
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenHeight, MainScreenWidth)];
            } else {//小屏
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(wmPlayer.frame))];
            }
            
            _imageView.image = [UIImage imageNamed:@"试看结束@2x"];
            [wmPlayer addSubview:_imageView];
            
            wmPlayer.playOrPauseBtn.enabled = NO;
            wmPlayer.playOrPauseBtn.selected = NO;
            wmPlayer.progressSlider.enabled = NO;
        }
    } else {//时间还没有到的
        wmPlayer.playOrPauseBtn.enabled = YES;
        wmPlayer.progressSlider.enabled = YES;
        if (_imageView.subviews.count == 0) {
            [_imageView removeFromSuperview];
        }
    }
}

- (void)videoTimeMonitorAndAliPlayer {
    if (_videoDataSource == nil) {
        
    } else {
        if ([[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0) {
            return;
        }
    }
    if ([[_videoDataSource stringValueForKey:@"is_free"] integerValue] == 1) {//如果免费
        return;
    }
    
    //监听播放时间
    NSString *ailTimeStr = [NSString stringWithFormat:@"%f",self.playerView.currentTime];
    float videoDurationSeconds = [ailTimeStr floatValue];
    
    if (videoDurationSeconds  > _timeNum) {
        [self.playerView pause];
        wmPlayer.playOrPauseBtn.selected = YES;//这句代码是暂停播放后播放按钮显示为暂停状态
        
        if (_imageView == nil || _imageView.subviews == nil) {
            //判断当前的播放器是小屏还是全屏
            if (self.playerView.frame.size.width == MainScreenWidth) {//说明是小屏的时候
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(self.playerView.frame))];
                _imageView.image = [UIImage imageNamed:@"试看结束@2x"];
                [self.playerView addSubview:_imageView];
            } else {
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(self.playerView.frame))];
                _imageView.image = [UIImage imageNamed:@"试看结束@2x"];
                [self.playerView addSubview:_imageView];
            }
            self.playerView.userInteractionEnabled = NO;
        } else {
            _imageView.hidden = NO;
            [self.playerView addSubview:_imageView];
            self.playerView.userInteractionEnabled = NO;
        }
    } else {//时间还没有到的
        wmPlayer.playOrPauseBtn.enabled = YES;
        wmPlayer.progressSlider.enabled = YES;
        if (_imageView.subviews.count == 0) {
            [_imageView removeFromSuperview];
        }
    }
}

#pragma mark ---- 本地拿数据 （专门针对阿里云视频）
- (void)getAilVideo {
    
    NSString *downVideoName = [_ailDownDict stringValueForKey:@"video_title"];
    self.downloadManage = [ZFDownloadManager sharedDownloadManager];
    NSMutableArray *finishedList = self.downloadManage.finishedlist;
    ZFFileModel *indexModel = nil;
    if (finishedList.count) {
        indexModel = [finishedList objectAtIndex:0];
    } else {
        //        return;
    }
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *cacheListPath = [paths stringByAppendingPathComponent:@"ZFDownLoad/CacheList/"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSArray *subPaths = [fileManager subpathsAtPath:cacheListPath];
    
    for (NSString *fileName in subPaths) {
        if ([fileName rangeOfString:@"阿里"].location != NSNotFound) {//就是当前视频
            NSString *currentFlieName = [NSString  stringWithFormat:@"%@/%@.mp4",cacheListPath,@"课时01 免费的阿里视频"];
            
        }
    }
    
    if ([indexModel.fileName rangeOfString:@"m3u8"].location != NSNotFound) {//就是下载的m3u8格式的视频
        if ([fileManager fileExistsAtPath:[cacheListPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m3u8",indexModel.fileName]]]) {
            NSString *pathLast = [NSString stringWithFormat:@"%@/%@",cacheListPath,indexModel.fileName];
            NSString * tttt = [NSString  stringWithFormat:@"%@.m3u8",pathLast];
            
            
            NSString *content = [NSString stringWithContentsOfFile:tttt
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
            
            
            //            BigWindCar_playViewController *plav = [[BigWindCar_playViewController alloc]initWithPath:tttt withName:[NSString stringWithFormat:@"%@",indexModel.fileName]];
            //            [self.navigationController pushViewController:plav animated:YES];
            
            
            return;
        }
    }
}

#pragma mark ---- 判断是够需要弹题
- (void)judgeNeedTest {
    if ([_seleCurrentDict stringValueForKey:@"qid"] == nil || [[_seleCurrentDict stringValueForKey:@"qid"] isEqualToString:@""]) {//没有弹题
        
    } else {//有弹题
        _popupTime = [[_seleCurrentDict stringValueForKey:@"popup_time"] integerValue];
        _popupTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoTimeNeedTest) userInfo:nil repeats:YES];
    }
}

//弹题的处理
- (void)videoTimeNeedTest {
    //监听播放时间
    NSString *ailTimeStr = [NSString stringWithFormat:@"%f",self.playerView.currentTime];
    float videoDurationSeconds = [ailTimeStr floatValue];
    
    if (videoDurationSeconds  > _popupTime) {//此时应该弹题
        if (isExitTestView) {
            return;
        } else {
            [self.playerView pause];
            //弹题处理
            ClassNeedTestViewController *vc = [[ClassNeedTestViewController alloc] initWithDict:_seleCurrentDict];
            [self.view addSubview:vc.view];
            vc.dict = _seleCurrentDict;
            [self addChildViewController:vc];
            isExitTestView = YES;
        }
        
    }
}



#pragma mark ---- aliPalyerDelegate


- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen{
    self.isLock = isLockScreen;
}


- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onVideoQualityChanged:(AliyunVodPlayerVideoQuality)quality{
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    NSLog(@"isfullScreen --%d",isFullScreen);
    
    self.isStatusHidden = isFullScreen;
    [self refreshUIWhenScreenChanged:isFullScreen];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView onVideoDefinitionChanged:(NSString *)videoDefinition {
    
}

- (void)onCircleStartWithVodPlayerView:(AliyunVodPlayerView *)playerView {
    
}

- (void)refreshUIWhenScreenChanged:(BOOL)isFullScreen{
    if (isFullScreen) {
        //自己项目里面的一些配置
        _moreButton.hidden = YES;
        _backButton.hidden = YES;
        _controllerSrcollView.userInteractionEnabled = NO;
        _videoView.frame = CGRectMake(0, 0, MainScreenHeight, MainScreenWidth);
        if (iPhone6) {
            _videoView.frame = CGRectMake(0, 0, 667, 375);
        } else if (iPhone6Plus) {
            _videoView.frame = CGRectMake(0, 0, 736, 414);
        } else if (iPhoneX) {
            _videoView.frame = CGRectMake(0, 0, 812, 375);
        } else if (iPhone5o5Co5S) {
            _videoView.frame = CGRectMake(0, 0, 568, 320);
        }
        _headerView.frame = _videoView.frame;
        _tableView.frame = _videoView.frame;
        _tableView.contentOffset = CGPointMake(0, 0);
        _mainDetailView.hidden = YES;
        _segleMentView.hidden = YES;
        _activityBackView.hidden = YES;
        _tableView.tableHeaderView = self.headerView;
    } else {
        _moreButton.hidden = NO;
        _backButton.hidden = NO;
        _controllerSrcollView.userInteractionEnabled = YES;
        _videoView.frame = CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit);
        _headerView.frame = CGRectMake(0, 0, MainScreenWidth, 280 * WideEachUnit);
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - MACRO_UI_SAFEAREA - 50 * HigtEachUnit);
        _controllerSrcollView.userInteractionEnabled = YES;
        _mainDetailView.hidden = NO;
        _segleMentView.hidden = NO;
        _activityBackView.hidden = NO;
        _tableView.tableHeaderView = self.headerView;
    }
    
    //试看图片尺寸配置
    if (_imageView == nil || _imageView.subviews == nil) {
        
    } else {
        _imageView.frame = _videoView.frame;
    }
}


#pragma mark --- UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    //    [TKProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    [TKProgressHUD showError:@"加载成功" toView:self.view];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //    [TKProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    [TKProgressHUD showError:@"加载失败" toView:self.view];
}

#pragma mark ---Marquee

- (void)detectionMarquee {
    if ([_marqueeOpenStr integerValue] == 1) {
        VideoMarqueeViewController *vc = [[VideoMarqueeViewController alloc] initWithDict:_marqueeDict];
        [_playerView addSubview:vc.view];
        [self addChildViewController:vc];
        return;
    }
}

#pragma mark --- 网络请求
- (void)netWorkVideoGetInfo {
    
    NSString *endUrlStr = YunKeTang_Video_video_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
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
    __weak Good_ClassMainViewController *wekself = self;
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([wekself.tableView isHeaderRefreshing]) {
            [wekself.tableView headerEndRefreshing];
        }
        wekself.videoDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[wekself.videoDataSource stringValueForKey:@"code"] integerValue] == 1) {
            if ([[wekself.videoDataSource dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                wekself.videoDataSource = [wekself.videoDataSource dictionaryValueForKey:@"data"];
            } else {
                wekself.videoDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        wekself.schoolInfo = [NSDictionary dictionaryWithDictionary:[wekself.videoDataSource objectForKey:@"school_info"]];
        wekself.imageUrl = [wekself.videoDataSource stringValueForKey:@"cover"];
        [wekself.videoCoverImageView sd_setImageWithURL:[NSURL URLWithString:wekself.imageUrl]];
        wekself.classTitle.text = [wekself.videoDataSource stringValueForKey:@"video_title"];
        
        [wekself.classTitle sizeToFit];
        [wekself.classTitle setHeight:_classTitle.height];
        [_mainDetailView setHeight:_classTitle.bottom + 10];
        [_teachersHeaderBackView setTop:_mainDetailView.bottom];
        [_headerView setHeight:_teachersHeaderBackView.bottom];
        
        _ordPrice.text = [NSString stringWithFormat:@"在学%@人",[_videoDataSource stringValueForKey:@"video_order_count"]];
        _priceLabel.text = [NSString stringWithFormat:@"育币%@",[_videoDataSource stringValueForKey:@"price"]];
//        [_attentionButton setTitle:[NSString stringWithFormat:@"育币 %@",[_videoDataSource stringValueForKey:@"price"]] forState:0];
        NSString *nowPrice = [NSString stringWithFormat:@"育币 %@",[_videoDataSource stringValueForKey:@"price"]];
        if (SWNOTEmptyDictionary(_activityInfo)) {
            NSString *eventType = [NSString stringWithFormat:@"%@",[[_activityInfo objectForKey:@"event_type_info"] objectForKey:@"type_code"]];
            if ([eventType integerValue] == 6) {
                nowPrice = [NSString stringWithFormat:@"育币 %@",[[_videoDataSource objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
            }
        }
        NSString *oldPrice = [NSString stringWithFormat:@"育币%@",[_videoDataSource stringValueForKey:@"v_price"]];
        if ([[_videoDataSource stringValueForKey:@"price"] floatValue] == 0) {
            nowPrice = @"免费";
            _priceLabel.text = @"免费";
            _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
        }
        NSString *priceFina = [NSString stringWithFormat:@"%@ %@",nowPrice,oldPrice];
        NSRange rangNow = [priceFina rangeOfString:nowPrice];
        NSRange rangOld = [priceFina rangeOfString:oldPrice];
        NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceFina];
        if ([[_videoDataSource stringValueForKey:@"price"] floatValue] == 0) {
            [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#47b37d"]} range:rangNow];
        } else {
            [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#f01414"]} range:rangNow];
        }
        [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888"]} range:rangOld];
        [_attentionButton setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:priceAtt] forState:0];
        if ([_orderSwitch integerValue] == 1) {
//            _studyNumber.text = [NSString stringWithFormat:@"在学%@人",[_videoDataSource stringValueForKey:@"video_order_count_mark"]];
            _ordPrice.text = [NSString stringWithFormat:@"在学%@人",[_videoDataSource stringValueForKey:@"video_order_count_mark"]];
        }
        _ordPrice.centerX = _attentionButton.centerX;
        _collectStr = [_videoDataSource stringValueForKey:@"iscollect"];
        if ([[_videoDataSource stringValueForKey:@"is_buy"] integerValue] == 1) {//已经解锁
            [_buyButton setTitle:@"已解锁" forState:UIControlStateNormal];
        } else {
            [_buyButton setTitle:@"立即解锁" forState:UIControlStateNormal];
        }
//        [self ordPriceDeal];//处理原价
        sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 * HigtEachUnit - MACRO_UI_UPHEIGHT;
        [wekself changeEventPriceUI];
        wekself.tableView.tableHeaderView = wekself.headerView;
        [wekself.tableView reloadData];
        [wekself netWorkTeacherGetInfo];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [wekself netWorkVideoGetInfo];
    }];
    [op start];
}

#pragma mark --- 网络请求
- (void)netWorkVideoGetInfoChangeStatus {
    
    NSString *endUrlStr = YunKeTang_Video_video_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
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
    __weak Good_ClassMainViewController *wekself = self;
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _videoDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_videoDataSource stringValueForKey:@"code"] integerValue] == 1) {
            if ([[_videoDataSource dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _videoDataSource = [_videoDataSource dictionaryValueForKey:@"data"];
            } else {
                _videoDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        _schoolInfo = [NSDictionary dictionaryWithDictionary:[_videoDataSource objectForKey:@"school_info"]];
        if (_buyButton) {
            if ([[_videoDataSource stringValueForKey:@"is_buy"] integerValue] == 1) {//已经解锁
                [_buyButton setTitle:@"已解锁" forState:UIControlStateNormal];
            } else {
                [_buyButton setTitle:@"立即解锁" forState:UIControlStateNormal];
            }
            if (SWNOTEmptyDictionary(_activityInfo)) {
                NSDictionary *myActivityInfo;
                if ([[_activityInfo objectForKey:@"user_asb"] isKindOfClass:[NSDictionary class]]) {
                    myActivityInfo = [NSDictionary dictionaryWithDictionary:[_activityInfo objectForKey:@"user_asb"]];
                }
                if (SWNOTEmptyDictionary(myActivityInfo)) {
                    if ([[myActivityInfo objectForKey:@"faild"] integerValue] == 1) {
                        
                    } else {
                        [_buyButton setTitle:@"去分享" forState:0];
                    }
                }
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [wekself netWorkVideoGetInfoChangeStatus];
    }];
    [op start];
}

// MARK: - 获取讲师详情
- (void)netWorkTeacherGetInfo {
    if (!SWNOTEmptyDictionary(_videoDataSource)) {
        return;
    }
    NSString *endUrlStr = YunKeTang_Teacher_teacher_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_videoDataSource objectForKey:@"teacher_id"] forKey:@"teacher_id"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    __weak Good_ClassMainViewController *wekself = self;
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
        [wekself setTeacherAndOrganizationData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

// MARK: - 获取h课程活动详情
- (void)getCourceActivityInfo {
    NSString *endUrlStr = YunKeTang_Course_Activity_Info;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"course_id"];
    if (_isClassNew) {
        [mutabDict setObject:@"6" forKey:@"course_type"];
    } else {
        [mutabDict setObject:@"1" forKey:@"course_type"];
    }
    
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
    __weak Good_ClassMainViewController *wekself = self;
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

//获取视频试看的时长
- (void)netWorkVideoGetFreeTime {
    
    NSString *endUrlStr = YunKeTang_Video_video_getFreeTime;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _timeNum = [[dict stringValueForKey:@"video_free_time"] integerValue];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
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
    } else {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            [_allWindowView removeFromSuperview];
            if ([_collectStr integerValue] == 1) {
                _collectStr = @"0";
            } else {
                _collectStr = @"1";
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
    [mutabDict setObject:@"0" forKey:@"type"];
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
            _shareVideoUrl = [dict stringValueForKey:@"share_url"];
            [self VideoShare];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取视频加密
- (void)netWorkConfigGetVideoKey {
    
    NSString *endUrlStr = YunKeTang_config_getVideoKey;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"10" forKey:@"count"];
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//获取是否免费能试看配置的接口
- (void)netWorkConfigFreeCourseLoginSwitch {
    
    NSString *endUrlStr = YunKeTang_config_freeCourseLoginSwitch;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([[dict stringValueForKey:@"free_course_opt"] integerValue] == 1) {
                _free_course_opt = @"1";
            } else if ([[dict stringValueForKey:@"free_course_opt"] integerValue] == 0) {
                _free_course_opt = @"0";
            }
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
                _serviceButton.center = CGPointMake(MainScreenWidth * 3 / 5.0, 1 + 49 * HigtEachUnit / 2.0);
                [_serviceButton setRight:_buyButton.left];
//                [_buyButton setMj_x:_serviceButton.right];
//                [_buyButton setWidth:MainScreenWidth - _serviceButton.right];
                [_downView addSubview:_serviceButton];
            } else {
                _serviceButton.hidden = YES;
                [_attentionButton setWidth:MainScreenWidth * 3 / 5.0];
                _ordPrice.centerX = _attentionButton.centerX;
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//配置跑马灯
- (void)netWorkVideoGetMarquee {
    
    NSString *endUrlStr = YunKeTang_Video_video_getMarquee;
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
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        NSLog(@"----%@",dict);
        _marqueeOpenStr = [dict stringValueForKey:@"is_open"];
        _marqueeDict = dict;
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//考试试题的详情
- (void)netWorkExamsGetPaperInfo {
    NSString *endUrlStr = YunKeTang_Exams_exams_getPaperInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([_seleCurrentDict stringValueForKey:@"eid"] == nil) {
        [TKProgressHUD showError:@"考试为空" toView:self.view];
        return;
    } else {
        [mutabDict setObject:[_seleCurrentDict stringValueForKey:@"eid"] forKey:@"paper_id"];
    }
    [mutabDict setObject:@"2" forKey:@"exams_type"];
    
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
    __weak Good_ClassMainViewController *wekself = self;
    [TKProgressHUD showMessag:@"加载中...." toView:[UIApplication sharedApplication].keyWindow];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([dict dictionaryValueForKey:@"paper_options"].allKeys.count == 0) {
            [TKProgressHUD showError:@"考试数据为空" toView:self.view];
            return ;
        }
        if ([[dict dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions"].allKeys.count == 0) {
            [TKProgressHUD showError:@"考试数据为空" toView:self.view];
            return ;
        }
        //        if ([_examsType integerValue] == 1) {//练习模式
        //            TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
        //            vc.examsType = _examsType;
        //            vc.dataSource = _dataSource;
        //            vc.testDict = _testDict;
        //            [self.navigationController pushViewController:vc animated:YES];
        //        } else {//考试模式
        //
        //        }
        
        TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
        vc.examsType = @"2";
        vc.dataSource = dict;
        vc.testDict = _seleCurrentDict;
        [wekself.navigationController pushViewController:vc animated:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [TKProgressHUD showError:@"加载失败" toView:self.view];
    }];
    [op start];
}


//获取百度文档的详情
- (void)netWorkVideoGetBaiduDocReadToken {
    NSString *endUrlStr = YunKeTang_Video_video_getBaiduDocReadToken;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutabDict setObject:[_seleCurrentDict stringValueForKey:@"cid"] forKey:@"cid"];
    
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
        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        
        NSLog(@"---%@",dict);
        _baiDuDocDict = dict;
        [self addBaiDuDoc];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [TKProgressHUD showError:@"加载失败" toView:self.view];
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
        if (_recordButton == nil) {
            self.introButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth/5.0, 50 * HigtEachUnit)];
            self.courseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/5.0, 0, MainScreenWidth/5.0, 50 * HigtEachUnit)];
            self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth*2/5.0, 0, MainScreenWidth/5.0, 50 * HigtEachUnit)];
            self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth*3/5.0, 0, MainScreenWidth/5.0, 50 * HigtEachUnit)];
            self.questionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth*4/5.0, 0, MainScreenWidth/5.0, 50 * HigtEachUnit)];
            [self.introButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.courseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.commentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.recordButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.questionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.introButton setTitle:@"简介" forState:0];
            [self.courseButton setTitle:@"目录" forState:0];
            [self.commentButton setTitle:@"点评" forState:0];
            [self.recordButton setTitle:@"笔记" forState:0];
            [self.questionButton setTitle:@"提问" forState:0];
            
            self.introButton.titleLabel.font = SYSTEMFONT(15);
            self.courseButton.titleLabel.font = SYSTEMFONT(15);
            self.commentButton.titleLabel.font = SYSTEMFONT(15);
            self.recordButton.titleLabel.font = SYSTEMFONT(15);
            self.questionButton.titleLabel.font = SYSTEMFONT(15);
            
            [self.introButton setTitleColor:[UIColor blackColor] forState:0];
            [self.courseButton setTitleColor:[UIColor blackColor] forState:0];
            [self.commentButton setTitleColor:[UIColor blackColor] forState:0];
            [self.recordButton setTitleColor:[UIColor blackColor] forState:0];
            [self.questionButton setTitleColor:[UIColor blackColor] forState:0];
            
            [self.introButton setTitleColor:BasidColor forState:UIControlStateSelected];
            [self.courseButton setTitleColor:BasidColor forState:UIControlStateSelected];
            [self.commentButton setTitleColor:BasidColor forState:UIControlStateSelected];
            [self.recordButton setTitleColor:BasidColor forState:UIControlStateSelected];
            [self.questionButton setTitleColor:BasidColor forState:UIControlStateSelected];
            
            self.introButton.selected = YES;
            
            self.blueLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 * HigtEachUnit, MainScreenWidth / 5.0, 1.5 * HigtEachUnit)];
            self.blueLineView.backgroundColor = BasidColor;
            self.blueLineView.centerX = self.introButton.centerX;
            
            UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 46 * HigtEachUnit, MainScreenWidth, 0.5 * HigtEachUnit)];
            grayLine.backgroundColor = GBLINECOLOR;
            
            [_bg addSubview:self.introButton];
            [_bg addSubview:self.courseButton];
            [_bg addSubview:self.commentButton];
            [_bg addSubview:self.recordButton];
            [_bg addSubview:self.questionButton];
            [_bg addSubview:self.blueLineView];
            [_bg addSubview:grayLine];
        }
        
        if (self.mainScroll == nil) {
            self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,46.5 * HigtEachUnit, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit)];
            self.mainScroll.contentSize = CGSizeMake(MainScreenWidth*5, 0);
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
            _activityWeb = [[ZhiboDetailIntroVC alloc] initWithNumID:_ID];
            _activityWeb.isZhibo = NO;
            _activityWeb.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _activityWeb.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _activityWeb.mainVC = self;
            _activityWeb.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            [self.mainScroll addSubview:_activityWeb.view];
            [self addChildViewController:_activityWeb];
        } else {
            _activityWeb.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _activityWeb.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _activityWeb.view.frame = CGRectMake(0,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            [_activityWeb changeMainScrollViewHeight:sectionHeight - 46.5 * HigtEachUnit];
        }
        
        if (_activityCommentList == nil) {
            _activityCommentList = [[Good_ClassCatalogViewController alloc] initWithNumID:_ID];
            _activityCommentList.isClassCourse = _isClassNew;
            _activityCommentList.sid = _sid;
            _activityCommentList.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _activityCommentList.vc = self;
            _activityCommentList.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _activityCommentList.videoInfoDict = _videoDataSource;
            _activityCommentList.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            [self.mainScroll addSubview:_activityCommentList.view];
            [self addChildViewController:_activityCommentList];
            [self addBlockCategory:_activityCommentList];
        } else {
            _activityCommentList.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _activityCommentList.view.frame = CGRectMake(MainScreenWidth,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            _activityCommentList.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
        }
        
        if (_activityQuestionList == nil) {
            _activityQuestionList = [[Good_ClassCommentViewController alloc] initWithNumID:_ID];
            _activityQuestionList.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _activityQuestionList.vc = self;
            _activityQuestionList.isNewClass = _isClassNew;
            _activityQuestionList.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _activityQuestionList.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            [self.mainScroll addSubview:_activityQuestionList.view];
            [self addChildViewController:_activityQuestionList];
        } else {
            _activityQuestionList.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _activityQuestionList.view.frame = CGRectMake(MainScreenWidth*2,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            _activityQuestionList.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
        }

        if (_notesList == nil) {
            _notesList = [[Good_ClassNotesViewController alloc] initWithNumID:_ID];
            _notesList.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _notesList.vc = self;
            _notesList.isNewClass = _isClassNew;
            _notesList.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _notesList.view.frame = CGRectMake(MainScreenWidth*3,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            [self.mainScroll addSubview:_notesList.view];
            [self addChildViewController:_notesList];
        } else {
            _notesList.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _notesList.view.frame = CGRectMake(MainScreenWidth*3,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            _notesList.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
        }

        if (_questionList == nil) {
            _questionList = [[Good_ClassAskQuestionsViewController alloc] initWithNumID:_ID];
            _questionList.tabelHeight = sectionHeight - 46.5 * HigtEachUnit;
            _questionList.vc = self;
            _questionList.isNewClass = _isClassNew;
            _questionList.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _questionList.view.frame = CGRectMake(MainScreenWidth*4,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            [self.mainScroll addSubview:_questionList.view];
            [self addChildViewController:_questionList];
        } else {
            _questionList.cellTabelCanScroll = !_canScrollAfterVideoPlay;
            _questionList.view.frame = CGRectMake(MainScreenWidth*4,0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
            _questionList.tableView.frame = CGRectMake(0, 0, MainScreenWidth, sectionHeight - 46.5 * HigtEachUnit);
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
    } else if (sender == self.recordButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 3, 0) animated:YES];
    } else if (sender == self.questionButton) {
        [self.mainScroll setContentOffset:CGPointMake(MainScreenWidth * 4, 0) animated:YES];
    }
}

- (void)createSubView {
    if (!self.headerView) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, (280+44) * HigtEachUnit)];
        self.headerView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScroll) {
        if (scrollView.contentOffset.x <= 0) {
            self.blueLineView.centerX = self.introButton.centerX;
            self.introButton.selected = YES;
            self.courseButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth * 2 && scrollView.contentOffset.x <= 2 * MainScreenWidth){
            self.blueLineView.centerX = self.commentButton.centerX;
            self.commentButton.selected = YES;
            self.introButton.selected = NO;
            self.courseButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth){
            self.blueLineView.centerX = self.courseButton.centerX;
            self.courseButton.selected = YES;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= 3*MainScreenWidth && scrollView.contentOffset.x <= 3*MainScreenWidth){
            self.blueLineView.centerX = self.recordButton.centerX;
            self.courseButton.selected = NO;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = YES;
            self.questionButton.selected = NO;
        }else if (scrollView.contentOffset.x >= 4*MainScreenWidth){
            self.blueLineView.centerX = self.questionButton.centerX;
            self.courseButton.selected = NO;
            self.introButton.selected = NO;
            self.commentButton.selected = NO;
            self.recordButton.selected = NO;
            self.questionButton.selected = YES;
        }
    } if (scrollView == self.tableView) {
        CGFloat bottomCellOffset = self.headerView.height - MACRO_UI_UPHEIGHT;
        if (scrollView.contentOffset.y > bottomCellOffset - 0.5) {
            _navigationView.backgroundColor = BasidColor;
            _videoTitleLabel.hidden = NO;
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                for (UIViewController *vc in self.childViewControllers) {
                    if (self.courseButton.selected) {
                        if ([vc isKindOfClass:[Good_ClassCatalogViewController class]]) {
                            Good_ClassCatalogViewController *vccomment = (Good_ClassCatalogViewController *)vc;
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
                        if ([vc isKindOfClass:[Good_ClassCommentViewController class]]) {
                            Good_ClassCommentViewController *vccomment = (Good_ClassCommentViewController *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.recordButton.selected) {
                        if ([vc isKindOfClass:[Good_ClassNotesViewController class]]) {
                            Good_ClassNotesViewController *vccomment = (Good_ClassNotesViewController *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                    if (self.questionButton.selected) {
                        if ([vc isKindOfClass:[Good_ClassAskQuestionsViewController class]]) {
                            Good_ClassAskQuestionsViewController *vccomment = (Good_ClassAskQuestionsViewController *)vc;
                            vccomment.cellTabelCanScroll = YES;
                        }
                    }
                }
            }
        }else{
            _navigationView.backgroundColor = [UIColor clearColor];
            _videoTitleLabel.hidden = YES;
            if (!self.canScroll) {//子视图没到顶部
                if (self.canScrollAfterVideoPlay) {
                    scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
                } else {
                    scrollView.contentOffset = CGPointMake(0, 0);
                }
            }
        }
    }
}

- (void)addBlockCategory:(Good_ClassCatalogViewController *)vc {
    __weak Good_ClassMainViewController *wekself = self;
    vc.videoDataSource = ^(NSDictionary *videoDataSource) {
        [_timer invalidate];
        wekself.timer = nil;
        _seleCurrentDict = videoDataSource;
        _ailDownDict = videoDataSource;
        _notifitonDic = videoDataSource;
        _videoUrl = [_notifitonDic stringValueForKey:@"video_address"];
        if ([[videoDataSource stringValueForKey:@"type"] integerValue] == 0 || [[videoDataSource stringValueForKey:@"type"] integerValue] == 1 || [[videoDataSource stringValueForKey:@"type"] integerValue] == 2 || [[videoDataSource stringValueForKey:@"type"] integerValue] == 5) {
            if ([[videoDataSource stringValueForKey:@"type"] integerValue] != 2) {
                //判断是否需要弹题出来
                isExitTestView = NO;
                [wekself judgeNeedTest];
                wekself.timer = nil;
                wekself.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:wekself selector:@selector(videoTimeMonitorAndAliPlayer) userInfo:nil repeats:YES];
            }
            [wekself removePassView];
            [wekself addAliYunPlayer];
            _canScroll = YES;
            [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            [wekself tableViewCanNotScroll];
        } else if ([[videoDataSource stringValueForKey:@"type"] integerValue] == 6) {
            [wekself removePassView];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"考试提示" message:@"是否现在前去考试？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [wekself netWorkExamsGetPaperInfo];
            }];
            [alertController addAction:sureAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:cancelAction];
            [wekself presentViewController:alertController animated:YES completion:nil];
            return;
        } else if ([[videoDataSource stringValueForKey:@"type"] integerValue] == 3) {
            [wekself removePassView];
            [wekself addTextView];
            _canScroll = YES;
            [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            [wekself tableViewCanNotScroll];
        } else if ([[videoDataSource stringValueForKey:@"type"] integerValue] == 4) {
            if ([[videoDataSource stringValueForKey:@"is_baidudoc"] integerValue] == 1) {
                [wekself netWorkVideoGetBaiduDocReadToken];
                return;
            } else {
                [wekself removePassView];
                _videoUrl = [_ailDownDict stringValueForKey:@"video_address"];
                [wekself addWebView];
                [_tableView setContentOffset:CGPointZero animated:YES];
                [wekself tableViewCanNotScroll];
            }
        }
        
        /**
        if ([[videoDataSource stringValueForKey:@"is_baidudoc"] integerValue] == 1) {
            [self netWorkVideoGetBaiduDocReadToken];
            return;
        }
        if ([[videoDataSource stringValueForKey:@"video_type"] integerValue] == 6) {//考试
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"考试提示" message:@"是否现在前去考试？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                [self netWorkExamsGetPaperInfo];
            }];
            [alertController addAction:sureAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }

        //判断是否需要弹题出来
        isExitTestView = NO;
        [self judgeNeedTest];
        if ([[videoDataSource stringValueForKey:@"video_address"] rangeOfString:YunKeTang_EdulineOssCnShangHai].location != NSNotFound) {
            _ailDownDict = videoDataSource;
            if ([[_ailDownDict stringValueForKey:@"type"] integerValue] == 4) {//阿里的文档
                if ([[_ailDownDict stringValueForKey:@"price"] floatValue] == 0) {
                    if ([_free_course_opt integerValue] == 1) {//还是需要登录
                        if (!UserOathToken) {
                            DLViewController *vc = [[DLViewController alloc] init];
                            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
                            [self.navigationController presentViewController:Nav animated:YES completion:nil];
                            return;
                        }
                    } else if ([_free_course_opt integerValue] == 0) {
                        
                    }
                }
                _videoUrl = [_ailDownDict stringValueForKey:@"video_address"];
                [self addWebView];
                [_tableView setContentOffset:CGPointZero animated:YES];
                [self tableViewCanNotScroll];
                
            } else {
                [self addAliYunPlayer];
                _canScroll = YES;
                [_tableView setContentOffset:CGPointZero animated:YES];
                [self tableViewCanNotScroll];
            }
            return ;
        } else {
            //            [self getVideoDataSource:videoDataSource];
            _ailDownDict = videoDataSource;
            _notifitonDic = videoDataSource;
            _videoUrl = [_notifitonDic stringValueForKey:@"video_address"];
            [self dealKindsOfType:videoDataSource];
            _canScroll = YES;
            [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            [self tableViewCanNotScroll];
        }
        */
    };
}

- (void)tableViewCanNotScroll {
    [self performSelector:@selector(canNotScroll) withObject:nil afterDelay:1];
}

- (void)canNotScroll {
    _canScroll = NO;
    _canScrollAfterVideoPlay = NO;
    sectionHeight = MainScreenHeight - MACRO_UI_SAFEAREA - 50 * HigtEachUnit - self.headerView.height;
    [_tableView reloadData];
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
        [_activityBackView setTop:_videoCoverImageView.bottom];
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
        [_activityBackView setTop:_videoCoverImageView.bottom];
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
        
        if (SWNOTEmptyDictionary(_videoDataSource)) {
            priceCount = [NSString stringWithFormat:@"%@",[[_videoDataSource objectForKey:@"mz_price"] objectForKey:@"eprice"]];
            discount = [NSString stringWithFormat:@"%@",[[_videoDataSource objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
            NSString *nowPrice = [NSString stringWithFormat:@"育币 %@",[_videoDataSource stringValueForKey:@"price"]];
            NSString *oldPrice = [NSString stringWithFormat:@"育币%@",[_videoDataSource stringValueForKey:@"v_price"]];
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                oldPrice = discount;
            }
            if ([[_videoDataSource stringValueForKey:@"price"] floatValue] == 0) {
                nowPrice = @"免费";
            }
            NSString *priceFina = [NSString stringWithFormat:@"%@ %@",nowPrice,oldPrice];
            NSRange rangNow = [priceFina rangeOfString:nowPrice];
            NSRange rangOld = [priceFina rangeOfString:oldPrice];
            NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceFina];
            if ([[_videoDataSource stringValueForKey:@"price"] floatValue] == 0) {
                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#47b37d"]} range:rangNow];
            } else {
                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#f01414"]} range:rangNow];
            }
            [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888"]} range:rangOld];
            [_attentionButton setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:priceAtt] forState:0];
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
                _rightYellowLabel.text = [NSString stringWithFormat:@"已抢(%@/%@)",[_activityInfo objectForKey:@"rest_count"],[_activityInfo objectForKey:@"total_count"]];
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
    if (SWNOTEmptyDictionary(_videoDataSource) && SWNOTEmptyDictionary(_activityInfo)) {
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
            if (SWNOTEmptyDictionary(_videoDataSource)) {
                priceCount = [NSString stringWithFormat:@"%@育币",[[_videoDataSource objectForKey:@"mz_price"] objectForKey:@"eprice"]];
                discount = [NSString stringWithFormat:@"%@育币",[[_videoDataSource objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
                NSString *nowPrice = [NSString stringWithFormat:@"育币 %@",[_videoDataSource stringValueForKey:@"price"]];
                NSString *oldPrice = [NSString stringWithFormat:@"育币%@",[_videoDataSource stringValueForKey:@"v_price"]];
                if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                    oldPrice = discount;
                }
                if ([[_videoDataSource stringValueForKey:@"price"] floatValue] == 0) {
                    nowPrice = @"免费";
                }
                NSString *priceFina = [NSString stringWithFormat:@"%@ %@",nowPrice,oldPrice];
                NSRange rangNow = [priceFina rangeOfString:nowPrice];
                NSRange rangOld = [priceFina rangeOfString:oldPrice];
                NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceFina];
                if ([[_videoDataSource stringValueForKey:@"price"] floatValue] == 0) {
                    [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#47b37d"]} range:rangNow];
                } else {
                    [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#f01414"]} range:rangNow];
                }
                [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888"]} range:rangOld];
                [_attentionButton setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:priceAtt] forState:0];
            }
            
            NSString *leftPrice = [NSString stringWithFormat:@"%@%@%@",activityType,priceCount,discount];
            NSRange priceRange = [leftPrice rangeOfString:priceCount];
            NSRange discountRange = [leftPrice rangeOfString:discount];
            NSMutableAttributedString *muta = [[NSMutableAttributedString alloc] initWithString:leftPrice];
            [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(19)} range:priceRange];
            [muta addAttributes:@{NSFontAttributeName: SYSTEMFONT(10),NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSStrikethroughColorAttributeName: [UIColor whiteColor]} range:discountRange];
            _otherLeftPriceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:muta];
            if ([[_videoDataSource objectForKey:@"is_buy"] integerValue] == 1) {
                [_otherActivityBackView setHeight:0];
                _otherActivityBackView.hidden = YES;
                [_otherActivityBackView setTop:_videoCoverImageView.bottom];
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
            if (SWNOTEmptyDictionary(_videoDataSource)) {
                priceCount = [NSString stringWithFormat:@"%@",[[_videoDataSource objectForKey:@"mz_price"] objectForKey:@"eprice"]];
                discount = [NSString stringWithFormat:@"%@",[[_videoDataSource objectForKey:@"mz_price"] objectForKey:@"oriPrice"]];
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
        [_otherActivityBackView setTop:_videoCoverImageView.bottom];
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
        
        _otherJoinIcon = [[UIButton alloc] initWithFrame:CGRectMake(_otherStarBtn.left - 80 - 10, (_otherActivityBackView.height - 30) / 2.0, 80, 30)];
        [_otherJoinIcon setTitle:@"参团" forState:0];
        [_otherJoinIcon setTitleColor:RGBHex(0xF12026) forState:0];
        _otherJoinIcon.backgroundColor = RGBHex(0xFBF259);
        _otherJoinIcon.titleLabel.font = SYSTEMFONT(13);
        _otherJoinIcon.layer.masksToBounds = YES;
        _otherJoinIcon.layer.cornerRadius = 3;
        [_otherJoinIcon addTarget:self action:@selector(joinGroupActivity) forControlEvents:UIControlEventTouchUpInside];
        [_otherActivityBackView addSubview:_otherJoinIcon];
        
        [_otherStarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_otherJoinIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
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
        [_otherActivityBackView setTop:_videoCoverImageView.bottom];
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
        if (SWNOTEmptyDictionary(_videoDataSource)) {
            priceCount = [NSString stringWithFormat:@"%@育币",[[_videoDataSource objectForKey:@"mz_price"] objectForKey:@"eprice"]];
            discount = [NSString stringWithFormat:@"%@育币",[[_videoDataSource objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
            NSString *nowPrice = [NSString stringWithFormat:@"育币 %@",[_videoDataSource stringValueForKey:@"price"]];
            NSString *oldPrice = [NSString stringWithFormat:@"育币%@",[_videoDataSource stringValueForKey:@"v_price"]];
            if ([[_activityInfo objectForKey:@"is_start"] integerValue] == 1) {
                oldPrice = discount;
            }
            if ([[_videoDataSource stringValueForKey:@"price"] floatValue] == 0) {
                nowPrice = @"免费";
            }
            NSString *priceFina = [NSString stringWithFormat:@"%@ %@",nowPrice,oldPrice];
            NSRange rangNow = [priceFina rangeOfString:nowPrice];
            NSRange rangOld = [priceFina rangeOfString:oldPrice];
            NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceFina];
            if ([[_videoDataSource stringValueForKey:@"price"] floatValue] == 0) {
                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#47b37d"]} range:rangNow];
            } else {
                [priceAtt addAttributes:@{NSFontAttributeName: SYSTEMFONT(16),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#f01414"]} range:rangNow];
            }
            [priceAtt addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888"]} range:rangOld];
            [_attentionButton setAttributedTitle:[[NSAttributedString alloc] initWithAttributedString:priceAtt] forState:0];
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
                [_otherActivityBackView setTop:_videoCoverImageView.bottom];
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
    if ([[_videoDataSource objectForKey:@"is_buy"] integerValue] == 1) {
        [_otherActivityBackView setHeight:0];
        _otherActivityBackView.hidden = YES;
        [_otherActivityBackView setTop:_videoCoverImageView.bottom];
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
    vc.courseType = _isClassNew ? @"5" : @"1";
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
    vc.dict = _videoDataSource;
    if (_isClassNew) {
        vc.typeStr = @"5";
    } else {
        vc.typeStr = @"1";
    }
    vc.cid = [_videoDataSource stringValueForKey:@"id"];
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
    if (SWNOTEmptyDictionary(_videoDataSource)) {
        TeacherMainViewController *vc = [[TeacherMainViewController alloc] initWithNumID:[_videoDataSource objectForKey:@"teacher_id"]];
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
