//
//  InstitutionHomeViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstitutionHomeViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "InstitionDiscountViewController.h"
#import "ZhiBoMainViewController.h"
#import "TKProgressHUD+Add.h"



@interface InstitutionHomeViewController ()<UIScrollViewDelegate>

@property (strong ,nonatomic)UIView *allView;

@property (strong ,nonatomic)UIView *todayView;

@property (strong ,nonatomic)UIView *videoClassView;

@property (strong ,nonatomic)UIView *classView;

@property (strong ,nonatomic)UIView *instationView;

@property (strong ,nonatomic)UIView *photoView;

@property (strong ,nonatomic)UIView *introView;
@property (strong ,nonatomic)UIScrollView *classScrollView;
@property (strong ,nonatomic)NSArray *classArray;
@property (strong ,nonatomic)UIView *discountView;

@property (strong ,nonatomic)UIView *moreView;
@property (strong ,nonatomic)UILabel *infoLabel;

@property (strong ,nonatomic)UIView *campusView;

@property (strong ,nonatomic)UIView *evaluateView;

@property (strong ,nonatomic)UIView *IDView;

@property (strong ,nonatomic)NSString *doadminStr;//生成二维码拼接字段

@property (strong, nonatomic) UIScrollView *mainScroll;


@end

@implementation InstitutionHomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight)];
    _mainScroll.delegate = self;
    _mainScroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainScroll];
    [self interFace];
//    [self addAllView];
//    [self addTodayView];
//    [self addVideoClassView];
//    [self addClassView];
//    [self addInstitutionView];
//    [self addPhotoView];
//    [self addIntroView];
//    [self addCampusView];
//    [self addEvaluateView];
//    [self addIDView];

}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    //接受通知（将机构的id传过来）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetInstitonSchoolID:) name:@"NotificationInstitionSchoolID" object:nil];
}

#pragma mark --- 通知
- (void)GetInstitonSchoolID:(NSNotification *)Not {
    _schoolID = (NSString *)Not.userInfo[@"school_id"];
//    [self netWorkInstitutionInfo];
    [self netWorkSchoolGetInfo];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"机构主页";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];

    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 添加各种界面

- (void)addAllView {
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight * 4)];
    _allView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_allView];
}

- (void)addTodayView {
    _todayView = [[UIView alloc] initWithFrame:CGRectMake(0,SpaceBaside , MainScreenWidth, 30)];
    _todayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_todayView];
    
    //添加按钮
    UILabel *todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0, MainScreenWidth - 2 * SpaceBaside, 30)];
    todayLabel.text = @"这是今日头条";
    todayLabel.font = Font(15);
    [_todayView addSubview:todayLabel];
    
}

- (void)addVideoClassView {
    _videoClassView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_todayView.frame) + SpaceBaside, MainScreenWidth, 140)];
    _videoClassView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_videoClassView];
    
    //添加视频课
    UILabel *video = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 20)];
    video.text = @"视频课";
    video.font = Font(13);
    [_videoClassView addSubview:video];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, SpaceBaside, 60, 20)];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    moreButton.titleLabel.font = Font(13);
    [moreButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
    [moreButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
    moreButton.imageEdgeInsets =  UIEdgeInsetsMake(0,40,0,0);
    moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
    [moreButton addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = 600;
    [_videoClassView addSubview:moreButton];
    
    //添加课程
    NSArray *nameArray = @[@"初中几何",@"三角函数"];
    CGFloat buttonW = (MainScreenWidth - 3 * SpaceBaside) / 2;
    CGFloat buttonH = 80;
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + i * (SpaceBaside + buttonW), 30, buttonW, buttonH)];
        button.backgroundColor = [UIColor yellowColor];
        [button setBackgroundImage:Image(@"你好") forState:UIControlStateNormal];
        [_videoClassView addSubview:button];
        
        //添加课程名字
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside + i * (SpaceBaside + buttonW), 110, buttonW, 20)];
        name.text = nameArray[i];
        name.font = Font(13);
        [_videoClassView addSubview:name];
    }
    
    
 
}

