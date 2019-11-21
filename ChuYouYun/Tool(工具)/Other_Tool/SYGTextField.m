//
//  SYGTextField.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/12.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "SYGTextField.h"

@implementation SYGTextField


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)sygDrawPlaceholderInRect:(CGRect)rect{
    UIColor *placeholderColor = [UIColor grayColor];//设置颜色
    [placeholderColor setFill];
    
    CGRect placeholderRect = CGRectMake(rect.origin.x+10, (rect.size.height- self.font.pointSize)/2, rect.size.width, self.font.pointSize);//设置距离
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = self.textAlignment;
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName, self.font, NSFontAttributeName, placeholderColor, NSForegroundColorAttributeName, nil];
    
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];
}


@end
