//
//  TKMessageTableViewCell.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKMessageTableViewCell.h"

#import "NSAttributedString+TKEmoji.h"
#import "SYG.h"



#define ThemeKP(args) [@"ClassRoom.TKChatViews." stringByAppendingString:args]
@implementation TKMessageTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setupView
{
    _iMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _iMessageLabel.sakura.textColor(ThemeKP(@"chatUserListTextColor"));
    _iMessageLabel.backgroundColor = [UIColor clearColor];
    _iMessageLabel.textAlignment = NSTextAlignmentCenter;
//    _iMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _iMessageLabel.numberOfLines = 0;
    [_iMessageLabel setFont:TKFont(15)];
    [self.contentView addSubview:_iMessageLabel];
    
    self.bubbleView = [[UIView alloc] init];
    self.bubbleView.layer.cornerRadius = (self.iMessageLabel.height - 8) / 2;
    self.bubbleView.layer.masksToBounds = YES;
    self.bubbleView.sakura.backgroundColor(@"ClassRoom.TKChatViews.chat_bubble_system_color");
    self.bubbleView.sakura.alpha(@"ClassRoom.TKChatViews.chat_bubble_system_alpha");
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor             = [UIColor clearColor];
   
}
- (void)resetView
{
    _iMessageLabel.text = _iMessageText;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize tMessageLabelsize = [TKMessageTableViewCell sizeFromAttributedString:_iMessageText withLimitWidth:CGRectGetWidth(self.frame) Font:TKFont(17)];
    
    _iMessageLabel.frame = CGRectMake(0, 0, tMessageLabelsize.width, 30);
    _iMessageLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _iMessageLabel.sakura.backgroundColor(ThemeKP(@"chatUserListBackgroundColor"));
    _iMessageLabel.layer.masksToBounds = YES;
    _iMessageLabel.layer.cornerRadius = 15;
    
     [TKUtil setCenter:_iMessageLabel ToFrame:self.contentView.frame];
    [self.contentView bringSubviewToFront:_iMessageLabel];
    if ([_iMessageText isEqualToString:@"全体禁言"]) {
        _iMessageLabel.textColor = [TKHelperUtil colorWithHexColorString:@"FF341F"];
    }
}


+ (CGSize)sizeFromText:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont
{
    
    NSDictionary *attribute = @{NSFontAttributeName: aFont};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}
+ (CGSize)sizeFromText:(NSString *)text withLimitHeight:(CGFloat)height Font:(UIFont*)aFont
{
    
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
    CGSize textBlockMinSize = {width, CGFLOAT_MAX};
    NSAttributedString *attributedString = [NSAttributedString tkEmojiAttributedString:text withFont:aFont withColor:RGBCOLOR(134, 134, 134)];
    CGRect boundingRect = [attributedString boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize tMessageLabelsize = boundingRect.size;
    return tMessageLabelsize;
    

}

@end
