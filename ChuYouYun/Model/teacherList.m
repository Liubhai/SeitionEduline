//
//  teacherList.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/22.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "teacherList.h"
NSString * const kTeacherID=@"id";
NSString * const kClassID = @"id";
NSString * const kTeacherImg = @"headimg";
NSString * const kTeacherInro = @"inro";
NSString * const kTeacherName = @"name";
NSString * const kTeacherVideo = @"video_cont";
NSString * const kRelatedCourseName = @"video_title";
NSString * const kRelatedCourseIron = @"video_intro";
NSString * const kRelatedCourseOrderCount = @"video_order_count";
NSString * const kRelatedCourseScore = @"video_score";
NSString * const kRelatedCourseImg = @"videoImgUrl";
//NSString * const kRelatedCouseImg = @""；
NSString * const kRelatedCoursePrice = @"mzprice";
NSString * const kClassImg = @"imageurl";
NSString * const kClassPrice = @"price";
NSString * const kClassListTime = @"listingtime";
NSString * const kClassUtime = @"utime";
NSString * const kClassVideoAddress = @"video_address";

@interface teacherList ()
- (id)objectOrNilForKeys:(id)aKey fromDictionary:(NSDictionary *)dict;
@end

@implementation teacherList
@synthesize cid = _cid;
@synthesize iD = _iD;
@synthesize uid = _uid;
@synthesize name = _name;
@synthesize inro = _inro;
@synthesize video_count = _video_count;
@synthesize heading = _heading;
@synthesize video_title = _video_title;
@synthesize video_inro = _video_inro;
@synthesize video_order_count = _video_order_count;
@synthesize video_score = _video_score;
@synthesize img = _img;
@synthesize mzprice = _mzprice;
@synthesize imgUrl = _imgUrl;
@synthesize price = _price;
@synthesize listTime = _listTime;
@synthesize uTime = _uTime;
@synthesize videoAddress = _videoAddress;
+(instancetype)modelObjectWithDictionary:(NSDictionary *)dicts
{
    return [[self alloc] initWithDictionary:dicts];
}

- (instancetype)initWithDictionarys:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.iD = [self objectOrNilForKeys: kTeacherID fromDictionary:dict];
        //self.uid = [self objectOrNilForKeys:kMaListCourseName fromDictionary:dict];
        self.name = [self objectOrNilForKeys:kTeacherName fromDictionary:dict];
        self.video_count = [self objectOrNilForKeys:kTeacherVideo fromDictionary:dict];
        self.inro = [self objectOrNilForKeys:kTeacherInro fromDictionary:dict];
        self.heading = [self objectOrNilForKeys:kTeacherImg fromDictionary:dict];

        self.video_inro = [self objectOrNilForKeys:kRelatedCourseIron fromDictionary:dict];
        self.video_title = [self objectOrNilForKeys:kRelatedCourseName fromDictionary:dict];
        
        self.video_score = [self objectOrNilForKeys:kRelatedCourseScore fromDictionary:dict];
        self.video_order_count = [self objectOrNilForKeys:kRelatedCourseOrderCount fromDictionary:dict];
        self.img = [self objectOrNilForKeys:kRelatedCourseImg fromDictionary:dict];
        self.mzprice = [self objectOrNilForKeys:kRelatedCoursePrice fromDictionary:dict];
        self.imgUrl = [self objectOrNilForKeys:kClassImg fromDictionary:dict];
        self.price = [self objectOrNilForKeys:kClassPrice fromDictionary:dict];
        self.cid  = [self objectOrNilForKeys:kClassID fromDictionary:dict];
        self.listTime = [self objectOrNilForKeys:kClassListTime fromDictionary:dict];
        self.uTime  = [self objectOrNilForKeys:kClassUtime fromDictionary:dict];
        self.videoAddress  = [self objectOrNilForKeys:kClassVideoAddress fromDictionary:dict];
        }
    
    return self;
    
}

