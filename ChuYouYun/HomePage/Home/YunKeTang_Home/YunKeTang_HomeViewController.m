//
//  YunKeTang_HomeViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/3/28.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "YunKeTang_HomeViewController.h"
#import "SYG.h"
#import "YunKeTang_Api.h"
#import "TKProgressHUD+Add.h"
#import "Passport.h"
#import "AppDelegate.h"

#import "HomeSearchViewController.h"
#import "SDCycleScrollView.h"
#import "ClassSearchGoodViewController.h"
#import "AdViewController.h"

#import "YunKeTang_HomeCollectionViewCell.h"
#import "ZhiBoBigRoomViewController.h"
#import "ZhiBoMainViewController.h"
#import "Good_TeacherMainViewController.h"
#import "Good_InstitutionMainViewController.h"
#import "OfflineMainViewController.h"

#import "OfflineDetailViewController.h"
#import "TeacherMainViewController.h"
#import "InstitutionMainViewController.h"
#import "Good_ClassMainViewController.h"
#import "VideoMarqueeViewController.h"
#import "WebViewController.h"
#import "ShoppingViewController.h"
#import "NewsMainViewController.h"
#import "ZXDTViewController.h"
#import "DLViewController.h"
// 直播板块儿 cell
#import "HomeLiveTableViewCell.h"
// 线下课 cell
#import "HomeOfflineTableViewCell.h"


#define cellWidth (MainScreenWidth - 30 * WideEachUnit) / 2
#define cellSpace  10 * WideEachUnit
#define cellHight  cellWidth

@interface YunKeTang_HomeViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (strong ,nonatomic)UITableView             *tableView;
@property (strong ,nonatomic)UICollectionView        *collectionView;
@property (strong ,nonatomic)UIView                  *tableViewHeaderView;
@property (strong ,nonatomic)UIScrollView            *imageScrollView;
@property (strong ,nonatomic)UIScrollView            *cateScrollView;
@property (strong ,nonatomic)UIScrollView            *liveScrollView;
@property (strong, nonatomic) UIView *liveHeaderView;

//数据类
@property (strong ,nonatomic)NSArray                 *imageDataArray;
@property (strong ,nonatomic)NSMutableArray          *titleArray;
@property (strong ,nonatomic)NSMutableArray          *bannerurlArray;
@property (strong ,nonatomic)NSMutableArray          *imageArray;
@property (strong ,nonatomic)NSArray                 *cateArray;
@property (strong ,nonatomic)NSArray                 *liveArray;
@property (strong ,nonatomic)NSArray                 *liveTimeArray;
@property (strong ,nonatomic)NSMutableArray          *timeArray;
@property (strong ,nonatomic)NSArray                 *choicenessArray;
@property (strong ,nonatomic)NSArray                 *lineClassArray;
@property (strong ,nonatomic)NSArray                 *newsArray;
@property (strong ,nonatomic)NSArray                 *tableTitleArray;
@property (strong ,nonatomic)NSArray                 *teacherArray;
@property (strong ,nonatomic)NSArray                 *schoolArray;

@property (strong ,nonatomic)NSTimer                 *timer;
//营销数据
@property (strong ,nonatomic)NSString                *order_switch;


@end

static NSString *cellID = @"cell";

@implementation YunKeTang_HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.hidden = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"App_Key"] == nil) {
        [app netInitApp];
    }
    if (_choicenessArray.count == 0) {
        [self getHomeAllData];
    }
    [self getPayMethodConfig];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHomeData) name:@"reloadEdulineHomeData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayMethodConfig) name:@"getPayMethodConfig" object:nil];
    [self interFace];
    [self addNav];
    [self addTableHeaderView];
    [self addTableView];
    [self netWorkConfigGetMarketStatus];
    [self reloadHomeData];
    [self getHomeAllData];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _bannerurlArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    _titleArray = [NSMutableArray array];
    _timeArray = [NSMutableArray array];
    if ([MoreOrSingle integerValue] == 1) {//单机构
        _tableTitleArray = @[@"最近直播",@"精选课程",@"最新课程",@"预约课程",@"名师推荐"];
    } else if ([MoreOrSingle integerValue] == 2) {//多机构
        _tableTitleArray = @[@"最近直播",@"精选课程",@"最新课程",@"预约课程",@"名师推荐",@"机构推荐"];
    }
    //定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(NetWorkAgain) userInfo:nil repeats:YES];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    //    //添加搜索
    SYGTextField *searchText = [[SYGTextField alloc] initWithFrame:CGRectMake(30, 25, MainScreenWidth - 60, 30)];
    
    if (iPhoneX) {
        searchText.frame = CGRectMake(30, 45, MainScreenWidth - 60, 30);
    }
    searchText.placeholder = @"搜索课程";
    searchText.font = Font(15);
    [searchText setValue:Font(16) forKeyPath:@"_placeholderLabel.font"];
    [searchText sygDrawPlaceholderInRect:CGRectMake(0, 10, 0, 0)];
    searchText.layer.borderWidth = 1;
    searchText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    searchText.backgroundColor = [UIColor whiteColor];
    searchText.layer.cornerRadius = 5;
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    searchText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    searchText.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
    [button setImage:Image(@"yunketang_search") forState:UIControlStateNormal];
    [searchText.leftView addSubview:button];
    [SYGView addSubview:searchText];
    
    
    //添加透明的按钮
    UIButton *searchButton = [[UIButton alloc] initWithFrame:searchText.bounds];
    searchButton.backgroundColor = [UIColor clearColor];
    [searchButton addTarget:self action:@selector(homeSearchButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [searchText addSubview:searchButton];
}

- (void)addTableHeaderView {
    _tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 500 * WideEachUnit)];
    if (iPhoneX) {
        _tableViewHeaderView.frame = CGRectMake(0, NavigationBarHeight, MainScreenWidth, 500 * WideEachUnit);
    }
    _tableViewHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [self.view addSubview:_tableViewHeaderView];
}

- (void)addImageScrollView {
    if (_imageScrollView == nil) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 2 * MainScreenWidth / 5)];
        [_tableViewHeaderView addSubview:_imageScrollView];
    }
    [_imageScrollView removeAllSubviews];
    _imageScrollView.backgroundColor = [UIColor whiteColor];
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    _imageScrollView.showsVerticalScrollIndicator = NO;
    _imageScrollView.contentSize = CGSizeMake(MainScreenWidth * 3, MainScreenWidth * 2 / 5);
    
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenWidth * 2 / 5) delegate:self placeholderImage:[UIImage imageNamed:@"站位图"]];
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = _imageArray;
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.pageControlDotSize = CGSizeMake(5, 5);
    cycleScrollView3.delegate = self;
    [_imageScrollView addSubview:cycleScrollView3];
}

