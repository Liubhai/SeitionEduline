//
//  TKCTNewChatView.m
//  EduClass
//
//  Created by talk on 2018/11/22.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKCTNewChatView.h"
#import "TKNewMessageCell.h"
#import "TKNewChatMessageTableViewCell.h"
#import "TKNewChatToolView.h"

#define ThemeKP(args) [@"ClassRoom.TKChatViews." stringByAppendingString:args]
#define ThemeNavViewKP(args) [@"ClassRoom.TKNavView." stringByAppendingString:args]

@implementation TKCTNewChatView
{
    CGFloat _btnWidth;
    CGFloat _btnSpace;
    
    UIButton *_middleBtn;
    UIButton *_rightBtn;
    UIButton *_leftBtn;
    CAGradientLayer *_gLayer;
    
    UILabel *_badgeLabel;
    
    BOOL _shouldShowKeyboard;

}

@synthesize keyboardView = _keyboardView;

- (instancetype)initWithFrame:(CGRect)frame chatController:(NSString *)chatController
{
    if (self = [super initWithFrame:frame chatController:chatController]) {
        self.chatCellClass = [TKNewChatMessageTableViewCell class];
        self.msgCellClass = [TKNewMessageCell class];
        self.alpha = 1;
        self.iChatTableView.alpha = 0;
        self.tTimeLabelHeigh = 16 * Proportion;
        self.tContentWidth -= 40;
        //        self.tTranslateLabelWidth -= 40;
        [self newUI];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    NSNumber * old = [change objectForKey:NSKeyValueChangeOldKey];
    NSNumber * new = [change objectForKey:NSKeyValueChangeNewKey];
    
    if (old.floatValue == new.floatValue || new.floatValue == 1) {
        return;
    }
    
    __block float height = 0;
    
    if (self.iMessageList.lastObject.iMessageType == TKMessageTypeMessage) {
        height += 30;
    } else {
        height += self.iMessageList.lastObject.height;
    }
    
    float top = self.iChatTableView.contentInset.top;
    top -= height;
    if (top >= 0) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.iChatTableView setContentInset:UIEdgeInsetsMake(top, 0, 0, 0)];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [self.iChatTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.iMessageList.count;
}

- (void)newUI
{
    [self addObserver:self forKeyPath:@"msgCount" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    self.contentImageView.image = nil;
    self.backImageView.image = nil;
    self.xButton.hidden = YES;
    [self.closeButton removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.toolView removeFromSuperview];
    self.backgroundColor = UIColor.clearColor;
    self.iChatTableView.backgroundColor = UIColor.clearColor;;
    self.iChatTableView.showsVerticalScrollIndicator = NO;
    
    _btnWidth = 46;
    _btnSpace = 20;
    [self addSubview:self.iChatTableView];
    self.iChatTableView.frame = CGRectMake(0, 0, self.width, self.height - _btnWidth);
    self.iChatTableView.contentInset = UIEdgeInsetsMake(self.iChatTableView.height, 0, 0, 0);
    self.iChatTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1f)];
    
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xButton = _rightBtn;//使用父类中xButton的逻辑
    _rightBtn.frame = CGRectMake(0, self.height - _btnWidth, _btnWidth, _btnWidth);
    _rightBtn.sakura.image(ThemeNavViewKP(@"button_message_onview_jinyan"), UIControlStateNormal);
    _rightBtn.sakura.image(ThemeNavViewKP(@"button_message_onview_yijinyan"), UIControlStateSelected);
    [_rightBtn addTarget:self action:@selector(shutUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    
    _middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _middleBtn.frame = CGRectMake(0, self.height - _btnWidth, _btnWidth, _btnWidth);
    _middleBtn.sakura.image(ThemeNavViewKP(@"button_message_onview_input"), UIControlStateNormal);
    _middleBtn.sakura.image(ThemeNavViewKP(@"button_message_onview_input_disable"), UIControlStateSelected);

    [_middleBtn addTarget:self action:@selector(input) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_middleBtn];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, self.height - _btnWidth, _btnWidth, _btnWidth);
    _leftBtn.sakura.image(ThemeNavViewKP(@"button_message_onview"), UIControlStateNormal);
    _leftBtn.sakura.image(ThemeNavViewKP(@"button_message_onview_selected"), UIControlStateSelected);
    [_leftBtn addTarget:self action:@selector(showMessageView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftBtn];
    
    _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftBtn.frame) - 17, _leftBtn.y + 1, 16, 16)];
    _badgeLabel.layer.cornerRadius = _badgeLabel.width / 2;
    _badgeLabel.layer.masksToBounds = YES;
    _badgeLabel.font = TKFont(8);
    _badgeLabel.backgroundColor = UIColor.redColor;
    _badgeLabel.textColor = UIColor.whiteColor;
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabel.lineBreakMode = NSLineBreakByClipping;
    _badgeLabel.hidden = YES;
    [self addSubview:_badgeLabel];
    
    _middleBtn.alpha = _rightBtn.alpha = 0;
    
    //////////////////////////////////////////////////
    //巡课不允许发送聊天消息
    //隐藏中间聊天按钮
    _middleBtn.hidden = ([TKEduSessionHandle shareInstance].localUser.role == TKUserType_Patrol);
    
    
    //////////////////添加渐变_gLayer//////////////////
    _gLayer = [CAGradientLayer layer];
    _gLayer.colors = @[(id)UIColor.whiteColor.CGColor,(id)UIColor.whiteColor.CGColor, (id)UIColor.clearColor];
    _gLayer.locations = @[@0.5f, @0.7f];
    _gLayer.startPoint = CGPointMake(0, 1);
    _gLayer.endPoint = CGPointMake(0, 0);
    
    _gLayer.anchorPoint = CGPointMake(0, 0);
    _gLayer.bounds = CGRectMake(0, 0, self.iChatTableView.width, self.iChatTableView.height);
    self.iChatTableView.layer.mask = _gLayer;
}

