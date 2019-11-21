//
//  PlayForMobileVC.m
//  NewCCDemo
//
//  Created by cc on 2016/12/14.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "PlayForMobileVC.h"
#import "CustomTextField.h"
#import "CCPublicTableViewCell.h"
#import "CCPrivateChatView.h"
#import "Dialogue.h"
#import "ModelView.h"
#import "CCSDK/RequestData.h"
#import "LoadingView.h"
#import "InformationShowView.h"
#import "Utility.h"
#import "GongGaoView.h"

@interface PlayForMobileVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,RequestDataDelegate>
/*
 * 是否横屏模式
 */
@property(nonatomic, assign)Boolean                 isScreenLandScape;
@property(nonatomic,strong)UIImageView              *daohangView;
@property(nonatomic,strong)UIButton                 *leftButton;
@property(nonatomic,strong)UILabel                  *leftLabel;
@property(nonatomic,copy) NSString                  *leftLabelText;

@property(nonatomic,strong)UIImageView              *userCountLogo;
@property(nonatomic,copy)NSString                   *userCount;
@property(nonatomic,strong)UILabel                  *userCountLabel;
@property(nonatomic,strong)UIButton                 *qingXiDuBtn;
@property(nonatomic,strong)UIButton                 *gongGaoBtn;
@property(nonatomic,strong)UIImageView              *gongGaoDot;

@property(nonatomic,strong)UIImageView              *soundBg;
@property(nonatomic,strong)UILabel                  *soundLabel;

@property(nonatomic,strong)CustomTextField          *chatTextField;
@property(nonatomic,strong)UIButton                 *danMuButton;
@property(nonatomic,strong)UIButton                 *sendButton;
@property(nonatomic,strong)UIView                   *contentView;
@property(nonatomic,strong)UIButton                 *rightView;

@property(nonatomic,strong)UITableView              *tableView;
@property(nonatomic,strong)NSMutableArray           *tableArray;
@property(nonatomic,assign)CGRect                   keyboardRect;

@property(nonatomic,strong)UIView                   *emojiView;
@property(nonatomic,strong)UIImageView              *contentBtnView;
@property(nonatomic,strong)NSMutableDictionary      *dataPrivateDic;

@property(nonatomic,strong)UIButton                 *soundVideoBtn;
@property(nonatomic,strong)UIButton                 *selectRoadBtn;

@property(nonatomic,strong)UIButton                 *publicChatBtn;
@property(nonatomic,strong)UIButton                 *privateChatBtn;
@property(nonatomic,strong)UIButton                 *hideDanMuBtn;
@property(nonatomic,strong)UIButton                 *closeBtn;

@property(nonatomic,strong)CCPrivateChatView        *ccPrivateChatView;
@property(nonatomic,strong)ModelView                *modelView;
@property(nonatomic,strong)UIView                   *modeoCenterView;
@property(nonatomic,strong)UILabel                  *modeoCenterLabel;
@property(nonatomic,strong)UIButton                 *cancelBtn;
@property(nonatomic,strong)UIButton                 *sureBtn;
@property(nonatomic,strong)NSTimer                  *timer;
@property(nonatomic,strong)NSTimer                  *danMuTimer;
@property(nonatomic,strong)NSTimer                  *hiddenTimer;
@property(nonatomic,assign)NSTimeInterval           hiddenTime;

@property(nonatomic,strong)RequestData              *requestData;
@property(nonatomic,strong)LoadingView              *loadingView;

@property(nonatomic,assign)NSInteger                currentRoadNum;
@property(nonatomic,assign)NSInteger                currentSecRoadNum;
@property(nonatomic,strong)NSMutableArray           *secRoadKeyArray;

@property(nonatomic,strong)UIButton                 *yuanHuaBtn;
@property(nonatomic,strong)UIButton                 *qingXiBtn;
@property(nonatomic,strong)UIButton                 *liuChangBtn;
@property(nonatomic,strong)UIButton                 *mainRoad;
@property(nonatomic,strong)UIButton                 *secondRoad;

@property(nonatomic,copy)  NSString                 *viewerId;
@property(nonatomic,strong)NSMutableDictionary      *userDic;

@property(nonatomic,strong)UIImageView              *Rectangle44;
@property(nonatomic,strong)NSMutableArray           *array;
@property(assign,nonatomic)NSInteger                secondToEnd;
@property(assign,nonatomic)NSInteger                lineLimit;
@property(assign,nonatomic)BOOL                     isKeyBoardShow;

@property(nonatomic,strong)GongGaoView              *gongGaoView;
@property(nonatomic,copy)  NSString                 *gongGaoStr;

@end

@implementation PlayForMobileVC

//抽奖
-(void)loadLotteryView {
    
}

//签到
-(void)loadRollcallView {
    
}

//答题
-(void)loadVoteView {
    
}

-(instancetype)initWithLeftLabelText:(NSString *)leftLabelText isScreenLandScape:(BOOL)isScreenLandScape {
    self = [super init];
    if(self) {
        self.leftLabelText = leftLabelText;
        self.isScreenLandScape = isScreenLandScape;
    }
    return self;
}

-(void)dealloc {
    [self removeObserver];
}

-(NSMutableDictionary *)userDic {
    if(!_userDic) {
        _userDic = [[NSMutableDictionary alloc] init];
    }
    return _userDic;
}

-(UILabel *)userCountLabel {
    if(!_userCountLabel) {
        _userCountLabel = [UILabel new];
        _userCountLabel.text = @"1";
        _userCountLabel.textColor = [UIColor whiteColor];
        _userCountLabel.textAlignment = NSTextAlignmentLeft;
        if(self.isScreenLandScape) {
            _userCountLabel.font = [UIFont systemFontOfSize:FontSize_26];
        } else {
            _userCountLabel.font = [UIFont systemFontOfSize:FontSize_24];
        }
    }
    return _userCountLabel;
}

//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

-(void)hiddenAll {
    if(_isKeyBoardShow == YES || _loadingView) {
        _hiddenTime = 5.0f;
        return;
    }
    if(self.hiddenTime > 0.0f) {
        self.hiddenTime -= 1.0f;
    }
    if(self.isScreenLandScape && self.hiddenTime == 0) {
        self.daohangView.hidden = YES;
        self.contentView.hidden = YES;
        self.soundVideoBtn.hidden = YES;
        self.selectRoadBtn.hidden = YES;
        [self hiddenAllBtns];
    } else {
        
    }
}

-(void)showAll {
    self.hiddenTime = 5.0f;
    if(self.isScreenLandScape) {
        self.daohangView.hidden = NO;
        self.contentView.hidden = NO;
        self.soundVideoBtn.hidden = NO;
        self.selectRoadBtn.hidden = NO;
    }
}

-(void)startHiddenTimer {
    [self stopHiddenTimer];
    self.hiddenTime = 5.0f;
    self.hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(hiddenAll) userInfo:nil repeats:YES];
}

-(void)stopHiddenTimer {
    if([self.hiddenTimer isValid]) {
        [self.hiddenTimer invalidate];
        self.hiddenTimer = nil;
    }
}

