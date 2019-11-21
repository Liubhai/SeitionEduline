//
//  ShoppingViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/8.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ShoppingViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "SDCycleScrollView.h"
#import "BigWindCar.h"

#import "ShopDetailViewController.h"
#import "AdViewController.h"
#import "ShopDetailMainViewController.h"

#import "WebViewController.h"
#import "ClassSearchGoodViewController.h"
#import "ZhiBoMainViewController.h"
#import "Good_ClassMainViewController.h"
#import "Good_InstitutionMainViewController.h"
#import "InstitutionMainViewController.h"
#import "Good_TeacherMainViewController.h"
#import "TeacherMainViewController.h"
#import "ShoppingViewController.h"
#import "NewsMainViewController.h"
#import "ZXDTViewController.h"
#import "DLViewController.h"


@interface ShoppingViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate> {
    CGFloat cellW;
    CGFloat cellH;
    CGFloat buttonXUp;
    CGFloat buttonXMight;
    CGFloat buttonXDown;
    
    CGFloat allButtonXUp;
    CGFloat allButtonXMight;
    CGFloat allButtonXDown;
    
    NSString *upTypeStr;
    NSString *mightTypeStr;
    NSString *downTypeStr;
    
    BOOL oneTitle;
    BOOL twoTitle;
    BOOL thereTitle;
    NSInteger Number;
    CGFloat cellHWithOutData;//当数据为空的时候cell返回的高度
    
    CGFloat percentage;
    NSString *categoryId;

}

@property (strong ,nonatomic)UITableView    *tableView;
@property (strong ,nonatomic)UIView         *tableHeaderView;
@property (strong ,nonatomic)UIView         *headerView;
@property (strong ,nonatomic)UIScrollView   *imageScrollView;
@property (strong ,nonatomic)NSMutableArray *bannerurlArray;
@property (strong ,nonatomic)NSMutableArray *titleArray;
@property (strong ,nonatomic)UIScrollView   *rankScrollView;
@property (strong, nonatomic) UIView *liveHeaderView;
@property (strong ,nonatomic)UIView         *exchangeView;
@property (strong ,nonatomic)UIScrollView   *exchangViewUp;
@property (strong ,nonatomic)UIScrollView   *exchangViewMight;
@property (strong ,nonatomic)UIScrollView   *exchangViewDown;
@property (strong ,nonatomic)UIButton       *exchangButtonUp;
@property (strong ,nonatomic)UIButton       *exchangButtonMight;
@property (strong ,nonatomic)UIButton       *exchangButtonDown;
@property (strong ,nonatomic)SYGTextField   *searchTextField;
@property (strong ,nonatomic)UIButton       *mightSeleButton;
@property (strong ,nonatomic)UIButton       *downSeleButton;

@property (strong ,nonatomic)NSArray        *imageDataArray;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *imageArray;
@property (strong ,nonatomic)NSArray        *rankArray;
@property (strong ,nonatomic)NSMutableArray *exchangArray;
@property (strong ,nonatomic)NSMutableArray *exchangUpArray;
@property (strong ,nonatomic)NSMutableArray *exchangUpButtonsArray;//装上面的按钮
@property (strong ,nonatomic)NSMutableArray *exchangMightButtonsArray;//装中面的按钮
@property (strong ,nonatomic)NSMutableArray *exchangDownButtonsArray;//装下面的按钮
@property (strong ,nonatomic)NSMutableArray *exchangMightArray;
@property (strong ,nonatomic)NSMutableArray *exchangDownArray;

@property (strong ,nonatomic)NSDictionary   *dataSource;
@property (strong ,nonatomic)NSString       *searchGoodName;//搜索的名字
@property (strong ,nonatomic)NSString       *scoreStaus;
@property (strong, nonatomic)NSArray        *payTypeArray;

@end

@implementation ShoppingViewController

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
    categoryId = @"0";
    _imageDataArray = [NSArray new];
    [self interFace];
    [self addNav];
//    [self addTableHeaderView];
//    [self addTableView];
//    [self netWorkGetGoodsBanner];
    [self netWorkGoodsAdvert];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    
    //计算每个cell的尺寸
    cellW = (MainScreenWidth - 3 * SpaceBaside) / 2;
    cellH = cellW + 55;
    
    buttonXUp = 0;
    buttonXMight = 0;
    buttonXDown = 0;
    
    allButtonXUp = 0;
    allButtonXMight = 0;
    allButtonXDown = 0;
    cellHWithOutData = 0;
    
    upTypeStr = @"0";
    mightTypeStr = @"0";
    downTypeStr = @"0",
    
    oneTitle = YES;
    twoTitle = NO;
    thereTitle = NO;
    Number = 1;
    
    _dataArray = [[NSMutableArray array] init];
    _exchangArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    _bannerurlArray = [NSMutableArray array];
    _titleArray = [NSMutableArray array];
    _exchangUpButtonsArray = [NSMutableArray array];
    _exchangMightButtonsArray = [NSMutableArray array];
    _exchangDownButtonsArray = [NSMutableArray array];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"商城";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineLab.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- TableView


- (void)addTableHeaderView {
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 500)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableHeaderView];
    }
    
    [self addTextFieldView];
    [self addImageScrollView];
    [self addRankView];
//    [self addExchangeView];
}

- (void)addTextFieldView {
    //添加搜索
    //    //添加搜索
    if (_searchTextField == nil) {
        SYGTextField *searchText = [[SYGTextField alloc] initWithFrame:CGRectMake(10, 5, MainScreenWidth - 20, 40)];
        searchText.placeholder = @"搜索商品名称";
        searchText.font = Font(15);
        [searchText setValue:Font(16) forKeyPath:@"_placeholderLabel.font"];
        [searchText sygDrawPlaceholderInRect:CGRectMake(0, 10, 0, 0)];
        searchText.layer.borderWidth = 1;
        searchText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        searchText.backgroundColor = [UIColor groupTableViewBackgroundColor];
        searchText.layer.cornerRadius = 20;
        searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
        searchText.returnKeyType = UIReturnKeySearch;
        searchText.delegate = self;
        _searchTextField = searchText;
        
        searchText.leftView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 30, 30)];
        searchText.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
        [button setImage:Image(@"yunketang_search") forState:UIControlStateNormal];
        [searchText.leftView addSubview:button];
        [_tableHeaderView addSubview:searchText];
    }

}

