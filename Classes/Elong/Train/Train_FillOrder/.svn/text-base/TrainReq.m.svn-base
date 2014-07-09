//
//  TrainReq.m
//  ElongClient
//
//  Created by 赵 海波 on 13-10-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainReq.h"
#import "StringEncryption.h"
#import "NSString+URLEncoding.h"
#import "TrainTickets.h"
#import "TrainSeats.h"
#import "AccountManager.h"

static TrainReq *request = nil;

@interface TrainReq ()

@end

@implementation TrainReq


- (void)dealloc
{
    SFRelease(request);
    SFRelease(_currentRoute);
    SFRelease(_currentSeat);
    
    [super dealloc];
}


+ (id)shared
{
	@synchronized(request)
    {
		if (!request)
        {
			request = [[TrainReq alloc] init];
		}
	}
	
	return request;
}


- (id)init
{
    if (self = [super init])
    {

	}
    
	return self;
}


- (NSString *)testingOrderDetail
{
    NSString *body = @"{\"wrapperId\":\"ika0000000\",\"orderId\":\"\"}";
    body = [StringEncryption EncryptString:body];
    body = [body URLEncodedString];
    
    NSString *url = [NSString stringWithFormat:@"http://192.168.14.51/mytrain/getOrderDetail?req=%@", body];
    
    return url;
}

- (NSString *)testing
{
    NSString *body = @"{\"isLogin\":true,\"wrapperId\":\"ika0000000\",\"uid\":\"49\",\"CardNo\":\"49\"}";
    body = [StringEncryption EncryptString:body];
    body = [body URLEncodedString];

    NSString *url = [NSString stringWithFormat:@"http://192.168.14.51/myelong/getTrainOrderList?req=%@", body];
    
    return url;
}


- (void)test
{
    NSURL *url = [NSURL URLWithString:@"http://192.168.14.51/myelong/getTrainOrderList?req=qBM7dXOIYJgmNoybj%2fj5k2erKMD57nqR87o3fRfiTDV39e3S2GRYDrUudS4k4VFeOKz7TICqAX9oFyBRJef06g%3d%3d"];
    
    NSMutableURLRequest *m_request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    
    [m_request setValue:@"train" forHTTPHeaderField:@"channelid"];
    [m_request setValue:@"200" forHTTPHeaderField:@"version"];
    [m_request setValue:@"123" forHTTPHeaderField:@"deviceid"];
    [m_request setValue:@"lzss" forHTTPHeaderField:@"compress"];
    //[m_request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [m_request setHTTPMethod:@"GET"];
    //[m_request setHTTPBody:data];
    
    //NSURLResponse *response;
    //NSData *pp = [NSURLConnection sendSynchronousRequest:m_request returningResponse:&response error:nil];
    
    //NSString *string = [[NSString alloc] initWithData:pp encoding:NSUTF8StringEncoding];
	
    //NSDictionary *responseDic = [PublicMethods unCompressData:pp];
    
}


+ (NSString *)submitOrderByPassengers:(NSMutableArray *)passengers mobilePhone:(NSString *)mobile otherData:(TrainCommitOrderAppendData *) otherData
{
    TrainTickets *ticket = [[TrainReq shared] currentRoute];
    TrainDepartStation *departInfo = ticket.departInfo;
    TrainArriveStation *arriveInfo = ticket.arriveInfo;
    
    NSString *uid = nil;
    
    if ([[AccountManager instanse] isLogin])
    {
        // 登陆时，uid传卡号
        uid = [[AccountManager instanse] cardNo];
    }
    else
    {
        // 未登陆时，uid传deviceid
        uid = [PublicMethods macaddress];
    }
    
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content safeSetObject:departInfo.name forKey:k_fromStationName];
	[content safeSetObject:arriveInfo.name forKey:k_toStationName];
    [content safeSetObject:ticket.departDate forKey:k_startDate];
    [content safeSetObject:ticket.number forKey:k_trainNumber];
	[content safeSetObject:passengers forKey:k_passengers];
    
    //app支付
    if ([PublicMethods couldPayByAlipayApp])
    {
        [content safeSetObject:[NSNumber numberWithInt:5] forKey:k_payChannel];
    }
    //网页支付
    else
    {
        [content safeSetObject:[NSNumber numberWithInt:2] forKey:k_payChannel];
    }
    
    [content safeSetObject:uid forKey:k_uid];
    [content safeSetObject:[NSNull null] forKey:k_extra];
	[content safeSetObject:Yihua_OTA forKey:k_wrapperId];
    [content safeSetObject:mobile forKey:k_userMobile];
    
    if (otherData)
    {
        if (otherData.captcha)
        {
            [content safeSetObject:otherData.captcha forKey:k_captcha];
        }
        if (otherData.utoken)
        {
            [content safeSetObject:otherData.utoken forKey:k_utoken];
        }
    }
	
	return [content JSONString];
}


- (void)clearData
{
    self.currentRoute = nil;
    self.currentSeat = nil;
}

@end
