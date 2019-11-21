//
//  ATFollowState.m
//
//  Created by 志强 林 on 15/2/14
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ATFollowState.h"


NSString *const kATFollowStateFollowing = @"following";
NSString *const kATFollowStateFollower = @"follower";


@interface ATFollowState ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ATFollowState

@synthesize following = _following;
@synthesize follower = _follower;


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
            self.following = [[self objectOrNilForKey:kATFollowStateFollowing fromDictionary:dict] doubleValue];
            self.follower = [[self objectOrNilForKey:kATFollowStateFollower fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.following] forKey:kATFollowStateFollowing];
    [mutableDict setValue:[NSNumber numberWithDouble:self.follower] forKey:kATFollowStateFollower];

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

    self.following = [aDecoder decodeDoubleForKey:kATFollowStateFollowing];
    self.follower = [aDecoder decodeDoubleForKey:kATFollowStateFollower];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_following forKey:kATFollowStateFollowing];
    [aCoder encodeDouble:_follower forKey:kATFollowStateFollower];
}

- (id)copyWithZone:(NSZone *)zone
{
    ATFollowState *copy = [[ATFollowState alloc] init];
    
    if (copy) {

        copy.following = self.following;
        copy.follower = self.follower;
    }
    
    return copy;
}


@end