- (void)addClassView {
    _classView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_videoClassView.frame) + SpaceBaside, MainScreenWidth, 300)];
    _classView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_classView];
    
    //添加班课
    UILabel *class = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 20)];
    class.text = @"班课";
    class.font = Font(13);
    [_classView addSubview:class];
    
    CGFloat listH = 100;
    
    for (int i = 0 ; i < 2 ; i ++) {
        
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 30 + (listH + 2 * SpaceBaside) * i, MainScreenWidth, 1)];
        lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_classView addSubview:lineButton];
        
        UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside, 40 + i * (listH + 2 * SpaceBaside), MainScreenWidth - SpaceBaside, listH)];
        listView.backgroundColor = [UIColor whiteColor];
        [_classView addSubview:listView];
        
        //在每个View 上面添加东西
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SpaceBaside, 100, 60)];
        imageView.image = Image(@"大家好");
        [listView addSubview:imageView];
        
        //名字 文本
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
        nameLabel.text = @"一年级语文";
        nameLabel.font = Font(14);
        [listView addSubview:nameLabel];
        
        //详情
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 20, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
        detailLabel.text = @"38小时|25人班|2016-09-30开课";
        detailLabel.font = Font(12);
        detailLabel.textColor = [UIColor grayColor];
        [listView addSubview:detailLabel];
        
        //老师
        UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 40, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
        teacherLabel.text = @"老师：石远刚";
        teacherLabel.font = Font(13);
        teacherLabel.textColor = [UIColor grayColor];
        [listView addSubview:teacherLabel];

        //价格
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 60, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
        priceLabel.text = @"2280.00育币";
        priceLabel.font = Font(15);
        priceLabel.textColor = [UIColor orangeColor];
        [listView addSubview:priceLabel];
        
        
        //添加报名 文本
        UILabel *applyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SpaceBaside + CGRectGetHeight(imageView.frame), CGRectGetWidth(imageView.frame) , 20)];
        applyLabel.text = @"已报名12/15人";
        applyLabel.font = Font(12);
        applyLabel.textColor = [UIColor grayColor];
        [listView addSubview:applyLabel];
        
        
    }
    
    //查看更多课程
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 270, 100, 20)];
    [moreButton setTitle:@"查看更多课程" forState:UIControlStateNormal];
    moreButton.titleLabel.font = Font(12);
    [moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
    moreButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80,0,0);
    moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
    [moreButton addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = 600;
    [_classView addSubview:moreButton];

    
    
}

- (void)addInstitutionView {
    
    _instationView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_classView.frame) + SpaceBaside, MainScreenWidth, 670)];
    _instationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_instationView];
    
    //添加班课
    UILabel *class = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 20)];
    class.text = @"机构推荐";
    class.font = Font(13);
    [_instationView addSubview:class];
    
    CGFloat listH = 100;
    
    for (int i = 0 ; i < 5 ; i ++) {
        
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 30 + (listH + 2 * SpaceBaside) * i, MainScreenWidth, 1)];
        lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_instationView addSubview:lineButton];
        
        UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside, 40 + i * (listH + 2 * SpaceBaside), MainScreenWidth - SpaceBaside, listH)];
        listView.backgroundColor = [UIColor whiteColor];
        [_instationView addSubview:listView];
        
        //在每个View 上面添加东西
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SpaceBaside, 80, 80)];
        imageView.image = Image(@"大家好");
        imageView.layer.cornerRadius = 40;
        imageView.layer.masksToBounds = YES;
        [listView addSubview:imageView];
        
        //名字 文本
        UILabel *teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
        teacherLabel.text = @"石远刚";
        teacherLabel.font = Font(14);
        [listView addSubview:teacherLabel];
        
        //名字 文本
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 20, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
        nameLabel.text = @"口语-英语生活口语100句";
        nameLabel.font = Font(12);
        [listView addSubview:nameLabel];
        
        //详情
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 40, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
        detailLabel.text = @"一份耕耘，一份收获";
        detailLabel.font = Font(12);
        detailLabel.textColor = [UIColor grayColor];
        [listView addSubview:detailLabel];
        
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 60, 120, 20)];
        timeLabel.text = @"228育币/小时";
        timeLabel.font = Font(15);
        timeLabel.textColor = [UIColor orangeColor];
        [listView addSubview:timeLabel];
        
        //在线授课
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, SpaceBaside + 60, 110, 20)];
        lineLabel.text = @"可在线授课";
        lineLabel.font = Font(12);
        lineLabel.textAlignment = NSTextAlignmentRight;
        lineLabel.textColor = [UIColor grayColor];
        [listView addSubview:lineLabel];
        
        
        
    }
    
    //查看更多课程
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 6 * listH + 40, 100, 20)];
    [moreButton setTitle:@"查看全部老师" forState:UIControlStateNormal];
    moreButton.titleLabel.font = Font(12);
    [moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
    moreButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80,0,0);
    moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
    [moreButton addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = 600;
    [_instationView addSubview:moreButton];
    
    
}

