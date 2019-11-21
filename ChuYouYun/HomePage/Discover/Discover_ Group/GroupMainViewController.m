//
//  GroupMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/19.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "GroupMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"

#import "GreatViewController.h"
#import "GroupOneViewController.h"
#import "GroupTwoViewController.h"
#import "GroupThereViewController.h"
#import "GroupGoodViewController.h"


@interface GroupMainViewController ()<UIScrollViewDelegate> {
    CGFloat buttonX;//每个按钮的X轴的开始位置
    CGFloat allButtonX;//记录滚动视图的最大的X轴的位置
    NSInteger index;//标题的下标
    BOOL isScrollAgain;//主页面是否滑动
}

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;

@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *dataSource;
@property (strong ,nonatomic)NSArray *cateArray;
@property (strong ,nonatomic)NSMutableArray *titleArray;
@property (strong ,nonatomic)NSArray        *buttonsArray;//顶部滑动按钮的集合

@property (strong ,nonatomic)UIScrollView *titleScrollView;
@property (strong ,nonatomic)UIButton     *titleButton;

@end

@implementation GroupMainViewController


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
    [self interFace];
    [self addNav];
//    [self addTitleView];
//    [self addControllerSrcollView];
    [self netWorkCate];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArray = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    buttonX = 0;
    allButtonX = 0;
    index = 0;
    isScrollAgain = NO;
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
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    WZLabel.text = @"小组";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加横线
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
//    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [SYGView addSubview:button];
    
    //添加分类的按钮
    UIButton *SortButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 25, 30, 30)];
    [SortButton setBackgroundImage:Image(@"创建小组2") forState:UIControlStateNormal];
    [SortButton addTarget:self action:@selector(SortButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SortButton];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        SortButton.frame = CGRectMake(MainScreenWidth - 50, 45, 30, 30);
    }
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 添加分类
- (void)addTitleView {
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 40)];
    if (iPhoneX) {
        titleScrollView.frame = CGRectMake(0, 88, MainScreenWidth, 40);
    }
    titleScrollView.backgroundColor = [UIColor whiteColor];
    titleScrollView.bounces = YES;
    titleScrollView.scrollEnabled = YES;
//    titleScrollView.delegate = self;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:titleScrollView];
    _titleScrollView = titleScrollView;
    
    

    titleScrollView.alwaysBounceVertical = NO;
    titleScrollView.pagingEnabled = NO;
    //同时单方向滚动
    titleScrollView.directionalLockEnabled = YES;
    titleScrollView.contentOffset = CGPointMake(0, 0);
    
    NSMutableArray *marr = [NSMutableArray array];
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];

    for (int i = 0; i < _titleArray.count ; i ++) {
        _titleButton = [[UIButton alloc] init];
        _titleButton.frame = CGRectMake(buttonX, 0, MainScreenWidth / 5, 40);
        [_titleButton setTitle:_titleArray[i] forState:UIControlStateNormal];
        [_titleScrollView addSubview:_titleButton];
        _titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleButton.tag = 100 + i;
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        if (iPhone5o5Co5S) {
           _titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            _titleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        } else if (iPhone6) {
            _titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            _titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        } else if (iPhone6Plus) {
           _titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
           _titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        //按钮的自适应
        CGRect labelSize = [_titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
        if (labelSize.size.width <= MainScreenWidth / 5 ) {
//            CGFloat buttonW = MainScreenWidth / _titleArray.count;
//            CGFloat buttonH = 40;
            labelSize.size.width = MainScreenWidth / 5;
        }
        _titleButton.frame = CGRectMake(_titleButton.frame.origin.x, _titleButton.frame.origin.y,labelSize.size.width, 40);
        buttonX = labelSize.size.width + _titleButton.frame.origin.x;
        allButtonX = labelSize.size.width + _titleButton.frame.origin.x;
        

        

        [_titleButton addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [_titleButton setTitleColor:ffbbcolor forState:UIControlStateNormal];
        }
        [marr addObject:_titleButton];

        
        if (_titleArray.count <= 5 ) {
            CGFloat buttonW = MainScreenWidth / _titleArray.count;
            CGFloat buttonH = 40;
            _titleButton.frame = CGRectMake(buttonW * i, 0, buttonW, buttonH);
            
            if (i == _titleArray.count - 1) {
                
            } else {
                //添加横线
                for (int i = 0 ; i < _titleArray.count - 1 ; i ++) {
                    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonW + buttonW * i, 12.5, 1, 15)];
                    lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
                    [_titleScrollView addSubview:lineButton];
                }
            }
        } else {
            if (i == _titleArray.count - 1) {
                
            } else {
                //添加横线
                for (int i = 0 ; i < _titleArray.count - 1 ; i ++) {
                    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 12.5, 1, 15)];
                    lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
                    [_titleScrollView addSubview:lineButton];
                }
            }
        }
    }
    
    _buttonsArray = [marr copy];
    int tempNum;
    tempNum = (int)_dataArray.count;
    _titleScrollView.contentSize = CGSizeMake(buttonX + 2, 40);
}


