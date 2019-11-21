//
//  BankTool.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/28.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankTool : NSObject

//取出缓存的数据
+ (NSArray *)bankWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)saveBanks:(NSArray *)SYGBanks;

@end
