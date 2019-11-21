//
//  OfflineDetailViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "OfflineDetailViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"

#import "BigWindCar.h"
#import "OffllineDetailOneCell.h"
#import "OfflineDetailTwoCell.h"
#import "DLViewController.h"
#import "MessageSendViewController.h"
#import "ClassAndLivePayViewController.h"



@interface OfflineDetailViewController ()<UIWebViewDelegate,UMSocialUIDelegate,UIScrollViewDelegate> {
    NSString  *shareUrl;
    UIImageView *shareImageView;
}

@property (strong ,nonatomic)UIView       *headerView;
@property (strong ,nonatomic)UIScrollView *allScrollView;
@property (strong ,nonatomic)UIView       *oneView;
@property (strong ,nonatomic)UIView       *twoView;
@property (strong ,nonatomic)UIScrollView *twoScrollView;
@property (strong ,nonatomic)UITableView  *tableView;
@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UIView       *downView;

@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSDictionary   *dict;
@property (strong ,nonatomic)NSArray        *commentArray;
@property (assign ,nonatomic)CGFloat        cellHight;


@property (strong ,nonatomic)UILabel      *titleName;
@property (strong ,nonatomic)UILabel      *teacher;
@property (strong ,nonatomic)UILabel      *person;
@property (strong ,nonatomic)UILabel      *price;
@property (strong ,nonatomic)UILabel      *time;
@property (strong ,nonatomic)UILabel      *discounts;
@property (strong ,nonatomic)UILabel      *adress;

@property (strong ,nonatomic)UIView          *allWindowView;
@property (strong ,nonatomic)UITextView      *textView;
@property (strong ,nonatomic)UIButton        *starButton_One;
@property (strong ,nonatomic)UIButton        *starButton_Two;
@property (strong ,nonatomic)UIButton        *starButton_There;
@property (strong ,nonatomic)UIButton        *starButton_Four;
@property (strong ,nonatomic)UIButton        *starButton_Five;

@property (strong ,nonatomic)UIButton     *collectButton;
@property (strong ,nonatomic)NSString     *collectStr;
@property (strong ,nonatomic)UIButton     *detailButton;//课程详情
@property (strong ,nonatomic)UIButton     *commentButton;//预约评价
@property (strong ,nonatomic)UILabel      *detail;
@property (strong ,nonatomic)UIScrollView *detailAndCommentScrollView;
@property (strong ,nonatomic)UIView       *commentView;
@property (strong ,nonatomic)NSString     *starStr;

@property (assign ,nonatomic)CGFloat      detailHight;
@property (assign ,nonatomic)CGFloat      commentHight;
@property (assign ,nonatomic)NSInteger    typeNum;

@property (strong ,nonatomic)NSString     *alipayStr;
@property (strong ,nonatomic)NSString     *wxpayStr;
@property (strong ,nonatomic)UIWebView    *webView;
@property (strong ,nonatomic)UIButton     *buyButton;
@property (strong ,nonatomic)NSString     *schoolID;//分享链接的时候要用到
@property (strong ,nonatomic)NSString     *line_switch;



@end

@implementation OfflineDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self netWorkLineVideoGetInfo];
    
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
    [self nsnotification];
    [self addNav];
    [self addAllScrollView];
    [self addHeaderView];
    [self addOneView];
    [self addTwoView];
    [self addDownView];
    [self netWorkLineVideoGetInfo];
    [self netWorkLineVideoGetRender];
//    [self netWorkCourseReviewConf];

}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _cellHight = 0;
    _commentHight = 600 * WideEachUnit;
}


- (void)nsnotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHight:) name:@"NSNotificationOfflineDetailCellHight" object:nil];
//    NSNotificationOfflineDetailCellHight
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
//    _titleView = SYGView;
//    SYGView.alpha = 0;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20+MACRO_UI_STATUSBAR_ADD_HEIGHT, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25+MACRO_UI_STATUSBAR_ADD_HEIGHT, MainScreenWidth - 140, 30)];
    WZLabel.text = _titleStr;
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    
    //添加收藏
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 20+MACRO_UI_STATUSBAR_ADD_HEIGHT, 40, 40)];
    [collectButton setImage:[UIImage imageNamed:@"ic_collect@3x"] forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:collectButton];
    _collectButton = collectButton;
    
    //添加分享
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20+MACRO_UI_STATUSBAR_ADD_HEIGHT, 40, 40)];
    [shareButton setImage:[UIImage imageNamed:@"ic_share@3x"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(netWorkLineVideoGetShareUrl) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:shareButton];
    
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT - 1, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
}

- (void)addShareImageView {
    shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    NSString *urlStr = [_dict stringValueForKey:@"imageurl"];
    [shareImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
}

- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 212 * WideEachUnit)];
    _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_allScrollView addSubview:_headerView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(_headerView.frame))];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
    [_headerView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
}

- (void)addAllScrollView {
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight -  MACRO_UI_UPHEIGHT - 49 * WideEachUnit)];
    _allScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_allScrollView];
}


