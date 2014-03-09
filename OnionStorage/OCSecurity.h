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

#define kOCStretchedShaIterations 15000
#define kOCDefaultIterations 10000

static const RNCryptorSettings kOCCryptorAES256Settings = {
    .algorithm = kCCAlgorithmAES128,
    .blockSize = kCCBlockSizeAES128,
    .IVSize = kCCBlockSizeAES128,
    .options = kCCOptionPKCS7Padding,
    .HMACAlgorithm = kCCHmacAlgSHA256,
    .HMACLength = CC_SHA256_DIGEST_LENGTH,
    
    .keySettings = {
        .keySize = kCCKeySizeAES256,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA512,
        .rounds = kOCDefaultIterations
    },
    
    .HMACKeySettings = {
        .keySize = kCCKeySizeAES256,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA512,
        .rounds = kOCDefaultIterations
    }
};


@interface OCSecurity : NSObject

+ (NSString *)encryptText:(NSString *)text;
+ (NSString *)decryptText:(NSString *)text iterations:(NSNumber *)iterations;
+ (NSString *)stretchedCredentialString:(NSString *)credential;
+ (NSData *)sha256:(NSData *)dataIn;

@end

