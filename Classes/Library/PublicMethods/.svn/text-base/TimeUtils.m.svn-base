//
//  TimeUtils.m
//  ElongClient
//
//  Created by bin xing on 11-3-19.
//  Copyright 2011 DP. All rights reserved.
//

#import "TimeUtils.h"


@implementation TimeUtils



+(void)setDefaultTimeZoneWithUTC{
	NSTimeZone *tz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	[NSTimeZone setDefaultTimeZone:tz];
}

+(NSDate *)NSStringToNSDate:(NSString *)string  formatter:(NSString *)formatter{
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	[f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [f setDateFormat:formatter];
	//NSString *__string=[[NSString alloc] initWithString:string];
    NSDate *d = [f dateFromString:string];
	//[__string release];
    [f release];
    return d;
}

+(NSDate *)resetNSDate:(NSDate *)date  formatter:(NSString *)formatter{
	NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:dtz];
	[f setDateFormat:formatter];
	NSString* s = [f stringFromDate:date];
	[f setTimeZone:dtz];
	NSDate *d=[f dateFromString:s];
	[f release];
	return d;
	
	
}
+(NSDate *)gmtNSDateToGMT8NSDate:(NSDate *)date formatter:(NSString *)formatter{
	NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:[NSTimeZone systemTimeZone]];
	[f setDateFormat:formatter];
	NSString* s = [f stringFromDate:date];
	[f setTimeZone:dtz];
	NSDate *d=[f dateFromString:s];
	[f release];
	return d;
	
}

+(NSDate *)gmtNSDateToGMT8NSDate:(NSDate *)date{
	NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:[NSTimeZone systemTimeZone]];
	[f setDateFormat:@"yyyy-MM-dd"];
	NSString* s = [f stringFromDate:date];
	[f setTimeZone:dtz];
	NSDate *d=[f dateFromString:s];
	[f release];
	return d;
	
}

+(NSDate *)displayNSStringToGMT8NSDate:(NSString *)s{
	NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];	
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:dtz];
	[f setDateFormat:@"yyyy-MM-dd"];
	NSDate *d=[f dateFromString:s];
	[f release];
	return d;
}
+(NSDate *)displayNSStringToGMT8CNNSDate:(NSString *)s {
	NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];	
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:dtz];
	[f setDateFormat:@"yyyy年MM月"];
	NSDate *d=[f dateFromString:s];
	[f release];
	return d;
}
+(NSString *)dPCalendarDateToString:(NSDate *)date{
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	//[f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[f setDateFormat:@"yyyy-MM-dd"];
	NSString* s = [f stringFromDate:date];
	[f release];
	return s;
}

+(NSString *)displayDateWithNSDate:(NSDate *)date formatter:(NSString *)formatter{
	
	NSTimeZone *tz=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
	//NSTimeZone *tz=[NSTimeZone systemTimeZone];
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:tz];
	[f setDateFormat:formatter];
	NSString* s=[f stringFromDate:date];
	[f release];
	return s;
	
}


+(NSString *)displayDateWithNSTimeInterval:(NSTimeInterval)seconds formatter:(NSString *)formatter{


	return [self displayDateWithNSDate:[NSDate dateWithTimeIntervalSince1970:seconds] formatter:formatter];

}

+(NSString *)displayDateWithJsonDate:(NSString *)jsondate formatter:(NSString *)formatter{
	
	return [self displayDateWithNSDate:[self parseJsonDate:jsondate] formatter:formatter];

}


+ (NSString *)displayNoTimeZoneJsonDate:(NSString *)jsonDate formatter:(NSString *)formatter {
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	NSTimeZone *tz=[NSTimeZone systemTimeZone];
	[format setTimeZone:tz];
	[format setDateFormat:formatter];
	return [format stringFromDate:[self parseJsonDate:jsonDate]];
}


+(NSDate *)parseJsonDate:(NSString *)jsondate{
	
	NSRange range1 = [jsondate rangeOfString:@"/Date("];
	NSRange range2 = [jsondate rangeOfString:@")/"];
	int start=range1.location+range1.length;
	int end=range2.location;
	
	NSCharacterSet* timezoneDelimiter = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
	NSRange rangeOfTimezoneSymbol = [jsondate rangeOfCharacterFromSet:timezoneDelimiter];
	NSTimeInterval interval;
	if (rangeOfTimezoneSymbol.length!=0) {
		int firstend = rangeOfTimezoneSymbol.location;
		
		NSRange secondrange=NSMakeRange(start, firstend-start);
		NSString* timeIntervalString = [jsondate substringWithRange:secondrange];
		
		unsigned long long s = [timeIntervalString longLongValue];
		interval = s/1000;
	}
	else {
		NSRange timerange=NSMakeRange(start, end-start);
		NSString* timestring =[jsondate substringWithRange:timerange];
		unsigned long long t = [timestring longLongValue];
		interval = t/1000;
	}

	return [NSDate dateWithTimeIntervalSince1970:interval];
}


+(NSString *)makeJsonDateWithNSTimeInterval:(NSTimeInterval)seconds{
	
	NSTimeZone *stz=[NSTimeZone systemTimeZone];
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:stz];
	[f setDateFormat:@"Z"];
	NSString *jsondate=[NSString stringWithFormat:@"/Date(%.f%@)/",seconds*1000,[f stringFromDate:[NSDate date]]];
	[f release];

	return jsondate;
}

//C2C 时间
+(NSString *)makeJsonDateWithNSTimeInterval_C2C:(NSTimeInterval)seconds{
	
	NSTimeZone *stz=[NSTimeZone systemTimeZone];
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:stz];
	[f setDateFormat:@"Z"];
	NSString *jsondate=[NSString stringWithFormat:@"/Date(%.f%@)/",seconds,[f stringFromDate:[NSDate date]]];
	[f release];
    
	return jsondate;
}


+(NSString *)makeJsonDateWithUTCDate:(NSDate *)utcDate{
	NSTimeInterval seconds = [utcDate timeIntervalSince1970];
	
	return [self makeJsonDateWithNSTimeInterval:seconds];
}


+(NSString *)makeJsonDateWithDisplayNSStringFormatter:(NSString *)string formatter:(NSString *)formatter {
	
	NSTimeZone *dtz=[NSTimeZone systemTimeZone];	
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:dtz];
	[f setDateFormat:formatter];
	NSDate *d=[f dateFromString:string];
	[f release];

	return [self makeJsonDateWithUTCDate:d];
}


@end
