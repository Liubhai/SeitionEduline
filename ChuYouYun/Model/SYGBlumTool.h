//
//  SYGBlumTool.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/15.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYGBlumTool : NSObject

//取出缓存的数据
+ (NSArray *)blumWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)saveBlums:(NSArray *)blums;

@end
