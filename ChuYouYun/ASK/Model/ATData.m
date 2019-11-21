//
//  ATData.m
//
//  Created by 志强 林 on 15/2/14
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ATData.h"
#import "ATCountInfo.h"
#import "ATFollowState.h"


NSString *const kATDataIntro = @"intro";
NSString *const kATDataProfile = @"profile";
NSString *const kATDataFollowId = @"follow_id";
NSString *const kATDataUid = @"uid";
NSString *const kATDataSex = @"sex";
NSString *const kATDataCountInfo = @"count_info";
NSString *const kATDataAvatarBig = @"avatar_big";
NSString *const kATDataAvatarMiddle = @"avatar_middle";
NSString *const kATDataUname = @"uname";
NSString *const kATDataRemark = @"remark";
NSString *const kATDataCtime = @"ctime";
NSString *const kATDataSpaceUrl = @"space_url";
NSString *const kATDataFollowState = @"follow_state";
NSString *const kATDataAvatarSmall = @"avatar_small";


@interface ATData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ATData

@synthesize intro = _intro;
@synthesize profile = _profile;
@synthesize followId = _followId;
@synthesize uid = _uid;
@synthesize sex = _sex;
@synthesize countInfo = _countInfo;
@synthesize avatarBig = _avatarBig;
@synthesize avatarMiddle = _avatarMiddle;
@synthesize uname = _uname;
@synthesize remark = _remark;
@synthesize ctime = _ctime;
@synthesize spaceUrl = _spaceUrl;
@synthesize followState = _followState;
@synthesize avatarSmall = _avatarSmall;


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
            self.intro = [self objectOrNilForKey:kATDataIntro fromDictionary:dict];
            self.profile = [self objectOrNilForKey:kATDataProfile fromDictionary:dict];
            self.followId = [self objectOrNilForKey:kATDataFollowId fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kATDataUid fromDictionary:dict];
            self.sex = [self objectOrNilForKey:kATDataSex fromDictionary:dict];
            self.countInfo = [ATCountInfo modelObjectWithDictionary:[dict objectForKey:kATDataCountInfo]];
            self.avatarBig = [self objectOrNilForKey:kATDataAvatarBig fromDictionary:dict];
            self.avatarMiddle = [self objectOrNilForKey:kATDataAvatarMiddle fromDictionary:dict];
            self.uname = [self objectOrNilForKey:kATDataUname fromDictionary:dict];
            self.remark = [self objectOrNilForKey:kATDataRemark fromDictionary:dict];
            self.ctime = [self objectOrNilForKey:kATDataCtime fromDictionary:dict];
            self.spaceUrl = [self objectOrNilForKey:kATDataSpaceUrl fromDictionary:dict];
            self.followState = [self objectOrNilForKey:kATDataFollowState fromDictionary:dict];
            self.avatarSmall = [self objectOrNilForKey:kATDataAvatarSmall fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.intro forKey:kATDataIntro];
    NSMutableArray *tempArrayForProfile = [NSMutableArray array];
    for (NSObject *subArrayObject in self.profile) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForProfile addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForProfile addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForProfile] forKey:kATDataProfile];
    [mutableDict setValue:self.followId forKey:kATDataFollowId];
    [mutableDict setValue:self.uid forKey:kATDataUid];
    [mutableDict setValue:self.sex forKey:kATDataSex];
    [mutableDict setValue:[self.countInfo dictionaryRepresentation] forKey:kATDataCountInfo];
    [mutableDict setValue:self.avatarBig forKey:kATDataAvatarBig];
    [mutableDict setValue:self.avatarMiddle forKey:kATDataAvatarMiddle];
    [mutableDict setValue:self.uname forKey:kATDataUname];
    [mutableDict setValue:self.remark forKey:kATDataRemark];
    [mutableDict setValue:self.ctime forKey:kATDataCtime];
    [mutableDict setValue:self.spaceUrl forKey:kATDataSpaceUrl];
    [mutableDict setValue:self.followState forKey:kATDataFollowState];
    [mutableDict setValue:self.avatarSmall forKey:kATDataAvatarSmall];

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

    self.intro = [aDecoder decodeObjectForKey:kATDataIntro];
    self.profile = [aDecoder decodeObjectForKey:kATDataProfile];
    self.followId = [aDecoder decodeObjectForKey:kATDataFollowId];
    self.uid = [aDecoder decodeObjectForKey:kATDataUid];
    self.sex = [aDecoder decodeObjectForKey:kATDataSex];
    self.countInfo = [aDecoder decodeObjectForKey:kATDataCountInfo];
    self.avatarBig = [aDecoder decodeObjectForKey:kATDataAvatarBig];
    self.avatarMiddle = [aDecoder decodeObjectForKey:kATDataAvatarMiddle];
    self.uname = [aDecoder decodeObjectForKey:kATDataUname];
    self.remark = [aDecoder decodeObjectForKey:kATDataRemark];
    self.ctime = [aDecoder decodeObjectForKey:kATDataCtime];
    self.spaceUrl = [aDecoder decodeObjectForKey:kATDataSpaceUrl];
    self.followState = [aDecoder decodeObjectForKey:kATDataFollowState];
    self.avatarSmall = [aDecoder decodeObjectForKey:kATDataAvatarSmall];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_intro forKey:kATDataIntro];
    [aCoder encodeObject:_profile forKey:kATDataProfile];
    [aCoder encodeObject:_followId forKey:kATDataFollowId];
    [aCoder encodeObject:_uid forKey:kATDataUid];
    [aCoder encodeObject:_sex forKey:kATDataSex];
    [aCoder encodeObject:_countInfo forKey:kATDataCountInfo];
    [aCoder encodeObject:_avatarBig forKey:kATDataAvatarBig];
    [aCoder encodeObject:_avatarMiddle forKey:kATDataAvatarMiddle];
    [aCoder encodeObject:_uname forKey:kATDataUname];
    [aCoder encodeObject:_remark forKey:kATDataRemark];
    [aCoder encodeObject:_ctime forKey:kATDataCtime];
    [aCoder encodeObject:_spaceUrl forKey:kATDataSpaceUrl];
    [aCoder encodeObject:_followState forKey:kATDataFollowState];
    [aCoder encodeObject:_avatarSmall forKey:kATDataAvatarSmall];
}

- (id)copyWithZone:(NSZone *)zone
{
    ATData *copy = [[ATData alloc] init];
    
    if (copy) {

        copy.intro = [self.intro copyWithZone:zone];
        copy.profile = [self.profile copyWithZone:zone];
        copy.followId = [self.followId copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.sex = [self.sex copyWithZone:zone];
        copy.countInfo = [self.countInfo copyWithZone:zone];
        copy.avatarBig = [self.avatarBig copyWithZone:zone];
        copy.avatarMiddle = [self.avatarMiddle copyWithZone:zone];
        copy.uname = [self.uname copyWithZone:zone];
        copy.remark = [self.remark copyWithZone:zone];
        copy.ctime = [self.ctime copyWithZone:zone];
        copy.spaceUrl = [self.spaceUrl copyWithZone:zone];
        copy.followState = [self.followState copyWithZone:zone];
        copy.avatarSmall = [self.avatarSmall copyWithZone:zone];
    }
    
    return copy;
}


@end
