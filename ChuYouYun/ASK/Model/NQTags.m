//
//  NQTags.m
//
//  Created by 志强 林 on 15/2/27
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "NQTags.h"


NSString *const kNQTagsName = @"name";
NSString *const kNQTagsTagId = @"tag_id";


@interface NQTags ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NQTags

@synthesize name = _name;
@synthesize tagId = _tagId;


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
            self.name = [self objectOrNilForKey:kNQTagsName fromDictionary:dict];
            self.tagId = [self objectOrNilForKey:kNQTagsTagId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kNQTagsName];
    [mutableDict setValue:self.tagId forKey:kNQTagsTagId];

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

    self.name = [aDecoder decodeObjectForKey:kNQTagsName];
    self.tagId = [aDecoder decodeObjectForKey:kNQTagsTagId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kNQTagsName];
    [aCoder encodeObject:_tagId forKey:kNQTagsTagId];
}

- (id)copyWithZone:(NSZone *)zone
{
    NQTags *copy = [[NQTags alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.tagId = [self.tagId copyWithZone:zone];
    }
    
    return copy;
}


@end
