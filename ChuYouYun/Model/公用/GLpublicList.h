//
//  GLpublicList.h
//  dafengche
//
//  Created by IOS on 16/10/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLpublicList : NSObject

+ (void)creatList:(NSString *)dataID;
//取出缓存的数据
+ (NSArray *)publicDataWithDic:(NSMutableDictionary *)dic DataID:(NSString *)dataID;

//存入缓存的数据
+ (void)savePublicDatas:(NSArray *)SYGTeacher DataID:(NSString *)dataID;


@end
