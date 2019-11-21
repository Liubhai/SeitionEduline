//
//  AreaTool.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/28.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "AreaTool.h"
#import "FMDB.h"

@implementation AreaTool

static FMDatabase *_db;
+ (void)initialize {
    //打开数据库
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"area.sqlite"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp/area.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_area (id integer PRIMARY KEY, area NOT NULL,idstr text NOT NULL);"];
    
}

+(NSArray *)areaWithDic:(NSMutableDictionary *)dic {
    
    //根据请求参数生成对应的SQL语句
    //    NSString *sql = @"SELECT * FROM t_blum WHERE idstr > %@ ORDER BY idstr DESC LIMIT 6";
    //    NSString *sql = @"SELECT * FROM t_blum WHERE idstr < %@ ORDER BY idstr DESC LIMIT 6";
    NSString *sql = @"SELECT * FROM t_area";
    
    
    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *blums = [NSMutableArray array];
    while (set.next) {
        NSData *blumData = [set objectForColumnName:@"area"];
        NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [blums addObject:blum];
    }
    return blums;
}

+ (void)saveAreas:(NSArray *)blums {
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *blum in blums ) {
        NSData *blumData = [NSKeyedArchiver archivedDataWithRootObject:blum];
        [_db executeUpdateWithFormat:@"INSERT INTO t_area(area ,idstr) VALUES (%@,%@);",blumData,blum];
    }
    
    
}



@end
