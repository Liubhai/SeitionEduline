//
//  RollcallView.m
//  NewCCDemo
//
//  Created by cc on 2017/1/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "RollcallView.h"
#import "UIImage+GIF.h"

#import "CC _header.h"


@interface RollcallView()

@property(nonatomic,strong)UIImageView              *clockImage;
@property(nonatomic,strong)UIView                   *bgView;
@property(nonatomic,strong)UIView                   *lineView;
@property(nonatomic,strong)UIView                   *view;
@property(nonatomic,strong)UILabel                  *label;
@property(nonatomic,assign)NSInteger                duration;
@property(nonatomic,strong)UIButton                 *lotteryBtn;
@property(nonatomic,strong)NSTimer                  *timer;
@property(nonatomic,copy)  CloseBtnClicked          closeblock;
@property(nonatomic,copy)  LotteryBtnClicked        lotteryblock;

@end

//签到
@implementation RollcallView

-(instancetype) initWithDuration:(NSInteger)duration closeblock:(CloseBtnClicked)closeblock lotteryblock:(LotteryBtnClicked)lotteryblock {
    self = [super init];
    if(self) {
        _duration = duration;
        self.closeblock = closeblock;
        self.lotteryblock = lotteryblock;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerfunc) userInfo:nil repeats:YES];
        [self initUI];
    }
    return self;
}

-(void)stopTimer {
    if([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}

-(void)timerfunc {
    WS(ws)
    _duration = _duration-1;
    NSLog(@"_duration = %d",(int)_duration);
    if(_duration == 0) {
        self.lotteryBtn.hidden = YES;
        [self stopTimer];
        self.label.text = @"签到结束";
        [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(190));
            make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(180));
        }];
        [ws layoutIfNeeded];
        
        if(self.closeblock) {
            self.closeblock();
        }
    } else {
        self.label.text = [NSString stringWithFormat:@"签到倒计时：%@",[self timeFormat:self.duration]];
    }
}

-(NSString *)timeFormat:(NSInteger)time {
    NSInteger minutes = time / 60;
    NSInteger seconds = time % 60;
    NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d",(int)minutes,(int)seconds];
    return timeStr;
}

-(UILabel *)label {
    if(!_label) {
        _label = [UILabel new];
        _label.text = [NSString stringWithFormat:@"签到倒计时：%@",[self timeFormat:self.duration]];
        _label.textColor = CCRGBColor(255,81,44);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:FontSize_40];
    }
    return _label;
}

-(UIButton *)lotteryBtn {
    if(_lotteryBtn == nil) {
        _lotteryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lotteryBtn.backgroundColor = CCRGBColor(255,102,51);
        [_lotteryBtn setTitle:@"我要签到" forState:UIControlStateNormal];
        [_lotteryBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_32]];
        [_lotteryBtn setTitleColor:CCRGBAColor(255, 255, 255, 1) forState:UIControlStateNormal];
        [_lotteryBtn setTitleColor:CCRGBAColor(255, 255, 255, 0.4) forState:UIControlStateDisabled];
        [_lotteryBtn.layer setMasksToBounds:YES];
        [_lotteryBtn.layer setBorderWidth:2.0];
        [_lotteryBtn.layer setBorderColor:[CCRGBColor(252,92,61) CGColor]];
        [_lotteryBtn.layer setCornerRadius:CCGetRealFromPt(6)];
        [_lotteryBtn addTarget:self action:@selector(lotteryBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_lotteryBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(255,102,51)] forState:UIControlStateNormal];
        [_lotteryBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(248,92,40)] forState:UIControlStateHighlighted];
    }
    return _lotteryBtn;
}

-(void)lotteryBtnClicked {
    WS(ws)
    self.lotteryBtn.hidden = YES;
    [self stopTimer];
    self.label.text = @"签到成功";
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(190));
        make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(180));
    }];
    [self layoutIfNeeded];
    
    if(self.lotteryblock) {
        self.lotteryblock();
    }
    
    if(self.closeblock) {
        self.closeblock();
    }
}

- (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIView *)lineView {
    if(!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CCRGBAColor(255,102,51,0.5);
    }
    return _lineView;
}

-(UIImageView *)clockImage {
    if(!_clockImage) {
        _clockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_pic_nav"]];
        _clockImage.backgroundColor = CCClearColor;
        _clockImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _clockImage;
}

-(void)initUI {
    WS(ws)
    self.backgroundColor = CCRGBAColor(0,0,0,0.5);
    _view = [[UIView alloc] init];
    _view.backgroundColor = CCRGBColor(255,81,44);
    _view.layer.cornerRadius = CCGetRealFromPt(6);
    [self addSubview:_view];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws).offset(CCGetRealFromPt(75));
        make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(75));
        make.top.mas_equalTo(ws).offset(CCGetRealFromPt(438));
        make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(486));
    }];

    self.bgView = [UIView new];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    self.bgView.layer.cornerRadius = CCGetRealFromPt(6);
    [_view addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(1);
        make.top.mas_equalTo(ws.view).offset(1);
        make.right.mas_equalTo(ws.view).offset(-1);
        make.bottom.mas_equalTo(ws.view).offset(-(1 + CCGetRealFromPt(4)));
    }];
    
    [self.bgView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(28));
        make.right.mas_equalTo(ws.view).offset(-CCGetRealFromPt(28));
        make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(26));
        make.height.mas_equalTo(1);
    }];
    
    [self.bgView addSubview:self.clockImage];
    [_clockImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.view);
        make.bottom.mas_equalTo(ws.view.mas_top).offset(CCGetRealFromPt(54));
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(110), CCGetRealFromPt(110)));
    }];
    
    [self.bgView addSubview:self.label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(146));
        make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(224));
    }];
    
    [self.bgView addSubview:self.lotteryBtn];
    [_lotteryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(140));
        make.right.mas_equalTo(ws.view).offset(-CCGetRealFromPt(140));
        make.height.mas_equalTo(CCGetRealFromPt(80));
        make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(52));
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    return;
}

@end
