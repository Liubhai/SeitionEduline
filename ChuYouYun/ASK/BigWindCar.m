//
//  BigWindCar.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/25.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "BigWindCar.h"

#import "ZhiyiHTTPRequest.h"
#import "AFNetworking.h"

@implementation BigWindCar


#define API_BigWinCar_URL @""

+ (instancetype)manager
{
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:API_BigWinCar_URL]];
}
- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act
{
    return [API_BigWinCar_URL stringByAppendingFormat:@"&mod=%@&act=%@",mod,act];
}
#pragma UserToken
- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret
{
    return [API_BigWinCar_URL stringByAppendingFormat:@"&mod=%@&act=%@&oauth_token=%@&oauth_token_secret=%@",mod,act,oauth_token,oauth_token_secret];
}


//通用的网络请求
-(void)BigWinCar_GetPublicWay:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSString *scheme = [self URLParamsWithModel:mod act:act];
//    NSLog(@"===6===%@",scheme);
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

#pragma mark --- 小组

//小组列表
- (void)BigWinCar_GroupList:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组分类
- (void)BigWinCar_GroupCate:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getGroupCate];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组的创建
- (void)BigWinCar_CreateGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_createGroup];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组详情
- (void)BigWinCar_GetGroupInfo:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getGroupInfo];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组评论
- (void)BigWinCar_getGroupTopList:(NSDictionary *)params
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getGroupTopList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
//小组 话题发布
- (void)BigWinCar_groupAddTopic:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_addTopic];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//加入小组
- (void)BigWinCar_joinGroup:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_joinGroup];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//退出小组
- (void)BigWinCar_quitGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_quitGroup];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//编辑小组
- (void)BigWinCar_editGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_editGroup];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//置顶 精华 锁定 收藏 话题
- (void)BigWinCar_operatTopic:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_operatTopic];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//获取收藏
- (void)BigWinCar_getTopicCollectList:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getCollectList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//删除话题
- (void)BigWinCar_deleteTopic:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_deleteTopic];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//话题回复
- (void)BigWinCar_commentTopic:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_commentTopic];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组成员了列表
- (void)BigWinCar_getGroupMember:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getGroupMember];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//小组成员管理
- (void)BigWinCar_member:(NSDictionary *)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_member];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//解散小组
- (void)BigWinCar_deleteGroup:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_deleteGroup];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//我加入的小组
- (void)BigWinCar_getJoinGroupList:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:BigWinCar_App_Group act:BigWinCar_App_getMyGroupList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}



@end
