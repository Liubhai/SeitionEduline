//
//  TKVideoPopupMenu.m
//  EduClass
//
//  Created by lyy on 2018/4/23.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKVideoPopupMenu.h"
#import "TKPopupMenuPath.h"
#import "TKVideoFunctionView.h"
#import "TKVideoVerticalFunctionView.h"
#import "TKEduSessionHandle.h"

#define ThemeKP(args) [@"ClassRoom.TKVideoView." stringByAppendingString:args]

#define CollectionCellHeight 69

@interface TKVideoPopupMenu ()<VideolistProtocol,VideoVlistProtocol>


/**
 显示控制按钮视图
 */
@property (nonatomic, strong) UIView * videoToolView;

@property (nonatomic, strong) UIView      * menuBackView;
@property (nonatomic) CGRect                relyRect;
@property (nonatomic, assign) CGFloat       itemWidth;
@property (nonatomic) CGPoint               point;
@property (nonatomic, assign) BOOL          isCornerChanged;
@property (nonatomic, strong) UIColor     * separatorColor;
@property (nonatomic, assign) BOOL          isChangeDirection;
@property (nonatomic, assign) CGFloat       controlButtonCount;
@end

@implementation TKVideoPopupMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultSettings];
        
    }
    return self;
}

#pragma mark - publics


