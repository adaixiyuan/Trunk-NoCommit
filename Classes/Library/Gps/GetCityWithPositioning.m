//
//  GetCityWithPositioning.m
//  ElongClient
//
//  Created by bin xing on 11-2-10.
//  Copyright 2011 DP. All rights reserved.
//

#import "GetCityWithPositioning.h"


@implementation GetCityWithPositioning
-(id)init{
	if (self=[super init]) {
		
		reverseGeocoder =[[MKReverseGeocoder alloc] initWithCoordinate:[[PositioningManager shared] myCoordinate]];
		reverseGeocoder.delegate = self;
		[reverseGeocoder start];
	}
	return self;
}

- (void)safeRelease {
	[reverseGeocoder release];
	reverseGeocoder=nil;
	[self release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placeMark
{
    if (!placeMark.locality) {
        [[PositioningManager shared] setCurrentCity:placeMark.administrativeArea];
        NSLog(@"定位地址：%@",placeMark.administrativeArea);
    }else{
        [[PositioningManager shared] setCurrentCity:placeMark.locality];
        NSLog(@"定位地址：%@",placeMark.locality);
    }
	
	[reverseGeocoder cancel];
	[self safeRelease];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	NSLog(@"reverseGeocoderError:%@",[error description]);
}


@end