- (void)setBadgeNumber:(float)num
{
    if (num > 0) {
        if (num < 100) {
            _badgeLabel.text = [NSString stringWithFormat:@"%d",(int)num];
        } else {
            _badgeLabel.text = @"99+";
        }
        _badgeLabel.hidden = NO;
    } else {
        
        _badgeLabel.hidden = YES;
        _badgeLabel.text = @"";
    }
}

- (TKChatToolView *)keyboardView{
    if (!_keyboardView) {
        
        CGFloat x = IS_IPHONE_X ?  44 : 0;
        self.keyboardView = [[TKNewChatToolView alloc] initWithFrame:CGRectMake(x,
                                                                                ScreenH+44,
                                                                                ScreenW - x,
                                                                                44) isDistance:true];
        _keyboardView.sakura.backgroundColor(ThemeKP(@"chatToolBackColor"));
        _keyboardView.delegate = self;
        [TKMainWindow addSubview:_keyboardView];
    }
    return _keyboardView;
}

//渐变_gLayer随动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    layer1.position = CGPointMake(0, scrollView.contentOffset.y);
    //    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"position"];
    //    ani.fromValue= [NSValue valueWithCGPoint:layer1.position];
    //    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(0, scrollView.contentOffset.y)];
    //    ani.duration = 0;
    //    ani.removedOnCompletion = YES;
    //    ani.autoreverses = NO;
    //    [layer1 addAnimation:ani forKey:nil];
    
    //直接修改属性会产生隐式动画，时长为0.25s，这样导致滑动时不跟手，可以用上面的CABasicAnimation设置动画时长为0.
    //或者使用下面的CATransaction动画事务，setDisableActions:YES或者setAnimationDuration:0都可以达到效果，
    //但是setDisableActions应该性能更高吧，毕竟是直接关闭了动画。setAnimationDuration仍然是设置动画时长为0
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    //    [CATransaction setAnimationDuration:0];
    _gLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}

//判断只有point落在本view的button或者table上才有效，避免本透明view遮挡白板操作
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //    NSArray<UIView *> *arr = @[_leftBtn, _middleBtn, _rightBtn, self.iChatTableView];
    NSMutableArray<UIView *> *mArr = [@[] mutableCopy];
    [mArr addObject:_leftBtn];
    
    if (!_middleBtn.hidden) {
        [mArr addObject:_middleBtn];
    }
    
    if (!_rightBtn.hidden) {
        [mArr addObject:_rightBtn];
    }
    
    if (self.iChatTableView.alpha != 0) {
        [mArr addObject:self.iChatTableView];
    }
    
    BOOL pointOnSelf = NO;
    
    for (UIView *tmp in mArr) {
        CGPoint viewPoint = [self convertPoint:point toView:tmp];
        if ([tmp isKindOfClass:UITableView.class]) {
            //只有当point在可显示的cell的bubble上时才可触发点击，避免遮挡后面的按钮
            for (UITableViewCell *cell in self.iChatTableView.visibleCells) {
                if ([cell isKindOfClass:[TKNewMessageCell class]]) {
                    TKNewMessageCell *mCell = (TKNewMessageCell *)cell;
                    CGPoint pointOnCell = [self.iChatTableView convertPoint:viewPoint toView:mCell];
                    if (pointOnCell.x >= 0 && pointOnCell.x <= mCell.bubbleView.width && pointOnCell.y >= 0 && pointOnCell.y <= mCell.height) {
                        pointOnSelf = YES;
                    }
                } else {
                    TKNewChatMessageTableViewCell *cCell = (TKNewChatMessageTableViewCell *)cell;
                    CGPoint pointOnCell = [self.iChatTableView convertPoint:viewPoint toView:cCell];
                    if (pointOnCell.x >= 0 && pointOnCell.x <= cCell.bubbleView.width && pointOnCell.y >= 0 && pointOnCell.y <= cCell.height) {
                        pointOnSelf = YES;
                    }
                }
            }
            
        } else {
            if (viewPoint.x >= 0 && viewPoint.x <= tmp.width && viewPoint.y >= 0 && viewPoint.y <= tmp.height) {
                pointOnSelf = YES;
            }
        }
    }
    
    return pointOnSelf;
}

