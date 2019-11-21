//
//  SMBaseClass.m
//
//  Created by 志强 林 on 15/2/5
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "SMBaseClass.h"


NSString *const kSMBaseClassIsRead = @"is_read";
NSString *const kSMBaseClassUid = @"uid";
NSString *const kSMBaseClassCtime = @"ctime";
NSString *const kSMBaseClassApp = @"app";
NSString *const kSMBaseClassId = @"id";
NSString *const kSMBaseClassTitle = @"title";
NSString *const kSMBaseClassAppname = @"appname";
NSString *const kSMBaseClassBody = @"body";
NSString *const kSMBaseClassNode = @"node";


@interface SMBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SMBaseClass

@synthesize isRead = _isRead;
@synthesize uid = _uid;
@synthesize ctime = _ctime;
@synthesize app = _app;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize title = _title;
@synthesize appname = _appname;
@synthesize body = _body;
@synthesize node = _node;


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
            self.isRead = [self objectOrNilForKey:kSMBaseClassIsRead fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kSMBaseClassUid fromDictionary:dict];
            self.ctime = [self objectOrNilForKey:kSMBaseClassCtime fromDictionary:dict];
            self.app = [self objectOrNilForKey:kSMBaseClassApp fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kSMBaseClassId fromDictionary:dict];
            self.title = [self objectOrNilForKey:kSMBaseClassTitle fromDictionary:dict];
            self.appname = [self objectOrNilForKey:kSMBaseClassAppname fromDictionary:dict];
            self.body = [self objectOrNilForKey:kSMBaseClassBody fromDictionary:dict];
            self.node = [self objectOrNilForKey:kSMBaseClassNode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.isRead forKey:kSMBaseClassIsRead];
    [mutableDict setValue:self.uid forKey:kSMBaseClassUid];
    [mutableDict setValue:self.ctime forKey:kSMBaseClassCtime];
    [mutableDict setValue:self.app forKey:kSMBaseClassApp];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kSMBaseClassId];
    [mutableDict setValue:self.title forKey:kSMBaseClassTitle];
    [mutableDict setValue:self.appname forKey:kSMBaseClassAppname];
    [mutableDict setValue:self.body forKey:kSMBaseClassBody];
    [mutableDict setValue:self.node forKey:kSMBaseClassNode];

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

    self.isRead = [aDecoder decodeObjectForKey:kSMBaseClassIsRead];
    self.uid = [aDecoder decodeObjectForKey:kSMBaseClassUid];
    self.ctime = [aDecoder decodeObjectForKey:kSMBaseClassCtime];
    self.app = [aDecoder decodeObjectForKey:kSMBaseClassApp];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kSMBaseClassId];
    self.title = [aDecoder decodeObjectForKey:kSMBaseClassTitle];
    self.appname = [aDecoder decodeObjectForKey:kSMBaseClassAppname];
    self.body = [aDecoder decodeObjectForKey:kSMBaseClassBody];
    self.node = [aDecoder decodeObjectForKey:kSMBaseClassNode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_isRead forKey:kSMBaseClassIsRead];
    [aCoder encodeObject:_uid forKey:kSMBaseClassUid];
    [aCoder encodeObject:_ctime forKey:kSMBaseClassCtime];
    [aCoder encodeObject:_app forKey:kSMBaseClassApp];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kSMBaseClassId];
    [aCoder encodeObject:_title forKey:kSMBaseClassTitle];
    [aCoder encodeObject:_appname forKey:kSMBaseClassAppname];
    [aCoder encodeObject:_body forKey:kSMBaseClassBody];
    [aCoder encodeObject:_node forKey:kSMBaseClassNode];
}

- (id)copyWithZone:(NSZone *)zone
{
    SMBaseClass *copy = [[SMBaseClass alloc] init];
    
    if (copy) {

        copy.isRead = [self.isRead copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.ctime = [self.ctime copyWithZone:zone];
        copy.app = [self.app copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.appname = [self.appname copyWithZone:zone];
        copy.body = [self.body copyWithZone:zone];
        copy.node = [self.node copyWithZone:zone];
    }
    
    return copy;
}


@end
