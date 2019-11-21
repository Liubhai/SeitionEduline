//
//  ATCountInfo.m
//
//  Created by 志强 林 on 15/2/14
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ATCountInfo.h"


NSString *const kATCountInfoFeedCount = @"feed_count";
NSString *const kATCountInfoFavoriteCount = @"favorite_count";
NSString *const kATCountInfoCheckConnum = @"check_connum";
NSString *const kATCountInfoNewFolowerCount = @"new_folower_count";
NSString *const kATCountInfoWeiboCount = @"weibo_count";
NSString *const kATCountInfoFollowingCount = @"following_count";
NSString *const kATCountInfoCheckTotalnum = @"check_totalnum";
NSString *const kATCountInfoFollowerCount = @"follower_count";


@interface ATCountInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ATCountInfo

@synthesize feedCount = _feedCount;
@synthesize favoriteCount = _favoriteCount;
@synthesize checkConnum = _checkConnum;
@synthesize newFolowerCount = _newFolowerCount;
@synthesize weiboCount = _weiboCount;
@synthesize followingCount = _followingCount;
@synthesize checkTotalnum = _checkTotalnum;
@synthesize followerCount = _followerCount;


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
            self.feedCount = [[self objectOrNilForKey:kATCountInfoFeedCount fromDictionary:dict] doubleValue];
            self.favoriteCount = [[self objectOrNilForKey:kATCountInfoFavoriteCount fromDictionary:dict] doubleValue];
            self.checkConnum = [[self objectOrNilForKey:kATCountInfoCheckConnum fromDictionary:dict] doubleValue];
            self.newFolowerCount = [[self objectOrNilForKey:kATCountInfoNewFolowerCount fromDictionary:dict] doubleValue];
            self.weiboCount = [[self objectOrNilForKey:kATCountInfoWeiboCount fromDictionary:dict] doubleValue];
            self.followingCount = [[self objectOrNilForKey:kATCountInfoFollowingCount fromDictionary:dict] doubleValue];
            self.checkTotalnum = [[self objectOrNilForKey:kATCountInfoCheckTotalnum fromDictionary:dict] doubleValue];
            self.followerCount = [[self objectOrNilForKey:kATCountInfoFollowerCount fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.feedCount] forKey:kATCountInfoFeedCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.favoriteCount] forKey:kATCountInfoFavoriteCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.checkConnum] forKey:kATCountInfoCheckConnum];
    [mutableDict setValue:[NSNumber numberWithDouble:self.newFolowerCount] forKey:kATCountInfoNewFolowerCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.weiboCount] forKey:kATCountInfoWeiboCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.followingCount] forKey:kATCountInfoFollowingCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.checkTotalnum] forKey:kATCountInfoCheckTotalnum];
    [mutableDict setValue:[NSNumber numberWithDouble:self.followerCount] forKey:kATCountInfoFollowerCount];

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

    self.feedCount = [aDecoder decodeDoubleForKey:kATCountInfoFeedCount];
    self.favoriteCount = [aDecoder decodeDoubleForKey:kATCountInfoFavoriteCount];
    self.checkConnum = [aDecoder decodeDoubleForKey:kATCountInfoCheckConnum];
    self.newFolowerCount = [aDecoder decodeDoubleForKey:kATCountInfoNewFolowerCount];
    self.weiboCount = [aDecoder decodeDoubleForKey:kATCountInfoWeiboCount];
    self.followingCount = [aDecoder decodeDoubleForKey:kATCountInfoFollowingCount];
    self.checkTotalnum = [aDecoder decodeDoubleForKey:kATCountInfoCheckTotalnum];
    self.followerCount = [aDecoder decodeDoubleForKey:kATCountInfoFollowerCount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_feedCount forKey:kATCountInfoFeedCount];
    [aCoder encodeDouble:_favoriteCount forKey:kATCountInfoFavoriteCount];
    [aCoder encodeDouble:_checkConnum forKey:kATCountInfoCheckConnum];
    [aCoder encodeDouble:_newFolowerCount forKey:kATCountInfoNewFolowerCount];
    [aCoder encodeDouble:_weiboCount forKey:kATCountInfoWeiboCount];
    [aCoder encodeDouble:_followingCount forKey:kATCountInfoFollowingCount];
    [aCoder encodeDouble:_checkTotalnum forKey:kATCountInfoCheckTotalnum];
    [aCoder encodeDouble:_followerCount forKey:kATCountInfoFollowerCount];
}

- (id)copyWithZone:(NSZone *)zone
{
    ATCountInfo *copy = [[ATCountInfo alloc] init];
    
    if (copy) {

        copy.feedCount = self.feedCount;
        copy.favoriteCount = self.favoriteCount;
        copy.checkConnum = self.checkConnum;
        copy.newFolowerCount = self.newFolowerCount;
        copy.weiboCount = self.weiboCount;
        copy.followingCount = self.followingCount;
        copy.checkTotalnum = self.checkTotalnum;
        copy.followerCount = self.followerCount;
    }
    
    return copy;
}


@end
