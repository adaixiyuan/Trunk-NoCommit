//
//  InterHotelSuggestRequest.m
//  ElongClient
//
//  Created by 赵 海波 on 13-7-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelSuggestRequest.h"
#import "PostHeader.h"
#import "ElongURL.h"
#import "InterHotelSearcher.h"

static InterHotelSuggestRequest *request = nil;

@implementation InterHotelSuggestRequest

@synthesize keyWord;

- (void)dealloc {
	[queue cancelAllOperations];
	[queue release];
    
	[contents release];
	
	self.keyWord = nil;
	
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
			request = [[InterHotelSuggestRequest alloc] init];
		}
	}
	
	return request;
}


- (void)clearData {
	[contents removeAllObjects];
}


- (void)requestForKeyword:(NSString *)key {
	if (![[contents allKeys] containsObject:key] &&
        STRINGHASVALUE(key)) {
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        
		InterHotelRequest *req = [[InterHotelRequest alloc] initWithKeyword:key destinationID:searcher.cityId countryCode:searcher.countryId];
		[queue addOperation:req];
		[req release];
	}
}


- (void)addSuggestList:(NSArray *)keyDic ForKey:(NSString *)key {
	@synchronized(contents) {
		[contents safeSetObject:keyDic forKey:key];
		[self performSelectorOnMainThread:@selector(postNotificationWithKey:) withObject:key waitUntilDone:NO];
	}
}


- (void)postNotificationWithKey:(NSString *)key {
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_INTERHOTEL_SUGGEST object:key];
}


- (NSArray *)getSuggestByKeyword:(NSString *)key {
	return [contents safeObjectForKey:key];
}

@end


@interface InterHotelRequest ()

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *destinationID;
@property (nonatomic, copy) NSString *countryCode;

@end


@implementation InterHotelRequest

@synthesize keyword;
@synthesize destinationID;
@synthesize countryCode;

- (void)dealloc {
	self.keyword = nil;
    self.destinationID = nil;
    self.countryCode = nil;
	
	[super dealloc];
}


- (id)initWithKeyword:(NSString *)key destinationID:(NSString *)destID countryCode:(NSString *)code {
	if (self = [super init]) {
		self.keyword = key;
        self.destinationID = destID;
        self.countryCode = code;
	}
	
	return self;
}


- (void)main {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [PostHeader header], Resq_Header,
                             keyword , @"KeyWork",
                             destinationID , @"CityId",
                             countryCode , @"CountryCode",nil];
    
    NSString *request = [[[NSString alloc] initWithFormat:@"action=GlobalHotelAutoSuggest&compress=true&req=%@", [postDic JSONRepresentationWithURLEncoding]] autorelease];
    
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
	NSArray *datas = [responseDic safeObjectForKey:@"SuggestHotelList"];
    if (!ARRAYHASVALUE(datas)) {
        datas = [NSArray array];
    }
    
    [[InterHotelSuggestRequest shared] addSuggestList:datas ForKey:keyword];
	
	[pool release];
}

@end