- (NSDictionary *)DictionaryRepresentation
{
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.iD forKey:kTeacherID];
    [mutableDict setValue:self.video_count forKey:kTeacherVideo];
    [mutableDict setValue:self.name forKey:kTeacherName];
    [mutableDict setValue:self.heading forKey:kTeacherImg];
    [mutableDict setValue:self.inro forKey:kTeacherInro];
    [mutableDict setValue:self.video_title forKey:kRelatedCourseName];
    [mutableDict setValue:self.video_inro forKey:kRelatedCourseIron];
    
    [mutableDict setValue:self.video_order_count forKey:kRelatedCourseOrderCount];
    [mutableDict setValue:self.video_score forKey:kRelatedCourseScore];
     [mutableDict setValue:self.img forKey:kRelatedCourseImg];
    [mutableDict setValue:self.mzprice forKey:kRelatedCoursePrice];
    [mutableDict setValue:self.imgUrl forKey:kClassImg];
    [mutableDict setValue:self.price forKey:kClassPrice];
    [mutableDict setValue:self.cid forKey:kClassID];
    [mutableDict setValue:self.listTime forKey:kClassListTime];
    [mutableDict setValue:self.uTime forKey:kClassUtime];
    [mutableDict setValue:self.videoAddress forKey:kClassVideoAddress];
       return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self DictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKeys:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.iD = [aDecoder decodeObjectForKey:kTeacherID];
    self.video_count = [aDecoder decodeObjectForKey:kTeacherVideo];
    self.name = [aDecoder decodeObjectForKey:kTeacherName];
    self.heading = [aDecoder decodeObjectForKey:kTeacherImg];
    self.inro = [aDecoder decodeObjectForKey:kTeacherInro];
    self.video_inro = [aDecoder decodeObjectForKey:kRelatedCourseIron];
    self.video_title = [aDecoder decodeObjectForKey:kRelatedCourseName];
    
    self.video_score = [aDecoder decodeObjectForKey:kRelatedCourseScore];
    self.video_order_count = [aDecoder decodeObjectForKey:kRelatedCourseOrderCount];
    self.img = [aDecoder decodeObjectForKey:kRelatedCourseImg];
    self.mzprice = [aDecoder decodeObjectForKey:kRelatedCoursePrice];
    self.imgUrl = [aDecoder decodeObjectForKey:kClassImg];
    self.price = [aDecoder decodeObjectForKey:kClassPrice];
     self.cid = [aDecoder decodeObjectForKey:kClassID];
    self.listTime = [aDecoder decodeObjectForKey:kClassListTime];
    self.uTime = [aDecoder decodeObjectForKey:kClassUtime];
    self.videoAddress = [aDecoder decodeObjectForKey:kClassVideoAddress];
        return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_iD forKey:kTeacherID];
    [aCoder encodeObject:_video_count forKey:kTeacherVideo];
    [aCoder encodeObject:_name forKey:kTeacherName];
    [aCoder encodeObject:_heading forKey:kTeacherImg];
    [aCoder encodeObject:_inro forKey:kTeacherInro];
    [aCoder encodeObject:_video_inro forKey:kRelatedCourseIron];
    [aCoder encodeObject:_video_title forKey:kRelatedCourseName];
    [aCoder encodeObject:_video_score forKey:kRelatedCourseScore];
    [aCoder encodeObject:_video_order_count forKey:kRelatedCourseOrderCount];
    [aCoder encodeObject:_img forKey:kRelatedCourseImg];
    [aCoder encodeObject:_mzprice forKey:kRelatedCoursePrice];
    [aCoder encodeObject:_imgUrl forKey:kClassImg];
    [aCoder encodeObject:_price forKey:kClassPrice];
    [aCoder encodeObject:_cid forKey:kClassID];
    [aCoder encodeObject:_listTime forKey:kClassListTime];
    [aCoder encodeObject:_uTime forKey:kClassUtime];
    [aCoder encodeObject:_videoAddress forKey:kClassVideoAddress];

}

- (id)copyWithZone:(NSZone *)zone
{
    teacherList *copy = [[teacherList alloc] init];
    
    if (copy) {
        
        copy.iD = [self.iD copyWithZone:zone];
        copy.video_count = [self.video_count copyWithZone:zone];
        copy.inro = [self.inro copyWithZone:zone];
        copy.heading = [self.heading copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.video_title = [self.video_title copyWithZone:zone];
        copy.video_inro = [self.video_inro copyWithZone:zone];
        
        copy.video_order_count = [self.video_order_count copyWithZone:zone];
        copy.video_score = [self.video_score copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.mzprice = [self.mzprice copyWithZone:zone];
        copy.imgUrl = [self.imgUrl copyWithZone:zone];
         copy.price = [self.price copyWithZone:zone];
        copy.cid = [self.cid copyWithZone:zone];
        copy.listTime = [self.listTime copyWithZone:zone];
        copy.uTime = [self.uTime copyWithZone:zone];
        copy.videoAddress = [self.videoAddress copyWithZone:zone];
    }
    
    return copy;
}


@end