+ (TKVideoPopupMenu *)showRelyOnView:(UIView *)view
                          aVideoRole:(TKEVideoRole)videoRole
                            aRoomUer:(TKRoomUser*)roomUser
                             isSplit:(BOOL)isSplit
                            delegate:(id<TKVideoPopupMenuDelegate>)delegate
{
    CGRect absoluteRect = [view convertRect:view.bounds toView:TKMainWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    
    TKVideoPopupMenu *popupMenu = [[TKVideoPopupMenu alloc] init];
    popupMenu.point = relyPoint;
    popupMenu.relyRect = absoluteRect;
    popupMenu.delegate = delegate;
    popupMenu.iRoomUser = roomUser;
    popupMenu.videoRole = videoRole;
    popupMenu.isSplit = isSplit;
  
    //判断显示控制按钮的个数（根据角色、拖拽状态、分屏状态）
    popupMenu.controlButtonCount = [popupMenu returnControlButtonCountVideoRole:videoRole aRoomUser:roomUser isSplit:isSplit];

    if (([TKEduClassRoom shareInstance].roomJson.roomtype == TKRoomTypeOneToOne &&
         ![TKEduClassRoom shareInstance].roomJson.configuration.assistantCanPublish)  ) {
        
        popupMenu.arrowDirection = TKPopupMenuArrowDirectionRight;
        popupMenu.priorityDirection = TKPopupMenuPriorityDirectionRight;
        
        popupMenu.itemWidth = 60;
        popupMenu.itemHeight =popupMenu.controlButtonCount * 69;
        
    }else if(isSplit){
        
        popupMenu.arrowDirection = TKPopupMenuArrowDirectionBottom;
        popupMenu.priorityDirection = TKPopupMenuPriorityDirectionBottom;
        
        popupMenu.itemWidth =popupMenu.controlButtonCount * 60;
        
    }else{
        
        popupMenu.arrowDirection = TKPopupMenuArrowDirectionTop;
        popupMenu.priorityDirection = TKPopupMenuPriorityDirectionTop;
        
        popupMenu.itemWidth =popupMenu.controlButtonCount * 60;
    }
    
    [popupMenu show];
    [popupMenu resetVideoToolFrame:CGRectMake(0, 0, popupMenu.width,popupMenu.height)];
    
    return popupMenu;
}

- (CGFloat)returnControlButtonCountVideoRole:(TKEVideoRole)aVideoRole aRoomUser:(TKRoomUser *)aRoomUer isSplit:(BOOL)isSplit{
    
    //默认按钮个数为0
    CGFloat tPoroFloat = 0;
    
    // 演讲按钮暂时去掉
    if (aRoomUer.disableVideo == YES) {
        if (aRoomUer.disableAudio == YES) {//视频禁用,音频禁用
            tPoroFloat = 0;
        } else {//视频禁用,音频未禁用
            tPoroFloat = 1;
        }
    } else {
        if (aRoomUer.disableAudio == YES) {//视频未禁用,音频禁用
            tPoroFloat = 1;
        } else {//视频未禁用,音频未禁用
            tPoroFloat = 2;
        }
    }
    // 操作人角色
    TKUserRoleType localRole = [[TKEduSessionHandle shareInstance] localUser].role;
    
    // 上台 授权 奖杯
    if (aRoomUer.role == TKUserType_Teacher) {
        
        if (localRole == TKUserType_Teacher) {
            // 老师点击自己 只有音视频
            tPoroFloat += (self.isSplit ? 2 : 1);//恢复位置 全体复位

        } else if (localRole == TKUserType_Student) {
            // 学生点击老师 不允许
        } else {
            tPoroFloat = 0;
        }
        
    } else if (aRoomUer.role == TKUserType_Student) {
        
        if (localRole == TKUserType_Teacher) {
            // 老师点击学生 允许助教上台的一对一 会进入一对多房间
            if ([TKEduClassRoom shareInstance].roomJson.roomtype == TKRoomTypeOneToOne &&
                ![TKEduClassRoom shareInstance].roomJson.configuration.assistantCanPublish) {
                tPoroFloat += 2;// 授权 奖杯
            } else {
                tPoroFloat += 3;// 授权 奖杯 上台
            }
            
            if (self.isSplit) {
                tPoroFloat += 1;// 恢复位置
            }
            
        } else if (localRole == TKUserType_Student) {
            // 学生点击自己 只有音视频
        } else {
            tPoroFloat = 0;
        }
        
    } else if (aRoomUer.role == TKUserType_Assistant) {
        
        if (localRole == TKUserType_Teacher) {
            // 老师点击助教
            tPoroFloat += 1;// 上台
            
            if (self.isSplit) {
                tPoroFloat += 1;// 恢复位置
            }

        } else if (localRole == TKUserType_Student) {
            // 学生点击助教 不允许
        } else {
            tPoroFloat = 0;
        }
        
    } else {
        tPoroFloat = 0;
    }
    
    
    return tPoroFloat;
    /* 演讲代码 不要删
    if (aRoomUer.disableVideo == YES) {
        if (aRoomUer.disableAudio == YES) {//视频禁用,音频禁用
            tPoroFloat = 4;
        } else {//视频禁用,音频未禁用
            tPoroFloat = 5;
        }
    } else {
        if (aRoomUer.disableAudio == YES) {//视频未禁用,音频禁用
            tPoroFloat = 5;
        } else {//视频未禁用,音频未禁用
            tPoroFloat = 6;
        }
    }
    
    //如果是老师  或者  是自己
    if (aVideoRole == TKUserType_Teacher || (aVideoRole != TKEVideoRoleTeacher && [aRoomUer.peerID isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID])) {
        
        //如果允许学生自己关闭音视频 并且是学生 则可以弹出  关闭音视频按钮
        if ([TKEduClassRoom shareInstance].tkRoomProperty.configuration.allowStudentCloseAV && aRoomUer.role == TKUserType_Student) {
            tPoroFloat = 2.0;
            
        }else{
            
            //如果是1v1课堂 && 未开始上课 && 是老师
            if ((TKRoomType)([[TKEduClassRoom shareInstance].tkRoomProperty.roomtype intValue]) != TKRoomTypeOneToOne && ![TKEduSessionHandle shareInstance].isClassBegin && [[TKEduSessionHandle shareInstance] localUser].role == TKEVideoRoleTeacher) {
                tPoroFloat = 2.0;
            }else{
                
                tPoroFloat = 3.0;
            }
        }
    }
    
    // 如果是助教，只显示下台和关音频2个
    if (aRoomUer.role == TKUserType_Assistant) {
        tPoroFloat = 4;
    }
    
    //如果是1v1课堂，开始上课，并且是老师角色 则减少一个分屏按钮
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iRoomType == TKRoomTypeOneToOne && [TKEduSessionHandle shareInstance].isClassBegin && [[TKEduSessionHandle shareInstance] localUser].role == TKEVideoRoleTeacher) {
        tPoroFloat = tPoroFloat -1;
    }
    // 1v1 学生
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iRoomType == TKRoomTypeOneToOne && aRoomUer.role == TKUserType_Student && [TKEduSessionHandle shareInstance].localUser.role == TKUserType_Teacher) {
        tPoroFloat = tPoroFloat -1;
    }
    
   //如果是一对一课堂，并且允许助教上台
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iRoomType == TKRoomTypeOneToOne &&
        [TKEduClassRoom shareInstance].tkRoomProperty.configuration.assistantCanPublish) {
        tPoroFloat = tPoroFloat +1;
    }
    //如果是一对一课堂，并且允许助教上台,并且用户角色是学生
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iRoomType == TKRoomTypeOneToOne &&
        [TKEduClassRoom shareInstance].tkRoomProperty.configuration.assistantCanPublish &&
        aVideoRole == TKUserType_Student) {
        tPoroFloat = tPoroFloat +1;
    }
    return tPoroFloat;
    */
}

- (void)dismiss
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(modifierFunction) withObject:nil afterDelay:0.3];

    self.isVisible = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ybPopupMenuBeganDismiss)]) {
        [self.delegate ybPopupMenuBeganDismiss];
    }
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
//        _menuBackView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ybPopupMenuDidDismiss)]) {
            [self.delegate ybPopupMenuDidDismiss];
        }
        self.delegate = nil;
        [self removeFromSuperview];