- (void)addOneView {
    _oneView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 212 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit)];
    _oneView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:_oneView];
    
    
    _titleName = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    _titleName.textColor = [UIColor blackColor];
    _titleName.backgroundColor = [UIColor whiteColor];
    [_oneView addSubview:_titleName];
    
    
    _teacher = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 47 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _teacher.textColor = [UIColor blackColor];
    _teacher.font = Font(12 * WideEachUnit);
    _teacher.textColor = [UIColor colorWithHexString:@"#656565"];
    _teacher.backgroundColor = [UIColor whiteColor];
    [_oneView addSubview:_teacher];
    
    
    _person = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 72 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _person.textColor = [UIColor blackColor];
    _person.font = Font(12 * WideEachUnit);
    _person.textColor = [UIColor colorWithHexString:@"#656565"];
    _person.backgroundColor = [UIColor whiteColor];
    [_oneView addSubview:_person];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 99 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _time.font = Font(12 * WideEachUnit);
    _time.backgroundColor = [UIColor whiteColor];
    _time.textColor = [UIColor colorWithHexString:@"#656565"];
    [_oneView addSubview:_time];
    
    _adress = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 126 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _adress.font = Font(12 * WideEachUnit);
    _adress.backgroundColor = [UIColor whiteColor];
    _adress.textColor = [UIColor colorWithHexString:@"#656565"];
    [_oneView addSubview:_adress];
//    _adress.hidden = YES;
    
    
    _discounts = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 151 * WideEachUnit, 60 * WideEachUnit, 20 * WideEachUnit)];
    _discounts.font = Font(14 * WideEachUnit);
    _discounts.backgroundColor = [UIColor whiteColor];
    _discounts.text = @"优惠价：";
    _discounts.textColor = [UIColor colorWithHexString:@"#fe575f"];
    [_oneView addSubview:_discounts];
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_discounts.frame), 151 * WideEachUnit, MainScreenWidth - CGRectGetMaxX(_discounts.frame) - 20 * WideEachUnit, 20 * WideEachUnit)];
    _price.font = Font(20 * WideEachUnit);
    _price.backgroundColor = [UIColor whiteColor];
    _price.textColor = [UIColor colorWithHexString:@"#fe575f"];
    [_oneView addSubview:_price];
}


- (void)oneViewGet {
    _titleName.text = [_dict stringValueForKey:@"course_name"];
    if (_dict == nil) {//空处理
        _titleName.text = @"";
    }
    _teacher.text = [NSString stringWithFormat:@"主讲人：%@",[_dict stringValueForKey:@"teacher_name"]];
    _person.text = [NSString stringWithFormat:@"已报名：%@",[_dict stringValueForKey:@"course_order_count"]];
    if ([_orderSwitch integerValue] == 1) {
        _person.text = [NSString stringWithFormat:@"已报名：%@",[_dict stringValueForKey:@"course_order_count_mark"]];
    }
    NSString *beginStr = [Passport formatterDate:[_dict stringValueForKey:@"listingtime"]];
    NSString *endStr = [Passport formatterDate:[_dict stringValueForKey:@"uctime"]];
    _time.text = [NSString stringWithFormat:@"开课时间：%@ ~ %@",beginStr,endStr];
    
    _adress.text = [NSString stringWithFormat:@"上课地点：%@", [_dict stringValueForKey:@"address" defaultValue:@"暂无地址"]];
    NSLog(@"----%@",_adress.text);
    if ([[_dict stringValueForKey:@"address"] isEqualToString:@""]) {
        _adress.text = @"上课地点：暂无地址";
    }
//    _adress.hidden = YES;
    
    _price.text = [NSString stringWithFormat:@"育币 %@",[_dict stringValueForKey:@"price"]];
    if ([[_dict stringValueForKey:@"price"] floatValue] == 0) {
        _price.text = @"免费";
    }
}

