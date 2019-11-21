//
//  SBaseClass.m
//
//  Created by 志强 林 on 15/2/5
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "SBaseClass.h"
#import "SMoneyData.h"


NSString *const kSBaseClassId = @"id";
NSString *const kSBaseClassBigIds = @"big_ids";
NSString *const kSBaseClassSmallIds = @"small_ids";
NSString *const kSBaseClassUid = @"uid";
NSString *const kSBaseClassAlbumTitle = @"album_title";
NSString *const kSBaseClassMiddleIds = @"middle_ids";
NSString *const kSBaseClassAlbumOrderCount = @"album_order_count";
NSString *const kSBaseClassMoneyData = @"money_data";
NSString *const kSBaseClassAlbumScore = @"album_score";
NSString *const kSBaseClassAlbumCategory = @"album_category";
NSString *const kSBaseClassCid = @"cid";
NSString *const kSBaseClassAlbumVideo = @"album_video";
//NSString *const kSBaseClassMiddleIds = @"middle_ids ";
NSString *const kSBaseClassAlbumIntro = @"album_intro";


@interface SBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SBaseClass

@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize bigIds = _bigIds;
@synthesize smallIds = _smallIds;
@synthesize uid = _uid;
@synthesize albumTitle = _albumTitle;
@synthesize middleIds = _middleIds;
@synthesize albumOrderCount = _albumOrderCount;
@synthesize moneyData = _moneyData;
@synthesize albumScore = _albumScore;
@synthesize albumCategory = _albumCategory;
@synthesize cid = _cid;
@synthesize albumVideo = _albumVideo;
//@synthesize middleIds = _middleIds;
@synthesize albumIntro = _albumIntro;
@synthesize albumId = _albumId;


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
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kSBaseClassId fromDictionary:dict];
            self.bigIds = [self objectOrNilForKey:kSBaseClassBigIds fromDictionary:dict];
            self.smallIds = [self objectOrNilForKey:kSBaseClassSmallIds fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kSBaseClassUid fromDictionary:dict];
            self.albumTitle = [self objectOrNilForKey:kSBaseClassAlbumTitle fromDictionary:dict];
            self.middleIds = [self objectOrNilForKey:kSBaseClassMiddleIds fromDictionary:dict];
            self.albumOrderCount = [self objectOrNilForKey:kSBaseClassAlbumOrderCount fromDictionary:dict];
            self.moneyData = [SMoneyData modelObjectWithDictionary:[dict objectForKey:kSBaseClassMoneyData]];
            self.albumScore = [[self objectOrNilForKey:kSBaseClassAlbumScore fromDictionary:dict] doubleValue];
            self.albumCategory = [self objectOrNilForKey:kSBaseClassAlbumCategory fromDictionary:dict];
            self.cid = [self objectOrNilForKey:kSBaseClassCid fromDictionary:dict];
            self.albumVideo = [self objectOrNilForKey:kSBaseClassAlbumVideo fromDictionary:dict];
