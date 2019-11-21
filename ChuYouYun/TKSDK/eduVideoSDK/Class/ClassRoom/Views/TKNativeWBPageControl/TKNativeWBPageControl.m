//
//  TKNativeWBPageControl.m
//  TKWhiteBoard
//
//  Created by 周洁 on 2018/12/27.
//  Copyright © 2018 MAC-MiNi. All rights reserved.
//

#import "TKNativeWBPageControl.h"
#import "Masonry.h"
#import "UIView+Drag.h"
#import "TKManyViewController.h"
#import "TKNativeWBRemarkView.h"

#define LargeNarrowLevelMax 3
#define LargeNarrwoLevelMin 1
#define ThemeKP(args) [@"TKNativeWB.PageControl." stringByAppendingString:args]
#define ProportionToPageControl (IS_PAD ? 1 : 0.8f)

@implementation TKNativeWBPageControl
{
    TKNativePageTableView *_pageView; // 选页页面
    UIButton *_enlarge;        // 放大
    UIButton *_narrow;        // 缩小
    UIButton *_page;        // 选页按钮
    UIButton *_mark;        // 课件备注
    
    NSInteger _totalPage;
    NSInteger _currentPage;
    
    TKNativeWBRemarkView *_remarkView;
    UIView				 *_contentView;
    

}
- (instancetype)init
{
    if (self = [super init]) {
        
        self.userInteractionEnabled = YES;
        self.largeNarrowLevel		= 1;
        
        [self initControl];
        [self layout];
    }
    return self;
}

- (void)initControl
{
    if (!_leftArrow) {
        _leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftArrow.sakura.image(ThemeKP(@"Left"), UIControlStateNormal);
        [_leftArrow addTarget:self action:@selector(prePage) forControlEvents:UIControlEventTouchUpInside];
        _leftArrow.enabled = NO;

        [self addSubview:_leftArrow];
    }
    
    if (!_page) {
        _page = [UIButton buttonWithType:UIButtonTypeCustom];
        _page.titleLabel.lineBreakMode = NSLineBreakByClipping;
        [_page addTarget:self action:@selector(choosePage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_page];
    }
    
    if (!_rightArrow) {
        _rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightArrow.sakura.image(ThemeKP(@"Right"), UIControlStateNormal);
        [_rightArrow addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightArrow];
    }
    
    if (!_enlarge) {
            
            _enlarge = [UIButton buttonWithType:UIButtonTypeCustom];
            _enlarge.sakura.image(ThemeKP(@"EnlargeEnable"), UIControlStateNormal);
            _enlarge.sakura.image(ThemeKP(@"EnlargeDisable"), UIControlStateDisabled);
            [_enlarge addTarget:self action:@selector(enlarge) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_enlarge];
    }
        
    if (!_narrow) {
        _narrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _narrow.sakura.image(ThemeKP(@"NarrowEnable"), UIControlStateNormal);
        _narrow.sakura.image(ThemeKP(@"NarrowDisable"), UIControlStateDisabled);
        [_narrow addTarget:self action:@selector(narrow) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_narrow];
    }
    
    if (!_fullScreen) {
        _fullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreen.sakura.image(ThemeKP(@"FullScreen"), UIControlStateNormal);
        _fullScreen.sakura.image(ThemeKP(@"FullScreenExit"), UIControlStateSelected);
        [_fullScreen addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_fullScreen];
    }
    
    
}

- (void)layout
{
    /*
     两个配置项：
     1.允许学生翻页 2.禁止学生翻页，两者不可能同时勾选
     当1为YES， 学生可以本地翻页，授权后可以同步翻页（每次翻页会发送信令，其他学生能同步）
     当2为YES， 学生不可以本地翻页，授权后不可以同步翻页（每次翻页会发送信令，其他学生能同步）
     当1和2为都为No， 学生不可以本地翻页，授权后可以同步翻页（每次翻页会发送信令，其他学生能同步）
     */
    
    //当配置项2 为YES 那么翻页按钮不应该显示
    if ([TKEduClassRoom shareInstance].roomJson.configuration.isHiddenPageFlip
        && [TKRoomManager instance].localUser.role == TKUserType_Student) {
        _leftArrow.hidden = YES;
        _rightArrow.hidden = YES;
    }else{
        _leftArrow.hidden = NO;
        _rightArrow.hidden = NO;
    }
    CGFloat btnWidth = 34 * ProportionToPageControl;
    CGFloat btnHeight= 34 * ProportionToPageControl;
    
    [_leftArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(btnWidth, btnHeight)]);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        if (!_leftArrow.hidden) {
            make.left.equalTo(self).offset(38 * ProportionToPageControl);
        }
    }];
    
    [_rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(btnWidth, btnHeight)]);
        make.left.equalTo(_page.mas_right).offset(20 * ProportionToPageControl);
        make.centerY.equalTo(self.mas_centerY);
    }];
    

    [_page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(60 * ProportionToPageControl, 15 * ProportionToPageControl)]);
        if (_leftArrow.hidden) {
            make.left.equalTo(self.mas_left).offset(20 * ProportionToPageControl);
        }else{
            make.left.equalTo(_leftArrow.mas_right).offset(20 * ProportionToPageControl);
        }
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    

    [_enlarge mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_showZoomBtn) {
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(btnWidth, btnHeight)]);
        }
        else {
            make.size.mas_equalTo(0);
        }
        if (_rightArrow.hidden) {
            make.left.equalTo(_page.mas_right).offset(35 * ProportionToPageControl);
        }else{
            make.left.equalTo(_rightArrow.mas_right).offset(35 * ProportionToPageControl);
        }
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    [_narrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_showZoomBtn) {
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(btnWidth, btnHeight)]);
        }
        else {
            make.size.mas_equalTo(0);
        }
        make.left.equalTo(_enlarge.mas_right).offset(35 * ProportionToPageControl);
        make.centerY.equalTo(self.mas_centerY);
    }];

    
    [_fullScreen mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(btnWidth, btnHeight)]);
        if (_showZoomBtn) {
            make.left.equalTo(_narrow.mas_right).offset(35 * ProportionToPageControl);
        }
        else {
            if (_rightArrow.hidden) {
                make.left.equalTo(_page.mas_right).offset(35 * ProportionToPageControl);
            }else{
                make.left.equalTo(_rightArrow.mas_right).offset(35 * ProportionToPageControl);
            }
        }
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-38 * ProportionToPageControl).priorityLow();
    }];
    
    
    if (self.largeNarrowLevel == LargeNarrowLevelMax) {
        _enlarge.enabled = NO;
    } else if (self.largeNarrowLevel == LargeNarrwoLevelMin) {
        _narrow.enabled  = NO;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)setShowMark:(BOOL)showMark
{
    _showMark = showMark;
    
    if (showMark) {
        // 课件备注
        if (!_mark) {
            _mark = [UIButton buttonWithType:UIButtonTypeCustom];
            _mark.selected = YES;
            _mark.sakura.image(ThemeKP(@"RemarkDefault"), UIControlStateNormal);
            _mark.sakura.image(ThemeKP(@"RemarkSelected"), UIControlStateSelected);
            [_mark addTarget:self action:@selector(shwoMark:) forControlEvents:UIControlEventTouchUpInside];
 
            _remarkView = [TKNativeWBRemarkView showRemarkViewAddedTo:_contentView pointingAtView:self];
            _remarkView.hidden = YES;
            
        }
    }

}
- (void)setWhiteBoardControl:(id<TKNativeWBPageControlDelegate>)whiteBoardControl {
 
    _whiteBoardControl	= whiteBoardControl;
    
    _contentView		= ((TKManyViewController *)whiteBoardControl).whiteboardBackView;
}

