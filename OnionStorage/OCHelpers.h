//
//  OCHelpers.h
//  OnionStorage
//
//  Created by Ben Gordon on 8/16/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCHelpers : NSObject

+ (BOOL)emailIsValid:(NSString *)email;
+ (void)appIsUpToDateWithCompletion:(void (^)(BOOL upToDate))completion;

@end
