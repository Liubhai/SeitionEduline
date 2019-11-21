//
//  SPBaseClass.m
//
//  Created by 志强 林 on 15/2/12
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "SPBaseClass.h"
#import "SPVideoInfo.h"


NSString *const kSPBaseClassIsBuy = @"is_buy";
NSString *const kSPBaseClassTmpId = @"tmp_id";
NSString *const kSPBaseClassCtime = @"ctime";
NSString *const kSPBaseClassUid = @"uid";
NSString *const kSPBaseClassId = @"id";
NSString *const kSPBaseClassTlimitState = @"tlimit_state";
NSString *const kSPBaseClassVideoInfo = @"video_info";
NSString *const kSPBaseClassVideoId = @"video_id";
NSString *const kSPBaseClassPrice = @"price";
NSString *const kSPBaseClassLegal = @"legal";


@interface SPBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SPBaseClass

@synthesize isBuy = _isBuy;
@synthesize tmpId = _tmpId;
@synthesize ctime = _ctime;
@synthesize uid = _uid;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize tlimitState = _tlimitState;
@synthesize videoInfo = _videoInfo;
@synthesize videoId = _videoId;
@synthesize price = _price;
@synthesize legal = _legal;


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
            self.isBuy = [[self objectOrNilForKey:kSPBaseClassIsBuy fromDictionary:dict] boolValue];
            self.tmpId = [self objectOrNilForKey:kSPBaseClassTmpId fromDictionary:dict];
            self.ctime = [self objectOrNilForKey:kSPBaseClassCtime fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kSPBaseClassUid fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kSPBaseClassId fromDictionary:dict];
            self.tlimitState = [[self objectOrNilForKey:kSPBaseClassTlimitState fromDictionary:dict] doubleValue];
            self.videoInfo = [SPVideoInfo modelObjectWithDictionary:[dict objectForKey:kSPBaseClassVideoInfo]];
            self.videoId = [self objectOrNilForKey:kSPBaseClassVideoId fromDictionary:dict];
            self.price = [self objectOrNilForKey:kSPBaseClassPrice fromDictionary:dict];
            self.legal = [[self objectOrNilForKey:kSPBaseClassLegal fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.isBuy] forKey:kSPBaseClassIsBuy];
    [mutableDict setValue:self.tmpId forKey:kSPBaseClassTmpId];
    [mutableDict setValue:self.ctime forKey:kSPBaseClassCtime];
    [mutableDict setValue:self.uid forKey:kSPBaseClassUid];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kSPBaseClassId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tlimitState] forKey:kSPBaseClassTlimitState];
    [mutableDict setValue:[self.videoInfo dictionaryRepresentation] forKey:kSPBaseClassVideoInfo];
    [mutableDict setValue:self.videoId forKey:kSPBaseClassVideoId];
    [mutableDict setValue:self.price forKey:kSPBaseClassPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.legal] forKey:kSPBaseClassLegal];

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

    self.isBuy = [aDecoder decodeBoolForKey:kSPBaseClassIsBuy];
    self.tmpId = [aDecoder decodeObjectForKey:kSPBaseClassTmpId];
    self.ctime = [aDecoder decodeObjectForKey:kSPBaseClassCtime];
    self.uid = [aDecoder decodeObjectForKey:kSPBaseClassUid];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kSPBaseClassId];
    self.tlimitState = [aDecoder decodeDoubleForKey:kSPBaseClassTlimitState];
    self.videoInfo = [aDecoder decodeObjectForKey:kSPBaseClassVideoInfo];
    self.videoId = [aDecoder decodeObjectForKey:kSPBaseClassVideoId];
    self.price = [aDecoder decodeObjectForKey:kSPBaseClassPrice];
    self.legal = [aDecoder decodeDoubleForKey:kSPBaseClassLegal];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_isBuy forKey:kSPBaseClassIsBuy];
    [aCoder encodeObject:_tmpId forKey:kSPBaseClassTmpId];
    [aCoder encodeObject:_ctime forKey:kSPBaseClassCtime];
    [aCoder encodeObject:_uid forKey:kSPBaseClassUid];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kSPBaseClassId];
    [aCoder encodeDouble:_tlimitState forKey:kSPBaseClassTlimitState];
    [aCoder encodeObject:_videoInfo forKey:kSPBaseClassVideoInfo];
    [aCoder encodeObject:_videoId forKey:kSPBaseClassVideoId];
    [aCoder encodeObject:_price forKey:kSPBaseClassPrice];
    [aCoder encodeDouble:_legal forKey:kSPBaseClassLegal];
}

- (id)copyWithZone:(NSZone *)zone
{
    SPBaseClass *copy = [[SPBaseClass alloc] init];
    
    if (copy) {

        copy.isBuy = self.isBuy;
        copy.tmpId = [self.tmpId copyWithZone:zone];
        copy.ctime = [self.ctime copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.tlimitState = self.tlimitState;
        copy.videoInfo = [self.videoInfo copyWithZone:zone];
        copy.videoId = [self.videoId copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.legal = self.legal;
    }
    
    return copy;
}


@end