//- (void)addPhotoView {
//    
//    _photoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_instationView.frame) + SpaceBaside, MainScreenWidth, 160)];
//    _photoView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_photoView];
//    
//    //添加视频课
//    UILabel *video = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 20)];
//    video.text = @"相册";
//    video.font = Font(13);
//    [_photoView addSubview:video];
//    
//    //添加课程
//    CGFloat buttonW = (MainScreenWidth - 3 * SpaceBaside) / 2;
//    CGFloat buttonH = 80;
//    for (int i = 0 ; i < 2 ; i ++) {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + i * (SpaceBaside + buttonW), 30, buttonW, buttonH)];
//        button.backgroundColor = [UIColor yellowColor];
//        [button setBackgroundImage:Image(@"大家好") forState:UIControlStateNormal];
//        [_photoView addSubview:button];
//    }
//    
//    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60, SpaceBaside + 120, 120, 20)];
//    [moreButton setTitle:@"更多视频/照片" forState:UIControlStateNormal];
//    moreButton.titleLabel.font = Font(13);
//    [moreButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
//    [moreButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
//    moreButton.imageEdgeInsets =  UIEdgeInsetsMake(0,100,0,0);
//    moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
//    [moreButton addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
//    moreButton.tag = 600;
//    [_photoView addSubview:moreButton];
//
//}

- (void)addIntroView {
    
    _introView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 85)];
    _introView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_introView];
    
    //添加班课
    UILabel *class = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 30)];
    class.text = @"机构简介";
    class.font = Font(15);
    class.font = [UIFont boldSystemFontOfSize:15];
    [_introView addSubview:class];
    
    CGFloat listH = 30;
    
    NSString *Str0 = [NSString stringWithFormat:@"位置：%@", [[_schoolDic dictionaryValueForKey:@"user_info"] stringValueForKey:@"location"]];
   
    NSLog(@"----%@",_address);
    if (![_address isEqualToString:@""]) {
        Str0 = [NSString stringWithFormat:@"位置：%@",_address];
        if (_address != nil) {
             Str0 = [NSString stringWithFormat:@"位置：%@",_address];
        } else {
             Str0 = [NSString stringWithFormat:@"位置：暂无"];
            if ([_schoolDic stringValueForKey:@"location"].length > 0) {
                Str0 = [NSString stringWithFormat:@"位置：%@",[_schoolDic stringValueForKey:@"location"]];
            } else if ([[_schoolDic stringValueForKey:@"location"] isEqualToString:@""]) {
                 Str0 = [NSString stringWithFormat:@"位置：暂无"];
            } else {
                 Str0 = [NSString stringWithFormat:@"位置：暂无"];
            }
        }
    } else {
        Str0 = [NSString stringWithFormat:@"位置：暂无"];
    }
    
    NSArray *textArray = @[Str0];
    
    for (int i = 0 ; i < textArray.count ; i ++) {
        
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 40 + (listH + 2 * SpaceBaside) * i, MainScreenWidth, 1)];
        lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_introView addSubview:lineButton];
        
        UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside, 50 + i * (listH + 2 * SpaceBaside), MainScreenWidth - SpaceBaside, listH)];
        listView.backgroundColor = [UIColor whiteColor];
        [_introView addSubview:listView];
        
        //添加文本
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  MainScreenWidth - SpaceBaside, listH)];
        titleL.text = textArray[i];
        titleL.font = Font(14);
        titleL.textColor = [UIColor grayColor];
        [listView addSubview:titleL];
        
        
    }
    
}


