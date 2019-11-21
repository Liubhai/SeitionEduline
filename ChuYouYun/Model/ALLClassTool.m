//
//  ALLClassTool.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/18.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "ALLClassTool.h"
#import "FMDB.h"

@implementation ALLClassTool

static FMDatabase *_db;
+ (void)initialize {
    //打开数据库
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ALLclass.sqlite"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp/ALLclass.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_ALLclass (id integer PRIMARY KEY, ALLclass NOT NULL,idstr text NOT NULL);"];
    
}

+(NSArray *)classWithDic:(NSMutableDictionary *)dic {
    
    //根据请求参数生成对应的SQL语句
    NSString *sql = @"SELECT * FROM t_ALLclass ORDER BY idstr DESC LIMIT 6";
    
    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *classes = [NSMutableArray array];
    while (set.next) {
        NSData *blumData = [set objectForColumnName:@"ALLclass"];
        NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [classes addObject:blum];
    }
    return classes;
}


+(void)saveClasses:(NSArray *)SYGClass {
    
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *class in SYGClass ) {
        NSData *classData = [NSKeyedArchiver archivedDataWithRootObject:class];
        [_db executeUpdateWithFormat:@"INSERT INTO t_ALLclass(ALLclass ,idstr) VALUES (%@,%@);",classData,class];
    }
    
}


@end