- (void)showMessageView:(UIButton *)sender
{
    [self loadNotification];
    //只有老师可以显示禁言按钮
    _rightBtn.hidden = !([TKEduSessionHandle shareInstance].roomMgr.localUser.role == TKUserType_Teacher);
    //巡课隐藏发言按钮
    _middleBtn.hidden = ([TKEduSessionHandle shareInstance].localUser.role == TKUserType_Patrol);
    
    sender.selected = !sender.selected;
    if (self.messageBtnClickBlock) {
        self.messageBtnClickBlock(sender);
    }
    [UIView animateWithDuration:0.3f animations:^{
        if (sender.selected) {
            _middleBtn.sakura.image(@"TKNavView.button_message_onview_input_highLight", UIControlStateNormal);//button_message_onview_input_highLight
            _middleBtn.x = _btnWidth + _btnSpace;
            _rightBtn.x = (_btnWidth + _btnSpace) * (_middleBtn.hidden ? 1 : 2);
            _middleBtn.alpha = _rightBtn.alpha = 1;
        } else {
            _middleBtn.sakura.image(@"TKNavView.button_message_onview_input", UIControlStateNormal);
            _middleBtn.alpha = _rightBtn.alpha = _middleBtn.x = _rightBtn.x = 0;
            
        }
        
        self.iChatTableView.alpha = sender.selected ? 1 : 0;
    } completion:^(BOOL finished) {
        if (sender.selected) {
            [self reloadData];
        }
    }];
}

- (void)setUserRoleType:(TKUserRoleType)type
{
    //TODO :暂时只有学生隐藏禁言按钮
    switch (type) {
        case TKUserType_Teacher:
        {
            //老师
            _rightBtn.hidden = _middleBtn.hidden = NO;
            break;
        }
        case TKUserType_Student:
        {
            //学生
            _rightBtn.hidden = YES;
            break;
        }
        case TKUserType_Patrol:
        {
            //巡课
            _rightBtn.hidden = _middleBtn.hidden = YES;
            break;
        }
        case TKUserType_Playback:
        {
            //回放
            break;
        }
        case TKUserType_Live:
        {
            //直播
            break;
        }
        case TKUserType_Assistant:
        {
            //助教
            break;
        }
        default:
            break;
    }
}

- (void)input
{
    if (_middleBtn.selected) {
        //不能发消息 提示： 你已经被禁言，无法发送消息
//        [TKUtil showMessage:MTLocalized(@"Prompt.ClassEndTime")]];
        [TKUtil showMessage:@"你已经被禁言，无法发送消息"];

    }else{
        // 从window移除后 导致键盘无法显示，需要重新add
        if (!self.keyboardView.superview) {
            CGFloat x = IS_IPHONE_X ?  44 : 0;
            self.keyboardView.frame = CGRectMake(x, ScreenH+44, ScreenW - x, 44);
            [TKMainWindow addSubview:self.keyboardView];
        }
        
        self.keyboardView.hidden = NO;
        [self.keyboardView.inputField becomeFirstResponder];
    }
}

- (void)banChat:(NSNotification *)notification
{
    [super banChat:notification];
    
    NSDictionary *message = notification.object;
    BOOL isBanSpeak = [TKUtil getBOOValueFromDic:message Key:@"isBanSpeak"];
    if ([TKEduSessionHandle shareInstance].localUser.role != TKUserType_Teacher) {
        _middleBtn.selected = isBanSpeak;
    }
}

