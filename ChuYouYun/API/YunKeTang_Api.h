//
//  YunKeTang_Api.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/3/28.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Api_Config.h"


@interface YunKeTang_Api : AFHTTPRequestOperationManager


#pragma mark --- 通用网络请求
-(void)YunKeTang_GetPublicWay:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark --- 加密方法的运用
- (NSDictionary *)YunkeTang_Encrypt_NetWork:(NSString *)url dictionary:(NSDictionary *)dict;



@end
