//
//  ISSKitTests.m
//  ISSKitTests
//
//  Created by Matt on 11/7/13.
//  Copyright (c) 2013 Matt Rajca. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ISSTracker.h"

@interface ISSKitTests : XCTestCase

@end

@implementation ISSKitTests

- (void)testTracker {
	[ISSTracker locateISSWithHandler:^(BOOL valid, double lat, double lon) {
		XCTAssertTrue(valid, @"could not retrieve a valid location");
		
		if (valid) {
			NSLog(@"%f %f", lat, lon);
		}
	}];
}

@end
