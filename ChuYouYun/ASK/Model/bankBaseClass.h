//
//  bankBaseClass.h
//
//  Created by 志强 林 on 15/2/10
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface bankBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *bankofdeposit;
@property (nonatomic, strong) NSString *telNum;
@property (nonatomic, strong) NSString *accountmaster;
@property (nonatomic, strong) NSString *accounttype;
@property (nonatomic, strong) NSString *province;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
