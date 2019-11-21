//
//  myQuestion.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/11.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myQuestion : NSObject

//取出缓存的数据
+ (NSArray *)BJWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)saveBJes:(NSArray *)SYGBJ;

@end
