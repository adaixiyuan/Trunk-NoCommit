//
//  InterHotelLocationRequest.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelLocationRequest.h"
#import "PostHeader.h"

#define kLocationRequestCityName      @"CityCode"
#define kLocationRequestCountryCode   @"CountryCode"
#define kLocationRequestStateCode     @"StateProvinceCode"

static InterHotelLocationRequest *request = nil;

@implementation InterHotelLocationRequest

+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[InterHotelLocationRequest alloc] init];
		}
	}
	
	return request;
}

- (void)dealloc
{
    [_cityName release];
    [_countryId release];
    [_stateId release];
    [_countryCode release];
    [_locationList release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (NSString *)request
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:@"Header"];
	[content setValue:_cityName forKey:kLocationRequestCityName];
	[content setValue:_countryCode forKey:kLocationRequestCountryCode];
    [content setValue:_stateId forKey:kLocationRequestStateCode];
	
	return [NSString stringWithFormat:@"action=GetGlobalCityLandmark&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}

@end
