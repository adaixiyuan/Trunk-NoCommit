/*
 *  DefineError.h
 *  ElongClient
 *
 *  Created by bin xing on 11-3-5.
 *  Copyright 2011 DP. All rights reserved.
 *
 */

#define Resp_IsError @"IsError"
#define Resp_ErrorMessage @"ErrorMessage"

#define Resq_HeaderChannelId @"ChannelId"
#define Resq_HeaderDeviceId @"DeviceId"
#define Resq_HeaderAuthCode @"AuthCode"
#define Resq_HeaderClientType @"ClientType"
#define Resq_CardNo @"CardNo"

#define JSON_NULL	 [NSNull null]
#define JSON_YES	 [NSNumber numberWithBool:YES]
#define JSON_NO	 [NSNumber numberWithBool:NO]
#define EmptyString	 @""
#define Zero	[NSNumber numberWithInt:0]
#define NegativeOne	[NSNumber numberWithInt:-1]
#define ELONGDATE	@"/Date(%.f)/"