//
//  MyViewController.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//


#import "MyViewController.h"
#import "UIButton+WebCache.h"
#import "settingViewController.h"
#import "MyMsgViewController.h"
#import "receiveCommandViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "CData.h"
#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WebP.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "XZViewController.h"
#import "KCViewController.h"
#import "MYinfoTool.h"
#import "DLViewController.h"
#import "SYGBJViewController.h"
#import "GZViewController.h"
#import "FSViewController.h"
#import "GLReachabilityView.h"
#include "MyDownLoadViewController.h"
#import "LookRecodeViewController.h"
#import "StudyRecodeViewController.h"

#import "MyInstationViewController.h"
#import "MyLibraryViewController.h"

#import "SYG.h"
#import "BigWindCar.h"

#import "ExchangeViewController.h"
#import "MyLiveViewController.h"

#import "OrderPagerViewController.h"
#import "PersonInfoViewController.h"

#import "CollectMainViewController.h"
#import "MyAnswerMainViewController.h"
#import "MyClassMainViewController.h"
#import "MyGroupViewController.h"

//优化（财富以及会员中心）
#import "Good_MyBalanceViewController.h"
#import "Good_CommissionViewController.h"
#import "Good_ IntegralViewController.h"
#import "MemberCenterViewController.h"

//优化 （优惠券）
#import "Good_MyCardStockMainViewController.h"

//我的考试
#import "MyExamMainViewController.h"
#import "Good_MessageMainViewController.h"
#import "Good_MyDownLoadMainViewController.h"

#import "MyDownLineViewController.h"
#import "MeTeacherMainViewController.h"
#import "MyShareViewController.h"

#import "AttentionMainViewController.h"
#import "MyLineDownClassMainViewController.h"
#import "MyTeacherMangerDownClassViewController.h"
#import "MeTeacherLineClassViewController.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger _number;
    CGRect rect;
    NSDictionary *userDic;
    UIImageView *_imageView;
    UILabel *numberlbl;
    UIButton *_headBtn;
    UIView *_childView;
    UIView *_headerView;
    UILabel *_attentionLabel;
    UILabel *_fanLabel;
    UIView  *_SYGView;
    
    UILabel *_bancleLabel;//余额
    UILabel *_gainLabel;//提成
    UILabel *_scoreLabel;//积分
    UIButton *_memberButton;
    UIImageView *_memberImageView;
    UIView  *_memberView;
    NSDictionary *_vipDict;
    BOOL    isRefreshTeacher;
}

@property (strong ,nonatomic)UIButton *msgButton;
@property (strong ,nonatomic)NSDictionary *SYGDic;

@property (strong ,nonatomic)NSDictionary *SYGBarDic;

@property (strong ,nonatomic)NSDictionary *MyMoneyDic;

@property (strong ,nonatomic)UIView *SYGNOView;
@property (strong ,nonatomic)UIView *selfView;
@property (strong ,nonatomic)UIView *noLoginView;

@property (strong ,nonatomic)NSString *balance;

@property (strong ,nonatomic)NSString *score;

@property (strong ,nonatomic)NSString *account;

@property (strong ,nonatomic)NSString *collect_album;

@property (strong ,nonatomic)NSString *collect_video;

@property (strong ,nonatomic)NSString *fans;

@property (strong ,nonatomic)NSString *follow;

@property (strong ,nonatomic)NSString *note;

@property (strong ,nonatomic)NSString *videocont;

@property (strong ,nonatomic)NSString *wdcont;

@property (strong ,nonatomic)NSString *JJStr;

@property (strong ,nonatomic)NSString *card;

@property (strong ,nonatomic)UILabel *YHJJLabel;

@property (strong ,nonatomic)NSDictionary *XXDic;

@property (strong ,nonatomic)UIView *DYView;

@property (strong ,nonatomic)NSString *TXString;

@property (strong ,nonatomic)NSString *NameString;

@property (strong ,nonatomic)NSString *isWifi;//来监听是否有网的时候的状态

@property (strong ,nonatomic)UIButton *HButton;//红点显示按钮

@property (strong ,nonatomic)NSDictionary *userCountDict;
@property (strong ,nonatomic)NSDictionary *userAccountDict;

//是否是老师
@property (strong ,nonatomic)NSString    *isTeacher;

@end

@implementation MyViewController

-(UIView *)noLoginView {
    if (!_noLoginView) {
        _noLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, -20 * WideEachUnit, MainScreenWidth, 280 * WideEachUnit)];
        _noLoginView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
        [_noLoginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"默认背景-2@2x"]]];
    }
    return _noLoginView;
}

-(UIView *)selfView {
    if (!_selfView) {
        _selfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return _selfView;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"App_Key"] == nil) {
        [app netInitApp];
    }
    //判断是否登录
    if (UserOathToken == nil) {//没有登录的情况下
         [self addNOLoginView];
        self.noLoginView.hidden = NO;
    }else {//已经登录
        [self creatSubView];
        //移除没有登录情况下的界面
        self.noLoginView.hidden = YES;
        [self netWorkUserGetInfo];
        [self netWorkUserGetCount];
        [self netWorkUserGetUserVip];
        [self netWorkUserGetAccount];
    }
    
    NSLog(@"---%@",UserOathToken);
}

- (void)viewWillDisappear:(BOOL)animated {
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [GLReachabilityView isConnectionAvailable];
    
    [self interFace];
    [self addScrollView];
    [self creatSubView];
}

- (void)creatSubView {
    [_scrollView removeAllSubviews];
    [self addHeaderView];
    [self addBalanceAndScoreView];
    [self addOrderView];
    [self addMYView];
    [self addNav];
    
    //判断是否登录
    if (UserOathToken == nil) {//没有登录的情况下
        [self addNOLoginView];
    }else {//已经登录
        [self addBarView];
    }
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    _SYGView = SYGView;
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"个人中心";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20 * WideEachUnit];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    SYGView.alpha = 0;
    
    if (iPhoneX) {
        SYGView.frame = CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
}


- (void)interFace {
    
    isRefreshTeacher = YES;
    rect = [UIScreen mainScreen].applicationFrame;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFace:) name:@"userFace" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlyLogin:) name:@"OnlyLoginNSNotification" object:nil];
    
}

- (void)addScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width,MainScreenHeight - 49)];
    if (iPhoneX) {
        self.scrollView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 83);
    }
    self.scrollView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1];
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.scrollView];
    self.scrollView.bounces = NO;
    self.scrollView.delaysContentTouches = YES;
    self.scrollView.canCancelContentTouches= NO;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.delegate = self;
}

- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_headerView];
    
    UIImageView *backgroundImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, -20 * WideEachUnit, MainScreenWidth, 170 * WideEachUnit)];
    [backgroundImageView setImage:[UIImage imageNamed:@"my_bg100"]];
    backgroundImageView.userInteractionEnabled =YES;
    [_headerView addSubview:backgroundImageView];
    if (iPhone4SOriPhone4) {
        
    } else if (iPhone5o5Co5S) {
        
    } else if (iPhone6) {
        
    } else if (iPhone6Plus) {
        
    } else {//iphone x
        backgroundImageView.frame = CGRectMake(0, -50 * WideEachUnit, MainScreenWidth, 200 * WideEachUnit);
    }
    
    //添加信息按钮
    UIButton *msg = [UIButton buttonWithType:0];
    msg.frame = CGRectMake(MainScreenWidth - 90, 24, 25, 25);
    [msg setBackgroundImage:[UIImage imageNamed:@"message1@3x"] forState:0];
    [msg addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:msg];
    _msgButton = msg;
    

    
    //添加设置按钮
    UIButton *settting =[UIButton buttonWithType:0];
    settting.frame = CGRectMake(rect.size.width-43, 24, 25, 25);
    [settting setBackgroundImage:[UIImage imageNamed:@"set1@3x"] forState:0];
    [settting addTarget:self action:@selector(tosetting) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:settting];
    
    if (iPhone4SOriPhone4) {
        
    } else if (iPhone5o5Co5S) {
        
    } else if (iPhone6) {
        
    } else if (iPhone6Plus) {
        _msgButton.frame = CGRectMake(MainScreenWidth - 90, 55, 25, 25);
        settting.frame = CGRectMake(rect.size.width-43, 55, 25, 25);
    } else {//ihphone X
        _msgButton.frame = CGRectMake(MainScreenWidth - 90, 50, 25, 25);
        settting.frame = CGRectMake(rect.size.width-43, 50, 25, 25);
    }
    
    
    //添加用户头像
    _headBtn = [UIButton buttonWithType:0];
    _headBtn.frame = CGRectMake(30 * WideEachUnit, 70 * WideEachUnit, 60 * WideEachUnit, 60 * WideEachUnit);
    _headBtn.clipsToBounds = YES;
    _headBtn.layer.cornerRadius= 30 * WideEachUnit;
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[_allInformation stringValueForKey:@"avatar_small"]] forState:0 placeholderImage:Image(@"站位图")];
    [_headBtn.layer setBorderWidth:2.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255.0/255.0, 255.0/255.0, 255.0/255.0, 1 });
    [_headBtn.layer setBorderColor:colorref];//边框颜色
    [_headBtn addTarget:self action:@selector(userHeaderImageButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [backgroundImageView addSubview:_headBtn];
    
    
    //添加名字
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(100 * WideEachUnit, 80 * WideEachUnit, 200 * WideEachUnit, 20 * WideEachUnit)];
    _userName.textColor = [UIColor whiteColor];
    _userName.font = Font(14 * WideEachUnit);
    [backgroundImageView addSubview:_userName];
    
    NSString *userInfo = [Passport filePath];
    userDic = [[NSDictionary alloc]initWithContentsOfFile:userInfo];
    _userName.text = [NSString stringWithFormat:@"%@", [_allInformation stringValueForKey:@"uname"]];
    
    //添加关注和粉丝
    for (int i = 0 ; i < 2 ; i ++) {
        UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 * WideEachUnit + (60 * WideEachUnit + 2 * WideEachUnit) * i, 100 * WideEachUnit, 60 * WideEachUnit, 20 * WideEachUnit)];
        buttonLabel.backgroundColor = [UIColor clearColor];
        buttonLabel.textColor = [UIColor whiteColor];
        buttonLabel.font = Font(12 * WideEachUnit);
        buttonLabel.tag = i;
        buttonLabel.userInteractionEnabled = YES;
        [buttonLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLabelClick:)]];
        [backgroundImageView addSubview:buttonLabel];
        if (i == 0) {
            _attentionLabel = buttonLabel;
        } else if (i == 1) {
            _fanLabel = buttonLabel;
        }
        

        //添加按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60 * WideEachUnit, 20 * WideEachUnit)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        [button addTarget:self action:@selector(attentionAndFanButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [buttonLabel addSubview:button];
        
        if (iPhoneX) {
            buttonLabel.frame = CGRectMake(100 + (60 + 2) * i, 130, 60, 20);
            button.frame = CGRectMake(0, 30, 60, 20);
        }
        
        
    }
    
    //添加横线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(161 * WideEachUnit, 100 * WideEachUnit, 1 * WideEachUnit, 20 * WideEachUnit)];
    line.backgroundColor = [UIColor whiteColor];
    line.userInteractionEnabled = YES;
    [backgroundImageView addSubview:line];
    line.hidden = YES;
    
    
    //添加视图
    UIView *memberView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WideEachUnit, 85 * WideEachUnit, 100 * WideEachUnit, 30 * WideEachUnit)];
    memberView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    memberView.layer.cornerRadius = 12 * WideEachUnit;
    memberView.layer.masksToBounds = YES;
    [backgroundImageView addSubview:memberView];
    _memberView = memberView;
    _memberView.hidden = YES;
    
    //添加会员
    UIButton *memberButton = [[UIButton alloc] initWithFrame:CGRectMake(25 * WideEachUnit, 3 * WideEachUnit, 75 * WideEachUnit, 24 * WideEachUnit)];
    [memberButton setTitle:@"黄金会员>" forState:UIControlStateNormal];
    memberButton.backgroundColor = [UIColor clearColor];
    memberButton.titleLabel.font = Font(14 * WideEachUnit);
    memberButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20 * WideEachUnit, 0, 20 * WideEachUnit);
    [memberButton addTarget:self action:@selector(memberButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [memberView addSubview:memberButton];
    _memberButton = memberButton;
    
    //添加图片
    UIImageView *memberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 7 * WideEachUnit, 16 * WideEachUnit, 16 * WideEachUnit)];
    memberImageView.backgroundColor = [UIColor clearColor];
    memberImageView.layer.cornerRadius = 8 * WideEachUnit;
    memberImageView.layer.masksToBounds = YES;
    memberImageView.userInteractionEnabled = YES;
    [memberView addSubview:memberImageView];
    _memberImageView = memberImageView;
    
    if (iPhoneX) {
        _headBtn.frame = CGRectMake(30, 100, 60, 60);
        _userName.frame = CGRectMake(100, 110, 200, 20);
//        memberButton.frame = CGRectMake(25, 63, 75, 24);
    }
    
}

- (void)userHeaderImageButtonCilck {
    PersonInfoViewController *infoVc = [[PersonInfoViewController alloc] init];
    infoVc.allDict = _allInformation;
    [self.navigationController pushViewController:infoVc animated:YES];
}