- (void)addTwoView {
    
    
    _twoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_oneView.frame) + 10 * WideEachUnit, MainScreenWidth, 190 * WideEachUnit + MainScreenHeight)];
    _twoView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:_twoView];
    
    _detailButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, 80 * WideEachUnit, 20 * WideEachUnit)];
    [_detailButton setTitle:@"课程详情" forState:UIControlStateNormal];
    _detailButton.titleLabel.font = Font(16 * WideEachUnit);
    [_detailButton setTitleColor:BasidColor forState:UIControlStateSelected];
    [_detailButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
    [_detailButton addTarget:self action:@selector(detailButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_twoView addSubview:_detailButton];
    _detailButton.selected = YES;
    
    _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(100 * WideEachUnit, 10 * WideEachUnit, 80 * WideEachUnit, 20 * WideEachUnit)];
    [_commentButton setTitle:@"课程评价" forState:UIControlStateNormal];
    _commentButton.titleLabel.font = Font(16 * WideEachUnit);
    [_commentButton setTitleColor:BasidColor forState:UIControlStateSelected];
    [_commentButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(commentButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_twoView addSubview:_commentButton];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 39 * WideEachUnit, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_twoView addSubview:lineButton];
    
    
    _detailAndCommentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, 500 * WideEachUnit + MainScreenHeight)];
    _detailAndCommentScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _detailAndCommentScrollView.pagingEnabled = YES;
    _detailAndCommentScrollView.scrollEnabled = YES;
    _detailAndCommentScrollView.delegate = self;
    _detailAndCommentScrollView.bounces = NO;
    _detailAndCommentScrollView.contentSize = CGSizeMake(MainScreenWidth * 2, 0);
    _detailAndCommentScrollView.showsVerticalScrollIndicator = NO;
    _detailAndCommentScrollView.showsHorizontalScrollIndicator = NO;
    //    _scrollView.contentSize = CGSizeMake(MainScreenWidth * 2,10);
    [_twoView addSubview:_detailAndCommentScrollView];
    
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, 100 * WideEachUnit)];
    _commentView.backgroundColor = [UIColor whiteColor];
    [_detailAndCommentScrollView addSubview:_commentView];
    
    
    //添加一个夹层
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    detailView.backgroundColor = [UIColor whiteColor];
    [_detailAndCommentScrollView addSubview:detailView];
    
    _detail = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _detail.textColor = [UIColor blackColor];
    _detail.backgroundColor = [UIColor whiteColor];
    _detail.font = Font(13);
    [detailView addSubview:_detail];
    
}

- (void)twoViewGet {
    NSLog(@"---%@",_dict);
    _detail.text = [_dict stringValueForKey:@"course_intro"];
    NSString *textStr = [Passport filterHTML:[_dict stringValueForKey:@"course_intro"]];
    [self setIntroductionText:textStr];
}


-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _detail.text = text;
    //设置label的最大行数
    _detail.numberOfLines = 0;
    
    CGRect labelSize = [_detail.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    NSLog(@"----%lf",labelSize.size.height);
    
    _detail.frame = CGRectMake(10 * WideEachUnit, 50 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, labelSize.size.height );
    
    NSLog(@"----%lf",_detail.frame.size.height);
    
    if (labelSize.size.height < 60 * WideEachUnit) {
        labelSize.size.height = 60 * WideEachUnit;
    }
    
    _detailHight = labelSize.size.height;
    
    _detailAndCommentScrollView.frame = CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, labelSize.size.height + 20 * WideEachUnit);
    _detail.frame = CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, labelSize.size.height );
    
    _twoView.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame) + 10 * WideEachUnit, MainScreenWidth, labelSize.size.height + 60 * WideEachUnit);
    _allScrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_twoView.frame) + 10 * WideEachUnit);
}


