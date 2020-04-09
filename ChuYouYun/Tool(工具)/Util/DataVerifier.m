//
//  DataVerifier.m
//  AlixPayDemo
//
//  Created by Jing Wen on 8/2/11.
//

#import "DataVerifier.h"


#import "RSADataVerifier.h"

id<DataVerifier> CreateRSADataVerifier(NSString *publicKey) {
	
	return [[RSADataVerifier alloc] initWithPublicKey:publicKey];
	
}
