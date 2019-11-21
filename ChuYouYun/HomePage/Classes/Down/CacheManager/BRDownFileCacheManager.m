//
//  BRDownFileCacheManager.m
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BRDownFileCacheManager.h"
#import "FMDB.h"
#import "SYG.h"
@interface BRDownFileCacheManager()
@property (nonatomic, strong) FMDatabase *db;
@end;
@implementation BRDownFileCacheManager
+(instancetype)manager{
    static BRDownFileCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BRDownFileCacheManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"coureseList.db"]];
        
        _db = [FMDatabase databaseWithPath:dbPath];
        [_db open];
        
        //创表
        [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_class (courseId text  PRIMARY KEY,class NOT NULL,userId text);"];

       
    }
    return self;
}


-(NSArray *)classWithDic:(NSMutableDictionary *)dic {
    
    if (!UserID) {
        return nil;
    }
    //根据请求参数生成对应的SQL语句
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_class where userId = %@",UserID];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_class"];

    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *classes = [NSMutableArray array];
    while (set.next) {
        NSData *blumData = [set objectForColumnName:@"class"];
        NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [classes addObject:blum];
    }
    return classes;
}

-(void)saveClasses:(NSArray *)SYGClass {
    
    if (!UserID) {
        return ;
    }
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *class in SYGClass ) {
        NSData *classData = [NSKeyedArchiver archivedDataWithRootObject:class];
        NSString *id_str = class[@"id"];
        if (id_str) {
            if (![id_str isKindOfClass:[NSString class]]) {
                id_str = [NSString stringWithFormat:@"%@",id_str];
            }
            [_db executeUpdateWithFormat:@"INSERT INTO t_class(courseId,class,userId) VALUES (%@,%@,%@);",id_str,classData,UserID];
        }
        
    }
    
}

@end
