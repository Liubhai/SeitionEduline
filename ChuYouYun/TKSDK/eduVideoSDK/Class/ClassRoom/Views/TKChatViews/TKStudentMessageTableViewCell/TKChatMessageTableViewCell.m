//
//  TKStudentMessageTableViewCell.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKChatMessageTableViewCell.h"
#import "NSAttributedString+TKEmoji.h"
#import "TKLinkLabel.h"

#define ThemeKP(args) [@"ClassRoom.TKChatViews." stringByAppendingString:args]
@interface TKChatMessageTableViewCell()
{
    
    
}


@end

@implementation TKChatMessageTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.userInteractionEnabled = YES;
        self.sakura.backgroundColor(ThemeKP(@"listBackColor"));
        self.urlArray = [NSMutableArray array];
        
        [self setupView];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
//14 12
- (void)setupView {
    
//    CGFloat tViewCap        =   10 * Proportion;
    CGFloat tContentWidth   =   CGRectGetWidth(self.contentView.frame);
//    CGFloat tContentHigh    =   CGRectGetHeight(self.contentView.frame);
    CGFloat tTimeLabelWidth =   35;     // 原来为50*Proportion
    CGFloat tTimeLabelHeigh =   25;
    
    CGFloat marginSize      =   16 * Proportion;
    CGFloat tTranslateLabelHeigh = 22 ;
    //昵称
    {
        
        _iNickNameLabel = ({
            
            UILabel *tLabel = [[UILabel alloc] init];
            // 昵称
            tLabel.frame = CGRectMake(20 * Proportion,
                                      16 * Proportion,
                                      90,
                                      tTranslateLabelHeigh);
            
            tLabel.textAlignment = NSTextAlignmentLeft ;
//            tLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            
            tLabel.sakura.textColor(ThemeKP(@"chatNameColor"));
            //            _iNickNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(14);
            tLabel;
            
        });
        [self.contentView addSubview:_iNickNameLabel];
        
    }
    //内容
    {
        
        // 文字
        _iMessageLabel = ({
            TKLinkLabel *tLabel = [[TKLinkLabel alloc] initWithFrame:CGRectMake(_iNickNameLabel.rightX,
                                                                                _iNickNameLabel.y,
                                                                                tContentWidth - _iNickNameLabel.rightX -tTranslateLabelHeigh - marginSize*2,
                                                                                _iNickNameLabel.height)];
            
            
            tLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            tLabel.sakura.textColor(ThemeKP(@"chatMessageColor"));
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(14);
            tLabel.numberOfLines = 0;
            
            tLabel.linkTapHandler = ^(TKLinkType linkType, NSString *string, NSRange range) {
                if (linkType == TKLinkTypeURL) {//打开连接
                    if(![TKHelperUtil isURL:string]){
                        string = [NSString stringWithFormat:@"http://%@",string];
                    }
                    NSURL *url = [NSURL URLWithString:string];
                    
                    [[UIApplication sharedApplication] openURL:url];
                }
            };
            tLabel.linkLongPressHandler = ^(TKLinkType linkType, NSString *string, NSRange range) {
                
                if (linkType == TKLinkTypeURL) {//复制链接
                    self.cString = string;
                    [self becomeFirstResponder];
                    UIMenuItem * item = [[UIMenuItem alloc]initWithTitle:MTLocalized(@"Menu.Copy") action:@selector(newFunc)];
                    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
                    [UIMenuController sharedMenuController].menuItems = @[item];
                    [UIMenuController sharedMenuController].menuVisible = YES;
                    
                    
                }
            };
            tLabel;
            
        });
        [self.contentView addSubview:_iMessageLabel];
        
    }
    
    //翻译按钮
    {
        _iTranslationButton = ({
            UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tLeftButton.frame = CGRectMake(_iMessageLabel.rightX + marginSize,
                                           _iNickNameLabel.y,
                                           tTranslateLabelHeigh,
                                           tTranslateLabelHeigh);
            
            tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            
            tLeftButton.enabled = NO;
            tLeftButton;
            
        });
        [self.contentView addSubview:_iTranslationButton];
    }
    
    //时间
    {
        _iTimeLabel = ({
            CGRect tFrame = CGRectMake(0,
                                       CGRectGetMaxY(_iMessageLabel.frame),
                                       tTimeLabelWidth,
                                       tTimeLabelHeigh);
            UILabel *tLabel = [[UILabel alloc] initWithFrame:tFrame];
            
            tLabel.sakura.textColor(ThemeKP(@"chatTimeColor"));
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(10);
            tLabel.textAlignment = NSTextAlignmentCenter;
            tLabel;
            
        });
        //聊天时间不显示
//        [self.contentView addSubview:_iTimeLabel];
    }
    //翻译
    {
        // 分割线
        _translationBorderView = ({
            UIView *view = [[UIView alloc] init];
            view.sakura.backgroundColor(ThemeKP(@"chatLineColor"));
            view.sakura.alpha(ThemeKP(@"chatLinealpha"));
            view;
        });
        _iMessageTranslationLabel = ({
            
            UILabel *tLabel = [[UILabel alloc] init];
            tLabel.frame = CGRectMake(_iMessageLabel.x,0,0,0);
            tLabel.sakura.textColor(ThemeKP(@"chatTransColor"));
            tLabel.font            = TKFont(14);
            tLabel.numberOfLines = 0;
            tLabel;
            
        });
        [self.contentView addSubview:_translationBorderView];
        [self.contentView addSubview:_iMessageTranslationLabel];
        
    }
    
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.backgroundColor             = [UIColor clearColor];
    
    
}


