//
//  ZhiyiHTTPRequest.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "ZhiyiHTTPRequest.h"
#import "AFNetworking.h"

@implementation ZhiyiHTTPRequest

#define API_ChuYouYun_URL @""

+ (instancetype)manager
{
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:API_ChuYouYun_URL]];
}

- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act
{
    return [API_ChuYouYun_URL stringByAppendingFormat:@"&mod=%@&act=%@",mod,act];
}
#pragma UserToken
- (NSString *)URLParamsWithModel:(NSString *)mod act:(NSString *)act oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret
{
    return [API_ChuYouYun_URL stringByAppendingFormat:@"&mod=%@&act=%@&oauth_token=%@&oauth_token_secret=%@",mod,act,oauth_token,oauth_token_secret];
}

- (void)userLogin:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Login act:API_Mod_Login_login];
    NSLog(@"%@",params);
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
 
- (void)userInfoShow:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_show];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
- (void)userLoginOfThirdParty:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Login act:API_act_login_sync];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
- (void)userTestingPhone:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Login act:API_act_clickPhoneCode];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
- (void)userAttention:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:APi_act_follow_create];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
- (void)cancelUserAttention:(NSDictionary *)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_follow_destroy];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

- (void)userAttentionCrouse:(NSDictionary *)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Video act:API_act_getCollectVideoList ];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)userCollectSpecial:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Album act:API_act_getCollectAlbumsList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
- (void)userCourse:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Video act:API_act_getBuyVideosList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

- (void)userDelCourse:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Video act:API_act_delalbum];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)userSpecial:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Album act:API_act_getBuyAlbumsList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//获得解锁课程
-(void)getClass:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Video act:API_act_getBuyVideosList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


-(void)systemMsg:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Home act:API_act_notify];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)reloadquiz:(NSDictionary *)params
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Home act:API_act_getwentilist];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//我的问答接口
-(void)MYQestion:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_getWenda];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//我的回答
-(void)MYAnsder:(NSDictionary *)params
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_getAnswer];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}



-(void)reloadNoteTitle:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Home act:API_act_getNoteList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//笔记详情
-(void)reloadNoteDetail:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Video act:API_act_noteDetail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//添加笔记
-(void)addNote:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Video act:API_act_addNote];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}




-(void)findPassword:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Login act:API_act_phoneGetPwd];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)findPWDSendCode:(NSDictionary *)params
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Login act:API_act_phoneGetPwd];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
    
}



//手机找回密码  提交
-(void)TJPWDSendCode:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Login act:API_act_savePwd];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
    
}

//邮箱  找回密码
-(void)YXPWDSendCode:(NSDictionary *)params
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Login act:API_act_doFindPasswordByEmail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
    
}


-(void)testingFindPWDCode:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Login act:API_act_clickRepwdCode];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)resetPassword:(NSDictionary *)params
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Login act:API_act_savePwd];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)resetUserPassword:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_doModifyPassword];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)delMyAnswer:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_delWenda];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)userAttentions:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_user_user_following];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)userFans:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_user_followers];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)sendUserFace:(NSDictionary *)params
       constructing:(void (^)(id <AFMultipartFormData> formData))block
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_upload_face];
    [self POST:scheme
    parameters:params
    constructingBodyWithBlock:block
    success:success
       failure:failure];
}
-(void)requestBank:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_card];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)addBankCard:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_saveCard];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
//获取开户的银行类型
-(void)getBankCard:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_addCard];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)sendUserData:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_saveUserInfo];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)findPWDToEmail:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Login act:API_act_doFindPasswordByEmail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)messageTitle:(NSDictionary *)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Message act:API_act_index];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)delMessageTitle:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Message act:API_act_doDelete];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)comMessageChat:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Message act:API_act_detail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)MessageChat:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Message act:API_act_loadMessage];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)sendChat:(NSDictionary *)params
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Message act:API_act_doReply];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)sendToChat:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Message act:API_act_doPost];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)reloadUserbalance:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Home act:API_act_learnc];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)reloadUserDealRecord:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Home act:API_act_account_pay];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)delUserShopingCar:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Video act:API_act_delVideoMerges];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)settleUserShopingCar:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Video act:API_act_buyVideos];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)buyAlbum:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Album act:API_act_buyOperating];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}



