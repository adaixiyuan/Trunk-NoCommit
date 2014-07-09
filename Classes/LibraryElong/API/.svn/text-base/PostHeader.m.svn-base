//
//  PostHeader.m
//  ElongClient
//
//  Created by bin xing on 11-1-26.
//  Copyright 2011 DP. All rights reserved.
//

#import "PostHeader.h"

static NSMutableDictionary *header = nil;

@implementation PostHeader
+ (NSMutableDictionary *)header  {
	
	@synchronized(self) {
		if(!header) {
			header = [[NSMutableDictionary alloc] init];
			[header safeSetObject:CHANNELID forKey:@"ChannelId"];
			[header safeSetObject:[PublicMethods macaddress] forKey:@"DeviceId"];
			[header safeSetObject:[NSNull null] forKey:@"AuthCode"];
			[header safeSetObject:[NSNumber numberWithInt:1] forKey:@"ClientType"];
			[header safeSetObject:[[[NSBundle mainBundle] infoDictionary] safeObjectForKey:@"CFBundleVersion"] forKey:@"Version"];
			NSString *osver = [NSString stringWithFormat:@"iphone_%@",[[UIDevice currentDevice] systemVersion]];
			[header safeSetObject:osver forKey:@"OsVersion"];
            
            if (IOSVersion_7) {
                if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
                {
                    NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                    [header safeSetObject:idfaStr forKey:@"Guid"];
                } 
            }
		}
	}
    NSLog(@"header:%@", [header JSONRepresentation]);
    
	return header;
}
@end