- (void)layoutSubviews {
    
    CGFloat tViewCap        =   10 * Proportion;
    CGFloat tContentWidth   =   CGRectGetWidth(self.contentView.frame);
    //    CGFloat marginSize      =   16 * Proportion;
    CGFloat tTranslateButtonWidth = 22 * Proportion;
    // 消息
    _iMessageLabel.width = tContentWidth - _iNickNameLabel.rightX - _iTimeLabel.width ;
    [_iMessageLabel sizeToFit];
    // 时间
    _iTimeLabel.x = tContentWidth - _iTimeLabel.width;
    _iTimeLabel.y = _iTranslationButton.bottomY;
    // 翻译按钮
    _iTranslationButton.centerX = _iTimeLabel.centerX;
    // 如果 翻译内容
    BOOL hiddenTrans = ([_iTranslationtext isEqualToString:@""] || !_iTranslationtext);
    _iMessageTranslationLabel.hidden = hiddenTrans;
    _translationBorderView.hidden = hiddenTrans;
    
    // 有翻译
    if (!hiddenTrans) {
        _iTranslationButton.sakura.image(ThemeKP(@"translation_selected"), UIControlStateDisabled);
        // 显示分割线
        _translationBorderView.frame = CGRectMake(10,
                                                  fmaxf(_iMessageLabel.bottomY, _iTimeLabel.bottomY) + tViewCap,
                                                  tContentWidth - 20,
                                                  1);
        _iMessageTranslationLabel.y     = _translationBorderView.bottomY + tViewCap;
        _iMessageTranslationLabel.width = tContentWidth - _iNickNameLabel.rightX - tTranslateButtonWidth;
        [_iMessageTranslationLabel sizeToFit];
        
    }
    else {
        _iTranslationButton.sakura.image(ThemeKP(@"translation_normal"), UIControlStateDisabled);
    }
    
}
/*
 - (void)layoutSubviews
 {
 [super layoutSubviews];
 
 CGFloat tViewCap              =     10 * Proportion;
 CGFloat tContentWidth         =     CGRectGetWidth(self.contentView.frame);
 CGFloat tTimeLabelWidth       =     100 * Proportion;    // 原来为50*Proportion
 CGFloat tTimeLabelHeigh       =     16 * Proportion;
 CGFloat tTranslateLabelHeigh  =     25 * Proportion;
 
 //    [_iNickNameLabel sizeToFit];
 
 
 // 消息 宽度
 CGFloat tMessageWidth         =     tContentWidth - tTranslateLabelHeigh - tViewCap * 2 - _iNickNameLabel.rightX;
 CGSize tMessageLabelsize;
 if (_chatModel.messageHeight == 0) {
 
 tMessageLabelsize = [TKChatMessageTableViewCell sizeFromAttributedString:_iText
 withLimitWidth:tMessageWidth
 Font:TKFont(15)];
 _chatModel.messageHeight = tMessageLabelsize.height;
 }
 // 消息 内容
 _iMessageLabel.frame = CGRectMake(0,
 0,
 tMessageWidth,
 _chatModel.messageHeight);
 
 // 消息 背景
 _iMessageView.frame = CGRectMake(
 self.iNickNameLabel.rightX + 5,
 self.iNickNameLabel.y,
 _iMessageLabel.height + tViewCap,
 tMessageLabelsize.height
 );
 
 
 
 // 时间
 _iTimeLabel.frame =  CGRectMake(tContentWidth -(tContentWidth-tTimeLabelWidth-tViewCap) ,
 CGRectGetMaxY(_iMessageView.frame) + 10,
 tContentWidth-tTimeLabelWidth-tViewCap-10,
 tTimeLabelHeigh);
 
 // 转换
 _iTranslationButton.frame = CGRectMake(tContentWidth-18-5, 5,  18,  18);
 //    _iTranslationButton.alpha = 1.;
 
 CGSize tTranslationMessageLabelsize = [TKChatMessageTableViewCell sizeFromText:_iTranslationtext withLimitWidth:tContentWidth - CGRectGetMaxX(self.iNickNameLabel.frame)-5 Font:TKFont(15)];
 
 _translationBorderView.frame = CGRectMake(10, CGRectGetMaxY(_iTimeLabel.frame)+ 5, tContentWidth-20, 1);
 
 _iMessageTranslationLabel.frame = CGRectMake(CGRectGetMinX(self.iMessageView.frame), CGRectGetMaxY(_translationBorderView.frame)+5, tTranslationMessageLabelsize.width+5, tTranslationMessageLabelsize.height+10);
 
 BOOL hiddenTrans = ([_iTranslationtext isEqualToString:@""]|| !_iTranslationtext);
 _iMessageTranslationLabel.hidden = hiddenTrans;
 _translationBorderView.hidden = hiddenTrans;
 if (!hiddenTrans) {
 
 _iTranslationButton.sakura.image(ThemeKP(@"translation_selected"),UIControlStateNormal);
 //        _iTranslationButton.selected = YES;
 }
 
 [TKUtil setHeight:self.contentView To:CGRectGetHeight(_iTimeLabel.frame)+CGRectGetHeight(_iMessageView.frame)+CGRectGetHeight(_iMessageTranslationLabel.frame)+25];
 
 [TKUtil setHeight:self To:CGRectGetHeight(_iTimeLabel.frame)+CGRectGetHeight(_iMessageView.frame)+CGRectGetHeight(_iMessageTranslationLabel.frame)+25];
 
 
 }
 */
