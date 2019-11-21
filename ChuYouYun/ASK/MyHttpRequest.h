//
//  MyHttpRequest.h
//  ThinkSNS
//
//  Created by 卢小成 on 14/11/28.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ASIHTTPRequest.h"
//#import "RegisterModel.h"
#define API_Base_Url @""
#define GLAPI_Base_Url @""

@interface MyHttpRequest : NSObject

{
    ASIHTTPRequest *_request;
}

/*
 urlStr URL地址
 method 请求方式   GET／POST
 parameter 详细URL参数拼接
 
 */
+ (void)requestWithURLString:(NSString *)urlStr requestMethod:(NSString *)method parameterDictionary:(NSDictionary *)parameter completion:(void (^) (id obj))completionBlock;

@end



@interface QKHTTPManager : AFHTTPRequestOperationManager

+ (instancetype)manager;



//公用
-(void)getpublicPort:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)getTokenpublicPort:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//公用，需要传入oauth_token
- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret;

//收藏、取消收藏直播
- (void)collectLive:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end





