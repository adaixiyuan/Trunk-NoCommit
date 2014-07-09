//
//  CalendarHelper.m
//  Calendar
//
//  Created by garin on 13-11-27.
//  Copyright (c) 2013年 garin. All rights reserved.
//

#import "CalendarHelper.h"

static CalendarHelper* curCalender;

@implementation CalendarHelper
@synthesize calendar;

+(id) shared
{
    @synchronized(curCalender)
    {
        if (!curCalender)
        {
            curCalender = [[CalendarHelper alloc] init];
            curCalender.calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
            [curCalender.calendar setLocale:[NSLocale currentLocale]];
            [curCalender.calendar setFirstWeekday:startSunday];
        }
        return curCalender;
    }
}

+(void) reset
{
    @synchronized(curCalender)
    {
        if (curCalender) {
            [curCalender release];
            curCalender=nil;
        }
        
        curCalender = [[CalendarHelper alloc] init];
        curCalender.calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
        [curCalender.calendar setLocale:[NSLocale currentLocale]];
        [curCalender.calendar setFirstWeekday:startSunday];
    }
}

-(void) dealloc
{
    self.calendar=nil;
    
    [super dealloc];
}

//本月的第一天
- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date
{
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comps setDay:1];
    return [self.calendar dateFromComponents:comps];
}

//周一，周二，周三。。。
- (NSArray *)getDaysOfTheWeek {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // adjust array depending on which weekday should be first
    NSArray *weekdays = [dateFormatter shortWeekdaySymbols];
    NSUInteger firstWeekdayIndex = [self.calendar firstWeekday] -1;
    if (firstWeekdayIndex > 0)
    {
        weekdays = [[weekdays subarrayWithRange:NSMakeRange(firstWeekdayIndex, 7-firstWeekdayIndex)]
                    arrayByAddingObjectsFromArray:[weekdays subarrayWithRange:NSMakeRange(0,firstWeekdayIndex)]];
    }
    
    [dateFormatter release];
    
    return weekdays;
}

- (int)dayOfWeekForDate:(NSDate *)date
{
    NSDateComponents *comps = [self.calendar components:NSWeekdayCalendarUnit fromDate:date];
    return comps.weekday;
}

-(BOOL)dateIsToday:(NSDate *)date
{
    NSDateComponents *otherDay = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *today = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    return ([today day] == [otherDay day] &&
            [today month] == [otherDay month] &&
            [today year] == [otherDay year] &&
            [today era] == [otherDay era]);
}

-(BOOL)dateIsYesterday:(NSDate *)date
{
    NSDateComponents *otherDay = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *yesterday = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:-(24*3600)]];
    return ([yesterday day] == [otherDay day] &&
            [yesterday month] == [otherDay month] &&
            [yesterday year] == [otherDay year] &&
            [yesterday era] == [otherDay era]);
}

-(BOOL)dateIsEqual:(NSDate *)firstDate secondDate:(NSDate *)secondDate
{
    if(firstDate==nil||secondDate==nil)
        return NO;
    
    NSDateComponents *firstDay = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:firstDate];
    NSDateComponents *secondDay = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:secondDate];
    return ([firstDay day] == [secondDay day] &&
            [firstDay month] == [secondDay month] &&
            [firstDay year] == [secondDay year] &&
            [firstDay era] == [secondDay era]);
}

//-比较日期
- (int) compareDate:(NSDate *)date1 withCheckOutDate:(NSDate *)date2
{
    if(date1==nil||date2==nil)
        return 100;
    
    NSDateComponents *firstDay = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date1];
    NSDateComponents *secondDay = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date2];
    
    int year0 = [firstDay year];
    int year1 = [secondDay year];
    int month0 = [firstDay month];
    int month1 = [secondDay month];
    int day0 = [firstDay day];
    int day1 = [secondDay day];
    
    if (year0 > year1) {
        return 1;
    }else if(year0 == year1){
        if (month0 > month1) {
            return 1;
        }else if(month0 == month1){
            if (day0 > day1) {
                return 1;
            }else if(day0 == day1){
                return 0;
            }else{
                return -1;
            }
        }else{
            return -1;
        }
    }else {
        return -1;
    }
}

//计算相差几天
-(int) getalldays:(NSDate *)checkin withCheckOutDate:(NSDate *)checkout
{
    if(checkin==nil||checkout==nil)
        return 0;
    
    int compareValue=[self compareDate:checkin withCheckOutDate:checkout];
    
    if(compareValue==1||compareValue==0)
    {
        return 0;
    }
    
    NSTimeInterval time=[checkout timeIntervalSinceDate:checkin];
    int days=((int)time)/(3600*24);
    return days;
}

- (int)weekNumberInMonthForDate:(NSDate *)date
{
    NSDateComponents *comps = [self.calendar components:(NSWeekOfMonthCalendarUnit) fromDate:date];
    return comps.weekOfMonth;
}

- (int)numberOfWeeksInMonthContainingDate:(NSDate *)date
{
    return [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (BOOL)dateIsInMonthShowing:(NSDate *)date otherDate:(NSDate *) otherDate
{
    NSDateComponents *comps1 = [self.calendar components:(NSMonthCalendarUnit) fromDate:otherDate];
    NSDateComponents *comps2 = [self.calendar components:(NSMonthCalendarUnit) fromDate:date];
    return comps1.month == comps2.month;
}

- (NSDate *)nextDay:(NSDate *)date
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    NSDate *re=[self.calendar dateByAddingComponents:comps toDate:date options:0];
    [comps release];
    return re;
}

- (NSDate *)preDay:(NSDate *)date
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    NSDate *re=[self.calendar dateByAddingComponents:comps toDate:date options:0];
    [comps release];
    return re;
}

- (NSDate *)nextMonth:(NSDate *)date
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSDate *re=[self.calendar dateByAddingComponents:comps toDate:date options:0];
    [comps release];
    return re;
}

-(NSDate *) addMonth:(NSDate *) date addValue:(int) addValue
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:addValue];
    NSDate *re=[self.calendar dateByAddingComponents:comps toDate:date options:0];
    [comps release];
    return re;
}

- (int)getDayCountOfMonth:(NSDate *) date
{
    NSDate *fromDate = [self firstDayOfMonthContainingDate:date];
    NSDate *toDate = [self nextMonth:fromDate];

    NSDateComponents *comps = [self.calendar components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
    
    return comps.day;
}

-(int) hour:(NSDate *) date
{
    NSDateComponents *components= [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate:date];
    
    return [components hour];
}

-(int) month:(NSDate *) date
{
    NSDateComponents *components= [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    return [components month];
}

-(int) day:(NSDate *) date
{
    NSDateComponents *components= [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    return [components day];
}

-(int) year:(NSDate *) date
{
    NSDateComponents *components= [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    return [components year];
}
@end
