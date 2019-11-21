//
//  AboutUsViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/4/26.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "rootViewController.h"
#import "BigWindCar.h"



@interface AboutUsViewController ()<UIWebViewDelegate>

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)UIView       *oneView;
@property (strong ,nonatomic)UIView       *twoView;
@property (strong ,nonatomic)UIView       *thereView;

@property (strong ,nonatomic)UIWebView    *webView;

@end

@implementation AboutUsViewController

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
    [self addWebView];
}


- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"关于我们-云课堂";
    WZLabel.text = [NSString stringWithFormat:@"关于我们-%@",AppName];
    WZLabel.text = [NSString stringWithFormat:@"关于我们"];
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:lineButton];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineButton.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
    
    
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    _scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_scrollView];
    
}

#pragma mark ---- 添加界面

- (void)addImageView {
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,MainScreenWidth, 240)];
    oneView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:oneView];
    _oneView = oneView;
    
    UIImageView *imgaeView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 40, 40, 80, 80)];
    imgaeView.image = Image(@"云课堂图标");
    [_oneView addSubview:imgaeView];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, MainScreenWidth, 30)];
    name.text = @"云课堂学生客户端";
    [_oneView addSubview:name];
    name.textAlignment = NSTextAlignmentCenter;
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(name.frame) + 10, MainScreenWidth, 30)];
    number.text = @"版本 1.0";
    number.textAlignment = NSTextAlignmentCenter;
    [_oneView addSubview:number];
    
    
    if (iPhone5o5Co5S) {
        imgaeView.frame = CGRectMake(MainScreenWidth / 2 - 40, 20, 80, 80);
        name.frame = CGRectMake(0, 100, MainScreenWidth, 30);
        number.frame = CGRectMake(0,  CGRectGetMaxY(name.frame), MainScreenWidth, 30);
        oneView.frame = CGRectMake(0, 0, MainScreenWidth, 160);
    } else if (iPhone6) {
        imgaeView.frame = CGRectMake(MainScreenWidth / 2 - 40, 30, 80, 80);
        name.frame = CGRectMake(0, 120, MainScreenWidth, 30);
        number.frame = CGRectMake(0,  CGRectGetMaxY(name.frame), MainScreenWidth, 30);
        oneView.frame = CGRectMake(0, 0, MainScreenWidth, 180);
    }
    
    
}

- (void)addTextView {
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_oneView.frame),MainScreenWidth, 200)];
    twoView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:twoView];
    _twoView = twoView;
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, MainScreenWidth - 20, 100)];
//    content.textAlignment = NSTextAlignmentCenter;
    [_twoView addSubview:content];
    content.font = Font(15);
    if (iPhone5o5Co5S) {
        content.font = Font(13);
    }
    
    
    CGRect frame;
    //文本赋值
    content.text = @"     云课堂是一家为机构提升教育品牌与招生，为学生及家长提供优质教育机构、资源的一家教育综合服务平台。打造“教育行业的携程模式”的为教育机构发展提供360度全方位服务，为学生家长提供优质教育资源降低学习成本，提升综合价值的平台。                                                                         领先的教育机构与学生与家长整体解决方案供应商，面向教育培训机构创新性推出了管理、教学、营销三大解决方案。在北京为总部、以济南为基地在主要城市下设服务中心（分公司）；建立网络服务、管理服务、教学服务、营销服务、投资服务五大服务体系。发展成为集教育互联网平台、教育管理服务、教育产品研发、教育项目投资于一体的高科技创新教育集团。";
    //设置label的最大行数
    content.numberOfLines = 0;
    CGRect labelSize = [content.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    
    if (iPhone5o5Co5S) {
         labelSize = [content.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    }
    
    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    frame.size.height = labelSize.size.height;
    _twoView.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame), MainScreenWidth, labelSize.size.height + 20);
    
    


}


- (void)addCompany {
    UIView *thereView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_twoView.frame),MainScreenWidth, 200)];
    thereView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:thereView];
    _thereView = thereView;
    
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, MainScreenWidth, 30)];
    
    name.text = @"成都赛新科技有限公司 版权所有";
    [_thereView addSubview:name];
    name.font = Font(13);
    name.textAlignment = NSTextAlignmentCenter;
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(name.frame) + 10, MainScreenWidth, 30)];
    number.text = @"云课堂 (成都) 赛新科技有限公司 1.0";
    number.textAlignment = NSTextAlignmentCenter;
    number.font = Font(13);
    [_thereView addSubview:number];
    
    if (iPhone5o5Co5S) {
        name.frame = CGRectMake(0, 40, MainScreenWidth, 30);
        number.frame = CGRectMake(0, CGRectGetMaxY(name.frame) + 10, MainScreenWidth, 30);
    } else if (iPhone6) {
        name.frame = CGRectMake(0, 60, MainScreenWidth, 30);
        number.frame = CGRectMake(0, CGRectGetMaxY(name.frame) + 10, MainScreenWidth, 30);
    }
    
}

#pragma mark --- webView
- (void)addWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, MainScreenWidth,MainScreenHeight - 64)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",EncryptUrl,YunKeTang_Basic_Basic_showAbout];
    url = [NSURL URLWithString:urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

@end
