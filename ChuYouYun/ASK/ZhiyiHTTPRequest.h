//
//  ZhiyiHTTPRequest.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ZhiyiHTTPRequest : AFHTTPRequestOperationManager

#define uOauth_token @"[[NSUserDefaults standardUserDefaults]objectForKey:@"oauth_token"]"
#define uOauth_token_secret @"[[NSUserDefaults standardUserDefaults]objectForKey:@"oauth_token_secret"]"

#define API_APP_api @"api"

#define API_Mod_Login @"Login"
#define API_Mod_Login_login @"login"

#define API_act_show @"show"

#define API_act_clickPhoneCode @"clickPhoneCode"
#define API_act_login_sync @"login_sync"

#define API_Mod_User @"User"
#define API_act_user_user_following @"user_following"
#define APi_act_follow_create @"follow_create"
#define API_act_follow_destroy @"follow_destroy"
#define API_act_follow_follow_create @"follow_create"
#define API_act_user_followers @"user_followers"

#define API_act_upload_face @"upload_face"
#define API_act_saveUserInfo @"saveUserInfo"

#define API_act_doFindPasswordByEmail @"doFindPasswordByEmail"

#define API_Mod_Video @"Video"

#define API_act_getBuyVideosList @"getBuyVideosList"

#define API_act_getBuyAlbumsList @"getBuyAlbumsList"

#define API_Mod_Album @"Album"



#define API_act_getCollectAlbumsList @"getCollectAlbumsList"

#define API_act_getCollectVideoList @"getCollectVideoList"

#define API_act_delalbum @"delalbum"


#define API_Mod_Home @"Home"
#define API_act_notify @"notify"

#define API_act_getwentilist @"getWentilist"

#define API_act_getWenda @"getWenda"

#define API_act_getAnswer @"getAnswer"

#define API_act_getNoteList @"getNoteList"

#define API_act_noteDetail @"noteDetail"

#define API_act_addNote @"addNote"

#define API_act_phoneGetPwd @"phoneGetPwd"

#define API_act_savePwd @"savePwd"

#define API_act_doFindPasswordByEmail @"doFindPasswordByEmail"

#define API_act_clickRepwdCode @"clickRepwdCode"

#define API_act_doModifyPassword @"doModifyPassword"

#define API_Mod_Wenda @"Wenda"
#define API_act_delWenda @"delWenda"

#define API_act_card @"card"

#define API_act_saveCard @"saveCard"

#define API_act_addCard @"addCard"

#define API_Mod_Message @"Message"
#define API_act_index @"index"

#define API_act_doDelete @"doDelete"

#define API_act_detail @"detail"

#define API_act_loadMessage @"loadMessage"
#define API_act_doReply @"doReply"
#define API_act_doPost @"doPost"

#define API_Mod_Home @"Home"
#define API_act_learnc @"learnc"

#define API_act_account_pay @"account_pay"

#define API_act_delVideoMerges @"delVideoMerges"
#define API_act_buyVideos @"buyVideos"

#define API_act_buyOperating @"buyOperating"

#define API_act_addVideoMerge @"addVideoMerge"

#define API_act_merge @"merge"

#define API_Mod_Message @"Message"
#define API_act_comment @"comment"
#define API_act_delComsg @"delComsg"


#define API_Mod_User @"User"

#define API_Mod_Wenda @"Wenda"
#define API_act_getWendaList @"getWendaList"

#define API_act_getWendaByCourse @"getWendaByCourse"

#define API_Mod_Attach @"Attach"
#define API_act_upload @"upload"

#define API_Mod_Attach @"Attach"
#define API_act_upload @"upload"

#define API_act_postWenda @"postWenda"

#define API_act_strSearch @"strSearch"

#define API_act_sevendayHot @"sevendayHot"

#define API_act_wendaCommentDesc @"wendaCommentDesc"

#define API_act_getAlbumTag @"getAlbumTag"

#define API_act_detail @"detail"

#define API_act_follow_create @"follow_create"

#define API_act_doWendaComment @"doWendaComment"

#define API_act_wendaComment @"wendaComment"

#define API_act_getSonComment @"getSonComment"

#define API_act_doSonComment @"doSonComment"

#define API_act_userContent @"userContent"

#define API_act_show @"show"

#define API_act_pay @"pay"

#define API_act_News @"News"

#define API_act_getCate @"getCate"

#define API_act_getList  @"getList"

#define API_act_getInfo  @"getInfo"

#define API_act_Exam @"Exam"

#define API_act_getCategory @"getCategory"

#define API_act_getExamList @"getExamList"

#define API_act_getExamInfo @"getExamInfo"

#define API_act_UserExamInfo @"UserExamInfo"

#define API_act_getQuestionTypeList @"getQuestionTypeList"

#define API_act_getQuestionInfo @"getQuestionInfo"

