//
//  ChineseCalendar.h
//  Elong_Shake
//  农历
//  Created by garin on 13-3-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CalendarHelper.h"

@interface ChineseCalendar : NSObject
{
    //内部变量
    NSDate *_date;
    int _cYear;
    int _cMonth;
    int _cDay;
    BOOL _cIsLeapMonth; //当月是否闰月
    BOOL _cIsLeapYear; //当年是否有闰月
}

-(void) makeChiniseCalendar:(NSDate *) dt;
// 计算中国农历节日
-(NSString *) ChineseCalendarHoliday;
-(NSString *) ChineseTwentyFourDay;
-(NSString *) DateHoliday;
@end
