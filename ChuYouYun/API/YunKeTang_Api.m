//
//  YunKeTang_Api.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/3/28.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "YunKeTang_Api.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "AESCrypt.h"
#import "NSData+CommonCrypto.h"
#import "NSString+AESSecurity.h"
#import "SYG.h"
#import "NSString+SBJSON.h"
#import "SBJsonParser.h"


@interface YunKeTang_Api()

@property (strong ,nonatomic)NSDictionary     *dataSource;

@end

@implementation YunKeTang_Api

#define API_YunKeTang_URL @""

#pragma mark --- 初始化
+ (instancetype)manager
{
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:API_YunKeTang_URL]];
}
- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act
{
    return [API_YunKeTang_URL stringByAppendingFormat:@"&mod=%@&act=%@",mod,act];
}

#pragma mark --- 通用网络请求
-(void)YunKeTang_GetPublicWay:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *scheme = [self URLParamsWithModel:mod act:act];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


- (NSDictionary *)YunkeTang_Encrypt_NetWork:(NSString *)url dictionary:(NSDictionary *)dict {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    
    NSString *newStr = [self jsonStringWithDict:dict];
    NSString *keyStr = [NSString stringWithFormat:@"%@|%@",timeSp,newStr];
    NSString *encryptStr = [NSString encrypyAES:keyStr key:NetKey];
    //替换特殊符号
    encryptStr = [encryptStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    encryptStr = [encryptStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    //添加header
    [request setValue:encryptStr forHTTPHeaderField:@"En-Params"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * dataqqq = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:dataqqq options:NSJSONReadingMutableLeaves error:nil];
        
        
        NSString *dataStr = [jsonDict stringValueForKey:@"data"];
        dataStr = [dataStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
        dataStr = [dataStr stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
        
        NSString *decodeStr = [NSString descryptAES:dataStr key:NetKey];
        NSString *fromStr = [decodeStr substringFromIndex:11];
        SBJsonParser* json =[[SBJsonParser alloc]init];
        NSMutableDictionary* dic =[json objectWithString:fromStr];
        _dataSource = dic;
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    [op start];
    return _dataSource;
    
}


#pragma mark --- Tool (将字典转成json格式的字符串)
- (NSString *)jsonStringWithDict:(NSDictionary *)dict {
    NSError *error;
    // 注
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingSortedKeys error:&error];
    
    // NSJSONWritingSortedKeys这个枚举类型只适用iOS11所以我是使用下面写法解决的
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:nil error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

@end
