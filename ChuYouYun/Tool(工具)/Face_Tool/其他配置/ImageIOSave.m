//
//  ImageIOSave.m
//  FaceSharp
//
//  Created by 阿凡树 on 2017/5/26.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "ImageIOSave.h"
@interface UIImage (Additions)
- (NSData *)data;
@end

@implementation UIImage (Additions)
- (NSData *)data {
    NSData* data = UIImageJPEGRepresentation(self, 0.6);
    if (data == nil) {
        data = UIImagePNGRepresentation(self);
    }
    return data;
}
@end
@implementation ImageIOSave

+ (void)writeImageStr:(NSString *)image withName:(NSString *)name {
    NSString* path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    [image writeToFile:[path stringByAppendingPathComponent:name] atomically:YES encoding:NSASCIIStringEncoding error:nil];
}

+ (void)writeImage:(UIImage *)image withName:(NSString *)name; {
    NSString* path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    [[image data] writeToFile:[path stringByAppendingPathComponent:name] atomically:YES];
}

+ (UIImage *)readImageWithname:(NSString *)name {
    NSString* path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString* imagePath = [path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:imagePath];
}

+ (UIImage *)readImageStrWithname:(NSString *)name {
    NSString* path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString* imagePath = [path stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        NSString* str = [NSString stringWithContentsOfFile:imagePath encoding:NSASCIIStringEncoding error:nil];
        NSData* data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        return [UIImage imageWithData:data];
    } else {
        return nil;
    }
}

@end


