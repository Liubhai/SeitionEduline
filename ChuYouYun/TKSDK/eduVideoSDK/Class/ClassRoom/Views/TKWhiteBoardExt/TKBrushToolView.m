//
//  TKNativeWBToolView.m
//  WhiteBoardTools
//
//  Created by 周洁 on 2018/12/25.
//  Copyright © 2018 周洁. All rights reserved.
//
//#define MAS_SHORTHAND
//#define MAS_SHORTHAND_GLOBALS
#import "TKBrushToolView.h"
#import "TKEduSessionHandle.h"
#import "TKBrushSelectorView.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"

#define ThemeKP(args) [@"TKNativeWB.BrushTools." stringByAppendingString:args]

@interface TKBrushToolView()<TKBrushSelectorViewDelegate>

@property (nonatomic, strong)NSArray<UIButton *> *btnArr;
@property (nonatomic, strong)TKBrushSelectorView *selectorView;
@end


@implementation TKBrushToolView
{
    UIButton *_toolsBtn;
    UIButton *_mouseBtn;
    UIButton *_penBtn;
    UIButton *_textBtn;
    UIButton *_shapeBtn;
    UIButton *_eraserBtn;
    UIButton *_closeBtn;
    BOOL _close;
    
    int _fromMouseToTool;  //1:鼠标到工具   2:工具到鼠标
    
    TKRoomConfiguration *_config;
    
}

- (instancetype)init
{
    if (self = [super init]) {
        _close = NO;
        _fromMouseToTool = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteSelectorTool:) name:TKWhiteBoardRemoteSelectTool object:nil];
        
        [self layout];
        
        //根据配置项选择是否要隐藏鼠标箭头或者形状按钮
        [self setConfig:[TKEduClassRoom shareInstance].roomJson.configuration];
        
    }
    
    return self;
}

