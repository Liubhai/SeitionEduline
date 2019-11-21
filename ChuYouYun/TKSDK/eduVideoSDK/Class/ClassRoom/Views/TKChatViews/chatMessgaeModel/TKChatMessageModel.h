//
//  TKChatMessageModel.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/12.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
//@import UIKit;
#import <UIKit/UIKit.h>
#import "SYG.h"

@interface TKChatMessageModel : NSObject
@property (nonatomic, strong) NSString *iUserName;
@property (nonatomic, strong) NSString *iTime;
@property (nonatomic, strong) NSString *iMessage;
@property (nonatomic, strong) NSString *iTranslationMessage;
@property (nonatomic, copy)   NSString* iToUid;
@property (nonatomic, copy)   NSString* iFromid;
@property (nonatomic, assign) TKMessageType iMessageType;
@property (nonatomic, strong) UIColor *  iMessageTypeColor;

@property (nonatomic, assign) CGFloat messageHeight;// 消息高度
@property (nonatomic, assign) CGFloat translationHeight;// 翻译高度
@property (nonatomic, assign) CGFloat height;// 行高

- (instancetype)initWithFromid:(NSString *)aFromid aTouid:(NSString *)aTouid iMessageType:(TKMessageType)aMessageType aMessage:(NSString *) aMessage aUserName:(NSString *)aUserName aTime:(NSString*)aTime;



@end