- (void)addCateScrollView {
    
    if (_cateScrollView == nil) {
        _cateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame), MainScreenWidth, 180 * WideEachUnit)];
        _cateScrollView.backgroundColor = [UIColor whiteColor];
        _cateScrollView.pagingEnabled = YES;
        _cateScrollView.scrollEnabled = NO;
        _cateScrollView.delegate = self;
        _cateScrollView.showsHorizontalScrollIndicator = NO;
        _cateScrollView.showsVerticalScrollIndicator = NO;
        [_tableViewHeaderView addSubview:_cateScrollView];
    }
    if (_cateArray.count % 10 == 0) {
        _cateScrollView.contentSize = CGSizeMake(MainScreenWidth * (_cateArray.count / 10), 0);
    } else {
        _cateScrollView.contentSize = CGSizeMake(MainScreenWidth * (_cateArray.count / 10 + 1), 0);
    }
    [_cateScrollView removeAllSubviews];
    //添加按钮
    NSInteger Num = 5;
    CGFloat ButtonW = (MainScreenWidth - (Num + 1) * SpaceBaside) / Num;
    CGFloat ButtonH = ButtonW;
    CGFloat allW = ButtonW;
    CGFloat allH = ButtonH + 20 * WideEachUnit;//20 为显示字
    NSInteger oneCount = 10;
    NSInteger twoCount;
    CGFloat nameWidth = (MainScreenWidth - 24) / 5.0;
    if (_cateArray.count <= 10) {
        oneCount = _cateArray.count;
    }
    
    for (int i = 0 ; i < oneCount; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (i % Num) * (ButtonW + SpaceBaside), SpaceBaside + (i / Num) * (allH + SpaceBaside), allW, allH)];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = Font(16 * WideEachUnit);
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (i == 9) {
            
        } else {
            NSString *urlStr = [NSString stringWithFormat:@"%@",_cateArray[i][@"middle_ids"]];
            [button sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        }
        
        button.imageEdgeInsets =  UIEdgeInsetsMake(5 * WideEachUnit,5 * WideEachUnit,allH - allW + 5 * WideEachUnit,5 * WideEachUnit);
        //        button.titleEdgeInsets = UIEdgeInsetsMake(ButtonH,-100 ,0 ,0);
        
        button.imageView.layer.cornerRadius = ButtonW / 2 - 5 * WideEachUnit;
        button.imageView.layer.masksToBounds = YES;
        button.tag = i;
        [button addTarget:self action:@selector(cateButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cateScrollView addSubview:button];
        
        //添加名字
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, button.bottom - 20 * WideEachUnit, nameWidth, 20 * WideEachUnit)];
        name.centerX = button.centerX;
        name.font = Font(12 * WideEachUnit);
        name.textColor = BlackNotColor;
        name.textAlignment = NSTextAlignmentCenter;
        name.lineBreakMode = NSLineBreakByCharWrapping;
        name.text = [[_cateArray objectAtIndex:i] stringValueForKey:@"title"];
        for (int i = (int)name.text.length; i>0; i--) {
            CGFloat widthhh = [[name.text substringWithRange:NSMakeRange(0, i)] sizeWithFont:name.font].width;
            if (widthhh <= nameWidth) {
                name.text = [name.text substringWithRange:NSMakeRange(0, i)];
                break;
            }
        }
        if (i == 9) {
            name.text = @"更多";
            [button setImage:Image(@"home_more（优化）") forState:UIControlStateNormal];
            button.imageView.layer.cornerRadius = ButtonW / 2 - 12 * WideEachUnit;
            if (iPhone6) {
                button.imageView.layer.cornerRadius = ButtonW / 2 - 12 * WideEachUnit;
            } else if (iPhone5o5Co5S) {
                
            } else if (iPhone6Plus) {
                
            }
        }
        [_cateScrollView addSubview:name];
        
        _cateScrollView.frame = CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame), MainScreenWidth,2 * allH + 5  * SpaceBaside);
        if (iPhone6) {
            _cateScrollView.frame = CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame), MainScreenWidth,2 * allH + 3 * SpaceBaside + 5);
            
        }
    }
    
    if (_cateArray.count > 10) {
        twoCount = _cateArray.count;
    } else {
        twoCount = 10;
    }
    
    if (_cateArray.count == 0) {
        _cateScrollView.frame = CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame), MainScreenWidth, 0);
    } else {
        _cateScrollView.frame = CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame), MainScreenWidth,_cateArray.count>5?(2 * allH + 5  * SpaceBaside):(allH + 2 * SpaceBaside));
    }
    _tableViewHeaderView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_cateScrollView.frame) + 10 * WideEachUnit);
}


