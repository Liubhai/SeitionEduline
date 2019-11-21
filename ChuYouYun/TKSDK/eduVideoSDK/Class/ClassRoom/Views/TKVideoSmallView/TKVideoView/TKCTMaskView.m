//
//  TKCTMaskView.m
//  EduClass
//
//  Created by talkcloud on 2018/10/12.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKCTMaskView.h"

#import "TKTurnOffCameraView.h"
#import "TKBackGroundView.h"
#import "TKEduSessionHandle.h"


#define ThemeKP(args) [@"ClassRoom.TKVideoView." stringByAppendingString:args]

@interface TKCTMaskView()
@property (nonatomic, assign) TKEVideoRole videoRole;
@property (nonatomic, strong) UIImageView * bomBgView;

@property (nonatomic, strong) TKTurnOffCameraView *turnOffCameraView;//关闭视频时的覆盖图像

@property (nonatomic, strong) TKBackGroundView *sIsInBackGroundView;//进入后台覆盖视图
@property (nonatomic, strong) UIImageView *backgroundImageView;//视频边框

@property (nonatomic, strong) UIImageView * drawDotColorPoint;//画笔颜色展示
@property (nonatomic, strong) UIImageView * drawDotView;//画笔颜色展示

@property (nonatomic, strong) UIImageView * volumeView;// 音量视图
@property (nonatomic, assign) NSTimeInterval lastTime;  // 最后更新时间
// 音量
@property (nonatomic, assign) int lastStyle; // 记录上一个样式
@property (nonatomic, assign) int grade; //等级系数

@property (nonatomic, assign) BOOL isPicInPic;// 开启画中画
@property (nonatomic, strong) NSDictionary * refreshDict;
@end

@implementation TKCTMaskView

