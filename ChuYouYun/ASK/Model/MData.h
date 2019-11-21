//
//  MData.h
//
//  Created by 志强 林 on 15/2/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLastMessage, MToUserInfo;

@interface MData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) MLastMessage *lastMessage;
@property (nonatomic, strong) NSString *fromUid;
@property (nonatomic, strong) NSString *isDel;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *messageNum;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *mtime;
@property (nonatomic, strong) NSString *memberUid;
@property (nonatomic, strong) NSDictionary *toUserInfo;
#pragma !!!!!!!!!!!!new!!!!!!!!!!!!!!
@property (nonatomic, strong) NSString *memberNum;
@property (nonatomic, strong) NSString *listId;
@property (nonatomic, strong) NSString *listCtime;
@property (nonatomic, strong) NSString *minMax;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
