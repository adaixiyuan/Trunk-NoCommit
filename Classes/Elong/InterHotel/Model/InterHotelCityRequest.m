//
//  InterHotelCityRequest.m
//  ElongClient
//  国际酒店城市列表请求
//
//  Created by 赵 海波 on 13-6-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelCityRequest.h"
#import "PostHeader.h"
#import "ElongURL.h"

static InterHotelCityRequest *request = nil;

@implementation InterHotelCityRequest

@synthesize CityKeyWord;

- (void)dealloc {
	[queue cancelAllOperations];
	[queue release];
    
	[contents release];
	
	self.CityKeyWord = nil;
	
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithCapacity:2];
		queue	 = [[NSOperationQueue alloc] init];
	}
	
	return self;
}


#pragma mark -
#pragma mark PublicMethods

+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[InterHotelCityRequest alloc] init];
		}
	}
	
	return request;
}


- (void)clearData {
	[contents removeAllObjects];
}


- (void)requestForKeyword:(NSString *)key {
	if (![[contents allKeys] containsObject:key] && STRINGHASVALUE(key)) {
		CityKeywordRequest *req = [[CityKeywordRequest alloc] initWithKeyword:key];
		[queue addOperation:req];
		[req release];
	}
}


- (void)addAddressList:(NSArray *)keyDic ForKey:(NSString *)key {
	@synchronized(contents) {
		[contents safeSetObject:keyDic forKey:key];
		[self performSelectorOnMainThread:@selector(postNotificationWithKey:) withObject:key waitUntilDone:NO];
	}
}


- (void)postNotificationWithKey:(NSString *)key {
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_INTERCITY_SUGGEST object:key];
}


- (NSArray *)getAddressListByKeyword:(NSString *)key {
	return [contents safeObjectForKey:key];
}

@end


@interface CityKeywordRequest ()

@property (nonatomic, copy) NSString *keyword;

@end


@implementation CityKeywordRequest

@synthesize keyword;

- (void)dealloc {
	self.keyword = nil;
	
	[super dealloc];
}


- (id)initWithKeyword:(NSString *)key {
	if (self = [super init]) {
		self.keyword	= key;
	}
	
	return self;
}


- (void)main {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [PostHeader header], Resq_Header,
                             keyword , @"CityKeyWord", nil];
    NSString *request = [[[NSString alloc] initWithFormat:@"action=GlobalCityAutoSuggest&compress=true&req=%@", [postDic JSONRepresentationWithURLEncoding]] autorelease];
    
    // 设置请求
    NSURL *url = [NSURL URLWithString:INTER_SEARCH];
    NSData *bodyData = [request dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *m_request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    [m_request setHTTPMethod:@"POST"];
    [m_request setHTTPBody:bodyData];
	
	NSURLResponse *response = nil;
	NSError *error;
	NSData *data = [NSURLConnection sendSynchronousRequest:m_request returningResponse:&response error:&error];
	response = nil;
	
    NSDictionary *responseDic = [PublicMethods unCompressData:data];
	NSArray *datas = [responseDic safeObjectForKey:@"SuggestCityList"];
    if (!ARRAYHASVALUE(datas)) {
        datas = [NSArray array];
    }
    
    [[InterHotelCityRequest shared] addAddressList:datas ForKey:keyword];
	
	[pool release];
}

@end