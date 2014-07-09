//
//  JAddCard.h
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostHeader.h"
#import "AccountManager.h"

@interface JAddCard : NSObject {
	NSMutableDictionary *contents;
	NSMutableDictionary *creditCardDictinoary;
	NSMutableDictionary *creditCardType;
}
-(void)clearBuildData;
-(NSString *)requesString:(BOOL)iscompress;

-(void)setHolderName:(NSString *)string;
-(void)setCreditCardTypeName:(NSString *)string;
-(void)setCreditCardTypeID:(NSString *)string;
-(void)setCreditCardNumber:(NSString *)string;
-(void)setExpireYear:(int)year;
-(void)setExpireMonth:(int)Month;
-(void)setCertificateType:(NSNumber *)type;
-(void)setCertificateNumber:(NSString *)string;
-(void)setVerifyCode:(NSString *)string;
-(NSMutableDictionary *)getCard;

@end