- (void)addLiveScrollView {
    if (_liveHeaderView == nil) {
        _liveHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cateScrollView.frame) + (_cateScrollView.frame.size.height > 0 ? 10 : 0), MainScreenWidth, 40)];
        _liveHeaderView.backgroundColor = [UIColor whiteColor];
        [_tableViewHeaderView addSubview:_liveHeaderView];
        _liveHeaderView.userInteractionEnabled = YES;
        
        //蓝色标志
        UIView *blueIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 20)];
        blueIcon.backgroundColor = BasidColor;
        [_liveHeaderView addSubview:blueIcon];
        
        //标题
        UILabel *liveLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 150, 20)];
        liveLabel.text = @"最近直播";
        liveLabel.font = Font(16);
        liveLabel.backgroundColor = [UIColor whiteColor];
        [_liveHeaderView addSubview:liveLabel];
        liveLabel.userInteractionEnabled = YES;
        
        blueIcon.centerY = liveLabel.centerY;
        
        UILabel *liveMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 115, SpaceBaside / 2 , 100, 30)];
        liveMoreLabel.userInteractionEnabled = YES;
        liveMoreLabel.text = @"查看全部";
        liveMoreLabel.font = SYSTEMFONT(13);
        liveMoreLabel.textColor = RGBHex(0x868686);
        liveMoreLabel.textAlignment = NSTextAlignmentRight;
        UITapGestureRecognizer *liveMoreLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveMoreButtonCilck)];
        [liveMoreLabel addGestureRecognizer:liveMoreLabelTap];
        [_liveHeaderView addSubview:liveMoreLabel];
    }
    
    if (_liveScrollView == nil) {
        _liveScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_liveHeaderView.frame), MainScreenWidth , 180)];
        _liveScrollView.backgroundColor = [UIColor whiteColor];
        _liveScrollView.showsHorizontalScrollIndicator = NO;
        _liveScrollView.showsVerticalScrollIndicator = NO;
        _liveScrollView.contentSize = CGSizeMake(MainScreenWidth * 2, 200);
        _liveScrollView.userInteractionEnabled = YES;
        [_tableViewHeaderView addSubview:_liveScrollView];
    }
    [_liveScrollView removeAllSubviews];
    
    CGFloat ButtonW = 120;
    CGFloat ButtonH = 70 + 15;
    NSInteger Num = _liveArray.count;
    
    for (int i = 0; i < Num; i++) {
        
    }
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 14, Num * (SpaceBaside + ButtonW), 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_liveScrollView addSubview:lineButton];
    //添加时间轴
    for (int i = 0 ; i < Num; i ++) {
        UIButton *timeButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (SpaceBaside + ButtonW) * i, 10, 90, 8)];
        if (iPhone5o5Co5S) {
            timeButton.frame = CGRectMake(SpaceBaside + (SpaceBaside + ButtonW) * i, 10, 80, 8);
        } else if (iPhone6) {
            timeButton.frame = CGRectMake(SpaceBaside + (SpaceBaside + ButtonW) * i, 10, 80, 8);
        } else if (iPhone6Plus) {
            timeButton.frame = CGRectMake(SpaceBaside + (SpaceBaside + ButtonW) * i, 10, 80, 8);
        }
        
        NSString *startHour = [Passport formatterTime:[_liveTimeArray objectAtIndex:i]];
        startHour = [startHour substringWithRange:NSMakeRange(0, startHour.length - 9)];
        [timeButton setTitle:startHour forState:UIControlStateNormal];
        timeButton.backgroundColor = [UIColor whiteColor];
        [timeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [timeButton setImage:Image(@"哈哈circle@3x") forState:UIControlStateNormal];
        timeButton.titleLabel.font = Font(10);
        timeButton.imageEdgeInsets =  UIEdgeInsetsMake(0,-3,0,50);
        [_liveScrollView addSubview:timeButton];
        
        //        if (_timeArray.count && i > 0) {
        //            NSString *oldTimeStr = _timeArray[i - 1];
        //            if ([oldTimeStr isEqualToString:startHour]) {//说明时间重合
        //                timeButton.hidden = YES;
        //            }
        //        }
    }
    
    NSLog(@"%@",_liveArray);
    
    //添加直播的课程
    for (int i = 0 ; i < Num; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + i * (ButtonW + SpaceBaside), 30, ButtonW, ButtonH)];
        NSString *urlStr = [[_liveArray objectAtIndex:i] stringValueForKey:@"imageurl"];;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        [_liveScrollView addSubview:button];
        button.tag = i;
        button.userInteractionEnabled = YES;
        [button addTarget:self action:@selector(liveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *sectionsArray = [[_liveArray objectAtIndex:i] arrayValueForKey:@"sections"];;;
        
        //添加介绍
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside + i * (ButtonW + SpaceBaside), 30 + ButtonH, ButtonW, 40)];
        if (sectionsArray.count) {
            label.text = [[_liveArray objectAtIndex:i] stringValueForKey:@"video_title"];
        } else {
            label.text = [[_liveArray objectAtIndex:i] stringValueForKey:@"video_title"];
        }
        label.font = Font(14);
        label.numberOfLines = 1;
        [_liveScrollView addSubview:label];
        
        //添加名字
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside + i * (ButtonW + SpaceBaside), 30 + ButtonH + 40, ButtonW / 2, 10)];
        price.font = Font(12);
        NSString *eoprice = [NSString stringWithFormat:@"%@",[[_liveArray[i] objectForKey:@"mz_price"] objectForKey:@"eoPrice"]];
        if (SWNOTEmptyStr(eoprice)) {
            if ([eoprice integerValue] > 0) {
                price.text = [[_liveArray[i] objectForKey:@"mz_price"] objectForKey:@"selPrice"];
                if ([[[_liveArray[i] objectForKey:@"mz_price"] objectForKey:@"selPrice"] floatValue] == 0) {
                    price.text = @"免费";
                    price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                } else {
                    price.text = [NSString stringWithFormat:@"%@育币",[[_liveArray[i] objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
                    price.textColor = PriceColor;
                }
            } else {
                price.text = [NSString stringWithFormat:@"%@育币",[[_liveArray objectAtIndex:i] stringValueForKey:@"t_price"]];
                price.font = Font(12);
                price.textAlignment = NSTextAlignmentLeft;
                price.textColor = [UIColor colorWithHexString:@"#f01414"];
                if ([[[_liveArray objectAtIndex:i] stringValueForKey:@"t_price"] floatValue] == 0) {
                    price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                    price.text = @"免费";
                }
            }
        } else {
            price.text = [NSString stringWithFormat:@"%@育币",[[_liveArray objectAtIndex:i] stringValueForKey:@"t_price"]];
            price.font = Font(12);
            price.textAlignment = NSTextAlignmentLeft;
            price.textColor = [UIColor colorWithHexString:@"#f01414"];
            if ([[[_liveArray objectAtIndex:i] stringValueForKey:@"t_price"] floatValue] == 0) {
                price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                price.text = @"免费";
            }
        }
        
        [_liveScrollView addSubview:price];
        
        //添加人数报名
        UILabel *person = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside + i * (ButtonW + SpaceBaside) + ButtonW / 2, 30 + ButtonH + 40, ButtonW / 2, 10)];
        person.text = [NSString stringWithFormat:@"%@人报名",[[_liveArray objectAtIndex:i] stringValueForKey:@"video_order_count"]];
        if ([_order_switch integerValue] == 1) {
             person.text = [NSString stringWithFormat:@"%@人报名",[[_liveArray objectAtIndex:i] stringValueForKey:@"video_order_count_mark"]];
        }
        person.font = Font(12);
        person.textAlignment = NSTextAlignmentRight;
        person.textColor = [UIColor grayColor];
        [_liveScrollView addSubview:person];
        
        //添加透明的按钮
        UIButton *liveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_liveScrollView.frame), CGRectGetHeight(_liveScrollView.frame))];
        liveButton.backgroundColor = [UIColor clearColor];
        [liveButton addTarget:self action:@selector(liveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        liveButton.tag = i;
        liveButton.enabled = YES;
        [_liveScrollView addSubview:liveButton];
        liveButton.hidden = YES;
        
    }
    
    
    //设置滚动的范围
    _liveScrollView.contentSize = CGSizeMake(Num * ButtonW + (Num + 1) * SpaceBaside, 0);
    
    
    //直播数据为空的时候 就隐藏
    if (_liveArray.count == 0) {
        _liveHeaderView.frame = CGRectMake(0, CGRectGetMaxY(_cateScrollView.frame), MainScreenWidth, 0);
        _liveHeaderView.hidden = YES;
        _liveScrollView.frame = CGRectMake(0, CGRectGetMaxY(_liveHeaderView.frame), MainScreenWidth, 0);
    } else {
        _liveHeaderView.frame = CGRectMake(0, CGRectGetMaxY(_cateScrollView.frame) + (_cateScrollView.frame.size.height > 0 ? 10 : 0), MainScreenWidth, 40);
        _liveHeaderView.hidden = NO;
        _liveScrollView.frame = CGRectMake(0, CGRectGetMaxY(_liveHeaderView.frame), MainScreenWidth , 180);
    }
    
    //确实头部视图的具体大小
    _tableViewHeaderView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_liveScrollView.frame) + 10 * WideEachUnit);
}

