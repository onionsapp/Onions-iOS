//
//  OCOnion.h
//  OnionStorage
//
//  Created by Ben Gordon on 8/11/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


typedef void (^SuccessBlock) (BOOL success);

@interface Onion : PFObject <PFSubclassing>

@property (retain) NSString *onionTitle;
@property (retain) NSString *onionInfo;
@property (retain) NSString *userId;

- (void)saveOnionWithCompletion:(SuccessBlock)completion;
- (void)decrypt;
+ (void)decryptOnions:(NSArray *)onions withCompletion:(void (^)(void))completion;
+ (NSString *)parseClassName;
- (void)update;
+ (void)updateOnions:(NSArray *)onions;

// - (instancetype)initWithDictionary:(NSDictionary *)dict;
/*
- (NSDictionary *)encryptedParameters;
+ (OCOnion *)onionFromEncryptedData:(NSDictionary *)encryptedDataDict;
*/

@end