- (void)layout
{
    self.backgroundColor = [[TKTheme colorWithPath:ThemeKP(@"bg_color")] colorWithAlphaComponent:[TKTheme floatWithPath:ThemeKP(@"bg_alpha")]];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    _toolsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _toolsBtn.tag = 301;
    [_toolsBtn addTarget:self action:@selector(switchToolsView) forControlEvents:UIControlEventTouchUpInside];
    _toolsBtn.sakura.image(ThemeKP(@"tk_Tools"), UIControlStateNormal);
    _toolsBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_toolsBtn];
    [_toolsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10 * Proportion);
        make.left.equalTo(self).offset(6 * Proportion);
        make.right.equalTo(self).offset(-6 * Proportion);
        make.height.equalTo(@(25 * Proportion));
        make.width.equalTo(@(50 * Proportion));
    }];
    
    UIView *dimView = [[UIView alloc] init];
    dimView.sakura.backgroundColor(ThemeKP(@"bg_top_color"));
    dimView.sakura.alpha(ThemeKP(@"bg_top_alpha"));
    [self addSubview:dimView];
    [dimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(_toolsBtn.mas_bottom).offset(10 * Proportion);
    }];
    
    [self bringSubviewToFront:_toolsBtn];
    
    _mouseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mouseBtn.tag = 302;
    [_mouseBtn addTarget:self action:@selector(toolsSelect:) forControlEvents:UIControlEventTouchUpInside];
    _mouseBtn.sakura.image(ThemeKP(@"tk_mouse_out_default"), UIControlStateNormal);
	_mouseBtn.sakura.image(ThemeKP(@"tk_mouse_out_selected"), UIControlStateSelected);
    _mouseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:_mouseBtn];
    [_mouseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_toolsBtn.mas_bottom).offset(30 * Proportion);
        make.left.equalTo(self).offset(6 * Proportion);
        make.right.equalTo(self).offset(-6 * Proportion);
        make.height.equalTo(@(25 * Proportion));
    }];
    
    _penBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _penBtn.tag = 303;
    [_penBtn addTarget:self action:@selector(toolsSelect:) forControlEvents:UIControlEventTouchUpInside];
    _penBtn.sakura.image(ThemeKP(@"tk_pen_out_default"), UIControlStateNormal);
    _penBtn.sakura.image(ThemeKP(@"tk_pen_out_selected"), UIControlStateSelected);
    _penBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:_penBtn];
    [_penBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mouseBtn.mas_bottom).offset(30 * Proportion);
        make.left.equalTo(self).offset(6 * Proportion);
        make.right.equalTo(self).offset(-6 * Proportion);
        make.height.equalTo(@(25 * Proportion));
    }];
    
    _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _textBtn.tag = 304;
    [_textBtn addTarget:self action:@selector(toolsSelect:) forControlEvents:UIControlEventTouchUpInside];
    _textBtn.sakura.image(ThemeKP(@"tk_text_out_default"), UIControlStateNormal);
    _textBtn.sakura.image(ThemeKP(@"tk_text_out_selected"), UIControlStateSelected);
    _textBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:_textBtn];
    [_textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_penBtn.mas_bottom).offset(30 * Proportion);
        make.left.equalTo(self).offset(6 * Proportion);
        make.right.equalTo(self).offset(-6 * Proportion);
        make.height.equalTo(@(25 * Proportion));
    }];
    
    _shapeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shapeBtn.tag = 305;
    [_shapeBtn addTarget:self action:@selector(toolsSelect:) forControlEvents:UIControlEventTouchUpInside];
    _shapeBtn.sakura.image(ThemeKP(@"tk_kongxinjuxing_out_default"), UIControlStateNormal);
    _shapeBtn.sakura.image(ThemeKP(@"tk_kongxinjuxing_out_selected"), UIControlStateSelected);
    _shapeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:_shapeBtn];
    [_shapeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textBtn.mas_bottom).offset(30 * Proportion);
        make.left.equalTo(self).offset(6 * Proportion);
        make.right.equalTo(self).offset(-6 * Proportion);
        make.height.equalTo(@(25 * Proportion));
    }];
    
    _eraserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _eraserBtn.tag = 306;
    [_eraserBtn addTarget:self action:@selector(toolsSelect:) forControlEvents:UIControlEventTouchUpInside];
    _eraserBtn.sakura.image(ThemeKP(@"tk_xiangpi_out_default"), UIControlStateNormal);
    _eraserBtn.sakura.image(ThemeKP(@"tk_xiangpi_out_selected"), UIControlStateSelected);
    _eraserBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:_eraserBtn];
    [_eraserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shapeBtn.mas_bottom).offset(30 * Proportion);
        make.left.equalTo(self).offset(6 * Proportion);
        make.right.equalTo(self).offset(-6 * Proportion);
        make.height.equalTo(@(25 * Proportion));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColor.whiteColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_eraserBtn.mas_bottom).offset(20 * Proportion);
        make.height.equalTo(@(1));
        make.left.equalTo(self).offset(6 * Proportion);
        make.right.equalTo(self).offset(-6 * Proportion);
    }];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.tag = 307;
    [_closeBtn addTarget:self action:@selector(switchToolsView) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.sakura.image(ThemeKP(@"tk_shouqi"), UIControlStateNormal);
    _closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_eraserBtn.mas_bottom).offset(30 * Proportion);
        make.left.equalTo(self).offset(6 * Proportion);
        make.right.equalTo(self).offset(-6 * Proportion);
        make.height.equalTo(@(25 * Proportion));
        make.bottom.equalTo(self).offset(-10 * Proportion);
    }];
    
    _mouseBtn.selected = YES;
    MASAttachKeys(_toolsBtn,_mouseBtn,_penBtn,_textBtn,_shapeBtn,_eraserBtn,line,_closeBtn);
    
    _btnArr = @[_mouseBtn, _penBtn, _textBtn, _shapeBtn, _eraserBtn];

}

- (void)switchToolsView {
    // 处于展开状态
    if (_close == NO) {
        if (_curBtn) {

            _curBtn.selected = YES;
        }
    }
    else {
        if (self.selectorView.superview) {
            [self.selectorView removeFromSuperview];
        }
    }
    [self setNeedsUpdateConstraints];
    _close = !_close;
}

