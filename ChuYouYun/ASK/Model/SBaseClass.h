//
//  SBaseClass.h
//
//  Created by 志强 林 on 15/2/5
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMoneyData;

@interface SBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *bigIds;
@property (nonatomic, strong) NSString *smallIds;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *albumTitle;
@property (nonatomic, strong) NSString *middleIds;
@property (nonatomic, strong) NSString *albumOrderCount;
@property (nonatomic, strong) SMoneyData *moneyData;
@property (nonatomic, assign) double albumScore;
@property (nonatomic, strong) NSString *albumCategory;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *albumVideo;
//@property (nonatomic, assign) BOOL middleIds;
@property (nonatomic, strong) NSString *albumIntro;
@property (nonatomic ,strong) NSString *albumId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
