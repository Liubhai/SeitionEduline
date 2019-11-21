//
//  MyQuestionMainVC.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/11/21.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "MyQuestionMainVC.h"
#import "SYG.h"
#import "YunKeTang_Api.h"
#import "TKProgressHUD+Add.h"
#import "Passport.h"
#import "AppDelegate.h"
#import "MyQuestionListVC.h"

@interface MyQuestionMainVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIButton *questionButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIView *grayLine;
@property (strong, nonatomic) UIView *blueLine;
@property (strong, nonatomic) UIScrollView *mainScrollView;



@end

@implementation MyQuestionMainVC

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"我的提问";
    [self makeHeaderView];
    [self makeMainScrollView];
}

- (void)makeHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 44)];
    [self.view addSubview:_headerView];
    
    _questionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2.0, 44)];
    [_questionButton setTitle:@"我的提问" forState:0];
    [_questionButton setTitleColor:RGBHex(0x333333) forState:0];
    [_questionButton setTitleColor:BasidColor forState:UIControlStateSelected];
    [_questionButton addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_questionButton];
    
    _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(_questionButton.right, 0, MainScreenWidth / 2.0, 44)];
    [_commentButton setTitle:@"我的回复" forState:0];
    [_commentButton setTitleColor:RGBHex(0x333333) forState:0];
    [_commentButton setTitleColor:BasidColor forState:UIControlStateSelected];
    [_commentButton addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_commentButton];
    
    _grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43, MainScreenWidth, 1)];
    _grayLine.backgroundColor = RGBHex(0xEEEEEE);
    [_headerView addSubview:_grayLine];
    
    _blueLine = [[UIView alloc] initWithFrame:CGRectMake(0, 42, _questionButton.width, 2)];
    _blueLine.backgroundColor = BasidColor;
    [_headerView addSubview:_blueLine];
}

- (void)makeMainScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, MainScreenWidth, MainScreenHeight - _headerView.bottom)];
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth*2, 0);
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    
    MyQuestionListVC *questionVC = [[MyQuestionListVC alloc] init];
    questionVC.typeString = @"1";
    questionVC.view.frame = CGRectMake(0, 0, MainScreenWidth, _mainScrollView.height);
    [_mainScrollView addSubview:questionVC.view];
    [self addChildViewController:questionVC];
    
    MyQuestionListVC *commentVC = [[MyQuestionListVC alloc] init];
    commentVC.typeString = @"2";
    commentVC.view.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, _mainScrollView.height);
    [_mainScrollView addSubview:commentVC.view];
    [self addChildViewController:commentVC];
}

- (void)headerButtonClick:(UIButton *)sender {
    if (sender == _questionButton) {
        [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender == _commentButton) {
        [_mainScrollView setContentOffset:CGPointMake(MainScreenWidth, 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _mainScrollView) {
        if (scrollView.contentOffset.x <= 0) {
            self.blueLine.centerX = self.questionButton.centerX;
            self.questionButton.selected = YES;
            self.commentButton.selected = NO;
        } else if (scrollView.contentOffset.x >= MainScreenWidth && scrollView.contentOffset.x <= MainScreenWidth) {
            self.blueLine.centerX = self.commentButton.centerX;
            self.commentButton.selected = YES;
            self.questionButton.selected = NO;
        }
    }
    
}

@end