- (void)setRemarkDict:(NSDictionary *)remarkDict
{
    _remarkDict = remarkDict;
    
    //刷新备注
    [self reloadMark];
}

- (void)setShowZoomBtn:(BOOL)showZoomBtn
{
    if (_showZoomBtn != showZoomBtn) {
        
        _showZoomBtn = showZoomBtn;
        // 刷新
        [self layout];
    }
}


- (void)reloadMark
{
    //获取当前备注
    NSString *key = [NSString stringWithFormat:@"%zd",_currentPage-1];
    NSDictionary *dict = [self.remarkDict valueForKey:key];

    if (dict) {
        _mark.selected = YES;
        _remarkView.hidden = NO;
        _remarkView.remarkContent = [dict valueForKey:@"remark"];

        [self addSubview:_mark];
        [_mark mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_fullScreen);
            make.left.equalTo(_fullScreen.mas_right).offset(35 * ProportionToPageControl);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-38 * ProportionToPageControl).priorityHigh();
        }];
        
    }else{
        _mark.selected = NO;;
        _remarkView.hidden = YES;
        [_mark  removeFromSuperview];
    }
}

- (void)setDisenablePaging:(BOOL)disenablePaging {
    
    _disenablePaging		= disenablePaging;
    
    _leftArrow.enabled   	=
    _rightArrow.enabled  	=
    _page.enabled        	= !_disenablePaging;
    
    if (!_disenablePaging) {
        if (_currentPage == _totalPage) {
            _rightArrow.enabled = NO;
        } else {
            _rightArrow.enabled = YES;
        }
    } else {
        _rightArrow.enabled = NO;
        _pageView.hidden = YES;
    }
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.sakura.backgroundColor(ThemeKP(@"BackgroundColor"));
    self.sakura.alpha(ThemeKP(@"BackgroundColorAlpha"));
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:self.alpha];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 2;
}

#pragma mark - 翻页控制
- (void)prePage
{
    if (self.whiteBoardControl && [self.whiteBoardControl respondsToSelector:@selector(prePage)]) {
        [self.whiteBoardControl prePage];
    }
    
    _pageView.hidden = YES;
    
    //刷新备注
    [self reloadMark];
}

