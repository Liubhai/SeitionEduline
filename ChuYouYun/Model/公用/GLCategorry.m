//
//  GLCategorry.m
//  dafengche
//
//  Created by IOS on 16/12/1.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLCategorry.h"
#import "FMDB.h"

@implementation GLCategorry

static FMDatabase *_db;
+ (void)initialize {
    //打开数据库
    //    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"teacher.sqlite"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp/gLCategorry.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
//    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_gLCategorry (id integer PRIMARY KEY, gLCategorry NOT NULL,idstr text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_gLCategorry (gLCategorry NOT NULL);"];
//    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_blum ( blum NOT NULL);"];
    
}

+ (NSArray *)gLCategorryWithDic:(NSMutableDictionary *)dic {
    
    //根据请求参数生成对应的SQL语句
    NSString *sql = @"SELECT * FROM t_gLCategorry ORDER BY idstr DESC LIMIT 20";
    
    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *classes = [NSMutableArray array];
    while (set.next) {
        NSData *blumData = [set objectForColumnName:@"gLCategorry"];
        NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [classes addObject:blum];
    }
    return classes;
}


+ (void)savegLCategorry:(NSArray *)SYGTeacher {
    
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *class in SYGTeacher ) {
        NSData *classData = [NSKeyedArchiver archivedDataWithRootObject:class];
//        [_db executeUpdateWithFormat:@"INSERT INTO t_gLCategorry(gLCategorry ,idstr) VALUES (%@,%@);",classData,class];
        [_db executeUpdateWithFormat:@"INSERT INTO t_gLCategorry(gLCategorry) VALUES (%@);",classData];
//            [_db executeUpdateWithFormat:@"INSERT INTO t_blum(blum) VALUES (%@);",blumData];
    }
    
}


@end
