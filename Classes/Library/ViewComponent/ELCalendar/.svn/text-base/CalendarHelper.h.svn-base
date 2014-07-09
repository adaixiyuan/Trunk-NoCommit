//
//  CalendarHelper.h
//  Calendar
//
//  Created by garin on 13-11-27.
//  Copyright (c) 2013年 garin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarHelper : NSObject
//周以什么开始 1：星期天 2：星期一
enum {
    startSunday = 1,
    startMonday = 2,
};
typedef int startDay;

@property (nonatomic,retain) NSCalendar *calendar;

+(id) shared;

//重置
+(void) reset;

- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date;  //日期在月份中的第一天

- (NSArray *)getDaysOfTheWeek;         //得到周日，周一的数组

- (int)dayOfWeekForDate:(NSDate *)date;                //week中的第几天

- (BOOL)dateIsToday:(NSDate *)date;                    //是否今天

- (int)weekNumberInMonthForDate:(NSDate *)date;

- (int)numberOfWeeksInMonthContainingDate:(NSDate *)date;         

- (BOOL)dateIsInMonthShowing:(NSDate *)date otherDate:(NSDate *) otherDate;    //两个日期是否在同一个月

- (NSDate *)nextDay:(NSDate *)date;               //日期的后一天

- (NSDate *)nextMonth:(NSDate *)date;             //得到日期的下个月

- (int)getDayCountOfMonth:(NSDate *) date;        //得到日期所在月有几天

-(NSDate *) addMonth:(NSDate *) date addValue:(int) addValue;      //指定日期增加几个月

-(BOOL)dateIsEqual:(NSDate *)firstDate secondDate:(NSDate *)secondDate;    //两个日期是否相等

- (int) compareDate:(NSDate *)date1 withCheckOutDate:(NSDate *)date2;      //-比较日期

-(int) getalldays:(NSDate *)checkin withCheckOutDate:(NSDate *)checkout;   //两个日期之间间隔多少天

-(BOOL)dateIsYesterday:(NSDate *)date;        //是否是昨天

-(int) hour:(NSDate *) date;                  //得到时间hour

-(int) month:(NSDate *) date;                 //得到时间month

-(int) day:(NSDate *) date;                   //得到时间day

-(int) year:(NSDate *) date;                  //得到时间year

- (NSDate *)preDay:(NSDate *)date;            //前一天
@end
