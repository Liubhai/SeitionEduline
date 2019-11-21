//
//  ATCountInfo.h
//
//  Created by 志强 林 on 15/2/14
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ATCountInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double feedCount;
@property (nonatomic, assign) double favoriteCount;
@property (nonatomic, assign) double checkConnum;
@property (nonatomic, assign) double newFolowerCount;
@property (nonatomic, assign) double weiboCount;
@property (nonatomic, assign) double followingCount;
@property (nonatomic, assign) double checkTotalnum;
@property (nonatomic, assign) double followerCount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
