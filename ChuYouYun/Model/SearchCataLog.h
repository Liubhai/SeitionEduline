//
//  SearchCataLog.h
//  dafengche
//
//  Created by 赛新科技 on 2017/4/19.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCataLog : NSObject

//取出缓存的数据
+ (NSArray *)CataLogWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)saveCataLogs:(NSArray *)CataLogs;

@end
