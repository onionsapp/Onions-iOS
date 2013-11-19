//
//  XCTestCase+OnionsTestCase.h
//  OnionStorage
//
//  Created by Ben Gordon on 11/19/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (OnionsTestCase)

- (void)testEqualityOfObject:(id)obj andObject:(id)obj2 fromMethod:(const char*)method;
- (void)testInequalityOfObject:(id)obj andObject:(id)obj2 fromMethod:(const char*)method;

@end
