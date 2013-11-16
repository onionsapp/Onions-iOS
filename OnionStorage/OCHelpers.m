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

@end
