//
//  blumList.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/12.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "blumList.h"
NSString * const kBlumID=@"id";
NSString * const kBlumImg=@"big_ids";
NSString * const kBlumTitle = @"album_title";
NSString * const kBlumCollect = @"album_order_count";
NSString * const kBlumIntro = @"album_intro";
NSString * const kBlumVideoCount = @"video_cont";
NSString * const kBlumScore = @"album_score";
NSString * const kBlumMoney = @"money_data";
@interface blumList ()
- (id)objectOrNilForKeys:(id)aKey fromDictionary:(NSDictionary *)dict;

@end


@implementation blumList
@synthesize blum_id = _blum_id;
@synthesize img = _img;
@synthesize album_collect_count = _album_collect_count;
@synthesize album_intro = _album_intro;
@synthesize album_title = _album_title;
@synthesize album_score = _album_score;
@synthesize video_cont= _video_cont;
@synthesize money_data = _money_data;
+(instancetype)modelObjectWithDictionary:(NSDictionary *)dicts
{
    return [[self alloc] initWithDictionary:dicts];
}
- (instancetype)initWithDictionarys:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.blum_id = [self objectOrNilForKeys: kBlumID fromDictionary:dict];
        //self.uid = [self objectOrNilForKeys:kMaListCourseName fromDictionary:dict];
        self.img = [self objectOrNilForKeys:kBlumImg fromDictionary:dict];
        self.album_collect_count = [self objectOrNilForKeys:kBlumCollect fromDictionary:dict];
        self.album_intro = [self objectOrNilForKeys:kBlumIntro fromDictionary:dict];
        self.album_title = [self objectOrNilForKeys:kBlumTitle fromDictionary:dict];
        
        self.video_cont = [self objectOrNilForKeys:kBlumVideoCount fromDictionary:dict];
        self.album_score = [self objectOrNilForKeys:kBlumScore fromDictionary:dict];
        self.money_data = [self objectOrNilForKeys:kBlumMoney fromDictionary:dict];

        
    }
    
    return self;
    
}

- (NSDictionary *)DictionaryRepresentation
{
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.blum_id forKey:kBlumID];
    [mutableDict setValue:self.video_cont forKey:kBlumVideoCount];
    [mutableDict setValue:self.album_score forKey:kBlumScore];
    [mutableDict setValue:self.album_intro forKey:kBlumIntro];
    [mutableDict setValue:self.album_collect_count forKey:kBlumCollect];
    [mutableDict setValue:self.album_title forKey:kBlumTitle];
    [mutableDict setValue:self.img forKey:kBlumImg];
    [mutableDict setValue:self.money_data forKey:kBlumMoney];
    
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
    
    self.blum_id = [aDecoder decodeObjectForKey:kBlumID];
    self.album_title = [aDecoder decodeObjectForKey:kBlumTitle];
    self.img= [aDecoder decodeObjectForKey:kBlumImg];
    self.video_cont = [aDecoder decodeObjectForKey:kBlumVideoCount];
    self.album_score = [aDecoder decodeObjectForKey:kBlumScore];
    self.album_intro = [aDecoder decodeObjectForKey:kBlumIntro];
    self.album_collect_count = [aDecoder decodeObjectForKey:kBlumCollect];
    self.money_data = [aDecoder decodeObjectForKey:kBlumMoney];
   
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_blum_id forKey:kBlumID];
    [aCoder encodeObject:_video_cont forKey:kBlumVideoCount];
    [aCoder encodeObject:_album_score forKey:kBlumScore];
    [aCoder encodeObject:_album_intro forKey:kBlumIntro];
    [aCoder encodeObject:_album_collect_count forKey:kBlumCollect];
    [aCoder encodeObject:_img forKey:kBlumImg];
    [aCoder encodeObject:_album_title forKey:kBlumTitle];
    [aCoder encodeObject:_money_data forKey:kBlumMoney];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    blumList *copy = [[blumList alloc] init];
    
    if (copy) {
        
        copy.blum_id = [self.blum_id copyWithZone:zone];
        copy.video_cont = [self.video_cont copyWithZone:zone];
        copy.img = [self.img copyWithZone:zone];
        copy.album_collect_count = [self.album_collect_count copyWithZone:zone];
        copy.album_intro = [self.album_intro copyWithZone:zone];
        copy.album_score = [self.album_score copyWithZone:zone];
        copy.album_title = [self.album_title copyWithZone:zone];
        copy.money_data = [self.money_data copyWithZone:zone];

       
    }
    
    return copy;
}



@end
