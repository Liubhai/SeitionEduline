//
//  Dialog.h
//  CCLivePlayDemo
//
//  Created by cc-mac on 16/2/15.
//  Copyright © 2016年 ma yige. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NSContentType) {
    NS_CONTENT_TYPE_CHAT,//默认从0开始
    NS_CONTENT_TYPE_QA_QUESTION,
    NS_CONTENT_TYPE_QA_ANSWER,
};

@interface Dialog : NSObject

/**
 *  对话数组
 *  time      NSInteger 对话时间
 *  content   NSString  内容
 *  username  NSString  用户名
 *  viewerId  NSString  观看者ID
 *  dataType  NSString  (@"1" 自己,@"2" 别人)
 */

/**
 *  问答数组
 *  time      NSInteger 对话时间
 *  content   NSString  内容
 *  username  NSString  用户名
 *  encryptId NSString  问答ID
 *  dataType  NSString  (@"1" 提问,@"2" 回答)
 */

@property(nonatomic,strong) NSString        *content;
@property(nonatomic,strong) NSString        *username;
@property(nonatomic,strong) NSString        *viewerId;
@property(nonatomic,strong) NSString        *encryptId;
@property(nonatomic,assign) BOOL            isPublicChat;
@property(nonatomic,strong) NSString        *avatar;

@property(nonatomic,assign) NSContentType   dataType;

@end
