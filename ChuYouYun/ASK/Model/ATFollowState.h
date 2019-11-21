//
//  ATFollowState.h
//
//  Created by 志强 林 on 15/2/14
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ATFollowState : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double following;
@property (nonatomic, assign) double follower;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