- (void)addCommentView:(NSArray *)array {
    
    NSLog(@"个数---%ld",array.count);
    
    _commentView.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, array.count * 100 * WideEachUnit + 50 * WideEachUnit);
    if (array.count == 0) {
        _commentView.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, array.count * 100 * WideEachUnit + 50 * WideEachUnit);
    }
    _detailAndCommentScrollView.frame = CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, array.count * 100 * WideEachUnit);
    
    _commentHight = 90 * WideEachUnit * array.count + 44 * WideEachUnit;
    if (array.count == 0) {
        _commentView.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, 50 * WideEachUnit);
        _commentHight = 50 * WideEachUnit;
        _commentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *marginLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit,15 * WideEachUnit, 60 * WideEachUnit , 20 * WideEachUnit)];
        marginLabel.font = Font(14 * WideEachUnit);
        marginLabel.textColor = [UIColor grayColor];
        marginLabel.textAlignment = NSTextAlignmentCenter;
        [_commentView addSubview:marginLabel];
        marginLabel.text = @"暂无数据";
        marginLabel.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50 * WideEachUnit, 200 * WideEachUnit, 200 * WideEachUnit)];
        imageView.image = Image(@"云课堂_空数据 （小）");
    }
    
    UIButton *secitionButton = [[UIButton alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 5 * WideEachUnit, MainScreenWidth - 40 * WideEachUnit, 34 * WideEachUnit)];
    secitionButton.layer.cornerRadius = 17 * WideEachUnit;
    secitionButton.layer.borderWidth = 1;
    secitionButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    secitionButton.backgroundColor = [UIColor whiteColor];
    [secitionButton setTitle:@"我也来评一下" forState:UIControlStateNormal];
    [secitionButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
    secitionButton.titleLabel.font = Font(14 * WideEachUnit);
    [secitionButton addTarget:self action:@selector(secitionButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_commentView addSubview:secitionButton];
    
    
    for (int i = 0; i < array.count ; i ++) {
        
        UIView *indexView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 * WideEachUnit + 90 * WideEachUnit * i, MainScreenWidth, 90 * WideEachUnit)];
        indexView.backgroundColor = [UIColor whiteColor];
        [_commentView addSubview:indexView];
        
        //名字 文本
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 15 * WideEachUnit, 30 * WideEachUnit , 30 * WideEachUnit)];
        imageButton.backgroundColor = [UIColor redColor];
        imageButton.layer.cornerRadius = 15 * WideEachUnit;
        imageButton.layer.masksToBounds = YES;
        [indexView addSubview:imageButton];
        [imageButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_commentArray[i][@"userface"]]]forState:(UIControlStateNormal) placeholderImage:(Image(@"站位图"))];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit,20 * WideEachUnit, MainScreenWidth - 60 * WideEachUnit , 15 * WideEachUnit)];
        name.font = Font(15 * WideEachUnit);
        name.textColor = [UIColor grayColor];
        [indexView addSubview:name];
        name.text = _commentArray[i][@"username"];
        
        NSString *Str0 = [NSString stringWithFormat:@"%@分",_commentArray[i][@"star"]];
        NSString *Str1 = [NSString stringWithFormat:@"%@分",_commentArray[i][@"attitude"]];
        if ([_commentArray[i][@"attitude"] isEqual:[NSNull null]]) {
            Str1 = @"";
        }
        NSString *Str2 = [NSString stringWithFormat:@"%@分",_commentArray[i][@"professional"]];
        if ([_commentArray[i][@"professional"] isEqual:[NSNull null]]) {
            Str2 = @"";
        }
        NSString *Str3 = [NSString stringWithFormat:@"%@分",_commentArray[i][@"skill"]];
        if ([_commentArray[i][@"skill"] isEqual:[NSNull null]]) {
            Str3 = @"";
        }
        
        
        //分数
        UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 40 * WideEachUnit, 80 * WideEachUnit , 20 * WideEachUnit)];
        //    _score.text = @"综合：5分 专业水平：5分 授课技巧：5分 教学态度：5分";
        scoreView.backgroundColor = [UIColor whiteColor];
        [indexView addSubview:scoreView];
        
        //添加灰色的星星
        CGFloat buttonH = 15 * WideEachUnit;
        CGFloat buttonW = 15 * WideEachUnit;
        for (int i = 0 ; i < 5 ; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonW * i, 0, buttonW, buttonH)];
            [button setImage:Image(@"star1@3x") forState:UIControlStateNormal];
            [scoreView addSubview:button];
        }
        
        for (int i = 0 ; i < [Str0 integerValue] ; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonW * i, 0, buttonW, buttonH)];
            [button setImage:Image(@"star2@3x") forState:UIControlStateNormal];
            [scoreView addSubview:button];
        }
        
        
        //详情
        UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageButton.frame) + SpaceBaside, 60 * WideEachUnit, MainScreenWidth - 70 * WideEachUnit , 15 * WideEachUnit)];
        comment.font = Font(14);
        comment.textColor = [UIColor grayColor];
        comment.numberOfLines = 2;
        [indexView addSubview:comment];
        comment.text = _commentArray[i][@"review_description"];
        
        
        //时间
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth -  90 * WideEachUnit, 35 * WideEachUnit, 80 * WideEachUnit , 15 * WideEachUnit)];
        time.font = Font(12 * WideEachUnit);
        time.textColor = [UIColor colorWithHexString:@"#ccc"];
        [indexView addSubview:time];
        time.textAlignment = NSTextAlignmentRight;
        time.text = [Passport formatterDate:[[_commentArray objectAtIndex:i] stringValueForKey:@"ctime"]];
        time.backgroundColor = [UIColor whiteColor];

        //添加线
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * WideEachUnit + 90 * WideEachUnit * i, MainScreenWidth, 1 * WideEachUnit)];
        lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_commentView addSubview:lineButton];
    }
    
}

