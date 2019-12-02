//
//  NewsMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/1.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "NewsMainViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZXDTViewController.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "UIButton+WebCache.h"

#import "NewsViewController.h"


@interface NewsMainViewController ()<UIScrollViewDelegate>{
    
    NSArray *_menuarr;
    UIButton *menubtn;
    int numsender;
    int tempNumber;
    UILabel *_colorLine;
    NSString *_ID;
    CGFloat buttonX;//每个按钮的最开始的位置
    CGFloat allButtonX;//最后按钮的X轴上的偏移量
    
    NSInteger index;//标题的下标
    BOOL isScrollAgain;//主页面是否滑动
}

@property (strong ,nonatomic)NSArray *lookArray;
@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UIScrollView *headScrollow;

///顶部btn集合
@property (strong, nonatomic) NSArray *btns;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)NSMutableArray *dataArr;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)NSMutableArray *imgdataArray;

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)NSArray        *buttonsArray;//顶部滑动按钮的集合


@end

@implementation NewsMainViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
        _imageView.image = Image(@"云课堂_空数据.png");
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

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
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self interFace];
    [self addNav];
//    [self NetWork];
    [self netWorkNewsGetCategory];
}

- (void)interFace {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"资讯";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //设置button上字体的偏移量
//    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(15, 40, 40, 40);
        titleLab.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineLab.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatMenu{
    
    //自定义segment区域
    NSMutableArray *marr = [NSMutableArray array];
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    
    for (int i=0; i< _dataArray.count; i++) {
        menubtn = [[UIButton alloc]init];
        //        menubtn.frame = CGRectMake(i*MainScreenWidth/5, 0, MainScreenWidth/5, 40);
        menubtn.frame = CGRectMake(buttonX, 0, MainScreenWidth / 5, 40);
        [menubtn setTitle:_dataArray[i][@"title"] forState:UIControlStateNormal];
        [_headScrollow addSubview:menubtn];
        menubtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [menubtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        menubtn.tag = 100+i;
        menubtn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (iPhone5o5Co5S) {
            menubtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            menubtn.titleLabel.font = [UIFont systemFontOfSize:12];
        } else if (iPhone6) {
            menubtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            menubtn.titleLabel.font = [UIFont systemFontOfSize:14];
        } else if (iPhone6Plus) {
            menubtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            menubtn.titleLabel.font = [UIFont systemFontOfSize:15];
        } else if (iPhoneX) {
            menubtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            menubtn.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        
        //按钮的自适应
        
        CGRect labelSize = [menubtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: menubtn.titleLabel.font} context:nil];
        labelSize = CGRectMake(labelSize.origin.x, labelSize.origin.y, labelSize.size.width + 5, labelSize.size.height);
        if (labelSize.size.width < MainScreenWidth / 5) {
            if (_dataArray.count < 5) {
                labelSize.size.width = MainScreenWidth / _dataArray.count;
            } else {
                if (iPhone6) {
                     labelSize.size.width = MainScreenWidth / 4;
                } else if (iPhone6Plus){
                     labelSize.size.width = MainScreenWidth / 4;
                }
            }
        } else {
            if (_dataArray.count < 5) {
                labelSize.size.width = MainScreenWidth / _dataArray.count;
            } else {//特殊处理
                if (iPhone6) {
                     labelSize.size.width = MainScreenWidth / 4;
                }
            }
        }
        menubtn.frame = CGRectMake(menubtn.frame.origin.x, 0,labelSize.size.width, 40);
        buttonX = labelSize.size.width + menubtn.frame.origin.x;
        allButtonX = labelSize.size.width + menubtn.frame.origin.x;
        
        [menubtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [menubtn setTitleColor:ffbbcolor forState:UIControlStateNormal];
        }
        [marr addObject:menubtn];
        
        NSLog(@"X----%lf",buttonX);
        if (i == _dataArray.count - 1) {
            
        } else {
            //添加横线
            for (int i = 0 ; i < _dataArray.count - 1 ; i ++) {
                UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 12.5, 1, 15)];
                lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
                [_headScrollow addSubview:lineButton];
            }
        }
    }
    _buttonsArray = [marr copy];
    int tempNum;
    tempNum = (int)_dataArray.count;
    _headScrollow.contentSize = CGSizeMake(allButtonX + 2, 40);
//    _colorLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _headScrollow.frame.size.height - 2, MainScreenWidth/5, 2)];
//    _colorLine.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
//    [_headScrollow addSubview:_colorLine];
//    CGPoint center = _colorLine.center;
//    center.x = MainScreenWidth / (2 * tempNum);
//    _colorLine.center = center;
//    _colorLine.hidden = YES;
}

-(void)addscrollow{
    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, MainScreenWidth,40)];
    if (iPhoneX) {
        _headScrollow.frame = CGRectMake(0, 88, MainScreenWidth, 40);
    }
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = NO;
    _headScrollow.backgroundColor = [UIColor whiteColor];
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.showsHorizontalScrollIndicator = NO;
}


#pragma mark --- 添加控制器的滚动
- (void)addControllerSrcollView {
    
    NSLog(@"%ld",_dataArray.count);
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 40 *HigtEachUnit,  MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 40 * HigtEachUnit)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * _dataArray.count,0);
    [self.view addSubview:_controllerSrcollView];
    
    
    //添加控制器
    for (int i = 0 ; i < _dataArray.count ; i ++) {
        NewsViewController *newsVc= [[NewsViewController alloc] initWithIDString:_dataArray[i][@"zy_topic_category_id"] schoolId:[NSString stringWithFormat:@"%@",_dataArray[i][@"mhm_id"]]];
        newsVc.view.frame = CGRectMake(MainScreenWidth * i, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 40 * HigtEachUnit);
        [_controllerSrcollView addSubview:newsVc.view];
        [self addChildViewController:newsVc];
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
            NSLog(@"移动%d   %ld",i,(long)index);
            isScrollAgain = NO;
            [self change:button];
        }
    }
    isScrollAgain = YES;
}



#pragma mark ----按钮滚动试图
-(void)change:(UIButton *)button{
    
    for (int i = 0; i < _buttonsArray.count; i++) {
        [self.buttonsArray[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    // 滚动标题栏到中间位置
    CGFloat offsetx   =  button.center.x - MainScreenWidth * 0.5;
    CGFloat offsetMax = _headScrollow.contentSize.width - _headScrollow.frame.size.width;
    
    // 在最左和最右时，标签没必要滚动到中间位置。
    if (offsetx < 0)		 {offsetx = 0;}
    if (offsetx > offsetMax) {offsetx = offsetMax;}
    
    [UIView animateWithDuration:0.2 animations:^{
        [_headScrollow setContentOffset:CGPointMake(offsetx, 0) animated:YES];
        [button setTitleColor:BasidColor forState:UIControlStateNormal];
    }];
    
    if (isScrollAgain) {
        NSInteger buttonTag = button.tag - 100;
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * buttonTag, 0);
    } else {//已经滑动过了，就不需要滑动了
        
    }
}


#pragma mark --- 网络请求
- (void)netWorkNewsGetCategory {
    
    NSString *endUrlStr = YunKeTang_News_news_getCategory;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"20" forKey:@"count"];
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
            _dataArray = (NSArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                [self addscrollow];
                [self creatMenu];
                [self addControllerSrcollView];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