- (void)attentionAndFanButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//关注
//        GZViewController *GZVC = [[GZViewController alloc] init];
//        [self.navigationController pushViewController:GZVC animated:YES];
        
        AttentionMainViewController *vc = [[AttentionMainViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (button.tag == 1) {//粉丝
        FSViewController *FSVC = [[FSViewController alloc] init];
        [self.navigationController pushViewController:FSVC animated:YES];
    }
}

- (void)addBalanceAndScoreView {
    //添加关注和粉丝
    NSInteger Num = 3;
    CGFloat viewW = MainScreenWidth / 3;
    CGFloat viewH = 60 * WideEachUnit;
    
    for (int i = 0 ; i < Num; i ++) {
        
        NSString *GZString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"follow" defaultValue:@"0"]];
        NSString *FSString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"fans" defaultValue:@"0"]];
        NSString *XBString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"score" defaultValue:@"0"]];
        NSString *YHKString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"card" defaultValue:@"0"]];
        
        NSArray *SYG = nil;
        if ([_isWifi isEqualToString:@"123"]) {
            NSString *F = [NSString stringWithFormat:@"%@",_follow];
            NSLog(@"%@",F);
            NSString *Fan = [NSString stringWithFormat:@"%@",_fans];
            NSString *XB = [NSString stringWithFormat:@"%@",_score];
            NSString *YH = _card;
            
            if ([F isEqualToString:@"(null)"]) {
                F = @"0";
            }
            if ([Fan isEqualToString:@"(null)"]) {
                Fan = @"0";
            }
            if ([XB isEqualToString:@"(null)"]) {
                XB = @"0";
            }
            
            SYG = @[F,Fan,XB,YH];
        }else {
            SYG = @[GZString,FSString,XBString,YHKString];
        }
        
        NSArray *GZArray = @[@"余额",@"收入",@"积分"];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(viewW * i, 160 * WideEachUnit, viewW, 20 * WideEachUnit);
        label.text = GZArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12 * WideEachUnit];
        label.textColor = [UIColor colorWithHexString:@"#888"];
        [_headerView addSubview:label];
        
        //添加数字
        UILabel *SZLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewW * i, 180 * WideEachUnit, viewW, 20 * WideEachUnit)];
        SZLabel.font = [UIFont systemFontOfSize:16 * WideEachUnit];
        SZLabel.text = SYG[i];
        [SZLabel setTextColor:[UIColor colorWithHexString:@"#333"]];
        SZLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:SZLabel];
        if (i == 0) {
            _bancleLabel = SZLabel;
            _bancleLabel.text = @"育币0";
        } else if (i == 1) {
            _gainLabel = SZLabel;
            _gainLabel.text = @"育币0";
        } else if (i == 2) {
            _scoreLabel = SZLabel;
            _scoreLabel.text = @"0";
        }
        
        //添加透明的按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(viewW * i, 150 * WideEachUnit, viewW,viewH)];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(GZFSButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + 100 * i;
        [_headerView addSubview:button];
        
    }
    
    //添加分割线
    for (int i = 0; i < Num - 1; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60) / Num + (MainScreenWidth - 60) / Num * i, 150 * WideEachUnit, 1, 60 * WideEachUnit)];
        label.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
        [_headerView addSubview:label];
    }

}

- (void)memberButtonCilck {
    MemberCenterViewController *vc = [[MemberCenterViewController alloc] init];
    vc.userName =  [_allInformation stringValueForKey:@"uname" defaultValue:@""];
    vc.vipDict = _vipDict;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buttonLabelClick:(UITapGestureRecognizer *)tap {
    NSLog(@"---%ld",tap.view.tag);
    
}

- (void)addNOLoginView {
    
    //添加试图
    [_scrollView addSubview:self.noLoginView];

    //添加头像
    UIButton *SYGButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SYGButton.frame = CGRectMake(MainScreenWidth / 2 - 40 * WideEachUnit, 90 * WideEachUnit, 80 * WideEachUnit, 80 * WideEachUnit);
    SYGButton.backgroundColor = [UIColor whiteColor];
    [SYGButton setBackgroundImage:[UIImage imageNamed:@"未登录头像.jpg"] forState:UIControlStateNormal];
    SYGButton.layer.cornerRadius = 40 * WideEachUnit;
    SYGButton.layer.masksToBounds = YES;
    [self.noLoginView addSubview:SYGButton];
    
    //添加登录按钮
    UIButton *LoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    LoginButton.frame = CGRectMake(MainScreenWidth / 2 - 60 * WideEachUnit, 200 * WideEachUnit, 120 * WideEachUnit, 40 * WideEachUnit);
    LoginButton.backgroundColor = [UIColor whiteColor];
    LoginButton.layer.cornerRadius = 5 * WideEachUnit;
    [LoginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [LoginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [LoginButton addTarget:self action:@selector(loginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.noLoginView addSubview:LoginButton];
    
}

- (void)loginButton {//登录按钮
    
    DLViewController *DLVC = [[DLViewController alloc] init];
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
    [self.navigationController presentViewController:Nav animated:YES completion:nil];
    
}

- (void)addBarView {

//    [self.scrollView addSubview:_bView];

}

- (void)addGZFSView {
    
    //将这些全部添加View上面
    UIView *DYView = [[UIView alloc] initWithFrame:CGRectMake(0, 220, MainScreenWidth, 40)];
    DYView.backgroundColor = [UIColor clearColor];
    [_bgIView addSubview:DYView];
    _DYView = DYView;
    
    //添加关注和粉丝
    NSInteger Num = 3;
    for (int i = 0 ; i < Num; i ++) {
        
        NSString *GZString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"follow" defaultValue:@"0"]];
        NSString *FSString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"fans" defaultValue:@"0"]];
        NSString *XBString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"score" defaultValue:@"0"]];
        NSString *YHKString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"card" defaultValue:@"0"]];
        
        NSArray *SYG = [NSArray array];
        if ([_isWifi isEqualToString:@"123"]) {
            NSString *F = [NSString stringWithFormat:@"%@",_follow];
            NSLog(@"%@",F);
            NSString *Fan = [NSString stringWithFormat:@"%@",_fans];
            NSString *XB = [NSString stringWithFormat:@"%@",_score];
            NSString *YH = _card;
            if (YH == nil) {
                YH = @"0";
            }
            
            if ([F isEqualToString:@"(null)"]) {
                F = @"0";
            }
            if ([Fan isEqualToString:@"(null)"]) {
                Fan = @"0";
            }
            if ([XB isEqualToString:@"(null)"]) {
                XB = @"0";
            }
            
            SYG = @[F,Fan,XB,YH];
        }else {
            SYG = @[GZString,FSString,XBString,YHKString];
        }

        NSArray *GZArray = @[@"关注",@"粉丝",@"积分"];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(30 + (MainScreenWidth - 60) / Num * i, 0, (MainScreenWidth - 60) / Num , 20);
        label.text = GZArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        [DYView addSubview:label];
        
        //添加数字
        UILabel *SZLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60) / Num * i, 20, (MainScreenWidth - 60) / Num , 20)];
        SZLabel.font = [UIFont systemFontOfSize:14];
        SZLabel.text = SYG[i];
        [SZLabel setTextColor:[UIColor whiteColor]];
        SZLabel.textAlignment = NSTextAlignmentCenter;
        [DYView addSubview:SZLabel];
        
        //添加透明的按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60 ) / Num * i, 0, (MainScreenWidth - 60) / Num , 40)];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(GZFSButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + 100 * i;
        [DYView addSubview:button];
        
    }
    
    //添加分割线
    for (int i = 0; i < Num - 1; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60) / Num + (MainScreenWidth - 60) / Num * i, 0, 1, 35)];
        label.backgroundColor = [UIColor whiteColor];
        [DYView addSubview:label];
    }
}

