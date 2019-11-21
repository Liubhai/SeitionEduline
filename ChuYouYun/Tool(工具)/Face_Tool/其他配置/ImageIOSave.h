//
//  ImageIOSave.h
//  FaceSharp
//
//  Created by 阿凡树 on 2017/5/26.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageIOSave : NSObject

+ (void)writeImageStr:(NSString *)image withName:(NSString *)name;

+ (UIImage *)readImageStrWithname:(NSString *)name;

+ (void)writeImage:(UIImage *)image withName:(NSString *)name;

+ (UIImage *)readImageWithname:(NSString *)name;

@end