- (void)addDiscountView  {
    _discountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
    _discountView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:_discountView];
    
    //添加标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0, MainScreenWidth - SpaceBaside * 2, 40)];
    titleLabel.text = @"机构优惠";
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.font = Font(15 * WideEachUnit);
    [_discountView addSubview:titleLabel];
    
    //添加更多课程
    UIButton *moreClassButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100 * WideEachUnit, 0, 90 * WideEachUnit, 40)];
    [moreClassButton setImage:Image(@"右箭头") forState:UIControlStateNormal];
    moreClassButton.backgroundColor = [UIColor clearColor];
    [moreClassButton setTitleColor:BasidColor forState:UIControlStateNormal];
    moreClassButton.titleLabel.font = Font(12);
    [moreClassButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
    [moreClassButton setTitle:@"去领取" forState:UIControlStateNormal];
    [_discountView addSubview:moreClassButton];
    moreClassButton.imageEdgeInsets =  UIEdgeInsetsMake(0,70,0,0);
    moreClassButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [moreClassButton addTarget:self action:@selector(discountMoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    if ([HASEduline isEqualToString:@"0"]) {
        [_discountView setHeight:0];
        _discountView.hidden = YES;
    }
}




- (void)addMoreDetailView {
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_discountView.frame), MainScreenWidth, 100)];
    _moreView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:_moreView];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - SpaceBaside, 20)];
    moreLabel.text = @"更多详情";
    moreLabel.font = [UIFont boldSystemFontOfSize:15];
    [_moreView addSubview:moreLabel];
    
    
    //添加介绍
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside,30, MainScreenWidth - 2 * SpaceBaside, 20)];

    if ([_schoolDic[@"info"] isEqual:[NSNull null]]) {
        [self setIntroductionText:@""];
    } else {
        NSString *infoStr = [self filterHTML:_schoolDic[@"info"]];
        [self setIntroductionText:infoStr];
    }
    _infoLabel.font = Font(13);
    _infoLabel.textColor = [UIColor grayColor];
    [_moreView addSubview:_infoLabel];
    
    
    CGFloat allH = CGRectGetMaxY(_moreView.frame) - SpaceBaside;
    NSLog(@"allH----%lf",allH);
    
    NSLog(@"%lf",MainScreenHeight);
    NSString *hightStr = [NSString stringWithFormat:@"%lf",allH];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IntHomeScrollHight" object:hightStr];
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, allH > _tabelHeight ? allH : _tabelHeight + 10);
}

- (void)addCampusView {
    
    _campusView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_moreView.frame) + SpaceBaside, MainScreenWidth, 40)];
    _campusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_campusView];
    
    //添加班课
    UILabel *class = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 20)];
    class.text = @"校区";
    class.font = Font(13);
    [_campusView addSubview:class];
    
}

