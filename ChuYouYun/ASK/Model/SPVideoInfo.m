//
//  SPVideoInfo.m
//
//  Created by 志强 林 on 15/2/12
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "SPVideoInfo.h"


NSString *const kSPVideoInfoCtime = @"ctime";
NSString *const kSPVideoInfoUid = @"uid";
NSString *const kSPVideoInfoBestRecommend = @"best_recommend";
NSString *const kSPVideoInfoId = @"id";
NSString *const kSPVideoInfoTeachingCover = @"teaching_cover";
NSString *const kSPVideoInfoOriginalRecommend = @"original_recommend";
NSString *const kSPVideoInfoFullcategorypath = @"fullcategorypath";
NSString *const kSPVideoInfoEndtime = @"endtime";
NSString *const kSPVideoInfoIsActivity = @"is_activity";
NSString *const kSPVideoInfoSmallIds = @"small_ids";
NSString *const kSPVideoInfoVideoCategory = @"video_category";
NSString *const kSPVideoInfoVideoId = @"video_id";
NSString *const kSPVideoInfoMiddleCover = @"middle_cover";
NSString *const kSPVideoInfoBeSort = @"be_sort";
NSString *const kSPVideoInfoReSort = @"re_sort";
NSString *const kSPVideoInfoBigIds = @"big_ids";
NSString *const kSPVideoInfoVideofileIds = @"videofile_ids";
NSString *const kSPVideoInfoTeacherId = @"teacher_id";
NSString *const kSPVideoInfoTPrice = @"t_price";
NSString *const kSPVideoInfoVideoStrTag = @"video_str_tag";
NSString *const kSPVideoInfoTeachingIds = @"teaching_ids";
NSString *const kSPVideoInfoListingtime = @"listingtime";
NSString *const kSPVideoInfoStarttime = @"starttime";
NSString *const kSPVideoInfoVideoIntro = @"video_intro";
NSString *const kSPVideoInfoSmallCover = @"small_cover";
NSString *const kSPVideoInfoVideoTitle = @"video_title";
NSString *const kSPVideoInfoBigCover = @"big_cover";
NSString *const kSPVideoInfoIsOffical = @"is_offical";
NSString *const kSPVideoInfoQiniuKey = @"qiniu_key";
NSString *const kSPVideoInfoVideoAddress = @"video_address";
NSString *const kSPVideoInfoUctime = @"uctime";
NSString *const kSPVideoInfoVPrice = @"v_price";
NSString *const kSPVideoInfoIsTlimit = @"is_tlimit";
NSString *const kSPVideoInfoDiscount = @"discount";
NSString *const kSPVideoInfoLimitDiscount = @"limit_discount";
NSString *const kSPVideoInfoShowTime = @"show_time";
NSString *const kSPVideoInfoMiddleIds = @"middle_ids";


@interface SPVideoInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SPVideoInfo

