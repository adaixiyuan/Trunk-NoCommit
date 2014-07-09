//
//  GDetailRequest.m
//  ElongClient
//  团购详细页面请求
//
//  Created by haibo on 11-11-9.
//  Copyright 2011 elong. All rights reserved.
//

#import "GDetailRequest.h"
#import "AccountManager.h"
#import "PostHeader.h"
#import "GListRequest.h"

static GDetailRequest *request = nil;

@implementation GDetailRequest


- (void)dealloc {
	[contents release];
	[request  release];
	
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[PostHeader header], Resq_Header, nil];
	}
	
	return self;
}


+ (id)shared {
	@synchronized(self) {
		if (!request) {
			request = [[GDetailRequest alloc] init];
		}
	}
	
	return request;
}


- (void)setProdId:(NSString *)prodId {
	[contents safeSetObject:prodId forKey:PRODID_GROUPON];
}


- (NSString *)grouponDetailCompress:(BOOL)animated {
	NSLog(@"request:%@",contents);
//	return [NSString stringWithFormat:@"action=SearchGrouponDetail&compress=%@&req=%@",
//			[NSString stringWithFormat:@"%@",animated ? @"true" : @"false"],
//			[contents JSONRepresentationWithURLEncoding]];
    NSMutableDictionary *tempContent = [NSMutableDictionary dictionaryWithDictionary:contents];
    [tempContent setObject:[NSNumber numberWithBool:YES] forKey:@"IsContainOriginalPhotos"];
    [tempContent setObject:[NSNumber numberWithBool:YES] forKey:@"IsContainStores"];
    [tempContent setObject:[NSNumber numberWithBool:YES] forKey:@"IsContainProductAdditionRelations"];
    [tempContent setObject:[NSNumber numberWithBool:YES] forKey:@"IsContainStoreAdditionRelations"];
    [tempContent setObject:[NSNumber numberWithBool:YES] forKey:@"IsContainCalender"];
    [tempContent safeSetObject:[NSNumber numberWithInt:1] forKey:@"containsStoresType"];
    
    GListRequest *cityListReq	= [GListRequest shared];
    NSString *cityID = [PublicMethods getCityIDWithCity:cityListReq.cityName];
    [tempContent safeSetObject:cityID forKey:@"cityId"];

    return [NSString stringWithFormat:@"action=SearchProductDetail&compress=%@&req=%@",
            [NSString stringWithFormat:@"%@",animated ? @"true" : @"false"],
            [tempContent JSONRepresentationWithURLEncoding]];
}

static NSString *wapPrefix = @"http://m.elong.com/Web4App/Groupon/";

- (NSString *)requestOfGrouponDetail {
	return [NSString stringWithFormat:@"%@Detail?productId=%@&header=%@&ver=2",
			wapPrefix,
			[contents safeObjectForKey:PRODID_GROUPON],
			[[contents safeObjectForKey:Resq_Header] JSONRepresentationWithURLEncoding]];
}


- (NSString *)requestOfHotelIntro {
	return [NSString stringWithFormat:@"%@HotelIntroList?productId=%@&header=%@&ver=2",
			wapPrefix,
			[contents safeObjectForKey:PRODID_GROUPON],
			[[contents safeObjectForKey:Resq_Header] JSONRepresentationWithURLEncoding]];
}


- (NSString *)requestOfComment {
	return [NSString stringWithFormat:@"%@HotelCommentsList?productId=%@&header=%@&ver=2",
			wapPrefix,
			[contents safeObjectForKey:PRODID_GROUPON],
			[[contents safeObjectForKey:Resq_Header] JSONRepresentationWithURLEncoding]];
}


- (NSString *)requestOfMap {
	return [NSString stringWithFormat:@"%@HotelMapList?productId=%@&header=%@",
			wapPrefix,
			[contents safeObjectForKey:PRODID_GROUPON],
			[[contents safeObjectForKey:Resq_Header] JSONRepresentationWithURLEncoding]];
}


@end
