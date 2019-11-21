//
//  MLastMessage.m
//
//  Created by 志强 林 on 15/2/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "MLastMessage.h"



NSString *const kMLastMessageToUid = @"to_uid";
NSString *const kMLastMessageContent = @"content";
NSString *const kMLastMessageIsDel = @"is_del";
NSString *const kMLastMessageMtime = @"mtime";
NSString *const kMLastMessageUserInfo = @"user_info";
NSString *const kMLastMessageMessageId = @"message_id";
NSString *const kMLastMessageListId = @"list_id";
NSString *const kMLastMessageAttachIds = @"attach_ids";
NSString *const kMLastMessageFromUid = @"from_uid";


@interface MLastMessage ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MLastMessage

@synthesize toUid = _toUid;
@synthesize content = _content;
@synthesize isDel = _isDel;
@synthesize mtime = _mtime;
@synthesize userInfo = _userInfo;
@synthesize messageId = _messageId;
@synthesize listId = _listId;
@synthesize attachIds = _attachIds;
@synthesize fromUid = _fromUid;


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
            self.toUid = [self objectOrNilForKey:kMLastMessageToUid fromDictionary:dict];
            self.content = [self objectOrNilForKey:kMLastMessageContent fromDictionary:dict];
            self.isDel = [self objectOrNilForKey:kMLastMessageIsDel fromDictionary:dict];
            self.mtime = [self objectOrNilForKey:kMLastMessageMtime fromDictionary:dict];
            self.userInfo = [self objectOrNilForKey:kMLastMessageUserInfo fromDictionary:dict];
            self.messageId = [self objectOrNilForKey:kMLastMessageMessageId fromDictionary:dict];
            self.listId = [self objectOrNilForKey:kMLastMessageListId fromDictionary:dict];
            self.attachIds = [self objectOrNilForKey:kMLastMessageAttachIds fromDictionary:dict];
            self.fromUid = [[self objectOrNilForKey:kMLastMessageFromUid fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForToUid = [NSMutableArray array];
    for (NSObject *subArrayObject in self.toUid) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForToUid addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForToUid addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForToUid] forKey:kMLastMessageToUid];
    [mutableDict setValue:self.content forKey:kMLastMessageContent];
    [mutableDict setValue:self.isDel forKey:kMLastMessageIsDel];
    [mutableDict setValue:self.mtime forKey:kMLastMessageMtime];
    [mutableDict setValue:self.userInfo forKey:kMLastMessageUserInfo];
    [mutableDict setValue:self.messageId forKey:kMLastMessageMessageId];
    [mutableDict setValue:self.listId forKey:kMLastMessageListId];
    [mutableDict setValue:self.attachIds forKey:kMLastMessageAttachIds];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fromUid] forKey:kMLastMessageFromUid];

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

    self.toUid = [aDecoder decodeObjectForKey:kMLastMessageToUid];
    self.content = [aDecoder decodeObjectForKey:kMLastMessageContent];
    self.isDel = [aDecoder decodeObjectForKey:kMLastMessageIsDel];
    self.mtime = [aDecoder decodeObjectForKey:kMLastMessageMtime];
    self.userInfo = [aDecoder decodeObjectForKey:kMLastMessageUserInfo];
    self.messageId = [aDecoder decodeObjectForKey:kMLastMessageMessageId];
    self.listId = [aDecoder decodeObjectForKey:kMLastMessageListId];
    self.attachIds = [aDecoder decodeObjectForKey:kMLastMessageAttachIds];
    self.fromUid = [aDecoder decodeDoubleForKey:kMLastMessageFromUid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_toUid forKey:kMLastMessageToUid];
    [aCoder encodeObject:_content forKey:kMLastMessageContent];
    [aCoder encodeObject:_isDel forKey:kMLastMessageIsDel];
    [aCoder encodeObject:_mtime forKey:kMLastMessageMtime];
    [aCoder encodeObject:_userInfo forKey:kMLastMessageUserInfo];
    [aCoder encodeObject:_messageId forKey:kMLastMessageMessageId];
    [aCoder encodeObject:_listId forKey:kMLastMessageListId];
    [aCoder encodeObject:_attachIds forKey:kMLastMessageAttachIds];
    [aCoder encodeDouble:_fromUid forKey:kMLastMessageFromUid];
}

- (id)copyWithZone:(NSZone *)zone
{
    MLastMessage *copy = [[MLastMessage alloc] init];
    
    if (copy) {

        copy.toUid = [self.toUid copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.isDel = [self.isDel copyWithZone:zone];
        copy.mtime = [self.mtime copyWithZone:zone];
        copy.userInfo = [self.userInfo copyWithZone:zone];
        copy.messageId = [self.messageId copyWithZone:zone];
        copy.listId = [self.listId copyWithZone:zone];
        copy.attachIds = [self.attachIds copyWithZone:zone];
        copy.fromUid = self.fromUid;
    }
    
    return copy;
}


@end
