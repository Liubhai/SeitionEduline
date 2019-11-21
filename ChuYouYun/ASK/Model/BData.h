//
//  BData.h
//
//  Created by 志强 林 on 15/2/12
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *oldPrice;
@property (nonatomic, strong) NSString *discountType;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *learnStatus;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *masterNum;
@property (nonatomic, strong) NSString *orderAlbumId;
@property (nonatomic, strong) NSString *isDel;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *muid;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *percent;
@property (nonatomic, strong) NSString *userNum;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
