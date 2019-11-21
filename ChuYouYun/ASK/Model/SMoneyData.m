//
//  SMoneyData.m
//
//  Created by 志强 林 on 15/2/5
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "SMoneyData.h"


NSString *const kSMoneyDataDiscount = @"discount";
NSString *const kSMoneyDataDisType = @"dis_type";
NSString *const kSMoneyDataOriPrice = @"oriPrice";
NSString *const kSMoneyDataPrice = @"price";
NSString *const kSMoneyDataDisPrice = @"disPrice";
NSString *const kSMoneyDataVipPrice = @"vipPrice";


@interface SMoneyData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SMoneyData

@synthesize discount = _discount;
@synthesize disType = _disType;
@synthesize oriPrice = _oriPrice;
@synthesize price = _price;
@synthesize disPrice = _disPrice;
@synthesize vipPrice = _vipPrice;


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
            self.discount = [[self objectOrNilForKey:kSMoneyDataDiscount fromDictionary:dict] doubleValue];
            self.disType = [[self objectOrNilForKey:kSMoneyDataDisType fromDictionary:dict] doubleValue];
            self.oriPrice = [[self objectOrNilForKey:kSMoneyDataOriPrice fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kSMoneyDataPrice fromDictionary:dict] doubleValue];
            self.disPrice = [[self objectOrNilForKey:kSMoneyDataDisPrice fromDictionary:dict] doubleValue];
            self.vipPrice = [[self objectOrNilForKey:kSMoneyDataVipPrice fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.discount] forKey:kSMoneyDataDiscount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.disType] forKey:kSMoneyDataDisType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.oriPrice] forKey:kSMoneyDataOriPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kSMoneyDataPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.disPrice] forKey:kSMoneyDataDisPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.vipPrice] forKey:kSMoneyDataVipPrice];

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

    self.discount = [aDecoder decodeDoubleForKey:kSMoneyDataDiscount];
    self.disType = [aDecoder decodeDoubleForKey:kSMoneyDataDisType];
    self.oriPrice = [aDecoder decodeDoubleForKey:kSMoneyDataOriPrice];
    self.price = [aDecoder decodeDoubleForKey:kSMoneyDataPrice];
    self.disPrice = [aDecoder decodeDoubleForKey:kSMoneyDataDisPrice];
    self.vipPrice = [aDecoder decodeDoubleForKey:kSMoneyDataVipPrice];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_discount forKey:kSMoneyDataDiscount];
    [aCoder encodeDouble:_disType forKey:kSMoneyDataDisType];
    [aCoder encodeDouble:_oriPrice forKey:kSMoneyDataOriPrice];
    [aCoder encodeDouble:_price forKey:kSMoneyDataPrice];
    [aCoder encodeDouble:_disPrice forKey:kSMoneyDataDisPrice];
    [aCoder encodeDouble:_vipPrice forKey:kSMoneyDataVipPrice];
}

- (id)copyWithZone:(NSZone *)zone
{
    SMoneyData *copy = [[SMoneyData alloc] init];
    
    if (copy) {

        copy.discount = self.discount;
        copy.disType = self.disType;
        copy.oriPrice = self.oriPrice;
        copy.price = self.price;
        copy.disPrice = self.disPrice;
        copy.vipPrice = self.vipPrice;
    }
    
    return copy;
}


@end
