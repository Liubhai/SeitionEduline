//
//  MyHttpRequest.m
//  ThinkSNS
//
//  Created by 卢小成 on 14/11/28.
//
//

#import "MyHttpRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@implementation MyHttpRequest

+ (void)requestWithURLString:(NSString *)urlStr requestMethod:(NSString *)method parameterDictionary:(NSDictionary *)parameter completion:(void (^)(id))completionBlock
{
    if (!method)
    {
        NSString *getString = @"?";
        for (int i = 0; i < parameter.allKeys.count; i ++)
        {
            
            NSString *keyString = parameter.allKeys[i];
            NSString *valuesString = parameter.allValues[i];
            getString = [getString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",keyString,valuesString]];
        }
        NSLog(@"----%@",[NSString stringWithFormat:@"%@%@",urlStr,getString]);
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",urlStr,getString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        [request setCompletionBlock:^{
            completionBlock(request.responseData);
        }];
        [request startAsynchronous];
    }
    else
    {
        NSLog(@"++++++%@",urlStr);
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
        for (int i = 0; i < parameter.allKeys.count ; i ++)
        {
            [request addPostValue:parameter.allValues[i] forKey:parameter.allKeys[i]];
        }
        [request setCompletionBlock:^{
            completionBlock(request.responseData);
        }];
        
        [request startAsynchronous];
    }
}
@end

@implementation QKHTTPManager


+ (instancetype)manager
{
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:API_Base_Url]];
}

- (NSString *)URLParamsWithMode:(NSString *)mod act:(NSString *)act
{
    return [API_Base_Url stringByAppendingFormat:@"&mod=%@&act=%@",mod, act];
}
- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret
{
    return [API_Base_Url stringByAppendingFormat:@"&mod=%@&act=%@&oauth_token=%@&oauth_token_secret=%@",mod,act,oauth_token,oauth_token_secret];
}


//公用
-(void)getpublicPort:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSString *scheme = [self URLParamsWithMode:mod act:act];
    NSLog(@"===6===%@",scheme);
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

@end




