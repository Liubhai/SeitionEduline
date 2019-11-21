//
//  NQBaseClass.m
//
//  Created by 志强 林 on 15/2/27
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "NQBaseClass.h"
#import "NQData.h"


NSString *const kNQBaseClassMsg = @"msg";
NSString *const kNQBaseClassData = @"data";
NSString *const kNQBaseClassCode = @"code";


@interface NQBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NQBaseClass

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
            self.msg = [self objectOrNilForKey:kNQBaseClassMsg fromDictionary:dict];
    NSObject *receivedNQData = [dict objectForKey:kNQBaseClassData];
    NSMutableArray *parsedNQData = [NSMutableArray array];
    if ([receivedNQData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedNQData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedNQData addObject:[NQData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedNQData isKindOfClass:[NSDictionary class]]) {
       [parsedNQData addObject:[NQData modelObjectWithDictionary:(NSDictionary *)receivedNQData]];
    }

    self.data = [NSArray arrayWithArray:parsedNQData];
            self.code = [[self objectOrNilForKey:kNQBaseClassCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.msg forKey:kNQBaseClassMsg];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kNQBaseClassData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kNQBaseClassCode];

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

    self.msg = [aDecoder decodeObjectForKey:kNQBaseClassMsg];
    self.data = [aDecoder decodeObjectForKey:kNQBaseClassData];
    self.code = [aDecoder decodeDoubleForKey:kNQBaseClassCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_msg forKey:kNQBaseClassMsg];
    [aCoder encodeObject:_data forKey:kNQBaseClassData];
    [aCoder encodeDouble:_code forKey:kNQBaseClassCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    NQBaseClass *copy = [[NQBaseClass alloc] init];
    
    if (copy) {

        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