//        [_menuBackView removeFromSuperview];
    }];
}

- (void)modifierFunction
{
    [TKEduSessionHandle shareInstance].dismissing = NO;
}

#pragma mark - privates
- (void)show
{
    self.isVisible = YES;
    
    [self addSubview:self.videoToolView];
    
//    [TKMainWindow addSubview:_menuBackView];
    [TKMainWindow addSubview:self];
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(ybPopupMenuBeganShow)]) {
        [self.delegate ybPopupMenuBeganShow];
    }
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
//        _menuBackView.alpha = 1;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ybPopupMenuDidShow)]) {
            [self.delegate ybPopupMenuDidShow];
        }
    }];
}

- (void)setDefaultSettings
{
    _cornerRadius = 10.0;
    _rectCorner = UIRectCornerAllCorners;
    self.isShowShadow = NO;//设置阴影
    _dismissOnSelected = YES;
    _dismissOnTouchOutside = YES;
    _offset = 0.0;
    _relyRect = CGRectZero;
    _point = CGPointZero;
    _borderWidth = [TKTheme floatWithPath:ThemeKP(@"videoPopBorderWidth")]; //设置边框宽度
    _borderColor = [[TKTheme colorWithPath:ThemeKP(@"videoPopBorderColor")] colorWithAlphaComponent:[TKTheme floatWithPath:ThemeKP(@"videoPopAlpha")]];//设置边框颜色

    _arrowWidth = 15.0;
    _arrowHeight = 10.0;
    _backColor = [[TKTheme colorWithPath:ThemeKP(@"videoPopBackColor")] colorWithAlphaComponent:[TKTheme floatWithPath:ThemeKP(@"videoPopAlpha")]];//设置背景颜色
    
    _type = TKPopupMenuTypeDefault;
    _minSpace = 10.0;
    _itemHeight = CollectionCellHeight;
    _isCornerChanged = NO;
    _showMaskView = YES;
//    _menuBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//    _menuBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    _menuBackView.alpha = 0;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
//    [_menuBackView addGestureRecognizer: tap];
    self.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //不在self内 并且不在smallview内
    if (![self pointInside:point withEvent:event]) {

        [self touchOutSide];
        [TKEduSessionHandle shareInstance].dismissing = YES;
        return nil;
    }
    return [super hitTest:point withEvent:event];

}