-(void)initUI {
    if(self.isScreenLandScape) {
        WS(ws)
        [self.view addSubview:self.daohangView];
        [_daohangView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(64);
        }];
        
        [self.daohangView addSubview:self.leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.daohangView).offset(CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.daohangView).offset(-CCGetRealFromPt(25));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(37), CCGetRealFromPt(37)));
        }];
        
        [self.daohangView addSubview:self.leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.leftButton.mas_right).offset(CCGetRealFromPt(10));
            make.centerY.mas_equalTo(ws.leftButton);
            make.size.mas_equalTo(CGSizeMake(ws.view.frame.size.width * 0.5, CCGetRealFromPt(30)));
        }];
        [self.daohangView addSubview:self.userCountLogo];
        [_userCountLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.daohangView).offset(-CCGetRealFromPt(358));
            make.bottom.mas_equalTo(ws.daohangView).offset(-CCGetRealFromPt(26));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(36), CCGetRealFromPt(36)));
        }];
        
        [self.daohangView addSubview:self.gongGaoBtn];
        [_gongGaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.daohangView).offset(-CCGetRealFromPt(43));
            make.bottom.mas_equalTo(ws.daohangView).offset(-CCGetRealFromPt(25));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(67), CCGetRealFromPt(38)));
        }];
        
        [self.daohangView addSubview:self.qingXiDuBtn];
        [_qingXiDuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.gongGaoBtn.mas_left).offset(-CCGetRealFromPt(52));
            make.bottom.mas_equalTo(ws.gongGaoBtn);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(86), CCGetRealFromPt(28)));
        }];
        
        [self.daohangView addSubview:self.userCountLabel];
        [_userCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.userCountLogo.mas_right).offset(CCGetRealFromPt(6));
            make.right.mas_equalTo(ws.qingXiDuBtn.mas_left);
            make.bottom.and.top.mas_equalTo(ws.qingXiDuBtn);
        }];
        
        [self.daohangView addSubview:self.gongGaoDot];
        [_gongGaoDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.gongGaoBtn.mas_right);
            make.bottom.mas_equalTo(ws.daohangView).offset(-CCGetRealFromPt(46));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(12), CCGetRealFromPt(12)));
        }];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealSingleTap:)];
        [self.view addGestureRecognizer:singleTap];
        
        [self.view addSubview:self.soundVideoBtn];
        [_soundVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.view).offset(-CCGetRealFromPt(30));
            make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(270));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(70),CCGetRealFromPt(70)));
        }];
        
        [self.view addSubview:self.selectRoadBtn];
        [_selectRoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.soundVideoBtn);
            make.top.mas_equalTo(ws.soundVideoBtn.mas_bottom).offset(CCGetRealFromPt(56));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(70),CCGetRealFromPt(70)));
        }];
        
        [self.view addSubview:self.yuanHuaBtn];
        [_yuanHuaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws.qingXiDuBtn);
            make.top.mas_equalTo(ws.daohangView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(166),CCGetRealFromPt(70)));
        }];
        _yuanHuaBtn.selected = YES;
        
        [self.view addSubview:self.qingXiBtn];
        [_qingXiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws.yuanHuaBtn);
            make.top.mas_equalTo(ws.yuanHuaBtn.mas_bottom);
            make.size.mas_equalTo(ws.yuanHuaBtn);
        }];
        
        [self.view addSubview:self.liuChangBtn];
        [_liuChangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws.qingXiBtn);
            make.top.mas_equalTo(ws.qingXiBtn.mas_bottom);
            make.size.mas_equalTo(ws.qingXiBtn);
        }];
        
        [self.view addSubview:self.mainRoad];
        [_mainRoad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.selectRoadBtn.mas_left).offset(-CCGetRealFromPt(14));
            make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(396));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(190), CCGetRealFromPt(60)));
        }];
        
        UIImageView *imageRight1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_btn_select"]];
        imageRight1.contentMode = UIViewContentModeScaleAspectFit;
        imageRight1.tag = 1;
        [self.mainRoad addSubview:imageRight1];
        [imageRight1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.mainRoad).offset(-CCGetRealFromPt(20));
            make.centerY.mas_equalTo(ws.mainRoad);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(31), CCGetRealFromPt(22)));
        }];
        
        [self.view addSubview:self.secondRoad];
        [_secondRoad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.mainRoad);
            make.top.mas_equalTo(ws.mainRoad.mas_bottom);
            make.size.mas_equalTo(ws.mainRoad);
        }];
        
        UIImageView *imageRight2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_btn_select"]];
        imageRight2.contentMode = UIViewContentModeScaleAspectFit;
        imageRight2.tag = 1;
        [self.secondRoad addSubview:imageRight2];
        [imageRight2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.secondRoad).offset(-CCGetRealFromPt(20));
            make.centerY.mas_equalTo(ws.secondRoad);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(31), CCGetRealFromPt(22)));
        }];
        imageRight2.hidden = YES;
        
        [self.view addSubview:self.soundBg];
        [_soundBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(239));
            make.centerX.mas_equalTo(ws.view);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(746), CCGetRealFromPt(220)));
        }];
    
        [self.view addSubview:self.soundLabel];
        [_soundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.soundBg.mas_bottom).offset(CCGetRealFromPt(20));
            make.centerX.mas_equalTo(ws.view);
            make.size.mas_equalTo(CGSizeMake(ws.view.frame.size.width, CCGetRealFromPt(32)));
        }];
        self.soundBg.hidden = YES;
        self.soundLabel.hidden = YES;
        
        [self.view addSubview:self.contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(110));
        }];
        
        [self.contentView addSubview:self.danMuButton];
        [_danMuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws.contentView.mas_centerY);
            make.left.mas_equalTo(ws.contentView).offset(CCGetRealFromPt(30));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(90), CCGetRealFromPt(50)));
        }];
        
        [self.contentView addSubview:self.chatTextField];
        [_chatTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws.contentView.mas_centerY);
            make.left.mas_equalTo(ws.danMuButton.mas_right).offset(CCGetRealFromPt(22));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(1024), CCGetRealFromPt(84)));
        }];
        
        [self.contentView addSubview:self.sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws.contentView.mas_centerY);
            make.left.mas_equalTo(ws.chatTextField.mas_right).offset(CCGetRealFromPt(20));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(120), CCGetRealFromPt(84)));
        }];
    } else {
        WS(ws)
        [self.view addSubview:self.contentBtnView];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.gongGaoBtn];
        [self.contentBtnView addSubview:self.publicChatBtn];
        [self.contentBtnView addSubview:self.privateChatBtn];
        [self.contentBtnView addSubview:self.selectRoadBtn];
        [self.contentBtnView addSubview:self.hideDanMuBtn];
        [self.contentBtnView addSubview:self.closeBtn];
        [self.view addSubview:self.Rectangle44];
        [self.view addSubview:self.ccPrivateChatView];
        
        [self.ccPrivateChatView setCheckDotBlock1:^(BOOL flag) {
            ws.privateChatBtn.selected = flag;
        }];
        
        [_ccPrivateChatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(542));
            make.bottom.mas_equalTo(ws.view).offset(CCGetRealFromPt(542));
        }];
        
        [_gongGaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
            make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(86));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(186), CCGetRealFromPt(50)));
        }];

        _gongGaoBtn.layer.cornerRadius = CCGetRealFromPt(50) / 2;
        _gongGaoBtn.layer.masksToBounds = YES;
        
        UILabel *label = [UILabel new];
        label.text = @"直播间公告";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:FontSize_24];
        [self.gongGaoBtn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.gongGaoBtn).offset(CCGetRealFromPt(10));
            make.right.mas_equalTo(ws.gongGaoBtn).offset(-CCGetRealFromPt(34));
            make.top.and.bottom.mas_equalTo(ws.gongGaoBtn);
        }];
        label.userInteractionEnabled = NO;
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"arrow"];
        imageView.backgroundColor = CCClearColor;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.gongGaoBtn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right);
            make.centerY.mas_equalTo(label);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(14), CCGetRealFromPt(26)));
        }];
        imageView.userInteractionEnabled = NO;
        
        UIImageView *people = [UIImageView new];
        people.image = [UIImage imageNamed:@"people"];
        people.backgroundColor = CCClearColor;
        people.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:people];
        [people mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(46));
            make.top.mas_equalTo(ws.gongGaoBtn.mas_bottom).offset(CCGetRealFromPt(10));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(37), CCGetRealFromPt(37)));
        }];
        
        [self.view addSubview:self.userCountLabel];
        [_userCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(people.mas_right).offset(CCGetRealFromPt(9));
            make.top.mas_equalTo(ws.gongGaoBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(ws.view.frame.size.width / 2), CCGetRealFromPt(56)));
        }];
        
        [self.gongGaoBtn addSubview:self.gongGaoDot];
        [_gongGaoDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.gongGaoBtn).offset(CCGetRealFromPt(137));
            make.top.mas_equalTo(ws.gongGaoBtn).offset(CCGetRealFromPt(9));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(12), CCGetRealFromPt(12)));
        }];
        
        [_contentBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(130));
        }];
        
        [_publicChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.contentBtnView).offset(CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.contentBtnView).offset(-CCGetRealFromPt(28));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(75), CCGetRealFromPt(74)));
        }];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.contentBtnView).offset(-CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.contentBtnView).offset(-CCGetRealFromPt(25));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(80), CCGetRealFromPt(80)));
        }];
        
        [_hideDanMuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.closeBtn.mas_left).offset(-CCGetRealFromPt(20));
            make.bottom.mas_equalTo(ws.closeBtn);
            make.size.mas_equalTo(ws.closeBtn);
        }];
        
        [_selectRoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.hideDanMuBtn.mas_left).offset(-CCGetRealFromPt(20));
            make.bottom.mas_equalTo(ws.hideDanMuBtn);
            make.size.mas_equalTo(ws.hideDanMuBtn);
        }];
        
        [_privateChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.selectRoadBtn.mas_left).offset(-CCGetRealFromPt(20));
            make.bottom.mas_equalTo(ws.selectRoadBtn);
            make.size.mas_equalTo(ws.selectRoadBtn);
        }];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.contentBtnView.mas_top);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
        }];
        
        [self.view addSubview:self.contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(110));
        }];
        
        [self.contentView addSubview:self.chatTextField];
        [_chatTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws.contentView.mas_centerY);
            make.left.mas_equalTo(ws.contentView).offset(CCGetRealFromPt(24));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(556), CCGetRealFromPt(84)));
        }];
        
        [self.contentView addSubview:self.sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws.contentView.mas_centerY);
            make.right.mas_equalTo(ws.contentView).offset(-CCGetRealFromPt(24));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(120), CCGetRealFromPt(84)));
        }];
        self.contentView.hidden = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealSingleTap:)];
        [self.view addGestureRecognizer:singleTap];
        
        [_Rectangle44 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws.selectRoadBtn.mas_centerX);
            make.bottom.mas_equalTo(ws.selectRoadBtn.mas_top).offset(-CCGetRealFromPt(23));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(190), CCGetRealFromPt(201)));
        }];
        
        [self.Rectangle44 addSubview:self.mainRoad];
        [_mainRoad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws.Rectangle44.mas_centerX);
            make.top.mas_equalTo(ws.Rectangle44).offset(CCGetRealFromPt(44));
            make.width.mas_equalTo(ws.Rectangle44);
            make.height.mas_equalTo(CCGetRealFromPt(28));
        }];
        
        UIImageView *imageRight1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_btn_select"]];
        imageRight1.contentMode = UIViewContentModeScaleAspectFit;
        imageRight1.tag = 1;
        [self.mainRoad addSubview:imageRight1];
        [imageRight1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.mainRoad).offset(-CCGetRealFromPt(20));
            make.centerY.mas_equalTo(ws.mainRoad);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(31), CCGetRealFromPt(22)));
        }];
        
        [self.Rectangle44 addSubview:self.secondRoad];
        [_secondRoad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws.Rectangle44.mas_centerX);
            make.bottom.mas_equalTo(ws.Rectangle44).offset(-CCGetRealFromPt(55));
            make.width.mas_equalTo(ws.Rectangle44);
            make.height.mas_equalTo(CCGetRealFromPt(28));
        }];
        
        UIImageView *imageRight2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_btn_select"]];
        imageRight2.contentMode = UIViewContentModeScaleAspectFit;
        imageRight2.tag = 1;
        [self.secondRoad addSubview:imageRight2];
        [imageRight2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.secondRoad).offset(-CCGetRealFromPt(20));
            make.centerY.mas_equalTo(ws.secondRoad);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(31), CCGetRealFromPt(22)));
        }];
        imageRight2.hidden = YES;
    }
}

