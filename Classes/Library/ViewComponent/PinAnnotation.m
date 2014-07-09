//
//  PinAnnotation.m
//  ElongClient
//
//  Created by haibo on 11-10-10.
//  Copyright 2011 elong. All rights reserved.
//

#import "PinAnnotation.h"


@implementation PinAnnotation

@synthesize coordinate;
@synthesize subtitle;


- (void)dealloc {
	self.subtitle = nil;
	
	[super dealloc];
}

- (NSString *)title {
	return @"目的地";
}

@end
