//
//  OnLiveList.m
//  dafengche
//
//  Created by IOS on 16/11/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "OnLiveList.h"
#import "FMDB.h"


@implementation OnLiveList

static FMDatabase *_db;


+ (void)initialize {
    //打开数据库
    //    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"blum.sqlite"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp/OnLive.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_OnLive ( OnLive NOT NULL);"];
    
}

+(NSArray *)OnLiveWithDic:(NSMutableDictionary *)dic {
    
    //根据请求参数生成对应的SQL语句
    //    NSString *sql = @"SELECT * FROM t_blum WHERE idstr > %@ ORDER BY idstr DESC LIMIT 6";
    //    NSString *sql = @"SELECT * FROM t_blum WHERE idstr < %@ ORDER BY idstr DESC LIMIT 6";
    NSString *sql = @"SELECT * FROM t_OnLive ";
    
    
    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *blums = [NSMutableArray array];
    while (set.next) {
        NSData *blumData = [set objectForColumnName:@"OnLive"];
        NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [blums addObject:blum];
    }
    return blums;
}

+ (void)saveOnLive:(NSArray *)OnLive {
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *OnLive in OnLive ) {
        NSData *OnLiveData = [NSKeyedArchiver archivedDataWithRootObject:OnLive];
        [_db executeUpdateWithFormat:@"INSERT INTO t_OnLive(OnLive) VALUES (%@);",OnLiveData];
    }
    
    
}


@end
