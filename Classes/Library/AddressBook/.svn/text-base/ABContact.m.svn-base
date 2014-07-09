//
//  ABContactor.m
//  QuickContacts
//
//  Created by 赵 海波 on 12-8-8.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ABContact.h"
#import "pinyin.h"

#define NO_NAME_IDENTITY		@"#"


@implementation ABContact

@synthesize record;
@synthesize fullName;
@synthesize phoneTic;
@synthesize phoneNumber;
@synthesize isOnlyAPhone;

- (void)dealloc {
	if(record) CFRelease(record);
	
	[fullName release];
	[phoneTic release];
	[phoneNumber release];
	
	[super dealloc];
}


- (id)initWithRef:(ABRecordRef)ref {
	if (self = [super init]) {
		record = CFRetain(ref);
		isOnlyAPhone = YES;
		
		fullName = [[self performSelector:@selector(getFullNameForRecord)] copy];
		if (!fullName || !STRINGHASVALUE(fullName)) {
			fullName = [@"无名称" copy];
		}
	}
	
	return self;
}


- (NSString *)getFirstCharOfPinYinFromString:(NSString *)sourceStr {
	NSString *key = nil;
	if ([sourceStr length] > 0) {
		unichar firstChar = [[sourceStr substringToIndex:1] characterAtIndex:0];
		if (firstChar >= 'A'&&firstChar <= 'Z') {
			key = [NSString stringWithFormat:@"%c",firstChar];
		}
		else if (firstChar >= 'a'&& firstChar <= 'z') {
			firstChar += ('A' - 'a');
			key = [NSString stringWithFormat:@"%c",firstChar];
		}
		else {
			unichar pinyinChar = pinyinFirstLetter(firstChar);
			if (pinyinChar != '#') {
				pinyinChar += ('A' - 'a');
			}
			
			key = [NSString stringWithFormat:@"%c",pinyinChar];
		}
	}
	
	if (!key) {
		key = NO_NAME_IDENTITY;
	}
	return key;
}


- (NSString *)getFullNameForRecord {
	// get names
	NSMutableString *string		= [NSMutableString string];
	NSString *firstName			= [(NSString *) ABRecordCopyValue(record, kABPersonFirstNameProperty) autorelease];
	NSString *lastName			= [(NSString *) ABRecordCopyValue(record, kABPersonLastNameProperty) autorelease];
	NSString *lastNamePhonetic	= [(NSString *) ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty) autorelease];
	NSString *prefixName		= [(NSString *) ABRecordCopyValue(record, kABPersonPrefixProperty) autorelease];
	NSString *suffixName		= [(NSString *) ABRecordCopyValue(record, kABPersonSuffixProperty) autorelease];
	NSString *nickName			= [(NSString *) ABRecordCopyValue(record, kABPersonNicknameProperty) autorelease];
	NSString *middleName		= [(NSString *) ABRecordCopyValue(record, kABPersonMiddleNameProperty) autorelease];
	NSString *organizationName	= [(NSString *) ABRecordCopyValue(record, kABPersonOrganizationProperty) autorelease];
	
	// get phones
	CFTypeRef theProperty = ABRecordCopyValue(record, kABPersonPhoneProperty);
	NSArray *phone = (NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty);
	
	if ([phone count] > 0) {
		[phoneNumber release];
		phoneNumber = [[phone safeObjectAtIndex:0] copy];
		
		if ([phone count] > 1) {
			isOnlyAPhone = NO;
		}
	}
	
	CFRelease(theProperty);
	[phone release];
	
	// get emails
	CFRelease(ABRecordCopyValue(record, kABPersonEmailProperty));
	
	if (firstName || lastName)
	{
		if (prefixName) [string appendFormat:@"%@ ", prefixName];
		if (lastName) [string appendFormat:@"%@ ", lastName];
		if (firstName) [string appendFormat:@"%@ ", firstName];
		if (middleName) [string appendFormat:@"%@", middleName];
		if (suffixName) [string appendFormat:@"%@ ", suffixName];
		if (nickName) [string appendFormat:@"%@ ", nickName];
		if (organizationName) [string appendString:organizationName];
	}
	else {
		// 没有名字的情况，查找电话
		if (phoneNumber) {
			// 只取第一个电话显示
			[string appendString:phoneNumber];
		}
	}
	
	NSString *name = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[phoneTic release];
	if (lastNamePhonetic) {
		// 优先取拼音
		phoneTic = [[self getFirstCharOfPinYinFromString:lastNamePhonetic] copy];
	}
	else if (lastName) {
		// 没有拼音直接取首字母
		phoneTic = [[self getFirstCharOfPinYinFromString:lastName] copy];
	}
	else {
		// 只有电话，没有姓名的情况
		phoneTic = [[self getFirstCharOfPinYinFromString:name] copy];
	}
	
	return name;
}

@end
