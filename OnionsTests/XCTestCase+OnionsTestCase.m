//
//  XCTestCase+OnionsTestCase.m
//  OnionStorage
//
//  Created by Ben Gordon on 11/19/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import "XCTestCase+OnionsTestCase.h"

@implementation XCTestCase (OnionsTestCase)


#pragma mark - Test Equality
- (void)testEqualityOfObject:(id)obj andObject:(id)obj2 fromMethod:(const char*)method {
    XCTAssertEqualObjects(obj, obj2, @"Failed: Objects are not equal in method: %s", method);
}


#pragma mark - Test Inequality
- (void)testInequalityOfObject:(id)obj andObject:(id)obj2 fromMethod:(const char*)method {
    XCTAssertNotEqualObjects(obj, obj2, @"Failed: Objects are equal in method: %s", method);
}

@end
