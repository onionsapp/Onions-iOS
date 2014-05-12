//
//  OCHelpers.m
//  OnionStorage
//
//  Created by Ben Gordon on 8/16/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCHelpers.h"

@implementation OCHelpers

+ (BOOL)emailIsValid:(NSString *)email {
    NSString* pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:email];
}

+ (void)appIsUpToDateWithCompletion:(void (^)(BOOL upToDate))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL versionsMatch = NO;
        NSError *error;
        NSHTTPURLResponse *response;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://itunes.apple.com/en/lookup?bundleId=com.subvertllc.onions"]] returningResponse:&response error:&error];
        
        if (responseData) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            if (json[@"results"][0][@"version"]) {
                CGFloat jsonVersion = [json[@"results"][0][@"version"] floatValue];
                NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                CGFloat thisVersion = [infoDict[@"CFBundleShortVersionString"] floatValue];
                versionsMatch = thisVersion >= jsonVersion;
            }
        }
        
        // Callback
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(versionsMatch);
        });
    });
}

@end
