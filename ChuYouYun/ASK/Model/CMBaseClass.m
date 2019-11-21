//
//  CMBaseClass.m
//
//  Created by 志强 林 on 15/2/14
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "CMBaseClass.h"



NSString *const kCMBaseClassAppId = @"app_id";
NSString *const kCMBaseClassId = @"id";
NSString *const kCMBaseClassAppTable = @"app_table";
NSString *const kCMBaseClassUid = @"uid";
NSString *const kCMBaseClassFidinfo = @"fidinfo";
NSString *const kCMBaseClassFid = @"fid";
NSString *const kCMBaseClassToComment = @"to_comment";
NSString *const kCMBaseClassAppUid = @"app_uid";
NSString *const kCMBaseClassAppName = @"app_name";
NSString *const kCMBaseClassUidinfo = @"uidinfo";
NSString *const kCMBaseClassIsDel = @"is_del";
NSString *const kCMBaseClassCtime = @"ctime";
NSString *const kCMBaseClassCommentId = @"comment_id";
NSString *const kCMBaseClassIsRead = @"is_read";
NSString *const kCMBaseClassInfo = @"info";
NSString *const kCMBaseClassToCommentId = @"to_comment_id";


@interface CMBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CMBaseClass

@synthesize appId = _appId;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize appTable = _appTable;
@synthesize uid = _uid;
@synthesize fidinfo = _fidinfo;
@synthesize fid = _fid;
@synthesize toComment = _toComment;
@synthesize appUid = _appUid;
@synthesize appName = _appName;
@synthesize uidinfo = _uidinfo;
@synthesize isDel = _isDel;
@synthesize ctime = _ctime;
@synthesize commentId = _commentId;
@synthesize isRead = _isRead;
@synthesize info = _info;
@synthesize toCommentId = _toCommentId;


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
            self.appId = [self objectOrNilForKey:kCMBaseClassAppId fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kCMBaseClassId fromDictionary:dict];
            self.appTable = [self objectOrNilForKey:kCMBaseClassAppTable fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kCMBaseClassUid fromDictionary:dict];
            self.fidinfo = [self objectOrNilForKey:kCMBaseClassFidinfo fromDictionary:dict];
            self.fid = [self objectOrNilForKey:kCMBaseClassFid fromDictionary:dict];
            self.toComment = [self objectOrNilForKey:kCMBaseClassToComment fromDictionary:dict];
            self.appUid = [self objectOrNilForKey:kCMBaseClassAppUid fromDictionary:dict];
            self.appName = [self objectOrNilForKey:kCMBaseClassAppName fromDictionary:dict];
            self.uidinfo = [self objectOrNilForKey:kCMBaseClassUidinfo fromDictionary:dict];
            self.isDel = [self objectOrNilForKey:kCMBaseClassIsDel fromDictionary:dict];
            self.ctime = [self objectOrNilForKey:kCMBaseClassCtime fromDictionary:dict];
            self.commentId = [self objectOrNilForKey:kCMBaseClassCommentId fromDictionary:dict];
            self.isRead = [self objectOrNilForKey:kCMBaseClassIsRead fromDictionary:dict];
            self.info = [self objectOrNilForKey:kCMBaseClassInfo fromDictionary:dict];
            self.toCommentId = [self objectOrNilForKey:kCMBaseClassToCommentId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.appId forKey:kCMBaseClassAppId];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kCMBaseClassId];
    [mutableDict setValue:self.appTable forKey:kCMBaseClassAppTable];
    [mutableDict setValue:self.uid forKey:kCMBaseClassUid];
    [mutableDict setValue:self.fidinfo  forKey:kCMBaseClassFidinfo];
    [mutableDict setValue:self.fid forKey:kCMBaseClassFid];
    [mutableDict setValue:self.toComment forKey:kCMBaseClassToComment];
    [mutableDict setValue:self.appUid forKey:kCMBaseClassAppUid];
    [mutableDict setValue:self.appName forKey:kCMBaseClassAppName];
    [mutableDict setValue:self.uidinfo  forKey:kCMBaseClassUidinfo];
    [mutableDict setValue:self.isDel forKey:kCMBaseClassIsDel];
    [mutableDict setValue:self.ctime forKey:kCMBaseClassCtime];
    [mutableDict setValue:self.commentId forKey:kCMBaseClassCommentId];
    [mutableDict setValue:self.isRead forKey:kCMBaseClassIsRead];
    [mutableDict setValue:self.info forKey:kCMBaseClassInfo];
    [mutableDict setValue:self.toCommentId forKey:kCMBaseClassToCommentId];

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

    self.appId = [aDecoder decodeObjectForKey:kCMBaseClassAppId];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kCMBaseClassId];
    self.appTable = [aDecoder decodeObjectForKey:kCMBaseClassAppTable];
    self.uid = [aDecoder decodeObjectForKey:kCMBaseClassUid];
    self.fidinfo = [aDecoder decodeObjectForKey:kCMBaseClassFidinfo];
    self.fid = [aDecoder decodeObjectForKey:kCMBaseClassFid];
    self.toComment = [aDecoder decodeObjectForKey:kCMBaseClassToComment];
    self.appUid = [aDecoder decodeObjectForKey:kCMBaseClassAppUid];
    self.appName = [aDecoder decodeObjectForKey:kCMBaseClassAppName];
    self.uidinfo = [aDecoder decodeObjectForKey:kCMBaseClassUidinfo];
    self.isDel = [aDecoder decodeObjectForKey:kCMBaseClassIsDel];
    self.ctime = [aDecoder decodeObjectForKey:kCMBaseClassCtime];
    self.commentId = [aDecoder decodeObjectForKey:kCMBaseClassCommentId];
    self.isRead = [aDecoder decodeObjectForKey:kCMBaseClassIsRead];
    self.info = [aDecoder decodeObjectForKey:kCMBaseClassInfo];
    self.toCommentId = [aDecoder decodeObjectForKey:kCMBaseClassToCommentId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_appId forKey:kCMBaseClassAppId];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kCMBaseClassId];
    [aCoder encodeObject:_appTable forKey:kCMBaseClassAppTable];
    [aCoder encodeObject:_uid forKey:kCMBaseClassUid];
    [aCoder encodeObject:_fidinfo forKey:kCMBaseClassFidinfo];
    [aCoder encodeObject:_fid forKey:kCMBaseClassFid];
    [aCoder encodeObject:_toComment forKey:kCMBaseClassToComment];
    [aCoder encodeObject:_appUid forKey:kCMBaseClassAppUid];
    [aCoder encodeObject:_appName forKey:kCMBaseClassAppName];
    [aCoder encodeObject:_uidinfo forKey:kCMBaseClassUidinfo];
    [aCoder encodeObject:_isDel forKey:kCMBaseClassIsDel];
    [aCoder encodeObject:_ctime forKey:kCMBaseClassCtime];
    [aCoder encodeObject:_commentId forKey:kCMBaseClassCommentId];
    [aCoder encodeObject:_isRead forKey:kCMBaseClassIsRead];
    [aCoder encodeObject:_info forKey:kCMBaseClassInfo];
    [aCoder encodeObject:_toCommentId forKey:kCMBaseClassToCommentId];
}

- (id)copyWithZone:(NSZone *)zone
{
    CMBaseClass *copy = [[CMBaseClass alloc] init];
    
    if (copy) {

        copy.appId = [self.appId copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.appTable = [self.appTable copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.fidinfo = [self.fidinfo copyWithZone:zone];
        copy.fid = [self.fid copyWithZone:zone];
        copy.toComment = [self.toComment copyWithZone:zone];
        copy.appUid = [self.appUid copyWithZone:zone];
        copy.appName = [self.appName copyWithZone:zone];
        copy.uidinfo = [self.uidinfo copyWithZone:zone];
        copy.isDel = [self.isDel copyWithZone:zone];
        copy.ctime = [self.ctime copyWithZone:zone];
        copy.commentId = [self.commentId copyWithZone:zone];
        copy.isRead = [self.isRead copyWithZone:zone];
        copy.info = [self.info copyWithZone:zone];
        copy.toCommentId = [self.toCommentId copyWithZone:zone];
    }
    
    return copy;
}


@end
