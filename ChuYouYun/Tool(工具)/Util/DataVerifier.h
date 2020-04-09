//
//  DataVerifier.h
//  AlixPayDemo
//
//  Created by Jing Wen on 8/2/11.
//

#import <Foundation/Foundation.h>


@protocol DataVerifier

- (NSString *)algorithmName;
- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString;

@end

id<DataVerifier> CreateRSADataVerifier(NSString *publicKey);

