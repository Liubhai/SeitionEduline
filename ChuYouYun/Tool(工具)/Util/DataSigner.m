//
//  DataSigner.m
//  AlixPayDemo
//
//  Created by Jing Wen on 8/2/11.
//

#import "DataSigner.h"
#import "RSADataSigner.h"
#import "MD5DataSigner.h"

id<DataSigner> CreateRSADataSigner(NSString *privateKey) {
	
	return [[RSADataSigner alloc] initWithPrivateKey:privateKey];
	
}