- (void)addOrderView {//添加订单试图
    
    _orderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame) - 10 * WideEachUnit, MainScreenWidth, 110)];
    _orderView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_orderView];
    
    //添加我的订单
    UILabel *DD = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 20)];
    DD.text = @"我的订单";
    [_orderView addSubview:DD];
    
    //添加按钮
    UIButton *allDD = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 150, SpaceBaside, 140, 20)];
    [allDD setTitle:@"查看全部" forState:UIControlStateNormal];
    [allDD setImage:Image(@"考试右@2x") forState:UIControlStateNormal];
    allDD.imageEdgeInsets =  UIEdgeInsetsMake(0,120,0,0);
    allDD.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    allDD.titleLabel.font = Font(15);
    [allDD setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [allDD addTarget:self action:@selector(allDDButton:) forControlEvents:UIControlEventTouchUpInside];
    allDD.tag = 10086;
    [_orderView addSubview:allDD];
    allDD.hidden = YES;
    
    
    CGFloat ButtonW = MainScreenWidth / 5;
    CGFloat ButtonH = ButtonW + 20;
    NSArray *titleArray = @[@"待支付",@"已取消",@"已完成",@"申请退款",@"已退款"];
    NSArray *image = @[@"order_pay@3x",@"order_cancel@3x",@"order_finish@3x",@"order_apply@3x",@"order_refund@2x"];
    
    //确定View 的大小
    _orderView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame) + 10 * WideEachUnit, MainScreenWidth,50 + ButtonH + SpaceBaside - SpaceBaside);

    
    for (int i = 0 ; i < 5 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 40, ButtonW, ButtonH)];

        [button setImage:Image(image[i]) forState:UIControlStateNormal];
        
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,0,20,0);
        
        button.titleLabel.font = Font(14);
        button.tag = 10087 + i;
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(allDDButton:) forControlEvents:UIControlEventTouchUpInside];
        [_orderView addSubview:button];
        
        //添加title
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, ButtonW - 10, ButtonW, 20)];
        title.text = titleArray[i];
        title.font = Font(14);
        title.textAlignment = NSTextAlignmentCenter;
        [button addSubview:title];
        
    }
}

- (void)allDDButton:(UIButton *)button {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    NSInteger Tag = button.tag;
//    AllOrderViewController *allOrderVc = [[AllOrderViewController alloc] init];
//    [self.navigationController pushViewController:allOrderVc animated:YES];
//    
//    allOrderVc.typeStr = [NSString stringWithFormat:@"%ld",Tag - 10086];
    
    
        OrderPagerViewController *orderVc = [[OrderPagerViewController alloc] init];
        [self.navigationController pushViewController:orderVc animated:YES];
    
        orderVc.typeStr = [NSString stringWithFormat:@"%ld",Tag - 10087];
    

}


