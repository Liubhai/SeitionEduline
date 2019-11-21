//
//  CollectMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/11.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "CollectMainViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BigWindCar.h"

#import "CollectLiveViewController.h"
#import "CollectClassViewController.h"
#import "CollectTopicViewController.h"
#import "CollectLineClassViewController.h"
#import "CollectInsViewController.h"
#import "CollectNewsViewController.h"



@interface CollectMainViewController ()<UIScrollViewDelegate>

@property (strong ,nonatomic)UIButton *liveButton;
@property (strong ,nonatomic)UIButton *classButton;
@property (strong ,nonatomic)UIButton *topicButton;
@property (strong ,nonatomic)UIButton *lineClassButton;
@property (strong ,nonatomic)UIButton *instButton;
@property (strong ,nonatomic)UIButton *newsButton;
@property (strong, nonatomic) UIButton *comboButton;
@property (strong, nonatomic) UIButton *newsClassButton;

@property (assign ,nonatomic)CGFloat  buttonW;
@property (strong ,nonatomic)UIButton *HDButton;
@property (strong ,nonatomic)UIButton *seletedButton;
@property (strong, nonatomic) NSArray *titleArray;

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;

//营销数据
@property (strong ,nonatomic)NSString     *order_switch;


@end

@implementation CollectMainViewController

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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"我的收藏";
    [self interFace];
    [self addWZView];
    [self addControllerSrcollView];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
   UILabel *titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    titleText.text = @"我的收藏";
    [titleText setTextColor:[UIColor whiteColor]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        titleText.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        button.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 34)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    //添加按钮
//    NSArray *titleArray = @[@"直播",@"点播",@"线下课",@"帖子"];
    _titleArray = @[@"直播",@"点播",@"线下课",@"机构",@"资讯",@"套餐",@"班级"];
    CGFloat ButtonH = 20;
    CGFloat ButtonW = MainScreenWidth / _titleArray.count;
    _buttonW = ButtonW;
    for (int i = 0; i < _titleArray.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(ButtonW * i, 7, ButtonW, ButtonH);
        button.tag = i;
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
//        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(WZButton:) forControlEvents:UIControlEventTouchUpInside];
        [WZView addSubview:button];
        if (i == 0) {
            [self WZButton:button];
        }
        
        if (i == 0) {
            _liveButton = button;
        } else if (i == 1) {
            _classButton = button;
        } else if (i == 2) {
            _lineClassButton = button;
        } else if (i == 3) {
            _instButton = button;
        } else if (i == 4) {
            _newsButton = button;
        } else if (i == 5) {
            _comboButton = button;
        } else if (i == 6) {
            _newsClassButton = button;
        }
        
        
        //添加分割线
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW + ButtonW * i, 10, 1, ButtonH - 6)];
        lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
        [WZView addSubview:lineButton];
        
        
    }
    
    //添加横线
    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 27 + 3, ButtonW, 1)];
    _HDButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [WZView addSubview:_HDButton];
    _HDButton.hidden = YES;
    
    
}


- (void)WZButton:(UIButton *)button {
    
    self.seletedButton.selected = NO;
    button.selected = YES;
    self.seletedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        _HDButton.frame = CGRectMake(button.tag * _buttonW, 27 + 3, _buttonW, 1);
        //        _pay_status = [NSString stringWithFormat:@"%ld",button.tag];
    }];
    //    [self NetWorkGetOrder];
    
    _controllerSrcollView.contentOffset = CGPointMake(button.tag * MainScreenWidth, 0);
    
}


- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 34 *HigtEachUnit,  MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * _titleArray.count,0);
    [self.view addSubview:_controllerSrcollView];
    _controllerSrcollView.backgroundColor = [UIColor whiteColor];
    
    CollectLiveViewController * liveVc= [[CollectLiveViewController alloc]init];
    liveVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit);
    [_controllerSrcollView addSubview:liveVc.view];
    [self addChildViewController:liveVc];
    
    CollectClassViewController * classVc = [[CollectClassViewController alloc]init];
    classVc.typeString = @"course";
    classVc.view.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit);
    [_controllerSrcollView addSubview:classVc.view];
    [self addChildViewController:classVc];
    
    CollectLineClassViewController * lineClassVc = [[CollectLineClassViewController alloc]init];
    lineClassVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit);
    [_controllerSrcollView addSubview:lineClassVc.view];
    [self addChildViewController:lineClassVc];
    