- (instancetype)initWithFrame:(CGRect)frame aVideoRole:(TKEVideoRole)aVideoRole{
    if (self = [super initWithFrame:frame]) {

        _videoRole = aVideoRole;
        _bomBgView = [[UIImageView alloc]init];
        [self addSubview:_bomBgView];
        _bomBgView.sakura.image(ThemeKP(@"videoBottomBg"));
        
        _lastTime = [[NSDate date] timeIntervalSince1970];
        
        //关闭视频背景层
        _turnOffCameraView = ({
            TKTurnOffCameraView *view = [[TKTurnOffCameraView alloc]init];
            [self addSubview:view];
            view;
        });
        
        
        //视频边框
        _backgroundImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            [self addSubview:imageView];
            imageView.image = [UIImage tkResizedImageWithName:ThemeKP(@"videoBoardImage")];
            
            imageView;
        });
        
        //用户名
        _nameLabel = ({
            UILabel *label = [[UILabel alloc]init];
            [_bomBgView addSubview:label];
            label.sakura.textColor(ThemeKP(@"videoToolTextColor"));
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.font = [UIFont systemFontOfSize:9];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        _drawDotColorPoint = ({
            UIImageView * viewww = [[UIImageView alloc] init];
            [_bomBgView addSubview:viewww];
            viewww;
        });
        //奖杯数量
        _trophyNumBtn = ({
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [self addSubview:button];
            button.titleLabel.font = TKFont(10);
            button.sakura.backgroundColor(ThemeKP(@"videoToolColor"));
            button.sakura.titleColor(ThemeKP(@"trophyColor"),UIControlStateNormal);
            button.sakura.alpha(ThemeKP(@"videoToolAlpha"));
            button.layer.masksToBounds = YES;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            button;
        });
        _trophyButton = ({
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [self addSubview:button];
            button.sakura.backgroundImage(ThemeKP(@"trophyImage"),UIControlStateNormal);
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            button;
        });
        
        //举手按钮
        _handImageView = ({
            UIImageView *view = [[UIImageView alloc]init];
            view.sakura.image(ThemeKP(@"videoHandImage"));
            [_backgroundImageView addSubview:view];
            view.hidden = YES;
            view;
        });
        
        //声音标识按钮
        _muteButton = ({
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.sakura.image(ThemeKP(@"videoAudioNomalImage"),UIControlStateNormal);
            button.sakura.image(ThemeKP(@"videoAudioSelectedImage"),UIControlStateSelected);
            [_backgroundImageView addSubview:button];
            button;
        });
        
        //画笔标识按钮
        _drawDotView = ({
            UIImageView *view = [[UIImageView alloc]init];
            view.backgroundColor = [UIColor clearColor];
            view.sakura.image(ThemeKP(@"tk_videoMaskDrawDotImage"));
            view.hidden = YES;
            [_backgroundImageView addSubview:view];
            view;
            
        });
        
        _volumeView = ({
            UIImageView *view = [[UIImageView alloc] init];
            _lastStyle = 0;
            _grade     = 32670 / 4;
            view.sakura.image(ThemeKP(@"volume_bg0"));
            [_backgroundImageView addSubview:view];
            view;
        });
        [self refreshUI];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    CGFloat iconWH = IS_PAD ? 16 : 12; // 举手  音量  画笔宽高;
    CGFloat iconMargin = 3.; // 举手  音量  画笔边距;
    CGFloat bomBgHeight = self.height * 0.3;
    if (bomBgHeight>30) {
        bomBgHeight = 30;
    }
    CGFloat toolMinY = self.height - bomBgHeight;
    
    _bomBgView.frame = CGRectMake(0, toolMinY, self.width, bomBgHeight);
    
    // 昵称 宽度让出左右按钮的位置，如果视频框比较窄，则不让
    CGFloat nameWidth = _bomBgView.width - (iconWH + 20 + 10) * 2;
    nameWidth = (nameWidth > 50) ? nameWidth : _bomBgView.width;
    _nameLabel.frame = CGRectMake((_bomBgView.width - nameWidth) / 2, bomBgHeight - iconMargin - iconWH, nameWidth, iconWH);
    _trophyNumBtn.layer.cornerRadius = _trophyNumBtn.height / 2.0;

    // 计算文字宽度，在名字前 添加表示画笔颜色的点
    CGFloat width = [TKHelperUtil sizeForString:_nameLabel.text?:@"" font:self.nameLabel.font size:CGSizeMake(200, 18)].width;
    if (width > _nameLabel.width) width = _nameLabel.width - 3;
    _drawDotColorPoint.frame = CGRectMake(_nameLabel.centerX - width/2 - 2 - 6, self.nameLabel.centerY - 3, 6, 6);
    _drawDotColorPoint.layer.cornerRadius = 3;
    _drawDotColorPoint.layer.masksToBounds = YES;
    
    _turnOffCameraView.frame = CGRectMake(0, 0, self.width, self.height);
    _sIsInBackGroundView.frame = CGRectMake(0, 0, self.width, self.height);
    _backgroundImageView.frame = CGRectMake(0, 0, self.width, self.height);
    
    // 举手按钮
    _handImageView.frame = CGRectMake(self.width - iconMargin - iconWH ,iconMargin, iconWH, iconWH);
    // 音量
    _muteButton.frame    = CGRectMake(iconMargin, self.height - iconMargin - iconWH, iconWH, iconWH);
    _volumeView.frame    = CGRectMake(_muteButton.rightX + 1, _muteButton.centerY - 4, 16, 8);
    // 画笔
    _drawDotView.frame   = CGRectMake(self.width - iconMargin - iconWH, self.height - iconMargin - iconWH, iconWH, iconWH);
    {//奖杯位置
        
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10.]};
        CGSize titleSize = [_trophyNumBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        CGFloat trophyW = titleSize.width+iconWH+7;
        if (trophyW>(self.width*0.9)/2.0) {
            trophyW = (self.width*0.9)/2.0;
        }
        _trophyNumBtn.frame = CGRectMake(iconMargin + 1, iconMargin + 1, trophyW, iconWH);
        _trophyNumBtn.layer.cornerRadius = _trophyNumBtn.height / 2.0;
        _trophyButton.frame = CGRectMake( _trophyNumBtn.leftX - 0, _trophyNumBtn.centerY - iconWH / 2, iconWH, iconWH);
    }
}

- (void)changeName:(NSString *)name{
    self.nameLabel.text = name;
}

