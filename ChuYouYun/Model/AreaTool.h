//
//  AreaTool.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/28.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaTool : NSObject

//取出缓存的数据
+ (NSArray *)areaWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)saveAreas:(NSArray *)SYGAreas;

@end