-(UIImageView *)Rectangle44 {
    if(!_Rectangle44) {
        _Rectangle44 = [UIImageView new];
        _Rectangle44.image = [UIImage imageNamed:@"Rectangle44"];
        _Rectangle44.backgroundColor = CCClearColor;
        _Rectangle44.contentMode = UIViewContentModeScaleAspectFit;
        _Rectangle44.userInteractionEnabled = YES;
    }
    return _Rectangle44;
}

-(UIButton *)publicChatBtn {
    if(!_publicChatBtn) {
        _publicChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publicChatBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_publicChatBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_chat_nor"] forState:UIControlStateNormal];
        [_publicChatBtn addTarget:self action:@selector(publicChatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publicChatBtn;
}

-(void)publicChatBtnClicked {
    [_chatTextField becomeFirstResponder];
}

-(UIButton *)privateChatBtn {
    if(!_privateChatBtn) {
        _privateChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_privateChatBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_privateChatBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_news_nor"] forState:UIControlStateNormal];
        [_privateChatBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_newsmsg_nor"] forState:UIControlStateSelected];
        [_privateChatBtn addTarget:self action:@selector(privateChatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privateChatBtn;
}

-(UIButton *)hideDanMuBtn {
    if(!_hideDanMuBtn) {
        _hideDanMuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hideDanMuBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_hideDanMuBtn setBackgroundImage:[UIImage imageNamed:@"notice_ic_barrage_nor"] forState:UIControlStateNormal];
        [_hideDanMuBtn setBackgroundImage:[UIImage imageNamed:@"notice_ic_barrage_ban"] forState:UIControlStateSelected];
        [_hideDanMuBtn addTarget:self action:@selector(hideDanMuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideDanMuBtn;
}

-(void)hideDanMuBtnClicked {
    BOOL selected = _hideDanMuBtn.selected;
    _hideDanMuBtn.selected = !selected;
    
    _tableView.hidden = _hideDanMuBtn.selected;
}

-(void)privateChatBtnClicked {
    WS(ws)
    if(!self.isScreenLandScape) {
        [self hiddenAll];
        [_ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(542));
            make.bottom.mas_equalTo(ws.view);
        }];
    } else {
        _Rectangle44.hidden = YES;
        [_ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(444));
            make.bottom.mas_equalTo(ws.view);
        }];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        [ws.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

-(UIButton *)closeBtn {
    if(!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"home_ic_close_nor"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(void)closeBtnClicked {
    [self.view addSubview:self.modelView];
    WS(ws)
    [_modelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.view);
    }];
    [_modelView addSubview:self.modeoCenterView];
    [_modeoCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(!ws.isScreenLandScape) {
            make.top.mas_equalTo(ws.modelView).offset(CCGetRealFromPt(390));
        } else {
            make.centerY.mas_equalTo(ws.modelView.mas_centerY);
        }
        make.centerX.mas_equalTo(ws.modelView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(500), CCGetRealFromPt(250)));
    }];
    [_modeoCenterView addSubview:self.cancelBtn];
    [_modeoCenterView addSubview:self.sureBtn];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(ws.modeoCenterView);
        make.height.mas_equalTo(CCGetRealFromPt(100));
        make.right.mas_equalTo(ws.sureBtn.mas_left);
        make.width.mas_equalTo(ws.sureBtn.mas_width);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(ws.modeoCenterView);
        make.height.mas_equalTo(ws.cancelBtn);
        make.left.mas_equalTo(ws.cancelBtn.mas_right);
        make.width.mas_equalTo(ws.cancelBtn.mas_width);
    }];
    
    [_modelView addSubview:self.modeoCenterLabel];
    [_modeoCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(ws.modeoCenterView);
        make.bottom.mas_equalTo(ws.sureBtn.mas_top);
    }];
    
    UIView *lineCross = [UIView new];
    lineCross.backgroundColor = CCRGBColor(221,221,221);
    [_modeoCenterView addSubview:lineCross];
    [lineCross mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.modeoCenterView);
        make.bottom.mas_equalTo(ws.cancelBtn.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    UIView *lineVertical = [UIView new];
    lineVertical.backgroundColor = CCRGBColor(221,221,221);
    [_modeoCenterView addSubview:lineVertical];
    [lineVertical mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.cancelBtn.mas_right);
        make.top.mas_equalTo(lineCross.mas_bottom);
        make.bottom.mas_equalTo(ws.cancelBtn.mas_bottom);
        make.width.mas_equalTo(1);
    }];
}

-(void)sureBtnClicked {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self removeObserver];
    [self.modelView removeFromSuperview];
    [self stopTimer];
    [self stopHiddenTimer];
    [self dismissViewControllerAnimated:YES completion:^ {
        
    }];
}

-(void) stopTimer {
    if([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)startTimer {
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerfunc) userInfo:nil repeats:YES];
}

-(void)cancelBtnClicked {
    [self.modelView removeFromSuperview];
}

- (void)timerfunc {
    [_requestData roomUserCount];
}

-(UILabel *)modeoCenterLabel {
    if(!_modeoCenterLabel) {
        _modeoCenterLabel = [UILabel new];
        _modeoCenterLabel.font = [UIFont systemFontOfSize:FontSize_30];
        _modeoCenterLabel.textAlignment = NSTextAlignmentCenter;
        _modeoCenterLabel.textColor = CCRGBColor(51,51,51);
        _modeoCenterLabel.text = @"您确认结束直播吗？";
    }
    return _modeoCenterLabel;
}

-(CCPrivateChatView *)ccPrivateChatView {
    if(!_ccPrivateChatView) {
        WS(ws)
        _ccPrivateChatView = [[CCPrivateChatView alloc] initWithCloseBlock:^{
            [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(ws.view);
                make.height.mas_equalTo(CCGetRealFromPt(542));
                make.bottom.mas_equalTo(ws.view).offset(CCGetRealFromPt(542));
            }];
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if(ws.ccPrivateChatView.privateChatViewForOne) {
                    [ws.ccPrivateChatView.privateChatViewForOne removeFromSuperview];
                    ws.ccPrivateChatView.privateChatViewForOne = nil;
                }
            }];
        } isResponseBlock:^(CGFloat y) {
            NSLog(@"PushViewController isResponseBlock y = %f",y);
            if(!ws.isScreenLandScape) {
                [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(ws.view);
                    make.height.mas_equalTo(CCGetRealFromPt(542));
                    make.bottom.mas_equalTo(ws.view).mas_offset(-y);
                }];
            } else {
                [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(ws.view);
                    make.height.mas_equalTo(ws.view.frame.size.height-_keyboardRect.size.height);
                    make.bottom.mas_equalTo(ws.view).offset(-_keyboardRect.size.height);
                }];
            }
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        } isNotResponseBlock:^{
            if(!ws.isScreenLandScape) {
                [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(ws.view);
                    make.height.mas_equalTo(CCGetRealFromPt(542));
                    make.bottom.mas_equalTo(ws.view);
                }];
            } else {
                [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(ws.view);
                    make.height.mas_equalTo(CCGetRealFromPt(444));
                    make.bottom.mas_equalTo(ws.view);
                }];
            }
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }  dataPrivateDic:[self.dataPrivateDic copy] isScreenLandScape:_isScreenLandScape];
    }
    return _ccPrivateChatView;
}

