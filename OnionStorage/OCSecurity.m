//
//  OCSecurity.m
//  OnionChat
//
//  Created by Ben Gordon on 8/10/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCSecurity.h"
#import "OCSession.h"

@implementation OCSecurity


#pragma mark - RNCryptorSettings
+ (RNCryptorSettings)onionSettingsForVersionNumber:(CGFloat)version iterations:(int)iterations {
    return ({
        RNCryptorSettings settings = version >= 2.0 ? kOCCryptorAES256Settings_V2 : kOCCryptorAES256Settings_V1;
        settings.keySettings.rounds = iterations;
        settings.HMACKeySettings.rounds = iterations;
        settings;
    });
}

#pragma mark - Parse Onions
+ (NSString *)encryptText:(NSString *)text {
    if (![OCSession Password]) {
        return nil;
    }
    
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:[text dataUsingEncoding:NSUTF8StringEncoding] withSettings:[OCSecurity onionSettingsForVersionNumber:kOCVersionNumber iterations:kOCDefaultIterations] password:[OCSession Password] error:&error];
    if (!error) {
        return [encryptedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    return nil;
}

+ (NSString *)decryptText:(NSString *)text iterations:(NSNumber *)iterations version:(NSNumber *)version {
    if (![OCSession Password]) {
        return nil;
    }
    
    NSError *error;
    NSData *decryptedData = [RNDecryptor decryptData:[[NSData alloc] initWithBase64EncodedString:text options:NSDataBase64DecodingIgnoreUnknownCharacters] withSettings:[OCSecurity onionSettingsForVersionNumber:version.floatValue iterations:iterations.intValue] password:[OCSession Password] error:&error];
    if (!error) {
        return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

+ (NSString *)stretchedCredentialString:(NSString *)credential {
    return [[OCSecurity stretchedSHA256String:credential withIterations:kOCStretchedShaIterations] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
}

+ (NSData *)stretchedSHA256String:(NSString *)string withIterations:(NSInteger)count {
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    for (int xx = 0; xx < count; xx++) {
        stringData = [OCSecurity sha256:stringData];
    }
    
    return stringData;
}

+ (NSData *)sha256:(NSData *)dataIn {
    NSMutableData *macOut = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(dataIn.bytes, (int)dataIn.length, macOut.mutableBytes);
    return macOut;
}

@end