- (void)addEvaluateView {
    
    _evaluateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_campusView.frame) + SpaceBaside, MainScreenWidth, 190)];
    _evaluateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_evaluateView];
    
    //添加班课
    UILabel *class = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 20)];
    class.text = @"课程评价";
    class.font = Font(13);
    [_evaluateView addSubview:class];
    
    CGFloat listH = 100;
    
    for (int i = 0 ; i < 2 ; i ++) {
        
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 30 + (listH + 2 * SpaceBaside) * i, MainScreenWidth, 1)];
        lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_evaluateView addSubview:lineButton];
        
        if (i == 1) {
            continue;
        }
        UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside, 40 + i * (listH + 2 * SpaceBaside), MainScreenWidth - SpaceBaside, listH)];
        listView.backgroundColor = [UIColor whiteColor];
        [_evaluateView addSubview:listView];
        
        //添加东西在View 上面
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SpaceBaside, 40, 40)];
        imageView.image = Image(@"大家好");
        imageView.layer.cornerRadius = 20;
        imageView.layer.masksToBounds = YES;
        [listView addSubview:imageView];
        
        //名字 文本
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
        nameLabel.text = @"龙培";
        nameLabel.font = Font(14);
        [listView addSubview:nameLabel];
        
        //好评星级
        UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 20, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
        starLabel.text = @"好评";
        starLabel.font = Font(12);
        starLabel.textColor = [UIColor grayColor];
        [listView addSubview:starLabel];
        
        //评价 内容
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + SpaceBaside, SpaceBaside + 40, MainScreenWidth - SpaceBaside - CGRectGetMaxX(imageView.frame) - SpaceBaside , 20)];
        contentLabel.text = @"很有用的课，石远刚老师好帅哦、、、哈哈哈";
        contentLabel.font = Font(13);
        contentLabel.textColor = [UIColor grayColor];
        [listView addSubview:contentLabel];
    }
    
    //查看更多课程
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 160, 100, 20)];
    [moreButton setTitle:@"全部评价" forState:UIControlStateNormal];
    moreButton.titleLabel.font = Font(12);
    [moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
    moreButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80,0,0);
    moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
    [moreButton addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = 600;
    [_evaluateView addSubview:moreButton];

    
}

- (void)addIDView {
    
    _IDView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_moreView.frame) + SpaceBaside, MainScreenWidth, 61)];
    _IDView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_IDView];
    
    //添加班课
    NSArray *textArray = @[@"机构ID",@"机构二维码名片"];
    CGFloat textH = 30;
    
    for (int i = 0 ; i < 2 ; i ++) {
        UILabel *class = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0 + (textH + 1) * i , 200, textH)];
        class.text = textArray[i];
        class.font = Font(13);
        [_IDView addSubview:class];
        
        //添加ID 文本
        if (i == 0) {
            
            UILabel *IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - SpaceBaside - 100, (textH + 1) * i, 100, textH)];
            IDLabel.text = [NSString stringWithFormat:@"%@",[_schoolDic stringValueForKey:@"school_id"]];
            IDLabel.textAlignment = NSTextAlignmentRight;
            IDLabel.textColor = [UIColor grayColor];
            IDLabel.font = Font(14);
            [_IDView addSubview:IDLabel];

        } else if (i == 1) {
            UIButton *IDButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - SpaceBaside - 20, (textH + 1) * i + 5, textH - 10, textH - 10)];
            [IDButton setImage:Image(@"二维码") forState:UIControlStateNormal];
            [_IDView addSubview:IDButton];

        }
        
    }
    
    //添加点击二维码的按钮
    UIButton *codeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, textH, MainScreenWidth, textH)];
    codeButton.backgroundColor = [UIColor clearColor];
    [codeButton addTarget:self action:@selector(codeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_IDView addSubview:codeButton];
    
    
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, textH + 1 , MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_IDView addSubview:lineButton];
    
    CGFloat allH = CGRectGetMaxY(_IDView.frame);
    NSLog(@"allH----%lf",allH);
    
    NSLog(@"%lf",MainScreenHeight);
    NSString *hightStr = [NSString stringWithFormat:@"%lf",allH];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IntHomeScrollHight" object:hightStr];
    
}

#pragma mark --- 文本自适应

//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    return html;
}