//            self.middleIds = [[self objectOrNilForKey:kSBaseClassMiddleIds fromDictionary:dict] boolValue];
            self.albumIntro = [self objectOrNilForKey:kSBaseClassAlbumIntro fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kSBaseClassId];
    [mutableDict setValue:self.bigIds forKey:kSBaseClassBigIds];
    [mutableDict setValue:self.smallIds forKey:kSBaseClassSmallIds];
    [mutableDict setValue:self.uid forKey:kSBaseClassUid];
    [mutableDict setValue:self.albumTitle forKey:kSBaseClassAlbumTitle];
    [mutableDict setValue:self.middleIds forKey:kSBaseClassMiddleIds];
    [mutableDict setValue:self.albumOrderCount forKey:kSBaseClassAlbumOrderCount];
    [mutableDict setValue:[self.moneyData dictionaryRepresentation] forKey:kSBaseClassMoneyData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.albumScore] forKey:kSBaseClassAlbumScore];
    [mutableDict setValue:self.albumCategory forKey:kSBaseClassAlbumCategory];
    [mutableDict setValue:self.cid forKey:kSBaseClassCid];
    [mutableDict setValue:self.albumVideo forKey:kSBaseClassAlbumVideo];
    [mutableDict setValue:[NSNumber numberWithBool:self.middleIds] forKey:kSBaseClassMiddleIds];
    [mutableDict setValue:self.albumIntro forKey:kSBaseClassAlbumIntro];

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

    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kSBaseClassId];
    self.bigIds = [aDecoder decodeObjectForKey:kSBaseClassBigIds];
    self.smallIds = [aDecoder decodeObjectForKey:kSBaseClassSmallIds];
    self.uid = [aDecoder decodeObjectForKey:kSBaseClassUid];
    self.albumTitle = [aDecoder decodeObjectForKey:kSBaseClassAlbumTitle];
    self.middleIds = [aDecoder decodeObjectForKey:kSBaseClassMiddleIds];
    self.albumOrderCount = [aDecoder decodeObjectForKey:kSBaseClassAlbumOrderCount];
    self.moneyData = [aDecoder decodeObjectForKey:kSBaseClassMoneyData];
    self.albumScore = [aDecoder decodeDoubleForKey:kSBaseClassAlbumScore];
    self.albumCategory = [aDecoder decodeObjectForKey:kSBaseClassAlbumCategory];
    self.cid = [aDecoder decodeObjectForKey:kSBaseClassCid];
    self.albumVideo = [aDecoder decodeObjectForKey:kSBaseClassAlbumVideo];
//    self.middleIds = [aDecoder decodeBoolForKey:kSBaseClassMiddleIds];
    self.albumIntro = [aDecoder decodeObjectForKey:kSBaseClassAlbumIntro];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kSBaseClassId];
    [aCoder encodeObject:_bigIds forKey:kSBaseClassBigIds];
    [aCoder encodeObject:_smallIds forKey:kSBaseClassSmallIds];
    [aCoder encodeObject:_uid forKey:kSBaseClassUid];
    [aCoder encodeObject:_albumTitle forKey:kSBaseClassAlbumTitle];
    [aCoder encodeObject:_middleIds forKey:kSBaseClassMiddleIds];
    [aCoder encodeObject:_albumOrderCount forKey:kSBaseClassAlbumOrderCount];
    [aCoder encodeObject:_moneyData forKey:kSBaseClassMoneyData];
    [aCoder encodeDouble:_albumScore forKey:kSBaseClassAlbumScore];
    [aCoder encodeObject:_albumCategory forKey:kSBaseClassAlbumCategory];
    [aCoder encodeObject:_cid forKey:kSBaseClassCid];
    [aCoder encodeObject:_albumVideo forKey:kSBaseClassAlbumVideo];
    [aCoder encodeBool:_middleIds forKey:kSBaseClassMiddleIds];
    [aCoder encodeObject:_albumIntro forKey:kSBaseClassAlbumIntro];
     [aCoder encodeObject:_albumId forKey:kSBaseClassAlbumIntro];
}

- (id)copyWithZone:(NSZone *)zone
{
    SBaseClass *copy = [[SBaseClass alloc] init];
    
    if (copy) {

        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.bigIds = [self.bigIds copyWithZone:zone];
        copy.smallIds = [self.smallIds copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.albumTitle = [self.albumTitle copyWithZone:zone];
        copy.middleIds = [self.middleIds copyWithZone:zone];
        copy.albumOrderCount = [self.albumOrderCount copyWithZone:zone];
        copy.moneyData = [self.moneyData copyWithZone:zone];
        copy.albumScore = self.albumScore;
        copy.albumCategory = [self.albumCategory copyWithZone:zone];
        copy.cid = [self.cid copyWithZone:zone];
        copy.albumVideo = [self.albumVideo copyWithZone:zone];
        copy.middleIds = self.middleIds;
        copy.albumIntro = [self.albumIntro copyWithZone:zone];
         copy.albumIntro = [self.albumId copyWithZone:zone];
    }
    
    return copy;
}


@end
