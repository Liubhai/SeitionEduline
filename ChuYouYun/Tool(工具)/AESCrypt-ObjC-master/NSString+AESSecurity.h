//
//  NSString+AESSecurity.h
//  AESSecurity
//
//  Created by luzhiyong on 2017/3/6.
//  Copyright © 2017年 ileafly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AESSecurity)

+ (NSString *)encrypyAES:(NSString *)content key:(NSString *)key;

+ (NSString *)descryptAES:(NSString *)content key:(NSString *)key;

@end