#define API_act_doUserExam @"doUserExam"

#define API_act_addAttach @"addAttach"

#define API_act_getExamRecodeTime @"getExamRecodeTime"

#define API_act_Group @"Group"

#define API_act_getList @"getList"




#pragma 登陆
- (void)userLogin:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 第三方登陆
- (void)userLoginOfThirdParty:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 手机验证码验证
- (void)userTestingPhone:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 关注
- (void)userAttention:(NSDictionary *)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 取消关注
- (void)cancelUserAttention:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 用户课程
- (void)userAttentionCrouse:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 收藏专辑
-(void)userCollectSpecial:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 解锁的专辑
-(void)userSpecial:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 解锁的课程
- (void)userCourse:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma 删除我的课程
- (void)userDelCourse:(NSDictionary *)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 系统消息
-(void)systemMsg:(NSDictionary *)params
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 问答
-(void)reloadquiz:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 笔记首页
-(void)reloadNoteTitle:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 上传头像
-(void)sendUserFace:(NSDictionary *)params
       constructing:(void (^)(id <AFMultipartFormData> formData))block
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 修改资料
-(void)sendUserData:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 找回密码验证码发送
-(void)findPWDSendCode:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 验证码验证
-(void)testingFindPWDCode:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 修改密码
-(void)resetPassword:(NSDictionary *)params
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 个人中心修改密码
-(void)resetUserPassword:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 删除我的回答
-(void)delMyAnswer:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 关注列表
-(void)userAttentions:(NSDictionary *)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 粉丝列表
-(void)userFans:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 获取银行卡信息
-(void)requestBank:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 添加银行卡
-(void)addBankCard:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 邮箱找回密码
-(void)findPWDToEmail:(NSDictionary *)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 私信列表
-(void)messageTitle:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 删除私信列表
-(void)delMessageTitle:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 进入私信详情
-(void)comMessageChat:(NSDictionary *)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 获取私信对话列表接口
-(void)MessageChat:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 发送私信
-(void)sendChat:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma "发起私信"
-(void)sendToChat:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 用户余额
-(void)reloadUserbalance:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 交易记录
-(void)reloadUserDealRecord:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 购物车列表
-(void)UserShopingCar:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 购物车结算
-(void)settleUserShopingCar:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 加入购物有车
-(void)addToShopingCar:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 删除购物车
-(void)delUserShopingCar:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 获取评论
-(void)reloadCommandForMe:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 删除收到的评论
-(void)delCommandForMe:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma 问答最新
-(void)reloadNewQuesttion:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 问答附件上传
-(void)quizOfAttach:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 问答文本提交
-(void)sendQuizText:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 提问附件上传
-(void)sendQuizImage:(NSDictionary *)params
        constructing:(void (^)(id <AFMultipartFormData> formData))block
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 一周热门
-(void)QuizOfHot:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 问答排行
-(void)RequestHonour:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 问答标签
-(void)reloadTags:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 问答详情
-(void)reloadQuizDetail:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 关注
-(void)attention:(NSDictionary *)params
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma 评论问答
-(void)reloadQuizComand:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 问答评论详情
-(void)reloadQuizComandDetail:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 二级回复列表
-(void)reloadQuizComandDetailOfCommand:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 二级回复
-(void)sendOfQuizComandDetailCommand:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 用户私有内容
-(void)reloadUserContent:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma 解锁课程
-(void)getClass:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma 获取银行类型
-(void)getBankCard:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma 充值
-(void)topUPUserContent:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//问答待回复
-(void)reloadNewQuesttion1:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//解锁专辑
-(void)buyAlbum:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//用户资料
-(void)userShow:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



//发现 资讯 分类

-(void)FXFL:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//发现  资讯 列表
-(void)FXLB:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//发现 资讯  详情
-(void)ZXXQ:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//手机  找回密码 
-(void)TJPWDSendCode:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//邮箱  找回密码
-(void)YXPWDSendCode:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


-(void)MYQestion:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


-(void)MYAnsder:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


-(void)SYGZX:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


-(void)reloadNoteDetail:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//添加笔记评论
-(void)addNote:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//考试系统分类
-(void)KSXTFXFL:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//考试系统列表
-(void)KSXTTab:(NSDictionary *)params
       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//考试系统详情
-(void)KSXTFXXQ:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//考试系统记录详情
-(void)KSXTJLXQ:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//考试系统题型
-(void)KSXTTXFL:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//获取考试系统题的所有数据
-(void)KSXTAll:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//提交试卷
-(void)KSXTTJ:(NSDictionary *)params
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//考试系统的时间
-(void)KSXTTime:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//考试完获取详情
-(void)KSXTTJ_Test_Number:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




//发现里面 小组列表
-(void)getGroup:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//我的里面 优惠券
//公用
-(void)getpublicPort:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
