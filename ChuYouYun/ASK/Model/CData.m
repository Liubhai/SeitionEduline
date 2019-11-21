//
//  CData.m
//
//  Created by 志强 林 on 15/2/3
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "CData.h"


NSString *const kCDataCtime = @"ctime";
NSString *const kCDataUid = @"uid";
NSString *const kCDataMiddleIds = @"middle_ids";
NSString *const kCDataBestRecommend = @"best_recommend";
NSString *const kCDataId = @"id";
NSString *const kCDataOriginalRecommend = @"original_recommend";
NSString *const kCDataFullcategorypath = @"fullcategorypath";
NSString *const kCDataEndtime = @"endtime";
NSString *const kCDataVideoCommentCount = @"video_comment_count";
NSString *const kCDataUtime = @"utime";
NSString *const kCDataIsActivity = @"is_activity";
NSString *const kCDataIsDel = @"is_del";
NSString *const kCDataVideoScore = @"video_score";
NSString *const kCDataSmallIds = @"small_ids";
NSString *const kCDataVideoQuestionCount = @"video_question_count";
NSString *const kCDataVideoCategory = @"video_category";
NSString *const kCDataVideoId = @"video_id";
NSString *const kCDataVideoOrderCount = @"video_order_count";
NSString *const kCDataBeSort = @"be_sort";
NSString *const kCDataReSort = @"re_sort";
NSString *const kCDataBigIds = @"big_ids";
NSString *const kCDataDelVideoSaleCount = @"del_video_sale_count";
NSString *const kCDataVideofileIds = @"videofile_ids";
NSString *const kCDataTPrice = @"t_price";
NSString *const kCDataVideoTagId = @"video_tag_id";
NSString *const kCDataVideoStrTag = @"video_str_tag";
NSString *const kCDataTeachingIds = @"teaching_ids";
NSString *const kCDataListingtime = @"listingtime";
NSString *const kCDataStarttime = @"starttime";
NSString *const kCDataVideoIntro = @"video_intro";
NSString *const kCDataCid = @"cid";
NSString *const kCDataVideoNoteCount = @"video_note_count";
NSString *const kCDataVideoTitle = @"video_title";
NSString *const kCDataQiniuKey = @"qiniu_key";
NSString *const kCDataIsOffical = @"is_offical";
NSString *const kCDataTeacherId = @"teacher_id";
NSString *const kCDataIsOriginal = @"is_original";
NSString *const kCDataVideoAddress = @"video_address";
NSString *const kCDataVideoCollectCount = @"video_collect_count";
NSString *const kCDataUctime = @"uctime";
NSString *const kCDataVPrice = @"v_price";
NSString *const kCDataMoney = @"money";
NSString *const kCDataIsTlimit = @"is_tlimit";
NSString *const kCDataDiscount = @"discount";
NSString *const kCDataShowTime = @"show_time";
NSString *const kCDataLimitDiscount = @"limit_discount";
NSString *const kCDataIconType = @"icon_type";


@interface CData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CData

