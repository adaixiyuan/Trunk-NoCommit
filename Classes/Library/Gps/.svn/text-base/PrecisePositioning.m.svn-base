//
//  PrecisePositioning.m
//  ElongClient
//
//  Created by bin xing on 11-2-10.
//  Copyright 2011 DP. All rights reserved.
//
#define MESSAGE_START 0
#define MESSAGE_RUN 1
#define MESSAGE_END 2
#define MESSAGE_FAIL 3

#import "PrecisePositioning.h"
#import "PositioningManager.h"
#import "GetCityWithPositioning.h"
#import "Setting.h"
#import "SettingManager.h"


@implementation PrecisePositioning

-(id)init{
	if (self = [super init]) {
        mapView=[[MKMapView alloc] init];
        
        mapView.showsUserLocation = YES;

    }
	
	return self;
}

-(void)sendMessage
{
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
	[NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}


-(void)positioning
{
	while (timeline < 1) {
		NSString *lats1=[NSString stringWithFormat:@"%.1f",mapView.userLocation.coordinate.latitude];
		NSString *lats2=[NSString stringWithFormat:@"%.1f",[[PositioningManager shared] myCoordinate].latitude];
		if ([lats1 floatValue]==[lats2 floatValue]) {				
			[[PositioningManager shared] setGpsing:NO];
			
			[[PositioningManager shared] setMyCoordinate:mapView.userLocation.coordinate];
		}
		timeline++;	
		
		[NSThread sleepForTimeInterval:3];
	}
	[[PositioningManager shared] setGpsing:NO];
	
	mapView=nil;
	[mapView release];
	[self release];
}


-(void)run
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[PositioningManager shared] setGpsing:YES];
	[self positioning];
	[pool release];
}

-(void)excecute{
	[self sendMessage];
}

@end
