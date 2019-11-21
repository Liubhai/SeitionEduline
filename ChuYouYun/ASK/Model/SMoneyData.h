//
//  SMoneyData.h
//
//  Created by 志强 林 on 15/2/5
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SMoneyData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double discount;
@property (nonatomic, assign) double disType;
@property (nonatomic, assign) double oriPrice;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double disPrice;
@property (nonatomic, assign) double vipPrice;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
