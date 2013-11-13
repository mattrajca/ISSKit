//
//  ISSTracker.m
//  ISSKit
//
//  Created by Matt on 11/7/13.
//  Copyright (c) 2013 Matt Rajca. All rights reserved.
//

#import "ISSTracker.h"

#import "Tle.h"
#import "SGP4.h"

@implementation ISSTracker

+ (void)locateISSWithHandler:(void(^)(BOOL valid, double lat, double lon))handler {
	NSURL *url = [NSURL URLWithString:@"http://spaceflight.nasa.gov/realdata/sightings/SSapplications/Post/JavaSSOP/orbit/ISS/SVPOST.html"];
	
#if TESTING
	
	/* synch request */
	NSData *data = [NSData dataWithContentsOfURL:url];
	
	double lat = 0;
	double lon = 0;
	
	BOOL success = [self getLatLonWithData:data lat:&lat lon:&lon];
	handler(success, lat, lon);
	
#else
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	[NSURLConnection sendAsynchronousRequest:request
									   queue:[NSOperationQueue mainQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
							   
							   double lat = 0;
							   double lon = 0;
							   
							   BOOL success = [self getLatLonWithData:data lat:&lat lon:&lon];
							   handler(success, lat, lon);
							   
						   }];
	
#endif
}

+ (BOOL)getLatLonWithData:(NSData *)data lat:(double *)outLat lon:(double *)outLon {
	if (!data)
		return NO;
	
	NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
	if (!str)
		return NO;
	
	NSScanner *scanner = [[NSScanner alloc] initWithString:str];
	[scanner scanUpToString:@"TWO LINE MEAN ELEMENT SET" intoString:nil];
	[scanner scanString:@"TWO LINE MEAN ELEMENT SET" intoString:nil];
	
	NSString *interesting = nil;
	[scanner scanUpToString:@"Satellite" intoString:&interesting];
	
	if (!interesting)
		return NO;
	
	NSArray *lines = [interesting componentsSeparatedByString:@"\n"];
	
	if ([lines count] < 3)
		return NO;
	
	NSString *oline1 = [[lines objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *oline2 = [[lines objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	std::string line1(oline1.UTF8String);
	std::string line2(oline2.UTF8String);
	
	Tle tle(line1, line2);
	SGP4 sgp4(tle);
	
	DateTime now = DateTime::Now(true);
	Eci eci = sgp4.FindPosition(now);
	CoordGeodetic geo = eci.ToGeodetic();
	
	if (outLat) {
		*outLat = geo.latitude * 180.0 / M_PI;
	}
	
	if (outLon) {
		*outLon = geo.longitude * 180.0 / M_PI;
	}
	
	return YES;
}

@end
