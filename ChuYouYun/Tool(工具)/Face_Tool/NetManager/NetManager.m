//
//  NetManager.m
//  NetManager
//
//  Created by 阿凡树 on 17-4-7.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "NetManager.h"
//#import <AFNetworking/AFNetworking.h>
#import "AFNetworking.h"

//#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "AFNetworkActivityIndicatorManager.h"

@interface NetManager ()
@property(nonatomic) AFURLSessionManager *sessionManager;
@property(nonatomic) AFHTTPRequestSerializer *requestSerializer;
@end

@implementation NetManager

#pragma mark - init

+ (instancetype)sharedInstance {
    static NetManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 20;
        sessionConfig.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024 diskCapacity:32*1024*1024 diskPath:@"com.baidu.FaceSharp"];
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
        AFHTTPResponseSerializer* serializer = [AFHTTPResponseSerializer serializer];
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/javascript",@"application/json",@"text/plain",@"text/html",@"application/xhtml+xml",@"application/xml",nil];
        _sessionManager.responseSerializer = serializer;
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

#pragma mark - Public Function
- (NSURLSessionDataTask *)getDataWithPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               completion:(FinishBlockWithObject)completionBlock
{
    if (path.length == 0) {
        return nil;
    }
    NSMutableString* url = [path mutableCopy];
    if (parameters != nil) {
        NSMutableString* paraStr = [[NSMutableString alloc] init];
        for (NSString* key in parameters.allKeys) {
            [paraStr appendFormat:@"%@=%@&",key,parameters[key]];
        }
        [url appendFormat:@"?%@",[paraStr substringWithRange:NSMakeRange(0, paraStr.length - 2)]];
    }
    NSURLSessionDataTask* task = [_sessionManager dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            completionBlock(error,responseObject);
    }];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)postDataWithPath:(NSString *)path
                                parameters:(NSDictionary *)parameters
                                completion:(FinishBlockWithObject)completionBlock {
    NSMutableURLRequest* postRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    postRequest.HTTPMethod = @"POST";
    NSError* error = nil;
    postRequest = [[_requestSerializer requestBySerializingRequest:postRequest withParameters:parameters error:&error] mutableCopy];
    if (error != nil) {
        NSLog(@"error = %@",error);
    }
    NSURLSessionDataTask* task = [_sessionManager dataTaskWithRequest:postRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        completionBlock(error,responseObject);
    }];
    [task resume];
    return task;
}

+ (NSString *)networkStatusMode
{
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:return @"NoInternet";
        case AFNetworkReachabilityStatusReachableViaWiFi:return @"Wifi";
        case AFNetworkReachabilityStatusReachableViaWWAN:return @"2G/3G";
        case AFNetworkReachabilityStatusUnknown:
        default:return @"未知错误";
    }
}

+ (BOOL)isReachableNet
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isReachableViaWWAN
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isReachableViaWiFi
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

@end