- (void)addImageScrollView {
    //添加滚动
    
    if (_imageScrollView == nil) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth, 200)];
        _imageScrollView.backgroundColor = [UIColor whiteColor];
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.contentSize = CGSizeMake(MainScreenWidth * 3, 200);
        [_tableHeaderView addSubview:_imageScrollView];
    } else {
        [_imageScrollView removeAllSubviews];
    }
    _imageScrollView.frame = CGRectMake(0, 50, MainScreenWidth, 200);
    NSLog(@"%@",_imageArray);
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenWidth, 200*MainScreenWidth/375) delegate:self placeholderImage:[UIImage imageNamed:@"站位图"]];
    if (iPhone5o5Co5S) {
        cycleScrollView3.frame = CGRectMake(0, 0, MainScreenWidth, 230 * MainScreenWidth / 357);
    } else if (iPhone6) {
        cycleScrollView3.frame = CGRectMake(0, 0, MainScreenWidth, 190 * MainScreenWidth / 357);
    } else if (iPhone6Plus) {
        cycleScrollView3.frame = CGRectMake(0, 0, MainScreenWidth, 180 * MainScreenWidth / 357);
    }
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = _imageArray;
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.delegate = self;
    [_imageScrollView addSubview:cycleScrollView3];
}

- (void)addRankView {
    CGFloat ButtonW = (MainScreenWidth - 4 * SpaceBaside / 2 ) / 3.5;
    CGFloat ButtonH = ButtonW;
    if (_liveHeaderView == nil) {
        _liveHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame) + 10, MainScreenWidth, ButtonH + 70)];
        _liveHeaderView.backgroundColor = RGBHex(0xF7F7F7);
        [_tableHeaderView addSubview:_liveHeaderView];
        _liveHeaderView.userInteractionEnabled = YES;
        
        //标题
        UILabel *liveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, ButtonH + 70)];
        liveLabel.text = @"排\n行\n榜";
        liveLabel.font = Font(22);
        liveLabel.numberOfLines = 0;
        [_liveHeaderView addSubview:liveLabel];
        liveLabel.userInteractionEnabled = YES;
        liveLabel.textAlignment = NSTextAlignmentCenter;
    }
    _liveHeaderView.frame = CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame) + 10, MainScreenWidth, ButtonH + 70);
    
    if (_rankScrollView == nil) {
        _rankScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(45, 0, MainScreenWidth - 45 , ButtonH + 70)];
        _rankScrollView.backgroundColor = RGBHex(0xF7F7F7);
        _rankScrollView.showsHorizontalScrollIndicator = NO;
        _rankScrollView.showsVerticalScrollIndicator = NO;
        _rankScrollView.userInteractionEnabled = YES;
        [_liveHeaderView addSubview:_rankScrollView];
    } else {
        [_rankScrollView removeAllSubviews];
    }
    
    NSInteger Num = _rankArray.count;
    
    _rankScrollView.frame = CGRectMake(45, 0, MainScreenWidth - 45, ButtonH + 70);
    
    //添加兑换课程课程
    for (int i = 0 ; i < Num; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside / 2 + i * (ButtonW + SpaceBaside / 2),SpaceBaside / 2, ButtonW, ButtonH)];
        NSString *urlStr = [[_rankArray objectAtIndex:i] stringValueForKey:@"cover"];;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        [_rankScrollView addSubview:button];
        button.tag = [[[_rankArray objectAtIndex:i] stringValueForKey:@"goods_id"] integerValue];
        button.tag = i;
        button.backgroundColor = [UIColor redColor];
        button.userInteractionEnabled = YES;
        [button addTarget:self action:@selector(rankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *sectionsArray = [[_rankArray objectAtIndex:i] arrayValueForKey:@"sections"];
        

        UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside / 2 +  i * (ButtonW + SpaceBaside / 2), ButtonH + SpaceBaside / 2, ButtonW, 60)];
        textView.backgroundColor = [UIColor whiteColor];
        [_rankScrollView addSubview:textView];
        
        //添加介绍
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside / 2,0, ButtonW - SpaceBaside, 30)];
        if (sectionsArray.count) {
            label.text = [[_rankArray objectAtIndex:i] stringValueForKey:@"title"];
        }
        label.text = [NSString stringWithFormat:@"%@",[[_rankArray objectAtIndex:i] stringValueForKey:@"title"]];
        label.font = Font(14);
        label.numberOfLines = 1;
        label.backgroundColor = [UIColor whiteColor];
        [textView addSubview:label];


        
        //添加名字
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside / 2, 30, ButtonW / 2 - SpaceBaside, 30)];
        name.text = [NSString stringWithFormat:@"库存%@",[[_rankArray objectAtIndex:i] stringValueForKey:@"stock"]];
        name.font = Font(11);
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor grayColor];
        name.backgroundColor = [UIColor whiteColor];
        [textView addSubview:name];