#pragma mark --- 添加表格视图
- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 50) style:UITableViewStyleGrouped];
    if (iPhone6Plus) {
        _tableView.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 50);
    } else if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88 - 83);
    }
    _tableView.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_TABBAR_HEIGHT);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(tableViewHeader)];
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark ---表格刷新
- (void)tableViewHeader {
    [self getHomeAllData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

#pragma mark -- UITableViewDataSoucre


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40 * WideEachUnit;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *cellHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40 * WideEachUnit)];
    cellHeaderView.backgroundColor = [UIColor whiteColor];
    
    //蓝色标志
    UIView *blueIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 20)];
    blueIcon.backgroundColor = BasidColor;
    [cellHeaderView addSubview:blueIcon];
    
    //标题
    UILabel *liveLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 150, 20)];
    liveLabel.text = _tableTitleArray[section];
    liveLabel.font = Font(16);
    liveLabel.backgroundColor = [UIColor whiteColor];
    [cellHeaderView addSubview:liveLabel];
    liveLabel.userInteractionEnabled = YES;
    
    blueIcon.centerY = liveLabel.centerY;
    
    UILabel *liveMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 115, SpaceBaside / 2 , 100, 30)];
    liveMoreLabel.userInteractionEnabled = YES;
    liveMoreLabel.text = @"查看全部";
    liveMoreLabel.font = SYSTEMFONT(13);
    liveMoreLabel.textColor = RGBHex(0x868686);
    liveMoreLabel.textAlignment = NSTextAlignmentRight;
    liveMoreLabel.tag = 100 * section;
    UITapGestureRecognizer *liveMoreLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forViewMoreButtonClick:)];
    [liveMoreLabel addGestureRecognizer:liveMoreLabelTap];
    [cellHeaderView addSubview:liveMoreLabel];
    
    return cellHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10 * WideEachUnit;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _liveArray.count;
    } else if (section == 3) {
        return _lineClassArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 直播
        return 70 + 15;
    } else if (indexPath.section == 1) {
        if (_choicenessArray.count == 0) {//精选课程
            return 0;
        } else {
            return (_choicenessArray.count / 2 + _choicenessArray.count % 2) * cellHight + 10 * WideEachUnit;
        }
    } else if (indexPath.section == 2) {//最新课程
        if (_newsArray.count == 0) {
            return 0;
        } else {
            return (_newsArray.count / 2 + _newsArray.count % 2) * cellHight + 10 * WideEachUnit;
        }
    } else if (indexPath.section == 3) {//线下课
        return 70 + 15;
    } else if (indexPath.section == 4){//名师推荐
        if (_teacherArray.count == 0) {
            return 0 * WideEachUnit;
        } else {
            return 160 + 30;
        }
    } else if (indexPath.section == 5) {//机构推荐
        if (_schoolArray.count == 0) {
            return 0 * WideEachUnit;
        } else {
            return 130;
        }
    } else {
        return 100 * WideEachUnit;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *liveCell = @"liveCell";
        HomeLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:liveCell];
        if (!cell) {
            cell = [[HomeLiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:liveCell];
        }
        [cell setLiveInfo:_liveArray[indexPath.row] order_switch:_order_switch liveTime:_liveTimeArray[indexPath.row]];
        return cell;
    } else {
        if (indexPath.section == 1) {//精选课程
            static NSString *cellID = @"cellID1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor whiteColor];
            for (int i = 0; i < _choicenessArray.count ; i++) {
                
                UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellSpace + (i % 2) * (cellWidth + cellSpace), cellSpace + (i / 2) * (cellHight) , cellWidth, cellHight)];
                cellView.backgroundColor = [UIColor whiteColor];
                cellView.tag = i;
                [cell addSubview:cellView];
                
                UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth / 5 * 3)];
                photoImageView.backgroundColor = [UIColor whiteColor];
                NSString *urlStr = [[_choicenessArray objectAtIndex:i] stringValueForKey:@"cover"];
                [photoImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
                photoImageView.userInteractionEnabled = YES;
                photoImageView.tag = i;
                [cellView addSubview:photoImageView];
                
                //添加课程的标识
                UIButton *logoLiveOrClassButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                logoLiveOrClassButton.backgroundColor = [UIColor clearColor];
                if ([[[_choicenessArray objectAtIndex:i] stringValueForKey:@"type"] integerValue] == 1) {//课程
                    [logoLiveOrClassButton setImage:Image(@"course_ident@3x") forState:UIControlStateNormal];
                } else if ([[[_choicenessArray objectAtIndex:i] stringValueForKey:@"type"] integerValue] == 2) {//直播
                    [logoLiveOrClassButton setImage:Image(@"course_ident_live@3x") forState:UIControlStateNormal];
                } else if ([[[_choicenessArray objectAtIndex:i] stringValueForKey:@"type"] integerValue] == 6) {
                    // 班级课
                    [logoLiveOrClassButton setImage:Image(@"course_class") forState:UIControlStateNormal];
                }
                [cellView addSubview:logoLiveOrClassButton];
                
                //添加名字
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHight / 5 * 3 + 10 * WideEachUnit , cellWidth, 20 * WideEachUnit)];
                title.text = [[_choicenessArray objectAtIndex:i] stringValueForKey:@"video_title"];
                title.numberOfLines = 1;
                title.font = Font(14);
                title.textColor = BlackNotColor;
                [cellView addSubview:title];
                
                //添加人数
                UILabel *person = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth / 2, CGRectGetMaxY(title.frame) + 5 * WideEachUnit, cellWidth / 2, 20 * WideEachUnit)];
                person.text = [NSString stringWithFormat:@"%@人正在学",[[_choicenessArray objectAtIndex:i] stringValueForKey:@"video_order_count"]];
                if ([_order_switch integerValue] == 1) {
                    person.text = [NSString stringWithFormat:@"%@人正在学",[[_choicenessArray objectAtIndex:i] stringValueForKey:@"video_order_count_mark"]];
                }
                person.font = Font(12);
                person.textColor = [UIColor grayColor];
                person.textAlignment = NSTextAlignmentRight;
                [cellView addSubview:person];
                
                //添加价格
                UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame) + 5 * WideEachUnit, cellWidth / 2 , 20 * WideEachUnit)];
                NSString *eoprice = [NSString stringWithFormat:@"%@",[[_choicenessArray[i] objectForKey:@"mz_price"] objectForKey:@"eoPrice"]];
                if (SWNOTEmptyStr(eoprice)) {
                    if ([eoprice integerValue]>0) {
                        price.text = [[_choicenessArray[i] objectForKey:@"mz_price"] objectForKey:@"selPrice"];
                        if ([[[_choicenessArray[i] objectForKey:@"mz_price"] objectForKey:@"selPrice"] floatValue] == 0) {
                            price.text = @"免费";
                            price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                        } else {
                            price.text = [NSString stringWithFormat:@"%@育币",[[_choicenessArray[i] objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
                            price.textColor = PriceColor;
                        }
                    } else {
                        price.text = [[_choicenessArray objectAtIndex:i] stringValueForKey:@"price"];
                        if ([[[_choicenessArray objectAtIndex:i] stringValueForKey:@"price"] floatValue] == 0) {
                            price.text = @"免费";
                            price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                        } else {
                            price.text = [NSString stringWithFormat:@"%@育币",[[_choicenessArray objectAtIndex:i] stringValueForKey:@"price"]];
                            price.textColor = PriceColor;
                        }
                    }
                } else {
                    price.text = [[_choicenessArray objectAtIndex:i] stringValueForKey:@"price"];
                    if ([[[_choicenessArray objectAtIndex:i] stringValueForKey:@"price"] floatValue] == 0) {
                        price.text = @"免费";
                        price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                    } else {
                        price.text = [NSString stringWithFormat:@"%@育币",[[_choicenessArray objectAtIndex:i] stringValueForKey:@"price"]];
                        price.textColor = PriceColor;
                    }
                }
                price.font = Font(13);
                [cellView addSubview:price];
                
                //添加手势
                [cellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseViewClick:)]];
            }
            return cell;
        } else if (indexPath.section == 2) {//最新课程
            static NSString *cellID = @"cellID2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor whiteColor];
            for (int i = 0; i < _newsArray.count ; i++) {
                UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(cellSpace + (i % 2) * (cellWidth + cellSpace), cellSpace + (i / 2) * (cellHight) , cellWidth, cellHight)];
                cellView.backgroundColor = [UIColor whiteColor];
                cellView.tag = i;
                [cell addSubview:cellView];
                
                UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth / 5 * 3)];
                photoImageView.backgroundColor = [UIColor whiteColor];
                NSString *urlStr = [[_newsArray objectAtIndex:i] stringValueForKey:@"cover"];
                [photoImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
                photoImageView.userInteractionEnabled = YES;
                photoImageView.tag = i;
                [cellView addSubview:photoImageView];
                
                //添加课程的标识
                UIButton *logoLiveOrClassButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                logoLiveOrClassButton.backgroundColor = [UIColor clearColor];
                if ([[[_newsArray objectAtIndex:i] stringValueForKey:@"type"] integerValue] == 1) {//课程
                    [logoLiveOrClassButton setImage:Image(@"course_ident@3x") forState:UIControlStateNormal];
                } else if ([[[_newsArray objectAtIndex:i] stringValueForKey:@"type"] integerValue] == 2) {//直播
                    [logoLiveOrClassButton setImage:Image(@"course_ident_live@3x") forState:UIControlStateNormal];
                } else if ([[[_newsArray objectAtIndex:i] stringValueForKey:@"type"] integerValue] == 6) {
                    // 班级课
                    [logoLiveOrClassButton setImage:Image(@"course_class") forState:UIControlStateNormal];
                }
                [cellView addSubview:logoLiveOrClassButton];
                
                //添加名字
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHight / 5 * 3 + 10 * WideEachUnit , cellWidth, 20 * WideEachUnit)];
                title.text = [[_newsArray objectAtIndex:i] stringValueForKey:@"video_title"];
                title.numberOfLines = 1;
                title.font = Font(14);
                title.textColor = BlackNotColor;
                [cellView addSubview:title];
                
                //添加人数
                UILabel *person = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth / 2, CGRectGetMaxY(title.frame) + 5 * WideEachUnit, cellWidth / 2, 20 * WideEachUnit)];
                person.text = [NSString stringWithFormat:@"%@人正在学",[[_newsArray objectAtIndex:i] stringValueForKey:@"video_order_count"]];
                if ([_order_switch integerValue] == 1) {
                    person.text = [NSString stringWithFormat:@"%@人正在学",[[_newsArray objectAtIndex:i] stringValueForKey:@"video_order_count_mark"]];
                }
                person.font = Font(12);
                person.textColor = [UIColor grayColor];
                person.textAlignment = NSTextAlignmentRight;
                [cellView addSubview:person];
                
                //添加价格
                UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame) + 5 * WideEachUnit, cellWidth / 2 , 20 * WideEachUnit)];
                NSString *eoprice = [NSString stringWithFormat:@"%@",[[_newsArray[i] objectForKey:@"mz_price"] objectForKey:@"eoPrice"]];
                if (SWNOTEmptyStr(eoprice)) {
                    if ([eoprice integerValue]>0) {
                        price.text = [[_newsArray[i] objectForKey:@"mz_price"] objectForKey:@"selPrice"];
                        if ([[[_newsArray[i] objectForKey:@"mz_price"] objectForKey:@"selPrice"] floatValue] == 0) {
                            price.text = @"免费";
                            price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                        } else {
                            price.text = [NSString stringWithFormat:@"%@育币",[[_newsArray[i] objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
                            price.textColor = PriceColor;
                        }
                    } else {
                        price.text = [[_newsArray objectAtIndex:i] stringValueForKey:@"price"];
                        if ([[[_newsArray objectAtIndex:i] stringValueForKey:@"price"] floatValue] == 0) {
                            price.text = @"免费";
                            price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                        } else {
                            price.text = [NSString stringWithFormat:@"%@育币",[[_newsArray objectAtIndex:i] stringValueForKey:@"price"]];
                            price.textColor = PriceColor;
                        }
                    }
                } else {
                    price.text = [[_newsArray objectAtIndex:i] stringValueForKey:@"price"];
                    if ([[[_newsArray objectAtIndex:i] stringValueForKey:@"price"] floatValue] == 0) {
                        price.text = @"免费";
                        price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                    } else {
                        price.text = [NSString stringWithFormat:@"%@育币",[[_newsArray objectAtIndex:i] stringValueForKey:@"price"]];
                        price.textColor = PriceColor;
                    }
                }
                price.font = Font(13);
                [cellView addSubview:price];
                
                //添加手势
                [cellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsViewClick:)]];
            }
            return cell;
        } else if (indexPath.section == 3) {//线下课
            static NSString *liveCell = @"offlineCell";
            HomeOfflineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:liveCell];
            if (!cell) {
                cell = [[HomeOfflineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:liveCell];
            }
            [cell setOfflineInfo:_lineClassArray[indexPath.row] order_switch:_order_switch];
            return cell;
        } else if (indexPath.section == 4) {//名师推荐
            static NSString *cellID = @"cellID4";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            [cell removeAllSubviews];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            CGFloat TeaViewWidth = 115;
            CGFloat TeaViewHight = 160;
            
            UIScrollView *teacherScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 160 + 30)];
            teacherScrollview.backgroundColor = [UIColor whiteColor];
            teacherScrollview.contentSize = CGSizeMake(15 * 2 + (TeaViewWidth + 12) * _teacherArray.count - 12, 160 + 30);
            teacherScrollview.showsVerticalScrollIndicator = NO;
            teacherScrollview.showsHorizontalScrollIndicator = NO;
            [cell addSubview:teacherScrollview];
            
            for (int i = 0 ; i < _teacherArray.count; i ++) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15 + (TeaViewWidth + 12) * i, 15, TeaViewWidth, TeaViewHight)];
                view.tag = i;
                view.layer.masksToBounds = NO;
                view.layer.cornerRadius = 10;
                view.backgroundColor = RGBHex(0xF5F5F5);
                view.layer.shadowColor = RGBHex(0xCDCDCD).CGColor;
                //剪切边界 如果视图上的子视图layer超出视图layer部分就截取掉 如果添加阴影这个属性必须是NO 不然会把阴影切掉
                //阴影半径，默认3
                view.layer.shadowRadius = 3;
                //shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
                view.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
                // 阴影透明度，默认0
                view.layer.shadowOpacity = 0.9f;
                [teacherScrollview addSubview:view];
                
                //添加头像
                UIImageView *TeaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 80, 80)];
                NSString *urlStr = [[_teacherArray objectAtIndex:i] stringValueForKey:@"headimg"];
                [TeaImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
                TeaImageView.layer.masksToBounds = YES;
                TeaImageView.layer.cornerRadius = 40;
                TeaImageView.centerX = TeaViewWidth / 2.0;
                [view addSubview:TeaImageView];
                
                //添加名字
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(TeaImageView.frame) + 13, TeaViewWidth, 20)];
                name.text = [[_teacherArray objectAtIndex:i] stringValueForKey:@"name"];
                name.textAlignment = NSTextAlignmentCenter;
                name.font = Font(14);
                name.textColor = RGBHex(0x3C3C3C);
                [view addSubview:name];
                
                //添加讲师等级
                UILabel *teacherLevel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(name.frame) + 3, TeaViewWidth, 17)];
                teacherLevel.text = [[_teacherArray objectAtIndex:i] stringValueForKey:@"teacher_title"];
                teacherLevel.textAlignment = NSTextAlignmentCenter;
                teacherLevel.font = Font(12);
                teacherLevel.textColor = RGBHex(0x7E7E7E);
                [view addSubview:teacherLevel];
                
                //添加手势
                [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teacherViewClick:)]];
            }
            return cell;
        } else if (indexPath.section == 5) {//机构推荐
            static NSString *cellID = @"cellID5";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            [cell removeAllSubviews];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            CGFloat TeaViewWidthMax = 315;
            CGFloat TeaViewHight = 100;
            
            UIScrollView *organizationScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 + 30)];
            organizationScrollview.backgroundColor = [UIColor whiteColor];
            organizationScrollview.showsVerticalScrollIndicator = NO;
            organizationScrollview.showsHorizontalScrollIndicator = NO;
            [cell addSubview:organizationScrollview];
            
            CGFloat XX = 15;
            
            for (int i = 0 ; i < _schoolArray.count ; i ++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(XX, 15, TeaViewWidthMax, TeaViewHight)];
                view.tag = i;
                view.layer.masksToBounds = NO;
                view.layer.cornerRadius = 8;
                view.backgroundColor = RGBHex(0xF5F5F5);
                view.layer.shadowColor = RGBHex(0xCDCDCD).CGColor;
                //剪切边界 如果视图上的子视图layer超出视图layer部分就截取掉 如果添加阴影这个属性必须是NO 不然会把阴影切掉
                //阴影半径，默认3
                view.layer.shadowRadius = 3;
                //shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
                view.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
                // 阴影透明度，默认0
                view.layer.shadowOpacity = 0.9f;
                [organizationScrollview addSubview:view];
                
                //添加头像
                UIImageView *TeaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 58, 58)];
                NSString *urlStr = [[_schoolArray objectAtIndex:i] stringValueForKey:@"cover"];
                [TeaImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
                TeaImageView.layer.masksToBounds = YES;
                TeaImageView.layer.cornerRadius = 58 / 2.0;
                TeaImageView.centerY = 50;
                [view addSubview:TeaImageView];
                
                //添加名字
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(TeaImageView.right + 15, TeaImageView.top + 12, TeaViewWidthMax, 20)];
                name.text = [[_schoolArray objectAtIndex:i] stringValueForKey:@"title"];
                name.font = Font(14);
                name.textColor = RGBHex(0x454545);
                [view addSubview:name];
                
                //添加讲师等级
                UILabel *schoolIntro = [[UILabel alloc] initWithFrame:CGRectMake(TeaImageView.right + 15, name.bottom + 2, TeaViewWidthMax, 20)];
                schoolIntro.text = @"判断机构名称和机构简介控件的长度";//[[_schoolArray objectAtIndex:i] stringValueForKey:@"title"];
                schoolIntro.font = Font(13);
                schoolIntro.textColor = RGBHex(0x868686);
                [view addSubview:schoolIntro];
                
                // 判断机构名称和机构简介控件的长度 取最长的去决定整个 view 的宽度 但是有个最大宽度 TeaViewWidthMax
                CGFloat nameWidth = [name.text sizeWithFont:name.font].width + 4;
                CGFloat schoolWidth = [schoolIntro.text sizeWithFont:schoolIntro.font].width + 4;
                [name setWidth:MAX(nameWidth, schoolWidth)];
                [schoolIntro setWidth:MAX(nameWidth, schoolWidth)];
                
                [view setWidth:name.right + 15];
                
                // 重置下一个控件的横坐标
                XX = XX + view.width + 15;

                //添加手势
                [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(schoolViewClick:)]];
            }
            organizationScrollview.contentSize = CGSizeMake(XX, 100 + 30);
            return cell;
        } else {
            static NSString *cellID = @"cellID2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([HASALIPAY isEqualToString:@"0"]) {
            if (!UserOathToken) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
                alert.tag = 100;
                [alert show];
                return;
            }
        }
        NSString *Cid = [[_liveArray objectAtIndex:indexPath.row] stringValueForKey:@"id"];
        NSString *Price = [[_liveArray objectAtIndex:indexPath.row] stringValueForKey:@"t_price"];
        NSString *Title = [[_liveArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
        NSString *ImageUrl = [[_liveArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
        
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
        zhiBoMainVc.order_switch = _order_switch;
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
    } else if (indexPath.section == 3) {
        if ([HASALIPAY isEqualToString:@"0"]) {
            if (!UserOathToken) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
                alert.tag = 100;
                [alert show];
                return;
            }
        }
        NSDictionary *dict = [_lineClassArray objectAtIndex:indexPath.row];
        
        OfflineDetailViewController *vc = [[OfflineDetailViewController alloc] init];
        vc.ID = [dict stringValueForKey:@"course_id"];
        vc.imageUrl = [dict stringValueForKey:@"cover"];
        vc.titleStr = [dict stringValueForKey:@"course_name"];
        vc.orderSwitch = _order_switch;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (SWNOTEmptyArr(_imageDataArray)) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:_imageDataArray[index]];
        NSString *bannerUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bannerurl"]];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:bannerUrl]]) {
            WebViewController *vc = [[WebViewController alloc] init];
            vc.urlString = bannerUrl;
            vc.titleString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"banner_title"]];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            if ([bannerUrl containsString:@"="]) {
                NSArray *pass = [bannerUrl componentsSeparatedByString:@"="];
                if (pass.count >= 2) {
                    NSString *type = pass[0];
                    NSString *typeId = pass[1];
                    if ([type isEqualToString:@"live"]) {
                        if ([typeId isEqualToString:@"0"]) {
                            ClassSearchGoodViewController *getSearchVc = [[ClassSearchGoodViewController alloc] init];
                            getSearchVc.typeStr = @"1";
                            [self.navigationController pushViewController:getSearchVc animated:YES];
                        } else {
                            if ([HASALIPAY isEqualToString:@"0"]) {
                                if (!UserOathToken) {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
                                    alert.tag = 100;
                                    [alert show];
                                    return;
                                }
                            }
                            ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:typeId andImage:nil andTitle:nil andNum:nil andprice:nil];
                            zhiBoMainVc.order_switch = _order_switch;
                            [self.navigationController pushViewController:zhiBoMainVc animated:YES];
                        }
                    } else if ([type isEqualToString:@"course"]) {
                        if ([typeId isEqualToString:@"0"]) {
                            ClassSearchGoodViewController *getSearchVc = [[ClassSearchGoodViewController alloc] init];
                            getSearchVc.typeStr = @"1";
                            [self.navigationController pushViewController:getSearchVc animated:YES];
                        } else {
                            if ([HASALIPAY isEqualToString:@"0"]) {
                                if (!UserOathToken) {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
                                    alert.tag = 100;
                                    [alert show];
                                    return;
                                }
                            }
                            Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
                            vc.ID = typeId;
                            vc.orderSwitch = _order_switch;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    } else if ([type isEqualToString:@"school"]) {
                        if ([typeId isEqualToString:@"0"]) {
                            Good_InstitutionMainViewController *homeInStVc = [[Good_InstitutionMainViewController alloc] init];
                            [self.navigationController pushViewController:homeInStVc animated:YES];
                        } else {
                            InstitutionMainViewController *institutionMainVc = [[InstitutionMainViewController alloc] init];
                            institutionMainVc.schoolID = typeId;
                            [self.navigationController pushViewController:institutionMainVc animated:YES];
                        }
                    } else if ([type isEqualToString:@"teacher"]) {
                        if ([typeId isEqualToString:@"0"]) {
                            Good_TeacherMainViewController *vc = [[Good_TeacherMainViewController alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                        } else {
                            TeacherMainViewController *teacherMainVc = [[TeacherMainViewController alloc] initWithNumID:typeId];
                            [self.navigationController pushViewController:teacherMainVc animated:YES];
                        }
                    } else if ([type isEqualToString:@"mall"]) {
                        if ([typeId isEqualToString:@"0"]) {
                            ShoppingViewController *shopVc = [[ShoppingViewController alloc] init];
                            [self.navigationController pushViewController:shopVc animated:YES];
                        } else {
                            
                        }
                    } else if ([type isEqualToString:@"news"]) {
                        if ([typeId isEqualToString:@"0"]) {
                            NewsMainViewController *newsMainVc = [[NewsMainViewController alloc] init];
                            [self.navigationController pushViewController:newsMainVc animated:YES];
                        } else {
                            ZXDTViewController *ZXDTVC = [[ZXDTViewController alloc] init];
                            ZXDTVC.ID = typeId;
                            [self.navigationController pushViewController:ZXDTVC animated:YES];
                        }
                    }
                }
            }
        }
    }
}