-(UIView *)videoToolView{
    
    if (!_videoToolView) {
       
        if (([TKEduClassRoom shareInstance].roomJson.roomtype == TKRoomTypeOneToOne &&
             ![TKEduClassRoom shareInstance].roomJson.configuration.assistantCanPublish)) {
            
            
            _videoToolView = [[TKVideoVerticalFunctionView  alloc] initWithFrame:CGRectMake(0, 0, _itemWidth, CollectionCellHeight) aVideoRole:_videoRole aRoomUer:_iRoomUser isSplit:_isSplit count:_controlButtonCount];
            
            TKVideoVerticalFunctionView *view = (TKVideoVerticalFunctionView *)_videoToolView;
            
            view.iDelegate = self;
            view.isSplitScreen = self.isSplit;
            
        }else{
            
            _videoToolView = [[TKVideoFunctionView  alloc] initWithFrame:CGRectMake(0, 0, _itemWidth, CollectionCellHeight) aVideoRole:_videoRole aRoomUer:_iRoomUser isSplit:_isSplit count:_controlButtonCount];
            TKVideoFunctionView *view = (TKVideoFunctionView *)_videoToolView;
            
            view.iDelegate = self;
            view.isSplitScreen = self.isSplit;
        }
    }
    return _videoToolView;
}


- (void)touchOutSide
{
    if (_dismissOnTouchOutside) {
        [self dismiss];
    }
}

#pragma mark - TKVideoFunctionView Delegate 实现
-(void)videoSmallbutton1:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole{
    //根据角色判断  老师：关闭视频  学生：授权涂鸦
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPopupMenuControlVideoOrCanDraw:aVideoRole:)] ) {
        [self.delegate videoPopupMenuControlVideoOrCanDraw:aButton aVideoRole:aVideoRole];
    }
    
}
-(void)videoSmallButton2:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPopupMenuControlAudioOrUnderPlatform:aVideoRole:)] ) {
        [self.delegate videoPopupMenuControlAudioOrUnderPlatform:aButton aVideoRole:aVideoRole];
    }
}
-(void)videoSmallButton3:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPopupMenuControlAudio:aVideoRole:)] ) {
        [self.delegate videoPopupMenuControlAudio:aButton aVideoRole:aVideoRole];
    }
}
-(void)videoSmallButton4:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPopupMenuSendGif:aVideoRole:)] ) {
        [self.delegate videoPopupMenuSendGif:aButton aVideoRole:aVideoRole];
    }
}
-(void)videoSmallButton5:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPopupMenuControlVideo:aVideoRole:)] ) {
        [self.delegate videoPopupMenuControlVideo:aButton aVideoRole:aVideoRole];
    }
}
-(void)videoSmallButton6:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoSplitScreenVideo:aVideoRole:)] ) {
        [self.delegate videoSplitScreenVideo:aButton aVideoRole:aVideoRole];
    }
}
-(void)videoSmallButton7:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPopupMenuControlRestorePosition:aVideoRole:)]) {
        [self.delegate videoPopupMenuControlRestorePosition:aButton aVideoRole:aVideoRole];
    }
}
-(void)videoSmallButton8:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPopupMenuControlRestoreAll:aVideoRole:)]) {
        [self.delegate videoPopupMenuControlRestoreAll:aButton aVideoRole:aVideoRole];
    }
}

#pragma mark - 初始化设置 以及 位置设置
- (void)setIsShowShadow:(BOOL)isShowShadow
{
    _isShowShadow = isShowShadow;
    self.layer.shadowOpacity = isShowShadow ? 0.5 : 0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = isShowShadow ? 2.0 : 0;
}

- (void)setShowMaskView:(BOOL)showMaskView
{
    _showMaskView = showMaskView;
//    _menuBackView.backgroundColor = showMaskView ? [[UIColor blackColor] colorWithAlphaComponent:0.1] : [UIColor clearColor];
}

