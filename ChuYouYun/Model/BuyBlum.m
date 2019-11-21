//
//  BuyBlum.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/7.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "BuyBlum.h"
#import "FMDB.h"


@implementation BuyBlum

static FMDatabase *_db;
+ (void)initialize {
    //打开数据库
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BuyBlum.sqlite"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp/BuyBlum.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_BuyBlum (id integer PRIMARY KEY, BuyBlum NOT NULL,idstr text NOT NULL);"];
    
}

+(NSArray *)blumWithDic:(NSMutableDictionary *)dic {
    
    //根据请求参数生成对应的SQL语句
    //    NSString *sql = @"SELECT * FROM t_blum WHERE idstr > %@ ORDER BY idstr DESC LIMIT 6";
    //    NSString *sql = @"SELECT * FROM t_blum WHERE idstr < %@ ORDER BY idstr DESC LIMIT 6";
    NSString *sql = @"SELECT * FROM t_BuyBlum ORDER BY idstr DESC LIMIT 20";
    
    
    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *blums = [NSMutableArray array];
    while (set.next) {
        NSData *blumData = [set objectForColumnName:@"BuyBlum"];
        NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [blums addObject:blum];
    }
    return blums;
}

+ (void)saveBlums:(NSArray *)blums {
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *blum in blums ) {
        NSData *blumData = [NSKeyedArchiver archivedDataWithRootObject:blum];
        [_db executeUpdateWithFormat:@"INSERT INTO t_BuyBlum(BuyBlum ,idstr) VALUES (%@,%@);",blumData,blum];
    }
    
    
}



@end
