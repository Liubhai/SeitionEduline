//
//  NQData.m
//
//  Created by 志强 林 on 15/2/27
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "NQData.h"
#import "NQTags.h"
#import "NQWdComment.h"


NSString *const kNQDataId = @"id";
NSString *const kNQDataWdDescription = @"wd_description";
NSString *const kNQDataUid = @"uid";
NSString *const kNQDataRecommend = @"recommend";
NSString *const kNQDataTagId = @"tag_id";
NSString *const kNQDataWdHelpCount = @"wd_help_count";
NSString *const kNQDataIsDel = @"is_del";
NSString *const kNQDataUname = @"uname";
NSString *const kNQDataType = @"type";
NSString *const kNQDataTags = @"tags";
NSString *const kNQDataCtime = @"ctime";
NSString *const kNQDataUserface = @"userface";
NSString *const kNQDataWdComment = @"wd_comment";
NSString *const kNQDataWdCommentCount = @"wd_comment_count";
NSString *const kNQDataWdBrowseCount = @"wd_browse_count";
NSString *const kNQDataWdTitle = @"wd_title";


@interface NQData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NQData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize wdDescription = _wdDescription;
@synthesize uid = _uid;
@synthesize recommend = _recommend;
@synthesize tagId = _tagId;
@synthesize wdHelpCount = _wdHelpCount;
@synthesize isDel = _isDel;
@synthesize uname = _uname;
@synthesize type = _type;
@synthesize tags = _tags;
@synthesize ctime = _ctime;
@synthesize userface = _userface;
@synthesize wdComment = _wdComment;
@synthesize wdCommentCount = _wdCommentCount;
@synthesize wdBrowseCount = _wdBrowseCount;
@synthesize wdTitle = _wdTitle;


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
            self.dataIdentifier = [self objectOrNilForKey:kNQDataId fromDictionary:dict];
            self.wdDescription = [self objectOrNilForKey:kNQDataWdDescription fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kNQDataUid fromDictionary:dict];
            self.recommend = [self objectOrNilForKey:kNQDataRecommend fromDictionary:dict];
            self.tagId = [self objectOrNilForKey:kNQDataTagId fromDictionary:dict];
            self.wdHelpCount = [self objectOrNilForKey:kNQDataWdHelpCount fromDictionary:dict];
            self.isDel = [self objectOrNilForKey:kNQDataIsDel fromDictionary:dict];
            self.uname = [self objectOrNilForKey:kNQDataUname fromDictionary:dict];
            self.type = [self objectOrNilForKey:kNQDataType fromDictionary:dict];
    NSObject *receivedNQTags = [dict objectForKey:kNQDataTags];
    NSMutableArray *parsedNQTags = [NSMutableArray array];
    if ([receivedNQTags isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedNQTags) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedNQTags addObject:[NQTags modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedNQTags isKindOfClass:[NSDictionary class]]) {
       [parsedNQTags addObject:[NQTags modelObjectWithDictionary:(NSDictionary *)receivedNQTags]];
    }

    self.tags = [NSArray arrayWithArray:parsedNQTags];
            self.ctime = [self objectOrNilForKey:kNQDataCtime fromDictionary:dict];
            self.userface = [self objectOrNilForKey:kNQDataUserface fromDictionary:dict];
            self.wdComment = [NQWdComment modelObjectWithDictionary:[dict objectForKey:kNQDataWdComment]];
            self.wdCommentCount = [self objectOrNilForKey:kNQDataWdCommentCount fromDictionary:dict];
            self.wdBrowseCount = [self objectOrNilForKey:kNQDataWdBrowseCount fromDictionary:dict];
            self.wdTitle = [self objectOrNilForKey:kNQDataWdTitle fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dataIdentifier forKey:kNQDataId];
    [mutableDict setValue:self.wdDescription forKey:kNQDataWdDescription];
    [mutableDict setValue:self.uid forKey:kNQDataUid];
    [mutableDict setValue:self.recommend forKey:kNQDataRecommend];
    [mutableDict setValue:self.tagId forKey:kNQDataTagId];
    [mutableDict setValue:self.wdHelpCount forKey:kNQDataWdHelpCount];
    [mutableDict setValue:self.isDel forKey:kNQDataIsDel];
    [mutableDict setValue:self.uname forKey:kNQDataUname];
    [mutableDict setValue:self.type forKey:kNQDataType];
    NSMutableArray *tempArrayForTags = [NSMutableArray array];
    for (NSObject *subArrayObject in self.tags) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTags addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTags addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTags] forKey:kNQDataTags];
    [mutableDict setValue:self.ctime forKey:kNQDataCtime];
    [mutableDict setValue:self.userface forKey:kNQDataUserface];
    [mutableDict setValue:[self.wdComment dictionaryRepresentation] forKey:kNQDataWdComment];
    [mutableDict setValue:self.wdCommentCount forKey:kNQDataWdCommentCount];
    [mutableDict setValue:self.wdBrowseCount forKey:kNQDataWdBrowseCount];
    [mutableDict setValue:self.wdTitle forKey:kNQDataWdTitle];

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

    self.dataIdentifier = [aDecoder decodeObjectForKey:kNQDataId];
    self.wdDescription = [aDecoder decodeObjectForKey:kNQDataWdDescription];
    self.uid = [aDecoder decodeObjectForKey:kNQDataUid];
    self.recommend = [aDecoder decodeObjectForKey:kNQDataRecommend];
    self.tagId = [aDecoder decodeObjectForKey:kNQDataTagId];
    self.wdHelpCount = [aDecoder decodeObjectForKey:kNQDataWdHelpCount];
    self.isDel = [aDecoder decodeObjectForKey:kNQDataIsDel];
    self.uname = [aDecoder decodeObjectForKey:kNQDataUname];
    self.type = [aDecoder decodeObjectForKey:kNQDataType];
    self.tags = [aDecoder decodeObjectForKey:kNQDataTags];
    self.ctime = [aDecoder decodeObjectForKey:kNQDataCtime];
    self.userface = [aDecoder decodeObjectForKey:kNQDataUserface];
    self.wdComment = [aDecoder decodeObjectForKey:kNQDataWdComment];
    self.wdCommentCount = [aDecoder decodeObjectForKey:kNQDataWdCommentCount];
    self.wdBrowseCount = [aDecoder decodeObjectForKey:kNQDataWdBrowseCount];
    self.wdTitle = [aDecoder decodeObjectForKey:kNQDataWdTitle];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dataIdentifier forKey:kNQDataId];
    [aCoder encodeObject:_wdDescription forKey:kNQDataWdDescription];
    [aCoder encodeObject:_uid forKey:kNQDataUid];
    [aCoder encodeObject:_recommend forKey:kNQDataRecommend];
    [aCoder encodeObject:_tagId forKey:kNQDataTagId];
    [aCoder encodeObject:_wdHelpCount forKey:kNQDataWdHelpCount];
    [aCoder encodeObject:_isDel forKey:kNQDataIsDel];
    [aCoder encodeObject:_uname forKey:kNQDataUname];
    [aCoder encodeObject:_type forKey:kNQDataType];
    [aCoder encodeObject:_tags forKey:kNQDataTags];
    [aCoder encodeObject:_ctime forKey:kNQDataCtime];
    [aCoder encodeObject:_userface forKey:kNQDataUserface];
    [aCoder encodeObject:_wdComment forKey:kNQDataWdComment];
    [aCoder encodeObject:_wdCommentCount forKey:kNQDataWdCommentCount];
    [aCoder encodeObject:_wdBrowseCount forKey:kNQDataWdBrowseCount];
    [aCoder encodeObject:_wdTitle forKey:kNQDataWdTitle];
}

- (id)copyWithZone:(NSZone *)zone
{
    NQData *copy = [[NQData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.wdDescription = [self.wdDescription copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.recommend = [self.recommend copyWithZone:zone];
        copy.tagId = [self.tagId copyWithZone:zone];
        copy.wdHelpCount = [self.wdHelpCount copyWithZone:zone];
        copy.isDel = [self.isDel copyWithZone:zone];
        copy.uname = [self.uname copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.tags = [self.tags copyWithZone:zone];
        copy.ctime = [self.ctime copyWithZone:zone];
        copy.userface = [self.userface copyWithZone:zone];
        copy.wdComment = [self.wdComment copyWithZone:zone];
        copy.wdCommentCount = [self.wdCommentCount copyWithZone:zone];
        copy.wdBrowseCount = [self.wdBrowseCount copyWithZone:zone];
        copy.wdTitle = [self.wdTitle copyWithZone:zone];
    }
    
    return copy;
}


@end
