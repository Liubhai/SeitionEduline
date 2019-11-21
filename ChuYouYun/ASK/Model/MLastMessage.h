//
//  MLastMessage.h
//
//  Created by 志强 林 on 15/2/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MLastMessage : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *toUid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *isDel;
@property (nonatomic, strong) NSString *mtime;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *listId;
@property (nonatomic, strong) NSString *attachIds;
@property (nonatomic, assign) double fromUid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
