//
//  myBJ.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/8.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myBJ : NSObject

//取出缓存的数据
+ (NSArray *)BJWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)saveBJes:(NSArray *)SYGBJ;

@end