- (void)addMYView {
    
    //添加整个View
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_orderView.frame) + SpaceBaside, MainScreenWidth, MainScreenHeight - 60 + 100)];
    SYGView.backgroundColor = [UIColor colorWithRed:245.f / 255 green:246.f / 255 blue:247.f / 255 alpha:1];
    SYGView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:SYGView];
    SYGView.userInteractionEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    
    CGFloat Bwidth = 45;
    CGFloat width = MainScreenWidth / 4 ;
    CGFloat spare = (MainScreenWidth / 4 - Bwidth) / 4;
    NSArray *SYGArray = @[@"我的课程",@"我的笔记",@"我的收藏",@"我的问答",@"我的考试",@"我的文库",@"我的下载",@"我的卡券",@"学习记录",@"兑换记录",@"我的机构",@"我的推荐"];
    NSArray *TBArray = @[@"live@3x",@"notes@3x",@"collect@3x",@"q&a@3x",@"ic_exam@3x",@"library@3x",@"download@3x",@"conpons@3x",@"study@3x",@"record@3x",@"org@3x",@"downLine"];
    

    
    if ([MoreOrSingle integerValue] == 1) {//单机构

        if ([HASALIPAY isEqualToString:@"0"]) {
            if ([_isTeacher integerValue] == 1) {
                SYGArray = @[@"我的课程",@"我的笔记",@"我的收藏",@"我的问答",@"我的考试",@"我的文库",@"我的下载",@"学习记录",@"兑换记录",@"我的推荐",@"我的授课"];
                TBArray = @[@"live@3x",@"notes@3x",@"collect@3x",@"q&a@3x",@"ic_exam@3x",@"library@3x",@"download@3x",@"study@3x",@"record@3x",@"downLine",@"me_is_teacher"];
            } else {
                SYGArray = @[@"我的课程",@"我的笔记",@"我的收藏",@"我的问答",@"我的考试",@"我的文库",@"我的下载",@"学习记录",@"兑换记录",@"我的推荐"];
                TBArray = @[@"live@3x",@"notes@3x",@"collect@3x",@"q&a@3x",@"ic_exam@3x",@"library@3x",@"download@3x",@"study@3x",@"record@3x",@"downLine"];
            }
        } else {
            if ([_isTeacher integerValue] == 1) {
                SYGArray = @[@"我的课程",@"我的笔记",@"我的收藏",@"我的问答",@"我的考试",@"我的文库",@"我的下载",@"我的卡券",@"学习记录",@"兑换记录",@"我的推荐",@"我的授课"];
                TBArray = @[@"live@3x",@"notes@3x",@"collect@3x",@"q&a@3x",@"ic_exam@3x",@"library@3x",@"download@3x",@"conpons@3x",@"study@3x",@"record@3x",@"downLine",@"me_is_teacher"];
            } else {
                SYGArray = @[@"我的课程",@"我的笔记",@"我的收藏",@"我的问答",@"我的考试",@"我的文库",@"我的下载",@"我的卡券",@"学习记录",@"兑换记录",@"我的推荐"];
                TBArray = @[@"live@3x",@"notes@3x",@"collect@3x",@"q&a@3x",@"ic_exam@3x",@"library@3x",@"download@3x",@"conpons@3x",@"study@3x",@"record@3x",@"downLine"];
            }
        }
        
    } else if ([MoreOrSingle integerValue] == 2) {

        if ([HASALIPAY isEqualToString:@"0"]) {
            if ([_isTeacher integerValue] == 1) {
                SYGArray = @[@"我的课程",@"我的笔记",@"我的收藏",@"我的问答",@"我的考试",@"我的文库",@"我的下载",@"学习记录",@"兑换记录",@"我的机构",@"我的推荐",@"我的授课",@"我的分享",@"我的线下课",@"线下课管理"];
                TBArray = @[@"live@3x",@"notes@3x",@"collect@3x",@"q&a@3x",@"ic_exam@3x",@"library@3x",@"download@3x",@"study@3x",@"record@3x",@"org@3x",@"downLine",@"me_is_teacher",@"icon-share",@"me_is_teacher",@"me_is_teacher"];
            } else {
                SYGArray = @[@"我的课程",@"我的笔记",@"我的收藏",@"我的问答",@"我的考试",@"我的文库",@"我的下载",@"学习记录",@"兑换记录",@"我的机构",@"我的推荐",@"我的分享",@"我的线下课"];
                TBArray = @[@"live@3x",@"notes@3x",@"collect@3x",@"q&a@3x",@"ic_exam@3x",@"library@3x",@"download@3x",@"study@3x",@"record@3x",@"org@3x",@"downLine",@"icon-share",@"me_is_teacher"];
            }
        } else {
            if ([_isTeacher integerValue] == 1) {
                SYGArray = @[@"我的课程",@"我的笔记",@"我的收藏",@"我的问答",@"我的考试",@"我的文库",@"我的下载",@"我的卡券",@"学习记录",@"兑换记录",@"我的机构",@"我的推荐",@"我的授课",@"我的分享",@"我的线下课",@"线下课管理"];
                TBArray = @[@"live@3x",@"notes@3x",@"collect@3x",@"q&a@3x",@"ic_exam@3x",@"library@3x",@"download@3x",@"conpons@3x",@"study@3x",@"record@3x",@"org@3x",@"downLine",@"me_is_teacher",@"icon-share",@"me_is_teacher",@"me_is_teacher"];
            } else {
                SYGArray = @[@"我的课程",@"我的笔记",@"我的收藏",@"我的问答",@"我的考试",@"我的文库",@"我的下载",@"我的卡券",@"学习记录",@"兑换记录",@"我的机构",@"我的推荐",@"我的分享",@"我的线下课"];
                TBArray = @[@"live@3x",@"notes@3x",@"collect@3x",@"q&a@3x",@"ic_exam@3x",@"library@3x",@"download@3x",@"conpons@3x",@"study@3x",@"record@3x",@"org@3x",@"downLine",@"icon-share",@"me_is_teacher"];
            }
        }
    }
    for (int i = 0 ; i < SYGArray.count ; i ++) {

        UIButton *TBButton = [[UIButton alloc] initWithFrame:CGRectMake((width - Bwidth) / 2 +width * (i % 4) , 130 * (i / 4) + 25 , Bwidth, Bwidth)];
        [TBButton setBackgroundImage:[UIImage imageNamed:TBArray[i]] forState:UIControlStateNormal];
        [SYGView addSubview:TBButton];

        //添加文字
        UILabel *WZLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * (i % 4) ,80 + 10 + (i / 4) * 130 ,width,20)];
        WZLabel.text = SYGArray[i];
        WZLabel.textAlignment = NSTextAlignmentCenter;
        WZLabel.font = [UIFont systemFontOfSize:13];
        [SYGView addSubview:WZLabel];
        
        //添加透明的按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width * (i % 4), 130 * (i / 4), width, 130)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        [button addTarget:self action:@selector(SYGButtton:) forControlEvents:UIControlEventTouchUpInside];
        [SYGView addSubview:button];
        _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame) + CGRectGetMaxY(_orderView.frame));
        
        if (iPhone6) {
             _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame) + CGRectGetMaxY(_orderView.frame) - 38);
            
            if (currentIOS >= 11.0) {
                 _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame) + CGRectGetMaxY(_orderView.frame) - 38 + 40 + 5);
            }
            
        } else if (iPhone5o5Co5S) {
            
        } else if (iPhone6Plus) {
              _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame) + CGRectGetMaxY(_orderView.frame) - 38 - 5);
            if (currentIOS >= 11.0) {
                _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame) + CGRectGetMaxY(_orderView.frame) - 38 - 5 + 50);
            }
        } else {//iphongx
             _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame) + CGRectGetMaxY(_orderView.frame) - 10 + 50);
        }
    }
    
    
    //添加线
    for (int i = 1 ; i < 4 ; i ++) {
        UIButton *Sline = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 4 * i, 0, 1, 390)];
        Sline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [SYGView addSubview:Sline];
        
        UIButton *Hline = [[UIButton alloc] initWithFrame:CGRectMake(0, 130 * i , MainScreenWidth,1)];
        if (i == 1) {
            if ([_isTeacher integerValue] == 1) {
                Sline.frame = CGRectMake(MainScreenWidth / 4 * i, 0, 1, 390 + 130);
            }
        }
        if ([MoreOrSingle integerValue] == 1) {
            if (i == 3) {
                Sline.frame = CGRectMake(MainScreenWidth / 4 * i, 0, 1, 260);
            }
        } else {
            if (i == 1) {
                Sline.frame = CGRectMake(MainScreenWidth / 4 * i, 0, 1, 390 + 130);
            }
             Sline.frame = CGRectMake(MainScreenWidth / 4 * i, 0, 1, 390 + 130);
        }
        Hline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [SYGView addSubview:Hline];
    }
}


- (void)addImageAndButton {
    
    _headBtn = [UIButton buttonWithType:0];
    _headBtn.frame = CGRectMake((rect.size.width-80)/2, 54, 80, 80);
    _headBtn.clipsToBounds = YES;
    _headBtn.layer.cornerRadius= 40;
    //添加时间
    [_headBtn addTarget:self action:@selector(GoToSetting) forControlEvents:UIControlEventTouchUpInside];
    
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[_allInformation  stringValueForKey:@"avatar_big"]] forState:0 placeholderImage:nil];
    
    [_headBtn.layer setBorderWidth:2.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255.0/255.0, 255.0/255.0, 255.0/255.0, 1 });
    [_headBtn.layer setBorderColor:colorref];//边框颜色
    [_bView addSubview:_headBtn];
    
    _userName.text = [NSString stringWithFormat:@"%@",[_allInformation stringValueForKey:@"uname"]];
    _userName.textColor = [UIColor whiteColor];
}

#pragma mark --- 点击事件

