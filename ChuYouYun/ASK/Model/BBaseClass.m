//
//  BBaseClass.m
//
//  Created by 志强 林 on 15/2/12
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BBaseClass.h"
#import "BData.h"


NSString *const kBBaseClassMsg = @"msg";
NSString *const kBBaseClassData = @"data";
NSString *const kBBaseClassCode = @"code";


@interface BBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BBaseClass

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
            self.msg = [self objectOrNilForKey:kBBaseClassMsg fromDictionary:dict];
    NSObject *receivedBData = [dict objectForKey:kBBaseClassData];
    NSMutableArray *parsedBData = [NSMutableArray array];
    if ([receivedBData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedBData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBData addObject:[BData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedBData isKindOfClass:[NSDictionary class]]) {
       [parsedBData addObject:[BData modelObjectWithDictionary:(NSDictionary *)receivedBData]];
    }

    self.data = [NSArray arrayWithArray:parsedBData];
            self.code = [[self objectOrNilForKey:kBBaseClassCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.msg forKey:kBBaseClassMsg];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kBBaseClassData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kBBaseClassCode];

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

    self.msg = [aDecoder decodeObjectForKey:kBBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kBBaseClassData];
    self.code = [aDecoder decodeDoubleForKey:kBBaseClassCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_msg forKey:kBBaseClassMsg];
    [aCoder encodeObject:_data forKey:kBBaseClassData];
    [aCoder encodeDouble:_code forKey:kBBaseClassCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    BBaseClass *copy = [[BBaseClass alloc] init];
    
    if (copy) {

        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