- (void)hide:(BOOL)hide
{
    if (hide) {
        //不知道为什么此处隐藏chatView 需要移除监听，
        //fix bug TALK-6797 当移除监听前，回收键盘，防止键盘不回收的情况
        [self.keyboardView.inputField resignFirstResponder];
        //退出教室后 屏幕从横屏转向竖屏 键盘会显示出来
        self.keyboardView.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    } else {
        [self loadNotification];
        self.keyboardView.hidden = NO;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        if (!hide) {
            _middleBtn.x = _btnWidth + _btnSpace;
            _rightBtn.x = (_btnWidth + _btnSpace) * 2;
            _middleBtn.alpha = _rightBtn.alpha = 1;
        } else {
            _middleBtn.alpha = _rightBtn.alpha = _middleBtn.x = _rightBtn.x = 0;
        }
        self.iChatTableView.alpha = !hide ? 1 : 0;
    } completion:^(BOOL finished) {
        if (!hide) {
            [self reloadData];
        }
        _leftBtn.selected = !hide;
    }];
    
    if (_hideComplete) {
        _hideComplete();
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[TKNewMessageCell class]]) {
        TKChatMessageModel *tMessageModel = [self.iMessageList objectAtIndex:indexPath.section];
        //聊天框禁言消息进入退出消息不需要时间，禁言消息显示红色
        [cell performSelector:@selector(setIMessageText:) withObject:[NSString stringWithFormat:@"%@", tMessageModel.iMessage]];
        [cell performSelector:@selector(resetView)];
        [cell performSelector:@selector(setTextColor:) withObject:tMessageModel.iMessageTypeColor];

    }
    return cell;
}

#pragma mark - 计算缓存 cell 高度
- (void)calculateCellHeight {
    
    [self.iMessageList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TKChatMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 系统消息不计算
        if (obj.iMessageType == TKMessageTypeMessage) {
            return;
        }
        
        // 文字高度
        if (!(obj.messageHeight > 0)) {// 如果未计算过
            float nameWidth = [self.chatCellClass sizeFromText:[NSString stringWithFormat:@"%@:", (obj.iMessageType == TKMessageTypeMe) ? MTLocalized(@"Role.Me") : obj.iUserName] withLimitWidth:fminf(self.iChatTableView.width / 3, 100) Font:TKFont(14)].width;
            float limitWidth = self.iChatTableView.width - 11 - nameWidth - 10 - 10 - 10 - 22;
            
            CGFloat msgHeight = [TKNewChatMessageTableViewCell heightForCellWithText:obj.iMessage.length > 0 ? obj.iMessage : @" "
                                                                       limitWidth:limitWidth];
            
//            CGSize msgSize = [self.chatCellClass sizeFromAttributedString:obj.iMessage.length > 0 ? obj.iMessage : @" "
//                                                           withLimitWidth:msgWidth
//                                                                     Font:TKFont(14)];
            
            obj.messageHeight = msgHeight;
            obj.height = 16 * Proportion +// 消息内容上边距
            obj.messageHeight + 16 * Proportion;  // 时间高度
        }
        // 翻译高度
        [self calculateTranslationHeight:obj];
    }];
}

// 计算翻译高度
- (void)calculateTranslationHeight:(TKChatMessageModel *)obj {
    
    // 翻译高度
    if (obj.iTranslationMessage.length > 0 && !(obj.translationHeight > 0)) {// 如果未计算过
        float nameWidth = [self.chatCellClass sizeFromText:[NSString stringWithFormat:@"%@:", (obj.iMessageType == TKMessageTypeMe) ? MTLocalized(@"Role.Me") : obj.iUserName] withLimitWidth:fminf(self.iChatTableView.width / 3, 100) Font:TKFont(14)].width;
        float msgWidth = self.iChatTableView.width - 11 - nameWidth - 10 - 10 - 10 - 11;
        CGSize msgSize = [self.chatCellClass sizeFromAttributedString:obj.iMessage.length > 0 ? obj.iMessage : @" "
                                                       withLimitWidth:msgWidth
                                                                 Font:TKFont(14)];
        float cellWidth = 11 + nameWidth + 10 + msgSize.width + 10 + 11 + 10;
        
        obj.translationHeight = [TKChatMessageTableViewCell sizeFromText:obj.iTranslationMessage
                                                          withLimitWidth:cellWidth - 20
                                                                    Font:TKFont(14)].height;
        obj.height += 10 * 2 + // 分割线上下边距
        obj.translationHeight + 0;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 系统消息
    if (self.iMessageList[indexPath.section].iMessageType == TKMessageTypeMessage) {
        return 30. + 8;
        
    }

    return self.iMessageList[indexPath.section].height + 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}


- (void)reloadData
{
    [super reloadData];
    
    if (self.iChatTableView.contentInset.top == 0) {
        return;
    }
    
    self.msgCount = self.iMessageList.count;
}

- (void)removeSubviews
{
    [self.keyboardView removeFromSuperview];
}

- (void)dealloc
{
//    NSLog(@"");
}

@end
