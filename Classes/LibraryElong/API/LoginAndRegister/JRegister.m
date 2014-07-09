//
//  JRegister.m
//  ElongClient
//
//  Created by bin xing on 11-1-26.
//  Copyright 2011 DP. All rights reserved.
//

#import "JRegister.h"


@implementation JRegister
-(void)buildPostData{
	
	[contents safeSetObject:[PostHeader header] forKey:@"Header"];
	[contents safeSetObject:@"" forKey:@"MobileNo"];
	[contents safeSetObject:@"" forKey:@"Password"];
	[contents safeSetObject:@"" forKey:@"ConfirmPassword"];
	
}
-(id)init{
    self = [super init];
    if (self) {
		
		contents=[[NSMutableDictionary alloc] init];
		
		[self buildPostData];
	}
	return self;
}

-(void)setAccount:(NSString *)username password:(NSString *)password{
	[contents safeSetObject:username forKey:@"MobileNo"];
	[contents safeSetObject:password forKey:@"Password"];
	[contents safeSetObject:password forKey:@"ConfirmPassword"];
	
}


-(NSString *)requesString:(BOOL)iscompress{
	COMMONREQUEST(@"%@",[contents JSONRepresentation]);
	return [NSString stringWithFormat:@"action=Regist&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
