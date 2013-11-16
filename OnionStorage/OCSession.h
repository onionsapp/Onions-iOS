//
//  OCSession.h
//  OnionStorage
//
//  Created by Ben Gordon on 8/11/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Onion.h"

@interface OCSession : NSObject

// Properties
@property (nonatomic, retain) NSString *Password;
@property (nonatomic, retain) NSMutableArray *OnionData;

// Main Session
+ (OCSession*)mainSession;

// Drop Data
+ (void)dropData;

// Delete Account
+ (void)deleteAccountWithCompletion:(void (^)(BOOL deleted))completion;

// Password
+ (NSString *)Password;
+ (void)setPassword:(NSString *)pass;

// Onions
+ (Onion *)onionAtIndex:(NSInteger)index;
+ (void)addOnion:(Onion *)onion;
+ (void)removeOnion:(Onion *)onion;
+ (void)setOnions:(NSArray *)onions;
+ (NSArray *)Onions;
+ (void)loadOnionsWithCompletion:(void (^)(void))completion;

// Pro
+ (BOOL)userIsPro;
+ (BOOL)userCanCreateOnions;
+ (void)purchaseProWithCompletion:(void (^)(BOOL purchased))completion;

// Login
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL success))completion;

// Sing Up
+ (void)signUpWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(PFUser *user))completion;

@end
