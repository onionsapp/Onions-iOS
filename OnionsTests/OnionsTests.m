//
//  OnionsTests.m
//  OnionsTests
//
//  Created by Ben Gordon on 11/19/13.
//  Copyright (c) 2013 BG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCSecurity.h"
#import "XCTestCase+OnionsTestCase.h"
#import "OCSession.h"

@interface OnionsTests : XCTestCase

@end

@implementation OnionsTests

#pragma mark - Behind The Scenes
- (void)setUp
{
    [super setUp];
    
    // Set OCSession Password
    [self setUpOCSession];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)setUpOCSession {
    [OCSession setPassword:@"PASSWORD"];
    
    // New Onions
    Onion *newOnion = [[Onion alloc] init];
    newOnion.onionTitle = @"Hello";
    newOnion.onionInfo = @"World!";
    newOnion.iterations = @(kDefaultIterations);
    [OCSession addOnion:newOnion];
}


#pragma mark - Testing
- (void)testSHA256StretchedIsDifferentThanOnce {
    // Test String
    NSString *testString = @"HelloWorld";
    
    // SHA-256 for one iteration
    NSString *shaOnceString = [[OCSecurity sha256:[testString dataUsingEncoding:NSUTF8StringEncoding]] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    // SHA-256 using the stretched method
    NSString *stretchedShaString = [OCSecurity stretchedCredentialString:testString];
    
    // Test that they are Different
    [self testInequalityOfObject:shaOnceString andObject:stretchedShaString fromMethod:__PRETTY_FUNCTION__];
}

- (void)testEncryptedStringIsDifferent {
    // Test String
    NSString *testString = @"HelloWorld";
    
    // Encrypt It
    NSString *encryptedString = [OCSecurity encryptText:testString];
    
    // Test Inequality
    [self testInequalityOfObject:testString andObject:encryptedString fromMethod:__PRETTY_FUNCTION__];
}

- (void)testStringEncryptsThenDecryptsBackToOriginal {
    // Test String
    NSString *testString = @"HelloWorld";
    
    // Encrypt It
    NSString *encryptedString = [OCSecurity encryptText:testString];
    
    // Decrypt It
    NSString *decryptedString = [OCSecurity decryptText:encryptedString iterations:@(kDefaultIterations)];
    
    // Test Equality
    [self testEqualityOfObject:testString andObject:decryptedString fromMethod:__PRETTY_FUNCTION__];
}

- (void)testDropDataFromOCSession {
    // Drop Data
    [OCSession dropData];
    
    // Test Password is Nil
    [self testEqualityOfObject:[OCSession Password] andObject:nil fromMethod:__PRETTY_FUNCTION__];
    
    // Test Onions is nil
    [self testEqualityOfObject:[OCSession Onions] andObject:nil fromMethod:__PRETTY_FUNCTION__];
    
    // ReInit OCSession Data for future tests
    [self setUpOCSession];
}

- (void)testIncorrectIterationsCount {
    // Test String
    NSString *testString = @"HelloWorld";
    
    // Encrypt It
    NSString *encryptedString = [OCSecurity encryptText:testString];
    
    // Incorrectly Decrypt It
    NSString *decryptedString = [OCSecurity decryptText:encryptedString iterations:@(kDefaultIterations - 1)];
    
    // Test Inequality
    [self testInequalityOfObject:testString andObject:decryptedString fromMethod:__PRETTY_FUNCTION__];
}

@end
