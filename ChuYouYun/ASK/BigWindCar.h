//
//  BigWindCar.h
//  dafengche
//
//  Created by 智艺创想 on 16/10/25.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface BigWindCar : AFHTTPRequestOperationManager

//小组
#define BigWinCar_App_Group @"Group"
#define BigWinCar_App_getList @"getList"
#define BigWinCar_App_getGroupCate @"getGroupCate"
#define BigWinCar_App_createGroup @"createGroup"
#define BigWinCar_App_getGroupInfo @"getGroupInfo"
#define BigWinCar_App_getGroupTopList @"getGroupTopList"
#define BigWinCar_App_addTopic @"addTopic"
#define BigWinCar_App_joinGroup @"joinGroup"
#define BigWinCar_App_quitGroup @"quitGroup"
#define BigWinCar_App_operatTopic @"operatTopic"
#define BigWinCar_App_getCollectList @"getCollectList"
#define BigWinCar_App_deleteTopic @"deleteTopic"
#define BigWinCar_App_editGroup @"editGroup"
#define BigWinCar_App_getGroupMember @"getGroupMember"
#define BigWinCar_App_member @"member"
#define BigWinCar_App_deleteGroup @"deleteGroup"
#define BigWinCar_App_commentTopic @"commentTopic"
#define BigWinCar_App_getJoinGroupList @"getJoinGroupList"
#define BigWinCar_App_getMyGroupList @"getMyGroupList"



#pragma mark --- 通用网络请求
-(void)BigWinCar_GetPublicWay:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 首页



#pragma mark --- 课程


#pragma mark --- 小组

//小组列表
- (void)BigWinCar_GroupList:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组的分类
- (void)BigWinCar_GroupCate:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组的创建
- (void)BigWinCar_CreateGroup:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//小组详情
- (void)BigWinCar_GetGroupInfo:(NSDictionary *)params
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组话题列表
- (void)BigWinCar_getGroupTopList:(NSDictionary *)params
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组 话题发布
- (void)BigWinCar_groupAddTopic:(NSDictionary *)params
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//加入小组
- (void)BigWinCar_joinGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//退出小组
- (void)BigWinCar_quitGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//置顶 精华 锁定 收藏 话题
- (void)BigWinCar_operatTopic:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取收藏
- (void)BigWinCar_getTopicCollectList:(NSDictionary *)params
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//删除话题
- (void)BigWinCar_deleteTopic:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//编辑小组
- (void)BigWinCar_editGroup:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组成员管理
- (void)BigWinCar_member:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//小组成员了列表
- (void)BigWinCar_getGroupMember:(NSDictionary *)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//解散小组
- (void)BigWinCar_deleteGroup:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//话题回复
- (void)BigWinCar_commentTopic:(NSDictionary *)params
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//我加入的小组
- (void)BigWinCar_getJoinGroupList:(NSDictionary *)params
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark --- 订单





@end
