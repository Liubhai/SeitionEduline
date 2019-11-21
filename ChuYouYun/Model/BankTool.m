//
//  BankTool.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/28.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "BankTool.h"
#import "FMDB.h"

@implementation BankTool

static FMDatabase *_db;
+ (void)initialize {
    //打开数据库
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bank.sqlite"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp/bank.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_bank (id integer PRIMARY KEY, bank NOT NULL,idstr text NOT NULL);"];
    
}

+(NSArray *)bankWithDic:(NSMutableDictionary *)dic {
    
    //根据请求参数生成对应的SQL语句
    //    NSString *sql = @"SELECT * FROM t_blum WHERE idstr > %@ ORDER BY idstr DESC LIMIT 6";
    //    NSString *sql = @"SELECT * FROM t_blum WHERE idstr < %@ ORDER BY idstr DESC LIMIT 6";
    NSString *sql = @"SELECT * FROM t_bank";
    
    
    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *blums = [NSMutableArray array];
    while (set.next) {
        NSData *blumData = [set objectForColumnName:@"bank"];
        NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [blums addObject:blum];
    }
    return blums;
}

+ (void)saveBanks:(NSArray *)blums {
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *blum in blums ) {
        NSData *blumData = [NSKeyedArchiver archivedDataWithRootObject:blum];
        [_db executeUpdateWithFormat:@"INSERT INTO t_bank(bank ,idstr) VALUES (%@,%@);",blumData,blum];
    }
    
    
}



@end
