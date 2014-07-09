//
//  ChineseCalendar.m
//  Elong_Shake
//
//  Created by garin on 13-3-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ChineseCalendar.h"
#import "NSDate+Helper.h"

#define MinYear 1900
#define MaxYear 2050

//按公历计算的节日
typedef struct SolarHolidayStruct_Tag
{
    int Month;
    int Day;
    int Recess;
    NSString *HolidayName;
    
}SolarHolidayStruct;

//按农历计算的节日
typedef struct LunarHolidayStruct_Tag
{
    int Month;
    int Day;
    int Recess;
    NSString *HolidayName;
    
}LunarHolidayStruct;

//按星期计算的节日
typedef struct WeekHolidayStruct_Tag
{
    int Month;
    int Day;
    int Recess;
    NSString *HolidayName;
    
}WeekHolidayStruct;


@implementation ChineseCalendar
{
    NSDate *MinDay;
    NSDate *MaxDay;
//    int GanZhiStartYear;
//    NSDate *GanZhiStartDay;
    NSString *HZNum;
//    int AnimalStartYear;
    
    NSMutableArray *LunarDateArray;
//    NSMutableArray *_constellationName;  //星座名称
//    NSMutableArray *_lunarHolidayName;   //二十四节气
    NSMutableArray *SolarTerm;    //节气数据
    NSMutableArray *sTermInfo;
    
    //农历相关数据
//    NSString *ganStr;
//    NSString *zhiStr;
//    NSString *animalStr;
    NSString *nStr1;
    NSString *nStr2;
//    NSMutableArray *_monthString;
//    NSMutableArray *_dayString;
}

-(id) init
{
    if(self=[super init])
    {
        [self initChineseCalendar];
    }
    
    return self;
}

-(void) initChineseCalendar
{
    [self initSomeObjects];
}

