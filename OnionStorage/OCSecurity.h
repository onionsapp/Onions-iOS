//
//  OCSecurity.h
//  OnionChat
//
//  Created by Ben Gordon on 8/10/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kStretchedShaIterations 15000

@interface OCSecurity : NSObject

+ (NSString *)encryptText:(NSString *)text;
+ (NSString *)decryptText:(NSString *)text;
+ (NSString *)stretchedCredentialString:(NSString *)credential;

@end

