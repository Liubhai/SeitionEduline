//
//  LotteryView.m
//  NewCCDemo
//
//  Created by cc on 2017/1/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "LotteryView.h"
#import "UIImage+GIF.h"

#import "CC _header.h"


//抽奖
@interface LotteryView()

@property(nonatomic,strong)UIImageView              *giftView;
@property(nonatomic,strong)UIImageView              *topBgView;
@property(nonatomic,copy)  CloseBlock               block;
@property(nonatomic,strong)UILabel                  *label;
@property(nonatomic,strong)UIButton                 *closeBtn;
@property(nonatomic,strong)UIView                   *bgView;
@property(nonatomic,strong)UIView                   *view;

@end

@implementation LotteryView

-(instancetype)initWithCloseBlock:(CloseBlock)block {
    self = [super init];
    if(self) {
        self.block = block;
        [self initUI];
    }
    return self;
}

-(void)myselfWin:(NSString *)code {
    WS(ws)
    self.type = 2;
    self.label.text = @"恭喜您中奖啦";
    [self.giftView removeFromSuperview];
    _giftView = nil;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gift_pic"]];
    image.backgroundColor = CCClearColor;
    image.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(62));
        make.right.mas_equalTo(ws.view).offset(-CCGetRealFromPt(62));
        make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(94));
        make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(102));
    }];
    
    UILabel *labelCode = [UILabel new];
    labelCode.text = code;
    labelCode.textColor = CCRGBColor(255,65,46);
    labelCode.textAlignment = NSTextAlignmentCenter;
    labelCode.font = [UIFont systemFontOfSize:FontSize_72];
    [image addSubview:labelCode];
    [labelCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(image);
        make.right.mas_equalTo(image).offset(-CCGetRealFromPt(100));
    }];
    
    UILabel *label = [UILabel new];
    label.text = @"请牢记您的中奖码";
    label.textColor = CCRGBColor(102,102,102);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:FontSize_28];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(image.mas_bottom);
        make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(6));
    }];
    
    [self layoutIfNeeded];
}

-(void)otherWin:(NSString *)winnerName {
    WS(ws)
    self.type = 3;
    self.label.text = @"哎呀，就差一点";
    [self.giftView removeFromSuperview];
    _giftView = nil;
    
    UILabel *labelWinner = [UILabel new];
    labelWinner.text = @"中奖者";
    labelWinner.numberOfLines = 1;
    labelWinner.textColor = CCRGBColor(102,102,102);
    labelWinner.textAlignment = NSTextAlignmentCenter;
    labelWinner.font = [UIFont systemFontOfSize:FontSize_28];
    [self addSubview:labelWinner];
    [labelWinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(85));
        make.right.mas_equalTo(ws.view).offset(-CCGetRealFromPt(85));
        make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(134));
        make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(218));
    }];
    
    UILabel *labelWinnerName = [UILabel new];
    labelWinnerName.text = winnerName;
    labelWinnerName.numberOfLines = 1;
    labelWinnerName.textColor = CCRGBColor(255,81,44);
    labelWinnerName.textAlignment = NSTextAlignmentCenter;
    labelWinnerName.font = [UIFont systemFontOfSize:FontSize_42];
    [self addSubview:labelWinnerName];
    [labelWinnerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(85));
        make.right.mas_equalTo(ws.view).offset(-CCGetRealFromPt(85));
        make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(212));
        make.bottom.mas_equalTo(ws.view).offset(-CCGetRealFromPt(126));
    }];
    
    [self layoutIfNeeded];
}

-(UILabel *)label {
    if(!_label) {
        _label = [UILabel new];
        _label.text = @"正在抽奖";
        _label.textColor = CCRGBColor(255,255,255);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:FontSize_36];
    }
    return _label;
}

-(UIButton *)closeBtn {
    if(!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = CCClearColor;
        _closeBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"gift_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

-(void)closeBtnClicked {
    if(self.block) {
        self.block();
    }
}

-(UIImageView *)giftView {
    if(!_giftView) {
        _giftView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"gift_loading_gif"]];
        _giftView.backgroundColor = CCClearColor;
        _giftView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftView;
}

-(UIImageView *)topBgView {
    if(!_topBgView) {
        _topBgView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"gift_nav"]];
        _topBgView.backgroundColor = CCClearColor;
        _topBgView.userInteractionEnabled = YES;
        _topBgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topBgView;
}

-(void)initUI {
    WS(ws)
    self.type = 1;
    self.backgroundColor = CCRGBAColor(0, 0, 0, 0.5);
    _view = [[UIView alloc]init];
    _view.backgroundColor = CCRGBColor(255,81,44);
    _view.layer.cornerRadius = CCGetRealFromPt(6);
    [self addSubview:_view];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws).offset(CCGetRealFromPt(105));
        make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(105));
        make.top.mas_equalTo(ws).offset(CCGetRealFromPt(488));
        make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(466));
    }];

    self.bgView = [UIView new];
    [self.bgView setBackgroundColor:CCRGBColor(255,252,220)];
    self.bgView.layer.cornerRadius = CCGetRealFromPt(6);
    [_view addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(1);
        make.top.mas_equalTo(ws.view).offset(1);
        make.right.mas_equalTo(ws.view).offset(-1);
        make.bottom.mas_equalTo(ws.view).offset(-(1 + CCGetRealFromPt(4)));
    }];
    
    [self.bgView addSubview:self.topBgView];
    [_topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(-CCGetRealFromPt(55));
        make.right.mas_equalTo(ws.view).offset(CCGetRealFromPt(55));
        make.top.mas_equalTo(ws.view).offset(-CCGetRealFromPt(46));
        make.height.mas_equalTo(CCGetRealFromPt(100));
    }];
    
    [self.topBgView addSubview:self.label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.topBgView);
    }];
    
    [self.topBgView addSubview:self.closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.topBgView).offset(-CCGetRealFromPt(60));
        make.centerY.mas_equalTo(ws.topBgView);
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(80),CCGetRealFromPt(80)));
    }];
    
    [self.bgView addSubview:self.giftView];
    [_giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.bgView);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    return;
}

@end



