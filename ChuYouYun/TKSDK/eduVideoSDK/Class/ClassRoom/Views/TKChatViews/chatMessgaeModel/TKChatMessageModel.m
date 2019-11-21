//
//  TKChatMessageModel.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/12.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKChatMessageModel.h"


@implementation TKChatMessageModel
- (instancetype)initWithFromid:(NSString *)aFromid aTouid:(NSString*)aTouid iMessageType:(TKMessageType)aMessageType aMessage:(NSString*) aMessage aUserName:(NSString*)aUserName aTime:(NSString*)aTime
{
    if (self = [super init]) {
        
        _iUserName    = aUserName;
        _iToUid       = aTouid;
        _iFromid      = aFromid;
        _iMessageType = aMessageType;
        _iMessage     = aMessage;
        _iTime        = aTime;
//        switch (aMessageType) {
//            case MessageType_Teacher:
//            {
//
//                 _iUserName     = [NSString stringWithFormat:@"%@(%@)",_iUserName,MTLocalized(@"Role.Teacher")];
//                 break;
//            }
//            case MessageType_Me:
//            {
//                _iUserName     = [NSString stringWithFormat:@"%@(%@)",_iUserName,MTLocalized(@"Role.Me")];
//                break;
//            }
//            case MessageType_OtherUer:{
//                _iUserName         = aUserName;
//            }
//            default:{
        
                _iUserName     = aUserName;
//                 break;
//            }
        
//        }
    }
    return self;
}
@end
