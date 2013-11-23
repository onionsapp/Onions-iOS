//
//  OCSession.m
//  OnionStorage
//
//  Created by Ben Gordon on 8/11/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCSession.h"
#import "OCSecurity.h"

@implementation OCSession

static OCSession * _mainSession = nil;

#pragma mark - Singleton Creation
+ (OCSession *)mainSession {
	@synchronized([OCSession class]) {
		if (!_mainSession)
            _mainSession  = [[OCSession alloc]init];
		return _mainSession;
	}
	return nil;
}


+ (id)alloc {
	@synchronized([OCSession class]) {
		NSAssert(_mainSession == nil, @"Attempted to allocate a second instance of a singleton.");
		_mainSession = [super alloc];
		return _mainSession;
	}
	return nil;
}


- (id)init {
	if (self = [super init]) {
        // Init Array
        self.OnionData = [NSMutableArray array];
        
        // Satellite Store: Set Identifiers
        [[SatelliteStore shoppingCenter] setProductIdentifiers:@[kProProductID]];
        
        // Satellite Store: Get Prodcuts
        [[SatelliteStore shoppingCenter] getProductsWithCompletion:^(BOOL success) {
            //
        }];
	}
    
	return self;
}


#pragma mark - Drop Data
+ (void)dropData {
    [OCSession mainSession].OnionData = nil;
    [OCSession setPassword:nil];
    [PFUser logOut];
}


#pragma mark - Delete Account
+ (void)deleteAccountWithCompletion:(void (^)(BOOL deleted))completion {
    [PFObject deleteAllInBackground:[OCSession Onions] block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [OCSession dropData];
                }
                completion(succeeded);
            }];
        }
        else {
            completion(NO);
        }
    }];
}


#pragma mark - Onions
+ (Onion *)onionAtIndex:(NSInteger)index {
    return [OCSession mainSession].OnionData[index];
}

+ (void)setOnions:(NSArray *)onions {
    [OCSession mainSession].OnionData = [onions mutableCopy];
}

+ (void)addOnion:(Onion *)onion {
    [[OCSession mainSession].OnionData addObject:onion];
}

+ (void)removeOnion:(Onion *)onion {
    [[OCSession mainSession].OnionData removeObject:onion];
}

+ (NSArray *)Onions {
    return [OCSession mainSession].OnionData;
}

+ (void)loadOnionsWithCompletion:(void (^)(void))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Onion"];
    [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [OCSession setOnions:objects];
        [Onion decryptOnions:[OCSession Onions] withCompletion:completion];
    }];
}


#pragma mark - Password
+ (NSString *)Password {
    return [OCSession mainSession].Password;
}

+ (void)setPassword:(NSString *)pass {
    [OCSession mainSession].Password = pass;
}

#pragma mark - PRO
+ (BOOL)userIsPro {
    return [[PFUser currentUser][@"Pro"] boolValue];
}

+ (BOOL)userCanCreateOnions {
    if (![PFUser currentUser]) {
        return NO;
    }
    
    // Anyone can make an Onion if their total is less than 10
    if ([[OCSession Onions] count] < 10) {
        return YES;
    }
    else {
        // Onions >= 10, user must be Pro
        return [OCSession userIsPro];
    }
}

+ (void)purchaseProWithCompletion:(void (^)(BOOL purchased))completion {
    // If the User is Pro already, return
    if ([OCSession userIsPro]) {
        completion(YES);
        return;
    }
    
    // Use SatelliteStore to buy the product
    [[SatelliteStore shoppingCenter] purchaseProductWithIdentifier:kProProductID withCompletion:^(SKPaymentTransaction *transaction, BOOL success) {
        if (success) {
            [[PFUser currentUser] setValue:@YES forKey:@"Pro"];
            [[PFUser currentUser] setValue:transaction.transactionIdentifier forKey:@"ProReceipt"];
            [[PFUser currentUser] saveInBackground];
        }
        
        completion(success);
    }];
    
    // Purchase the Product
    /*
     [PFPurchase buyProduct:@"com.subvertllc.Onions.Pro" block:^(NSError *error) {
     if (!error) {
     [[PFUser currentUser] setValue:@YES forKey:@"Pro"];
     [[PFUser currentUser] saveInBackground];
     }
     
     if (completion) {
     completion(error ? NO : YES);
     }
     }];
     */
}

/*
+ (void)TEST__purchaseProWithCompletion:(void (^)(BOOL purchased))completion {
    [[PFUser currentUser] setValue:@YES forKey:@"Pro"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(succeeded);
    }];
}
*/

#pragma mark - Login
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [PFUser logInWithUsernameInBackground:[OCSecurity stretchedCredentialString:username] password:[OCSecurity stretchedCredentialString:[password stringByAppendingString:username]] block:^(PFUser *user, NSError *error) {
            if (user) {
                // Set Password
                [[OCSession mainSession] setPassword:password];
                
                // Return Success
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES);
                });
            }
            else {
                // Return Failure
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO);
                });
            }
        }];
    });
}


#pragma mark - Sign Up
+ (void)signUpWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(PFUser *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PFUser *newUser = [PFUser new];
        newUser.username = [OCSecurity stretchedCredentialString:username];
        newUser.password = [OCSecurity stretchedCredentialString:[password stringByAppendingString:username]];
        newUser[@"Pro"] = @(NO);
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // Set Password
                [[OCSession mainSession] setPassword:password];
                
                // Return User Object
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(newUser);
                });
            }
            else {
                // Return NO User Object
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil);
                });
            }
        }];
    });
}


@end