- (void)msgClick
{
    if (UserOathToken == nil) {//没有登录
        //提示去登录
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }else {//已经登录
        Good_MessageMainViewController *vc = [[Good_MessageMainViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tosetting
{
    if (UserOathToken == nil) {//没有登录的情况下
        //去登录
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }else {//已经登录
        settingViewController *set = [[settingViewController alloc]initWithUserFace:_imageView.image userName:[userDic objectForKey:@"uname"]];
        set.score = _score;
        set.allDic = _allInformation;
        [self.navigationController pushViewController:set animated:YES];
    }
}

- (void)GoToSetting {
    PersonInfoViewController *infoVc = [[PersonInfoViewController alloc] init];
    infoVc.allDict = _allInformation;
    [self.navigationController pushViewController:infoVc animated:YES];
}

- (void)GZFSButton:(UIButton *)button {
    
    if (button.tag == 100) {//余额
        Good_MyBalanceViewController *vc = [[Good_MyBalanceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (button.tag == 200) {//提成
        Good_CommissionViewController *vc = [[Good_CommissionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (button.tag == 300) {//积分
        Good__IntegralViewController *vc = [[Good__IntegralViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)SYGButtton:(UIButton *)button {
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }else {//已经登录
        [self manyButtonSet:button];
    }
}



-(void)userFace:(NSNotification *)info
{
    UIImage *image = [UIImage imageWithData:[info.userInfo objectForKey:@"userFace"]];
    [_headBtn setBackgroundImage:image forState:0];
    [_headBtn sd_setBackgroundImageWithURL:[[NSUserDefaults standardUserDefaults]objectForKey:@"small" ] forState:0];
    _imageView.image = image;
}

- (void)manyButtonSet:(UIButton *)button {
    if ([MoreOrSingle integerValue] == 1) {
        if ([HASALIPAY isEqualToString:@"0"]) {
            if (button.tag == 0) {//说明是课程
                MyClassMainViewController *myClassVc = [[MyClassMainViewController alloc] init];
                [self.navigationController pushViewController:myClassVc animated:YES];
            }
            if (button.tag == 1) {//说明是笔记
                SYGBJViewController *SYGBJVC = [[SYGBJViewController alloc] init];
                [self.navigationController pushViewController:SYGBJVC animated:YES];
            }
            if (button.tag == 2) {//说明是收藏
                CollectMainViewController *collectMainVc = [[CollectMainViewController alloc] init];
                [self.navigationController pushViewController:collectMainVc animated:YES];
            }
            if (button.tag == 3) {//说明是问答
                MyAnswerMainViewController *answerMainVc = [[MyAnswerMainViewController alloc] init];
                [self.navigationController pushViewController:answerMainVc animated:YES];
            }
            if (button.tag == 4) {//我的考试
                MyExamMainViewController *myEaxmVc = [[MyExamMainViewController alloc] init];
                [self.navigationController pushViewController:myEaxmVc animated:YES];
            }
            if (button.tag == 5) {//我的文库
                MyLibraryViewController *myLibVc = [[MyLibraryViewController alloc] init];
                [self.navigationController pushViewController:myLibVc animated:YES];
            }
            if (button.tag == 6) {//说明是我的下载
                Good_MyDownLoadMainViewController *vc = [[Good_MyDownLoadMainViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
//            if (button.tag == 7) {//我的优惠券
//                Good_MyCardStockMainViewController *vc = [[Good_MyCardStockMainViewController alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
            if (button.tag == 7) {//观看记录
                LookRecodeViewController *lookVc = [[LookRecodeViewController alloc] init];
                [self.navigationController pushViewController:lookVc animated:YES];
            }
            if (button.tag == 8) {//说明是兑换记录
                ExchangeViewController *JYJLVC =  [[ExchangeViewController alloc] init];
                [self.navigationController pushViewController:JYJLVC animated:YES];
            }
            if (button.tag == 9) {
                MyDownLineViewController *vc = [[MyDownLineViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (button.tag == 10) {
                MeTeacherMainViewController *vc = [[MeTeacherMainViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            if (button.tag == 0) {//说明是课程
                MyClassMainViewController *myClassVc = [[MyClassMainViewController alloc] init];
                [self.navigationController pushViewController:myClassVc animated:YES];
            }
            if (button.tag == 1) {//说明是笔记
                SYGBJViewController *SYGBJVC = [[SYGBJViewController alloc] init];
                [self.navigationController pushViewController:SYGBJVC animated:YES];
            }
            if (button.tag == 2) {//说明是收藏
                CollectMainViewController *collectMainVc = [[CollectMainViewController alloc] init];
                [self.navigationController pushViewController:collectMainVc animated:YES];
            }
            if (button.tag == 3) {//说明是问答
                MyAnswerMainViewController *answerMainVc = [[MyAnswerMainViewController alloc] init];
                [self.navigationController pushViewController:answerMainVc animated:YES];
            }
            if (button.tag == 4) {//我的考试
                MyExamMainViewController *myEaxmVc = [[MyExamMainViewController alloc] init];
                [self.navigationController pushViewController:myEaxmVc animated:YES];
            }
            if (button.tag == 5) {//我的文库
                MyLibraryViewController *myLibVc = [[MyLibraryViewController alloc] init];
                [self.navigationController pushViewController:myLibVc animated:YES];
            }
            if (button.tag == 6) {//说明是我的下载
                Good_MyDownLoadMainViewController *vc = [[Good_MyDownLoadMainViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (button.tag == 7) {//我的优惠券
                Good_MyCardStockMainViewController *vc = [[Good_MyCardStockMainViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (button.tag == 8) {//观看记录
                LookRecodeViewController *lookVc = [[LookRecodeViewController alloc] init];
                [self.navigationController pushViewController:lookVc animated:YES];
            }
            if (button.tag == 9) {//说明是兑换记录
                ExchangeViewController *JYJLVC =  [[ExchangeViewController alloc] init];
                [self.navigationController pushViewController:JYJLVC animated:YES];
            }
            if (button.tag == 10) {
                MyDownLineViewController *vc = [[MyDownLineViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (button.tag == 11) {
                MeTeacherMainViewController *vc = [[MeTeacherMainViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    } else {
        if ([HASALIPAY isEqualToString:@"0"]) {
            if (button.tag == 0) {//说明是课程
                MyClassMainViewController *myClassVc = [[MyClassMainViewController alloc] init];
                [self.navigationController pushViewController:myClassVc animated:YES];
            }
            if (button.tag == 1) {//说明是笔记
                SYGBJViewController *SYGBJVC = [[SYGBJViewController alloc] init];
                [self.navigationController pushViewController:SYGBJVC animated:YES];
            }
            if (button.tag == 2) {//说明是收藏
                CollectMainViewController *collectMainVc = [[CollectMainViewController alloc] init];
                [self.navigationController pushViewController:collectMainVc animated:YES];
            }
            if (button.tag == 8) {//说明是兑换记录
                ExchangeViewController *JYJLVC =  [[ExchangeViewController alloc] init];
                [self.navigationController pushViewController:JYJLVC animated:YES];
            }
            if (button.tag == 10) {
                MyDownLineViewController *vc = [[MyDownLineViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (button.tag == 11) {
                
                if ([_isTeacher integerValue] == 1) {
                    MeTeacherMainViewController *vc = [[MeTeacherMainViewController alloc] init];
                    //                vc.allMyDict = _allInformation;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    MyShareViewController *vc = [[MyShareViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            if (button.tag == 12) {
                
                if ([_isTeacher integerValue] == 1) {
                    MyShareViewController *vc = [[MyShareViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    MyLineDownClassMainViewController *vc = [[MyLineDownClassMainViewController alloc] init];
                    vc.allMyDict = _allInformation;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            
            if (button.tag == 13) {
                if ([_isTeacher integerValue] == 1) {
                    MyLineDownClassMainViewController *vc = [[MyLineDownClassMainViewController alloc] init];
                    vc.allMyDict = _allInformation;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    MyLineDownClassMainViewController *vc = [[MyLineDownClassMainViewController alloc] init];
                    vc.allMyDict = _allInformation;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            
            if (button.tag == 14) {
                MyTeacherMangerDownClassViewController *vc = [[MyTeacherMangerDownClassViewController alloc] init];
                vc.allMyDict = _allInformation;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            if (button.tag == 3) {//说明是问答
                MyAnswerMainViewController *answerMainVc = [[MyAnswerMainViewController alloc] init];
                [self.navigationController pushViewController:answerMainVc animated:YES];
            }
            if (button.tag == 6) {//说明是我的下载
                Good_MyDownLoadMainViewController *vc = [[Good_MyDownLoadMainViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (button.tag == 7) {//观看记录
                StudyRecodeViewController *lookVc = [[StudyRecodeViewController alloc] init];
                [self.navigationController pushViewController:lookVc animated:YES];
            }
            if (button.tag == 9) {//我的机构
                MyInstationViewController *myInsnVc = [[MyInstationViewController alloc] init];
                [self.navigationController pushViewController:myInsnVc animated:YES];
            }
            if (button.tag == 5) {//我的文库
                MyLibraryViewController *myLibVc = [[MyLibraryViewController alloc] init];
                [self.navigationController pushViewController:myLibVc animated:YES];
            }
            if (button.tag == 4) {//我的考试
                MyExamMainViewController *myEaxmVc = [[MyExamMainViewController alloc] init];
                [self.navigationController pushViewController:myEaxmVc animated:YES];
            }
        } else {
            if (button.tag == 0) {//说明是课程
                MyClassMainViewController *myClassVc = [[MyClassMainViewController alloc] init];
                [self.navigationController pushViewController:myClassVc animated:YES];
            }
            if (button.tag == 1) {//说明是笔记
                SYGBJViewController *SYGBJVC = [[SYGBJViewController alloc] init];
                [self.navigationController pushViewController:SYGBJVC animated:YES];
            }
            if (button.tag == 2) {//说明是收藏
                CollectMainViewController *collectMainVc = [[CollectMainViewController alloc] init];
                [self.navigationController pushViewController:collectMainVc animated:YES];
            }
            if (button.tag == 9) {//说明是兑换记录
                ExchangeViewController *JYJLVC =  [[ExchangeViewController alloc] init];
                [self.navigationController pushViewController:JYJLVC animated:YES];
            }
            if (button.tag == 11) {
                MyDownLineViewController *vc = [[MyDownLineViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (button.tag == 12) {
                
                if ([_isTeacher integerValue] == 1) {
                    MeTeacherMainViewController *vc = [[MeTeacherMainViewController alloc] init];
                    //                vc.allMyDict = _allInformation;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    MyShareViewController *vc = [[MyShareViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            if (button.tag == 13) {
                
                if ([_isTeacher integerValue] == 1) {
                    MyShareViewController *vc = [[MyShareViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    MyLineDownClassMainViewController *vc = [[MyLineDownClassMainViewController alloc] init];
                    vc.allMyDict = _allInformation;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            
            if (button.tag == 14) {
                if ([_isTeacher integerValue] == 1) {
                    //                MeTeacherLineClassViewController *vc = [[MeTeacherLineClassViewController alloc] init];
                    //                [self.navigationController pushViewController:vc animated:YES];
                    
                    MyLineDownClassMainViewController *vc = [[MyLineDownClassMainViewController alloc] init];
                    vc.allMyDict = _allInformation;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    MyLineDownClassMainViewController *vc = [[MyLineDownClassMainViewController alloc] init];
                    vc.allMyDict = _allInformation;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            
            if (button.tag == 15) {
                MyTeacherMangerDownClassViewController *vc = [[MyTeacherMangerDownClassViewController alloc] init];
                vc.allMyDict = _allInformation;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            if (button.tag == 3) {//说明是问答
                MyAnswerMainViewController *answerMainVc = [[MyAnswerMainViewController alloc] init];
                [self.navigationController pushViewController:answerMainVc animated:YES];
            }
            if (button.tag == 6) {//说明是我的下载
                Good_MyDownLoadMainViewController *vc = [[Good_MyDownLoadMainViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (button.tag == 8) {//观看记录
                StudyRecodeViewController *lookVc = [[StudyRecodeViewController alloc] init];
                [self.navigationController pushViewController:lookVc animated:YES];
            }
            if (button.tag == 7) {//我的优惠券
                Good_MyCardStockMainViewController *vc = [[Good_MyCardStockMainViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (button.tag == 10) {//我的机构
                MyInstationViewController *myInsnVc = [[MyInstationViewController alloc] init];
                [self.navigationController pushViewController:myInsnVc animated:YES];
            }
            if (button.tag == 5) {//我的文库
                MyLibraryViewController *myLibVc = [[MyLibraryViewController alloc] init];
                [self.navigationController pushViewController:myLibVc animated:YES];
            }
            if (button.tag == 4) {//我的考试
                MyExamMainViewController *myEaxmVc = [[MyExamMainViewController alloc] init];
                [self.navigationController pushViewController:myEaxmVc animated:YES];
            }
        }
    }
}

#pragma mark ---- 通知 (唯一登录)
- (void)onlyLogin:(NSNotification *)not {
    NSDictionary *dict = (NSDictionary *)not.object;
    NSString *message = [dict stringValueForKey:@"msg"];
    [TKProgressHUD showError:message toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        Passport *ps = [[Passport alloc] init];
        [ps goOutLogin];
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    });
}

#pragma mark ---- 网络请求
//获取用户信息
- (void)netWorkUserGetInfo {
    
    NSString *endUrlStr = YunKeTang_User_user_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (UserID == nil) {
    } else {
         [mutabDict setObject:UserID forKey:@"user_id"];
    }
    
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
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _allInformation = [dict dictionaryValueForKey:@"data"];
            } else {
                _allInformation = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        //保存数据
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[_allInformation stringValueForKey:@"avatar_big"] forKey:@"avatar_big"];
        [userDefaults setObject:[_allInformation stringValueForKey:@"uname"] forKey:@"uname"];
        [userDefaults synchronize];
        
        NSString *urlStr = [_allInformation stringValueForKey:@"avatar_big" defaultValue:@""];
        [_headBtn sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal];
        _userName.text =  [_allInformation stringValueForKey:@"uname" defaultValue:@""];
        
        _isTeacher = [_allInformation stringValueForKey:@"is_teacher"];
        if (isRefreshTeacher) {
            [self addMYView];
            isRefreshTeacher = NO;
        } else {
            isRefreshTeacher = NO;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取用户信息
- (void)netWorkUserGetCount {
    
    NSString *endUrlStr = YunKeTang_User_user_getCount;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (UserID == nil) {
    } else {
        [mutabDict setObject:UserID forKey:@"user_id"];
    }
    
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
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _userCountDict = [dict dictionaryValueForKey:@"data"];
            } else {
                _userCountDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        
        //保存数据
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[_userCountDict stringValueForKey:@"intr"] forKey:@"intr"];
        [userDefaults setObject:[_userCountDict stringValueForKey:@"fans"] forKey:@"fans"];
        [userDefaults setObject:[_userCountDict stringValueForKey:@"follow"] forKey:@"follow"];
        [userDefaults synchronize];
        
        _attentionLabel.text = [NSString stringWithFormat:@"%@ 关注",[_userCountDict stringValueForKey:@"follow"]];
        _fanLabel.text = [NSString stringWithFormat:@"%@ 粉丝",[_userCountDict stringValueForKey:@"fans"]];
        [self messageButtonHandle];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//获取当前用户的会员等级
//获取用户信息
- (void)netWorkUserGetUserVip {
    
    NSString *endUrlStr = YunKeTang_User_user_getUserVip;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"new" forKey:@"time"];
    
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
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                 _vipDict = [dict dictionaryValueForKey:@"data"];
            } else {
                 _vipDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }

        if ([[_vipDict stringValueForKey:@"vip_type"] integerValue] == 0) {
            [_memberButton setTitle:@"开通会员>" forState:UIControlStateNormal];
            _memberImageView.frame = CGRectMake(10 * WideEachUnit, 7 * WideEachUnit, 0, 16 * WideEachUnit);
        } else {
            [_memberButton setTitle:[NSString stringWithFormat:@"%@>",[_vipDict stringValueForKey:@"vip_type_txt"]] forState:UIControlStateNormal];
            NSString *urlStr = [_vipDict stringValueForKey:@"cover"];
            [_memberImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
            _memberImageView.frame = CGRectMake(10 * WideEachUnit, 7 * WideEachUnit, 16 * WideEachUnit, 16 * WideEachUnit);
        }
        BOOL isVip = [[_vipDict stringValueForKey:@"vip_type"] integerValue] == 0 ? NO : YES;
        CGFloat memberButtonWidth = [_memberButton.titleLabel.text sizeWithFont:_memberButton.titleLabel.font].width + 4;
        _memberButton.frame = CGRectMake(_memberImageView.right + (isVip ? 5 : 0), 3 * WideEachUnit, memberButtonWidth, 24 * WideEachUnit);
        _memberView.frame = CGRectMake(MainScreenWidth - (20 + _memberButton.right + 10) * WideEachUnit, iPhoneX ? 85 * WideEachUnit + 30 : 85 * WideEachUnit, (20 + memberButtonWidth + _memberImageView.width + (isVip ? 5 : 0)) * WideEachUnit, 30 * WideEachUnit);
        if ([HASALIPAY isEqualToString:@"0"]) {
            _memberView.hidden = YES;
        } else {
            _memberView.hidden = NO;
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



//获取用户的流水数据
- (void)netWorkUserGetAccount {
    
    NSString *endUrlStr = YunKeTang_User_user_getAccount;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"new" forKey:@"time"];
    
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
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                 _userAccountDict = [dict dictionaryValueForKey:@"data"];
            } else {
                 _userAccountDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }

        NSLog(@"Vip---%@",_vipDict);
        _bancleLabel.text = [NSString stringWithFormat:@"育币%@",[_userAccountDict stringValueForKey:@"learn" defaultValue:@"0"]];
        _gainLabel.text = [NSString stringWithFormat:@"育币%@",[_userAccountDict stringValueForKey:@"split" defaultValue:@"0"]];
        _scoreLabel.text = [NSString stringWithFormat:@"%ld", [[_userAccountDict stringValueForKey:@"score" defaultValue:@"0"] integerValue]];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




#pragma mark --- 消息按钮的处理
- (void)messageButtonHandle {
    NSString *commentStr = [_userCountDict stringValueForKey:@"no_read_comment"];
    NSString *messageStr = [_userCountDict stringValueForKey:@"no_read_message"];
    NSString *notifyStr = [_userCountDict stringValueForKey:@"no_read_notify"];
    NSInteger C = [commentStr integerValue];
    NSInteger M = [messageStr integerValue];
    NSInteger N = [notifyStr integerValue];
    if (C + M + N > 0) {//有消息没有读
        if (_msgButton.subviews.count == 1) {//说明第一次
            UIButton *HButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 3, 8, 8)];
            HButton.backgroundColor = [UIColor redColor];
            HButton.layer.cornerRadius = 4;
            [_msgButton addSubview:HButton];
            _HButton = HButton;
            _HButton.hidden = NO;
        } else {//说明已经纯在
            _HButton.hidden = NO;
        }
    }else {
        _HButton.hidden = YES;
    }
}


#pragma mark --- 滚动视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollHieght1 = 20 * WideEachUnit;
    CGFloat scrollHieght2 = 40 * WideEachUnit;
    CGFloat alphaH = 0.017;
    
    if (iPhone4SOriPhone4) {
        
    } else if (iPhone5o5Co5S) {
        
    } else if (iPhone6) {
        
    } else if (iPhone6Plus) {
        
    } else {//IPHONE X
        scrollHieght1 = 44 * WideEachUnit;
        alphaH = 0.017;
    }
    if (_scrollView.contentOffset.y > - scrollHieght1 && _scrollView.contentOffset.y < scrollHieght2) {
        [UIView animateWithDuration:0.25 animations:^{
            _SYGView.alpha = (0.017) * (_scrollView.contentOffset.y + scrollHieght1);
        }];
    }
    if (_scrollView.contentOffset.y > scrollHieght2) {
        _SYGView.alpha = 1;
    }
    if (_scrollView.contentOffset.y == - scrollHieght1) {
        _SYGView.alpha = 0;
    }
}



@end