- (void)setType:(YBPopupMenuType)type
{
    _type = type;
    switch (type) {
        case TKPopupMenuTypeDark:
        {
            
            _backColor = [UIColor colorWithRed:0.25 green:0.27 blue:0.29 alpha:1];
            _separatorColor = [UIColor lightGrayColor];
        }
            break;
            
        default:
        {
            _backColor = [UIColor whiteColor];
            _separatorColor = [UIColor lightGrayColor];
        }
            break;
    }
    [self updateUI];
}

- (void)setPoint:(CGPoint)point
{
    _point = point;
    [self updateUI];
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    [self updateUI];
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    _itemHeight = itemHeight;
    [self updateUI];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateUI];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self updateUI];
}

- (void)setArrowPosition:(CGFloat)arrowPosition
{
    _arrowPosition = arrowPosition;
    [self updateUI];
}

- (void)setArrowWidth:(CGFloat)arrowWidth
{
    _arrowWidth = arrowWidth;
    [self updateUI];
}

- (void)setArrowHeight:(CGFloat)arrowHeight
{
    _arrowHeight = arrowHeight;
    [self updateUI];
}

- (void)setArrowDirection:(YBPopupMenuArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self updateUI];
}

- (void)setMaxVisibleCount:(NSInteger)maxVisibleCount
{
    [self updateUI];
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    [self updateUI];
}

- (void)setPriorityDirection:(YBPopupMenuPriorityDirection)priorityDirection
{
    _priorityDirection = priorityDirection;
    [self updateUI];
}

- (void)setRectCorner:(UIRectCorner)rectCorner
{
    _rectCorner = rectCorner;
    [self updateUI];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateUI];
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    [self updateUI];
}