-(NSDictionary *)dataPrivateDic {
    if(!_dataPrivateDic) {
        _dataPrivateDic = [[NSMutableDictionary alloc] init];
    }
    return _dataPrivateDic;
}

-(CGSize)getTitleSizeByFont:(NSString *)str font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(20000.0f, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _currentRoadNum = 0;
    _currentSecRoadNum = 0;
    _isKeyBoardShow = NO;
    
    [self addObserver];
    [self initUI];
    [self hiddenAllBtns];
    if(self.isScreenLandScape) {
        [self startDanMuTimer];
        _secondToEnd = 8.0f;
    }
    CGRect rect = CGRectZero;
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(self.isScreenLandScape) {
        rect = CGRectMake(0, 0, height, width);
        _lineLimit = (self.view.frame.size.height - 64) / (IMGWIDTH * 1.5);
    } else {
        rect = self.view.frame;
    }
//    PlayParameter *parameter = [[PlayParameter alloc] init];
//    parameter.userId = GetFromUserDefaults(WATCH_USERID);
//    parameter.roomId = GetFromUserDefaults(WATCH_ROOMID);
//    parameter.viewerName = GetFromUserDefaults(WATCH_USERNAME);
//    parameter.token = GetFromUserDefaults(WATCH_PASSWORD);
//    parameter.docParent = self.pptView;
//    parameter.docFrame = self.pptView.frame;
//    parameter.playerParent = self.videoView;
//    parameter.playerFrame = _videoRect;
//    parameter.security = YES;
//    parameter.scalingMode = 3;
//    parameter.viewercustomua = @"viewercustomua";
//    _requestData = [[RequestData alloc] initWithParameter:parameter];
//    _requestData.delegate = self;
    
    _loadingView = [[LoadingView alloc] initWithLabel:@"视频加载中" centerY:YES];
    [self.view addSubview:_loadingView];
    
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
    [_loadingView layoutIfNeeded];
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
//    switch (_requestData.playState)
//    {
//        case MoviePlayStateStopped: {
//            break;
//        }
//        case MoviePlayStatePlaying: {
//            [_loadingView removeFromSuperview];
//            _loadingView = nil;
//            break;
//        }
//        case MoviePlayStatePaused: {
//            break;
//        }
//        case MoviePlayStateInterrupted: {
//            break;
//        }
//        case MoviePlayStateSeekingForward:
//        case MoviePlayStateSeekingBackward: {
//            break;
//        }
//        default: {
//            break;
//        }
//    }
}

- (void)dealSingleTap:(UITapGestureRecognizer *)tap {
    if(self.isScreenLandScape) {
        CGPoint point = [tap locationInView:self.view];
        if(_contentBtnView.hidden == NO && CGRectContainsPoint(_contentBtnView.frame, point)) {
            return;
        } else if (_daohangView.hidden == NO && CGRectContainsPoint(_daohangView.frame, point)) {
            return;
        } else if(_gongGaoView) {
            return;
        }
        
        [self hiddenAllBtns];
        if([self.chatTextField isFirstResponder]) {
            [self.chatTextField resignFirstResponder];
        } else {
            if(self.daohangView.hidden == YES) {
                self.hiddenTime = 5.0f;
                [self showAll];
            } else {
                self.hiddenTime = 0.0f;
                [self hiddenAll];
            }
        }
    } else {
//        [self hiddenAll];
        _Rectangle44.hidden = YES;
        [_chatTextField resignFirstResponder];
        [_ccPrivateChatView.privateChatViewForOne.chatTextField resignFirstResponder];
        WS(ws)
        
        [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(542));
            make.bottom.mas_equalTo(ws.view).offset(CCGetRealFromPt(542));
        }];
        
        [UIView animateWithDuration:0.25f animations:^{
            [ws.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if(ws.ccPrivateChatView.privateChatViewForOne) {
                [ws.ccPrivateChatView.privateChatViewForOne removeFromSuperview];
                ws.ccPrivateChatView.privateChatViewForOne = nil;
            }
        }];
    }
}

-(UIImageView *)soundBg {
    if(!_soundBg) {
        _soundBg = [[UIImageView alloc] init];
        _soundBg.image = [UIImage imageNamed:@"video_img_sound"];
        _soundBg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _soundBg;
}

-(UIImageView *)daohangView {
    if(!_daohangView) {
        _daohangView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"daohang"]];
        _daohangView.userInteractionEnabled = YES;
        _daohangView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _daohangView;
}

