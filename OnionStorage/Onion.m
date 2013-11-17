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
@dynamic onionTitle, onionInfo, userId, iterations;

+ (NSString *)parseClassName {
    return @"Onion";
}

- (void)saveOnionWithCompletion:(SuccessBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *plainTitle = self.onionTitle;
        NSString *plainInfo = self.onionInfo;
        
        self.onionTitle = [OCSecurity encryptText:self.onionTitle];
        self.onionInfo = [OCSecurity encryptText:self.onionInfo];
        self.iterations = @(kDefaultIterations);
        self.userId = [PFUser currentUser].objectId;
        
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
    self.onionTitle = [OCSecurity decryptText:self.onionTitle iterations:self.iterations];
    self.onionInfo = [OCSecurity decryptText:self.onionInfo iterations:self.iterations];
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



/*
+ (OCOnion *)onionFromEncryptedData:(NSDictionary *)encryptedDataDict {
    OCOnion *newOnion = [[OCOnion alloc] init];
    
    // Authenticate the message
    if ([encryptedDataDict[@"Title_AuthTag"] isEqualToString:[OCSecurity HMACfromMessage:encryptedDataDict[@"HashedTitle"] key:[kOnionsAuthTag stringByAppendingString:[OCSession Password]] iv:encryptedDataDict[@"Title_Iv"]]] && [encryptedDataDict[@"Info_AuthTag"] isEqualToString:[OCSecurity HMACfromMessage:encryptedDataDict[@"HashedInfo"] key:[kOnionsAuthTag stringByAppendingString:[OCSession Password]] iv:encryptedDataDict[@"Info_Iv"]]]) {
        newOnion.Title = @"Message Authentication Failed";
        newOnion.Info = @"";
        return newOnion;
    }
    
    // Generate AESKey
    NSString *TitleAESKey = [OCSecurity AESKeyForPassword:[OCSession Password] username:[OCSession Username] salt:[encryptedDataDict[@"Title_Salt"] base64EncodedDataWithOptions:0] iterations:[encryptedDataDict[@"Title_Iterations"] intValue]];
    NSString *InfoAESKey = [OCSecurity AESKeyForPassword:[OCSession Password] username:[OCSession Username] salt:[encryptedDataDict[@"Info_Salt"] base64EncodedDataWithOptions:0] iterations:[encryptedDataDict[@"Info_Iterations"] intValue]];
    
    // Decrypt Onion
    NSMutableData *onionTitleData = [[encryptedDataDict[@"HashedTitle"] base64EncodedDataWithOptions:0] mutableCopy];
    NSMutableData *onionInfoData = [[encryptedDataDict[@"HashedInfo"] base64EncodedDataWithOptions:0] mutableCopy];
    [onionTitleData decryptWithKey:TitleAESKey iv:[encryptedDataDict[@"Title_IV"] base64EncodedDataWithOptions:0]];
    [onionInfoData decryptWithKey:InfoAESKey iv:[encryptedDataDict[@"Info_IV"] base64EncodedDataWithOptions:0]];
    
    // Assign values
    newOnion.Title = [[NSString alloc] initWithData:onionTitleData encoding:NSUTF8StringEncoding];
    newOnion.Info = [[NSString alloc] initWithData:onionInfoData encoding:NSUTF8StringEncoding];
    
    return newOnion;
}

- (NSDictionary *)encryptedParameters {
    NSInteger iterations = 20000;
    
    // Generate Title
    NSData *titleSalt = [OCSecurity generateSalt];
    NSData *titleIV = [OCSecurity generateIV];
    NSMutableData *titleData = [[self.Title dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [titleData encryptWithKey:[OCSecurity AESKeyForPassword:[OCSession Password] username:[OCSession Username] salt:titleSalt iterations:iterations] iv:titleIV];
    NSString *base64Title = [titleData base64EncodedStringWithOptions:0];
    NSString *base64TitleIv = [titleIV base64EncodedStringWithOptions:0];
    NSString *base64TitleSalt = [titleSalt base64EncodedStringWithOptions:0];
    NSString *titleHmac = [OCSecurity HMACfromMessage:base64Title key:[kOnionsAuthTag stringByAppendingString:[OCSession Password]] iv:base64TitleIv];
    
    // Generate Info
    NSData *infoSalt = [OCSecurity generateIV];
    NSData *infoIV = [OCSecurity generateIV];
    NSMutableData *infoData = [[self.Info dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [infoData encryptWithKey:[OCSecurity AESKeyForPassword:[OCSession Password] username:[OCSession Username] salt:infoSalt iterations:iterations] iv:infoIV];
    NSString *base64Info = [infoData base64EncodedStringWithOptions:0];
    NSString *base64InfoIv = [infoIV base64EncodedStringWithOptions:0];
    NSString *base64InfoSalt = [infoSalt base64EncodedStringWithOptions:0];
    NSString *infoHmac = [OCSecurity HMACfromMessage:base64Info key:[kOnionsAuthTag stringByAppendingString:[OCSession Password]] iv:base64InfoIv];
    
    NSMutableDictionary *params = [@{@"HashedTitle":base64Title,
                                    @"Title_Salt":base64TitleSalt,
                                    @"Title_Iv":base64TitleIv,
                                    @"Title_AuthTag":titleHmac,
                                    @"HashedInfo":base64Info,
                                    @"Info_Salt":base64InfoSalt,
                                    @"Info_Iv":base64InfoIv,
                                     @"Info_AuthTag":infoHmac} mutableCopy];
    if (self.Id) {
        [params setObject:self.Id forKey:@"Id"];
    }
    
    return params;
}
*/
 
@end
