//
//  InterOrderDetailRequest.m
//  ElongClient
//
//  Created by Dawn on 13-7-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterOrderDetailRequest.h"
#import "AccountManager.h"


@implementation InterOrderDetailRequest
@synthesize orderNumber;

- (void)dealloc{
    self.orderNumber = nil;
    [super dealloc];
}

- (NSString *)request
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content setValue:self.orderNumber forKey:@"OrderId"];
    [content setValue:[[AccountManager instanse] cardNo] forKey:@"MemberShip"];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	
	return [NSString stringWithFormat:@"action=GetGlobalHotelOrderDetail&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}

- (NSString *)cancelRequest{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content setValue:self.orderNumber forKey:@"OrderID"];
    [content setValue:[[AccountManager instanse] cardNo] forKey:@"MemberShip"];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	
	return [NSString stringWithFormat:@"action=GlobalHotelCancelOrder&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}
@end