//
        //添加人数报名
        UILabel *person = [[UILabel alloc] initWithFrame:CGRectMake( ButtonW / 2, 30, ButtonW / 2 - SpaceBaside / 2, 30)];
        NSString *text1 = @" ";
        NSString *textStr = [NSString stringWithFormat:@"%@积分 %@",[[_rankArray objectAtIndex:i] stringValueForKey:@"price"],text1];
        if ([_scoreStaus integerValue] == 0) {
             textStr = [NSString stringWithFormat:@"育币%.2f",[[[_rankArray objectAtIndex:i] stringValueForKey:@"price"] floatValue]  * percentage];
        }
        person.text = textStr;
        person.font = Font(11);
        person.textAlignment = NSTextAlignmentRight;
        person.textColor = [UIColor redColor];
        person.backgroundColor = [UIColor whiteColor];
        [textView addSubview:person];
        
        //添加透明的按钮
        UIButton *liveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_rankScrollView.frame), CGRectGetHeight(_rankScrollView.frame))];
        liveButton.backgroundColor = [UIColor clearColor];
        [liveButton addTarget:self action:@selector(rankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        liveButton.tag = [_rankArray[i][@"goods_id"] integerValue];
        liveButton.tag = [[[_rankArray objectAtIndex:i] stringValueForKey:@"goods_id"] integerValue];
        liveButton.enabled = YES;
        [_rankScrollView addSubview:liveButton];
        liveButton.hidden = YES;
        
    }
    
    
    //设置滚动的范围
    _rankScrollView.contentSize = CGSizeMake(Num * ButtonW + (Num + 1) * (SpaceBaside / 2), 0);
    //直播数据为空的时候 就隐藏
    if (_rankArray.count == 0) {
        _liveHeaderView.frame = CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame), MainScreenWidth, 0);
        _rankScrollView.frame = CGRectMake(45, 0, MainScreenWidth, 0);
        _liveHeaderView.hidden = YES;
        _rankScrollView.hidden = YES;
    }
    
    _tableHeaderView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_liveHeaderView.frame));
}

- (void)addExchangeView {
    _exchangeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200 - 30)];
    if (twoTitle) {
        if (thereTitle) {
            _exchangeView.frame = CGRectMake(0, 0, MainScreenWidth, 150 - 30 + 22);
        } else {
            _exchangeView.frame = CGRectMake(0, 0, MainScreenWidth, 110 - 30 + 22);
        }
    } else {
        _exchangeView.frame = CGRectMake(0, 0, MainScreenWidth, 70 - 30 + 22);
    }
    [_headerView addSubview:_exchangeView];
    [_headerView setHeight:_exchangeView.height];
    
    //添加品质交换
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 62, 62)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"品质\n兑换";
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = BlackNotColor;
    label.font = SYSTEMFONT(22);
    [_exchangeView addSubview:label];
    
    [self addExchangViewUp];
    if (twoTitle) {
        NSInteger tag = [upTypeStr integerValue];
        _exchangMightArray = (NSMutableArray *)[[_exchangArray objectAtIndex:tag] arrayValueForKey:@"childs"];
        [self addExchangViewMightWithArray];
    }
    if (thereTitle) {
        NSInteger tag = [mightTypeStr integerValue];
        _exchangDownArray = (NSMutableArray *)[[_exchangMightArray objectAtIndex:tag] arrayValueForKey:@"childs"];
        [self addExchangViewDownWithArray];
    }
}

- (void)addExchangViewUp {
    
    _exchangViewUp = [[UIScrollView alloc] initWithFrame:CGRectMake(62, 0, MainScreenWidth - 62, 62)];
    _exchangViewUp.backgroundColor = [UIColor whiteColor];
    [_exchangeView addSubview:_exchangViewUp];

    _exchangViewUp.bounces = YES;
    _exchangViewUp.scrollEnabled = YES;
    _exchangViewUp.delegate = self;
    _exchangViewUp.showsHorizontalScrollIndicator = NO;
    _exchangViewUp.showsVerticalScrollIndicator = NO;
    _exchangViewUp.alwaysBounceVertical = NO;
    _exchangViewUp.pagingEnabled = NO;
    //同时单方向滚动
    _exchangViewUp.directionalLockEnabled = YES;
    _exchangViewUp.contentOffset = CGPointMake(0, 0);
    
    NSMutableArray *marr = [NSMutableArray array];
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    
    buttonXUp = 0;
    allButtonXUp = 0;
    for (int i = 0; i < _exchangArray.count ; i ++) {
        _exchangButtonUp = [[UIButton alloc] init];
        _exchangButtonUp.frame = CGRectMake(buttonXUp, 0, (MainScreenWidth - 62) / 5, 40);
        _exchangButtonUp.centerY = _exchangViewUp.height/2.0;
        [_exchangButtonUp setTitle:[[_exchangArray objectAtIndex:i] stringValueForKey:@"title"] forState:UIControlStateNormal];
        [_exchangViewUp addSubview:_exchangButtonUp];
        _exchangButtonUp.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_exchangButtonUp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_exchangButtonUp setTitleColor:BasidColor forState:UIControlStateSelected];
        _exchangButtonUp.tag = i;
        _exchangButtonUp.titleLabel.font = [UIFont systemFontOfSize:14];
        if (iPhone5o5Co5S) {
            _exchangButtonUp.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            _exchangButtonUp.titleLabel.font = [UIFont systemFontOfSize:12];
        } else if (iPhone6) {
            _exchangButtonUp.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            _exchangButtonUp.titleLabel.font = [UIFont systemFontOfSize:14];
        } else if (iPhone6Plus) {
            _exchangButtonUp.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            _exchangButtonUp.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        //按钮的自适应
        CGRect labelSize = [_exchangButtonUp.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
        if (labelSize.size.width < (MainScreenWidth - 62) / 5 ) {
            labelSize.size.width = (MainScreenWidth - 62) / 5;
        }
        
        if (_exchangArray.count <= 5) {
            CGFloat ButtonW = (MainScreenWidth - 62) / _exchangArray.count;
            _exchangButtonUp.frame = CGRectMake(ButtonW * i, 0, ButtonW, 40);
        } else {
            _exchangButtonUp.frame = CGRectMake(_exchangButtonUp.frame.origin.x, _exchangButtonUp.frame.origin.y,labelSize.size.width, 40);
            buttonXUp = labelSize.size.width + _exchangButtonUp.frame.origin.x;
            allButtonXUp = labelSize.size.width + _exchangButtonUp.frame.origin.x;
        }

        
        [_exchangButtonUp addTarget:self action:@selector(changeUp:) forControlEvents:UIControlEventTouchUpInside];
        if (i == [upTypeStr integerValue]) {
            [_exchangButtonUp setTitleColor:ffbbcolor forState:UIControlStateNormal];
        }
        [marr addObject:_exchangButtonUp];
    }
    
    _exchangUpButtonsArray = [marr copy];
    int tempNum;
    tempNum = (int)_dataArray.count;
    _exchangViewUp.contentSize = CGSizeMake(buttonXUp + 2, 40);
    for (int i = 0; i<_exchangUpButtonsArray.count; i++) {
        if (((UIButton *)_exchangUpButtonsArray[i]).tag == [upTypeStr integerValue]) {
            if ((((UIButton *)_exchangUpButtonsArray[i]).left + (MainScreenWidth - 62)) > _exchangViewUp.contentSize.width) {
                _exchangViewUp.contentOffset = CGPointMake(_exchangViewUp.contentSize.width - (MainScreenWidth - 62), 0);
            } else {
                _exchangViewUp.contentOffset = CGPointMake(((UIButton *)_exchangUpButtonsArray[i]).left, 0);
            }
            break;
        }
    }
    
}

- (void)addExchangViewMight {
    _exchangViewMight = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_exchangViewUp.frame), MainScreenWidth, 40)];
    UIColor *ffbbcolor = [UIColor colorWithRed:246.f / 255 green:246.f / 255 blue:246.f / 255 alpha:1];
    _exchangViewMight.backgroundColor = ffbbcolor;
    [_exchangeView addSubview:_exchangViewMight];
    
    _exchangViewMight.bounces = YES;
    _exchangViewMight.scrollEnabled = YES;
    _exchangViewMight.delegate = self;
    _exchangViewMight.showsHorizontalScrollIndicator = NO;
    _exchangViewMight.showsVerticalScrollIndicator = NO;
    _exchangViewMight.alwaysBounceVertical = NO;
    _exchangViewMight.pagingEnabled = NO;
    //同时单方向滚动
    _exchangViewMight.directionalLockEnabled = YES;
    _exchangViewMight.contentOffset = CGPointMake(0, 0);
    
}

