//
//  SearchCataLog.m
//  dafengche
//
//  Created by 赛新科技 on 2017/4/19.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//  搜索分类

#import "SearchCataLog.h"
#import "FMDB.h"

@implementation SearchCataLog

static FMDatabase *_db;
+ (void)initialize {
    //打开数据库
    //    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"blum.sqlite"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp/cataLog.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_cataLog (cataLog NOT NULL);"];
    
}

+(NSArray *)CataLogWithDic:(NSMutableDictionary *)dic {
    
    //根据请求参数生成对应的SQL语句
    //    NSString *sql = @"SELECT * FROM t_cataLog WHERE idstr > %@ ORDER BY idstr DESC LIMIT 6";
    //    NSString *sql = @"SELECT * FROM t_cataLog WHERE idstr < %@ ORDER BY idstr DESC LIMIT 6";
    NSString *sql = @"SELECT * FROM t_cataLog ";
    
    
    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *blums = [NSMutableArray array];
    while (set.next) {
        NSData *blumData = [set objectForColumnName:@"cataLog"];
        NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [blums addObject:blum];
    }
    return blums;
}

+ (void)saveCataLogs:(NSArray *)CataLogs {
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *blum in CataLogs ) {
        NSData *blumData = [NSKeyedArchiver archivedDataWithRootObject:blum];
        [_db executeUpdateWithFormat:@"INSERT INTO t_cataLog(cataLog) VALUES (%@);",blumData];
    }
    
    
}


@end
