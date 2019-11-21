//
//  NQWdComment.h
//
//  Created by 志强 林 on 15/2/27
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NQWdComment : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *wdCommentIdentifier;
@property (nonatomic, strong) NSString *commentCount;
@property (nonatomic, strong) NSString *wdCommentDescription;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, assign) id fid;
@property (nonatomic, strong) NSString *helpCount;
@property (nonatomic, strong) NSString *isDel;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *wid;
@property (nonatomic, strong) NSString *userface;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
