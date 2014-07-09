//
//  StringFormat.m
//  elong
//
//  Created by Nikoe on 09-12-27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StringFormat.h"


@implementation StringFormat

+ (BOOL)isOnlyContainedNumber:(NSString*)str
{
	for (int i=0; i<[str length]; i++)
	{
		unichar c = [str characterAtIndex:i];
		if (c < '0' || '9' < c)
		{
			return NO;
		}
	}
	
	return YES;
}

+ (BOOL)isOnlyContainedCharacter:(NSString*)str
{
	for (int i=0; i<[str length]; i++)
	{
		unichar c = [str characterAtIndex:i];
		if (c < 'A' || ('Z' < c && c < 'a') || 'z' < c)
		{
			return NO;
		}
	}
	
	return YES;
}

+ (BOOL)isOnlyContainedEnglishName:(NSString*)str
{
	//for (int i=0; i<[str length]; i++)
//	{
//		unichar c = [str characterAtIndex:i];
//		if (c == '/' ||
//			c >= 'A' && c <= 'Z' ||
//			c >= 'a' && c <= 'z')
//		{
//			return YES;
//		}
//	}
//	
//	return NO;
	return [[NSPredicate predicateWithFormat:@"SELF MATCHES '^[A-Za-z\\\\s\\n/]+$'"] evaluateWithObject:str];
}


+ (BOOL)isNameFormat:(NSString *)str {
	return [[NSPredicate predicateWithFormat:@"SELF MATCHES '^[\u4e00-\u9fa5A-Za-z\\\\s\\n/]+$'"] evaluateWithObject:str];
}


+ (BOOL)isContainedNumber:(NSString*)str
{
	for (int i=0; i<[str length]; i++)
	{
		unichar c = [str characterAtIndex:i];
		if ('0' <= c && c <= '9')
		{
			return YES;
		}
	}
	
	return NO;
}

+ (BOOL)isContainedSpecialChar:(NSString*)str
{
	NSString* specialStr = @"!@#$%^&*+|~;[]{}:;.<>?～@#￥％&×……＋|＝〔〕｛｝；《》？";
	for (int i=0; i<[str length]; i++)
	{
		unichar c = [str characterAtIndex:i];
		for (int k=0; k<[specialStr length]; k++)
		{
			if (c == [specialStr characterAtIndex:k])
			{
				return YES;
			}
		}
	}
	
	return NO;
}


+ (BOOL)hotelNameSpecialChar:(NSString *)str
{
	NSString* specialStr = @"!#$%^*+|=\\~`;'[]{}\"':;.<>?～！#￥％^×……＋|＝〔〕｛｝：“；‘《》？";
	for (int i=0; i<[str length]; i++)
	{
		unichar c = [str characterAtIndex:i];
		for (int k=0; k<[specialStr length]; k++)
		{
			if (c == [specialStr characterAtIndex:k])
			{
				return YES;
			}
		}
	}
	
	return NO;
}


+ (BOOL)isContainedIllegalChar:(NSString*)str
{
    if (str == nil && str.length == 0) {
        return NO;
    }
    else if ([str sensitiveWord])
    {
        return YES;
    }
	
	
	return NO;
}

+ (BOOL)isOnlyEnWordAndNum:(NSString *)str {
	if (ENANDNUMISRIGHT(str)) {
		return YES;
	}
	
	return NO;
}

@end