//根据数组不同进行
- (void)addExchangViewMightWithArray {
    
    _exchangViewMight = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_exchangViewUp.frame), MainScreenWidth, 40)];
    UIColor *ffbbcolor = [UIColor colorWithRed:246.f / 255 green:246.f / 255 blue:246.f / 255 alpha:1];
    _exchangViewMight.backgroundColor = ffbbcolor;
    [_exchangeView addSubview:_exchangViewMight];
    
    _exchangViewMight.bounces = YES;
    _exchangViewMight.scrollEnabled = YES;
    _exchangViewMight.delegate = self;
    _exchangViewMight.showsHorizontalScrollIndicator = NO;
    _exchangViewMight.showsVerticalScrollIndicator = NO;
    _exchangViewMight.alwaysBounceVertical = NO;
    _exchangViewMight.pagingEnabled = NO;
    //同时单方向滚动
    _exchangViewMight.directionalLockEnabled = YES;
    _exchangViewMight.contentOffset = CGPointMake(0, 0);

    
    NSMutableArray *marr = [NSMutableArray array];
    allButtonXMight = 0;
    buttonXMight = 0;
    NSArray *childArray = _exchangMightArray;
    for (int i = 0; i < childArray.count ; i ++) {
        _exchangButtonMight = [[UIButton alloc] init];
        _exchangButtonMight.frame = CGRectMake(buttonXMight, 0, MainScreenWidth / 5, 40);
        [_exchangButtonMight setTitle:[[childArray objectAtIndex:i] stringValueForKey:@"title"] forState:UIControlStateNormal];
        [_exchangViewMight addSubview:_exchangButtonMight];
        _exchangButtonMight.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_exchangButtonMight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _exchangButtonMight.tag = i;
        _exchangButtonMight.titleLabel.font = [UIFont systemFontOfSize:14];
        if (iPhone5o5Co5S) {
            _exchangButtonMight.titleLabel.font = [UIFont systemFontOfSize:12];
        } else if (iPhone6) {
            _exchangButtonMight.titleLabel.font = [UIFont systemFontOfSize:14];
        } else if (iPhone6Plus) {
            _exchangButtonMight.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        //按钮的自适应
        CGRect labelSize = [_exchangButtonMight.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
        if (labelSize.size.width < MainScreenWidth / 5 ) {
            labelSize.size.width = MainScreenWidth / 5;
        }
        
        if (childArray.count <= 5) {
            CGFloat ButtonW = MainScreenWidth / childArray.count;
            _exchangButtonMight.frame = CGRectMake(ButtonW * i, 0, ButtonW, 40);
        } else {
            _exchangButtonMight.frame = CGRectMake(_exchangButtonMight.frame.origin.x, _exchangButtonMight.frame.origin.y,labelSize.size.width, 40);
            buttonXMight = labelSize.size.width + _exchangButtonMight.frame.origin.x;
            allButtonXMight = labelSize.size.width + _exchangButtonMight.frame.origin.x;
        }
        
        
        [_exchangButtonMight addTarget:self action:@selector(changeMight:) forControlEvents:UIControlEventTouchUpInside];
        if (i == [mightTypeStr integerValue]) {
            [_exchangButtonMight setTitleColor:BasidColor forState:UIControlStateNormal];
        }
        [marr addObject:_exchangButtonMight];
    }
    
    _exchangMightButtonsArray = marr;

}

- (void)addExchangViewDown {
    _exchangViewDown = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_exchangViewMight.frame), MainScreenWidth, 40)];
    _exchangViewDown.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_exchangeView addSubview:_exchangViewDown];
    
    _exchangViewDown.bounces = YES;
    _exchangViewDown.scrollEnabled = YES;
    _exchangViewDown.delegate = self;
    _exchangViewDown.showsHorizontalScrollIndicator = NO;
    _exchangViewDown.showsVerticalScrollIndicator = NO;
    _exchangViewDown.alwaysBounceVertical = NO;
    _exchangViewDown.pagingEnabled = NO;
    //同时单方向滚动
    _exchangViewDown.directionalLockEnabled = YES;
    _exchangViewDown.contentOffset = CGPointMake(0, 0);
    
    NSMutableArray *marr = [NSMutableArray array];
    
    NSArray *childArray = [[[[_exchangArray objectAtIndex:0] arrayValueForKey:@"childs"] objectAtIndex:0] arrayValueForKey:@"childs"];
    buttonXDown = 0;
    allButtonXDown = 0;
    for (int i = 0; i < childArray.count ; i ++) {
        _exchangButtonDown = [[UIButton alloc] init];
        _exchangButtonDown.frame = CGRectMake(buttonXDown, SpaceBaside , MainScreenWidth / 5, 30);
        [_exchangButtonDown setTitle:[[childArray objectAtIndex:i] stringValueForKey:@"title"] forState:UIControlStateNormal];
        [_exchangViewDown addSubview:_exchangButtonDown];
        _exchangButtonDown.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_exchangButtonDown setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _exchangButtonDown.tag = i;
        _exchangButtonDown.titleLabel.font = [UIFont systemFontOfSize:14];
        _exchangButtonDown.backgroundColor = [UIColor whiteColor];
        _exchangButtonDown.layer.cornerRadius = 15;
        _exchangButtonDown.layer.masksToBounds = YES;
        
        if (iPhone5o5Co5S) {
            _exchangButtonDown.titleLabel.font = [UIFont systemFontOfSize:12];
        } else if (iPhone6) {
            _exchangButtonDown.titleLabel.font = [UIFont systemFontOfSize:14];
        } else if (iPhone6Plus) {
            _exchangButtonDown.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        //按钮的自适应
        CGRect labelSize = [_exchangButtonDown.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
        if (labelSize.size.width < MainScreenWidth / 5 ) {
            labelSize.size.width = MainScreenWidth / 5;
        }
        
        if (childArray.count <= 5) {
            CGFloat ButtonW = MainScreenWidth / childArray.count;
            _exchangButtonDown.frame = CGRectMake(ButtonW * i, 0, ButtonW, 30);
            
            CGFloat ButtonWW = (MainScreenWidth - 5 * SpaceBaside) / 4;
            _exchangButtonDown.frame = CGRectMake(ButtonWW * i + SpaceBaside * (i + 1), SpaceBaside , ButtonWW, 30);
        } else {
            _exchangButtonDown.frame = CGRectMake(_exchangButtonDown.frame.origin.x, _exchangButtonDown.frame.origin.y,labelSize.size.width, 30);
            buttonXDown = labelSize.size.width + _exchangButtonDown.frame.origin.x;
            allButtonXDown = labelSize.size.width + _exchangButtonDown.frame.origin.x;
        }
        
        
        [_exchangButtonDown addTarget:self action:@selector(changeDown:) forControlEvents:UIControlEventTouchUpInside];
        [marr addObject:_exchangButtonDown];
    }
    
    //默认值
    _exchangDownButtonsArray = [marr copy];
    _exchangDownArray = (NSMutableArray *)[[[[_exchangArray objectAtIndex:0] arrayValueForKey:@"childs"] objectAtIndex:0] arrayValueForKey:@"childs"];
    
    _exchangViewDown.contentSize = CGSizeMake(buttonXDown + 2, 40);
    
    _exchangeView.frame = CGRectMake(0, CGRectGetMaxY(_rankScrollView.frame) + SpaceBaside, MainScreenWidth, CGRectGetMaxY(_exchangViewDown.frame));
    _tableHeaderView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_exchangeView.frame));

}