- (void)updateUI
{
    CGFloat height;
    height = _itemHeight;

     _isChangeDirection = NO;
    if (_priorityDirection == TKPopupMenuPriorityDirectionTop) {
        if (_point.y + height + _arrowHeight > ScreenH - _minSpace) {
            _arrowDirection = TKPopupMenuArrowDirectionBottom;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = TKPopupMenuArrowDirectionTop;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == TKPopupMenuPriorityDirectionBottom) {
        
        if ((_point.y - height - _arrowHeight < _minSpace) && !_isSplit) {
            _arrowDirection = TKPopupMenuArrowDirectionTop;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = TKPopupMenuArrowDirectionBottom;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == TKPopupMenuPriorityDirectionLeft) {
        if (_point.x + _itemWidth + _arrowHeight > ScreenW - _minSpace) {
            _arrowDirection = TKPopupMenuArrowDirectionRight;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = TKPopupMenuArrowDirectionLeft;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == TKPopupMenuPriorityDirectionRight) {
        
        if (_point.x - _itemWidth - _arrowHeight < _minSpace) {
            _arrowDirection = TKPopupMenuArrowDirectionLeft;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = TKPopupMenuArrowDirectionRight;
            _isChangeDirection = NO;
        }
    }
    [self setArrowPosition];
    [self setRelyRect];
    if (_arrowDirection == TKPopupMenuArrowDirectionTop) {
        CGFloat y = _isChangeDirection ? _point.y  : _point.y;
        if (_arrowPosition > _itemWidth / 2) {
            self.frame = CGRectMake(ScreenW - _minSpace - _itemWidth, y, _itemWidth, height + _arrowHeight);
        }else if (_arrowPosition < _itemWidth / 2) {
            self.frame = CGRectMake(_minSpace, y, _itemWidth, height + _arrowHeight);
        }else {
            self.frame = CGRectMake(_point.x - _itemWidth / 2, y, _itemWidth, height + _arrowHeight);
        }
    }else if (_arrowDirection == TKPopupMenuArrowDirectionBottom) {
       
        if (_isSplit) {//分屏状态下
            
            self.frame = CGRectMake(_relyRect.origin.x,_relyRect.origin.y, _itemWidth,  height + _arrowHeight);
        }else{
            CGFloat y = _isChangeDirection ? _point.y - _arrowHeight - height : _point.y - _arrowHeight - height;
            if (_arrowPosition > _itemWidth / 2) {
                self.frame = CGRectMake(ScreenW - _minSpace - _itemWidth, y, _itemWidth, height + _arrowHeight);
            }else if (_arrowPosition < _itemWidth / 2) {
                self.frame = CGRectMake(_minSpace, y, _itemWidth, height + _arrowHeight);
            }else {
                self.frame = CGRectMake(_point.x - _itemWidth / 2, y, _itemWidth, height + _arrowHeight);
            }
        }
        
        
    }else if (_arrowDirection == TKPopupMenuArrowDirectionLeft) {
        CGFloat x = _isChangeDirection ? _point.x : _point.x;
        if (_arrowPosition < _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }else if (_arrowPosition > _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }else {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }
    }else if (_arrowDirection == TKPopupMenuArrowDirectionRight) { //箭头在右边   主要在1v1模式下使用 || 经典原结构的老师视频下
      
        CGFloat x = _isChangeDirection ? _point.x - _itemWidth - _arrowHeight : _point.x - _itemWidth - _arrowHeight;
        CGFloat y = _point.y - _arrowPosition;
        if (_videoRole == TKEVideoRoleOur && IS_IPHONE && _controlButtonCount>3) {
            y = y - _relyRect.size.height;
        }
        if (_arrowPosition < _itemHeight / 2) {
            self.frame = CGRectMake(x, y, _itemWidth + _arrowHeight, height);
        }else if (_arrowPosition > _itemHeight / 2) {
            self.frame = CGRectMake(x, y, _itemWidth + _arrowHeight, height);
        }else {
            self.frame = CGRectMake(x, y, _itemWidth + _arrowHeight, height);
        }
        
    }else if (_arrowDirection == TKPopupMenuArrowDirectionNone) {
        
    }
    
    if (_isChangeDirection) {
        [self changeRectCorner];
    }
    [self setAnchorPoint];
    [self setOffset];
    [self setNeedsDisplay];
}

- (void)setRelyRect
{
    if (CGRectEqualToRect(_relyRect, CGRectZero)) {
        return;
    }
    if (_arrowDirection == TKPopupMenuArrowDirectionTop) {
        _point.y = _relyRect.size.height + _relyRect.origin.y;
    }else if (_arrowDirection == TKPopupMenuArrowDirectionBottom) {
        _point.y = _relyRect.origin.y;
    }else if (_arrowDirection == TKPopupMenuArrowDirectionLeft) {
        _point = CGPointMake(_relyRect.origin.x + _relyRect.size.width, _relyRect.origin.y + _relyRect.size.height / 2);
    }else {
        _point = CGPointMake(_relyRect.origin.x, _relyRect.origin.y);
    }
}

//设置内容区域
- (void)resetVideoToolFrame:(CGRect)frame
{
//    [super setFrame:frame];
    if (_arrowDirection == TKPopupMenuArrowDirectionTop) {
        self.videoToolView.frame = CGRectMake(_borderWidth, _borderWidth + _arrowHeight, frame.size.width - _borderWidth * 2, frame.size.height - _arrowHeight);
    }else if (_arrowDirection == TKPopupMenuArrowDirectionBottom) {
        self.videoToolView.frame = CGRectMake(_borderWidth, _borderWidth, frame.size.width - _borderWidth * 2, frame.size.height - _arrowHeight);
    }else if (_arrowDirection == TKPopupMenuArrowDirectionLeft) {
        self.videoToolView.frame = CGRectMake(_borderWidth + _arrowHeight, _borderWidth , frame.size.width - _borderWidth * 2 - _arrowHeight, frame.size.height);
    }else if (_arrowDirection == TKPopupMenuArrowDirectionRight) {
        self.videoToolView.frame = CGRectMake(_borderWidth , _borderWidth , frame.size.width - _borderWidth * 2 - _arrowHeight, frame.size.height);
    }
}

- (void)changeRectCorner
{
    if (_isCornerChanged || _rectCorner == UIRectCornerAllCorners) {
        return;
    }
    BOOL haveTopLeftCorner = NO, haveTopRightCorner = NO, haveBottomLeftCorner = NO, haveBottomRightCorner = NO;
    if (_rectCorner & UIRectCornerTopLeft) {
        haveTopLeftCorner = YES;
    }
    if (_rectCorner & UIRectCornerTopRight) {
        haveTopRightCorner = YES;
    }
    if (_rectCorner & UIRectCornerBottomLeft) {
        haveBottomLeftCorner = YES;
    }
    if (_rectCorner & UIRectCornerBottomRight) {
        haveBottomRightCorner = YES;
    }
    
    if (_arrowDirection == TKPopupMenuArrowDirectionTop || _arrowDirection == TKPopupMenuArrowDirectionBottom) {
        
        if (haveTopLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomLeft);
        }
        if (haveTopRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomRight);
        }
        if (haveBottomLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopLeft);
        }
        if (haveBottomRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopRight);
        }
        
    }else if (_arrowDirection == TKPopupMenuArrowDirectionLeft || _arrowDirection == TKPopupMenuArrowDirectionRight) {
        if (haveTopLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopRight);
        }
        if (haveTopRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopLeft);
        }
        if (haveBottomLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomRight);
        }
        if (haveBottomRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomLeft);
        }
    }
    
    _isCornerChanged = YES;
}

