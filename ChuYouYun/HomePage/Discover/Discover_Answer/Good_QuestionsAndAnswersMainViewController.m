//
//  Good_QuestionsAndAnswersMainViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/16.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_QuestionsAndAnswersMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"

#import "Good_QuesAndAnsHotViewController.h"
#import "Good_QuesAndAnsNewViewController.h"
#import "Good_QuesAndAnsReplyViewController.h"
#import "DLViewController.h"
#import "Good_QuesAndAnsPublishViewController.h"
#import "Good_QuesAndAnsSearchViewController.h"
#import "Good_QuestionAndAnsCateViewController.h"


@interface Good_QuestionsAndAnswersMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>



@property (strong ,nonatomic)UIView *infoView;
@property (strong ,nonatomic)UIScrollView *allScrollView;
@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UIScrollView *classScrollView;
@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIView *segleMentView;
@property (strong ,nonatomic)UILabel *teacherInfo;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UIButton *attentionButton;
@property (strong ,nonatomic)SYGTextField *searchTextField;


@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *myUID;
@property (strong ,nonatomic)NSString *uID;//关注时用到
@property (strong ,nonatomic)NSString *teacherID;
@property (strong ,nonatomic)NSDictionary *teacherDic;
@property (strong ,nonatomic)NSDictionary *cateDict;
@property (strong ,nonatomic)NSString *following;
@property (strong ,nonatomic)NSString *nameStr;

@property (strong ,nonatomic)NSString *oneHightStr;
@property (strong ,nonatomic)NSString *fourHightStr;
@property (strong ,nonatomic)NSString *homeMoreButtonSet;


@end

@implementation Good_QuestionsAndAnswersMainViewController

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


-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self addWZView];
    [self addControllerSrcollView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    currentIndex = 0;
    //    _imageArray = @[@"你好",@"我好",@"他好",@"你好",@"大家好"];
    //    _titleInfoArray = @[@"简介"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeScrollHight:) name:@"TeacherHomeScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentScrollHight:) name:@"TeacherCommentScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeMoreButtonCilck:) name:@"TeacherHomeMoreButtonCilck" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeMovePhotoCilck:) name:@"TeacherHomeMoveToPhoto" object:nil];
    
    //从分类的过来的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCateDict:) name:@"NSNotificationQuestionCateDict" object:nil];
    
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
    WZLabel.text = @"问答";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    WZLabel.hidden = YES;
    
    //添加搜索
    SYGTextField *searchText = [[SYGTextField alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 140, 30)];
    searchText.placeholder = @"搜索问答";
    searchText.font = Font(15);
//    [searchText setValue:Font(16) forKeyPath:@"_placeholderLabel.font"];
    searchText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索问答" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [searchText sygDrawPlaceholderInRect:CGRectMake(0, 10, 0, 0)];
    searchText.layer.borderWidth = 1;
    searchText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    searchText.backgroundColor = [UIColor groupTableViewBackgroundColor];
    searchText.layer.cornerRadius = 15;
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.delegate = self;
    _searchTextField = searchText;
    
    searchText.leftView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 30, 30)];
    searchText.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
    [button setImage:Image(@"yunketang_search") forState:UIControlStateNormal];
    [searchText.leftView addSubview:button];
    [SYGView addSubview:searchText];
    
    //添加按钮
    UIButton *clearnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 100, 30)];
    clearnButton.backgroundColor = [UIColor clearColor];
    [clearnButton addTarget:self action:@selector(clearnButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_searchTextField addSubview:clearnButton];
    
    //提问的按钮
    UIButton *publishButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90, 15, 50, 50)];
    [publishButton setImage:Image(@"quesMain_add") forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(publishButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:publishButton];
    
    //添加按钮
    UIButton *cateButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 15, 50, 50)];
    [cateButton setImage:Image(@"资讯分类@2x") forState:UIControlStateNormal];
    [cateButton addTarget:self action:@selector(cateButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:cateButton];
    
    if (iPhoneX) {
        SYGView.frame = CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight);
        backButton.frame = CGRectMake(5, 40, 40, 40);
        searchText.frame = CGRectMake(50, 45, MainScreenWidth - 140, 30);
        publishButton.frame = CGRectMake(MainScreenWidth - 90, 35, 50, 50);
        cateButton.frame = CGRectMake(MainScreenWidth - 50, 35, 50, 50);
    }
}


- (void)addAllScrollView {
    
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreenWidth, MainScreenHeight - 50 * WideEachUnit)];
    //    _allScrollView.pagingEnabled = YES;
    _allScrollView.delegate = self;
    _allScrollView.bounces = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allScrollView.contentSize = CGSizeMake(0, 1000);
    [self.view addSubview:_allScrollView];
    
}