#pragma mark --- 计时器
- (void)NetWorkAgain {
    if (_teacherArray.count == 0 && _newsArray.count == 0 && _cateArray.count == 0 && _choicenessArray.count == 0 && _lineClassArray.count == 0 && _schoolArray.count == 0) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"App_Key"] == nil) {
            [[AppDelegate delegate] netInitApp];
        }
        [self getHomeAllData];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark --- 事件监听
- (void)homeSearchButtonCilck {
    HomeSearchViewController *homeSearchVc = [[HomeSearchViewController alloc] init];
    [self.navigationController pushViewController:homeSearchVc animated:NO];
}

//分类 点击
- (void)cateButton:(UIButton *)button {
    
    if (button.tag == 9) {
        ClassSearchGoodViewController *searchGetVc = [[ClassSearchGoodViewController alloc] init];
        [self.navigationController pushViewController:searchGetVc animated:YES];
    } else {
        NSDictionary *dict = _cateArray[button.tag];
        NSLog(@"----%@",dict);
        NSString *title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        NSString *ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"zy_currency_category_id"]];
        ClassSearchGoodViewController *searchGetVc = [[ClassSearchGoodViewController alloc] init];
        searchGetVc.typeStr = @"1";
        searchGetVc.cateStr = title;
        searchGetVc.cate_ID = ID;
        [self.navigationController pushViewController:searchGetVc animated:YES];
    }
}

