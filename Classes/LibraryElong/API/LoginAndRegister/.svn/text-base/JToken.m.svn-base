//
//  JToken.m
//  ElongClient
//
//  Created by Dawn on 14-1-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "JToken.h"

@implementation JToken
- (void) dealloc{
    [contents release];
    [super dealloc];
}

-(void)buildPostData{
	
    [contents safeSetObject:[PostHeader header] forKey:@"Header"];
    [contents safeSetObject:@"" forKey:@"AccessToken"];
    
}

-(id)init{
    self = [super init];
    if (self) {
		
		contents=[[NSMutableDictionary alloc] init];
		
		[self buildPostData];
	}
	return self;
}


-(void)setToken:(NSString *)token{
    [contents safeSetObject:token forKey:@"AccessToken"];
}


-(NSString *)requesString:(BOOL)iscompress{
	return [NSString stringWithFormat:@"action=GetUserInfoByCardNo&version=1.2&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}
@end