- (void)setOffset
{
    if (_itemWidth == 0) return;
    
    CGRect originRect = self.frame;
    
    if (_arrowDirection == TKPopupMenuArrowDirectionTop) {
        originRect.origin.y += _offset;
    }else if (_arrowDirection == TKPopupMenuArrowDirectionBottom) {
        originRect.origin.y -= _offset;
    }else if (_arrowDirection == TKPopupMenuArrowDirectionLeft) {
        originRect.origin.x += _offset;
    }else if (_arrowDirection == TKPopupMenuArrowDirectionRight) {
        originRect.origin.x -= _offset;
    }
    self.frame = originRect;
}

- (void)setAnchorPoint
{
    if (_itemWidth == 0) return;
    
    CGPoint point = CGPointMake(0.5, 0.5);
    if (_arrowDirection == TKPopupMenuArrowDirectionTop) {
        point = CGPointMake(_arrowPosition / _itemWidth, 0);
    }else if (_arrowDirection == TKPopupMenuArrowDirectionBottom) {
        point = CGPointMake(_arrowPosition / _itemWidth, 1);
    }else if (_arrowDirection == TKPopupMenuArrowDirectionLeft) {
        point = CGPointMake(0, (_itemHeight - _arrowPosition) / _itemHeight);
    }else if (_arrowDirection == TKPopupMenuArrowDirectionRight) {
        point = CGPointMake(1, (_itemHeight - _arrowPosition) / _itemHeight);
    }
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}

- (void)setArrowPosition
{
    if (_priorityDirection == TKPopupMenuPriorityDirectionNone) {
        return;
    }
    if (_arrowDirection == TKPopupMenuArrowDirectionTop || _arrowDirection == TKPopupMenuArrowDirectionBottom) {
        if (_point.x + _itemWidth / 2 > ScreenW - _minSpace) {
            _arrowPosition = _itemWidth - (ScreenW - _minSpace - _point.x);
        }else if (_point.x < _itemWidth / 2 + _minSpace) {
            _arrowPosition = _point.x - _minSpace;
        }else {
            _arrowPosition = _itemWidth / 2;
        }
        
    }
}

- (void)drawRect:(CGRect)rect
{
    //主要设置箭头样式和位置
    UIBezierPath *bezierPath = [TKPopupMenuPath yb_bezierPathWithRect:rect rectCorner:_rectCorner cornerRadius:_cornerRadius borderWidth:_borderWidth borderColor:_borderColor backgroundColor:_backColor arrowWidth:_arrowWidth arrowHeight:_arrowHeight arrowPosition:_arrowPosition arrowDirection:_arrowDirection];
    
    [bezierPath fill];
    [bezierPath stroke];
}

@end
