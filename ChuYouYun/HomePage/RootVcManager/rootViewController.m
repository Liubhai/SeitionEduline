//
//  rootViewController.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "rootViewController.h"
#import "MyViewController.h"
#import "AppDelegate.h"
#import "Passport.h"
#import "MoreViewController.h"
#import "SYG.h"


#import "ClassSearchGoodViewController.h"
#import "YunKeTang_HomeViewController.h"


@interface rootViewController ()
{
    MyViewController* mvc;
}

@property (strong ,nonatomic)UIButton *seledButton;

@end

@implementation rootViewController
static rootViewController *sharedBaseTabBar;
//创建子视图控制器
- (void)createViewController
{
    YunKeTang_HomeViewController *homeVc = [[YunKeTang_HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVc];
    
    ClassSearchGoodViewController *goodVc = [[ClassSearchGoodViewController alloc] init];
    goodVc.typeTagStr = @"1";
    UINavigationController *goodNav = [[UINavigationController alloc] initWithRootViewController:goodVc];
    
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    UINavigationController *navi6 = [[UINavigationController alloc] initWithRootViewController:moreVC];
    
    MyViewController * more = [[MyViewController alloc]init];
    UINavigationController * navi5 = [[UINavigationController alloc]initWithRootViewController:more];
    
    self.viewControllers = [NSArray arrayWithObjects:homeNav,goodNav,navi6,navi5, nil];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, MainScreenHeight - 49 - MACRO_UI_SAFEAREA, self.view.frame.size.width, 49 + MACRO_UI_SAFEAREA)];
    _imageView.tag = 100;
    _imageView.image = [UIImage imageNamed:@"options.png"];
    [self.view addSubview:_imageView];
    
    //添加线
    UILabel *XLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    XLabel.backgroundColor = [UIColor colorWithRed:143.f / 255 green:143.f / 255 blue:143.f / 255 alpha:0.5];
    [_imageView addSubview:XLabel];
    
    
//    NSArray *imageArray = @[@"home_no_press@2x",@"class_no_press@2x",@"tab_discover_nopress@2x",@"me_no_press@2x"];
//    NSArray *selectedArray = @[@"home_press@2x",@"class_press@2x",@"tab_discover_press@2x",@"me_press@2x"];
    
    NSArray *imageArray = @[@"tab_home'@2x",@"tab_course@2x",@"tab_found@2x",@"tab_my@2x"];
    NSArray *selectedArray = @[@"tab_home_pre@2x",@"tab_course_pre@2x",@"tab_found_pre@2x",@"tab_my_pre@2x"];
    
    //添加按钮
    CGFloat space = (self.view.frame.size.width-40*4)/5;
    for(int i=0;i<4;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(space+(space+40)*i, 0, 40, 49);
        //常态时按钮的图片
        UIImage * imageNol = [UIImage imageNamed:imageArray[i]];
        [btn setImage:imageNol forState:UIControlStateNormal];
        //选中状态时的图片
        UIImage * imageSelected = [UIImage imageNamed:selectedArray[i]];
        [btn setImage:imageSelected forState:UIControlStateSelected];
        
        [_imageView addSubview:btn];
        btn.tag= i+1;
        
        //设置第一个按钮为选中状态
        if (btn.tag==1) {
            [self pressBtn:btn];
        }
        //开启交互
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenTaberBar) name:@"hiddenTableBar" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backBtnClick) name:@"backBtnClick" object:nil];
    
}


-(void)backBtnClick
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    _imageView.alpha=1;
    // commitAnimations,将beginAnimation之后的所有动画提交并生成动画
    [UIView commitAnimations];
}

-(void)hiddenTaberBar
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    _imageView.alpha=0;
    // commitAnimations,将beginAnimation之后的所有动画提交并生成动画
    [UIView commitAnimations];
}


- (void)pressBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.selectedIndex = btn.tag-1;
//    UIImageView * imageView = (UIImageView *)[self.view viewWithTag:100];
//    NSArray * arr = [imageView subviews];
//    
//    for (UIButton *subBtn in  arr) {
//        if (subBtn.tag==btn.tag) {
//            subBtn.selected=YES;
//        }
//        else{
//            subBtn.selected = NO;
//        }
//    }
    self.seledButton.selected = NO;
    btn.selected = YES;
    self.seledButton = btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *plistPath = [Passport filePath];
    NSDictionary * _users = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if ([[_users objectForKey:@"userface"] isEqual:[NSNull null]]) {
        
    }
    [self createViewController];
    //隐藏系统tabbar
    [self.tabBar setHidden:YES];
}

-(void)isHiddenCustomTabBarByBoolean:(BOOL)boolean
{
    _imageView.hidden = boolean;
}

- (void)rootVcIndexWithNum:(NSInteger)Num {
    
    UIButton *button =(UIButton *) _imageView.subviews[Num];
    [self pressBtn:button];
    
}

+ (rootViewController *)sharedBaseTabBarViewController {
    
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    if (!sharedBaseTabBar) {
        sharedBaseTabBar = [[rootViewController alloc] init];
        NSLog(@"初始化");
    }
    //    });
    return sharedBaseTabBar;
}

+(rootViewController *)destoryShared{
    for (UIViewController *baseV in sharedBaseTabBar.viewControllers) {
        [baseV.view removeAllSubviews];
        [baseV removeFromParentViewController];
        [[NSNotificationCenter defaultCenter]removeObserver:baseV];
    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"deallocSelf" object:nil];
    sharedBaseTabBar.viewControllers = nil;
    return sharedBaseTabBar = nil;
}

@end