- (void)addCommentView {
    //添加
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 25 * WideEachUnit, MainScreenWidth, 16 * WideEachUnit)];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    title.font = Font(16 * WideEachUnit);
    title.text = @"点评该课程";
    title.textAlignment = NSTextAlignmentCenter;
    [_commentView addSubview:title];
    _commentView.userInteractionEnabled = YES;
    
    int count = 5;
    if ([_line_switch integerValue] == 1) {//关
        title.hidden = YES;
        count = 0;
    }

    for (int i = 0 ; i < count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(110 * WideEachUnit + 22 * i + 10 * i, 53 * WideEachUnit, 22, 22)];
        [button setBackgroundImage:[UIImage imageNamed:@"star1@3x"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"star2@3x"] forState:UIControlStateSelected];
        //        button.tag = i + 1;
        [button addTarget:self action:@selector(addAllWindow) forControlEvents:UIControlEventTouchUpInside];
        [_commentView addSubview:button];
    }
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 100 * WideEachUnit, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_commentView addSubview:lineButton];
    
    CGFloat cellH = 120 * WideEachUnit;
    CGFloat cellW = MainScreenWidth;
    
    CGFloat cellY = 100 * WideEachUnit;
    if ([_line_switch integerValue] == 1) {//关
        cellY = 10 * WideEachUnit;
    }
    for (int i = 0 ; i < _commentArray.count ; i ++) {
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, cellY * (i + 1) + 30 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit)];
        if ([_line_switch integerValue] == 1) {//关
            headerImageView.frame = CGRectMake(15 * WideEachUnit, 100 * WideEachUnit  * (i) + 10 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit);
        }
        headerImageView.layer.cornerRadius = 15 * WideEachUnit;
        headerImageView.layer.masksToBounds = YES;
        headerImageView.backgroundColor = [UIColor redColor];
        NSString *urlStr = [[_commentArray objectAtIndex:i] stringValueForKey:@"userface"];
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        [_commentView addSubview:headerImageView];
        
        //标题
       UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 100 * WideEachUnit * (1 + i) + 10 * WideEachUnit ,MainScreenWidth - 80 * WideEachUnit, 15 * WideEachUnit)];
        if ([_line_switch integerValue] == 1) {//关
            title.frame = CGRectMake(50 * WideEachUnit, 100 * WideEachUnit * i + 10 * WideEachUnit ,MainScreenWidth - 80 * WideEachUnit, 15 * WideEachUnit);
        }
        title.font = Font(14 * WideEachUnit);
        title.textColor = [UIColor colorWithHexString:@"#666"];
        title.text = @"人与自然";
        title.text = [[_commentArray objectAtIndex:i] stringValueForKey:@"username"];
        [_commentView addSubview:title];
        
        //时间
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 100 * WideEachUnit *  (1 + i) + 35 * WideEachUnit , MainScreenWidth - 120 * WideEachUnit, 10 * WideEachUnit)];
        if ([_line_switch integerValue] == 1) {//关
            time.frame = CGRectMake(50 * WideEachUnit, 100 * WideEachUnit *  i + 35 * WideEachUnit , MainScreenWidth - 120 * WideEachUnit, 10 * WideEachUnit);
        }
        [_commentView addSubview:time];
        time.numberOfLines = 1;
        time.text = @"50分钟";
        time.textColor = [UIColor grayColor];
        NSString *timeStr = [[_commentArray objectAtIndex:i] stringValueForKey:@"ctime"];
        time.text = [Passport formatterDate:timeStr];
        time.font = Font(10 * WideEachUnit);
        
        //具体内容
       UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 100 * WideEachUnit  * (1 + i) + 55 * WideEachUnit, MainScreenWidth - 120 * WideEachUnit, 14 * WideEachUnit)];
        [_commentView addSubview:content];
        if ([_line_switch integerValue] == 1) {//关
            content.frame = CGRectMake(50 * WideEachUnit, 100 * WideEachUnit  * i + 55 * WideEachUnit, MainScreenWidth - 120 * WideEachUnit, 14 * WideEachUnit);
        }
        content.numberOfLines = 1;
        content.text = @"老师讲的好";
        content.text = [[_commentArray objectAtIndex:i] stringValueForKey:@"review_description"];
        content.textColor = [UIColor colorWithHexString:@"#333"];
        content.font = Font(14 * WideEachUnit);
        
        //试看
       UIButton *starButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, 115 * WideEachUnit  * (1 + i), 80 * WideEachUnit, 14 * WideEachUnit)];
        if ([_line_switch integerValue] == 1) {//关
            starButton.frame = CGRectMake(MainScreenWidth - 90 * WideEachUnit, 110 * WideEachUnit  * i + 10 * WideEachUnit, 80 * WideEachUnit, 14 * WideEachUnit);
        }
        starButton.backgroundColor = [UIColor whiteColor];
        [starButton setBackgroundImage:Image(@"104@2x") forState:UIControlStateNormal];
        [starButton setTitleColor:[UIColor colorWithHexString:@"#25b882"] forState:UIControlStateNormal];
        starButton.titleLabel.font = Font(12 * WideEachUnit);
        NSString *starStr = [NSString stringWithFormat:@"10%@@2x",[[_commentArray objectAtIndex:i] stringValueForKey:@"star"]];
        [starButton setBackgroundImage:Image(starStr) forState:UIControlStateNormal];
        [_commentView addSubview:starButton];
    }
    
    if (_commentArray.count == 0) {//空数据处理
        
        _twoView.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame), MainScreenWidth, 590 * WideEachUnit);
        _commentView.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, 100 * WideEachUnit + 300 * WideEachUnit);
        _detailAndCommentScrollView.frame = CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, 140 * WideEachUnit + 300 * WideEachUnit);
        _commentHight = 300 * WideEachUnit + 100 * WideEachUnit + 220 * WideEachUnit;
        _allScrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 500);
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 600, MainScreenWidth, 300 * WideEachUnit)];
        if (iPhone6) {
            _imageView.frame = CGRectMake(0, 550, MainScreenWidth,MainScreenHeight / 2);
        }
        _imageView.image = Image(@"云课堂_空数据 （小）");
        [_allScrollView addSubview:_imageView];
        _imageView.backgroundColor = [UIColor whiteColor];
        [_allScrollView bringSubviewToFront:_imageView];
        _imageView.hidden = YES;
        if ([_line_switch integerValue] == 1) {//关闭评论
            _imageView.frame = CGRectMake(0, 300, MainScreenWidth,MainScreenHeight / 2);
            _commentView.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth,300 * WideEachUnit);
            _detailAndCommentScrollView.frame = CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, 40 * WideEachUnit + 300 * WideEachUnit);
            _commentHight = 300 * WideEachUnit + 220 * WideEachUnit;
            _allScrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 500);
        }
        return;
    }
    
    _commentView.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, 100 * WideEachUnit + _commentArray.count * 85);
    _commentView.backgroundColor = [UIColor whiteColor];
    _detailAndCommentScrollView.frame = CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, 140 * WideEachUnit + _commentArray.count * 85 + 300 * WideEachUnit);
    _detailAndCommentScrollView.backgroundColor = [UIColor whiteColor];
    _commentHight = _commentArray.count * 85 * WideEachUnit + 100 * WideEachUnit + 220 * WideEachUnit;
    
    if ([_line_switch integerValue] == 1) {
        _commentView.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth,_commentArray.count * 85);
        _commentView.backgroundColor = [UIColor whiteColor];
        _detailAndCommentScrollView.frame = CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, 40 * WideEachUnit + _commentArray.count * 85 + 300 * WideEachUnit);
        _detailAndCommentScrollView.backgroundColor = [UIColor whiteColor];
        _commentHight = _commentArray.count * 85 * WideEachUnit + 220 * WideEachUnit;
    }
}


- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 49 * WideEachUnit, MainScreenWidth, 49 * WideEachUnit)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    CGFloat buttonW = MainScreenWidth / 2;
    CGFloat buttonH = 49 * WideEachUnit;
    NSArray *titleArray = @[@"在线咨询",@"预约课程"];
    if ([[_dict stringValueForKey:@"is_buy"] integerValue] == 1) {//已经解锁
        titleArray = @[@"在线咨询",@"已解锁"];
    }
    
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonW * i, 0, buttonW, buttonH)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [_downView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.backgroundColor = [UIColor colorWithHexString:@"#535353"];
        } else {
            button.backgroundColor = BasidColor;
            _buyButton = button;
        }
        
    }
}

#pragma mark --- 添加window 视图
- (void)addAllWindow {
    if (!UserOathToken) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if ([[_dict stringValueForKey:@"is_buy"] integerValue] == 0) {
        [TKProgressHUD showError:@"解锁之后才能评论" toView:self.view];
        return;
    }
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds = YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WideEachUnit,44 * WideEachUnit,200 * WideEachUnit,210 * WideEachUnit)];
    moreView.center = app.keyWindow.center;
    moreView.center = CGPointMake(MainScreenWidth / 2, MainScreenHeight / 3);
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    moreView.userInteractionEnabled = YES;
    _allWindowView.userInteractionEnabled = YES;
    
    //添加
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, 180 * WideEachUnit, 12 * WideEachUnit)];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    title.font = Font(12 * WideEachUnit);
    title.text = @"评价该课程";
    title.textAlignment = NSTextAlignmentCenter;
    [moreView addSubview:title];
    
    for (int i = 0 ; i < 5; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20 * WideEachUnit + 22 * i + 10 * i, 35 * WideEachUnit, 22 * WideEachUnit, 22 * WideEachUnit)];
        [button setBackgroundImage:[UIImage imageNamed:@"star1@3x"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"star2@3x"] forState:UIControlStateSelected];
        button.tag = i + 1;
        [button addTarget:self action:@selector(starButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:button];
        if (i == 0) {
            _starButton_One = button;
        } else if (i == 1) {
            _starButton_Two = button;
        } else if (i == 2) {
            _starButton_There = button;
        } else if (i == 3) {
            _starButton_Four = button;
        } else if (i == 4) {
            _starButton_Five = button;
        }
    }
    
    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 * WideEachUnit, 200 * WideEachUnit, 100 * WideEachUnit)];
    textBackView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [moreView addSubview:textBackView];
    
    //添加textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 5 * WideEachUnit, 180 * WideEachUnit, 90 * WideEachUnit)];
    _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [textBackView addSubview:_textView];
    
    //添加提交的按钮
    UIButton *subitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textBackView.frame), 200 * WideEachUnit, 40 * WideEachUnit)];
    [subitButton setTitle:@"提交" forState:UIControlStateNormal];
    [subitButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [subitButton addTarget:self action:@selector(subitButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:subitButton];
}

#pragma mark --- 手势
- (void)allWindowViewClick:(UIGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectButtonCilck {
    [self netWorkLineVideoCollect];
}
- (void)lineVideoShare {
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:shareUrl];
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppSecret url:shareUrl];
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppId secret:SinaAppSecret RedirectURL:shareUrl];UMShareToSina
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:[NSString stringWithFormat:@"%@",[_dict stringValueForKey:@"course_name"]]
                                     shareImage:shareImageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
    
    
}