-(UILabel *)leftLabel {
    if(!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.text = _leftLabelText;
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.font = [UIFont systemFontOfSize:FontSize_30];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftLabel;
}

-(UIButton *)leftButton {
    if(!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.backgroundColor = CCClearColor;
        [_leftButton addTarget:self action:@selector(onSelectVC) forControlEvents:UIControlEventTouchUpInside];
        UIImage *aimage = [UIImage imageNamed:@"nav_ic_back_nor"];
        UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_leftButton setImage:image forState:UIControlStateNormal];
        _leftButton.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftButton;
}

-(CGSize)getTitleSizeByFont:(NSString *)str width:(CGFloat)width font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

- (UIImage*)createImageWithColor: (UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIImageView *)userCountLogo {
    if(!_userCountLogo) {
        _userCountLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_dis_people"]];
        _userCountLogo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _userCountLogo;
}

-(UIButton *)gongGaoBtn {
    if(!_gongGaoBtn) {
        _gongGaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(self.isScreenLandScape) {
            [_gongGaoBtn setTitle:@"公告" forState:UIControlStateNormal];
            [_gongGaoBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_28]];
            [_gongGaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_gongGaoBtn setBackgroundColor:CCClearColor];
        } else {
            _gongGaoBtn.layer.backgroundColor = [CCRGBAColor(0, 0, 0, 0.3) CGColor];
        }
        [_gongGaoBtn addTarget:self action:@selector(gongGaoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gongGaoBtn;
}

-(UIButton *)qingXiDuBtn {
    if(!_qingXiDuBtn) {
        _qingXiDuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qingXiDuBtn setTitle:@"清晰度" forState:UIControlStateNormal];
        [_qingXiDuBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_28]];
        [_qingXiDuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_qingXiDuBtn addTarget:self action:@selector(qingXiDuAction) forControlEvents:UIControlEventTouchUpInside];
        [_qingXiDuBtn setBackgroundColor:CCClearColor];
    }
    return _qingXiDuBtn;
}

-(UIImageView *)gongGaoDot {
    if(!_gongGaoDot) {
        _gongGaoDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_btn_msg"]];
        _gongGaoDot.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _gongGaoDot;
}

-(UILabel *)soundLabel {
    if(!_soundLabel) {
        _soundLabel = [UILabel new];
        _soundLabel.backgroundColor = CCClearColor;
        _soundLabel.textColor = CCRGBAColor(255,255,255,0.5);
        _soundLabel.textAlignment = NSTextAlignmentCenter;
        _soundLabel.font = [UIFont systemFontOfSize:FontSize_32];
        _soundLabel.text = @"音频模式";
    }
    return _soundLabel;
}

///////////////////////////////////////////////////////////////////////////////

-(void)addObserver {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:)
//                                                 name:CCMoviePlayStateChangedNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(privateChat:)
//                                                 name:@"private_Chat"
//                                               object:nil];
    
}

-(void)removeObserver {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:CCMoviePlayStateChangedNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"private_Chat"
//                                                  object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self chatSendMessage];
    return YES;
}

-(void)chatSendMessage {
    NSString *str = _chatTextField.text;
    if(str == nil || str.length == 0) {
        return;
    }
    
    [_requestData chatMessage:str];

    _chatTextField.text = nil;
    [_chatTextField resignFirstResponder];
}

#pragma mark keyboard notification
- (void)keyboardWillShow:(NSNotification *)notif {
    if(![self.chatTextField isFirstResponder]) {
        return;
    }
    
    NSDictionary *userInfo = [notif userInfo];
    _isKeyBoardShow = YES;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyboardRect = [aValue CGRectValue];
    CGFloat y = _keyboardRect.size.height;
    CGFloat x = _keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",(int)y);
    NSLog(@"键盘宽度是  %d",(int)x);
    if(!self.isScreenLandScape) {
        if ([self.chatTextField isFirstResponder]) {
            self.contentView.hidden = NO;
            self.contentBtnView.hidden = YES;
            WS(ws)
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(ws.view);
                make.bottom.mas_equalTo(ws.view).offset(-y);
                make.height.mas_equalTo(CCGetRealFromPt(110));
            }];
            
            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
                make.bottom.mas_equalTo(ws.contentView.mas_top);
                make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
            }];
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
    } else {
        if ([self.chatTextField isFirstResponder]) {
            WS(ws)
            [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(ws.view);
                make.bottom.mas_equalTo(ws.view).offset(-y);
                make.height.mas_equalTo(CCGetRealFromPt(110));
            }];
            
            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
                make.bottom.mas_equalTo(ws.contentView.mas_top);
                make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(700),CCGetRealFromPt(300)));
            }];
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    WS(ws)
    _isKeyBoardShow = NO;
    if(!self.isScreenLandScape) {
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(110));
        }];
        
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.contentBtnView.mas_top);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
        }];
        
        [UIView animateWithDuration:0.25f animations:^{
            self.contentView.hidden = YES;
            self.contentBtnView.hidden = NO;
            [ws.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(110));
        }];
        
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(30));
            make.bottom.mas_equalTo(ws.contentView.mas_top);
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(700),CCGetRealFromPt(300)));
        }];
        [UIView animateWithDuration:0.25f animations:^{
            [ws.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(UIView *)contentView {
    if(!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = CCRGBAColor(171,179,189,0.30);
    }
    return _contentView;
}

-(CustomTextField *)chatTextField {
    if(!_chatTextField) {
        _chatTextField = [CustomTextField new];
        _chatTextField.delegate = self;
        [_chatTextField addTarget:self action:@selector(chatTextFieldChange) forControlEvents:UIControlEventEditingChanged];
        _chatTextField.rightView = self.rightView;
    }
    return _chatTextField;
}

-(void)chatTextFieldChange {
    if(_chatTextField.text.length > 300) {
//        [self.view endEditing:YES];
        _chatTextField.text = [_chatTextField.text substringToIndex:300];
        InformationShowView *informationView = [[InformationShowView alloc] initWithLabel:@"输入限制在300个字符以内"];
        [APPDelegate.window addSubview:informationView];
        [informationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 200, 0));
        }];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
            [informationView removeFromSuperview];
        }];
    }
}

-(UIButton *)rightView {
    if(!_rightView) {
        _rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightView.frame = CGRectMake(0, 0, CCGetRealFromPt(48), CCGetRealFromPt(48));
        _rightView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightView.backgroundColor = CCClearColor;
        [_rightView setImage:[UIImage imageNamed:@"chat_ic_face_nor"] forState:UIControlStateNormal];
        [_rightView setImage:[UIImage imageNamed:@"chat_ic_face_hov"] forState:UIControlStateSelected];
        [_rightView addTarget:self action:@selector(faceBoardClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightView;
}

- (void)faceBoardClick {
    BOOL selected = !_rightView.selected;
    _rightView.selected = selected;
    
    if(selected) {
        [_chatTextField setInputView:self.emojiView];
    } else {
        [_chatTextField setInputView:nil];
    }
    
    [_chatTextField becomeFirstResponder];
    [_chatTextField reloadInputViews];
}

-(UIButton *)sendButton {
    if(!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.backgroundColor = CCRGBColor(255,102,51);
        _sendButton.layer.cornerRadius = CCGetRealFromPt(4);
        _sendButton.layer.masksToBounds = YES;
        _sendButton.layer.borderColor = [CCRGBColor(255,71,0) CGColor];
        _sendButton.layer.borderWidth = 1;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:CCRGBColor(255,255,255) forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:FontSize_32]];
        [_sendButton addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

-(UIButton *)danMuButton {
    if(!_danMuButton) {
        _danMuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_danMuButton setBackgroundImage:[UIImage imageNamed:@"video_btn_word_off"] forState:UIControlStateNormal];
        [_danMuButton setBackgroundImage:[UIImage imageNamed:@"video_btn_word_on"] forState:UIControlStateSelected];
        [_danMuButton addTarget:self action:@selector(danMuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danMuButton;
}

-(void)danMuBtnClicked {
    BOOL selected = [_danMuButton isSelected];
    _danMuButton.selected = !selected;
}

-(void)sendBtnClicked {
    if(!StrNotEmpty([_chatTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])) {
        InformationShowView *informationView = [[InformationShowView alloc] initWithLabel:@"发送内容为空"];
        [APPDelegate.window addSubview:informationView];
        [informationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 200, 0));
        }];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
            [informationView removeFromSuperview];
        }];
        return;
    }
    [self chatSendMessage];
    _chatTextField.text = nil;
    [_chatTextField resignFirstResponder];
}

-(UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.backgroundColor = [UIColor grayColor];
    }
    return _tableView;
}

-(NSMutableArray *)tableArray {
    if(!_tableArray) {
        _tableArray = [[NSMutableArray alloc] init];
    }
    return _tableArray;
}