//初始化变量
-(void) initSomeObjects
{
    MinDay=[NSDate dateFromString:@"1900-01-30" withFormat:@"yy-MM-dd"];
    [MinDay retain];
    MaxDay=[NSDate dateFromString:@"2049-12-31" withFormat:@"yy-MM-dd"];
    [MaxDay retain];
//    GanZhiStartDay=[NSDate dateFromString:@"1899-12-32" withFormat:@"yy-MM-dd"];//起始日
    HZNum=@"○一二三四五六七八九";
//    AnimalStartYear=1900;//1900年为鼠年
    
    LunarDateArray=[[NSMutableArray alloc] initWithObjects:
                    [NSNumber numberWithInt:0x04BD8],
                    [NSNumber numberWithInt:0x04AE0],
                    [NSNumber numberWithInt:0x0A570],
                    [NSNumber numberWithInt:0x054D5],
                    [NSNumber numberWithInt:0x0D260],
                    [NSNumber numberWithInt:0x0D950],
                    [NSNumber numberWithInt:0x16554],
                    [NSNumber numberWithInt:0x056A0],
                    [NSNumber numberWithInt:0x09AD0],
                    [NSNumber numberWithInt:0x055D2],
                    
                    [NSNumber numberWithInt:0x04AE0],
                    [NSNumber numberWithInt:0x0A5B6],
                    [NSNumber numberWithInt:0x0A4D0],
                    [NSNumber numberWithInt:0x0D250],
                    [NSNumber numberWithInt:0x1D255],
                    [NSNumber numberWithInt:0x0B540],
                    [NSNumber numberWithInt:0x0D6A0],
                    [NSNumber numberWithInt:0x0ADA2],
                    [NSNumber numberWithInt:0x095B0],
                    [NSNumber numberWithInt:0x14977],
                    
                    [NSNumber numberWithInt:0x04970],
                    [NSNumber numberWithInt:0x0A4B0],
                    [NSNumber numberWithInt:0x0B4B5],
                    [NSNumber numberWithInt:0x06A50],
                    [NSNumber numberWithInt:0x06D40],
                    [NSNumber numberWithInt:0x1AB54],
                    [NSNumber numberWithInt:0x02B60],
                    [NSNumber numberWithInt:0x09570],
                    [NSNumber numberWithInt:0x052F2],
                    [NSNumber numberWithInt:0x04970],
                    
                    [NSNumber numberWithInt:0x06566],
                    [NSNumber numberWithInt:0x0D4A0],
                    [NSNumber numberWithInt:0x0EA50],
                    [NSNumber numberWithInt:0x06E95],
                    [NSNumber numberWithInt:0x05AD0],
                    [NSNumber numberWithInt:0x02B60],
                    [NSNumber numberWithInt:0x186E3],
                    [NSNumber numberWithInt:0x092E0],
                    [NSNumber numberWithInt:0x1C8D7],
                    [NSNumber numberWithInt:0x0C950],
                    
                    
                    [NSNumber numberWithInt:0x0D4A0],
                    [NSNumber numberWithInt:0x1D8A6],
                    [NSNumber numberWithInt:0x0B550],
                    [NSNumber numberWithInt:0x056A0],
                    [NSNumber numberWithInt:0x1A5B4],
                    [NSNumber numberWithInt:0x025D0],
                    [NSNumber numberWithInt:0x092D0],
                    [NSNumber numberWithInt:0x0D2B2],
                    [NSNumber numberWithInt:0x0A950],
                    [NSNumber numberWithInt:0x0B557],
                    
                    
                    [NSNumber numberWithInt:0x06CA0],
                    [NSNumber numberWithInt:0x0B550],
                    [NSNumber numberWithInt:0x15355],
                    [NSNumber numberWithInt:0x04DA0],
                    [NSNumber numberWithInt:0x0A5B0],
                    [NSNumber numberWithInt:0x14573],
                    [NSNumber numberWithInt:0x052B0],
                    [NSNumber numberWithInt:0x0A9A8],
                    [NSNumber numberWithInt:0x0E950],
                    [NSNumber numberWithInt:0x06AA0],
                    
                    [NSNumber numberWithInt:0x0AEA6],
                    [NSNumber numberWithInt:0x0AB50],
                    [NSNumber numberWithInt:0x04B60],
                    [NSNumber numberWithInt:0x0AAE4],
                    [NSNumber numberWithInt:0x0A570],
                    [NSNumber numberWithInt:0x05260],
                    [NSNumber numberWithInt:0x0F263],
                    [NSNumber numberWithInt:0x0D950],
                    [NSNumber numberWithInt:0x05B57],
                    [NSNumber numberWithInt:0x056A0],
                    
                    [NSNumber numberWithInt:0x096D0],
                    [NSNumber numberWithInt:0x04DD5],
                    [NSNumber numberWithInt:0x04AD0],
                    [NSNumber numberWithInt:0x0A4D0],
                    [NSNumber numberWithInt:0x0D4D4],
                    [NSNumber numberWithInt:0x0D250],
                    [NSNumber numberWithInt:0x0D558],
                    [NSNumber numberWithInt:0x0B540],
                    [NSNumber numberWithInt:0x0B6A0],
                    [NSNumber numberWithInt:0x195A6],
                    
                    [NSNumber numberWithInt:0x095B0],
                    [NSNumber numberWithInt:0x049B0],
                    [NSNumber numberWithInt:0x0A974],
                    [NSNumber numberWithInt:0x0A4B0],
                    [NSNumber numberWithInt:0x0B27A],
                    [NSNumber numberWithInt:0x06A50],
                    [NSNumber numberWithInt:0x06D40],
                    [NSNumber numberWithInt:0x0AF46],
                    [NSNumber numberWithInt:0x0AB60],
                    [NSNumber numberWithInt:0x09570],
                    
                    [NSNumber numberWithInt:0x04AF5],
                    [NSNumber numberWithInt:0x04970],
                    [NSNumber numberWithInt:0x064B0],
                    [NSNumber numberWithInt:0x074A3],
                    [NSNumber numberWithInt:0x0EA50],
                    [NSNumber numberWithInt:0x06B58],
                    [NSNumber numberWithInt:0x055C0],
                    [NSNumber numberWithInt:0x0AB60],
                    [NSNumber numberWithInt:0x096D5],
                    [NSNumber numberWithInt:0x092E0],
                    
                    
                    [NSNumber numberWithInt:0x0C960],
                    [NSNumber numberWithInt:0x0D954],
                    [NSNumber numberWithInt:0x0D4A0],
                    [NSNumber numberWithInt:0x0DA50],
                    [NSNumber numberWithInt:0x07552],
                    [NSNumber numberWithInt:0x056A0],
                    [NSNumber numberWithInt:0x0ABB7],
                    [NSNumber numberWithInt:0x025D0],
                    [NSNumber numberWithInt:0x092D0],
                    [NSNumber numberWithInt:0x0CAB5],
                    
                    
                    [NSNumber numberWithInt:0x0A950],
                    [NSNumber numberWithInt:0x0B4A0],
                    [NSNumber numberWithInt:0x0BAA4],
                    [NSNumber numberWithInt:0x0AD50],
                    [NSNumber numberWithInt:0x055D9],
                    [NSNumber numberWithInt:0x04BA0],
                    [NSNumber numberWithInt:0x0A5B0],
                    [NSNumber numberWithInt:0x15176],
                    [NSNumber numberWithInt:0x052B0],
                    [NSNumber numberWithInt:0x0A930],
                    
                    
                    [NSNumber numberWithInt:0x07954],
                    [NSNumber numberWithInt:0x06AA0],
                    [NSNumber numberWithInt:0x0AD50],
                    [NSNumber numberWithInt:0x05B52],
                    [NSNumber numberWithInt:0x04B60],
                    [NSNumber numberWithInt:0x0A6E6],
                    [NSNumber numberWithInt:0x0A4E0],
                    [NSNumber numberWithInt:0x0D260],
                    [NSNumber numberWithInt:0x0EA65],
                    [NSNumber numberWithInt:0x0D530],
                    
                    
                    [NSNumber numberWithInt:0x05AA0],
                    [NSNumber numberWithInt:0x076A3],
                    [NSNumber numberWithInt:0x096D0],
                    [NSNumber numberWithInt:0x04BD7],
                    [NSNumber numberWithInt:0x04AD0],
                    [NSNumber numberWithInt:0x0A4D0],
                    [NSNumber numberWithInt:0x1D0B6],
                    [NSNumber numberWithInt:0x0D250],
                    [NSNumber numberWithInt:0x0D520],
                    [NSNumber numberWithInt:0x0DD45],
                    
                    
                    [NSNumber numberWithInt:0x0B5A0],
                    [NSNumber numberWithInt:0x056D0],
                    [NSNumber numberWithInt:0x055B2],
                    [NSNumber numberWithInt:0x049B0],
                    [NSNumber numberWithInt:0x0A577],
                    [NSNumber numberWithInt:0x0A4B0],
                    [NSNumber numberWithInt:0x0AA50],
                    [NSNumber numberWithInt:0x1B255],
                    [NSNumber numberWithInt:0x06D20],
                    [NSNumber numberWithInt:0x0ADA0],
                    
                    [NSNumber numberWithInt:0x14B63],nil];
                    
//    _constellationName=[[NSMutableArray alloc] initWithObjects:@"白羊座", @"金牛座", @"双子座",
//                        @"巨蟹座", @"狮子座", @"处女座",
//                        @"天秤座", @"天蝎座", @"射手座",
//                        @"摩羯座", @"水瓶座", @"双鱼座", nil];
    
//    _lunarHolidayName=[[NSMutableArray alloc] initWithObjects:@"小寒", @"大寒", @"立春", @"雨水",
//                       @"惊蛰", @"春分", @"清明", @"谷雨",
//                       @"立夏", @"小满", @"芒种", @"夏至",
//                       @"小暑", @"大暑", @"立秋", @"处暑",
//                       @"白露", @"秋分", @"寒露", @"霜降",
//                       @"立冬", @"小雪", @"大雪", @"冬至", nil];
    
    SolarTerm=[[NSMutableArray alloc] initWithObjects:@"小寒", @"大寒", @"立春", @"雨水", @"惊蛰", @"春分",
               @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分",
               @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至", nil];
    
    sTermInfo=[[NSMutableArray alloc] initWithObjects:
               [NSNumber numberWithInt:0],
               [NSNumber numberWithInt:21208],
               [NSNumber numberWithInt:42467],
               [NSNumber numberWithInt:63836],
               [NSNumber numberWithInt:85337],
               [NSNumber numberWithInt:107014],
               [NSNumber numberWithInt:128867],
               [NSNumber numberWithInt:150921],
               [NSNumber numberWithInt:173149],
               [NSNumber numberWithInt:195551],
               [NSNumber numberWithInt:218072],
               [NSNumber numberWithInt:240693],
               [NSNumber numberWithInt:263343],
               [NSNumber numberWithInt:285989],
               [NSNumber numberWithInt:308563],
               [NSNumber numberWithInt:331033],
               [NSNumber numberWithInt:353350],
               [NSNumber numberWithInt:375494],
               [NSNumber numberWithInt:397447],
               [NSNumber numberWithInt:419210],
               [NSNumber numberWithInt:440795],
               [NSNumber numberWithInt:462224],
               [NSNumber numberWithInt:483532],
               [NSNumber numberWithInt:504758],nil
               ];
    
//    ganStr = @"甲乙丙丁戊己庚辛壬癸";
//    zhiStr = @"子丑寅卯辰巳午未申酉戌亥";
//    animalStr = @"鼠牛虎兔龙蛇马羊猴鸡狗猪";
    nStr1 = @"日一二三四五六七八九";
    nStr2 = @"初十廿卅";
//    _monthString =[[NSMutableArray alloc] initWithObjects:@"出错",@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",
//                   @"七月",@"八月",@"九月",@"十月",@"十一月",@"腊月", nil];
    
//    _dayString=[[NSMutableArray alloc] initWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",
//                @"初六",@"初七",@"初八","初九","初十",
//                "十一","十二","十三","十四","十五",
//                "十六","十七","十八","十九","二十",
//                "廿一","廿二","廿三","廿四","廿五",
//                "廿六","廿七","廿八","廿九","三十", nil];
}

//检测输入的公历
-(BOOL) CheckDateLimit:(NSDate *) dt
{
    CalendarHelper *helper = [CalendarHelper shared];
    int re1= [helper compareDate:dt withCheckOutDate:MinDay];
    int re2= [helper compareDate:dt withCheckOutDate:MaxDay];
    
    if (re1<0 || re2>0)
    {
        return false;
    }
    
    return true;
}


//制作农历
-(void) makeChiniseCalendar:(NSDate *) dt
{
    int i;
    int leap;
    int temp;
    int offset;
    
    
//    if(![self CheckDateLimit:dt])
//    {
//        return;
//    }
    
    _date = dt;
    
    
    
    //农历日期计算部分
    temp = 0;
    
    CalendarHelper *helper = [CalendarHelper shared];
    
    offset=[helper getalldays:MinDay withCheckOutDate:_date];
    
    for (i = MinYear; i <= MaxYear; i++)
    {
        temp = [self GetChineseYearDays:i];  //求当年农历年天数
        if (offset - temp < 1)
            break;
        else
        {
            offset = offset - temp;
        }
    }
    _cYear = i;
    
    leap = [self GetChineseLeapMonth:_cYear];//计算该年闰哪个月
    //设定当年是否有闰月
    if (leap > 0)
    {
        _cIsLeapYear = true;
    }
    else
    {
        _cIsLeapYear = false;
    }
    
    _cIsLeapMonth = false;
    for (i = 1; i <= 12; i++)
    {
        //闰月
        if ((leap > 0) && (i == leap + 1) && (_cIsLeapMonth == false))
        {
            _cIsLeapMonth = true;
            i = i - 1;
            temp = [self GetChineseLeapMonthDays:_cYear]; //计算闰月天数
        }
        else
        {
            _cIsLeapMonth = false;
            temp =[self GetChineseMonthDays:_cYear month:i];//计算非闰月天数
        }
        
        
        
        offset = offset - temp;
        if (offset <= 0) break;
    }
    
    
    
    offset = offset + temp;
    _cMonth = i;
    _cDay = offset;

}

//按公历日计算的节日
-(NSString *) DateHoliday
{
    const int sHolidayInfoLength=7;
    SolarHolidayStruct sHolidayInfo[7]=
    {
        {1, 1, 1, @"元 旦"},
        {2, 14, 0,@"情人节"},
        {3, 8, 0, @"妇女节"},
        {5, 1, 1, @"劳动节"},
        {10, 1, 1, @"国庆节"},
        {12, 24, 0, @"平安夜"},
        {12, 25, 0, @"圣诞节"}
    };
    
    NSString *tempStr = @"";
    
    CalendarHelper *helper = [CalendarHelper shared];
    
    for (int i=0; i<sHolidayInfoLength; i++)
    {
        SolarHolidayStruct sh=(SolarHolidayStruct)sHolidayInfo[i];
        if ((sh.Month == [helper month:_date]) && (sh.Day == [helper day:_date]))
        {
            tempStr = sh.HolidayName;
            break;
        }
    }
    return tempStr;
}




//取农历年一年的天数
-(int) GetChineseYearDays:(int) year
{
    int i, f, sumDay, info;
    
    
    
    sumDay = 348; //29天 X 12个月
    i = 0x8000;
    info = [[LunarDateArray objectAtIndex:(year - MinYear)] intValue] & 0x0FFFF;
    
    
    
    //计算12个月中有多少天为30天
    for (int m = 0; m < 12; m++)
    {
        f = info & i;
        if (f != 0)
        {
            sumDay++;
        }
        i = i >> 1;
    }
    return sumDay + [self GetChineseLeapMonthDays:year];
}

//传回农历 y年闰月的天数
-(int) GetChineseLeapMonthDays:(int) year
{
    if ([self GetChineseLeapMonth:year] != 0)
    {
        if (([[LunarDateArray objectAtIndex:(year - MinYear)] intValue] & 0x10000) != 0)
        {
            return 30;
        }
        else
        {
            return 29;
        }
    }
    else
    {
        return 0;
    }
}

//传回农历 y年闰哪个月 1-12 , 没闰传回 0
-(int) GetChineseLeapMonth:(int) year
{
    return [[LunarDateArray objectAtIndex:(year - MinYear)] intValue] & 0xF;
}

//传回农历 y年m月的总天数
-(int) GetChineseMonthDays:(int) year month:(int) month
{
    if([self BitTest32:[[LunarDateArray objectAtIndex:(year - MinYear)] intValue] bitpostion: (16 - month)])
    {
        return 30;
    }
    else
    {
        return 29;
    }
}

//测试某位是否为真
-(BOOL) BitTest32:(int)num bitpostion:(int)bitpostion
{
    if ((bitpostion > 31) || (bitpostion < 0))
        return false;
    
    
    
    int bit = 1 << bitpostion;
    
    
    
    if ((num & bit) == 0)
    {
        return false;
    }
    else
    {
        return true;
    }
}

// 计算中国农历节日
-(NSString *) ChineseCalendarHoliday
{
    const int lHolidayInfoLenght=8;
    
    LunarHolidayStruct lHolidayInfo[8]=
    {
        {1, 1, 1,@"春 节"},
        {1, 15, 0,@"元宵节"},
        {5, 5, 0,@"端午节"},
        {7, 7, 0,@"七 夕"},
        {8, 15, 0,@"中秋节"},
        {9, 9, 0,@"重阳节"},
        {12, 8, 0,@"腊 八"},
        {12, 23, 0,@"小 年"}
    };
    
    NSString *tempStr = @"";
    if (_cIsLeapMonth == false) //闰月不计算节日
    {
        for (int i=0; i<lHolidayInfoLenght; i++)
        {
            LunarHolidayStruct lh=(LunarHolidayStruct)lHolidayInfo[i];
            if ((lh.Month == _cMonth) && (lh.Day == _cDay))
            {
                tempStr = lh.HolidayName;
                break;
            }
        }
        
        //对除夕进行特别处理
        if (_cMonth == 12)
        {
            int i = [self GetChineseMonthDays:_cYear month:12]; //计算当年农历12月的总天数
            if (_cDay == i) //如果为最后一天
            {
                tempStr = @"除 夕";
            }
        }
    }
    return tempStr;
}

/// 定气法计算二十四节气,二十四节气是按地球公转来计算的，并非是阴历计算的
/// </summary>
/// <remarks>
/// 节气的定法有两种。古代历法采用的称为"恒气"，即按时间把一年等分为24份，
/// 每一节气平均得15天有余，所以又称"平气"。现代农历采用的称为"定气"，即
/// 按地球在轨道上的位置为标准，一周360°，两节气之间相隔15°。由于冬至时地
/// 球位于近日点附近，运动速度较快，因而太阳在黄道上移动15°的时间不到15天。
/// 夏至前后的情况正好相反，太阳在黄道上移动较慢，一个节气达16天之多。采用
/// 定气时可以保证春、秋两分必然在昼夜平分的那两天。
-(NSString *) ChineseTwentyFourDay
{
    NSDate *baseDateAndTime =[NSDate dateFromString:@"1900-01-06 02:05:00" withFormat:@"yy-MM-dd hh:mm:ss"];//#1/6/1900 2:05:00 AM#
    NSDate *newDate;
    double num;
    int y;
    NSString *tempStr = @"";
    
    CalendarHelper *helper = [CalendarHelper shared];
    
    y = [helper year:_date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"D"];
    NSString *basicDayOfYear = [dateFormatter stringFromDate:_date];
    
    for (int i = 1; i <= 24; i++)
    {
        num = 525948.76 * (y - 1900) + [[sTermInfo objectAtIndex:(i - 1)] intValue];
        
        newDate=[baseDateAndTime dateByAddingTimeInterval:num*60];//按分钟计算
        
        NSString *newDayOfYear = [dateFormatter stringFromDate:newDate];
        
        if ([basicDayOfYear  isEqualToString:newDayOfYear])
        {
            tempStr = [SolarTerm objectAtIndex:(i-1)];
            break;
        }
    }
    
    [dateFormatter release];
    
    //只显示清明节
    if([tempStr isEqualToString:@"清明"])
    {
        return @"清明节";
    }
    else
    {
        return @"";
    }
    
    return tempStr;
}


-(void) dealloc
{
    [MinDay release];
    [MaxDay release];
    [LunarDateArray dealloc];
    [SolarTerm dealloc];
    [sTermInfo dealloc];
    
    [super dealloc];
}

@end