- (void)chooseFromRemote:(UIButton *)button
{
    [_btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.selected = [obj isEqual:button] ?: NO;
    }];
    
    if (button.tag == 301 || button.tag == 307) {
        
        [self switchToolsView];
    }
}
#pragma mark - 画笔选择
- (void)toolsSelect:(UIButton *)button
{
    __block BOOL flag = NO;
    if ([_btnArr indexOfObject:button] == 0) {
        [_btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.selected) {
                if (idx > 0) {
                    flag = YES;
                    *stop = YES;
                }
            }
        }];
        if (flag) {
            _fromMouseToTool = 1;
        } else {
            _fromMouseToTool = 0;
        }
    }
    else {
        flag = NO;
        [_btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.selected) {
                if (idx == 0) {
                    flag = YES;
                    *stop = YES;
                }
            }
        }];
        if (flag) {
            _fromMouseToTool = 2;
        } else {
            _fromMouseToTool = 0;
        }
    }
    // 同步画笔选择
    if ([TKRoomManager instance].localUser.role == TKUserType_Teacher && [TKEduSessionHandle shareInstance].isClassBegin) {
        
        NSString *msgName    = @"whiteboardMarkTool";
        //1:鼠标到工具   2:工具到鼠标
        if (_fromMouseToTool == 1) {
            
            [[TKRoomManager instance] pubMsg:msgName msgID:msgName toID:sTellAll data:@"{\"sourceInstanceId\":\"default\",\"selectMouse\":true}" save:YES completion:nil];
            
        } else if (_fromMouseToTool == 2) {
            
            [[TKRoomManager instance] pubMsg:msgName msgID:msgName toID:sTellAll data:@"{\"sourceInstanceId\":\"default\",\"selectMouse\":false}" save:YES completion:nil];
        }
    }

    [self chooseFromRemote:button];
    
    
    
    //鼠标
    if (button.tag == 302) {
        [[TKEduSessionHandle shareInstance] wbSessionManagerBrushToolDidSelect:TKBrushToolTypeMouse];
        if (self.selectorView.superview) {
            [self.selectorView removeFromSuperview];
        }
    }
    // 不是展开或收起
    else if(button.tag != 301 || button.tag == 307) {
        
//        self.selectorView.hidden = NO;
        
        //画笔
        if (button.tag == 303) {
            [[TKEduSessionHandle shareInstance] wbSessionManagerBrushToolDidSelect:TKBrushToolTypeLine];
            [self.selectorView showType:TKSelectorShowTypeHigh];
            [self.selectorView showWithTKNativeWBToolView:self type:TKBrushToolTypeLine];

        }
        //文字
        else if (button.tag == 304) {
            [[TKEduSessionHandle shareInstance] wbSessionManagerBrushToolDidSelect:TKBrushToolTypeText];
            //根据配置项选择文字调色盘类型
            if ([TKRoomManager instance].localUser.role == TKUserType_Student) {
                if ([TKEduClassRoom shareInstance].roomJson.configuration.shouldHideFontOnDrawSelectorView) {
                    [self.selectorView showType:TKSelectorShowTypeSpecial];
                } else {
                    [self.selectorView showType:TKSelectorShowTypeMiddle];
                }
            } else {
                [self.selectorView showType:TKSelectorShowTypeMiddle];
            }
            [self.selectorView showWithTKNativeWBToolView:self type:TKBrushToolTypeText];

        }
        //形状
        else if (button.tag == 305) {
            [[TKEduSessionHandle shareInstance] wbSessionManagerBrushToolDidSelect:TKBrushToolTypeShape];
            [self.selectorView showType:TKSelectorShowTypeHigh];
            [self.selectorView showWithTKNativeWBToolView:self type:TKBrushToolTypeShape];

        }
        //橡皮擦
        else if (button.tag == 306) {
            [[TKEduSessionHandle shareInstance] wbSessionManagerBrushToolDidSelect:TKBrushToolTypeEraser];
            [self.selectorView showType:TKSelectorShowTypeLow];
            [self.selectorView showWithTKNativeWBToolView:self type:TKBrushToolTypeEraser];

        }

    }
	
}

- (void)updateConstraints
{
    if (_close) {
        _closeBtn.sakura.image(ThemeKP(@"tk_down"), UIControlStateNormal);
        [_closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(6 * Proportion);
            make.right.equalTo(self).offset(-6 * Proportion);
            make.top.equalTo(_toolsBtn.mas_bottom).offset(10 * Proportion);
            make.bottom.equalTo(self);
        }];
    } else {
        _closeBtn.sakura.image(ThemeKP(@"tk_shouqi"), UIControlStateNormal);
        [_closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_eraserBtn.mas_bottom).offset(30 * Proportion);
            make.left.equalTo(self).offset(6 * Proportion);
            make.right.equalTo(self).offset(-6 * Proportion);
            make.height.equalTo(@(25 * Proportion));
            make.bottom.equalTo(self).offset(-10 * Proportion);
        }];
    }
    
    if ([TKRoomManager instance].localUser.role == TKUserType_Student) {
        if (_config.shouldHideMouseOnDrawToolView) {
            _penBtn.hidden = _close;
        } else {
            _mouseBtn.hidden = _close;
        }
    } else {
        _mouseBtn.hidden = _close;
    }
    
    [super updateConstraints];
}