@synthesize ctime = _ctime;
@synthesize uid = _uid;
@synthesize bestRecommend = _bestRecommend;
@synthesize videoInfoIdentifier = _videoInfoIdentifier;
@synthesize teachingCover = _teachingCover;
@synthesize originalRecommend = _originalRecommend;
@synthesize fullcategorypath = _fullcategorypath;
@synthesize endtime = _endtime;
@synthesize isActivity = _isActivity;
@synthesize smallIds = _smallIds;
@synthesize videoCategory = _videoCategory;
@synthesize videoId = _videoId;
@synthesize middleCover = _middleCover;
@synthesize beSort = _beSort;
@synthesize reSort = _reSort;
@synthesize bigIds = _bigIds;
@synthesize videofileIds = _videofileIds;
@synthesize teacherId = _teacherId;
@synthesize tPrice = _tPrice;
@synthesize videoStrTag = _videoStrTag;
@synthesize teachingIds = _teachingIds;
@synthesize listingtime = _listingtime;
@synthesize starttime = _starttime;
@synthesize videoIntro = _videoIntro;
@synthesize smallCover = _smallCover;
@synthesize videoTitle = _videoTitle;
@synthesize bigCover = _bigCover;
@synthesize isOffical = _isOffical;
@synthesize qiniuKey = _qiniuKey;
@synthesize videoAddress = _videoAddress;
@synthesize uctime = _uctime;
@synthesize vPrice = _vPrice;
@synthesize isTlimit = _isTlimit;
@synthesize discount = _discount;
@synthesize limitDiscount = _limitDiscount;
@synthesize showTime = _showTime;
@synthesize middleIds = _middleIds;


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
            self.ctime = [self objectOrNilForKey:kSPVideoInfoCtime fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kSPVideoInfoUid fromDictionary:dict];
            self.bestRecommend = [self objectOrNilForKey:kSPVideoInfoBestRecommend fromDictionary:dict];
            self.videoInfoIdentifier = [self objectOrNilForKey:kSPVideoInfoId fromDictionary:dict];
            self.teachingCover = [[self objectOrNilForKey:kSPVideoInfoTeachingCover fromDictionary:dict] boolValue];
            self.originalRecommend = [self objectOrNilForKey:kSPVideoInfoOriginalRecommend fromDictionary:dict];
            self.fullcategorypath = [self objectOrNilForKey:kSPVideoInfoFullcategorypath fromDictionary:dict];
            self.endtime = [self objectOrNilForKey:kSPVideoInfoEndtime fromDictionary:dict];
            self.isActivity = [self objectOrNilForKey:kSPVideoInfoIsActivity fromDictionary:dict];
            self.smallIds = [self objectOrNilForKey:kSPVideoInfoSmallIds fromDictionary:dict];
            self.videoCategory = [self objectOrNilForKey:kSPVideoInfoVideoCategory fromDictionary:dict];
            self.videoId = [self objectOrNilForKey:kSPVideoInfoVideoId fromDictionary:dict];
            self.middleCover = [self objectOrNilForKey:kSPVideoInfoMiddleCover fromDictionary:dict];
            self.beSort = [self objectOrNilForKey:kSPVideoInfoBeSort fromDictionary:dict];
            self.reSort = [self objectOrNilForKey:kSPVideoInfoReSort fromDictionary:dict];
            self.bigIds = [self objectOrNilForKey:kSPVideoInfoBigIds fromDictionary:dict];
            self.videofileIds = [self objectOrNilForKey:kSPVideoInfoVideofileIds fromDictionary:dict];
            self.teacherId = [self objectOrNilForKey:kSPVideoInfoTeacherId fromDictionary:dict];
            self.tPrice = [self objectOrNilForKey:kSPVideoInfoTPrice fromDictionary:dict];
            self.videoStrTag = [self objectOrNilForKey:kSPVideoInfoVideoStrTag fromDictionary:dict];
            self.teachingIds = [self objectOrNilForKey:kSPVideoInfoTeachingIds fromDictionary:dict];
            self.listingtime = [self objectOrNilForKey:kSPVideoInfoListingtime fromDictionary:dict];
            self.starttime = [self objectOrNilForKey:kSPVideoInfoStarttime fromDictionary:dict];
            self.videoIntro = [self objectOrNilForKey:kSPVideoInfoVideoIntro fromDictionary:dict];
            self.smallCover = [self objectOrNilForKey:kSPVideoInfoSmallCover fromDictionary:dict];
            self.videoTitle = [self objectOrNilForKey:kSPVideoInfoVideoTitle fromDictionary:dict];
            self.bigCover = [self objectOrNilForKey:kSPVideoInfoBigCover fromDictionary:dict];
            self.isOffical = [self objectOrNilForKey:kSPVideoInfoIsOffical fromDictionary:dict];
            self.qiniuKey = [self objectOrNilForKey:kSPVideoInfoQiniuKey fromDictionary:dict];
            self.videoAddress = [self objectOrNilForKey:kSPVideoInfoVideoAddress fromDictionary:dict];
            self.uctime = [self objectOrNilForKey:kSPVideoInfoUctime fromDictionary:dict];
            self.vPrice = [self objectOrNilForKey:kSPVideoInfoVPrice fromDictionary:dict];
            self.isTlimit = [self objectOrNilForKey:kSPVideoInfoIsTlimit fromDictionary:dict];
            self.discount = [self objectOrNilForKey:kSPVideoInfoDiscount fromDictionary:dict];
            self.limitDiscount = [self objectOrNilForKey:kSPVideoInfoLimitDiscount fromDictionary:dict];
            self.showTime = [self objectOrNilForKey:kSPVideoInfoShowTime fromDictionary:dict];
            self.middleIds = [self objectOrNilForKey:kSPVideoInfoMiddleIds fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.ctime forKey:kSPVideoInfoCtime];
    [mutableDict setValue:self.uid forKey:kSPVideoInfoUid];
    [mutableDict setValue:self.bestRecommend forKey:kSPVideoInfoBestRecommend];
    [mutableDict setValue:self.videoInfoIdentifier forKey:kSPVideoInfoId];
    [mutableDict setValue:[NSNumber numberWithBool:self.teachingCover] forKey:kSPVideoInfoTeachingCover];
    [mutableDict setValue:self.originalRecommend forKey:kSPVideoInfoOriginalRecommend];
    [mutableDict setValue:self.fullcategorypath forKey:kSPVideoInfoFullcategorypath];
    [mutableDict setValue:self.endtime forKey:kSPVideoInfoEndtime];
    [mutableDict setValue:self.isActivity forKey:kSPVideoInfoIsActivity];
    [mutableDict setValue:self.smallIds forKey:kSPVideoInfoSmallIds];
    [mutableDict setValue:self.videoCategory forKey:kSPVideoInfoVideoCategory];
    [mutableDict setValue:self.videoId forKey:kSPVideoInfoVideoId];
    [mutableDict setValue:self.middleCover forKey:kSPVideoInfoMiddleCover];
    [mutableDict setValue:self.beSort forKey:kSPVideoInfoBeSort];
    [mutableDict setValue:self.reSort forKey:kSPVideoInfoReSort];
    [mutableDict setValue:self.bigIds forKey:kSPVideoInfoBigIds];
    [mutableDict setValue:self.videofileIds forKey:kSPVideoInfoVideofileIds];
    [mutableDict setValue:self.teacherId forKey:kSPVideoInfoTeacherId];
    [mutableDict setValue:self.tPrice forKey:kSPVideoInfoTPrice];
    [mutableDict setValue:self.videoStrTag forKey:kSPVideoInfoVideoStrTag];
    [mutableDict setValue:self.teachingIds forKey:kSPVideoInfoTeachingIds];
    [mutableDict setValue:self.listingtime forKey:kSPVideoInfoListingtime];
    [mutableDict setValue:self.starttime forKey:kSPVideoInfoStarttime];
    [mutableDict setValue:self.videoIntro forKey:kSPVideoInfoVideoIntro];
    [mutableDict setValue:self.smallCover forKey:kSPVideoInfoSmallCover];
    [mutableDict setValue:self.videoTitle forKey:kSPVideoInfoVideoTitle];
    [mutableDict setValue:self.bigCover forKey:kSPVideoInfoBigCover];
    [mutableDict setValue:self.isOffical forKey:kSPVideoInfoIsOffical];
    [mutableDict setValue:self.qiniuKey forKey:kSPVideoInfoQiniuKey];
    [mutableDict setValue:self.videoAddress forKey:kSPVideoInfoVideoAddress];
    [mutableDict setValue:self.uctime forKey:kSPVideoInfoUctime];
    [mutableDict setValue:self.vPrice forKey:kSPVideoInfoVPrice];
    [mutableDict setValue:self.isTlimit forKey:kSPVideoInfoIsTlimit];
    [mutableDict setValue:self.discount forKey:kSPVideoInfoDiscount];
    [mutableDict setValue:self.limitDiscount forKey:kSPVideoInfoLimitDiscount];
    [mutableDict setValue:self.showTime forKey:kSPVideoInfoShowTime];
    [mutableDict setValue:self.middleIds forKey:kSPVideoInfoMiddleIds];

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

    self.ctime = [aDecoder decodeObjectForKey:kSPVideoInfoCtime];
    self.uid = [aDecoder decodeObjectForKey:kSPVideoInfoUid];
    self.bestRecommend = [aDecoder decodeObjectForKey:kSPVideoInfoBestRecommend];
    self.videoInfoIdentifier = [aDecoder decodeObjectForKey:kSPVideoInfoId];
    self.teachingCover = [aDecoder decodeBoolForKey:kSPVideoInfoTeachingCover];
    self.originalRecommend = [aDecoder decodeObjectForKey:kSPVideoInfoOriginalRecommend];
    self.fullcategorypath = [aDecoder decodeObjectForKey:kSPVideoInfoFullcategorypath];
    self.endtime = [aDecoder decodeObjectForKey:kSPVideoInfoEndtime];
    self.isActivity = [aDecoder decodeObjectForKey:kSPVideoInfoIsActivity];
    self.smallIds = [aDecoder decodeObjectForKey:kSPVideoInfoSmallIds];
    self.videoCategory = [aDecoder decodeObjectForKey:kSPVideoInfoVideoCategory];
    self.videoId = [aDecoder decodeObjectForKey:kSPVideoInfoVideoId];
    self.middleCover = [aDecoder decodeObjectForKey:kSPVideoInfoMiddleCover];
    self.beSort = [aDecoder decodeObjectForKey:kSPVideoInfoBeSort];
    self.reSort = [aDecoder decodeObjectForKey:kSPVideoInfoReSort];
    self.bigIds = [aDecoder decodeObjectForKey:kSPVideoInfoBigIds];
    self.videofileIds = [aDecoder decodeObjectForKey:kSPVideoInfoVideofileIds];
    self.teacherId = [aDecoder decodeObjectForKey:kSPVideoInfoTeacherId];
    self.tPrice = [aDecoder decodeObjectForKey:kSPVideoInfoTPrice];
    self.videoStrTag = [aDecoder decodeObjectForKey:kSPVideoInfoVideoStrTag];
    self.teachingIds = [aDecoder decodeObjectForKey:kSPVideoInfoTeachingIds];
    self.listingtime = [aDecoder decodeObjectForKey:kSPVideoInfoListingtime];
    self.starttime = [aDecoder decodeObjectForKey:kSPVideoInfoStarttime];
    self.videoIntro = [aDecoder decodeObjectForKey:kSPVideoInfoVideoIntro];
    self.smallCover = [aDecoder decodeObjectForKey:kSPVideoInfoSmallCover];
    self.videoTitle = [aDecoder decodeObjectForKey:kSPVideoInfoVideoTitle];
    self.bigCover = [aDecoder decodeObjectForKey:kSPVideoInfoBigCover];
    self.isOffical = [aDecoder decodeObjectForKey:kSPVideoInfoIsOffical];
    self.qiniuKey = [aDecoder decodeObjectForKey:kSPVideoInfoQiniuKey];
    self.videoAddress = [aDecoder decodeObjectForKey:kSPVideoInfoVideoAddress];
    self.uctime = [aDecoder decodeObjectForKey:kSPVideoInfoUctime];
    self.vPrice = [aDecoder decodeObjectForKey:kSPVideoInfoVPrice];
    self.isTlimit = [aDecoder decodeObjectForKey:kSPVideoInfoIsTlimit];
    self.discount = [aDecoder decodeObjectForKey:kSPVideoInfoDiscount];
    self.limitDiscount = [aDecoder decodeObjectForKey:kSPVideoInfoLimitDiscount];
    self.showTime = [aDecoder decodeObjectForKey:kSPVideoInfoShowTime];
    self.middleIds = [aDecoder decodeObjectForKey:kSPVideoInfoMiddleIds];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_ctime forKey:kSPVideoInfoCtime];
    [aCoder encodeObject:_uid forKey:kSPVideoInfoUid];
    [aCoder encodeObject:_bestRecommend forKey:kSPVideoInfoBestRecommend];
    [aCoder encodeObject:_videoInfoIdentifier forKey:kSPVideoInfoId];
    [aCoder encodeBool:_teachingCover forKey:kSPVideoInfoTeachingCover];
    [aCoder encodeObject:_originalRecommend forKey:kSPVideoInfoOriginalRecommend];
    [aCoder encodeObject:_fullcategorypath forKey:kSPVideoInfoFullcategorypath];
    [aCoder encodeObject:_endtime forKey:kSPVideoInfoEndtime];
    [aCoder encodeObject:_isActivity forKey:kSPVideoInfoIsActivity];
    [aCoder encodeObject:_smallIds forKey:kSPVideoInfoSmallIds];
    [aCoder encodeObject:_videoCategory forKey:kSPVideoInfoVideoCategory];
    [aCoder encodeObject:_videoId forKey:kSPVideoInfoVideoId];
    [aCoder encodeObject:_middleCover forKey:kSPVideoInfoMiddleCover];
    [aCoder encodeObject:_beSort forKey:kSPVideoInfoBeSort];
    [aCoder encodeObject:_reSort forKey:kSPVideoInfoReSort];
    [aCoder encodeObject:_bigIds forKey:kSPVideoInfoBigIds];
    [aCoder encodeObject:_videofileIds forKey:kSPVideoInfoVideofileIds];
    [aCoder encodeObject:_teacherId forKey:kSPVideoInfoTeacherId];
    [aCoder encodeObject:_tPrice forKey:kSPVideoInfoTPrice];
    [aCoder encodeObject:_videoStrTag forKey:kSPVideoInfoVideoStrTag];
    [aCoder encodeObject:_teachingIds forKey:kSPVideoInfoTeachingIds];
    [aCoder encodeObject:_listingtime forKey:kSPVideoInfoListingtime];
    [aCoder encodeObject:_starttime forKey:kSPVideoInfoStarttime];
    [aCoder encodeObject:_videoIntro forKey:kSPVideoInfoVideoIntro];
    [aCoder encodeObject:_smallCover forKey:kSPVideoInfoSmallCover];
    [aCoder encodeObject:_videoTitle forKey:kSPVideoInfoVideoTitle];
    [aCoder encodeObject:_bigCover forKey:kSPVideoInfoBigCover];
    [aCoder encodeObject:_isOffical forKey:kSPVideoInfoIsOffical];
    [aCoder encodeObject:_qiniuKey forKey:kSPVideoInfoQiniuKey];
    [aCoder encodeObject:_videoAddress forKey:kSPVideoInfoVideoAddress];
    [aCoder encodeObject:_uctime forKey:kSPVideoInfoUctime];
    [aCoder encodeObject:_vPrice forKey:kSPVideoInfoVPrice];
    [aCoder encodeObject:_isTlimit forKey:kSPVideoInfoIsTlimit];
    [aCoder encodeObject:_discount forKey:kSPVideoInfoDiscount];
    [aCoder encodeObject:_limitDiscount forKey:kSPVideoInfoLimitDiscount];
    [aCoder encodeObject:_showTime forKey:kSPVideoInfoShowTime];
    [aCoder encodeObject:_middleIds forKey:kSPVideoInfoMiddleIds];
}

