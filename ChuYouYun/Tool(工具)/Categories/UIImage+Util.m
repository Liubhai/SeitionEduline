//
//  UIImage+Util.m
//  ThinkSNS（探索版）
//
//  Created by lip on 16/11/17.
//  Copyright © 2016年 zhishi. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)
- (UIImage *)converToMainColor {
    UIImage *newImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [BasidColor set];
    [newImage drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