- (void)liveMoreButtonCilck {
    ZhiBoBigRoomViewController *zhiboBigRoomVc = [[ZhiBoBigRoomViewController alloc] init];
    [self.navigationController pushViewController:zhiboBigRoomVc animated:YES];
    
    
    
//    VideoMarqueeViewController *vc = [[VideoMarqueeViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
//    vc.ID = [dict stringValueForKey:@"id"];
//    vc.title = [dict stringValueForKey:@"video_title"];
//    vc.price = [dict stringValueForKey:@"price"];
//    vc.imageUrl = [dict stringValueForKey:@"imageurl"];
//    vc.videoUrl = [dict stringValueForKey:@"video_address"];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)liveButtonClick:(UIButton *)button {
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    NSLog(@"%ld",button.tag);
    NSInteger Tag = button.tag;
    NSString *Cid = nil;
    Cid = [[_liveArray objectAtIndex:Tag] stringValueForKey:@"id"];
    NSString *Price = [[_liveArray objectAtIndex:Tag] stringValueForKey:@"t_price"];
    NSString *Title = [[_liveArray objectAtIndex:Tag] stringValueForKey:@"video_title"];
    NSString *ImageUrl = [[_liveArray objectAtIndex:Tag] stringValueForKey:@"imageurl"];
    
    ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)Tag andprice:Price];
    zhiBoMainVc.order_switch = _order_switch;
    [self.navigationController pushViewController:zhiBoMainVc animated:YES];
    
}