#pragma mark --- 添加控制器

- (void)addControllerSrcollView {
    
    NSLog(@"%ld",_dataSource.count);
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104,  MainScreenWidth, MainScreenHeight * 3 + 500)];
    if (iPhoneX) {
        _controllerSrcollView.frame = CGRectMake(0, 128, MainScreenWidth, MainScreenHeight * 3 + 500);
    }
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * _titleArray.count,0);
    [self.view addSubview:_controllerSrcollView];
    
    
    //添加控制器
    for (int i = 0 ; i < _dataSource.count ; i ++) {
        GroupOneViewController *groupOneVc= [[GroupOneViewController alloc] initWithArray:_dataSource[i]];
        groupOneVc.view.frame = CGRectMake(MainScreenWidth * i, 0, MainScreenWidth, MainScreenHeight);
        [self addChildViewController:groupOneVc];
        [_controllerSrcollView addSubview:groupOneVc.view];
    }

    
}

#pragma mark --- 滚动试图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentCrorX = _controllerSrcollView.contentOffset.x;
    index = contentCrorX / MainScreenWidth;
    for (int i = 0; i < _buttonsArray.count; i++) {
        UIButton *button = _buttonsArray[i];
        button.tag = 100 + i;
        [self.buttonsArray[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == index) {
            isScrollAgain = NO;
            [self change:button];
        }
    }
}



#pragma mark ----按钮滚动试图
-(void)change:(UIButton *)button{
    
    for (int i = 0; i < _buttonsArray.count; i++) {
        [self.buttonsArray[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    // 滚动标题栏到中间位置
    CGFloat offsetx   =  button.center.x - MainScreenWidth * 0.5;
    CGFloat offsetMax = _titleScrollView.contentSize.width - _titleScrollView.frame.size.width;
    
    // 在最左和最右时，标签没必要滚动到中间位置。
    if (offsetx < 0)		 {offsetx = 0;}
    if (offsetx > offsetMax) {offsetx = offsetMax;}
    
    if (_titleArray.count <= 5) {
            [button setTitleColor:BasidColor forState:UIControlStateNormal];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [_titleScrollView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
            [button setTitleColor:BasidColor forState:UIControlStateNormal];
        }];
    }

    
    if (isScrollAgain) {
        NSInteger buttonTag = button.tag - 100;
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * buttonTag, 0);
    } else {//已经滑动过了，就不需要滑动了
        
    }
    isScrollAgain = YES;
}





#pragma mark --- 事件监听

- (void)SortButtonClick {
    GreatViewController *greatVc = [[GreatViewController alloc] init];
    [self.navigationController pushViewController:greatVc animated:YES];
    greatVc.cateArray = _cateArray;
}

#pragma mark --- 网络请求

- (void)netWorkCate {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    
    [manager BigWinCar_GroupCate:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _cateArray = responseObject[@"data"];
        for (int i = 0 ; i < _cateArray.count ; i ++) {
            NSString *titleStr = _cateArray[i][@"title"];
            [_titleArray addObject:titleStr];
        }
        [self addTitleView];
        [self netWork];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"请检查网络" toView:self.view];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
        imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
        [self.view addSubview:imageView];
    }];
    
}

- (void)netWork {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    
    [manager BigWinCar_GroupList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            _dataArray = responseObject[@"data"];
            for (int i = 0 ; i < _dataArray.count ; i ++) {
                NSArray *array = [[_dataArray objectAtIndex:i] arrayValueForKey:@"group_list"];
                if (array == nil) {
                    array = @[];
                    [_dataSource addObject:array];
                } else {
                    [_dataSource addObject:array];
                }
            }
            [self addControllerSrcollView];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"请检查网络" toView:self.view];
        //添加空白处理
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
        imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
        [self.view addSubview:imageView];
    }];
    
}






@end
