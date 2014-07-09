//
//  HotelKeywordListRequest.m
//  ElongClient
//
//  Created by 赵 海波 on 12-4-17.
//  Copyright 2012 elong. All rights reserved.
//

#import "HotelKeywordListRequest.h"
#import "ELONGURL.h"


static HotelKeywordListRequest *request = nil;

@implementation HotelKeywordListRequest

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
			request = [[HotelKeywordListRequest alloc] init];
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

#define Cache_HotelSearch_Suggest_Count 99999   //  暂时不对每个城市的suggest做上限

- (void)saveDataToCache {
    CacheManage *cManager = [CacheManage manager];
    
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionaryWithDictionary:contents];
    
    if ([contents count] > Cache_HotelSearch_Suggest_Count) {
        // 如果suggest数量大于最大存储数，只存储最近输入的条件（存入）
        NSArray *sortArray = [[saveDic allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        NSArray *removeArray = [sortArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(Cache_HotelSearch_Suggest_Count, [saveDic count] - Cache_HotelSearch_Suggest_Count)]];
        
        [saveDic removeObjectsForKeys:removeArray];
    }
    
    [cManager setHotelSuggests:saveDic forCity:currentCityID];
}


- (void)clearData {
	[contents removeAllObjects];
}


- (void)requestForKeyword:(NSString *)key {
    
	if (![[contents allKeys] containsObject:key] && STRINGHASVALUE(key)) {
		KeywordRequest *req = [[KeywordRequest alloc] initWithKeyword:key andCityID:currentCityID];
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
    if ([contents count] == 0) {
        // 没有数据时，先尝试从本地缓存内取出数据
        NSDictionary *cacheData = [[CacheManage manager] getHotelSuggestFromCity:currentCityID];
        
        if (DICTIONARYHASVALUE(cacheData)) {
            [contents addEntriesFromDictionary:cacheData];
        }
    }
    
	return [contents safeObjectForKey:key];
}

@end


@interface KeywordRequest ()

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *cityId;

@end


@implementation KeywordRequest

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
                             @"cn" , @"language",
                             [NSNumber numberWithInt:10], @"limit",
                             cityId , @"CityId",
                             keyword , @"Q", nil];
    
    NSString *postStr = [postDic JSONRepresentationWithURLEncoding];
    if (postStr) {
        NSString *request = [[[NSString alloc] initWithFormat:@"action=GetKeyWordsSuggest&compress=true&req=%@", postStr] autorelease];
        
        // 设置请求
        NSURL *url = [NSURL URLWithString:HOTELSEARCH];
        NSData *bodyData = [request dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *m_request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
        [m_request setHTTPMethod:@"POST"];
        [m_request setHTTPBody:bodyData];
        
        NSURLResponse *response = nil;
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:m_request returningResponse:&response error:&error];
        response = nil;
        
        NSDictionary *responseDic = [PublicMethods unCompressData:data];
        NSArray *datas = [responseDic safeObjectForKey:@"SuggestList"];
        
        if (ARRAYHASVALUE(datas)) {
            [[HotelKeywordListRequest shared] addAddressList:datas ForKey:keyword];
        }
        
        [pool release];
    }
}
								   
@end