//根据数组不同进行
- (void)addExchangViewDownWithArray {
    
    _exchangViewDown = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_exchangViewMight.frame), MainScreenWidth, 40)];
    _exchangViewDown.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_exchangeView addSubview:_exchangViewDown];
    
    _exchangViewDown.bounces = YES;
    _exchangViewDown.scrollEnabled = YES;
    _exchangViewDown.delegate = self;
    _exchangViewDown.showsHorizontalScrollIndicator = NO;
    _exchangViewDown.showsVerticalScrollIndicator = NO;
    _exchangViewDown.alwaysBounceVertical = NO;
    _exchangViewDown.pagingEnabled = NO;
    _exchangViewDown.userInteractionEnabled = YES;
    //同时单方向滚动
    _exchangViewDown.directionalLockEnabled = YES;
    _exchangViewDown.contentOffset = CGPointMake(0, 0);

    
    NSMutableArray *marr = [NSMutableArray array];
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    
    NSArray *childArray = _exchangDownArray;
    for (int i = 0; i < childArray.count ; i ++) {
        _exchangButtonDown = [[UIButton alloc] init];
        _exchangButtonDown.frame = CGRectMake(buttonXDown, SpaceBaside / 2, MainScreenWidth / 5, 30);
        [_exchangButtonDown setTitle:[[childArray objectAtIndex:i] stringValueForKey:@"title"] forState:UIControlStateNormal];
        [_exchangViewDown addSubview:_exchangButtonDown];
        _exchangButtonDown.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_exchangButtonDown setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_exchangButtonDown setTitleColor:BasidColor forState:UIControlStateSelected];
        _exchangButtonDown.tag = i;
        _exchangButtonDown.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _exchangButtonDown.backgroundColor = [UIColor whiteColor];
        _exchangButtonDown.layer.cornerRadius = 15;
        _exchangButtonDown.layer.masksToBounds = YES;
        _exchangButtonDown.enabled = YES;
        
        if (iPhone5o5Co5S) {
            _exchangButtonDown.titleLabel.font = [UIFont systemFontOfSize:12];
        } else if (iPhone6) {
            _exchangButtonDown.titleLabel.font = [UIFont systemFontOfSize:14];
        } else if (iPhone6Plus) {
            _exchangButtonDown.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        //按钮的自适应
        CGRect labelSize = [_exchangButtonDown.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
        if (labelSize.size.width < MainScreenWidth / 5 ) {
            labelSize.size.width = MainScreenWidth / 5;
        }
        
        if (childArray.count <= 5) {
            CGFloat ButtonW = MainScreenWidth / childArray.count;
            _exchangButtonDown.frame = CGRectMake(ButtonW * i + (SpaceBaside + 1) * i, SpaceBaside, ButtonW, 30);
            
            CGFloat ButtonWW = (MainScreenWidth - 5 * SpaceBaside) / 4;
            _exchangButtonDown.frame = CGRectMake(ButtonWW * i + SpaceBaside * (i + 1), SpaceBaside / 2 , ButtonWW, 30);
        } else {
            _exchangButtonDown.frame = CGRectMake(_exchangButtonDown.frame.origin.x, _exchangButtonDown.frame.origin.y,labelSize.size.width, 30);
            buttonXDown = labelSize.size.width + _exchangButtonDown.frame.origin.x;
            allButtonXDown = labelSize.size.width + _exchangButtonDown.frame.origin.x;
        }
        
        
        [_exchangButtonDown addTarget:self action:@selector(changeDown:) forControlEvents:UIControlEventTouchUpInside];
        if (i == [downTypeStr integerValue]) {
            [_exchangButtonDown setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _exchangButtonDown.backgroundColor = [UIColor colorWithRed:67.f / 255 green:78.f / 255 blue:87.f / 255 alpha:1];
        }
        [marr addObject:_exchangButtonDown];
    }
    _exchangDownButtonsArray = marr;
    
}



- (void)addTableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStylePlain];
        if (iPhoneX) {
            _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88);
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        _tableView.tableHeaderView = _tableHeaderView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
        _tableView.tableFooterView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, -10, 0);
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView addFooterWithTarget:self action:@selector(footMore)];
        
        //iOS 11 适配
        if (currentIOS >= 11.0) {
            Passport *ps = [[Passport alloc] init];
            [ps adapterOfIOS11With:_tableView];
        }
    } else {
        _tableView.tableHeaderView = _tableHeaderView;
    }
}

