//
//  JModifyCard.m
//  ElongClient
//
//  Created by WangHaibin on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JModifyCard.h"

@implementation JModifyCard
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
		[contents safeSetObject:creditCardDictinoary forKey:@"CreditCard"];
	}
}


-(id)init{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] init];
		
		creditCardDictinoary = [[[NSMutableDictionary alloc] init] autorelease];
		creditCardType = [[[NSMutableDictionary alloc] init] autorelease];
		
		[creditCardDictinoary safeSetObject:[[AccountManager instanse] cardNo] forKey:@"ElongCardNo"];
		[creditCardDictinoary safeSetObject:creditCardType forKey:@"CreditCardType"];
		[creditCardDictinoary safeSetObject:@"" forKey:@"CreditCardNumber"];
		[creditCardDictinoary safeSetObject:@"" forKey:@"HolderName"];
		[creditCardDictinoary safeSetObject:@"" forKey:@"VerifyCode"];
		[creditCardDictinoary safeSetObject:[NSNumber numberWithInt:0] forKey:@"CertificateType"];
		[creditCardDictinoary safeSetObject:@"" forKey:@"CertificateNumber"];
		[creditCardDictinoary safeSetObject:[NSNumber numberWithInt:0] forKey:@"ExpireYear"];
		[creditCardDictinoary safeSetObject:[NSNumber numberWithInt:0] forKey:@"ExpireMonth"];
		
		[creditCardType safeSetObject:@"" forKey:@"Id"];
		[creditCardType safeSetObject:[NSNull null] forKey:@"Name"];

		[self clearBuildData];
	}
	return self;
}


-(NSMutableDictionary *)getCard{
	
	NSMutableDictionary *card=[[NSMutableDictionary alloc] initWithDictionary:contents copyItems:YES];
	[card removeObjectForKey:@"Header"];
	
	return [card autorelease];
	
}
-(void)setVerifyCode:(NSString *)string{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:string forKey:@"VerifyCode"];
}

-(void)setHolderName:(NSString *)string{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:string forKey:@"HolderName"];
}

-(void)setCreditCardTypeName:(NSString *)string{
	[[[contents safeObjectForKey:@"CreditCard"] safeObjectForKey:@"CreditCardType"] safeSetObject:string forKey:@"Name"];
}

-(void)setCreditCardTypeID:(NSString *)string{
	[[[contents safeObjectForKey:@"CreditCard"] safeObjectForKey:@"CreditCardType"] safeSetObject:string forKey:@"Id"];
}
-(void)setCreditCardNumber:(NSString *)string{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:string forKey:@"CreditCardNumber"];
}

-(void)setExpireYear:(int)year{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:[NSNumber numberWithInt:year] forKey:@"ExpireYear"];
}

-(void)setExpireMonth:(int)Month{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:[NSNumber numberWithInt:Month] forKey:@"ExpireMonth"];
}

-(void)setCertificateType:(NSNumber *)type{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:type forKey:@"CertificateType"];
}

-(void)setCertificateNumber:(NSString *)string{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:string forKey:@"CertificateNumber"];
}

-(void)clearBuildData{
	[self buildPostData:YES];
}

-(NSString *)requesString:(BOOL)iscompress{
	return [NSString stringWithFormat:@"action=ModifyCreditCard&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
