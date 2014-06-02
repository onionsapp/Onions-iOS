//
//  OCOnion.m
//  OnionStorage
//
//  Created by Ben Gordon on 8/11/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "Onion.h"
#import "OCSession.h"
#import "OCSecurity.h"
#import <Parse/PFObject+Subclass.h>

@implementation Onion
@dynamic onionTitle, onionInfo, userId, iterations, onionVersion;

+ (NSString *)parseClassName {
    return @"Onion";
}

- (void)saveOnionWithCompletion:(SuccessBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *plainTitle = self.onionTitle;
        NSString *plainInfo = self.onionInfo;
        
        self.onionTitle = [OCSecurity encryptText:self.onionTitle];
        self.onionInfo = [OCSecurity encryptText:self.onionInfo];
        self.iterations = @(kOCDefaultIterations);
        self.userId = [PFUser currentUser].objectId;
        self.onionVersion = @(kOCVersionNumber);
        
        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.onionTitle = plainTitle;
            self.onionInfo = plainInfo;
            
            // Operation is finished, call the main queue's completion block
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(succeeded);
            });
        }];
    });
}

- (void)decrypt {
    self.onionTitle = [OCSecurity decryptText:self.onionTitle iterations:self.iterations version:self.onionVersion];
    self.onionInfo = [OCSecurity decryptText:self.onionInfo iterations:self.iterations version:self.onionVersion];
}

+ (void)decryptOnions:(NSArray *)onions withCompletion:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [onions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[Onion class]]) {
                [(Onion *)obj decrypt];
            }
        }];
        
        // Launch Completion on main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    });
}

- (void)update {
    [self refresh];
    [self decrypt];
}

+ (void)updateOnions:(NSArray *)onions {
    [onions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[Onion class]]) {
            [(Onion *)obj update];
        }
    }];
}

 
@end