- (void)footMore {
    Number ++;
    [self netWorkGoodsGetList:Number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    });
}

#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (twoTitle) {//有两级以及两级以上分类
        if (thereTitle) {//
            return 150 - 30 + 22;
        } else {//只有两级分类的时候
            return 110 - 30 + 22;
        }
    } else {//只有一级分类
        return 70 - 30 + 22;
    }
    return 150 - 30 + 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 150)];
    headerView.backgroundColor = [UIColor whiteColor];
    _headerView = headerView;
    [self addExchangeView];
    return _headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger Count = _dataArray.count;
    NSLog(@"%ld",(long)Count);
    
    CGFloat titleViewH;
    if (twoTitle) {
        if (thereTitle) {
            titleViewH = 150;
        } else {
            titleViewH = 110;
        }
    } else {
        titleViewH = 70;
    }
    
    if (Count % 2 == 0) {
        
        if ((cellH + SpaceBaside) * (Count / 2) <= MainScreenHeight - 64 - titleViewH) {
            cellHWithOutData = MainScreenHeight - 64 - titleViewH;
            return MainScreenHeight - 64 - titleViewH;
        } else {
            return (cellH + SpaceBaside) * (Count / 2);
        }

    } else {
        
        if ((cellH + SpaceBaside) * (Count / 2 + 1) <= MainScreenHeight - 64 - titleViewH) {
            cellHWithOutData = MainScreenHeight - 64 - titleViewH;
            return MainScreenHeight - 64 - titleViewH;
        } else {
            return (cellH + SpaceBaside) * (Count / 2 + 1);
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSLog(@"all--%@",_dataArray);
    
    for (int i = 0; i < _dataArray.count ; i++) {
        
        NSLog(@"开始--%d",i);
        
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside + (i % 2) * (cellW + SpaceBaside), SpaceBaside + (i / 2) * (cellH + SpaceBaside), cellW, cellH)];
        cellView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:cellView];
        
        //添加图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH - 55)];
        NSString *urlStr = [[_dataArray objectAtIndex:i] stringValueForKey:@"cover" defaultValue:@""];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        [cellView addSubview:imageView];
        
        //添加名字
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(imageView.frame) + SpaceBaside / 2, cellW - 2 * SpaceBaside, 20)];
        name.text =  [[_dataArray objectAtIndex:i] stringValueForKey:@"title"];
        name.font = Font(14);
        name.backgroundColor = [UIColor whiteColor];
        [cellView addSubview:name];
        
        //添加库存
        UILabel *repertory = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(name.frame), cellW / 2 - SpaceBaside, 30)];
        repertory.text = [NSString stringWithFormat:@"库存%@",[[_dataArray objectAtIndex:i] stringValueForKey:@"stock"]];
        repertory.font = Font(12);
        repertory.textColor = [UIColor grayColor];
        [cellView addSubview:repertory];
        
        //添加积分
        UILabel *integral = [[UILabel alloc] initWithFrame:CGRectMake(cellW / 2, CGRectGetMaxY(name.frame), cellW / 2 - SpaceBaside, 30)];
        integral.text = [NSString stringWithFormat:@"%@积分",[[_dataArray objectAtIndex:i] stringValueForKey:@"price"]];
        if ([_scoreStaus integerValue] == 0) {
            integral.text = [NSString stringWithFormat:@"%.2f育币",[[[_dataArray objectAtIndex:i] stringValueForKey:@"price"] floatValue]  * percentage];
        }
        integral.font = Font(14);
        integral.textColor = [UIColor redColor];
        integral.textAlignment = NSTextAlignmentRight;
        [cellView addSubview:integral];
        
        UIButton *viewButton = [[UIButton alloc] initWithFrame:cellView.bounds];
        viewButton.backgroundColor = [UIColor clearColor];
//        viewButton.tag = [_dataArray[i][@"goods_id"] integerValue];
//        viewButton.tag = [[[_dataArray objectAtIndex:i] stringValueForKey:@"goods_id"] integerValue];
        viewButton.tag = i;
        [viewButton addTarget:self action:@selector(viewButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:viewButton];
        
    }
    
    if (_dataArray.count == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        imageView.image = Image(@"云课堂_空数据");
        [cell addSubview:imageView];
        if (iPhoneX) {
            imageView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 200);
        }
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
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
//                            zhiBoMainVc.order_switch = _order_switch;
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
//                            vc.orderSwitch = _order_switch;
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
                            return;
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