-(UIView *)emojiView {
    if(!_emojiView) {
        if(_keyboardRect.size.width == 0 || _keyboardRect.size.height ==0) {
            _keyboardRect = CGRectMake(0, 0, 414, 271);
        }
        _emojiView = [[UIView alloc] initWithFrame:_keyboardRect];
        _emojiView.backgroundColor = CCRGBColor(242,239,237);
        
        CGFloat faceIconSize = CCGetRealFromPt(60);
        CGFloat xspace = (_keyboardRect.size.width - FACE_COUNT_CLU * faceIconSize) / (FACE_COUNT_CLU + 1);
        CGFloat yspace = (_keyboardRect.size.height - 26 - FACE_COUNT_ROW * faceIconSize) / (FACE_COUNT_ROW + 1);
        
        for (int i = 0; i < FACE_COUNT_ALL; i++) {
            UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            faceButton.tag = i + 1;
            
            [faceButton addTarget:self action:@selector(faceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //            计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = (i % FACE_COUNT_CLU + 1) * xspace + (i % FACE_COUNT_CLU) * faceIconSize;
            CGFloat y = (i / FACE_COUNT_CLU + 1) * yspace + (i / FACE_COUNT_CLU) * faceIconSize;
            
            faceButton.frame = CGRectMake(x, y, faceIconSize, faceIconSize);
            faceButton.backgroundColor = CCClearColor;
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%02d", i+1]]
                        forState:UIControlStateNormal];
            faceButton.contentMode = UIViewContentModeScaleAspectFit;
            [_emojiView addSubview:faceButton];
        }
        //删除键
        UIButton *button14 = (UIButton *)[_emojiView viewWithTag:14];
        UIButton *button20 = (UIButton *)[_emojiView viewWithTag:20];
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.contentMode = UIViewContentModeScaleAspectFit;
        [back setImage:[UIImage imageNamed:@"chat_btn_facedel"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        [_emojiView addSubview:back];
        
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(button14);
            make.centerY.mas_equalTo(button20);
        }];
    }
    return _emojiView;
}

- (void) backFace {
    NSString *inputString = _chatTextField.text;
    if ( [inputString length] > 0) {
        NSString *string = nil;
        NSInteger stringLength = [inputString length];
        if (stringLength >= FACE_NAME_LEN) {
            string = [inputString substringFromIndex:stringLength - FACE_NAME_LEN];
            NSRange range = [string rangeOfString:FACE_NAME_HEAD];
            if ( range.location == 0 ) {
                string = [inputString substringToIndex:[inputString rangeOfString:FACE_NAME_HEAD options:NSBackwardsSearch].location];
            } else {
                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        else {
            string = [inputString substringToIndex:stringLength - 1];
        }
        _chatTextField.text = string;
    }
}

- (void)faceButtonClicked:(id)sender {
    NSInteger i = ((UIButton*)sender).tag;
    
    NSMutableString *faceString = [[NSMutableString alloc]initWithString:_chatTextField.text];
    [faceString appendString:[NSString stringWithFormat:@"[em2_%02d]",(int)i]];
    _chatTextField.text = faceString;
}

-(UIImageView *)contentBtnView {
    if(!_contentBtnView) {
        _contentBtnView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle"]];
        _contentBtnView.userInteractionEnabled = YES;
        _contentBtnView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentBtnView;
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isScreenLandScape) {
        [self hiddenAll];
    } else {
        _Rectangle44.hidden = YES;
    }
    [self.chatTextField resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellPlayForMobileVC";
    
    Dialogue *dialogue = [_tableArray objectAtIndex:indexPath.row];
    
    WS(ws)
    CCPublicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CCPublicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier dialogue:dialogue antesomeone:^(NSString *antename, NSString *anteid) {
            [ws.chatTextField resignFirstResponder];
            NSMutableArray *array = [ws.dataPrivateDic objectForKey:anteid];
            
            NSString *userName = nil;
            NSRange range = [dialogue.username rangeOfString:@": "];
            if(range.location != NSNotFound) {
                userName = [dialogue.username substringToIndex:range.location];
            } else {
                userName = dialogue.username;
            }
            
            CCLog(@"111 anteid = %@",dialogue.userid);
            
            [self.ccPrivateChatView createPrivateChatViewForOne:[array copy] anteid:dialogue.userid  anteName:userName];
            [self privateChatBtnClicked];
        }];
    } else {
        [cell reloadWithDialogue:dialogue antesomeone:^(NSString *antename, NSString *anteid) {
            [ws.chatTextField resignFirstResponder];
            
            NSMutableArray *array = [ws.dataPrivateDic objectForKey:anteid];
            
            NSString *userName = nil;
            NSRange range = [dialogue.username rangeOfString:@": "];
            if(range.location != NSNotFound) {
                userName = [dialogue.username substringToIndex:range.location];
            } else {
                userName = dialogue.username;
            }
            
            CCLog(@"111 anteid = %@",dialogue.userid);
            
            [self.ccPrivateChatView createPrivateChatViewForOne:[array copy] anteid:dialogue.userid anteName:userName];
            [self privateChatBtnClicked];
        }];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CCGetRealFromPt(26);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, CCGetRealFromPt(26))];
    view.backgroundColor = CCClearColor;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Dialogue *dialogue = [self.tableArray objectAtIndex:indexPath.row];
    return dialogue.msgSize.height + 10;
}

-(UIButton *)soundVideoBtn {
    if(!_soundVideoBtn) {
        _soundVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_soundVideoBtn setBackgroundImage:[UIImage imageNamed:@"video_ic_live_nor"] forState:UIControlStateNormal];
        [_soundVideoBtn setBackgroundImage:[UIImage imageNamed:@"video_ic_live_hov"] forState:UIControlStateSelected];
        [_soundVideoBtn addTarget:self action:@selector(soundVideoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _soundVideoBtn;
}

-(UIButton *)selectRoadBtn {
    if(!_selectRoadBtn) {
        _selectRoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(self.isScreenLandScape) {
            [_selectRoadBtn setBackgroundImage:[UIImage imageNamed:@"video_ic_line"] forState:UIControlStateNormal];
        } else {
            [_selectRoadBtn setBackgroundImage:[UIImage imageNamed:@"notice_ic_line"] forState:UIControlStateNormal];
        }
        [_selectRoadBtn addTarget:self action:@selector(selectRoadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectRoadBtn;
}

-(ModelView *)modelView {
    if(!_modelView) {
        _modelView = [ModelView new];
        _modelView.backgroundColor = CCClearColor;
    }
    return _modelView;
}

-(UIView *)modeoCenterView {
    if(!_modeoCenterView) {
        _modeoCenterView = [UIView new];
        _modeoCenterView.backgroundColor = [UIColor whiteColor];
        _modeoCenterView.layer.borderWidth = 1;
        _modeoCenterView.layer.borderColor = [CCRGBColor(187, 187, 187) CGColor];
        _modeoCenterView.layer.cornerRadius = CCGetRealFromPt(10);
        _modeoCenterView.layer.masksToBounds = YES;
    }
    return _modeoCenterView;
}

/**
 *	@brief	收到在线人数
 */
- (void)onUserCount:(NSString *)count {
    _userCountLabel.text = [NSString stringWithFormat:@"%@",count];
}

-(UIButton *)cancelBtn {
    if(!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.layer.cornerRadius = CCGetRealFromPt(10);
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:CCRGBColor(51,51,51) forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_30]];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIButton *)sureBtn {
    if(!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = [UIColor whiteColor];
        _sureBtn.layer.cornerRadius = CCGetRealFromPt(10);
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:CCRGBColor(51,51,51) forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_30]];
        [_sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

/**
 *	@brief	请求成功
 */
-(void)requestSucceed {
    NSLog(@"请求成功！");
    [self startTimer];
    [self startHiddenTimer];
}

/**
 *	@brief	登录请求失败
 */
-(void)requestFailed:(NSError *)error reason:(NSString *)reason {
    NSString *message = nil;
    if (reason == nil) {
        message = [error localizedDescription];
    } else {
        message = reason;
    }
    [_loadingView removeFromSuperview];
    _loadingView = nil;
    InformationShowView *informationView = [[InformationShowView alloc] initWithLabel:message];
    [self.view addSubview:informationView];
    [informationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
        [informationView removeFromSuperview];
    }];
}

-(UIButton *)yuanHuaBtn {
    if(!_yuanHuaBtn) {
        _yuanHuaBtn = [UIButton new];
        _yuanHuaBtn.backgroundColor = CCRGBAColor(0, 0, 0, 0.5);
        _yuanHuaBtn.layer.shadowOffset = CGSizeMake(2, -2);
        _yuanHuaBtn.layer.shadowColor = [CCRGBAColor(0,0,0,0.6) CGColor];
        
        [_yuanHuaBtn setTitle:@"原画" forState:UIControlStateNormal];
        [_yuanHuaBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_30]];
        [_yuanHuaBtn setTitleColor:CCRGBColor(255, 255, 255) forState:UIControlStateNormal];
        [_yuanHuaBtn setTitleColor:CCRGBColor(255,102,51) forState:UIControlStateSelected];
        [_yuanHuaBtn addTarget:self action:@selector(yuanHuaBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yuanHuaBtn;
}

-(UIButton *)qingXiBtn {
    if(!_qingXiBtn) {
        _qingXiBtn = [UIButton new];
        _qingXiBtn.backgroundColor = CCRGBAColor(0, 0, 0, 0.5);
        _qingXiBtn.layer.shadowOffset = CGSizeMake(2, -2);
        _qingXiBtn.layer.shadowColor = [CCRGBAColor(0,0,0,0.6) CGColor];
        
        [_qingXiBtn setTitle:@"清晰" forState:UIControlStateNormal];
        [_qingXiBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_30]];
        [_qingXiBtn setTitleColor:CCRGBColor(255, 255, 255) forState:UIControlStateNormal];
        [_qingXiBtn setTitleColor:CCRGBColor(255,102,51) forState:UIControlStateSelected];
        [_qingXiBtn addTarget:self action:@selector(qingXiBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qingXiBtn;
}

-(UIButton *)liuChangBtn {
    if(!_liuChangBtn) {
        _liuChangBtn = [UIButton new];
        _liuChangBtn.backgroundColor = CCRGBAColor(0, 0, 0, 0.5);
        _liuChangBtn.layer.shadowOffset = CGSizeMake(2, -2);
        _liuChangBtn.layer.shadowColor = [CCRGBAColor(0,0,0,0.6) CGColor];
        
        [_liuChangBtn setTitle:@"流畅" forState:UIControlStateNormal];
        [_liuChangBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_30]];
        [_liuChangBtn setTitleColor:CCRGBColor(255, 255, 255) forState:UIControlStateNormal];
        [_liuChangBtn setTitleColor:CCRGBColor(255,102,51) forState:UIControlStateSelected];
        [_liuChangBtn addTarget:self action:@selector(liuChangBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liuChangBtn;
}

-(UIButton *)mainRoad {
    if(!_mainRoad) {
        _mainRoad = [UIButton new];
        _mainRoad.backgroundColor = CCRGBAColor(0, 0, 0, 0.6);
        _mainRoad.layer.shadowOffset = CGSizeMake(0, 2);
        _mainRoad.layer.shadowColor = [CCRGBAColor(0,0,0,0.5) CGColor];
        
        [_mainRoad setTitleEdgeInsets:UIEdgeInsetsMake(0,CCGetPxFromPt(19),0,0)];
        [_mainRoad setTitle:@"主线路" forState:UIControlStateNormal];
        [_mainRoad.titleLabel setFont:[UIFont systemFontOfSize:FontSize_26]];
        [_mainRoad setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _mainRoad.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_mainRoad addTarget:self action:@selector(mainRoadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainRoad;
}

-(UIButton *)secondRoad {
    if(!_secondRoad) {
        _secondRoad = [UIButton new];
        _secondRoad.backgroundColor = CCRGBAColor(0, 0, 0, 0.6);
        _secondRoad.layer.shadowOffset = CGSizeMake(0, 2);
        _secondRoad.layer.shadowColor = [CCRGBAColor(0,0,0,0.5) CGColor];
        [_secondRoad setTitleEdgeInsets:UIEdgeInsetsMake(0,CCGetPxFromPt(19),0,0)];
        [_secondRoad setTitle:@"备用线路" forState:UIControlStateNormal];
        [_secondRoad.titleLabel setFont:[UIFont systemFontOfSize:FontSize_26]];
        [_secondRoad setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _secondRoad.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_secondRoad addTarget:self action:@selector(secondRoadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondRoad;
}

-(void)yuanHuaBtnClicked {
    [self hiddenAllBtns];
    _yuanHuaBtn.selected = YES;
    _qingXiBtn.selected = NO;
    _liuChangBtn.selected = NO;
    if(_currentSecRoadNum == 0) {
        return;
    }
    _currentSecRoadNum = 0;
    [_requestData switchToPlayUrlWithFirIndex:_currentRoadNum key:[_secRoadKeyArray objectAtIndex:_currentSecRoadNum]];
}

-(void)qingXiBtnClicked {
    [self hiddenAllBtns];
    _yuanHuaBtn.selected = NO;
    _qingXiBtn.selected = YES;
    _liuChangBtn.selected = NO;
    if(_currentSecRoadNum == 1) {
        return;
    }
    _currentSecRoadNum = 1;
    [_requestData switchToPlayUrlWithFirIndex:_currentRoadNum key:[_secRoadKeyArray objectAtIndex:_currentSecRoadNum]];
}

-(void)liuChangBtnClicked {
    [self hiddenAllBtns];
    _yuanHuaBtn.selected = NO;
    _qingXiBtn.selected = NO;
    _liuChangBtn.selected = YES;
    if(_currentSecRoadNum == 2) {
        return;
    }
    _currentSecRoadNum = 2;
    [_requestData switchToPlayUrlWithFirIndex:_currentRoadNum key:[_secRoadKeyArray objectAtIndex:_currentSecRoadNum]];
}

-(void)mainRoadBtnClicked {
    [self hiddenAllBtns];
    if(_currentRoadNum == 0) {
        return;
    }
    _currentRoadNum = 0;
    
    UIImageView *imageView1 = [(UIImageView *)self.mainRoad viewWithTag:1];
    UIImageView *imageView2 = [(UIImageView *)self.mainRoad viewWithTag:1];
    imageView1.hidden = NO;
    imageView2.hidden = YES;
    [_requestData switchToPlayUrlWithFirIndex:_currentRoadNum key:[_secRoadKeyArray objectAtIndex:_currentSecRoadNum]];
}

-(void)secondRoadBtnClicked {
    [self hiddenAllBtns];
    if(_currentRoadNum == 1) {
        return;
    }
    _currentRoadNum = 1;
    
    UIImageView *imageView1 = [(UIImageView *)self.mainRoad viewWithTag:1];
    UIImageView *imageView2 = [(UIImageView *)self.mainRoad viewWithTag:1];
    imageView1.hidden = YES;
    imageView2.hidden = NO;
    [_requestData switchToPlayUrlWithFirIndex:_currentRoadNum key:[_secRoadKeyArray objectAtIndex:_currentSecRoadNum]];
}

-(void)qingXiDuAction {
    if(self.yuanHuaBtn.hidden) {
        if([_secRoadKeyArray count] == 1) {
            _yuanHuaBtn.hidden = NO;
        } else {
            _yuanHuaBtn.hidden = NO;
            _qingXiBtn.hidden = NO;
            _liuChangBtn.hidden = NO;
        }
    } else {
        [self hiddenAllBtns];
    }
}

-(void)gongGaoAction {
    [_chatTextField resignFirstResponder];
    _daohangView.hidden = YES;
    _contentView.hidden = YES;
    _soundVideoBtn.hidden = YES;
    if(self.isScreenLandScape) {
        _selectRoadBtn.hidden = YES;
    }
    _Rectangle44.hidden = YES;
    _yuanHuaBtn.hidden = YES;
    _qingXiBtn.hidden = YES;
    _liuChangBtn.hidden = YES;
    _Rectangle44.hidden = YES;
    _gongGaoDot.hidden = YES;
    WS(ws)
    
    if(!self.isScreenLandScape) {
        [_ccPrivateChatView.privateChatViewForOne.chatTextField resignFirstResponder];

        [ws.ccPrivateChatView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.height.mas_equalTo(CCGetRealFromPt(542));
            make.bottom.mas_equalTo(ws.view).offset(CCGetRealFromPt(542));
        }];
        
        [UIView animateWithDuration:0.25f animations:^{
            [ws.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if(ws.ccPrivateChatView.privateChatViewForOne) {
                [ws.ccPrivateChatView.privateChatViewForOne removeFromSuperview];
                ws.ccPrivateChatView.privateChatViewForOne = nil;
            }
        }];
    }
    
    [self.view addSubview:self.gongGaoView];
    if(self.isScreenLandScape) {
        [_gongGaoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(ws.view);
        }];
    } else {
        [_gongGaoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(ws.view);
        }];
    }
}

-(UIView *)gongGaoView {
    if(!_gongGaoView) {
        WS(ws)
        _gongGaoView = [[GongGaoView alloc] initWithLeftLabelText:_gongGaoStr isScreenLandScape:self.isScreenLandScape forPC:NO block:^{
            [ws.gongGaoView removeFromSuperview];
            ws.gongGaoView = nil;
        }];
        _gongGaoView.userInteractionEnabled = YES;
    }
    return _gongGaoView;
}

-(void)selectRoadBtnClicked {
    if(self.Rectangle44.hidden) {
        _Rectangle44.hidden = NO;
    } else {
        [self hiddenAllBtns];
    }
}

-(void)soundVideoBtnClicked {
    [self hiddenAllBtns];
    BOOL selected = self.soundVideoBtn.selected;
    self.soundVideoBtn.selected = !selected;
    if(self.soundVideoBtn.selected) {
        [_requestData switchToPlayUrlWithFirIndex:_currentRoadNum key:@""];
        self.soundBg.hidden = NO;
        self.soundLabel.hidden = NO;
    } else {
        self.soundBg.hidden = YES;
        self.soundLabel.hidden = YES;
        [_requestData switchToPlayUrlWithFirIndex:_currentRoadNum key:[_secRoadKeyArray objectAtIndex:_currentSecRoadNum]];
    }
}

-(void)hiddenAllBtns {
    if(_loadingView) return;
    _yuanHuaBtn.hidden = YES;
    _qingXiBtn.hidden = YES;
    _liuChangBtn.hidden = YES;
    _Rectangle44.hidden = YES;
    self.hiddenTime = 5;
}

-(void)onSelectVC {
    if(self.isScreenLandScape) {
        [self hiddenAll];
    } else {
        _Rectangle44.hidden = YES;
    }
    [self hiddenAllBtns];
    
    [self removeObserver];
    [self stopTimer];
    [self stopHiddenTimer];
    if(self.isScreenLandScape) {
        [self stopDanMuTimer];
    }
    [self dismissViewControllerAnimated:YES completion:^ {
        
    }];
}

/*
 *  @brief 切换源，firRoadNum表示一共有几个源，secRoadKeyArray表示每
 *  个源的描述数组，具体参见demo，firRoadNum是下拉列表有面的tableviewcell
 *  的行数，secRoadKeyArray是左面的tableviewcell的描述信息数组
 */
- (void)firRoad:(NSInteger)firRoadNum secRoadKeyArray:(NSArray *)secRoadKeyArray {
    _secRoadKeyArray = [secRoadKeyArray mutableCopy];
//    NSLog(@"firRoadNum = %d,secRoadKeyArray = %@",(int)firRoadNum,secRoadKeyArray);
}

- (void)onPublicChatMessage:(NSDictionary *)dic {
//    NSLog(@"onPublicChatMessage = %@",dic);
    if(self.isScreenLandScape) {
        if(_danMuButton.selected) {
            [self insertStr:dic[@"msg"]];
        }
        return;
    }
    Dialogue *dialogue = [[Dialogue alloc] init];
    dialogue.userid = dic[@"userid"];
    dialogue.fromuserid = dic[@"userid"];
    dialogue.username = [dic[@"username"] stringByAppendingString:@": "];
    dialogue.fromusername = [dic[@"username"] stringByAppendingString:@": "];
    dialogue.userrole = dic[@"userrole"];
    dialogue.fromuserrole = dic[@"userrole"];
    dialogue.msg = dic[@"msg"];
    dialogue.useravatar = dic[@"useravatar"];
    dialogue.time = dic[@"time"];
    dialogue.myViwerId = _viewerId;
    
    if([self.userDic objectForKey:dialogue.userid] == nil) {
        [self.userDic setObject:dic[@"username"] forKey:dialogue.userid];
    }
    
    dialogue.msgSize = [self getTitleSizeByFont:[dialogue.username stringByAppendingString:dialogue.msg] width:_tableView.frame.size.width font:[UIFont systemFontOfSize:FontSize_32]];
    
    dialogue.userNameSize = [self getTitleSizeByFont:dialogue.username width:_tableView.frame.size.width font:[UIFont systemFontOfSize:FontSize_32]];
    
    [_tableArray addObject:dialogue];
    
    if([_tableArray count] >= 1){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            NSIndexPath *indexPathLast = [NSIndexPath indexPathForItem:([_tableArray count]-1) inSection:0];
            [_tableView scrollToRowAtIndexPath:indexPathLast atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }
}

- (void)OnPrivateChat:(NSDictionary *)dic {
    NSLog(@"OnPrivateChat = %@",dic);
    if(self.isScreenLandScape) return;
    if(dic[@"fromuserid"] && dic[@"fromusername"] && [self.userDic objectForKey:dic[@"fromuserid"]] == nil) {
         [self.userDic setObject:dic[@"fromusername"] forKey:dic[@"fromuserid"]];
    }
    if(dic[@"touserid"] && dic[@"tousername"] && [self.userDic objectForKey:dic[@"touserid"]] == nil) {
         [self.userDic setObject:dic[@"tousername"] forKey:dic[@"touserid"]];
    }
    Dialogue *dialogue = [[Dialogue alloc] init];
    dialogue.fromuserid = dic[@"fromuserid"] ;
    dialogue.fromusername = dic[@"fromusername"];
    dialogue.fromuserrole = dic[@"fromuserrole"];
    dialogue.useravatar = dic[@"useravatar"];
    dialogue.touserid = dic[@"touserid"];
    dialogue.tousername = self.userDic[dialogue.touserid];
    dialogue.username = dialogue.fromusername;
    dialogue.userid = dialogue.fromuserid;
    dialogue.msg = dic[@"msg"];
    dialogue.time = dic[@"time"];
    dialogue.myViwerId = _viewerId;
    dialogue.msgSize = [self getTitleSizeByFont:[dialogue.username stringByAppendingString:dialogue.msg] width:_tableView.frame.size.width font:[UIFont systemFontOfSize:FontSize_32]];
    
    dialogue.userNameSize = [self getTitleSizeByFont:dialogue.username width:_tableView.frame.size.width font:[UIFont systemFontOfSize:FontSize_32]];
    
    NSString *anteName = nil;
    NSString *anteid = nil;
    if([dialogue.fromuserid isEqualToString:self.viewerId]) {
        anteid = dialogue.touserid;
        anteName = dialogue.tousername;
    } else {
        anteid = dialogue.fromuserid;
        anteName = dialogue.fromusername;
    }
    
    NSMutableArray *array = [self.dataPrivateDic objectForKey:anteid];
    if(!array) {
        array = [[NSMutableArray alloc] init];
        [self.dataPrivateDic setValue:array forKey:anteid];
    }
    
    [array addObject:dialogue];
    
    NSLog(@"anteid = %@,anteName = %@",anteid,anteName);
    
    [self.ccPrivateChatView reloadDict:[self.dataPrivateDic mutableCopy] anteName:anteName anteid:anteid];
}

/**
 *	@brief	服务器端给自己设置的UserId
 */
-(void)setMyViewerId:(NSString *)viewerId {
    _viewerId = viewerId;
}

- (void)privateChat:(NSNotification*) notification
{
//    if(self.isScreenLandScape) return;
//    NSDictionary *dic = [notification object];
//    
//    [_requestData privateChatWithTouserid:dic[@"anteid"] msg:dic[@"str"]];
}

- (void)startDanMuTimer {
    [self stopDanMuTimer];
    _danMuTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(makeTheRightAction) userInfo:nil repeats:YES];
}

- (void)stopDanMuTimer {
    if ([_danMuTimer isValid]){
        [_danMuTimer invalidate];
        _danMuTimer=nil;
        [self.array removeAllObjects];
    }
}

- (void)makeTheRightAction {
    for(int i = 0;i < _lineLimit;i++){
        if ([self.array count] >= 1) {
            [self makeLabel:[_array objectAtIndex:0] currentLine:i];
            [_array removeObjectAtIndex:0];
        } else {
            break;
        }
    }
}

-(NSMutableArray *)array {
    if(!_array) {
        _array = [NSMutableArray new];
    }
    return _array;
}

- (void)insertStr:(NSString *)str{
    if ([_danMuTimer isValid]) {
        [self.array addObject:str];
    }
}

- (void)makeLabel:(NSString *)str currentLine:(int)currentLine{
    if (self.isScreenLandScape == NO) {
        return;
    }
    
    NSMutableAttributedString *attrStr = [Utility emotionStrWithString:str y:-8];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:20.0f]
                    range:NSMakeRange(0, attrStr.length)];
    CGSize textSize = [attrStr boundingRectWithSize:CGSizeMake(100000, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                            context:nil].size;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 64 + IMGWIDTH * 0.5 * (currentLine + 1) + IMGWIDTH * currentLine, textSize.width, textSize.height)];
    contentLabel.font = [UIFont systemFontOfSize:20.0f];
    contentLabel.numberOfLines = 1;
    contentLabel.attributedText = attrStr;
    contentLabel.backgroundColor = [UIColor clearColor];
    //设置字体颜色为green
    contentLabel.textColor = [UIColor greenColor];
    //文字居中显示
    contentLabel.textAlignment = NSTextAlignmentCenter;
    //自动折行设置
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.view addSubview:contentLabel];
    
    [self moveAction:contentLabel size:textSize];
}

- (void)moveAction:(UIView *)view size:(CGSize) size {
    [UIView animateWithDuration:_secondToEnd delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        view.frame = CGRectMake(-size.width,view.frame.origin.y,size.width,size.height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

-(void)announcement:(NSString *)str {
    if(StrNotEmpty(str)) {
        _gongGaoStr = str;
        self.gongGaoDot.hidden = NO;
    } else {
        _gongGaoStr = @"";
        self.gongGaoDot.hidden = YES;
    }
}

- (void)on_announcement:(NSDictionary *)dict {
    if([dict[@"action"] isEqualToString:@"release"]) {
        self.gongGaoDot.hidden = NO;
        _gongGaoStr = dict[@"announcement"];
    } else if([dict[@"action"] isEqualToString:@"remove"]) {
        self.gongGaoDot.hidden = YES;
        _gongGaoStr = @"";
    }
    
    if(_gongGaoView) {
        [_gongGaoView updateViews:_gongGaoStr];
    }
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    if(self.isScreenLandScape) {
//        bool bRet = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft));
//        return bRet;
//    }else{
//        return false;
//    }
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    if(self.isScreenLandScape) {
//        return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
//    }else{
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}

@end


