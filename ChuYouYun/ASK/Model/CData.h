//
//  CData.h
//
//  Created by 志强 林 on 15/2/3
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *middleIds;
@property (nonatomic, strong) NSString *bestRecommend;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *originalRecommend;
@property (nonatomic, strong) NSString *fullcategorypath;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic, strong) NSString *videoCommentCount;
@property (nonatomic, strong) NSString *utime;
@property (nonatomic, strong) NSString *isActivity;
@property (nonatomic, strong) NSString *isDel;
@property (nonatomic, strong) NSString *videoScore;
@property (nonatomic, strong) NSString *smallIds;
@property (nonatomic, strong) NSString *videoQuestionCount;
@property (nonatomic, strong) NSString *videoCategory;
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *videoOrderCount;
@property (nonatomic, strong) NSString *beSort;
@property (nonatomic, strong) NSString *reSort;
@property (nonatomic, strong) NSString *bigIds;
@property (nonatomic, strong) NSString *delVideoSaleCount;
@property (nonatomic, strong) NSString *videofileIds;
@property (nonatomic, strong) NSString *tPrice;
@property (nonatomic, strong) NSString *videoTagId;
@property (nonatomic, strong) NSString *videoStrTag;
@property (nonatomic, strong) NSString *teachingIds;
@property (nonatomic, strong) NSString *listingtime;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *videoIntro;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *videoNoteCount;
@property (nonatomic, strong) NSString *videoTitle;
@property (nonatomic, strong) NSString *qiniuKey;
@property (nonatomic, strong) NSString *isOffical;
@property (nonatomic, strong) NSString *teacherId;
@property (nonatomic, strong) NSString *isOriginal;
@property (nonatomic, strong) NSString *videoAddress;
@property (nonatomic, strong) NSString *videoCollectCount;
@property (nonatomic, strong) NSString *uctime;
@property (nonatomic, strong) NSString *vPrice;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *isTlimit;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *showTime;
@property (nonatomic, strong) NSString *limitDiscount;
@property (nonatomic, strong) NSString *iconType;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
