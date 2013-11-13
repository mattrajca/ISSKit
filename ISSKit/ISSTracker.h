//
//  ISSTracker.h
//  ISSKit
//
//  Created by Matt on 11/7/13.
//  Copyright (c) 2013 Matt Rajca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTracker : NSObject

+ (void)locateISSWithHandler:(void(^)(BOOL valid, double lat, double lon))handler;

@end