//    CollectTopicViewController * topicVc = [[CollectTopicViewController alloc]init];
//    topicVc.view.frame = CGRectMake(MainScreenWidth * 3, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit);
//    [self addChildViewController:topicVc];
//    [_controllerSrcollView addSubview:topicVc.view];
    
    
    CollectInsViewController * instVc = [[CollectInsViewController alloc]init];
    instVc.view.frame = CGRectMake(MainScreenWidth * 3, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit);
    [_controllerSrcollView addSubview:instVc.view];
    [self addChildViewController:instVc];
    
    CollectNewsViewController * newsVc = [[CollectNewsViewController alloc]init];
    newsVc.view.frame = CGRectMake(MainScreenWidth * 4, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit);
    [_controllerSrcollView addSubview:newsVc.view];
    [self addChildViewController:newsVc];
    
    CollectClassViewController * ComboVc = [[CollectClassViewController alloc]init];
    ComboVc.typeString = @"combo";
    ComboVc.view.frame = CGRectMake(MainScreenWidth * 5, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit);
    [_controllerSrcollView addSubview:ComboVc.view];
    [self addChildViewController:ComboVc];
    
    CollectClassViewController * newClassVc = [[CollectClassViewController alloc]init];
    newClassVc.typeString = @"newClass";
    newClassVc.view.frame = CGRectMake(MainScreenWidth * 6, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit);
    [_controllerSrcollView addSubview:newClassVc.view];
    [self addChildViewController:newClassVc];
    
}



#pragma mark --- 滚动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //要吧之前的按钮设置为未选中 不然颜色不会变
    self.seletedButton.selected = NO;
    
    
    NSLog(@"%lf",scrollView.contentOffset.x);
    
    if (_controllerSrcollView == scrollView) {
        CGPoint point = scrollView.contentOffset;
        if (point.x == 0) {
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(0, 27 + 3, _buttonW, 1);
            }];
            
            [_liveButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_topicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_comboButton setTitleColor:[UIColor blackColor] forState:0];
            [_newsClassButton setTitleColor:[UIColor blackColor] forState:0];
            
        } else if(point.x == MainScreenWidth) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW, 27 + 3, _buttonW, 1);
            }];
            [_liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_instButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_comboButton setTitleColor:[UIColor blackColor] forState:0];
            [_newsClassButton setTitleColor:[UIColor blackColor] forState:0];
            
        }else if (point.x == MainScreenWidth * 2) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 2, 27 + 3, _buttonW, 1);
            }];
            
            [_liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_instButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_comboButton setTitleColor:[UIColor blackColor] forState:0];
            [_newsClassButton setTitleColor:[UIColor blackColor] forState:0];
            
            
        } else if (point.x == MainScreenWidth * 3) {
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 3, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 3, 27 + 3, _buttonW, 1);
            }];
            
            [_liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_instButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_comboButton setTitleColor:[UIColor blackColor] forState:0];
            [_newsClassButton setTitleColor:[UIColor blackColor] forState:0];
        } else if (point.x == MainScreenWidth * 4) {
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 4, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 4, 27 + 3, _buttonW, 1);
            }];
            
            [_liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_newsButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_instButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_comboButton setTitleColor:[UIColor blackColor] forState:0];
            [_newsClassButton setTitleColor:[UIColor blackColor] forState:0];
        } else if (point.x == MainScreenWidth * 5) {
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 5, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 5, 27 + 3, _buttonW, 1);
            }];
            
            [_liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_instButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_comboButton setTitleColor:BasidColor forState:0];
            [_newsClassButton setTitleColor:[UIColor blackColor] forState:0];
        } else if (point.x == MainScreenWidth * 6) {
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 6, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW * 6, 27 + 3, _buttonW, 1);
            }];
            
            [_liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_lineClassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_instButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_comboButton setTitleColor:[UIColor blackColor] forState:0];
            [_newsClassButton setTitleColor:BasidColor forState:0];
        }
    }
}


#pragma mark ---   网络请求
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


@end
