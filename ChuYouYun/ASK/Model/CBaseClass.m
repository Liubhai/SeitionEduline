//
//  CBaseClass.m
//
//  Created by 志强 林 on 15/2/3
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "CBaseClass.h"
#import "CData.h"


NSString *const kCBaseClassMsg = @"msg";
NSString *const kCBaseClassData = @"data";
NSString *const kCBaseClassCode = @"code";


@interface CBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CBaseClass

@synthesize msg = _msg;
@synthesize data = _data;
@synthesize code = _code;


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
            self.msg = [self objectOrNilForKey:kCBaseClassMsg fromDictionary:dict];
    NSObject *receivedCData = [dict objectForKey:kCBaseClassData];
    NSMutableArray *parsedCData = [NSMutableArray array];
    if ([receivedCData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCData addObject:[CData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCData isKindOfClass:[NSDictionary class]]) {
       [parsedCData addObject:[CData modelObjectWithDictionary:(NSDictionary *)receivedCData]];
    }

    self.data = [NSArray arrayWithArray:parsedCData];
            self.code = [[self objectOrNilForKey:kCBaseClassCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.msg forKey:kCBaseClassMsg];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kCBaseClassData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kCBaseClassCode];

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

    self.msg = [aDecoder decodeObjectForKey:kCBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kCBaseClassData];
    self.code = [aDecoder decodeDoubleForKey:kCBaseClassCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_msg forKey:kCBaseClassMsg];
    [aCoder encodeObject:_data forKey:kCBaseClassData];
    [aCoder encodeDouble:_code forKey:kCBaseClassCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    CBaseClass *copy = [[CBaseClass alloc] init];
    
    if (copy) {

        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
