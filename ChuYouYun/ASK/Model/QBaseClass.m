//
//  QBaseClass.m
//
//  Created by 志强 林 on 15/2/6
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "QBaseClass.h"


NSString *const kQBaseClassId = @"id";
NSString *const kQBaseClassQcount = @"qcount";
NSString *const kQBaseClassQstCollectCount = @"qst_collect_count";
NSString *const kQBaseClassUid = @"uid";
NSString *const kQBaseClassQstCommentCount = @"qst_comment_count";
NSString *const kQBaseClassQstDescription = @"qst_description";
NSString *const kQBaseClassParentId = @"parent_id";
NSString *const kQBaseClassQstVoteCount = @"qst_vote_count";
NSString *const kQBaseClassType = @"type";
NSString *const kQBaseClassReplyUid = @"reply_uid";
NSString *const kQBaseClassQstHelpCount = @"qst_help_count";
NSString *const kQBaseClassOid = @"oid";
NSString *const kQBaseClassQstTitle = @"qst_title";
NSString *const kQBaseClassCtime = @"ctime";
NSString *const kQBaseClassStrtime = @"strtime";
NSString *const kQBaseClassPid = @"pid";
NSString *const kQBaseClassQstSource = @"qst_source";


@interface QBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation QBaseClass

@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize qcount = _qcount;
@synthesize qstCollectCount = _qstCollectCount;
@synthesize uid = _uid;
@synthesize qstCommentCount = _qstCommentCount;
@synthesize qstDescription = _qstDescription;
@synthesize parentId = _parentId;
@synthesize qstVoteCount = _qstVoteCount;
@synthesize type = _type;
@synthesize replyUid = _replyUid;
@synthesize qstHelpCount = _qstHelpCount;
@synthesize oid = _oid;
@synthesize qstTitle = _qstTitle;
@synthesize ctime = _ctime;
@synthesize strtime = _strtime;
@synthesize pid = _pid;
@synthesize qstSource = _qstSource;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kQBaseClassId fromDictionary:dict];
            self.qcount = [self objectOrNilForKey:kQBaseClassQcount fromDictionary:dict];
            self.qstCollectCount = [self objectOrNilForKey:kQBaseClassQstCollectCount fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kQBaseClassUid fromDictionary:dict];
            self.qstCommentCount = [self objectOrNilForKey:kQBaseClassQstCommentCount fromDictionary:dict];
            self.qstDescription = [self objectOrNilForKey:kQBaseClassQstDescription fromDictionary:dict];
            self.parentId = [self objectOrNilForKey:kQBaseClassParentId fromDictionary:dict];
            self.qstVoteCount = [self objectOrNilForKey:kQBaseClassQstVoteCount fromDictionary:dict];
            self.type = [self objectOrNilForKey:kQBaseClassType fromDictionary:dict];
            self.replyUid = [self objectOrNilForKey:kQBaseClassReplyUid fromDictionary:dict];
            self.qstHelpCount = [self objectOrNilForKey:kQBaseClassQstHelpCount fromDictionary:dict];
            self.oid = [self objectOrNilForKey:kQBaseClassOid fromDictionary:dict];
            self.qstTitle = [self objectOrNilForKey:kQBaseClassQstTitle fromDictionary:dict];
            self.ctime = [self objectOrNilForKey:kQBaseClassCtime fromDictionary:dict];
            self.strtime = [self objectOrNilForKey:kQBaseClassStrtime fromDictionary:dict];
            self.pid = [self objectOrNilForKey:kQBaseClassPid fromDictionary:dict];
            self.qstSource = [self objectOrNilForKey:kQBaseClassQstSource fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kQBaseClassId];
    [mutableDict setValue:self.qcount forKey:kQBaseClassQcount];
    [mutableDict setValue:self.qstCollectCount forKey:kQBaseClassQstCollectCount];
    [mutableDict setValue:self.uid forKey:kQBaseClassUid];
    [mutableDict setValue:self.qstCommentCount forKey:kQBaseClassQstCommentCount];
    [mutableDict setValue:self.qstDescription forKey:kQBaseClassQstDescription];
    [mutableDict setValue:self.parentId forKey:kQBaseClassParentId];
    [mutableDict setValue:self.qstVoteCount forKey:kQBaseClassQstVoteCount];
    [mutableDict setValue:self.type forKey:kQBaseClassType];
    [mutableDict setValue:self.replyUid forKey:kQBaseClassReplyUid];
    [mutableDict setValue:self.qstHelpCount forKey:kQBaseClassQstHelpCount];
    [mutableDict setValue:self.oid forKey:kQBaseClassOid];
    [mutableDict setValue:self.qstTitle forKey:kQBaseClassQstTitle];
    [mutableDict setValue:self.ctime forKey:kQBaseClassCtime];
    [mutableDict setValue:self.strtime forKey:kQBaseClassStrtime];
    [mutableDict setValue:self.pid forKey:kQBaseClassPid];
    [mutableDict setValue:self.qstSource forKey:kQBaseClassQstSource];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kQBaseClassId];
    self.qcount = [aDecoder decodeObjectForKey:kQBaseClassQcount];
    self.qstCollectCount = [aDecoder decodeObjectForKey:kQBaseClassQstCollectCount];
    self.uid = [aDecoder decodeObjectForKey:kQBaseClassUid];
    self.qstCommentCount = [aDecoder decodeObjectForKey:kQBaseClassQstCommentCount];
    self.qstDescription = [aDecoder decodeObjectForKey:kQBaseClassQstDescription];
    self.parentId = [aDecoder decodeObjectForKey:kQBaseClassParentId];
    self.qstVoteCount = [aDecoder decodeObjectForKey:kQBaseClassQstVoteCount];
    self.type = [aDecoder decodeObjectForKey:kQBaseClassType];
    self.replyUid = [aDecoder decodeObjectForKey:kQBaseClassReplyUid];
    self.qstHelpCount = [aDecoder decodeObjectForKey:kQBaseClassQstHelpCount];
    self.oid = [aDecoder decodeObjectForKey:kQBaseClassOid];
    self.qstTitle = [aDecoder decodeObjectForKey:kQBaseClassQstTitle];
    self.ctime = [aDecoder decodeObjectForKey:kQBaseClassCtime];
    self.strtime = [aDecoder decodeObjectForKey:kQBaseClassStrtime];
    self.pid = [aDecoder decodeObjectForKey:kQBaseClassPid];
    self.qstSource = [aDecoder decodeObjectForKey:kQBaseClassQstSource];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kQBaseClassId];
    [aCoder encodeObject:_qcount forKey:kQBaseClassQcount];
    [aCoder encodeObject:_qstCollectCount forKey:kQBaseClassQstCollectCount];
    [aCoder encodeObject:_uid forKey:kQBaseClassUid];
    [aCoder encodeObject:_qstCommentCount forKey:kQBaseClassQstCommentCount];
    [aCoder encodeObject:_qstDescription forKey:kQBaseClassQstDescription];
    [aCoder encodeObject:_parentId forKey:kQBaseClassParentId];
    [aCoder encodeObject:_qstVoteCount forKey:kQBaseClassQstVoteCount];
    [aCoder encodeObject:_type forKey:kQBaseClassType];
    [aCoder encodeObject:_replyUid forKey:kQBaseClassReplyUid];
    [aCoder encodeObject:_qstHelpCount forKey:kQBaseClassQstHelpCount];
    [aCoder encodeObject:_oid forKey:kQBaseClassOid];
    [aCoder encodeObject:_qstTitle forKey:kQBaseClassQstTitle];
    [aCoder encodeObject:_ctime forKey:kQBaseClassCtime];
    [aCoder encodeObject:_strtime forKey:kQBaseClassStrtime];
    [aCoder encodeObject:_pid forKey:kQBaseClassPid];
    [aCoder encodeObject:_qstSource forKey:kQBaseClassQstSource];
}

- (id)copyWithZone:(NSZone *)zone
{
    QBaseClass *copy = [[QBaseClass alloc] init];
    
    if (copy) {

        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.qcount = [self.qcount copyWithZone:zone];
        copy.qstCollectCount = [self.qstCollectCount copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.qstCommentCount = [self.qstCommentCount copyWithZone:zone];
        copy.qstDescription = [self.qstDescription copyWithZone:zone];
        copy.parentId = [self.parentId copyWithZone:zone];
        copy.qstVoteCount = [self.qstVoteCount copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.replyUid = [self.replyUid copyWithZone:zone];
        copy.qstHelpCount = [self.qstHelpCount copyWithZone:zone];
        copy.oid = [self.oid copyWithZone:zone];
        copy.qstTitle = [self.qstTitle copyWithZone:zone];
        copy.ctime = [self.ctime copyWithZone:zone];
        copy.strtime = [self.strtime copyWithZone:zone];
        copy.pid = [self.pid copyWithZone:zone];
        copy.qstSource = [self.qstSource copyWithZone:zone];
    }
    
    return copy;
}


@end
