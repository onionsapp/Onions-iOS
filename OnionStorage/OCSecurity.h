//
//  OCSecurity.h
//  OnionChat
//
//  Created by Ben Gordon on 8/10/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "RNCryptor.h"

#define kStretchedShaIterations 15000

@interface OCSecurity : NSObject

+ (NSString *)encryptText:(NSString *)text;
+ (NSString *)decryptText:(NSString *)text iterations:(NSNumber *)iterations;
+ (NSString *)stretchedCredentialString:(NSString *)credential;
+ (NSData *)sha256:(NSData *)dataIn;

@end

