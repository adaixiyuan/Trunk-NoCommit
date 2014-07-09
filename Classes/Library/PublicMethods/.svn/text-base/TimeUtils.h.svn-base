//
//  TimeUtils.h
//  ElongClient
//
//  Created by bin xing on 11-3-19.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeUtils : NSObject {

}
+(void)setDefaultTimeZoneWithUTC;
+(NSDate *)NSStringToNSDate:(NSString *)string  formatter:(NSString *)formatter;
+(NSString *)dPCalendarDateToString:(NSDate *)date;
+(NSDate *)gmtNSDateToGMT8NSDate:(NSDate *)date formatter:(NSString *)formatter;
+(NSString *)displayDateWithNSDate:(NSDate *)date formatter:(NSString *)formatter;
+(NSString *)displayDateWithNSTimeInterval:(NSTimeInterval)seconds formatter:(NSString *)formatter;
+(NSString *)displayDateWithJsonDate:(NSString *)jsondate formatter:(NSString *)formatter;
+(NSDate *)parseJsonDate:(NSString *)jsondate;
+(NSString *)makeJsonDateWithNSTimeInterval:(NSTimeInterval)seconds;
+(NSString *)makeJsonDateWithUTCDate:(NSDate *)utcDate;
+(NSString *)makeJsonDateWithDisplayNSStringFormatter:(NSString *)string formatter:(NSString *)formatter;
+(NSDate *)gmtNSDateToGMT8NSDate:(NSDate *)date;
+(NSDate *)displayNSStringToGMT8NSDate:(NSString *)s;
+(NSDate *)resetNSDate:(NSDate *)date  formatter:(NSString *)formatter;
+(NSDate *)displayNSStringToGMT8CNNSDate:(NSString *)s;
+ (NSString *)displayNoTimeZoneJsonDate:(NSString *)jsonDate formatter:(NSString *)formatter;

//C2C 时间
+(NSString *)makeJsonDateWithNSTimeInterval_C2C:(NSTimeInterval)seconds;
@end
