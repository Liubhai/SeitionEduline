//
//  NBaseClass.h
//
//  Created by 志强 林 on 15/2/6
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *noteSource;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *noteDescription;
@property (nonatomic, strong) NSString *noteCommentCount;
@property (nonatomic, strong) NSString *isOpen;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *noteVoteCount;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *noteCollectCount;
@property (nonatomic, strong) NSString *noteHelpCount;
@property (nonatomic, strong) NSString *userface;
@property (nonatomic, strong) NSString *noteTitle;
@property (nonatomic, strong) NSString *replyUid;
@property (nonatomic, strong) NSString *qcount;
@property (nonatomic, strong) NSString *strtime;
@property (nonatomic, strong) NSString *pid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
