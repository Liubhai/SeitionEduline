//
//  MYinfoTool.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/19.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "MYinfoTool.h"
#import "FMDB.h"

@implementation MYinfoTool

static FMDatabase *_db;
+ (void)initialize {
    //打开数据库
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"myinfo.sqlite"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp/myinfo.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_myinfo (id integer PRIMARY KEY, myinfo NOT NULL,idstr text NOT NULL);"];
    
}

+ (NSArray *)myWithDic:(NSMutableDictionary *)dic {
    
    //根据请求参数生成对应的SQL语句
    NSString *sql = @"SELECT * FROM t_myinfo ORDER BY idstr DESC LIMIT 20";
    
    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *classes = [NSMutableArray array];
    while (set.next) {
        NSData *blumData = [set objectForColumnName:@"myinfo"];
      NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [classes addObject:blum];
    }
    return classes;
}


+ (void)saveMYes:(NSArray *)SYGWendaes {
    
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *class in SYGWendaes ) {
        NSData *classData = [NSKeyedArchiver archivedDataWithRootObject:class];
        [_db executeUpdateWithFormat:@"INSERT INTO t_myinfo(myinfo ,idstr) VALUES (%@,%@);",classData,class];
        
    }
    
    
}


@end
