//
//  UIImage+TKExtension.m
//  EduClass
//
//  Created by lyy on 2018/5/4.
//  Copyright © 2018年 talkcloud. All rights reserved.
//


#import "UIImage+TKExtension.h"
#import "SYG.h"


@implementation UIImage (TKExtension)

//+ (UIImage *)imageWithName:(NSString *)name
//{
//    if (1) {
//        NSString *newName = [name stringByAppendingString:@"_os7"];
//        UIImage *image = [UIImage imageNamed:newName];
//        if (image == nil) {
//            image = [UIImage imageNamed:name];
//        }
//        return image;
//    }
//    return [UIImage imageNamed:name];
//}

+ (UIImage *)tkResizedImageWithName:(NSString *)name
{
//    UIImage *image = [self imageNamed:name];
    
    UIImage *image = [TKTheme imageWithPath:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (UIImage *)tkFixOrientation:(UIImage *)aImage {
    //图片大于2M时会被旋转
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,
                                                   aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the
    // transform
    // calculated above.
    CGContextRef ctx =
    CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                          CGImageGetBitsPerComponent(aImage.CGImage), 0,
                          CGImageGetColorSpace(aImage.CGImage),
                          CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(
                               ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width),
                               aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(
                               ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height),
                               aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
