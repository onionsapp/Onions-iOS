//
//  OCHelpers.m
//  OnionStorage
//
//  Created by Ben Gordon on 8/16/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "OCHelpers.h"

@implementation OCHelpers

+ (void)appIsUpToDateWithCompletion:(void (^)(BOOL upToDate))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL versionsMatch = YES;
        NSError *error;
        NSHTTPURLResponse *response;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.onions.io/version"]] returningResponse:&response error:&error];
        
        if (responseData) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            if (json && json[@"version"]) {
                versionsMatch = [json[@"version"] isEqualToString:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
            }
        }
        
        // Callback
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(versionsMatch);
        });
    });
}

@end
