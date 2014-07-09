//
//  JAccount.m
//  ElongClient
//
//  Created by bin xing on 11-1-26.
//  Copyright 2011 DP. All rights reserved.
//

#import "JAccount.h"


@implementation JAccount

@synthesize isSevenDayMember;

-(void)buildPostData:(NSMutableDictionary *)dictionary{
	[dictionary removeObjectForKey:@"IsError"];
	[dictionary removeObjectForKey:@"ErrorMessage"];
	[dictionary removeObjectForKey:@"RegisterDate"];
	[dictionary removeObjectForKey:@"KeepSMSInformed"];
	[dictionary removeObjectForKey:@"KeepEmailInformed"];
	[dictionary removeObjectForKey:@"AuthId"];
	[dictionary removeObjectForKey:@"UserId"];
	[dictionary safeSetObject:[PostHeader header] forKey:@"Header"];
	[dictionary safeSetObject:[[LoginRegisterPostManager instanse] password] forKey:@"Password"];
	[dictionary safeSetObject:[[LoginRegisterPostManager instanse] password] forKey:@"ConfirmPassword"];
	[dictionary safeSetObject:@"" forKey:@"IsDragon_VIP"];
    self.isSevenDayMember = NO;
	
	if (contents!=nil) {
		[contents removeAllObjects];
		[contents release],contents = nil;
	}
	contents = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
	
	// 通知各处登录完成
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HAD_LOGIN object:nil];
}


-(void)clearData{
	[contents removeAllObjects];
	
	[contents release],contents = nil;
	
}
-(NSDictionary *)contents{
	return contents;
}
-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] initWithDictionary:dictionary];
	}
	return self;
}
-(id)init:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
		
	}
	return self;
}

-(NSString *)cardNo{
    if ([contents safeObjectForKey:@"CardNo"]) {
        return [NSString stringWithFormat:@"%@", [contents safeObjectForKey:@"CardNo"]];
    }
    return nil;
}
-(NSString *)name{
	return [contents safeObjectForKey:@"Name"];
}
-(NSString *)sex{
	return [contents safeObjectForKey:@"Sex"];
}
-(NSString *)email{
	return [contents safeObjectForKey:@"Email"];
}
-(NSString *)password{
	return [contents safeObjectForKey:@"Password"];
}
-(NSString *)phoneNo {
	return [contents safeObjectForKey:@"PhoneNo"];
}
-(NSString *)DragonVIP {
	return [contents safeObjectForKey:@"IsDragon_VIP"];
}

-(void)setName:(NSString *)name{
	 [contents safeSetObject:name forKey:@"Name"];
}
-(void)setSex:(NSString *)sex{
	
	 [contents safeSetObject:sex forKey:@"Sex"];
}
-(void)setEmail:(NSString *)email{
	 [contents safeSetObject:email forKey:@"Email"];
}
-(void)setPassword:(NSString *)password{
	 [contents safeSetObject:password forKey:@"Password"];
	[contents safeSetObject:password forKey:@"ConfirmPassword"];
}
-(void)setPhoneNo:(NSString *)phoneNo {
	[contents safeSetObject:phoneNo forKey:@"PhoneNo"];
}
-(void)setDragon_VIP:(NSString *)phoneNo {
	[contents safeSetObject:phoneNo forKey:@"IsDragon_VIP"];
}
-(BOOL)isLogin{
	
	if (contents==nil||[contents safeObjectForKey:@"CardNo"]==nil) {
		return NO;
	}
	
	return YES;
	
}

-(NSString *)requesString:(BOOL)iscompress{
	return [NSString stringWithFormat:@"action=EditProfile&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

-(void) dealloc{
	if(contents){
		[contents release],contents = nil;
	}
	[super dealloc];
}


#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    NSString *receiveString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary *infoDict = [receiveString JSONValue];
    
    int userno = [[infoDict safeObjectForKey:@"UserLever"] intValue];
    [self setDragon_VIP:[NSString stringWithFormat:@"%d",userno]];
    
    if ([[infoDict safeObjectForKey:@"UserLever"] intValue] == 2) {
        // 如果是龙萃会员发送刷新页面的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_LONGVIP object:nil];
    }
}


@end