- (void)imageBcakButtonCilck:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonCilck:(UIButton *)button {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    NSInteger buttonTag = button.tag;
    if (buttonTag == 0) {
        [self gotoSendMessage];
    } else if (buttonTag == 1) {
        if ([[_dict stringValueForKey:@"is_buy"] integerValue] == 1) {
            [TKProgressHUD showError:@"已经解锁" toView:self.view];
            return;
        } else {
            
            ClassAndLivePayViewController *payVc = [[ClassAndLivePayViewController alloc] init];
            payVc.dict = _dict;
            payVc.cid = _ID;
            payVc.typeStr = @"3";//线下课
            [self.navigationController pushViewController:payVc animated:YES];
        }
    }
}

- (void)detailButtonCilck {
    _detailAndCommentScrollView.contentOffset = CGPointMake(0, 0);
    _detailButton.selected = YES;
    _commentButton.selected = NO;
    _twoView.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame) + 10 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit + _detailHight + 10 * WideEachUnit);
    _allScrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_twoView.frame) + 10 * WideEachUnit);
    _imageView.hidden = YES;
}

- (void)commentButtonCilck {
    _detailAndCommentScrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
    _detailButton.selected = NO;
    _commentButton.selected = YES;
    _allScrollView.contentSize = CGSizeMake(MainScreenWidth, _commentHight + 50 * WideEachUnit + 160 * WideEachUnit + 10 * WideEachUnit + 90 * WideEachUnit);
    _twoView.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame) + 10 * WideEachUnit, MainScreenWidth, 800 * WideEachUnit);
    if (_commentArray.count == 0) {
        _imageView.hidden = NO;
    }
    
}

- (void)secitionButtonCilck {
    if ([[_dict stringValueForKey:@"is_buy"] integerValue] == 1) {//已经解锁
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
            DLViewController *DLVC = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
//        SYGDPViewController *SYGDPVC = [[SYGDPViewController alloc] init];
//        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:SYGDPVC];
//        SYGDPVC.ID = _ID;
//        SYGDPVC.isTeacher = @"lineClass";
//        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        [self addAllWindow];
        
    } else {
        [TKProgressHUD showError:@"解锁了才能评论" toView:self.view];
    }
}

- (void)starButtonCilck:(UIButton *)button {
    
    NSInteger K = button.tag;
    if (K == 1) {//一颗星
        _starButton_One.selected = YES;
        _starButton_Two.selected = NO;
        _starButton_There.selected = NO;
        _starButton_Four.selected = NO;
        _starButton_Five.selected = NO;
    } else if (K == 2) {//二颗星
        _starButton_One.selected = YES;
        _starButton_Two.selected = YES;
        _starButton_There.selected = NO;
        _starButton_Four.selected = NO;
        _starButton_Five.selected = NO;
        
    }  else if (K == 3) {//三颗星
        _starButton_One.selected = YES;
        _starButton_Two.selected = YES;
        _starButton_There.selected = YES;
        _starButton_Four.selected = NO;
        _starButton_Five.selected = NO;
        
    }  else if (K == 4) {//四颗星
        _starButton_One.selected = YES;
        _starButton_Two.selected = YES;
        _starButton_There.selected = YES;
        _starButton_Four.selected = YES;
        _starButton_Five.selected = NO;
        
    }  else if (K == 5) {//五颗星
        _starButton_One.selected = YES;
        _starButton_Two.selected = YES;
        _starButton_There.selected = YES;
        _starButton_Four.selected = YES;
        _starButton_Five.selected = YES;
        
    }
    //这里取到的tag值就是评论的星级个数
    _starStr = [NSString stringWithFormat:@"%ld",K];
}

- (void)subitButtonCilck:(UIButton *)button {
    [self netWorkLineVideoAddReview];
}

#pragma mark ---- 滚动试图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView = _detailAndCommentScrollView;
    NSLog(@"---%lf",scrollView.contentOffset.x);
    
    if (scrollView.contentOffset.x == MainScreenWidth) {//就是点评页面
        _detailButton.selected = NO;
        _commentButton.selected = YES;
        _imageView.hidden = NO;
        _detailAndCommentScrollView.frame = CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit + _commentArray.count * 85 * WideEachUnit + 100 * WideEachUnit);
        _twoView.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame) + 10 * WideEachUnit, MainScreenWidth, 190 * WideEachUnit + _commentArray.count * 85 * WideEachUnit);
        _allScrollView.contentSize = CGSizeMake(MainScreenWidth, _commentHight + 50 * WideEachUnit + 160 * WideEachUnit + 10 * WideEachUnit + 100 * WideEachUnit);
//        _twoView.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame) + 10 * WideEachUnit, MainScreenWidth, _commentHight + 40 * WideEachUnit);
        
        
    } else {//详情页面
        _detailButton.selected = YES;
        _commentButton.selected = NO;
        _imageView.hidden = YES;
        _detailAndCommentScrollView.frame = CGRectMake(0, 40 * WideEachUnit, MainScreenWidth,50 * WideEachUnit + _detailHight + 100 * WideEachUnit);
        _twoView.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame) + 10 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit + _detailHight);
        _allScrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_twoView.frame) + 10 * WideEachUnit + 100 * WideEachUnit);
    }
    
}

