//
//  TeacherTool.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/18.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherTool : NSObject

//取出缓存的数据
+ (NSArray *)teacherWithDic:(NSMutableDictionary *)dic;

//存入缓存的数据
+ (void)saveTeacheres:(NSArray *)SYGTeacher;

@end