- (void)setConfig:(TKRoomConfiguration *)config
{
    if ([TKRoomManager instance].localUser.role == TKUserType_Student) {
        _config = config;
        if (config.shouldHideMouseOnDrawToolView) {
            _mouseBtn.hidden = YES;
            [_penBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_toolsBtn.mas_bottom).offset(30 * Proportion);
                make.left.equalTo(self).offset(6 * Proportion);
                make.right.equalTo(self).offset(-6 * Proportion);
                make.height.equalTo(@(25 * Proportion));
            }];
        }
        
        if (config.shouldHideShapeOnDrawToolView) {
            _shapeBtn.hidden = YES;
            [_eraserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_textBtn.mas_bottom).offset(30 * Proportion);
                make.left.equalTo(self).offset(6 * Proportion);
                make.right.equalTo(self).offset(-6 * Proportion);
                make.height.equalTo(@(25 * Proportion));
            }];
        }
    }
}

#pragma mark - 类型 && 颜色 &&大小
- (void)brushSelectorViewDidSelectDrawType:(TKSelectorType)type color:(NSString *)hexColor widthProgress:(float)progress
{
    switch (type) {
        case TKSelectorTypePen:
        {
            [[TKEduSessionHandle shareInstance] wbSessionManagerDidSelectDrawType:Draw_Pen color:hexColor widthProgress:progress];
            _penBtn.sakura.image(ThemeKP(@"tk_pen_out_selected"), UIControlStateSelected);
            _penBtn.sakura.image(ThemeKP(@"tk_pen_out_selected"), UIControlStateSelected  | UIControlStateHighlighted);
            
            break;
        }
        case TKSelectorTypeMarkPen:
        {
            [[TKEduSessionHandle shareInstance] wbSessionManagerDidSelectDrawType:Draw_MarkPen color:hexColor widthProgress:progress];
            _penBtn.sakura.image(ThemeKP(@"tk_yingguangbi_out_selected"), UIControlStateSelected);
            _penBtn.sakura.image(ThemeKP(@"tk_yingguangbi_out_selected"), UIControlStateSelected  | UIControlStateHighlighted);
            
            break;
        }
        case TKSelectorTypeLine:
        {
            [[TKEduSessionHandle shareInstance] wbSessionManagerDidSelectDrawType:Draw_Line color:hexColor widthProgress:progress];

            _penBtn.sakura.image(ThemeKP(@"tk_line_out_selected"), UIControlStateSelected);
            _penBtn.sakura.image(ThemeKP(@"tk_line_out_selected"), UIControlStateSelected  | UIControlStateHighlighted);
            
            break;
        }
        case TKSelectorTypeArrowLine:
        {
            [[TKEduSessionHandle shareInstance] wbSessionManagerDidSelectDrawType:Draw_Arrow color:hexColor widthProgress:progress];

            _penBtn.sakura.image(ThemeKP(@"tk_jiantou_out_selected"), UIControlStateSelected);
            _penBtn.sakura.image(ThemeKP(@"tk_jiantou_out_selected"), UIControlStateSelected  | UIControlStateHighlighted);
            
            break;
        }
        case TKSelectorTypeTextMS:
        {
            if (progress <= 0.08f) {
                progress = 0.08f;
            }
            [[TKEduSessionHandle shareInstance] wbSessionManagerDidSelectDrawType:Draw_Text_Size color:hexColor widthProgress:progress];

            break;
        }
        case TKSelectorTypeEmptyRectangle:
        {
             [[TKEduSessionHandle shareInstance] wbSessionManagerDidSelectDrawType:Draw_EmptyRect color:hexColor widthProgress:progress];
            _shapeBtn.sakura.image(ThemeKP(@"tk_kongxinjuxing_out_selected"), UIControlStateSelected);
            _shapeBtn.sakura.image(ThemeKP(@"tk_kongxinjuxing_out_selected"), UIControlStateSelected  | UIControlStateHighlighted);
            
            break;
        }
        case TKSelectorTypeFilledRectangle:
        {
             [[TKEduSessionHandle shareInstance] wbSessionManagerDidSelectDrawType:Draw_SolidRect color:hexColor widthProgress:progress];
            _shapeBtn.sakura.image(ThemeKP(@"tk_shixinjuxing_out_selected"), UIControlStateSelected);
            _shapeBtn.sakura.image(ThemeKP(@"tk_shixinjuxing_out_selected"), UIControlStateSelected  | UIControlStateHighlighted);
            
            break;
        }
        case TKSelectorTypeEmptyEllipse:
        {
            [[TKEduSessionHandle shareInstance] wbSessionManagerDidSelectDrawType:Draw_EmptyCircle color:hexColor widthProgress:progress];

            _shapeBtn.sakura.image(ThemeKP(@"tk_kongxinyuan_out_selected"), UIControlStateSelected);
            _shapeBtn.sakura.image(ThemeKP(@"tk_kongxinyuan_out_selected"), UIControlStateSelected  | UIControlStateHighlighted);
            
            break;
        }
        case TKSelectorTypeFilledEllipse:
        {
            [[TKEduSessionHandle shareInstance] wbSessionManagerDidSelectDrawType:Draw_SolidCircle color:hexColor widthProgress:progress];
            _shapeBtn.sakura.image(ThemeKP(@"tk_shixinyuan_out_selected"), UIControlStateSelected);
            _shapeBtn.sakura.image(ThemeKP(@"tk_shixinyuan_out_selected"), UIControlStateSelected  | UIControlStateHighlighted);
            break;
        }
        case TKSelectorTypeEraser:
        {
            [[TKEduSessionHandle shareInstance] wbSessionManagerDidSelectDrawType:Draw_Eraser color:hexColor widthProgress:progress];

            break;
        }
        default:
            break;
    }
}
- (void)hideSelectorView
{
    [_selectorView showWithTKNativeWBToolView:self type:TKBrushToolTypeMouse];

}