- (void)forViewMoreButtonClick:(UITapGestureRecognizer *)button {
    
    if (button.view.tag == 300) {
        OfflineMainViewController *vc = [[OfflineMainViewController alloc] init];
        vc.orderSwitch = _order_switch;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (button.view.tag == 400) {//名师推荐
        Good_TeacherMainViewController *vc = [[Good_TeacherMainViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (button.view.tag == 500) {//机构推荐
        Good_InstitutionMainViewController *homeInStVc = [[Good_InstitutionMainViewController alloc] init];
        [self.navigationController pushViewController:homeInStVc animated:YES];
    } else if (button.view.tag == 0) {//机构推荐
        ZhiBoBigRoomViewController *zhiboBigRoomVc = [[ZhiBoBigRoomViewController alloc] init];
        [self.navigationController pushViewController:zhiboBigRoomVc animated:YES];
    } else {
        [self inGetSearchWithClass:button];
    }
}

- (void)inGetSearchWithClass:(UITapGestureRecognizer *)button {
    ClassSearchGoodViewController *getSearchVc = [[ClassSearchGoodViewController alloc] init];
    getSearchVc.typeStr = @"1";
    if (button.view.tag == 100) {
        getSearchVc.screeningStr = @"best";
    }
    [self.navigationController pushViewController:getSearchVc animated:YES];
}

#pragma mark --- 手势

//精选课程的手势
- (void)chooseViewClick:(UIGestureRecognizer *)not {
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    NSInteger temp = not.view.tag;
    NSDictionary *dict = [_choicenessArray objectAtIndex:temp];
    if ([[dict stringValueForKey:@"type"] integerValue] == 1) {//点播
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = [dict stringValueForKey:@"id"];
        vc.videoTitle = [dict stringValueForKey:@"video_title"];
        vc.price = [dict stringValueForKey:@"price"];
        vc.imageUrl = [dict stringValueForKey:@"cover"];
        vc.videoUrl = [dict stringValueForKey:@"video_address"];
        vc.orderSwitch = _order_switch;
        vc.isClassNew = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 6) {//班级
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = [dict stringValueForKey:@"id"];
        vc.videoTitle = [dict stringValueForKey:@"video_title"];
        vc.price = [dict stringValueForKey:@"price"];
        vc.imageUrl = [dict stringValueForKey:@"cover"];
        vc.videoUrl = [dict stringValueForKey:@"video_address"];
        vc.orderSwitch = _order_switch;
        vc.isClassNew = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {//直播
        NSString *Cid = nil;
        Cid = [dict stringValueForKey:@"id"];
        NSString *Price = [dict stringValueForKey:@"price"];
        NSString *Title = [dict stringValueForKey:@"video_title"];
        NSString *ImageUrl = [dict stringValueForKey:@"cover"];

        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)temp andprice:Price];
        zhiBoMainVc.order_switch = _order_switch;
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
    }
}

- (void)newsViewClick:(UIGestureRecognizer *)not {
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    NSInteger temp = not.view.tag;
    NSDictionary *dict = [_newsArray objectAtIndex:temp];
    
    if ([[dict stringValueForKey:@"type"] integerValue] == 1) {//点播
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = [dict stringValueForKey:@"id"];
        vc.videoTitle = [dict stringValueForKey:@"video_title"];
        vc.price = [dict stringValueForKey:@"price"];
        vc.imageUrl = [dict stringValueForKey:@"cover"];
        vc.videoUrl = [dict stringValueForKey:@"video_address"];
        vc.orderSwitch = _order_switch;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 6) {//班级
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = [dict stringValueForKey:@"id"];
        vc.videoTitle = [dict stringValueForKey:@"video_title"];
        vc.price = [dict stringValueForKey:@"price"];
        vc.imageUrl = [dict stringValueForKey:@"cover"];
        vc.videoUrl = [dict stringValueForKey:@"video_address"];
        vc.orderSwitch = _order_switch;
        vc.isClassNew = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {//直播
        NSString *Cid = nil;
        Cid = [dict stringValueForKey:@"id"];
        NSString *Price = [dict stringValueForKey:@"price"];
        NSString *Title = [dict stringValueForKey:@"video_title"];
        NSString *ImageUrl = [dict stringValueForKey:@"cover"];
        
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)temp andprice:Price];
        zhiBoMainVc.order_switch = _order_switch;
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
    }
}

- (void)lineClassViewClick:(UIGestureRecognizer *)not {
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    NSInteger temp = not.view.tag;
    NSDictionary *dict = [_lineClassArray objectAtIndex:temp];
    
    OfflineDetailViewController *vc = [[OfflineDetailViewController alloc] init];
    vc.ID = [dict stringValueForKey:@"course_id"];
    vc.imageUrl = [dict stringValueForKey:@"cover"];
    vc.titleStr = [dict stringValueForKey:@"course_name"];
    vc.orderSwitch = _order_switch;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)teacherViewClick:(UIGestureRecognizer *)not {
    NSInteger temp = not.view.tag;
    NSString *ID = [[_teacherArray objectAtIndex:temp] stringValueForKey:@"id"];
    TeacherMainViewController *teacherMainVc = [[TeacherMainViewController alloc] initWithNumID:ID];
    [self.navigationController pushViewController:teacherMainVc animated:YES];
}

- (void)schoolViewClick:(UIGestureRecognizer *)not {
    NSInteger temp = not.view.tag;
    InstitutionMainViewController *institutionMainVc = [[InstitutionMainViewController alloc] init];
    institutionMainVc.schoolID = [[_schoolArray objectAtIndex:temp] stringValueForKey:@"id"];
//    institutionMainVc.uID = [[_schoolArray objectAtIndex:temp] stringValueForKey:@"uid"];
//    institutionMainVc.address = [[_schoolArray objectAtIndex:temp] stringValueForKey:@"location"];
    [self.navigationController pushViewController:institutionMainVc animated:YES];
}

#pragma mark --- 网络请求

//获取首页的广告图
- (void)netWorkHomeAdvert {
    
    NSString *endUrlStr = YunKeTang_App_Home_home_advert;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"app_home" forKey:@"place"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    
    NSLog(@"----%@",NetKey);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _imageDataArray = (NSArray *)[dict arrayValueForKey:@"data"];
            } else {
                _imageDataArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }

            [_bannerurlArray removeAllObjects];
            [_imageArray removeAllObjects];
            [_titleArray removeAllObjects];
            for (int i = 0; i < _imageDataArray.count; i ++) {
                NSString * imageName = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"banner"];
                NSURL *url = [NSURL URLWithString:imageName];
                
                NSString *bannerurl = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"bannerurl"];
                [_bannerurlArray addObject:bannerurl];
                if (_imageArray.count == _imageDataArray.count) {//已经可以了
                    
                } else {
                    [self.imageArray addObject:url];
                }
                
                NSString *banner_title = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"banner_title"];
//                [_titleArray addObject:banner_title];
            }
            if (_imageArray.count == _imageDataArray.count) {
                [self addImageScrollView];
            }
            [self netWorkHomeCate];
        } else {
            [self netWorkHomeCate];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [self netWorkHomeCate];
    }];
    [op start];
}

