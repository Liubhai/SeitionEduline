//
//  NQData.h
//
//  Created by 志强 林 on 15/2/27
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NQWdComment;

@interface NQData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *wdDescription;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *recommend;
@property (nonatomic, strong) NSString *tagId;
@property (nonatomic, strong) NSString *wdHelpCount;
@property (nonatomic, strong) NSString *isDel;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *userface;
@property (nonatomic, strong) NQWdComment *wdComment;
@property (nonatomic, strong) NSString *wdCommentCount;
@property (nonatomic, strong) NSString *wdBrowseCount;
@property (nonatomic, strong) NSString *wdTitle;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