- (id)copyWithZone:(NSZone *)zone
{
    SPVideoInfo *copy = [[SPVideoInfo alloc] init];
    
    if (copy) {

        copy.ctime = [self.ctime copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.bestRecommend = [self.bestRecommend copyWithZone:zone];
        copy.videoInfoIdentifier = [self.videoInfoIdentifier copyWithZone:zone];
        copy.teachingCover = self.teachingCover;
        copy.originalRecommend = [self.originalRecommend copyWithZone:zone];
        copy.fullcategorypath = [self.fullcategorypath copyWithZone:zone];
        copy.endtime = [self.endtime copyWithZone:zone];
        copy.isActivity = [self.isActivity copyWithZone:zone];
        copy.smallIds = [self.smallIds copyWithZone:zone];
        copy.videoCategory = [self.videoCategory copyWithZone:zone];
        copy.videoId = [self.videoId copyWithZone:zone];
        copy.middleCover = [self.middleCover copyWithZone:zone];
        copy.beSort = [self.beSort copyWithZone:zone];
        copy.reSort = [self.reSort copyWithZone:zone];
        copy.bigIds = [self.bigIds copyWithZone:zone];
        copy.videofileIds = [self.videofileIds copyWithZone:zone];
        copy.teacherId = [self.teacherId copyWithZone:zone];
        copy.tPrice = [self.tPrice copyWithZone:zone];
        copy.videoStrTag = [self.videoStrTag copyWithZone:zone];
        copy.teachingIds = [self.teachingIds copyWithZone:zone];
        copy.listingtime = [self.listingtime copyWithZone:zone];
        copy.starttime = [self.starttime copyWithZone:zone];
        copy.videoIntro = [self.videoIntro copyWithZone:zone];
        copy.smallCover = [self.smallCover copyWithZone:zone];
        copy.videoTitle = [self.videoTitle copyWithZone:zone];
        copy.bigCover = [self.bigCover copyWithZone:zone];
        copy.isOffical = [self.isOffical copyWithZone:zone];
        copy.qiniuKey = [self.qiniuKey copyWithZone:zone];
        copy.videoAddress = [self.videoAddress copyWithZone:zone];
        copy.uctime = [self.uctime copyWithZone:zone];
        copy.vPrice = [self.vPrice copyWithZone:zone];
        copy.isTlimit = [self.isTlimit copyWithZone:zone];
        copy.discount = [self.discount copyWithZone:zone];
        copy.limitDiscount = [self.limitDiscount copyWithZone:zone];
        copy.showTime = [self.showTime copyWithZone:zone];
        copy.middleIds = [self.middleIds copyWithZone:zone];
    }
    
    return copy;
}


@end