#pragma mark --- 事件点击
- (void)rankButtonClick:(UIButton *)button {
    
    ShopDetailMainViewController *vc = [[ShopDetailMainViewController alloc] init];
    vc.dict = [_rankArray objectAtIndex:button.tag];
    vc.scoreStaus = _scoreStaus;
    vc.percentage = percentage;
    vc.payTypeArray = _payTypeArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)indexButtonCilck:(UIButton *)button {
    NSString *ID = [NSString stringWithFormat:@"%ld",(long)button.tag];
    ShopDetailViewController *shopDetail = [[ShopDetailViewController alloc]initWithID:ID];
    shopDetail.percentage = percentage;
    shopDetail.scoreStaus = _scoreStaus;
    shopDetail.payTypeArray = _payTypeArray;
    [self.navigationController pushViewController:shopDetail animated:YES];
}

- (void)changeUp:(UIButton *)button {
    
    if ([button.titleLabel.text isEqualToString:@"全部"]) {
        oneTitle = YES;
        twoTitle = NO;
        thereTitle = NO;
        upTypeStr = @"0";
        
        for (int i = 0; i < _exchangUpButtonsArray.count; i++) {
            [_exchangUpButtonsArray[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [button setTitleColor:BasidColor forState:UIControlStateNormal];
        
//        NSString *ID = [NSString stringWithFormat:@"%@",_exchangArray[button.tag][@"goods_category_id"]];
        NSString *ID = [NSString stringWithFormat:@"%@",[[_exchangArray objectAtIndex:button.tag] stringValueForKey:@"goods_category_id"]];
        categoryId = ID;
        Number = 1;
        [_tableView reloadData];
        [self netWorkGoodsGetList:Number];
        return;
    }
    upTypeStr = [NSString stringWithFormat:@"%ld",(long)button.tag];
    mightTypeStr = @"0";
    
    for (int i = 0; i < _exchangUpButtonsArray.count; i++) {
        [_exchangUpButtonsArray[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    for (UIButton *btn in _exchangViewUp.subviews) {
        if (btn.tag == button.tag) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
    [button setTitleColor:BasidColor forState:UIControlStateNormal];
    
    
    //移除以前的视图
    [_exchangViewMight.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    _exchangMightArray = _exchangArray[button.tag][@"childs"];
    _exchangMightArray =(NSMutableArray *) [[_exchangArray objectAtIndex:button.tag] stringValueForKey:@"childs"];
    if (_exchangMightArray.count>0) {
        oneTitle = YES;
        twoTitle = YES;
        thereTitle = NO;
        NSString *ID = [NSString stringWithFormat:@"%@",[[_exchangArray objectAtIndex:button.tag] stringValueForKey:@"goods_category_id"]];
        categoryId = ID;
        Number = 1;
        [self addExchangViewMightWithArray];
        [_tableView reloadData];
        [self netWorkGoodsGetList:Number];
    } else {
        oneTitle = YES;
        twoTitle = NO;
        thereTitle = NO;
        NSString *ID = [NSString stringWithFormat:@"%@",[[_exchangArray objectAtIndex:button.tag] stringValueForKey:@"goods_category_id"]];
        categoryId = ID;
        Number = 1;
        [_tableView reloadData];
        [self netWorkGoodsGetList:Number];
        return;
    }
}
- (void)changeMight:(UIButton *)button {
    
    if ([button.titleLabel.text isEqualToString:@"全部"]) {
        oneTitle = YES;
        twoTitle = YES;
        thereTitle = NO;
        mightTypeStr = @"0";
        NSString *ID = [NSString stringWithFormat:@"%@",[[_exchangMightArray objectAtIndex:button.tag] stringValueForKey:@"goods_category_id"]];
        categoryId = ID;
        Number = 1;
        [_tableView reloadData];
        [self netWorkGoodsGetList:Number];
        return;
    }

    
    mightTypeStr = [NSString stringWithFormat:@"%ld",(long)button.tag];
    downTypeStr = @"0";
    
    
    for (int i = 0; i < _exchangMightButtonsArray.count; i++) {
        [_exchangMightButtonsArray[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:BasidColor forState:UIControlStateNormal];
    
    //移除以前的视图
    [_exchangViewDown.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _exchangDownArray = (NSMutableArray *)[[_exchangMightArray objectAtIndex:button.tag] arrayValueForKey:@"childs"];
    if (_exchangDownArray.count>0) {
        oneTitle = YES;
        twoTitle = YES;
        thereTitle = YES;
        NSString *ID = [NSString stringWithFormat:@"%@",[[_exchangMightArray objectAtIndex:button.tag] stringValueForKey:@"goods_category_id"]];
        categoryId = ID;
        Number = 1;
        [self addExchangViewDownWithArray];
        [_tableView reloadData];
        [self netWorkGoodsGetList:Number];
    } else {
        oneTitle = YES;
        twoTitle = YES;
        thereTitle = NO;
        NSString *ID = [NSString stringWithFormat:@"%@",[[_exchangMightArray objectAtIndex:button.tag] stringValueForKey:@"goods_category_id"]];
        categoryId = ID;
        Number = 1;
        [_tableView reloadData];
        [self netWorkGoodsGetList:Number];
        return;
    }
}
- (void)changeDown:(UIButton *)button {
    
    downTypeStr = [NSString stringWithFormat:@"%ld",(long)button.tag];
    for (int i = 0; i < _exchangDownButtonsArray.count; i++) {
        [_exchangDownButtonsArray[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIButton *everyButton = _exchangDownButtonsArray[i];
        everyButton.backgroundColor = [UIColor whiteColor];
    }
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:67.f / 255 green:78.f / 255 blue:87.f / 255 alpha:1];
    
    NSLog(@"%@",_exchangDownArray[button.tag]);
    NSString *ID = [[_exchangDownArray objectAtIndex:button.tag] stringValueForKey:@"goods_category_id"];
    categoryId = ID;
    Number = 1;
    [self netWorkGoodsGetList:Number];

}

- (void)viewButtonCilck:(UIButton *)button {
//    NSString *ID = [NSString stringWithFormat:@"%ld",(long)button.tag];
//    ShopDetailViewController *shopDetail = [[ShopDetailViewController alloc]initWithID:ID];
//    shopDetail.dict = [_dataArray objectAtIndex:button.tag];
//    shopDetail.scoreStaus = _scoreStaus;
//    shopDetail.percentage = percentage;
//    shopDetail.payTypeArray = _payTypeArray;
//    [self.navigationController pushViewController:shopDetail animated:YES];
    
    ShopDetailMainViewController *vc = [[ShopDetailMainViewController alloc] init];
    vc.dict = [_dataArray objectAtIndex:button.tag];
    vc.scoreStaus = _scoreStaus;
    vc.percentage = percentage;
    vc.payTypeArray = _payTypeArray;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark --- 键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"123");
    //点搜索按钮
    Number = 1;
    if (_searchTextField.text.length > 0) {
        [self netWorkGoodsGetHomeDataWithID:nil];
    }
    
    [textField becomeFirstResponder];
    [textField resignFirstResponder];
    if ([textField.text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
}


#pragma mark --- 网络请求

//获取banber图
- (void)netWorkGoodsAdvert {
    
    NSString *endUrlStr = YunKeTang_App_Home_home_advert;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"app_goods_banner" forKey:@"place"];
    
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
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _imageDataArray = (NSArray *)[dict arrayValueForKey:@"data"];
            } else {
                _imageDataArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            NSArray *array = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            for (int i = 0 ; i < array.count ; i ++) {
                NSString *urlStr = array[i][@"banner"];
                [_imageArray addObject:urlStr];
                
                NSString *bannerStr = array[i][@"bannerurl"];
                [_bannerurlArray addObject:bannerStr];
                
                NSString *banner_title = [[array objectAtIndex:i] stringValueForKey:@"banner_title"];
                [_titleArray addObject:banner_title];
                
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [self netWorkGoodsGetHomeDataWithID:nil];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//商城的数据源
- (void)netWorkGoodsGetHomeDataWithID:(NSString *)ID {
    NSString *endUrlStr = YunKeTang_Goods_goods_getHomeData;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"app_goods_banner" forKey:@"place"];
    if (ID == nil) {
    } else {
        [mutabDict setValue:ID forKey:@"goods_category"];
    }
    if (_searchTextField.text.length > 0 ) {
        [mutabDict setValue:_searchTextField.text forKey:@"keyword"];
    }
    
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
        
       _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        _rankArray = [_dataSource arrayValueForKey:@"rank"];
        [self netWorkGoodsGetCategory:1];

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//商城的分类
- (void)netWorkGoodsGetCategory:(NSInteger)Num {
    NSString *endUrlStr = YunKeTang_Goods_goods_getCategory;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setValue:@"20" forKey:@"count"];
    [mutabDict setValue:@"0" forKey:@"goods_category_id"];
    
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
        
        _exchangArray = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if (Number == 1) {
             _dataArray = (NSMutableArray *)[_dataSource arrayValueForKey:@"list"];
        } else {
            NSArray *array = [_dataSource arrayValueForKey:@"list"];
            [_dataArray addObjectsFromArray:array];
        }
        NSLog(@"--个数%ld",(unsigned long)_dataArray.count);
        [self netWorkGoodsCredpayConf];

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//商城的分类
- (void)netWorkGoodsGetCategoryDowning:(NSInteger)Num {
    NSString *endUrlStr = YunKeTang_Goods_goods_getCategory;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setValue:@"10" forKey:@"count"];
    [mutabDict setValue:@"0" forKey:@"goods_category_id"];
    
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
        
        _exchangArray = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if (Number == 1) {
            _dataArray = (NSMutableArray *)[_dataSource arrayValueForKey:@"list"];
        } else {
            NSArray *array = [_dataSource arrayValueForKey:@"list"];
            [_dataArray addObjectsFromArray:array];
        }
        NSLog(@"--个数%ld",(unsigned long)_dataArray.count);
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//商品列表
- (void)netWorkGoodsGetList:(NSInteger)Num {
    NSString *endUrlStr = YunKeTang_Goods_goods_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setValue:@"10" forKey:@"count"];
    [mutabDict setValue:categoryId forKey:@"goods_category"];
    [mutabDict setValue:@"list" forKey:@"type"];
    [mutabDict setValue:_searchTextField.text forKey:@"keyword"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (oath_token_Str == nil) {
        
    } else {
       [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict objectForKey:@"code"] integerValue] == 1) {
            NSMutableArray *pass = [NSMutableArray new];
            if (SWNOTEmptyArr([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject])) {
                [pass addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
                if (Number == 1) {
                    [_dataArray removeAllObjects];
                }
                [_dataArray addObjectsFromArray:pass];
            } else {
                if (Number == 1) {
                    [_dataArray removeAllObjects];
                }
                [_dataArray addObjectsFromArray:pass];
            }
            if (pass.count < 10) {
                [_tableView setFooterHidden:YES];
            } else {
                [_tableView setFooterHidden:NO];
            }
        } else {
            if (Number > 1) {
                Number--;
            }
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (Number>1) {
            Number--;
        }
    }];
    [op start];
}




//积分的配置
- (void)netWorkGoodsCredpayConf {
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _scoreStaus = [dict stringValueForKey:@"status"];
            NSString *split_score_str = [dict stringValueForKey:@"split_score"];
            NSArray *array = [split_score_str componentsSeparatedByString:@":"];
            percentage = (CGFloat)[array[0] integerValue] / [array[1] integerValue];
        }
        _payTypeArray = [dict arrayValueForKey:@"pay_type"];
        
        [self addTableHeaderView];
        [self addTableView];
        [_tableView reloadData];
        
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
