//
//  PriceAnnotation.m
//  ElongClient
//
//  Created by bin xing on 11-1-28.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "PriceAnnotation.h"

@implementation PriceAnnotation

@synthesize title;
@synthesize subtitle; 
@synthesize coordinate;
@synthesize hotelid;
@synthesize index;
@synthesize priceStr;
@synthesize starLevel;
@synthesize hotelSpecialType=_hotelSpecialType;
@synthesize truePrice;
@synthesize isUnsigned;

-(void)setCoordinateStruct:(double)r l:(double)l{
	CLLocationCoordinate2D ccld;
	ccld.latitude=r;
	ccld.longitude=l;
	self.coordinate=ccld;
	
}


- (void)dealloc
{
	self.title = nil;
	self.subtitle = nil;
	self.priceStr = nil;
	self.starLevel = nil;
	self.hotelid = nil;
	
    [super dealloc];
}

@end