//获取首页的分类
- (void)netWorkHomeCate {
    
    NSString *endUrlStr = YunKeTang_App_Home_home_cate;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
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
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _cateArray = [dict arrayValueForKey:@"data"];
            } else {
                _cateArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        [self addCateScrollView];
        [self netWorkHomeLive];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取首页直播的数据
- (void)netWorkHomeLive {
    
    NSString *endUrlStr = YunKeTang_App_Home_home_live;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                dict = [dict dictionaryValueForKey:@"data"];
            } else {
                dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        
        _liveTimeArray = [dict arrayValueForKey:@"live_ctime"];
        _liveArray = [dict arrayValueForKey:@"live_list"];
        [self addLiveScrollView];
        _tableView.tableHeaderView = _tableViewHeaderView;
        [self netWorkHomeHotVideo];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//首页精选课程的数据
- (void)netWorkHomeHotVideo {
    
    NSString *endUrlStr = YunKeTang_App_Home_home_hotVideo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _choicenessArray = [dict arrayValueForKey:@"data"];
            } else {
                _choicenessArray = (NSArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        [_tableView reloadData];
        [self netWorkHomeNewVideo];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//首页最新课程的数据
- (void)netWorkHomeNewVideo {
    
    NSString *endUrlStr = YunKeTang_App_Home_home_newVideo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                 _newsArray = [dict arrayValueForKey:@"data"];
            } else {
                 _newsArray = (NSArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        [_tableView reloadData];
        [self netWorkHomeLineVideo];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//首页预约课程
- (void)netWorkHomeLineVideo {
    
    NSString *endUrlStr = YunKeTang_App_Home_home_lineVideo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"4" forKey:@"count"];
//    [mutabDict setObject:@"new" forKey:@"orderBy"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                 _lineClassArray = (NSArray *)[dict arrayValueForKey:@"data"];
            } else {
                 _lineClassArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        [_tableView reloadData];
        [self netWorkHomeTeacher];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//首页推荐教师的数据
- (void)netWorkHomeTeacher {
    
    NSString *endUrlStr = YunKeTang_App_Home_home_teacher;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _teacherArray = (NSArray *)[dict arrayValueForKey:@"data"];
            } else {
                _teacherArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        [_tableView reloadData];
        [self netWorkHomeSchool];
        [self netWorkConfigGetMarketStatus];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//首页推荐机构的数据
- (void)netWorkHomeSchool {
    
    NSString *endUrlStr = YunKeTang_App_Home_home_school;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _schoolArray = [dict arrayValueForKey:@"data"];
            } else {
                _schoolArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        [_tableView reloadData];
        //        [self netWorkHomeIndexNewCourse];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//获取营销数据
- (void)netWorkConfigGetMarketStatus {
    
    NSString *endUrlStr = YunKeTang_config_getMarketStatus;
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _order_switch = [dict stringValueForKey:@"order_switch"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

// MARK: - 首页新接口 一并返回所有数据
- (void)getHomeAllData {
    NSString *endUrlStr = YunKeTang_App_Home_allData;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"edulineHomeData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject];
        if (SWNOTEmptyDictionary(dict)) {
            // 广告位
            _imageDataArray = (NSArray *)[dict objectForKey:@"home_ad"];
            [_bannerurlArray removeAllObjects];
            [_imageArray removeAllObjects];
            [_titleArray removeAllObjects];
            for (int i = 0; i < _imageDataArray.count; i ++) {
                NSString * imageName = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"banner"];
                NSURL *url = [NSURL URLWithString:imageName];
                
                NSString *bannerurl = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"bannerurl"];
                [_bannerurlArray addObject:bannerurl];
                if (_imageArray.count == _imageDataArray.count) {//已经可以了
                    
                } else {
                    [self.imageArray addObject:url];
                }
                
                NSString *banner_title = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"banner_title"];
//                [_titleArray addObject:banner_title];
            }
            if (_imageArray.count == _imageDataArray.count) {
                [self addImageScrollView];
            }
            // 首页分类
            _cateArray = (NSArray *)[dict arrayValueForKey:@"re_cate"];
            [self addCateScrollView];
            // 精选课程
            _choicenessArray = (NSArray *)[dict arrayValueForKey:@"best_video"];
            // 最新课程
            _newsArray = (NSArray *)[dict arrayValueForKey:@"new_video"];
            // 预约课程
            _lineClassArray = (NSArray *)[dict arrayValueForKey:@"lineclass"];
            // 名师推荐
            _teacherArray = (NSArray *)[dict arrayValueForKey:@"teacher"];
            // 机构推荐
            _schoolArray = (NSArray *)[dict arrayValueForKey:@"school"];
            // 直播
            if (SWNOTEmptyDictionary([dict objectForKey:@"live"])) {
                _liveArray = (NSArray *)[[dict objectForKey:@"live"] arrayValueForKey:@"live_list"];
                _liveTimeArray = (NSArray *)[[dict objectForKey:@"live"] arrayValueForKey:@"live_ctime"];
//                [self addLiveScrollView];
            }
            _tableView.tableHeaderView = _tableViewHeaderView;
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)reloadHomeData {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"edulineHomeData"] != nil) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:[[NSUserDefaults standardUserDefaults] objectForKey:@"edulineHomeData"]];
        if (SWNOTEmptyDictionary(dict)) {
            // 广告位
            _imageDataArray = (NSArray *)[dict objectForKey:@"home_ad"];
            [_bannerurlArray removeAllObjects];
            [_imageArray removeAllObjects];
            [_titleArray removeAllObjects];
            for (int i = 0; i < _imageDataArray.count; i ++) {
                NSString * imageName = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"banner"];
                NSURL *url = [NSURL URLWithString:imageName];
                
                NSString *bannerurl = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"bannerurl"];
                [_bannerurlArray addObject:bannerurl];
                if (_imageArray.count == _imageDataArray.count) {//已经可以了
                    
                } else {
                    [self.imageArray addObject:url];
                }
                
                NSString *banner_title = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"banner_title"];
//                [_titleArray addObject:banner_title];
            }
            if (_imageArray.count == _imageDataArray.count) {
                [self addImageScrollView];
            }
            // 首页分类
            _cateArray = (NSArray *)[dict arrayValueForKey:@"re_cate"];
            [self addCateScrollView];
            // 精选课程
            _choicenessArray = (NSArray *)[dict arrayValueForKey:@"best_video"];
            // 最新课程
            _newsArray = (NSArray *)[dict arrayValueForKey:@"new_video"];
            // 预约课程
            _lineClassArray = (NSArray *)[dict arrayValueForKey:@"lineclass"];
            // 名师推荐
            _teacherArray = (NSArray *)[dict arrayValueForKey:@"teacher"];
            // 机构推荐
            _schoolArray = (NSArray *)[dict arrayValueForKey:@"school"];
            // 直播
            if (SWNOTEmptyDictionary([dict objectForKey:@"live"])) {
                _liveArray = (NSArray *)[[dict objectForKey:@"live"] arrayValueForKey:@"live_list"];
                _liveTimeArray = (NSArray *)[[dict objectForKey:@"live"] arrayValueForKey:@"live_ctime"];
//                [self addLiveScrollView];
            }
            _tableView.tableHeaderView = _tableViewHeaderView;
            [_tableView reloadData];
        }
    }
}

- (void)getPayMethodConfig {
    NSString *endUrlStr = YunKeTang_Goods_goods_credpayConf;
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
            NSArray *payMethod = [[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject] arrayValueForKey:@"pay_type"];
            if ([payMethod containsObject:@"alipay"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"hasAlipay"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"hasAlipay"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)netWorkGoodsCredpayConf {
    NSString *endUrlStr = YunKeTang_User_user_balanceConfig;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1"forKey:@"tab"];
    [mutabDict setObject:@"50"forKey:@"limit"];
    
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
        
        NSArray *payMethod = [[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject] arrayValueForKey:@"pay"];
        if ([payMethod containsObject:@"alipay"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"hasAlipay"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

@end