#pragma mark --- 方法
- (void)gotoSendMessage {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
    MSVC.TID = [_dict stringValueForKey:@"teacher_uid"];
    MSVC.name = [_dict stringValueForKey:@"teacher_name"];
    [self.navigationController pushViewController:MSVC animated:YES];
}



#pragma mark ---- 网络请求
//线下课的详情
- (void)netWorkLineVideoGetInfo {
    
    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_ID == nil) {
        return;
    }
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
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _dict = [dict dictionaryValueForKey:@"data"];
            } else {
                _dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        _collectStr = [_dict stringValueForKey:@"is_collect"];
        if ([_collectStr integerValue] == 1) {//已经收藏
            [_collectButton setImage:Image(@"ic_collect_press@3x") forState:UIControlStateNormal];
        } else {
            [_collectButton setImage:Image(@"ic_collect@3x") forState:UIControlStateNormal];
        }
        [self addShareImageView];
        [self oneViewGet];
        [self twoViewGet];
        [self addDownView];
        if ([[_dict stringValueForKey:@"is_buy"] integerValue] == 1) {
            [_buyButton setTitle:@"已解锁" forState:UIControlStateNormal];
        } else {
            [_buyButton setTitle:@"解锁课程" forState:UIControlStateNormal];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}
//线下课的评论
- (void)netWorkLineVideoGetRender {
    
    NSString *endUrlStr = YunKeTang_Video_video_render;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"1" forKey:@"page"];
    [mutabDict setValue:@"100" forKey:@"count"];
    [mutabDict setValue:_ID forKey:@"kzid"];
    [mutabDict setValue:@"3" forKey:@"kztype"];
    [mutabDict setValue:@"2" forKey:@"type"];
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
            if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
                if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]] ) {
                    _commentArray = [dict arrayValueForKey:@"data"];
                } else {
                    _commentArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                }
            }
//            [self addCommentView];
            [self netWorkCourseReviewConf];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//课程收藏
- (void)netWorkLineVideoCollect {
    
    NSString *endUrlStr = YunKeTang_Video_video_collect;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"7" forKey:@"sctype"];
    if ([_collectStr integerValue] == 1) {//已经收藏（为取消收藏操作）
        [mutabDict setValue:@"0" forKey:@"type"];
    } else {//没有收藏 （为收藏操作）
        [mutabDict setValue:@"1" forKey:@"type"];
    }
    [mutabDict setValue:_ID forKey:@"source_id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            if ([_collectStr integerValue] == 1) {
                _collectStr = @"0";
                 [_collectButton setImage:Image(@"ic_collect@3x") forState:UIControlStateNormal];
            } else {
                _collectStr = @"1";
                [_collectButton setImage:Image(@"ic_collect_press@3x") forState:UIControlStateNormal];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//线下课评论
- (void)netWorkLineVideoAddReview {
    
    NSString *endUrlStr = YunKeTang_Video_video_addReview;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_ID forKey:@"kzid"];
    [mutabDict setValue:@"" forKey:@"title"];
    [mutabDict setValue:_textView.text forKey:@"content"];
    //评论星级
    [mutabDict setValue:_starStr forKey:@"score"];
    [mutabDict setValue:@"3" forKey:@"kztype"]; // 2为专辑 1 为课程 3为线下课
    
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
            [_allWindowView removeFromSuperview];
            [self netWorkLineVideoGetRender];
        } else {
            [_allWindowView removeFromSuperview];
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取课程分享的链接
- (void)netWorkLineVideoGetShareUrl {
    
    NSString *endUrlStr = YunKeTang_Video_video_getShareUrl;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"3" forKey:@"type"];
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
            shareUrl = [dict stringValueForKey:@"share_url"];
            [self lineVideoShare];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//评论的配置
- (void)netWorkCourseReviewConf {
    NSString *endUrlStr = YunKeTang_Course_video_reviewConf;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                dict = [dict dictionaryValueForKey:@"data"];
            } else {
                dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            _line_switch = [dict stringValueForKey:@"course_line_switch"];
            if ([_line_switch integerValue] == 0) {//关
                [self addCommentView];
            } else {
                [self addCommentView];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



#pragma mark --- 通知
- (void)getHight:(NSNotification *)not {
    _cellHight = [not.object floatValue];
    [_tableView reloadData];
}

#pragma mark --- 支付

#pragma mark --- 添加跳转识图
- (void)addWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    if (_typeNum == 1) {
        if (_alipayStr == nil) {
            [TKProgressHUD showError:@"支付失败" toView:self.view];
        } else {
            url = [NSURL URLWithString:_alipayStr];
        }
        
    } else if (_typeNum == 2) {
        if (_wxpayStr == nil) {
            [TKProgressHUD showError:@"支付失败" toView:self.view];
        } else {
            url = [NSURL URLWithString:_wxpayStr];
        }
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}





@end
