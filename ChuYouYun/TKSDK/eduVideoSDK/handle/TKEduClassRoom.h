//
//  TKEduClassRoom.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//  Version: 2.1.0
//

#import <Foundation/Foundation.h>
#import "TKRoomJsonModel.h"
#import <UIKit/UIKit.h>


#pragma mark TKEduEnterClassRoomDelegate
@protocol TKEduRoomDelegate <NSObject>
@optional


/**
 进入房间失败
 
 @param result 错误码 详情看TKRoomErrorCode结构体
 
 @param desc 失败的原因描述
 */
- (void) onEnterRoomFailed:(int)result Description:(NSString*)desc;

/**
 被踢回调

 @param reason 0:被老师踢出（暂时无） 1：重复登录
 */
- (void) onKitout:(EKickOutReason)reason;

/**
 进入课堂成功后的回调
 */
- (void) joinRoomComplete;

/**
 离开课堂成功后的回调
 */
- (void) leftRoomComplete;

/**
 课堂开始的回调
 */
- (void) onClassBegin;

/**
 课堂结束的回调
 */
- (void) onClassDismiss;

/**
 摄像头打开失败回调
 */
- (void) onCameraDidOpenError;

@end


@interface TKEduClassRoom : NSObject

@property (nonatomic, readonly) BOOL enterClassRoomAgain;
    
/**
 checkRoom 成功后赋值
 */
@property (nonatomic, strong)TKRoomJsonModel *roomJson;

+(instancetype)shareInstance;

/**
 进入房间的函数

 @param paramDic NSDictionary类型，键值需要传递serial（课堂号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）、uiserid(用户ID，可选)、password(密码)、clientType(客户端类型）
 @param controller 当前页面的控制器，通常与下边delegate相同
 @param delegate 遵循TKEduEnterClassRoomDelegate代理，供给用户进行处理
 @param isFromWeb 是否是从网址链接进入进入
 @return 是否成功 0 成功 其他失败
 */
- (int)joinRoomWithParamDic:(NSDictionary*)paramDic
           ViewController:(UIViewController*)controller
                 Delegate:(id<TKEduRoomDelegate>)delegate
                 isFromWeb:(BOOL)isFromWeb;

/**
 进入回放房间的函数
 
 @param paramDic NSDictionary类型，键值需要传递serial（课堂号）、host（服务器地址）、port（服务器端口号）、nickname（用户昵称）、uiserid(用户ID，可选)、password(密码)、clientType(客户端类型）
 @param controller 当前页面的控制器，通常与下边delegate相同
 @param delegate 遵循TKEduEnterClassRoomDelegate代理，供给用户进行处理
 @param isFromWeb 是否是从网址链接进入进入
 @return 是否成功 0 成功 其他失败
 */
- (int)joinPlaybackRoomWithParamDic:(NSDictionary *)paramDic
                     ViewController:(UIViewController*)controller
                           Delegate:(id<TKEduRoomDelegate>)delegate
                          isFromWeb:(BOOL)isFromWeb;

/**
 从网页链接进入教室

 @param url 网页url
 */
- (void)joinRoomWithUrl:(NSString*)url;

@end
