//
//  MData.m
//
//  Created by 志强 林 on 15/2/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "MData.h"
#import "MLastMessage.h"


NSString *const kMDataLastMessage = @"last_message";
NSString *const kMDataFromUid = @"from_uid";
NSString *const kMDataIsDel = @"is_del";
NSString *const kMDataTitle = @"title";
NSString *const kMDataType = @"type";
NSString *const kMDataMessageNum = @"message_num";
NSString *const kMDataCtime = @"ctime";
NSString *const kMDataMtime = @"mtime";
NSString *const kMDataMemberUid = @"member_uid";
NSString *const kMDataToUserInfo = @"to_user_info";
NSString *const kMDataMemberNum = @"member_num";
NSString *const kMDataNew = @"new";
NSString *const kMDataListId = @"list_id";
NSString *const kMDataListCtime = @"list_ctime";
NSString *const kMDataMinMax = @"min_max";


@interface MData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MData

@synthesize lastMessage = _lastMessage;
@synthesize fromUid = _fromUid;
@synthesize isDel = _isDel;
@synthesize title = _title;
@synthesize type = _type;
@synthesize messageNum = _messageNum;
@synthesize ctime = _ctime;
@synthesize mtime = _mtime;
@synthesize memberUid = _memberUid;
@synthesize toUserInfo = _toUserInfo;
@synthesize memberNum = _memberNum;

@synthesize listId = _listId;
@synthesize listCtime = _listCtime;
@synthesize minMax = _minMax;


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
            self.lastMessage = [MLastMessage modelObjectWithDictionary:[dict objectForKey:kMDataLastMessage]];
            self.fromUid = [self objectOrNilForKey:kMDataFromUid fromDictionary:dict];
            self.isDel = [self objectOrNilForKey:kMDataIsDel fromDictionary:dict];
            self.title = [self objectOrNilForKey:kMDataTitle fromDictionary:dict];
            self.type = [self objectOrNilForKey:kMDataType fromDictionary:dict];
            self.messageNum = [self objectOrNilForKey:kMDataMessageNum fromDictionary:dict];
            self.ctime = [self objectOrNilForKey:kMDataCtime fromDictionary:dict];
            self.mtime = [self objectOrNilForKey:kMDataMtime fromDictionary:dict];
            self.memberUid = [self objectOrNilForKey:kMDataMemberUid fromDictionary:dict];
            self.memberNum = [self objectOrNilForKey:kMDataMemberNum fromDictionary:dict];

            self.listId = [self objectOrNilForKey:kMDataListId fromDictionary:dict];
            self.listCtime = [self objectOrNilForKey:kMDataListCtime fromDictionary:dict];
            self.minMax = [self objectOrNilForKey:kMDataMinMax fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.lastMessage dictionaryRepresentation] forKey:kMDataLastMessage];
    [mutableDict setValue:self.fromUid forKey:kMDataFromUid];
    [mutableDict setValue:self.isDel forKey:kMDataIsDel];
    [mutableDict setValue:self.title forKey:kMDataTitle];
    [mutableDict setValue:self.type forKey:kMDataType];
    [mutableDict setValue:self.messageNum forKey:kMDataMessageNum];
    [mutableDict setValue:self.ctime forKey:kMDataCtime];
    [mutableDict setValue:self.mtime forKey:kMDataMtime];
    [mutableDict setValue:self.memberUid forKey:kMDataMemberUid];
    [mutableDict setValue:self.memberNum forKey:kMDataMemberNum];

    [mutableDict setValue:self.listId forKey:kMDataListId];
    [mutableDict setValue:self.listCtime forKey:kMDataListCtime];
    [mutableDict setValue:self.minMax forKey:kMDataMinMax];

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

    self.lastMessage = [aDecoder decodeObjectForKey:kMDataLastMessage];
    self.fromUid = [aDecoder decodeObjectForKey:kMDataFromUid];
    self.isDel = [aDecoder decodeObjectForKey:kMDataIsDel];
    self.title = [aDecoder decodeObjectForKey:kMDataTitle];
    self.type = [aDecoder decodeObjectForKey:kMDataType];
    self.messageNum = [aDecoder decodeObjectForKey:kMDataMessageNum];
    self.ctime = [aDecoder decodeObjectForKey:kMDataCtime];
    self.mtime = [aDecoder decodeObjectForKey:kMDataMtime];
    self.memberUid = [aDecoder decodeObjectForKey:kMDataMemberUid];
    self.toUserInfo = [aDecoder decodeObjectForKey:kMDataToUserInfo];
    self.memberNum = [aDecoder decodeObjectForKey:kMDataMemberNum];

    self.listId = [aDecoder decodeObjectForKey:kMDataListId];
    self.listCtime = [aDecoder decodeObjectForKey:kMDataListCtime];
    self.minMax = [aDecoder decodeObjectForKey:kMDataMinMax];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_lastMessage forKey:kMDataLastMessage];
    [aCoder encodeObject:_fromUid forKey:kMDataFromUid];
    [aCoder encodeObject:_isDel forKey:kMDataIsDel];
    [aCoder encodeObject:_title forKey:kMDataTitle];
    [aCoder encodeObject:_type forKey:kMDataType];
    [aCoder encodeObject:_messageNum forKey:kMDataMessageNum];
    [aCoder encodeObject:_ctime forKey:kMDataCtime];
    [aCoder encodeObject:_mtime forKey:kMDataMtime];
    [aCoder encodeObject:_memberUid forKey:kMDataMemberUid];
    [aCoder encodeObject:_toUserInfo forKey:kMDataToUserInfo];
    [aCoder encodeObject:_memberNum forKey:kMDataMemberNum];

    [aCoder encodeObject:_listId forKey:kMDataListId];
    [aCoder encodeObject:_listCtime forKey:kMDataListCtime];
    [aCoder encodeObject:_minMax forKey:kMDataMinMax];
}

- (id)copyWithZone:(NSZone *)zone
{
    MData *copy = [[MData alloc] init];
    
    if (copy) {

        copy.lastMessage = [self.lastMessage copyWithZone:zone];
        copy.fromUid = [self.fromUid copyWithZone:zone];
        copy.isDel = [self.isDel copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.messageNum = [self.messageNum copyWithZone:zone];
        copy.ctime = [self.ctime copyWithZone:zone];
        copy.mtime = [self.mtime copyWithZone:zone];
        copy.memberUid = [self.memberUid copyWithZone:zone];
        copy.memberNum = [self.memberNum copyWithZone:zone];

        copy.listId = [self.listId copyWithZone:zone];
        copy.listCtime = [self.listCtime copyWithZone:zone];
        copy.minMax = [self.minMax copyWithZone:zone];
    }
    
    return copy;
}


@end