#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearnButtonCilck {
    Good_QuesAndAnsSearchViewController *vc = [[Good_QuesAndAnsSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)publishButtonCilck {
    if (!UserOathToken) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    Good_QuesAndAnsPublishViewController *vc = [[Good_QuesAndAnsPublishViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cateButtonCilck {
    Good_QuestionAndAnsCateViewController *vc = [[Good_QuestionAndAnsCateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segleMentView.frame) + 10 * WideEachUnit,  MainScreenWidth, MainScreenHeight * 3 + 500 * WideEachUnit)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [self.view addSubview:_controllerSrcollView];
    
    Good_QuesAndAnsHotViewController *hotVc= [[Good_QuesAndAnsHotViewController alloc] initWithNumID:_ID];
    hotVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:hotVc];
    [_controllerSrcollView addSubview:hotVc.view];


    Good_QuesAndAnsNewViewController * newVc = [[Good_QuesAndAnsNewViewController alloc] initWithNumID:_ID];
    newVc.view.frame = CGRectMake(MainScreenWidth * 1, 0, MainScreenWidth, MainScreenHeight * 2 + 500 * WideEachUnit);
    [self addChildViewController:newVc];
    [_controllerSrcollView addSubview:newVc.view];

    Good_QuesAndAnsReplyViewController * replyVc = [[Good_QuesAndAnsReplyViewController alloc] initWithNumID:_ID];
    replyVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight * 2 + 500 * WideEachUnit);
    [self addChildViewController:replyVc];
    [_controllerSrcollView addSubview:replyVc.view];

}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 44 * WideEachUnit)];
    if (iPhoneX) {
        WZView.frame = CGRectMake(0, NavigationBarHeight, MainScreenWidth, 44 * WideEachUnit);
    }
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    _segleMentView = WZView;
    
    NSArray *segmentedArray = @[@"最热",@"最新",@"待回复"];
    _mainSegment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _mainSegment.frame = CGRectMake(0,7 * WideEachUnit,MainScreenWidth, 30 * WideEachUnit);
    
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



#pragma mark --- 滚动试图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentCrorX = _controllerSrcollView.contentOffset.x;
    if (contentCrorX < MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 0;
        _allScrollView.contentSize = CGSizeMake(0 , [_oneHightStr floatValue] + CGRectGetMaxY(_infoView.frame) + 50 * WideEachUnit);
    }
    //    else if (contentCrorX < 2 * MainScreenWidth) {
    //        _mainSegment.selectedSegmentIndex = 1;
    //        _allScrollView.contentSize = CGSizeMake(0, MainScreenWidth);
    //    }
    else if (contentCrorX < 2 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 1;
        _allScrollView.contentSize = CGSizeMake(0, MainScreenHeight);
    }  else if (contentCrorX < 3 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 2;
        _allScrollView.contentSize = CGSizeMake(0 , [_fourHightStr floatValue] + 270 * WideEachUnit);
    }
    
}


- (void)mainChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            _allScrollView.contentSize = CGSizeMake(0 , 1000);
            _allScrollView.contentSize = CGSizeMake(0 , [_oneHightStr floatValue] + CGRectGetMaxY(_infoView.frame) + 50 * WideEachUnit);
            break;
            //        case 1:
            //            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            //            //设置滚动的范围
            //            _allScrollView.contentSize = CGSizeMake(0, MainScreenWidth);
            //            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 1, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0, MainScreenHeight);
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0 , [_fourHightStr floatValue] + 270 * WideEachUnit);
            break;
            
        default:
            break;
    }
}
#pragma mark --- 通知
- (void)getHomeScrollHight:(NSNotification *)not {
    
    NSString *hightStr = not.object;
    _oneHightStr = hightStr;
    _allScrollView.contentSize = CGSizeMake(0 , [hightStr floatValue] + CGRectGetHeight(_infoView.frame) + 150 * WideEachUnit);
}

- (void)getCommentScrollHight:(NSNotification *)not {
    
    NSString *hightStr = not.object;
    _fourHightStr = hightStr;
    _allScrollView.contentSize = CGSizeMake(0 , [hightStr floatValue] + 270 * WideEachUnit);
    if (_mainSegment.selectedSegmentIndex == 0) {
        _allScrollView.contentSize = CGSizeMake(0 , [hightStr floatValue] + 270 * WideEachUnit);
    }
}

- (void)getHomeMoreButtonCilck:(NSNotification *)not {
    NSLog(@"%@",not.object);
    _homeMoreButtonSet = (NSString *)not.object;
    
    if ([_homeMoreButtonSet integerValue] == 2) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
        _mainSegment.selectedSegmentIndex = 1;
        _allScrollView.contentOffset = CGPointMake(0, 0);
    } else if ([_homeMoreButtonSet integerValue] == 3) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
        _mainSegment.selectedSegmentIndex = 2;
        _allScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)getHomeMovePhotoCilck:(NSNotification *)not {
    _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
    _mainSegment.selectedSegmentIndex = 1;
    _allScrollView.contentOffset = CGPointMake(0, 0);
}

- (void)getCateDict:(NSNotification *)not {
    _cateDict = (NSDictionary *)not.object;
    
}


@end
