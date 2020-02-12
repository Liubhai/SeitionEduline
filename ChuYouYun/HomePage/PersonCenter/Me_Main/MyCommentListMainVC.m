//
//  MyCommentListMainVC.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/11/21.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "MyCommentListMainVC.h"
#import "SYG.h"
#import "YunKeTang_Api.h"
#import "TKProgressHUD+Add.h"
#import "Passport.h"
#import "AppDelegate.h"
#import "MyCommentListVC.h"

@interface MyCommentListMainVC ()<UIScrollViewDelegate>

@property(strong, nonatomic) NSArray *typeClassArray;
@property(strong, nonatomic) NSArray *topClassArray;
@property(strong, nonatomic) UIScrollView *mainScrollView;
@property(strong, nonatomic) UIView *bottomLineView;
@property(strong, nonatomic) UIView *lineView;
@property(strong, nonatomic) UIScrollView *topScrollView;

@end

@implementation MyCommentListMainVC

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
    _titleLabel.text = @"我的点评";
    _topClassArray = @[@"点播/直播评论",@"套餐评论",@"线下课评论",@"讲师评论",@"班级评论"];
    _typeClassArray = @[@"1",@"2",@"3",@"4",@"6"];
    [self makeTopScrollViewUI];
    [self makeMainScrollView];
}

- (void)changeScrollViewUI:(UIScrollView *)scrollView {
    NSInteger k = scrollView.contentOffset.x / MainScreenWidth;
    for (int i = 0; i<_topClassArray.count; i++) {
        UIButton *btn = [_topScrollView viewWithTag:i + 100];
        if (i == k) {
            btn.selected = YES;
            _bottomLineView.centerX = btn.centerX;
            [_bottomLineView setWidth:btn.width];
            CGPoint btnPoint = [_topScrollView convertPoint:CGPointMake(btn.x, btn.y) toView:self.view];
            if ((btnPoint.x + btn.width) > MainScreenWidth) {
                [_topScrollView setContentOffset:CGPointMake((btnPoint.x + btn.width) - MainScreenWidth, 0)];
            }
            if (btnPoint.x < 0) {
                [_topScrollView setContentOffset:CGPointMake(_topScrollView.contentOffset.x + btnPoint.x, 0)];
            }
        } else {
            btn.selected = NO;
        }
    }
}

- (void)typeButtonClick:(UIButton *)sender {
    [_mainScrollView setContentOffset:CGPointMake(MainScreenWidth * (sender.tag - 100), 0) animated:YES];
}

- (void)makeMainScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topScrollView.bottom, MainScreenWidth, MainScreenHeight - _topScrollView.bottom)];
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth*_topClassArray.count, 0);
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    
    for (int i = 0; i< _typeClassArray.count; i++) {
        MyCommentListVC *vc = [[MyCommentListVC alloc] init];
        vc.commentTypeString = _typeClassArray[i];
        vc.view.frame = CGRectMake(MainScreenWidth*i, 0, MainScreenWidth, _mainScrollView.height);
        [_mainScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

- (void)makeTopScrollViewUI {
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 44)];
    _topScrollView.delegate = self;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.bounces = NO;
    [self.view addSubview:_topScrollView];
    CGFloat allWidth = 0;
    BOOL overWidth = NO;
    for (int i = 0; i<_topClassArray.count; i++) {
        allWidth = allWidth + [(NSString *)_topClassArray[i] sizeWithFont:SYSTEMFONT(14)].width + 10;
    }
    if (allWidth > MainScreenWidth) {
        overWidth = YES;
    }
    
    CGFloat x = 0;
    CGFloat WW = MainScreenWidth / _topClassArray.count;
    for (int i = 0; i<_topClassArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 50, 42)];
        [btn setTitle:_topClassArray[i] forState:0];
        [btn setTitleColor:RGBHex(0x333333) forState:0];
        [btn setTitleColor:BasidColor forState:UIControlStateSelected];
        btn.titleLabel.font = SYSTEMFONT(14);
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat btnWidth = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width + 10;
        [btn setWidth:overWidth ? btnWidth : WW];
        [_topScrollView addSubview:btn];
        
        x = x + btn.width;
        if (i == 0) {
            btn.selected = YES;
        }
    }
    _topScrollView.contentSize = CGSizeMake(x, 0);
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _topScrollView.bottom - 1, MainScreenWidth, 1)];
    _lineView.backgroundColor = RGBHex(0xEEEEEE);
    [self.view addSubview:_lineView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        if (scrollView.contentOffset.x == 0) {
            [self changeScrollViewUI:scrollView];
        } else if (scrollView.contentOffset.x == MainScreenWidth) {
            [self changeScrollViewUI:scrollView];
        } else if (scrollView.contentOffset.x == MainScreenWidth * 2) {
            [self changeScrollViewUI:scrollView];
        } else if (scrollView.contentOffset.x == MainScreenWidth * 3) {
            [self changeScrollViewUI:scrollView];
        } else if (scrollView.contentOffset.x == MainScreenWidth * 4) {
            [self changeScrollViewUI:scrollView];
        }
    }
}

@end
