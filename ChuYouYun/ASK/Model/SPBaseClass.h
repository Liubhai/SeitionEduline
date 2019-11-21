//
//  SPBaseClass.h
//
//  Created by 志强 林 on 15/2/12
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPVideoInfo;

@interface SPBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL isBuy;
@property (nonatomic, strong) NSString *tmpId;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, assign) double tlimitState;
@property (nonatomic, strong) SPVideoInfo *videoInfo;
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) double legal;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