- (void)remoteSelectorTool:(NSNotification *)noti
{
    if (self.hidden) {
        return;
    }
    
    // 是否点选鼠标
    if ([noti.object boolValue]) {
        
        [self toolsSelect:_mouseBtn];
        [self chooseFromRemote:_mouseBtn];
    }
    else
    {
        [self toolsSelect:_penBtn];
        [self brushSelectorViewDidSelectDrawType:TKSelectorTypePen color:_selectorView.currentColor ? : @"#5AC9FA" widthProgress:_selectorView.progress1];
        [_selectorView removeFromSuperview];
    }
}
// 颜色选择器
- (TKBrushSelectorView *)selectorView {
    
    if (_selectorView == nil) {
        // 一对一 默认画笔黑色
        NSString *color = nil;
        if ([TKEduClassRoom shareInstance].roomJson.roomtype == 0) {
            color = @"#160C30";
        }
        _selectorView = [[TKBrushSelectorView alloc] initWithDefaultColor:color];
        _selectorView.delegate = self;
        
        
        [self.superview addSubview:_selectorView];
    }
    return _selectorView;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    if (hidden) {
        [self hideSelectorView];
        
    }else{
        
        BOOL state = [TKEduSessionHandle shareInstance].whiteBoardManager.nativeWhiteBoardView.selectMouse;
        if (state) {
            
            [self toolsSelect:_mouseBtn];
            [self chooseFromRemote:_mouseBtn];
            
        }else{

            [self toolsSelect:_penBtn];
            [self brushSelectorViewDidSelectDrawType:TKSelectorTypePen color:_selectorView.currentColor ? : @"#5AC9FA" widthProgress:_selectorView.progress1];
            [_selectorView removeFromSuperview];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    static BOOL isSecond = NO;
    
    if (isSecond) {
        isSecond = NO;
        return _selectorView;
    }
    if ([self pointInside:point withEvent:event] == NO && [_selectorView pointInside:point withEvent:event] == NO)
    {
        if (_selectorView.superview)
        {
            [_selectorView hide];
            isSecond	= YES;
            return _selectorView;
            
        }
    }
    isSecond = NO;
    return [super hitTest:point withEvent:event];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%@ --dealloc--",self.class);
}

#pragma clang diagnostic pop
@end
