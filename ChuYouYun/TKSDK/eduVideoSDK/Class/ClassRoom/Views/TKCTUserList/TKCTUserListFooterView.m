//
//  TKCTUserListFooterView.m
//  EduClass
//
//  Created by talkcloud on 2018/10/15.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKCTUserListFooterView.h"
#import "TKPageView.h"
#import "TKUserListToolView.h"

#define toolHeight 44

#define ThemeKP(args) [@"TKUserListView." stringByAppendingString:args]

@interface TKCTUserListFooterView()<UIGestureRecognizerDelegate,UITextFieldDelegate,TKUserListToolViewDelegate>
{
    NSInteger _totalNum;
    NSInteger _currentNum;
}
@property (nonatomic, strong) TKPageView *pageView;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;

@property (nonatomic, strong) TKUserListToolView *toolView;// 实际 聊天输入工具条

@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic, assign) CGFloat keyboardViewHeight;

@end

@implementation TKCTUserListFooterView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    //弹起：
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //回收：
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.backgroundColor = [UIColor clearColor];
    
    //    self.jumpBtn.layer.masksToBounds = YES;
    //    self.jumpBtn.layer.cornerRadius = 11;
    //    self.jumpBtn.sakura.backgroundColor(ThemeKP(@"userList_jumpBackColor"));
    //    [self.jumpBtn setTitle:MTLocalized(@"跳转") forState:UIControlStateNormal];
    self.currentPage.delegate = self;
    self.currentpageView.layer.masksToBounds = YES;
    self.currentpageView.layer.cornerRadius = 5;
//    self.currentpageView.layer.borderColor = [TKTheme cgColorWithPath:ThemeKP(@"userList_TextColor")];
//    self.currentpageView.layer.borderWidth = 1;
//    self.currentpageView.sakura.backgroundColor(ThemeKP(@"userList_currentPageBackColor"));
    
    self.lineLabel.sakura.textColor(ThemeKP(@"userList_TextColor"));
    self.totalPage.sakura.textColor(ThemeKP(@"userList_TextColor"));
    self.currentPage.sakura.textColor(ThemeKP(@"userList_TextColor"));
    
    self.preBtn.sakura.image(ThemeKP(@"userlist_left_unclickable"),UIControlStateNormal);
    self.preBtn.sakura.image(ThemeKP(@"userlist_left"),UIControlStateSelected);
    self.preBtn.imageView.contentMode = UIViewContentModeCenter;
    self.preBtn.selected = NO;
    
    self.nextBtn.sakura.image(ThemeKP(@"userlist_right_unclickable"),UIControlStateNormal);
    self.nextBtn.sakura.image(ThemeKP(@"userlist_right"),UIControlStateSelected);
    self.nextBtn.imageView.contentMode = UIViewContentModeCenter;
    self.nextBtn.selected = YES;
}


- (void)setCurrentPageNum:(NSInteger)pageNum{
    _currentNum = pageNum;
    [self setPageButtonStates];
    self.currentPage.text = [NSString stringWithFormat:@"%d",(int)pageNum];
    
}
- (void)setTotalNum:(NSInteger)totalNum{
    _totalNum = totalNum;
    [self setPageButtonStates];
    self.totalPage.text = [NSString stringWithFormat:@"%d",(int)totalNum];
    
}
- (void)setPageButtonStates{
    if (_currentNum == 1) {//当前为第一页不允许往前翻页
        self.preBtn.selected = NO;
        self.preBtn.enabled = NO;
    }
    if (_currentNum == _totalNum) {//当前页等于总页数不允许往后翻页
        
        self.nextBtn.selected = NO;
        self.nextBtn.enabled = NO;
    }
    if (_currentNum < _totalNum) {//当前页小于总页数允许往后翻页
        self.nextBtn.selected = YES;
        self.nextBtn.enabled = YES;
    }
    if (_currentNum >1) {//当前页不是第一页允许往前翻页
        self.preBtn.selected = YES;
        self.preBtn.enabled = YES;
    }
    if (_totalNum == 1) {//总页码为1的时候不允许弹出页码选择框
        self.currentPage.enabled = NO;
        
    }else{
        
        self.currentPage.enabled = YES;
    }
}

- (IBAction)nextPage:(UIButton *)sender {
    if (!sender.selected) {
        return;
    }
    if (self.nextPage) {
        self.nextPage();
    }
}

- (IBAction)prePage:(UIButton *)sender {
    if (!sender.selected) {
        return;
    }
    if (self.prePage) {
        self.prePage();
    }
}

- (void) keyboardWillShow : (NSNotification*)notification {
    
    if (![self.toolView.textField isFirstResponder]) {
        return;
    }
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        self.keyboardHeight = keyboardF.size.height;
        _keyboardViewHeight = _keyboardViewHeight ? _keyboardViewHeight : toolHeight;
        _toolView.y = ScreenH - self.keyboardHeight - _keyboardViewHeight;
        
        
    }];
}
- (void) keyboardWillHide : (NSNotification*)notification {
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.keyboardHeight = 0;
        _toolView.y = ScreenH+toolHeight;
        [_toolView removeFromSuperview];
        _toolView = nil;
    }];
    
}

- (void)hiddenKeyBoard:(UITapGestureRecognizer *)gesture{
    [self endEditing:YES];
}

- (IBAction)showTool:(UIButton *)sender {
    // 花名册 跳页功能 暂时去掉
//    if (_totalNum > 2) {
//        return;
//    }
//    [self.currentPage resignFirstResponder];
//    [self.toolView.textField becomeFirstResponder];
}

- (UIView *)toolView{
    if (!_toolView) {
        _toolView = [[TKUserListToolView alloc] initWithFrame:CGRectMake(0, ScreenH+toolHeight, ScreenW, toolHeight)];
        _toolView.delegate = self;
        
        _toolView.textField.delegate = self;
        [TKMainWindow addSubview:_toolView];
    }
    return _toolView;
}
-(void)jumpPageNum:(int)pageNum{
    if (pageNum<1) {
        pageNum = 1;
    }
    if ( pageNum>_totalNum) {
        pageNum = (int)_totalNum;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userListJumpPageNum:)]) {
        [self.delegate userListJumpPageNum:pageNum];
    }
    
}

- (void)destory{
    [_toolView removeFromSuperview];
    _toolView = nil;
}

@end
