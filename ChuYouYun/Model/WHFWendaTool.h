//
//  WHFWendaTool.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/18.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHFWendaTool : NSObject

//取出缓存的数据
+ (NSArray *)wendaWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)saveWendaes:(NSArray *)SYGWendaes;

@end