@synthesize ctime = _ctime;
@synthesize uid = _uid;
@synthesize middleIds = _middleIds;
@synthesize bestRecommend = _bestRecommend;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize originalRecommend = _originalRecommend;
@synthesize fullcategorypath = _fullcategorypath;
@synthesize endtime = _endtime;
@synthesize videoCommentCount = _videoCommentCount;
@synthesize utime = _utime;
@synthesize isActivity = _isActivity;
@synthesize isDel = _isDel;
@synthesize videoScore = _videoScore;
@synthesize smallIds = _smallIds;
@synthesize videoQuestionCount = _videoQuestionCount;
@synthesize videoCategory = _videoCategory;
@synthesize videoId = _videoId;
@synthesize videoOrderCount = _videoOrderCount;
@synthesize beSort = _beSort;
@synthesize reSort = _reSort;
@synthesize bigIds = _bigIds;
@synthesize delVideoSaleCount = _delVideoSaleCount;
@synthesize videofileIds = _videofileIds;
@synthesize tPrice = _tPrice;
@synthesize videoTagId = _videoTagId;
@synthesize videoStrTag = _videoStrTag;
@synthesize teachingIds = _teachingIds;
@synthesize listingtime = _listingtime;
@synthesize starttime = _starttime;
@synthesize videoIntro = _videoIntro;
@synthesize cid = _cid;
@synthesize videoNoteCount = _videoNoteCount;
@synthesize videoTitle = _videoTitle;
@synthesize qiniuKey = _qiniuKey;
@synthesize isOffical = _isOffical;
@synthesize teacherId = _teacherId;
@synthesize isOriginal = _isOriginal;
@synthesize videoAddress = _videoAddress;
@synthesize videoCollectCount = _videoCollectCount;
@synthesize uctime = _uctime;
@synthesize vPrice = _vPrice;
@synthesize money = _money;
@synthesize isTlimit = _isTlimit;
@synthesize discount = _discount;
@synthesize showTime = _showTime;
@synthesize limitDiscount = _limitDiscount;
@synthesize iconType = _iconType;


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
            self.ctime = [self objectOrNilForKey:kCDataCtime fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kCDataUid fromDictionary:dict];
            self.middleIds = [self objectOrNilForKey:kCDataMiddleIds fromDictionary:dict];
            self.bestRecommend = [self objectOrNilForKey:kCDataBestRecommend fromDictionary:dict];
            self.dataIdentifier = [self objectOrNilForKey:kCDataId fromDictionary:dict];
            self.originalRecommend = [self objectOrNilForKey:kCDataOriginalRecommend fromDictionary:dict];
            self.fullcategorypath = [self objectOrNilForKey:kCDataFullcategorypath fromDictionary:dict];
            self.endtime = [self objectOrNilForKey:kCDataEndtime fromDictionary:dict];
            self.videoCommentCount = [self objectOrNilForKey:kCDataVideoCommentCount fromDictionary:dict];
            self.utime = [self objectOrNilForKey:kCDataUtime fromDictionary:dict];
            self.isActivity = [self objectOrNilForKey:kCDataIsActivity fromDictionary:dict];
            self.isDel = [self objectOrNilForKey:kCDataIsDel fromDictionary:dict];
            self.videoScore = [self objectOrNilForKey:kCDataVideoScore fromDictionary:dict];
            self.smallIds = [self objectOrNilForKey:kCDataSmallIds fromDictionary:dict];
            self.videoQuestionCount = [self objectOrNilForKey:kCDataVideoQuestionCount fromDictionary:dict];
            self.videoCategory = [self objectOrNilForKey:kCDataVideoCategory fromDictionary:dict];
            self.videoId = [self objectOrNilForKey:kCDataVideoId fromDictionary:dict];
            self.videoOrderCount = [self objectOrNilForKey:kCDataVideoOrderCount fromDictionary:dict];
            self.beSort = [self objectOrNilForKey:kCDataBeSort fromDictionary:dict];
            self.reSort = [self objectOrNilForKey:kCDataReSort fromDictionary:dict];
            self.bigIds = [self objectOrNilForKey:kCDataBigIds fromDictionary:dict];
            self.delVideoSaleCount = [self objectOrNilForKey:kCDataDelVideoSaleCount fromDictionary:dict];
            self.videofileIds = [self objectOrNilForKey:kCDataVideofileIds fromDictionary:dict];
            self.tPrice = [self objectOrNilForKey:kCDataTPrice fromDictionary:dict];
            self.videoTagId = [self objectOrNilForKey:kCDataVideoTagId fromDictionary:dict];
            self.videoStrTag = [self objectOrNilForKey:kCDataVideoStrTag fromDictionary:dict];
            self.teachingIds = [self objectOrNilForKey:kCDataTeachingIds fromDictionary:dict];
            self.listingtime = [self objectOrNilForKey:kCDataListingtime fromDictionary:dict];
            self.starttime = [self objectOrNilForKey:kCDataStarttime fromDictionary:dict];
            self.videoIntro = [self objectOrNilForKey:kCDataVideoIntro fromDictionary:dict];
            self.cid = [self objectOrNilForKey:kCDataCid fromDictionary:dict];
            self.videoNoteCount = [self objectOrNilForKey:kCDataVideoNoteCount fromDictionary:dict];
            self.videoTitle = [self objectOrNilForKey:kCDataVideoTitle fromDictionary:dict];
            self.qiniuKey = [self objectOrNilForKey:kCDataQiniuKey fromDictionary:dict];
            self.isOffical = [self objectOrNilForKey:kCDataIsOffical fromDictionary:dict];
            self.teacherId = [self objectOrNilForKey:kCDataTeacherId fromDictionary:dict];
            self.isOriginal = [self objectOrNilForKey:kCDataIsOriginal fromDictionary:dict];
            self.videoAddress = [self objectOrNilForKey:kCDataVideoAddress fromDictionary:dict];
            self.videoCollectCount = [self objectOrNilForKey:kCDataVideoCollectCount fromDictionary:dict];
            self.uctime = [self objectOrNilForKey:kCDataUctime fromDictionary:dict];
            self.vPrice = [self objectOrNilForKey:kCDataVPrice fromDictionary:dict];
            self.money = [self objectOrNilForKey:kCDataMoney fromDictionary:dict];
            self.isTlimit = [self objectOrNilForKey:kCDataIsTlimit fromDictionary:dict];
            self.discount = [self objectOrNilForKey:kCDataDiscount fromDictionary:dict];
            self.showTime = [self objectOrNilForKey:kCDataShowTime fromDictionary:dict];
            self.limitDiscount = [self objectOrNilForKey:kCDataLimitDiscount fromDictionary:dict];
            self.iconType = [self objectOrNilForKey:kCDataIconType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.ctime forKey:kCDataCtime];
    [mutableDict setValue:self.uid forKey:kCDataUid];
    [mutableDict setValue:self.middleIds forKey:kCDataMiddleIds];
    [mutableDict setValue:self.bestRecommend forKey:kCDataBestRecommend];
    [mutableDict setValue:self.dataIdentifier forKey:kCDataId];
    [mutableDict setValue:self.originalRecommend forKey:kCDataOriginalRecommend];
    [mutableDict setValue:self.fullcategorypath forKey:kCDataFullcategorypath];
    [mutableDict setValue:self.endtime forKey:kCDataEndtime];
    [mutableDict setValue:self.videoCommentCount forKey:kCDataVideoCommentCount];
    [mutableDict setValue:self.utime forKey:kCDataUtime];
    [mutableDict setValue:self.isActivity forKey:kCDataIsActivity];
    [mutableDict setValue:self.isDel forKey:kCDataIsDel];
    [mutableDict setValue:self.videoScore forKey:kCDataVideoScore];
    [mutableDict setValue:self.smallIds forKey:kCDataSmallIds];
    [mutableDict setValue:self.videoQuestionCount forKey:kCDataVideoQuestionCount];
    [mutableDict setValue:self.videoCategory forKey:kCDataVideoCategory];
    [mutableDict setValue:self.videoId forKey:kCDataVideoId];
    [mutableDict setValue:self.videoOrderCount forKey:kCDataVideoOrderCount];
    [mutableDict setValue:self.beSort forKey:kCDataBeSort];
    [mutableDict setValue:self.reSort forKey:kCDataReSort];
    [mutableDict setValue:self.bigIds forKey:kCDataBigIds];
    [mutableDict setValue:self.delVideoSaleCount forKey:kCDataDelVideoSaleCount];
    [mutableDict setValue:self.videofileIds forKey:kCDataVideofileIds];
    [mutableDict setValue:self.tPrice forKey:kCDataTPrice];
    [mutableDict setValue:self.videoTagId forKey:kCDataVideoTagId];
    [mutableDict setValue:self.videoStrTag forKey:kCDataVideoStrTag];
    [mutableDict setValue:self.teachingIds forKey:kCDataTeachingIds];
    [mutableDict setValue:self.listingtime forKey:kCDataListingtime];
    [mutableDict setValue:self.starttime forKey:kCDataStarttime];
    [mutableDict setValue:self.videoIntro forKey:kCDataVideoIntro];
    [mutableDict setValue:self.cid forKey:kCDataCid];
    [mutableDict setValue:self.videoNoteCount forKey:kCDataVideoNoteCount];
    [mutableDict setValue:self.videoTitle forKey:kCDataVideoTitle];
    [mutableDict setValue:self.qiniuKey forKey:kCDataQiniuKey];
    [mutableDict setValue:self.isOffical forKey:kCDataIsOffical];
    [mutableDict setValue:self.teacherId forKey:kCDataTeacherId];
    [mutableDict setValue:self.isOriginal forKey:kCDataIsOriginal];
    [mutableDict setValue:self.videoAddress forKey:kCDataVideoAddress];
    [mutableDict setValue:self.videoCollectCount forKey:kCDataVideoCollectCount];
    [mutableDict setValue:self.uctime forKey:kCDataUctime];
    [mutableDict setValue:self.vPrice forKey:kCDataVPrice];
    [mutableDict setValue:self.money forKey:kCDataMoney];
    [mutableDict setValue:self.isTlimit forKey:kCDataIsTlimit];
    [mutableDict setValue:self.discount forKey:kCDataDiscount];
    [mutableDict setValue:self.showTime forKey:kCDataShowTime];
    [mutableDict setValue:self.limitDiscount forKey:kCDataLimitDiscount];
    [mutableDict setValue:self.iconType forKey:kCDataIconType];

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

    self.ctime = [aDecoder decodeObjectForKey:kCDataCtime];
    self.uid = [aDecoder decodeObjectForKey:kCDataUid];
    self.middleIds = [aDecoder decodeObjectForKey:kCDataMiddleIds];
    self.bestRecommend = [aDecoder decodeObjectForKey:kCDataBestRecommend];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kCDataId];
    self.originalRecommend = [aDecoder decodeObjectForKey:kCDataOriginalRecommend];
    self.fullcategorypath = [aDecoder decodeObjectForKey:kCDataFullcategorypath];
    self.endtime = [aDecoder decodeObjectForKey:kCDataEndtime];
    self.videoCommentCount = [aDecoder decodeObjectForKey:kCDataVideoCommentCount];
    self.utime = [aDecoder decodeObjectForKey:kCDataUtime];
    self.isActivity = [aDecoder decodeObjectForKey:kCDataIsActivity];
    self.isDel = [aDecoder decodeObjectForKey:kCDataIsDel];
    self.videoScore = [aDecoder decodeObjectForKey:kCDataVideoScore];
    self.smallIds = [aDecoder decodeObjectForKey:kCDataSmallIds];
    self.videoQuestionCount = [aDecoder decodeObjectForKey:kCDataVideoQuestionCount];
    self.videoCategory = [aDecoder decodeObjectForKey:kCDataVideoCategory];
    self.videoId = [aDecoder decodeObjectForKey:kCDataVideoId];
    self.videoOrderCount = [aDecoder decodeObjectForKey:kCDataVideoOrderCount];
    self.beSort = [aDecoder decodeObjectForKey:kCDataBeSort];
    self.reSort = [aDecoder decodeObjectForKey:kCDataReSort];
    self.bigIds = [aDecoder decodeObjectForKey:kCDataBigIds];
    self.delVideoSaleCount = [aDecoder decodeObjectForKey:kCDataDelVideoSaleCount];
    self.videofileIds = [aDecoder decodeObjectForKey:kCDataVideofileIds];
    self.tPrice = [aDecoder decodeObjectForKey:kCDataTPrice];
    self.videoTagId = [aDecoder decodeObjectForKey:kCDataVideoTagId];
    self.videoStrTag = [aDecoder decodeObjectForKey:kCDataVideoStrTag];
    self.teachingIds = [aDecoder decodeObjectForKey:kCDataTeachingIds];
    self.listingtime = [aDecoder decodeObjectForKey:kCDataListingtime];
    self.starttime = [aDecoder decodeObjectForKey:kCDataStarttime];
    self.videoIntro = [aDecoder decodeObjectForKey:kCDataVideoIntro];
    self.cid = [aDecoder decodeObjectForKey:kCDataCid];
    self.videoNoteCount = [aDecoder decodeObjectForKey:kCDataVideoNoteCount];
    self.videoTitle = [aDecoder decodeObjectForKey:kCDataVideoTitle];
    self.qiniuKey = [aDecoder decodeObjectForKey:kCDataQiniuKey];
    self.isOffical = [aDecoder decodeObjectForKey:kCDataIsOffical];
    self.teacherId = [aDecoder decodeObjectForKey:kCDataTeacherId];
    self.isOriginal = [aDecoder decodeObjectForKey:kCDataIsOriginal];
    self.videoAddress = [aDecoder decodeObjectForKey:kCDataVideoAddress];
    self.videoCollectCount = [aDecoder decodeObjectForKey:kCDataVideoCollectCount];
    self.uctime = [aDecoder decodeObjectForKey:kCDataUctime];
    self.vPrice = [aDecoder decodeObjectForKey:kCDataVPrice];
    self.money = [aDecoder decodeObjectForKey:kCDataMoney];
    self.isTlimit = [aDecoder decodeObjectForKey:kCDataIsTlimit];
    self.discount = [aDecoder decodeObjectForKey:kCDataDiscount];
    self.showTime = [aDecoder decodeObjectForKey:kCDataShowTime];
    self.limitDiscount = [aDecoder decodeObjectForKey:kCDataLimitDiscount];
    self.iconType = [aDecoder decodeObjectForKey:kCDataIconType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_ctime forKey:kCDataCtime];
    [aCoder encodeObject:_uid forKey:kCDataUid];
    [aCoder encodeObject:_middleIds forKey:kCDataMiddleIds];
    [aCoder encodeObject:_bestRecommend forKey:kCDataBestRecommend];
    [aCoder encodeObject:_dataIdentifier forKey:kCDataId];
    [aCoder encodeObject:_originalRecommend forKey:kCDataOriginalRecommend];
    [aCoder encodeObject:_fullcategorypath forKey:kCDataFullcategorypath];
    [aCoder encodeObject:_endtime forKey:kCDataEndtime];
    [aCoder encodeObject:_videoCommentCount forKey:kCDataVideoCommentCount];
    [aCoder encodeObject:_utime forKey:kCDataUtime];
    [aCoder encodeObject:_isActivity forKey:kCDataIsActivity];
    [aCoder encodeObject:_isDel forKey:kCDataIsDel];
    [aCoder encodeObject:_videoScore forKey:kCDataVideoScore];
    [aCoder encodeObject:_smallIds forKey:kCDataSmallIds];
    [aCoder encodeObject:_videoQuestionCount forKey:kCDataVideoQuestionCount];
    [aCoder encodeObject:_videoCategory forKey:kCDataVideoCategory];
    [aCoder encodeObject:_videoId forKey:kCDataVideoId];
    [aCoder encodeObject:_videoOrderCount forKey:kCDataVideoOrderCount];
    [aCoder encodeObject:_beSort forKey:kCDataBeSort];
    [aCoder encodeObject:_reSort forKey:kCDataReSort];
    [aCoder encodeObject:_bigIds forKey:kCDataBigIds];
    [aCoder encodeObject:_delVideoSaleCount forKey:kCDataDelVideoSaleCount];
    [aCoder encodeObject:_videofileIds forKey:kCDataVideofileIds];
    [aCoder encodeObject:_tPrice forKey:kCDataTPrice];
    [aCoder encodeObject:_videoTagId forKey:kCDataVideoTagId];
    [aCoder encodeObject:_videoStrTag forKey:kCDataVideoStrTag];
    [aCoder encodeObject:_teachingIds forKey:kCDataTeachingIds];
    [aCoder encodeObject:_listingtime forKey:kCDataListingtime];
    [aCoder encodeObject:_starttime forKey:kCDataStarttime];
    [aCoder encodeObject:_videoIntro forKey:kCDataVideoIntro];
    [aCoder encodeObject:_cid forKey:kCDataCid];
    [aCoder encodeObject:_videoNoteCount forKey:kCDataVideoNoteCount];
    [aCoder encodeObject:_videoTitle forKey:kCDataVideoTitle];
    [aCoder encodeObject:_qiniuKey forKey:kCDataQiniuKey];
    [aCoder encodeObject:_isOffical forKey:kCDataIsOffical];
    [aCoder encodeObject:_teacherId forKey:kCDataTeacherId];
    [aCoder encodeObject:_isOriginal forKey:kCDataIsOriginal];
    [aCoder encodeObject:_videoAddress forKey:kCDataVideoAddress];
    [aCoder encodeObject:_videoCollectCount forKey:kCDataVideoCollectCount];
    [aCoder encodeObject:_uctime forKey:kCDataUctime];
    [aCoder encodeObject:_vPrice forKey:kCDataVPrice];
    [aCoder encodeObject:_money forKey:kCDataMoney];
    [aCoder encodeObject:_isTlimit forKey:kCDataIsTlimit];
    [aCoder encodeObject:_discount forKey:kCDataDiscount];
    [aCoder encodeObject:_showTime forKey:kCDataShowTime];
    [aCoder encodeObject:_limitDiscount forKey:kCDataLimitDiscount];
    [aCoder encodeObject:_iconType forKey:kCDataIconType];
}