-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _infoLabel.text = text;
    //设置label的最大行数
    _infoLabel.numberOfLines = 0;
    
    CGRect labelSize = [_infoLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    _infoLabel.frame = CGRectMake(SpaceBaside,30,MainScreenWidth - 2 * SpaceBaside,labelSize.size.height);
    _moreView.frame = CGRectMake(0, CGRectGetMaxY(_discountView.frame) + SpaceBaside, MainScreenWidth, 40 + labelSize.size.height);

}



#pragma mark --- 更多视图

- (void)addMoreView {
//    _allBigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight * 3)];
//    _allBigView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
//    [self.view addSubview:_allBigView];
    
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0,MainScreenWidth,MainScreenHeight)];
    _window.windowLevel = UIWindowLevelAlert;
    _window.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [_window makeKeyAndVisible];//关键语句,显示window
    [_window.superview addSubview:_window];

    
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight * 3)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_window addSubview:_allButton];
    

    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(MainScreenWidth / 2 - 100, _window.center.y, 200, 300);
    _buyView.backgroundColor = [UIColor whiteColor];
    _buyView.layer.cornerRadius = 3;
    _buyView.center = _window.center;
    [_window addSubview:_buyView];
    
    //添加机构的名字
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, SpaceBaside, 200, 20)];
    name.text = [_schoolDic stringValueForKey:@"title"];
    name.textAlignment = NSTextAlignmentCenter;
    name.font = Font(20);
    [_buyView addSubview:name];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, 30, 200 - 2 * SpaceBaside, 200)];
    imageView.image = Image(@"二维码");
    [_buyView addSubview:imageView];
    _imgaeView = imageView;
    
    //提示
    UILabel *remain = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside,230, 200 - 2 * SpaceBaside, 40)];
    remain.text = @"可通过扫码二维码进入机构详情页";
    remain.textAlignment = NSTextAlignmentCenter;
    remain.numberOfLines = 2;
    remain.font = Font(14);
    [_buyView addSubview:remain];
   
    //生成二维码
    [self GetCodeImage];
}

- (void)miss {
    _window.hidden = YES;
    [self.view.window resignKeyWindow];
    _window = nil;
    
    [_allBigView removeFromSuperview];
    [_allButton removeFromSuperview];
    [_buyView removeFromSuperview];

}


#pragma mark --- 事件点击

- (void)moreButtonCilck:(UIButton *)button {
    
}

- (void)discountMoreButtonClick {
    InstitionDiscountViewController *discountVc = [[InstitionDiscountViewController alloc] init];
    discountVc.schoolID = _schoolID;
    [self.navigationController pushViewController:discountVc animated:YES];
}
- (void)codeButtonClick {
    
    [self addMoreView];
}

//生成二维码
- (void)GetCodeImage {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据
    
//    NSString *basidStr = @"http://dafengche.51eduline.com/index.php?app=school&mod=School&act=index";
    NSString *modStr = @"app=school&mod=School&act=index";
    NSString *basidStr = [NSString stringWithFormat:@"%@%@",basidUrl,modStr];
    NSString *infoStr = [NSString stringWithFormat:@"id=%@&doadmin=%@",_schoolID,_doadminStr];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@&%@",basidStr,infoStr];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    _imgaeView.image = [UIImage imageWithCIImage:outputImage scale:20.0 orientation:UIImageOrientationUp];
}

#pragma mark --- 网络请求
//获取机构详情
- (void)netWorkSchoolGetInfo {
    
    NSString *endUrlStr = YunKeTang_School_school_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_schoolID forKey:@"school_id"];
    
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
        _schoolDic = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        _doadminStr = [_schoolDic stringValueForKey:@"doadmin"];
        _classArray = [_schoolDic arrayValueForKey:@"recommend_list"];
        [self addDiscountView];
        [self addMoreDetailView];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScroll) {
        if (!self.cellTabelCanScroll) {
            scrollView.contentOffset = CGPointZero;
        }
        if (scrollView.contentOffset.y <= 0) {
            self.cellTabelCanScroll = NO;
            scrollView.contentOffset = CGPointZero;
            self.vc.canScroll = YES;
        }
    }
}


@end
