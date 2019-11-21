//
//  TKNewChatMessageTableViewCell.m
//  EduClass
//
//  Created by talk on 2018/11/11.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKNewChatMessageTableViewCell.h"
#import "NSAttributedString+TKEmoji.h"
#import <objc/runtime.h>
#import "TKLinkLabel.h"
#import "TKEduClassRoom.h"


@implementation TKNewChatMessageTableViewCell
{
    ;
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setChatModel:(TKChatMessageModel *)chatModel
{
    [super setChatModel:chatModel];
    
    //根据配置项决定中日互译还是中英互译
    self.iTranslationButton.sakura.image([TKEduClassRoom shareInstance].roomJson.configuration.isChineseJapaneseTranslation ? @"TKChatViews.cj_translation_normal": @"TKChatViews.translation_normal", UIControlStateNormal);
    self.iTranslationButton.sakura.image([TKEduClassRoom shareInstance].roomJson.configuration.isChineseJapaneseTranslation ? @"TKChatViews.cj_translation_selected" : @"TKChatViews.translation_selected", UIControlStateNormal);
    
    self.translationBorderView.backgroundColor = UIColor.whiteColor;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.iMessageLabel.isWhiteColor = YES;
    //自己的名字显示黄色他人名字显示白色
    self.iNickNameLabel.sakura.textColor(chatModel.iMessageType == TKMessageTypeMe ? @"TKUserListTableView.coursewareButtonYellowColor" : @"TKUserListTableView.coursewareButtonWhiteColor");
    self.iMessageLabel.attributedText = (NSMutableAttributedString *)[NSAttributedString tkEmojiAttributedString:self.iText withFont:TEXT_FONT withColor:UIColor.whiteColor];//[TKTheme colorWithPath:@"ClassRoom.TKChatViews.chatMessageColor"]
    self.iNickNameLabel.text = [NSString stringWithFormat:@"%@:", (chatModel.iMessageType == TKMessageTypeMe) ? MTLocalized(@"Role.Me") : chatModel.iUserName];
    //    [self adaptCoordinate];
    if (!_bubbleView) {
        _bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleView.sakura.image(@"ClassRoom.TKChatViews.chat_bubble");
        UIImage *image = _bubbleView.image;
        CGFloat top = image.size.height/2.0;
        CGFloat left = image.size.width/2.0;
        CGFloat bottom = image.size.height/2.0;
        CGFloat right = image.size.width/2.0;
        _bubbleView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
        [self.contentView addSubview:_bubbleView];
        [self.contentView sendSubviewToBack:_bubbleView];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor = UIColor.clearColor;
    //隐藏时间label
//    self.iTimeLabel.height = 0;
    
    CGSize nameSize = [[self class] sizeFromText:self.iNickNameLabel.text withLimitWidth:fminf(self.width / 3, 100) Font:TKFont(14)];
    self.iNickNameLabel.size = nameSize;
    self.iNickNameLabel.x = 11;
    self.iNickNameLabel.y = 16 * Proportion;
    
//    CGSize msgSize = [[self class] sizeFromAttributedString:self.iText.length > 0 ? self.iText : @" " withLimitWidth:self.width - 11 -  self.iNickNameLabel.width - 10 - 10 - 10 - 20  Font:TKFont(14)];
    
    CGFloat limitWidth = self.width - 11 -  self.iNickNameLabel.width - 10 - 10 - 10 - 20;
    CGSize msgSize = [self.iMessageLabel sizeThatFits:CGSizeMake(limitWidth, CGFLOAT_MAX)];

    self.iMessageLabel.size = msgSize;
    self.iMessageLabel.x = CGRectGetMaxX(self.iNickNameLabel.frame) + 10;
    self.iMessageLabel.y = 16 * Proportion;
    self.iTranslationButton.autoresizingMask = UIViewAutoresizingNone;
    self.iTranslationButton.x = CGRectGetMaxX(self.iMessageLabel.frame) + 10;
    
    self.iMessageTranslationLabel.x = self.iNickNameLabel.x;
    self.iMessageTranslationLabel.textColor = UIColor.whiteColor;
    
    float bubbleWidth = CGRectGetMaxX(self.iTranslationButton.frame) + 10;
    
    self.translationBorderView.y = CGRectGetMaxY(self.iMessageLabel.frame) + 10;
    self.translationBorderView.width = bubbleWidth - self.translationBorderView.x * 2;
    
    self.iMessageTranslationLabel.y = CGRectGetMaxY(self.translationBorderView.frame) + 10;
    
    CGSize trSize = [[self class] sizeFromText:self.iMessageTranslationLabel.text withLimitWidth:bubbleWidth - 20 Font:TKFont(15)];
    self.iMessageTranslationLabel.size = trSize;
    self.iMessageTranslationLabel.x = 10;
    
    _bubbleView.frame = CGRectMake(0, 0, bubbleWidth, self.height - 8);
}

//根据显示内容计算高度
+ (CGFloat)heightForCellWithText:(NSString *)text limitWidth:(CGFloat)width
{
   NSAttributedString *attributedText = [NSAttributedString tkEmojiAttributedString:text withFont:TEXT_FONT withColor:UIColor.whiteColor];

    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.font = TKFont(14);
    tempLabel.numberOfLines = 0;
    tempLabel.attributedText = attributedText;
    
    CGSize labelSize = [tempLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    
    return labelSize.height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
