//
//  InterOrderConfirmationLetterRequest.m
//  ElongClient
//
//  Created by 赵岩 on 13-7-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterOrderConfirmationLetterRequest.h"
#import "AccountManager.h"

@implementation InterOrderConfirmationLetterRequest

- (void)dealloc
{
    [_orderNumber release];
    [super dealloc];
}

- (NSString *)request
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content setValue:_orderNumber forKey:@"OrderId"];
    [content setValue:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	
	return [NSString stringWithFormat:@"action=GetConfirmationInfo&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}

@end
