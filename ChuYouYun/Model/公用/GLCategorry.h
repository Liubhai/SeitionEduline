//
//  GLCategorry.h
//  dafengche
//
//  Created by IOS on 16/12/1.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCategorry : NSObject

//取出缓存的数据
+ (NSArray *)gLCategorryWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)savegLCategorry:(NSArray *)SYGTeacher;

@end