- (void)setIVideoViewTag:(NSInteger)iVideoViewTag{
    _iVideoViewTag = iVideoViewTag;
    if (iVideoViewTag == -1) {
        _backgroundImageView.image = [UIImage tkResizedImageWithName:ThemeKP(@"videoBoardTeacherImage")];
        if ([TKEduSessionHandle shareInstance].isOnlyAudioRoom) {
            _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"onlyAudioBackImage"));
        } else {
            if (iVideoViewTag == -1) {
                _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoBackTeacherImage"));
            } else {
                _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoBackStuImage"));
            }
        }
    }
}

-(void)setIRoomUser:(TKRoomUser *)iRoomUser{
    _iRoomUser = iRoomUser;
    if ([TKEduSessionHandle shareInstance].isOnlyAudioRoom) {
        _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"onlyAudioBackImage"));
    } else {
        if(!_iRoomUser.hasVideo){
            _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoNoCameraImage"));
        }else{
            _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoCloseCameraImage"));
        }
    }
    [self refreshUI];
}

- (void)refreshUI{
    
    if (_iRoomUser) {
        _bomBgView.hidden = NO;
        
        //设置奖杯数量
        int currentGift = 0;
        if(_iRoomUser.properties && [_iRoomUser.properties objectForKey:sGiftNumber]){
            
            id gift = [_iRoomUser.properties objectForKey:sGiftNumber];
            
            if ([gift isKindOfClass:[NSNumber class]]) {
                
                currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];
                
            }else if([gift isKindOfClass:[NSDictionary class]]){
                currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];
                
            }
        }

        // 默认也显示奖杯   格式🏆*0
        if (_iRoomUser.role == TKUserType_Teacher || _iRoomUser.role == TKUserType_Assistant || _iRoomUser.role == TKUserType_Patrol) {
            
            _trophyButton.hidden = YES;
            _trophyNumBtn.hidden = YES;
            _handImageView.hidden = YES;
            _drawDotView.hidden = YES;
            _drawDotColorPoint.hidden = NO;
            _muteButton.hidden = NO;
            _volumeView.hidden = NO;
        }
        else{
            
            _trophyButton.hidden  = NO;
            _trophyNumBtn.hidden = NO;
            _handImageView.hidden = NO;
            _drawDotView.hidden   = NO;
            _drawDotColorPoint.hidden = NO;
            _muteButton.hidden    = NO;
            _volumeView.hidden    = NO;
            NSString *numStr = [NSString stringWithFormat:@"%@",@(currentGift)];
            [_trophyNumBtn setTitle:numStr forState:UIControlStateNormal];

            
            if(_trophyNumBtn.titleLabel.text){
                int currentFontSize = [TKUtil getCurrentFontSize:CGSizeMake(_trophyNumBtn.frame.size.width, _trophyNumBtn.frame.size.height) withString:_trophyNumBtn.titleLabel.text];
                if (currentFontSize>9) {
                    currentFontSize = 9;
                }
                if (currentFontSize<=0) {
                    currentFontSize = 9;
                }
                _trophyNumBtn.titleLabel.font = TKFont(currentFontSize);
            }
        }
        
        //声音显示
        PublishState tPublishState = (PublishState)_iRoomUser.publishState;
        BOOL tAudioImageShow = !(tPublishState  == TKPublishStateBOTH || tPublishState == TKPublishStateAUDIOONLY );
        //todo
        _muteButton.selected = tAudioImageShow;
        _volumeView.hidden = tAudioImageShow;
        
        //视频是否显示
        BOOL turnOffCameraShow = (tPublishState == TKPublishStateBOTH || tPublishState == TKPublishStateVIDEOONLY || tPublishState == TKPublishStateLocalNONE);
        _turnOffCameraView.hidden = _iRoomUser.hasVideo ? turnOffCameraShow : NO;
        if ([TKEduSessionHandle shareInstance].isOnlyAudioRoom) {
            _turnOffCameraView.hidden = NO;
        }
        
        //举手图标是否显示
        BOOL tHandsUpImageShow = (![[_iRoomUser.properties objectForKey:sRaisehand]boolValue]);
        _handImageView.hidden = tHandsUpImageShow;
        
        //画笔颜色值是否显示
        BOOL tDrawImageShow = [[_iRoomUser.properties objectForKey:sCandraw]boolValue];
        
        if([[_iRoomUser.properties allKeys] containsObject:sPrimaryColor])
        {
#pragma mark  视频画笔设置1
            NSString *color = [TKUtil optString:_iRoomUser.properties Key:sPrimaryColor];
            _drawDotColorPoint.backgroundColor = [TXSakuraManager tx_colorFromString:color];
//            _drawDotView.image = [UIImage imageNamed:[TKHelperUtil imageNameWithPrimaryColor:color]];
            
        }
        if (_iRoomUser.role == TKUserType_Teacher || _iRoomUser.role == TKUserType_Patrol) {
            _drawDotView.hidden = YES;
        }else{
            _drawDotView.hidden = !tDrawImageShow;
        }
        _drawDotColorPoint.hidden = !tDrawImageShow;

        [self bringSubviewToFront:_bomBgView];
        [self bringSubviewToFront:_backgroundImageView];
        
    }else{
        
        if (self.sIsInBackGroundView) {
            [self.sIsInBackGroundView removeFromSuperview];
        }

        _bomBgView.hidden = YES;
        _trophyButton.hidden = YES;
        _trophyNumBtn.hidden = YES;
        
        _turnOffCameraView.hidden = NO;
        if ([TKEduSessionHandle shareInstance].isOnlyAudioRoom) {
            _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"onlyAudioBackImage"));
        } else {
            if (_iVideoViewTag == -1) {//老师
                _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoBackTeacherImage"));
            }else{//学生
                _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoBackStuImage"));
            }
        }
        _handImageView.hidden = YES;
        _drawDotView.hidden = YES;
        _drawDotColorPoint.hidden = YES;
        _muteButton.hidden = YES;
        _volumeView.hidden = YES;
    }
    
    [self maskViewChangeForPicInPicWithisShow:_isPicInPic];
}
-(void)refreshVolume:(NSDictionary *)dict{
    
    if(!(_iRoomUser.publishState == TKPublishStateAUDIOONLY ||
         _iRoomUser.publishState == TKPublishStateBOTH) ){
        return;
    }
    
    // 音量大于0 显示
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    if ([dict[sVolume] intValue] >= 0 &&
         time - _lastTime > 0.1) {// 此处为了限制次数.
        
        // 音量大小 0 ～ 32670
        CGFloat volume = [dict[sVolume] floatValue];
        int num = volume / _grade;
        
        if (num != _lastStyle) {
            
            NSString *imageName = [NSString stringWithFormat:@"volume_bg%d", num];
            _volumeView.sakura.image(ThemeKP(imageName));
            _lastStyle = num;
        }
        _lastTime = time;
    }
}

