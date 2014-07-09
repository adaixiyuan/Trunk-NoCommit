//
//  JLogin.m
//  ElongClient
//
//  Created by bin xing on 11-1-16.
//  Copyright 2011 DP. All rights reserved.
//

#import "JLogin.h"


@implementation JLogin

-(void)buildPostData{
	
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
		[contents safeSetObject:@"" forKey:@"LoginNo"];
		[contents safeSetObject:@"" forKey:@"Password"];

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
		[contents safeSetObject:username forKey:@"LoginNo"];
		[contents safeSetObject:password forKey:@"Password"];

}


-(NSString *)password{
	return [contents safeObjectForKey:@"Password"];
}

-(NSString *)requesString:(BOOL)iscompress{
	return [NSString stringWithFormat:@"action=login&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
