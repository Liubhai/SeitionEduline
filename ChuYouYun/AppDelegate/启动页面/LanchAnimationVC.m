//
//  LanchAnimationVC.m
//  ThinkSNS（探索版）
//
//  Created by Herman8040 on 2016/10/19.
//  Copyright © 2016年 zhishi. All rights reserved.
//


#import "LanchAnimationVC.h"

// 放大倍数 建议：1.1
#define BgSale 1.1
// 动画时间 建议：2.0
#define AnimationTime 3.0
// 透明度起始值 建议：0.3
#define AnimationBgAlpha 0.3
// 透明度完成值 建议：1.0
#define AnimationEdAlpha 1

@interface LanchAnimationVC (){

    UIImageView* _bgImageView;
    UIImageView* _logImageView;
    UIButton *_timerbutton;
    NSTimer *_timer;
    NSInteger timerCountDefault;
    
}

@end

@implementation LanchAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    timerCountDefault = 3;
    _titleImage.hidden = YES;
    
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _logImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    _logImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:_bgImageView];
    [self.view addSubview:_logImageView];
    if (MACRO_UI_SAFEAREA) {
        _bgImageView.image = [UIImage imageNamed:@"lauchIphoneX"];
        _logImageView.image = [UIImage imageNamed:@"lauchIphoneX"];
    }
    else{
        _bgImageView.image = [UIImage imageNamed:@"lauch375"];
        _logImageView.image = [UIImage imageNamed:@"lauch375"];
    }

    _timerbutton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 20 - 60, MACRO_UI_LIUHAI_HEIGHT + 30, 60, 30)];
    _timerbutton.clipsToBounds = YES;
    _timerbutton.layer.cornerRadius = 15;
    [_timerbutton setTitle:[NSString stringWithFormat:@"跳过 %@",@(timerCountDefault)] forState:0];
    _timerbutton.backgroundColor = RGBHex(0xEEEEEE);//[UIColor colorWithRGBA:0x00000026];
    [_timerbutton addTarget:self action:@selector(timerOut) forControlEvents:UIControlEventTouchUpInside];
    [_timerbutton setTitleColor:RGBHex(0x333333) forState:0];
    _timerbutton.titleLabel.font = SYSTEMFONT(14);
    [self.view addSubview:_timerbutton];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    _bgImageView.alpha = AnimationBgAlpha;

    [UIView animateWithDuration:AnimationTime animations:^{
        
        _bgImageView.left = (BgSale - 1) / 2.0 * MainScreenWidth * (-1);
        _bgImageView.top =(BgSale - 1) / 2.0 * MainScreenHeight * (-1);
        _bgImageView.width = BgSale * MainScreenWidth;
        _bgImageView.height = BgSale * MainScreenHeight;
        _bgImageView.alpha = AnimationEdAlpha;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)timerOut {
    if (self.animationFinished) {
        self.animationFinished(YES);
        self.view = nil;
        [_timer invalidate];
    }
}

- (void)timerCount{
    timerCountDefault--;
    if (timerCountDefault <= 0) {
        if (self.animationFinished) {
            self.animationFinished(YES);
            self.view = nil;
            [_timer invalidate];
        }
    } else {
        [_timerbutton setTitle:[NSString stringWithFormat:@"跳过 %@",@(timerCountDefault)] forState:0];
    }
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [self.view removeAllSubviews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
