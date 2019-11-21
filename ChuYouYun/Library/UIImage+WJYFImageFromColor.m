//
//  UIImage+WJYFImageFromColor.m
//  wojiayoufu
//
//  Created by 我家有福 on 15/11/22.
//  Copyright © 2015年 我家有福. All rights reserved.
//

#import "UIImage+WJYFImageFromColor.h"

@implementation UIImage (WJYFImageFromColor)
+(UIImage*)imageWithColor:(UIColor*) color{
    //自定义
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //画布
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    return theImage;
}
@end
