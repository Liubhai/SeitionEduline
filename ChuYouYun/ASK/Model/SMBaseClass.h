//
//  SMBaseClass.h
//
//  Created by 志强 林 on 15/2/5
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SMBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *isRead;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, assign) id app;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *appname;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *node;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
