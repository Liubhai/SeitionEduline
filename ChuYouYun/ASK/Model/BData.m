//
//  BData.m
//
//  Created by 志强 林 on 15/2/12
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BData.h"


NSString *const kBDataId = @"id";
NSString *const kBDataOldPrice = @"old_price";
NSString *const kBDataDiscountType = @"discount_type";
NSString *const kBDataUid = @"uid";
NSString *const kBDataLearnStatus = @"learn_status";
NSString *const kBDataDiscount = @"discount";
NSString *const kBDataVideoId = @"video_id";
NSString *const kBDataMasterNum = @"master_num";
NSString *const kBDataOrderAlbumId = @"order_album_id";
NSString *const kBDataIsDel = @"is_del";
NSString *const kBDataTitle = @"title";
NSString *const kBDataPrice = @"price";
NSString *const kBDataMuid = @"muid";
NSString *const kBDataCtime = @"ctime";
NSString *const kBDataPercent = @"percent";
NSString *const kBDataUserNum = @"user_num";


@interface BData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BData

@synthesize dataIdentifier = _dataIdentifier;
@synthesize oldPrice = _oldPrice;
@synthesize discountType = _discountType;
@synthesize uid = _uid;
@synthesize learnStatus = _learnStatus;
@synthesize discount = _discount;
@synthesize videoId = _videoId;
@synthesize masterNum = _masterNum;
@synthesize orderAlbumId = _orderAlbumId;
@synthesize isDel = _isDel;
@synthesize title = _title;
@synthesize price = _price;
@synthesize muid = _muid;
@synthesize ctime = _ctime;
@synthesize percent = _percent;
@synthesize userNum = _userNum;


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
            self.dataIdentifier = [self objectOrNilForKey:kBDataId fromDictionary:dict];
            self.oldPrice = [self objectOrNilForKey:kBDataOldPrice fromDictionary:dict];
            self.discountType = [self objectOrNilForKey:kBDataDiscountType fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kBDataUid fromDictionary:dict];
            self.learnStatus = [self objectOrNilForKey:kBDataLearnStatus fromDictionary:dict];
            self.discount = [self objectOrNilForKey:kBDataDiscount fromDictionary:dict];
            self.videoId = [self objectOrNilForKey:kBDataVideoId fromDictionary:dict];
            self.masterNum = [self objectOrNilForKey:kBDataMasterNum fromDictionary:dict];
            self.orderAlbumId = [self objectOrNilForKey:kBDataOrderAlbumId fromDictionary:dict];
            self.isDel = [self objectOrNilForKey:kBDataIsDel fromDictionary:dict];
            self.title = [self objectOrNilForKey:kBDataTitle fromDictionary:dict];
            self.price = [self objectOrNilForKey:kBDataPrice fromDictionary:dict];
            self.muid = [self objectOrNilForKey:kBDataMuid fromDictionary:dict];
            self.ctime = [self objectOrNilForKey:kBDataCtime fromDictionary:dict];
            self.percent = [self objectOrNilForKey:kBDataPercent fromDictionary:dict];
            self.userNum = [self objectOrNilForKey:kBDataUserNum fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dataIdentifier forKey:kBDataId];
    [mutableDict setValue:self.oldPrice forKey:kBDataOldPrice];
    [mutableDict setValue:self.discountType forKey:kBDataDiscountType];
    [mutableDict setValue:self.uid forKey:kBDataUid];
    [mutableDict setValue:self.learnStatus forKey:kBDataLearnStatus];
    [mutableDict setValue:self.discount forKey:kBDataDiscount];
    [mutableDict setValue:self.videoId forKey:kBDataVideoId];
    [mutableDict setValue:self.masterNum forKey:kBDataMasterNum];
    [mutableDict setValue:self.orderAlbumId forKey:kBDataOrderAlbumId];
    [mutableDict setValue:self.isDel forKey:kBDataIsDel];
    [mutableDict setValue:self.title forKey:kBDataTitle];
    [mutableDict setValue:self.price forKey:kBDataPrice];
    [mutableDict setValue:self.muid forKey:kBDataMuid];
    [mutableDict setValue:self.ctime forKey:kBDataCtime];
    [mutableDict setValue:self.percent forKey:kBDataPercent];
    [mutableDict setValue:self.userNum forKey:kBDataUserNum];

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

    self.dataIdentifier = [aDecoder decodeObjectForKey:kBDataId];
    self.oldPrice = [aDecoder decodeObjectForKey:kBDataOldPrice];
    self.discountType = [aDecoder decodeObjectForKey:kBDataDiscountType];
    self.uid = [aDecoder decodeObjectForKey:kBDataUid];
    self.learnStatus = [aDecoder decodeObjectForKey:kBDataLearnStatus];
    self.discount = [aDecoder decodeObjectForKey:kBDataDiscount];
    self.videoId = [aDecoder decodeObjectForKey:kBDataVideoId];
    self.masterNum = [aDecoder decodeObjectForKey:kBDataMasterNum];
    self.orderAlbumId = [aDecoder decodeObjectForKey:kBDataOrderAlbumId];
    self.isDel = [aDecoder decodeObjectForKey:kBDataIsDel];
    self.title = [aDecoder decodeObjectForKey:kBDataTitle];
    self.price = [aDecoder decodeObjectForKey:kBDataPrice];
    self.muid = [aDecoder decodeObjectForKey:kBDataMuid];
    self.ctime = [aDecoder decodeObjectForKey:kBDataCtime];
    self.percent = [aDecoder decodeObjectForKey:kBDataPercent];
    self.userNum = [aDecoder decodeObjectForKey:kBDataUserNum];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dataIdentifier forKey:kBDataId];
    [aCoder encodeObject:_oldPrice forKey:kBDataOldPrice];
    [aCoder encodeObject:_discountType forKey:kBDataDiscountType];
    [aCoder encodeObject:_uid forKey:kBDataUid];
    [aCoder encodeObject:_learnStatus forKey:kBDataLearnStatus];
    [aCoder encodeObject:_discount forKey:kBDataDiscount];
    [aCoder encodeObject:_videoId forKey:kBDataVideoId];
    [aCoder encodeObject:_masterNum forKey:kBDataMasterNum];
    [aCoder encodeObject:_orderAlbumId forKey:kBDataOrderAlbumId];
    [aCoder encodeObject:_isDel forKey:kBDataIsDel];
    [aCoder encodeObject:_title forKey:kBDataTitle];
    [aCoder encodeObject:_price forKey:kBDataPrice];
    [aCoder encodeObject:_muid forKey:kBDataMuid];
    [aCoder encodeObject:_ctime forKey:kBDataCtime];
    [aCoder encodeObject:_percent forKey:kBDataPercent];
    [aCoder encodeObject:_userNum forKey:kBDataUserNum];
}

- (id)copyWithZone:(NSZone *)zone
{
    BData *copy = [[BData alloc] init];
    
    if (copy) {

        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.oldPrice = [self.oldPrice copyWithZone:zone];
        copy.discountType = [self.discountType copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.learnStatus = [self.learnStatus copyWithZone:zone];
        copy.discount = [self.discount copyWithZone:zone];
        copy.videoId = [self.videoId copyWithZone:zone];
        copy.masterNum = [self.masterNum copyWithZone:zone];
        copy.orderAlbumId = [self.orderAlbumId copyWithZone:zone];
        copy.isDel = [self.isDel copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.muid = [self.muid copyWithZone:zone];
        copy.ctime = [self.ctime copyWithZone:zone];
        copy.percent = [self.percent copyWithZone:zone];
        copy.userNum = [self.userNum copyWithZone:zone];
    }
    
    return copy;
}


@end
