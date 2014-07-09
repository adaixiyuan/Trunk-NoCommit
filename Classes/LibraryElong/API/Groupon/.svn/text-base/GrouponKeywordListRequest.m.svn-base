//
//  GrouponKeywordListRequest.m
//  ElongClient
//
//  Created by Dawn on 13-6-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponKeywordListRequest.h"
#import "ElongURL.h"
static GrouponKeywordListRequest *request = nil;

@implementation GrouponKeywordListRequest
@synthesize currentCityID;

- (void)dealloc {
	[queue cancelAllOperations];
	[queue release];
    
	[contents release];
	
	self.currentCityID = nil;
	
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
			request = [[GrouponKeywordListRequest alloc] init];
		}
	}
	
	return request;
}


- (void)setCurrentCityID:(NSString *)cityID {
	if (cityID != currentCityID && ![cityID isEqualToString:currentCityID]) {
		[currentCityID release];
		currentCityID = [cityID copy];
		
		// 切换城市时，清空原来搜索过的数据
		[self clearData];
	}
}

#define Cache_GrouponSearch_Suggest_Count 99999   //  暂时不对每个城市的suggest做上限

- (void)saveDataToCache {
    /*
    CacheManage *cManager = [CacheManage manager];
    
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionaryWithDictionary:contents];
    
    if ([contents count] > Cache_GrouponSearch_Suggest_Count) {
        // 如果suggest数量大于最大存储数，只存储最近输入的条件（存入）
        NSArray *sortArray = [[saveDic allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        NSArray *removeArray = [sortArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(Cache_GrouponSearch_Suggest_Count, [saveDic count] - Cache_GrouponSearch_Suggest_Count)]];
        
        [saveDic removeObjectsForKeys:removeArray];
    }
    
    [cManager setHotelSuggests:saveDic forCity:currentCityID];
     */
}


- (void)clearData {
	[contents removeAllObjects];
}


- (void)requestForKeyword:(NSString *)key {
    
	if (![[contents allKeys] containsObject:key] && STRINGHASVALUE(key)) {
		GrouponKeywordRequest *req = [[GrouponKeywordRequest alloc] initWithKeyword:key andCityID:currentCityID];
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
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_KEYWORD_UPDATE object:key];
}


- (NSArray *)getAddressListByKeyword:(NSString *)key {
    /*
    if ([contents count] == 0) {
        // 没有数据时，先尝试从本地缓存内取出数据
        NSDictionary *cacheData = [[CacheManage manager] getHotelSuggestFromCity:currentCityID];
        
        if (DICTIONARYHASVALUE(cacheData)) {
            [contents addEntriesFromDictionary:cacheData];
        }
    }
    */
    
	return [contents safeObjectForKey:key];
}

@end


@interface GrouponKeywordRequest ()

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *cityId;

@end


@implementation GrouponKeywordRequest

@synthesize keyword;
@synthesize cityId;

- (void)dealloc {
	self.keyword = nil;
	self.cityId  = nil;
	
	[super dealloc];
}


- (id)initWithKeyword:(NSString *)key andCityID:(NSString *)cityID {
	if (self = [super init]) {
		self.keyword	= key;
		self.cityId		= cityID;
	}
	
	return self;
}


- (void)main {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [PostHeader header], Resq_Header,
                             cityId , @"CityID",
                             keyword , @"KeyWords", nil];
    
    NSString *request = [[[NSString alloc] initWithFormat:@"action=SearchKeyWordsInfo&compress=true&req=%@", [postDic JSONRepresentationWithURLEncoding]] autorelease];
    
    // 设置请求
    NSURL *url = [NSURL URLWithString:GROUPON_SEARCH];
    NSData *bodyData = [request dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *m_request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    [m_request setHTTPMethod:@"POST"];
    [m_request setHTTPBody:bodyData];
	
	NSURLResponse *response = nil;
	NSError *error;
	NSData *data = [NSURLConnection sendSynchronousRequest:m_request returningResponse:&response error:&error];
	response = nil;
	
    NSDictionary *responseDic = [PublicMethods unCompressData:data];
	NSArray *datas = [responseDic safeObjectForKey:@"HitInfoList"];
    
	if (ARRAYHASVALUE(datas)) {
		[[GrouponKeywordListRequest shared] addAddressList:datas ForKey:keyword];
	}
	
	[pool release];
}

@end
