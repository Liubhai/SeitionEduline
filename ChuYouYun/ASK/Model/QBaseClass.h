//
//  QBaseClass.h
//
//  Created by 志强 林 on 15/2/6
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface QBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *qcount;
@property (nonatomic, strong) NSString *qstCollectCount;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *qstCommentCount;
@property (nonatomic, strong) NSString *qstDescription;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *qstVoteCount;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *replyUid;
@property (nonatomic, strong) NSString *qstHelpCount;
@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSString *qstTitle;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *strtime;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *qstSource;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
