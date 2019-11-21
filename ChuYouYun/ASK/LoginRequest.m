//
//  LoginRequest.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "LoginRequest.h"
#import "AFNetworking.h"
#import "ZYDefines.h"
#import "BaseClass.h"
@implementation LoginRequest


+(id)loginWithRequests:(NSString *)userName withPassword:(NSString *)password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str = [NSString stringWithFormat:@"http://demo.chuyouyun.com/index.php?app=api&mod=Login&act=login"];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"uname",userName,@"",password, nil];
    __block BaseClass *base = [[BaseClass alloc]init];
    [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        base = [BaseClass modelObjectWithDictionary:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    return base;
}

@end