- (void)refreshRaiseHandUI:(NSDictionary *)dict{
    
    _refreshDict = dict;
    
    PublishState tPublishState = (PublishState)[[dict objectForKey:sPublishstate]integerValue];
    
    BOOL tAudioImageShow = !(tPublishState  == TKPublishStateBOTH || tPublishState == TKPublishStateAUDIOONLY );
    //todo
    _muteButton.selected = tAudioImageShow;
    _volumeView.hidden   = tAudioImageShow;
    
    BOOL turnOffCameraShow = (tPublishState == TKPublishStateBOTH || tPublishState == TKPublishStateVIDEOONLY ||tPublishState == TKPublishStateLocalNONE);
    
    if (_iRoomUser && ![TKEduSessionHandle shareInstance].isClassBegin &&
        ![TKEduClassRoom shareInstance].roomJson.configuration.beforeClassPubVideoFlag) {
        
        if (tPublishState == TKPublishStateAUDIOONLY || [TKEduSessionHandle shareInstance].isOnlyAudioRoom) {
            
            turnOffCameraShow = NO;
        }else{
            turnOffCameraShow = YES;
        }
        
    }
 
    if ([TKEduSessionHandle shareInstance].isOnlyAudioRoom) {
        _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"onlyAudioBackImage"));
        turnOffCameraShow = NO;
    }
    else {
        if (tPublishState > TKPublishStateNONE) {
            
            if(!_iRoomUser.hasVideo){
                _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoNoCameraImage"));
            }else{
                _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoCloseCameraImage"));
            }
        } else {
            
            if (_iVideoViewTag == -1) {//老师
                _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoBackTeacherImage"));
            }else{//学生
                _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoBackStuImage"));
            }
        }
    }
    _turnOffCameraView.hidden = _iRoomUser.hasVideo ? turnOffCameraShow : NO;
    
    BOOL tHandsUpImageShow = (![[dict objectForKey:sRaisehand]boolValue]);
    _handImageView.hidden = tHandsUpImageShow;
    
    BOOL tDrawImageShow = [[dict objectForKey:sCandraw]boolValue];
    
    
    if([[dict allKeys] containsObject:sPrimaryColor])
    {
#pragma mark 视频画笔设置2
        NSString *color = [TKUtil optString:_iRoomUser.properties Key:sPrimaryColor];
        _drawDotColorPoint.backgroundColor = [TXSakuraManager tx_colorFromString:color];
//        _drawDotView.image = [UIImage imageNamed:[TKHelperUtil imageNameWithPrimaryColor:color]];
        
    }
    
    if (_iRoomUser.role == TKUserType_Teacher || _iRoomUser.role == TKUserType_Patrol) {
        _drawDotView.hidden = YES;
    }else{
        _drawDotView.hidden = !tDrawImageShow;
    }
    _drawDotColorPoint.hidden = !tDrawImageShow;

    if ([[dict allKeys] containsObject:sGiftNumber] && [[[TKEduSessionHandle shareInstance].roomMgr localUser].peerID isEqualToString:dict[@"fromid"]]) {
        
        NSString *numStr = [NSString stringWithFormat:@"%@",dict[sGiftNumber]];
        if (numStr.length == 0) numStr = @"0";
        [_trophyNumBtn setTitle:numStr forState:UIControlStateNormal];
    }
    
    [self bringSubviewToFront:_bomBgView];
    [self bringSubviewToFront:_backgroundImageView];
    
    [self maskViewChangeForPicInPicWithisShow:_isPicInPic];
}