- (void)resetView
{
    NSMutableAttributedString *iMessageText = (NSMutableAttributedString *)[NSAttributedString tkEmojiAttributedString:_iText withFont:TEXT_FONT withColor:[TKTheme colorWithPath:@"ClassRoom.TKChatViews.chatMessageColor"]];
    
    _iMessageLabel.attributedText = iMessageText;
    
    _iMessageLabel.sakura.textColor(ThemeKP(@"chatMessageColor"));
    
    //判断是否只是表情，如果只是表情则不进行翻译
    if ([_iTranslationtext isEqualToString:@""]) {
        _iTranslationtext = nil;
    }
    _iMessageTranslationLabel.text = _iTranslationtext;
    
    _iNickNameLabel.text = _iNickName;
    _iTimeLabel.text =  _iTime;
    
    
}




+ (CGSize)sizeFromText:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont
{
    //    CGSize size = [text sizeWithFont:TEXT_FONT constrainedToSize:CGSizeMake(180, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName: aFont};
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}
+ (CGSize)sizeFromText:(NSString *)text withLimitHeight:(CGFloat)height Font:(UIFont*)aFont
{
    //    CGSize size = [text sizeWithFont:TEXT_FONT constrainedToSize:CGSizeMake(180, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName: aFont};
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}
+ (CGFloat)heightFromText:(NSString *)text withLimitWidth:(CGFloat)width
{
    
    CGFloat height = [self sizeFromText:text withLimitWidth:width Font:TEXT_FONT].height;
    return height;
}


+ (CGSize)sizeFromAttributedString:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont{
    //计算富文本的宽高
    CGSize textBlockMinSize = {width-60, CGFLOAT_MAX};
    NSAttributedString *attributedString = [NSAttributedString tkEmojiAttributedString:text withFont:aFont withColor:RGBCOLOR(134, 134, 134)];
    CGRect boundingRect = [attributedString boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize tMessageLabelsize = boundingRect.size;
    return tMessageLabelsize;
}
- (void)setChatModel:(TKChatMessageModel *)chatModel{
    
    //    NSLog(@"liyanyan:%@",chatModel.iMessage);
    _chatModel = chatModel;
    
    _iText               = chatModel.iMessage;
    
    _iMessageLabel.textColor = (chatModel.iMessageType ==TKMessageTypeMe)?  RGBCOLOR(221, 221, 221): RGBCOLOR(162, 162, 162);
    _iTranslationtext    = chatModel.iTranslationMessage;
    
    //    _iTime = [TKUtil getCurrentHoursAndMinutes:chatModel.iTime];
    _iTime = chatModel.iTime;
    
    _iNickName = [NSString stringWithFormat:@"%@:", chatModel.iUserName];
    _iMessageType        = chatModel.iMessageType;
    
    
    
    [self resetView];
}

#pragma 长按复制

-(BOOL)canBecomeFirstResponder {
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(newFunc)) {
        return YES;
    }
    return NO;
}

//针对于响应方法的实现
-(void)copy:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.cString;
}

-(void)newFunc{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.cString;
}

@end

