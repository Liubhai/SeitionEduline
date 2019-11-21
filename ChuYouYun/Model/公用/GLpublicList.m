//
//  GLpublicList.m
//  dafengche
//
//  Created by IOS on 16/10/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLpublicList.h"
#import "FMDB.h"


@implementation GLpublicList

static FMDatabase *_db;

+ (void)creatList:(NSString *)dataID{
    //打开数据库
    //    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"teacher.sqlite"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Private Documents/Temp/%@.sqlite",dataID]];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
    [_db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_%@ (id integer PRIMARY KEY, %@ NOT NULL,idstr text NOT NULL);",dataID,dataID]];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_teacher (id integer PRIMARY KEY, teacher NOT NULL,idstr text NOT NULL);"];
    
}

+ (NSArray *)publicDataWithDic:(NSMutableDictionary *)dic DataID:(NSString *)dataID{
    
    //根据请求参数生成对应的SQL语句
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM t_%@ ORDER BY idstr DESC LIMIT 20",dataID];
    
    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *classes = [NSMutableArray array];
    while (set.next) {
        
        NSData *blumData = [set objectForColumnName:dataID];
        
        NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [classes addObject:blum];
    }
    return classes;
}


+ (void)savePublicDatas:(NSArray *)SYGTeacher DataID:(NSString *)dataID {
    
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *class in SYGTeacher ) {
        NSData *classData = [NSKeyedArchiver archivedDataWithRootObject:class];
        [_db executeUpdateWithFormat:@"INSERT INTO t_%@(teacher ,idstr) VALUES (%@,%@);",dataID,classData,class];
    }
    
}


@end