-(void)addToShopingCar:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Video act:API_act_addVideoMerge];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)UserShopingCar:(NSDictionary *)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Video act:API_act_merge];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)reloadCommandForMe:(NSDictionary *)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Message act:API_act_comment];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)delCommandForMe:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Message act:API_act_delComsg];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)reloadNewQuesttion:(NSDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_getWendaList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)reloadNewQuesttion1:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_getWendaByCourse];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}




-(void)quizOfAttach:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self POST:API_ChuYouYun_URL
    parameters:params
       success:success
       failure:failure];
}
-(void)sendQuizText:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_postWenda];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)sendQuizImage:(NSDictionary *)params
       constructing:(void (^)(id <AFMultipartFormData> formData))block
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Attach act:API_act_upload];
    [self POST:scheme
    parameters:params
constructingBodyWithBlock:block
       success:success
       failure:failure];
}
-(void)seachQuiz:(NSDictionary *)params
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_strSearch];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)QuizOfHot:(NSDictionary *)params
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_sevendayHot];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)RequestHonour:(NSDictionary *)params
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_wendaCommentDesc];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)reloadTags:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Album act:API_act_getAlbumTag];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)attention:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_follow_create];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)reloadQuizDetail:(NSDictionary *)params
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_detail];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)reloadQuizComand:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_doWendaComment];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)reloadQuizComandDetail:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_wendaComment];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)reloadQuizComandDetailOfCommand:(NSDictionary *)params
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_getSonComment];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)sendOfQuizComandDetailCommand:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_Wenda act:API_act_doSonComment];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}
-(void)reloadUserContent:(NSDictionary *)params
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_userContent];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//获取用户资料
-(void)userShow:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_show];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}




//充值
-(void)topUPUserContent:(NSDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_Mod_User act:API_act_pay];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//发现 资讯 分类

-(void)FXFL:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_News act:API_act_getCate];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//发现  资讯 列表
-(void)FXLB:(NSDictionary *)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_News act:API_act_getList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//发现 资讯 资讯详情
-(void)ZXXQ:(NSDictionary *)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_News act:API_act_getInfo];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

-(void)SYGZX:(NSDictionary *)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_News act:API_act_getList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//考试系统的分类列表
-(void)KSXTFXFL:(NSDictionary *)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_Exam act:API_act_getCategory];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//考试系统的分类列表数据
-(void)KSXTTab:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_Exam act:API_act_getExamList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//考试系统的详情
-(void)KSXTFXXQ:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_Exam act:API_act_getExamInfo];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//考试系统记录详情
-(void)KSXTJLXQ:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_Exam act:API_act_UserExamInfo];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//考试系统时间
-(void)KSXTTime:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_Exam act:API_act_getExamRecodeTime];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//考试系统题型的分类列表
-(void)KSXTTXFL:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_Exam act:API_act_getQuestionTypeList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//考试系统题型的所有数据
-(void)KSXTAll:(NSDictionary *)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_Exam act:API_act_getQuestionInfo];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

//提交试卷
-(void)KSXTTJ:(NSDictionary *)params
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_Exam act:API_act_doUserExam];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//考试完获取详情
-(void)KSXTTJ_Test_Number:(NSDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_Exam act:API_act_UserExamInfo];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


// 发现小组
-(void)getGroup:(NSDictionary *)params
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *scheme = [self URLParamsWithModel:API_act_Group act:API_act_getList];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}


//公用
-(void)getpublicPort:(NSDictionary *)params mod:(NSString *)mod act:(NSString *)act success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{

    NSString *scheme = [self URLParamsWithModel:mod act:act];
    [self GET:scheme
   parameters:params
      success:success
      failure:failure];
}

@end
