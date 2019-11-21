//
//  GLTextView.m
//  类的封装
//
//  Created by IOS on 16/6/22.
//  Copyright © 2016年 IOS. All rights reserved.
//

#import "GLTextView.h"


@implementation GLTextView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 通过通知监听文本变化
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}


- (void)textDidChange
{
    // 重绘
    [self setNeedsDisplay];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    // 重绘
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    // 重绘
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
    // 重绘
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
    // 重绘
    [self setNeedsDisplay];
}
//偏移量，contentOffset就是(0, 480)，也就是y偏移了480
- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    
    // 重绘
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.text.length) return;
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    // 设置字体大小
    attr[NSFontAttributeName] = self.font;
    // 默认字体颜色为灰色
    attr[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    // 设置绘画的位置，范围
    CGFloat drawX = 5;
    CGFloat drawY = 8;
    CGFloat drawW = rect.size.width - 2 * drawX;
    CGFloat drawH = rect.size.height - 2 * drawY;
    
    CGRect placeholderRect = CGRectMake(drawX, drawY, drawW, drawH);
    
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];

}


@end