- (void)nextPage
{
    if (self.whiteBoardControl && [self.whiteBoardControl respondsToSelector:@selector(nextPage)]) {
        [self.whiteBoardControl nextPage];
    }
    _pageView.hidden = YES;
    
    //刷新备注
    [self reloadMark];
}

- (void)choosePage
{
    _pageView.hidden = !_pageView.hidden;
    
    //刷新备注
    [self reloadMark];
}

- (void)setTotalPage:(NSInteger)total
         currentPage:(NSInteger)currentPage
{
    if (!_pageView) {
        _pageView = [[TKNativePageTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _pageView.delegate = self;
        _pageView.dataSource = self;
        _pageView.hidden = YES;
    }
    [self.superview addSubview:_pageView];
    
    _totalPage = total;
    if (_totalPage < 1) {
        _totalPage = 1;
    }
    _currentPage = currentPage;
    if (_currentPage < 1) {
        _currentPage = 1;
    }
    
    [_pageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_page.mas_centerX);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(85 * Proportion, 45 * Proportion * (_totalPage > 5 ? 5 : _totalPage))]);
        make.bottom.equalTo(self.mas_top).offset(-16 * Proportion);
    }];
    
    [_page setAttributedTitle:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"%ld/%ld",(long)_currentPage, (long)_totalPage] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20 * Proportion], NSForegroundColorAttributeName : UIColor.whiteColor}] forState:UIControlStateNormal];
    
    [_pageView reloadData];
    [self setup];
}

- (void)setup
{
    if (_currentPage == 1) {
        _leftArrow.enabled = NO;
    }else{
        _leftArrow.enabled = YES;
    }
    
    if (_currentPage == _totalPage){
        
        _rightArrow.enabled = NO;
        
        if ([TKEduSessionHandle shareInstance].whiteBoardManager.nativeWhiteBoardView.fileid.intValue == 0
            && [TKEduSessionHandle shareInstance].isClassBegin
            && [TKRoomManager instance].localUser.role == TKUserType_Teacher) {
            
            _rightArrow.enabled = YES;
        }
        if ([TKRoomManager instance].localUser.role == TKUserType_Student) {
            _rightArrow.enabled = NO;
        }
    }else{
        _rightArrow.enabled = YES;
    }
}

- (void)enlarge
{
    if (self.whiteBoardControl && [self.whiteBoardControl respondsToSelector:@selector(enlarge)]) {
        
        if (self.largeNarrowLevel >= LargeNarrowLevelMax) {
            
            _enlarge.enabled = NO;
        } else {
            
            self.largeNarrowLevel += 0.5f;
            _narrow.enabled = YES;
            [self.whiteBoardControl enlarge];
            
            if (self.largeNarrowLevel == LargeNarrowLevelMax) {
                
                _enlarge.enabled = NO;
            }
        }
    }
}

- (void)narrow
{
    if (self.whiteBoardControl && [self.whiteBoardControl respondsToSelector:@selector(narrow)]) {
        
        if (self.largeNarrowLevel <= LargeNarrwoLevelMin) {
            
            _narrow.enabled = NO;
        } else {
         
            self.largeNarrowLevel -= 0.5f;
            _enlarge.enabled = YES;
            [self.whiteBoardControl narrow];
            
            if (self.largeNarrowLevel == LargeNarrwoLevelMin) {
                _narrow.enabled = NO;
            }
        }
    }
}

- (void)resetBtnStates
{
    _enlarge.enabled = YES;
    _narrow.enabled = NO;
    self.largeNarrowLevel = 1;
}

- (void)fullScreen:(UIButton *)btn
{
    if (self.whiteBoardControl && [self.whiteBoardControl respondsToSelector:@selector(fullScreen:)]) {
       
        [self.whiteBoardControl fullScreen:btn.selected];
    }
}

- (void)shwoMark:(UIButton *)btn
{
    if (btn.selected) {
        _remarkView.hidden = YES;
    }else{
        _remarkView.hidden = NO;
    }
    
    btn.selected = !btn.selected;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _totalPage;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45 * Proportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    TKNativePageCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[TKNativePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    [cell setNumber:indexPath.row + 1 Color:UIColor.whiteColor];
    if ((indexPath.row + 1) == _currentPage) {
        [cell setNumber:indexPath.row + 1 Color:UIColor.yellowColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _pageView.hidden = YES;
    if (self.whiteBoardControl && [self.whiteBoardControl respondsToSelector:@selector(turnToPage:)]) {
        [self.whiteBoardControl performSelector:@selector(turnToPage:) withObject:@(indexPath.row + 1)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation TKNativePageTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.sakura.backgroundColor(ThemeKP(@"BackgroundColor"));
        self.sakura.alpha(ThemeKP(@"BackgroundColorAlpha"));
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:self.alpha];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.delaysContentTouches = NO;
    }
    
    return self;
}

@end

@implementation TKNativePageCell
{
    UILabel *_numberLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont systemFontOfSize:20 * Proportion];
        [self.contentView addSubview:_numberLabel];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

- (void)setNumber:(NSInteger)number Color:(UIColor *)color
{
    _numberLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
    _numberLabel.textColor = color;
}

@end
