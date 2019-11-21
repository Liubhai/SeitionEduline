//
//  NQWdComment.m
//
//  Created by 志强 林 on 15/2/27
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "NQWdComment.h"


NSString *const kNQWdCommentId = @"id";
NSString *const kNQWdCommentCommentCount = @"comment_count";
NSString *const kNQWdCommentDescription = @"description";
NSString *const kNQWdCommentUid = @"uid";
NSString *const kNQWdCommentParentId = @"parent_id";
NSString *const kNQWdCommentFid = @"fid";
NSString *const kNQWdCommentHelpCount = @"help_count";
NSString *const kNQWdCommentIsDel = @"is_del";
NSString *const kNQWdCommentUname = @"uname";
NSString *const kNQWdCommentCtime = @"ctime";
NSString *const kNQWdCommentWid = @"wid";
NSString *const kNQWdCommentUserface = @"userface";


@interface NQWdComment ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NQWdComment

@synthesize wdCommentIdentifier = _wdCommentIdentifier;
@synthesize commentCount = _commentCount;
@synthesize wdCommentDescription = _wdCommentDescription;
@synthesize uid = _uid;
@synthesize parentId = _parentId;
@synthesize fid = _fid;
@synthesize helpCount = _helpCount;
@synthesize isDel = _isDel;
@synthesize uname = _uname;
@synthesize ctime = _ctime;
@synthesize wid = _wid;
@synthesize userface = _userface;


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
            self.wdCommentIdentifier = [self objectOrNilForKey:kNQWdCommentId fromDictionary:dict];
            self.commentCount = [self objectOrNilForKey:kNQWdCommentCommentCount fromDictionary:dict];
            self.wdCommentDescription = [self objectOrNilForKey:kNQWdCommentDescription fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kNQWdCommentUid fromDictionary:dict];
            self.parentId = [self objectOrNilForKey:kNQWdCommentParentId fromDictionary:dict];
            self.fid = [self objectOrNilForKey:kNQWdCommentFid fromDictionary:dict];
            self.helpCount = [self objectOrNilForKey:kNQWdCommentHelpCount fromDictionary:dict];
            self.isDel = [self objectOrNilForKey:kNQWdCommentIsDel fromDictionary:dict];
            self.uname = [self objectOrNilForKey:kNQWdCommentUname fromDictionary:dict];
            self.ctime = [self objectOrNilForKey:kNQWdCommentCtime fromDictionary:dict];
            self.wid = [self objectOrNilForKey:kNQWdCommentWid fromDictionary:dict];
            self.userface = [self objectOrNilForKey:kNQWdCommentUserface fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.wdCommentIdentifier forKey:kNQWdCommentId];
    [mutableDict setValue:self.commentCount forKey:kNQWdCommentCommentCount];
    [mutableDict setValue:self.wdCommentDescription forKey:kNQWdCommentDescription];
    [mutableDict setValue:self.uid forKey:kNQWdCommentUid];
    [mutableDict setValue:self.parentId forKey:kNQWdCommentParentId];
    [mutableDict setValue:self.fid forKey:kNQWdCommentFid];
    [mutableDict setValue:self.helpCount forKey:kNQWdCommentHelpCount];
    [mutableDict setValue:self.isDel forKey:kNQWdCommentIsDel];
    [mutableDict setValue:self.uname forKey:kNQWdCommentUname];
    [mutableDict setValue:self.ctime forKey:kNQWdCommentCtime];
    [mutableDict setValue:self.wid forKey:kNQWdCommentWid];
    [mutableDict setValue:self.userface forKey:kNQWdCommentUserface];

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

    self.wdCommentIdentifier = [aDecoder decodeObjectForKey:kNQWdCommentId];
    self.commentCount = [aDecoder decodeObjectForKey:kNQWdCommentCommentCount];
    self.wdCommentDescription = [aDecoder decodeObjectForKey:kNQWdCommentDescription];
    self.uid = [aDecoder decodeObjectForKey:kNQWdCommentUid];
    self.parentId = [aDecoder decodeObjectForKey:kNQWdCommentParentId];
    self.fid = [aDecoder decodeObjectForKey:kNQWdCommentFid];
    self.helpCount = [aDecoder decodeObjectForKey:kNQWdCommentHelpCount];
    self.isDel = [aDecoder decodeObjectForKey:kNQWdCommentIsDel];
    self.uname = [aDecoder decodeObjectForKey:kNQWdCommentUname];
    self.ctime = [aDecoder decodeObjectForKey:kNQWdCommentCtime];
    self.wid = [aDecoder decodeObjectForKey:kNQWdCommentWid];
    self.userface = [aDecoder decodeObjectForKey:kNQWdCommentUserface];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_wdCommentIdentifier forKey:kNQWdCommentId];
    [aCoder encodeObject:_commentCount forKey:kNQWdCommentCommentCount];
    [aCoder encodeObject:_wdCommentDescription forKey:kNQWdCommentDescription];
    [aCoder encodeObject:_uid forKey:kNQWdCommentUid];
    [aCoder encodeObject:_parentId forKey:kNQWdCommentParentId];
    [aCoder encodeObject:_fid forKey:kNQWdCommentFid];
    [aCoder encodeObject:_helpCount forKey:kNQWdCommentHelpCount];
    [aCoder encodeObject:_isDel forKey:kNQWdCommentIsDel];
    [aCoder encodeObject:_uname forKey:kNQWdCommentUname];
    [aCoder encodeObject:_ctime forKey:kNQWdCommentCtime];
    [aCoder encodeObject:_wid forKey:kNQWdCommentWid];
    [aCoder encodeObject:_userface forKey:kNQWdCommentUserface];
}

- (id)copyWithZone:(NSZone *)zone
{
    NQWdComment *copy = [[NQWdComment alloc] init];
    
    if (copy) {

        copy.wdCommentIdentifier = [self.wdCommentIdentifier copyWithZone:zone];
        copy.commentCount = [self.commentCount copyWithZone:zone];
        copy.wdCommentDescription = [self.wdCommentDescription copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.parentId = [self.parentId copyWithZone:zone];
        copy.fid = [self.fid copyWithZone:zone];
        copy.helpCount = [self.helpCount copyWithZone:zone];
        copy.isDel = [self.isDel copyWithZone:zone];
        copy.uname = [self.uname copyWithZone:zone];
        copy.ctime = [self.ctime copyWithZone:zone];
        copy.wid = [self.wid copyWithZone:zone];
        copy.userface = [self.userface copyWithZone:zone];
    }
    
    return copy;
}


@end
