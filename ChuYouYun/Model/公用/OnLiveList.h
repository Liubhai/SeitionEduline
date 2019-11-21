//
//  OnLiveList.h
//  dafengche
//
//  Created by IOS on 16/11/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnLiveList : NSObject

//取出缓存的数据
+ (NSArray *)OnLiveWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)saveOnLive:(NSArray *)OnLive;

@end