#pragma mark private

- (void)endInBackGround:(BOOL)isInBackground{
    
    if (isInBackground) {//进入后台需将视频顶层覆盖视图
        [self addSubview:self.sIsInBackGroundView];
        [self bringSubviewToFront:self.sIsInBackGroundView];
        [self bringSubviewToFront:_bomBgView];
        [self bringSubviewToFront:_backgroundImageView];
        
        if (self.hidden) {
            self.hidden = NO;
        }
        
    }else{//取消覆盖
        [self.sIsInBackGroundView removeFromSuperview];
    }
    
}

- (UIView *)sIsInBackGroundView{
    if (!_sIsInBackGroundView) {
        _sIsInBackGroundView = [[TKBackGroundView alloc]init];
        _sIsInBackGroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    [self setBackgroundLabelContent];
    return _sIsInBackGroundView;
}

- (void)setBackgroundLabelContent {
    if (_iRoomUser.role == TKUserType_Student) {
        
        [_sIsInBackGroundView setContent:MTLocalized(@"State.isInBackGround")];
    } else {

        [_sIsInBackGroundView setContent:MTLocalized(@"State.teacherInBackGround")];
    }
}
- (void)inOnlyAudioRoom {
    _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"onlyAudioBackImage"));
}
- (void)setIsSplit:(BOOL)isSplit {
    _isSplit = isSplit;
    
    if (isSplit) {
        _drawDotView.hidden = YES;
        _drawDotColorPoint.hidden = YES;
    }else{
        [self refreshUI];
    }
    
}

- (void) maskViewChangeForPicInPicWithisShow:(BOOL)isShow {
    // 蛋疼的逻辑，修改请慎重
    if (isShow) {
        
        _isPicInPic = YES;
        // 画中画 按钮 全部隐藏
        _bomBgView.hidden = YES;
        _trophyButton.hidden = YES;//奖杯
        _trophyNumBtn.hidden = YES;// 奖杯数量
        _handImageView.hidden = YES;//举手
        _muteButton.hidden = YES;//音频展示按钮
        _drawDotColorPoint.hidden = YES;//画笔颜色展示
        _drawDotView.hidden = YES;//画笔颜色展示
        _volumeView.hidden = YES;// 音量视图
    } else if (_isPicInPic && !isShow) {
        
        _isPicInPic = NO;
        [self refreshUI];
        if (_refreshDict) [self refreshRaiseHandUI:_refreshDict];
    }
}

@end


