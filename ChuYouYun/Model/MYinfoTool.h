//
//  MYinfoTool.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/19.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYinfoTool : NSObject

//取出缓存的数据
+ (NSArray *)myWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)saveMYes:(NSArray *)SYGWendae;

@end
