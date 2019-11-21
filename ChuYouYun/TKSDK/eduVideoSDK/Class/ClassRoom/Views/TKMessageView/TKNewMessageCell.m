//
//  TMNewMessageCell.m
//  EduClass
//
//  Created by talk on 2018/11/21.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKNewMessageCell.h"
#import "SYG.h"


#define ThemeKP(args) [@"ClassRoom.TKChatViews." stringByAppendingString:args]
@implementation TKNewMessageCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor =UIColor.clearColor;
    self.iMessageLabel.font = TKFont(11);
    self.iMessageLabel.numberOfLines = 1;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.iMessageLabel.backgroundColor = UIColor.clearColor;
    
    CGSize tMessageLabelsize = [TKNewMessageCell sizeFromText:self.iMessageLabel.text withLimitWidth:self.width / 3 * 2 - 20 Font:TKFont(11)];
    self.iMessageLabel.width = tMessageLabelsize.width;
    [TKUtil setCenter:self.iMessageLabel ToFrame:self.contentView.frame];
    self.iMessageLabel.x = 5;
    
    
    if (!_bubbleView) {
        _bubbleView = [[UIView alloc] init];
        _bubbleView.layer.cornerRadius = (self.iMessageLabel.height - 8) / 2;
        _bubbleView.layer.masksToBounds = YES;
        _bubbleView.sakura.backgroundColor(@"ClassRoom.TKChatViews.chat_bubble_system_color");
        _bubbleView.sakura.alpha(@"ClassRoom.TKChatViews.chat_bubble_system_alpha");
        [self.contentView addSubview:_bubbleView];
        
        [self.contentView sendSubviewToBack:_bubbleView];
    }
    
    _bubbleView.frame = self.iMessageLabel.frame;
    _bubbleView.height = self.iMessageLabel.height - 8;
    self.iMessageLabel.centerY = _bubbleView.centerY;
    _bubbleView.width = _bubbleView.width + 10;
    _bubbleView.x = 0;
    
    [self.contentView bringSubviewToFront:self.iMessageLabel];
}

- (void)setTextColor:(UIColor *)color
{
    if (!color) {
        self.iMessageLabel.sakura.textColor(ThemeKP(@"chatUserListTextColor"));
    } else {
        self.iMessageLabel.textColor = color;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
