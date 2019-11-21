//
//  CMBaseClass.h
//
//  Created by 志强 林 on 15/2/14
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMFidinfo, CMUidinfo;

@interface CMBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *appTable;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSDictionary *fidinfo;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *toComment;
@property (nonatomic, strong) NSString *appUid;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSDictionary *uidinfo;
@property (nonatomic, strong) NSString *isDel;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *isRead;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *toCommentId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