- (id)copyWithZone:(NSZone *)zone
{
    CData *copy = [[CData alloc] init];
    
    if (copy) {

        copy.ctime = [self.ctime copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.middleIds = [self.middleIds copyWithZone:zone];
        copy.bestRecommend = [self.bestRecommend copyWithZone:zone];
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.originalRecommend = [self.originalRecommend copyWithZone:zone];
        copy.fullcategorypath = [self.fullcategorypath copyWithZone:zone];
        copy.endtime = [self.endtime copyWithZone:zone];
        copy.videoCommentCount = [self.videoCommentCount copyWithZone:zone];
        copy.utime = [self.utime copyWithZone:zone];
        copy.isActivity = [self.isActivity copyWithZone:zone];
        copy.isDel = [self.isDel copyWithZone:zone];
        copy.videoScore = [self.videoScore copyWithZone:zone];
        copy.smallIds = [self.smallIds copyWithZone:zone];
        copy.videoQuestionCount = [self.videoQuestionCount copyWithZone:zone];
        copy.videoCategory = [self.videoCategory copyWithZone:zone];
        copy.videoId = [self.videoId copyWithZone:zone];
        copy.videoOrderCount = [self.videoOrderCount copyWithZone:zone];
        copy.beSort = [self.beSort copyWithZone:zone];
        copy.reSort = [self.reSort copyWithZone:zone];
        copy.bigIds = [self.bigIds copyWithZone:zone];
        copy.delVideoSaleCount = [self.delVideoSaleCount copyWithZone:zone];
        copy.videofileIds = [self.videofileIds copyWithZone:zone];
        copy.tPrice = [self.tPrice copyWithZone:zone];
        copy.videoTagId = [self.videoTagId copyWithZone:zone];
        copy.videoStrTag = [self.videoStrTag copyWithZone:zone];
        copy.teachingIds = [self.teachingIds copyWithZone:zone];
        copy.listingtime = [self.listingtime copyWithZone:zone];
        copy.starttime = [self.starttime copyWithZone:zone];
        copy.videoIntro = [self.videoIntro copyWithZone:zone];
        copy.cid = [self.cid copyWithZone:zone];
        copy.videoNoteCount = [self.videoNoteCount copyWithZone:zone];
        copy.videoTitle = [self.videoTitle copyWithZone:zone];
        copy.qiniuKey = [self.qiniuKey copyWithZone:zone];
        copy.isOffical = [self.isOffical copyWithZone:zone];
        copy.teacherId = [self.teacherId copyWithZone:zone];
        copy.isOriginal = [self.isOriginal copyWithZone:zone];
        copy.videoAddress = [self.videoAddress copyWithZone:zone];
        copy.videoCollectCount = [self.videoCollectCount copyWithZone:zone];
        copy.uctime = [self.uctime copyWithZone:zone];
        copy.vPrice = [self.vPrice copyWithZone:zone];
        copy.money = [self.money copyWithZone:zone];
        copy.isTlimit = [self.isTlimit copyWithZone:zone];
        copy.discount = [self.discount copyWithZone:zone];
        copy.showTime = [self.showTime copyWithZone:zone];
        copy.limitDiscount = [self.limitDiscount copyWithZone:zone];
        copy.iconType = [self.iconType copyWithZone:zone];
    }
    
    return copy;
}


@end
