//
//  CalendarContentCell.m
//  Calendar
//
//  Created by garin on 13-11-28.
//  Copyright (c) 2013年 garin. All rights reserved.
//

#import "CalendarContentCell.h"

//节假日数据
static NSMutableDictionary *dicHoliday;
//公休日数据
static NSMutableDictionary *legalHoliday;

@implementation CalendarContentCell

@synthesize curDate;
@synthesize delegate;

@synthesize startCheckInDate;
@synthesize startCheckOutDate;
@synthesize cellRowIndex;
@synthesize dataBtnsDic;

+(void) makeStaicHolidays
{
    //节假日
    if (dicHoliday)
    {
        return;
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"holiday_new" ofType:@"plist"];
        dicHoliday = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    
    //公休日
    if (legalHoliday)
    {
        return;
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"legalHolidays" ofType:@"plist"];
        legalHoliday = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
}

+(void) clearStaticHolidays
{
    if (dicHoliday)
    {
        [dicHoliday release];
        dicHoliday=nil;
    }
    
    if (legalHoliday)
    {
        [legalHoliday release];
        legalHoliday=nil;
    }
}

-(void) dealloc
{
    self.curDate=nil;
    self.startCheckInDate=nil;
    self.startCheckOutDate=nil;
    self.delegate=nil;
    self.dataBtnsDic=nil;
    
    [super dealloc];
}

- (void) initWithSth:(NSDate *) cellDate
{
    [self initObjects:cellDate];
    
    [self addContentView];
    
    [self addCurMonth];
    
    [self addDateView];
}

-(void) initObjects:(NSDate *) date
{
    self.curDate=date;
    CalendarHelper *helper=[CalendarHelper shared];
    
    if(self.dataBtnsDic==nil)
    {
        self.dataBtnsDic=[NSMutableDictionary dictionary];
    }
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    dateBtnWidth=SCREEN_WIDTH/7;   //日历格子的宽度
    NSDate *firstDate = [helper firstDayOfMonthContainingDate:self.curDate];  //返回self.curDate所在月的第几天
    dayOfWeek=[helper dayOfWeekForDate:firstDate];   //星期几
    monthDays=[helper getDayCountOfMonth:firstDate]; //当前月有几天
    allRow=(dayOfWeek+monthDays-1)%7>0?(dayOfWeek+monthDays-1)/7+1:(dayOfWeek+monthDays-1)/7;
}

//初始化后续的操作
-(void)  doOtherSth:(NSDate *) cInDate cOutdate:(NSDate *) cOutdate selectDayDelegate:(id<SelectDayDelegate>) selectDayDelegate type:(CalendarType) type
{
    calendarTypeType=type;
    self.startCheckInDate=cInDate;
    self.startCheckOutDate=cOutdate;
    self.delegate=selectDayDelegate;
    
    CalendarHelper *helper=[CalendarHelper shared];
    
    //0~5点算午夜
    int curHour = [helper hour:[NSDate date]];
    if(curHour<5)
    {
        isMidnight=YES;
    }
    else
    {
        isMidnight=NO;
    }
    
    //国际酒店，前一天都预定
    if (type==GlobelHotelCalendar)
    {
        isMidnight=YES;
    }
    
    //当前时间
    NSDate *currentTimeDate=[NSDate date];
    if (type==HotelCalendar||type==GlobelHotelCalendar)
    {
        if (cInDate==nil)
        {
            self.startCheckInDate=[NSDate date];
        }
        if (cOutdate==nil)
        {
            self.startCheckOutDate=[[NSDate date] dateByAddingTimeInterval:24*3600];
        }
        //午夜和昨天比
        if (isMidnight)
        {
            NSDate *yesterdayDate=[currentTimeDate dateByAddingTimeInterval:-(24*3600)];
            
            if ([helper compareDate:yesterdayDate withCheckOutDate:cInDate]==1   //入住日期小于昨天
                ||[helper compareDate:yesterdayDate withCheckOutDate:cOutdate]>=0) //离店日期小于等于昨天
            {
                self.startCheckInDate=[NSDate date];
                self.startCheckOutDate=[self.startCheckInDate dateByAddingTimeInterval:24*3600];
            }
        }
        else
        {
            if ([helper compareDate:currentTimeDate withCheckOutDate:cInDate]==1  //入住日期小于今天
                ||[helper compareDate:currentTimeDate withCheckOutDate:cOutdate]>=0)  //入住日期小于今天
            {
                self.startCheckInDate=[NSDate date];
                self.startCheckOutDate=[self.startCheckInDate dateByAddingTimeInterval:24*3600];
            }
        }
    }
    else
    {
        if (cInDate==nil)
        {
            self.startCheckInDate=[[NSDate date] dateByAddingTimeInterval:24*3600];
        }
        if ([helper compareDate:currentTimeDate withCheckOutDate:cInDate]==1)  //入住日期小于今天
        {
            self.startCheckInDate=[[NSDate date] dateByAddingTimeInterval:24*3600];
        }
    }
    
    //重新初始化日期数据
    [self reInitDateSpans];
}

//重新初始化日期数据
-(void) reInitDateSpans
{
    CalendarHelper *helper=[CalendarHelper shared];
    
    DateButton *findCheckInDateBtn=nil; //找到入店日期
    DateButton *findCheckOutDateBtn=nil; //找到离店日期
    //重新初始化
    for(UIView *v in contentView.subviews)
    {
        if([v isMemberOfClass:[DateButton class]])
        {
            DateButton *dateBtn=(DateButton *)v;
            if(dateBtn)
            {
                //重置
                [self resetDateBtn:dateBtn];
                
                if([helper dateIsEqual:dateBtn.date secondDate:self.startCheckInDate])
                {
                    findCheckInDateBtn=dateBtn;
                }
                //酒店，国际酒店才有离店
                else if((calendarTypeType==HotelCalendar||calendarTypeType==GlobelHotelCalendar)&&[helper dateIsEqual:dateBtn.date secondDate:self.startCheckOutDate])
                {
                    findCheckOutDateBtn=dateBtn;
                }
            }
        }
    }
    
    //改变标题
    if ((calendarTypeType==HotelCalendar||calendarTypeType==GlobelHotelCalendar))
    {
        if (findCheckInDateBtn&&findCheckOutDateBtn)
        {
            //计算入住天数
            int allDays = [helper getalldays:findCheckInDateBtn.date withCheckOutDate:findCheckOutDateBtn.date];
            if (allDays>0)
            {
                if ([delegate respondsToSelector:@selector(selectDaysCnt:)])
                {
                    [delegate selectDaysCnt:allDays];
                }
            }
        }
    }
    
    //选中初始化的入离日期
    if([delegate respondsToSelector:@selector(tableCellSelectDay:type:isInit:)])
    {
        if(findCheckInDateBtn)
        {
            [delegate tableCellSelectDay:findCheckInDateBtn type:calendarTypeType isInit:YES];
            //叉号影藏
            UIImageView *cancelView=(UIImageView *)[findCheckInDateBtn viewWithTag:1230600];
            cancelView.hidden=YES;
            
            //滚动到这个位置
            if ([delegate respondsToSelector:@selector(scroolToIndex:)]) {
                [delegate scroolToIndex:cellRowIndex];
            }
        }
        if(findCheckOutDateBtn)
            [delegate tableCellSelectDay:findCheckOutDateBtn type:calendarTypeType isInit:YES];
    }
}

-(void) resetDateBtn:(DateButton *) dateBtn
{
    if(dateBtn.isMidNight)
    {
        NSLog(@"%@",dateBtn.date);
        dateBtn.isMidNight=NO;
        [dateBtn setHoliday:dateBtn.trueHoliday];
    }
    
    //把今天的恢复
    if([dateBtn.titleLabel.text isEqualToString:@"今天"])
    {
        [dateBtn setDateAndTitle:dateBtn.date];
    }
    
    if([dateBtn getCheckState]!=None)
    {
        [dateBtn setCheckState:None];
    }
    
    dateBtn.type=calendarTypeType;
    [dateBtn setBtnEnabled:YES];
    
    CalendarHelper *helper=[CalendarHelper shared];
    
    //今天
    if ([helper dateIsToday:dateBtn.date])
    {
        [dateBtn setTitle:@"今天" forState:UIControlStateNormal];
        [dateBtn setTxt:@"今天"];
    }
    
    //深夜而且是昨天
    if(isMidnight&&[helper dateIsYesterday:dateBtn.date])
    {
        if (calendarTypeType==HotelCalendar) {
            [dateBtn setHoliday:@"深夜"];
        }
        dateBtn.isMidNight=isMidnight;
        if(self.startCheckInDate)
        {
            //初始化的入住日期在今天，时深夜可用
            if([helper dateIsToday:self.startCheckInDate])
            {
                [dateBtn setBtnEnabled:YES];
            }
        }
        
    }
}

//月份栏
-(void) addCurMonth
{
    CalendarHelper *helper=[CalendarHelper shared];
    monthlbl=[[UILabel alloc] initWithFrame:CGRectZero];
    monthlbl.backgroundColor=[UIColor clearColor];
    monthlbl.textAlignment=NSTextAlignmentCenter;
    monthlbl.text=[NSString stringWithFormat:@"%d月",[helper month:self.curDate]];
    monthlbl.textColor=[UIColor colorWithRed:250/255.0 green:51/255.0 blue:26/255.0 alpha:1];
//    monthlbl.frame=CGRectMake((dayOfWeek-1)*dateBtnWidth+5, 8, 80, monthLanHeight-8);
    monthlbl.frame=CGRectMake(SCREEN_WIDTH/2-40, 8, 80, monthLanHeight-8);
    [contentView addSubview:monthlbl];
    [monthlbl release];
}

//日期主体
-(void) addContentView
{    
    contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, monthLanHeight+allRow*dayLanHeight)];
    contentView.backgroundColor=[UIColor clearColor];
    [self addSubview:contentView];
    [contentView release];
}

//日历格子
-(void) addDateView
{
    CalendarHelper *helper=[CalendarHelper shared];
    NSDate *firstDate = [helper firstDayOfMonthContainingDate:self.curDate];
    
    for (int i = 0; i < 42; i++)
    {
        int curRow=i/7+1;
        
        if(i%7==0)
        {
            UIView *splitView=[[UIView alloc] init];
            splitView.backgroundColor=[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
            [contentView addSubview:splitView];
            [splitView release];
            
            //中间行画满
            if(curRow>0&&curRow<=allRow)
            {
                splitView.frame = CGRectMake(0, monthLanHeight+(curRow-1)*dayLanHeight-1, SCREEN_WIDTH, 0.55);
            }
//            if(curRow>1&&curRow<allRow)
//            {
//                splitView.frame = CGRectMake(0, monthLanHeight+(curRow-1)*dayLanHeight-1, SCREEN_WIDTH, 0.55);
//            }
//            else if(curRow==1)
//            {
//                splitView.frame = CGRectMake((dayOfWeek-1)*dateBtnWidth, monthLanHeight+(curRow-1)*dayLanHeight-1, SCREEN_WIDTH-(dayOfWeek-1)*dateBtnWidth, 0.55);
//            }
//            else if(curRow==allRow)
//            {
//                splitView.frame = CGRectMake(0, monthLanHeight+(curRow-1)*dayLanHeight-1, (42-dayOfWeek-monthDays+1)*dateBtnWidth, 0.55);
//            }
        }
        
        if(i<(dayOfWeek-1))
            continue;
        
        if(i>(dayOfWeek+monthDays-2))
            continue;
        
        DateButton *dateButton = [DateButton buttonWithType:UIButtonTypeCustom];
        dateButton.frame=CGRectMake((i%7)*dateBtnWidth, monthLanHeight+(i/7)*dayLanHeight, dateBtnWidth, dayLanHeight);
        [dateButton addTarget:self action:@selector(dateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:dateButton];
        
        [dateButton setDateAndTitle:firstDate];
        
        //------------------------------绘制成绿色，休息日
        //最后一列是周六,第一列是周日
        BOOL isWeekend=NO;
        if (i%7==6||i%7==0)
        {
            isWeekend=YES;
        }
        
        if ([self isTrueGreenDay:firstDate isWeekend:isWeekend])
        {
            dateButton.isGreenDay=YES;
        }
        else
        {
            dateButton.isGreenDay=NO;
        }
        //------------------------------end
        
        //设置节假日
        NSString *holidayStr=[self getHoliday:firstDate];
        [dateButton setHoliday:holidayStr];
        dateButton.trueHoliday=holidayStr;
        
        //最后一个月,最后一天
        if(self.cellRowIndex==(monthCnt-1))
        {
            if(i==(dayOfWeek+monthDays-2))
            {
                dateButton.couldNotSelectByCheckIn=YES;
            }
        }
        
        if(dateButton)
        {
            [self.dataBtnsDic safeSetObject:dateButton forKey:[NSString stringWithFormat:@"%d-%d-%d",[helper year:firstDate],[helper month:firstDate],[helper day:firstDate]]];
        }
        
        firstDate = [helper nextDay:firstDate];
    }
}

//找到button
-(DateButton *) findButtonInView:(NSDate *) _targetDate
{
    CalendarHelper *helper=[CalendarHelper shared];
    DateButton *temBtn = [self.dataBtnsDic safeObjectForKey:[NSString stringWithFormat:@"%d-%d-%d",
                                                         [helper year:_targetDate]
                                                         ,[helper month:_targetDate],
                                                         [helper day:_targetDate]]];
    
    return temBtn;
}

//点选日历
-(void) dateButtonPressed:(id) sender
{
    if([delegate respondsToSelector:@selector(tableCellSelectDay:type:isInit:)])
    {
        [delegate tableCellSelectDay:sender type:calendarTypeType isInit:NO];
    }
}

//返回节假日
-(NSString *) getHoliday:(NSDate *) curDrawDate
{
    if(curDrawDate==nil)
        return @"";
    
    NSString *keyString = [NSDate stringFromDate:curDrawDate withFormat:@"yyyy-MM-dd"];
    
    NSString *holiday = [dicHoliday safeObjectForKey:keyString];
    
    if(!STRINGHASVALUE(holiday))
        return @"";
    
    return holiday;
}

//实际的公休日，包含周末，节假日，去掉调休
-(BOOL) isTrueGreenDay:(NSDate *) curDrawDate isWeekend:(BOOL) isWeekend
{
    //是周末，看看有无调休
    if (isWeekend)
    {
        if ([self isGrayDay:curDrawDate])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    //工作日，看看是否节假日休息
    else
    {
        if ([self isGreenDay:curDrawDate])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

//是否公休日
-(BOOL) isGreenDay:(NSDate *) curDrawDate
{
    if(curDrawDate==nil)
        return NO;
    
    NSArray *greenDays = [legalHoliday safeObjectForKey:@"GreenDays"];
    
    NSString *keyString = [NSDate stringFromDate:curDrawDate withFormat:@"yyyy-MM-dd"];
    
    if (greenDays&&[greenDays containsObject:keyString])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//是否倒休
-(BOOL) isGrayDay:(NSDate *) curDrawDate
{
    if(curDrawDate==nil)
        return NO;
    
    NSArray *grayDays = [legalHoliday safeObjectForKey:@"GrayDays"];
    
    NSString *keyString = [NSDate stringFromDate:curDrawDate withFormat:@"yyyy-MM-dd"];
    
    if (grayDays&&[grayDays containsObject:keyString])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//激活下
-(void) setCellActive
{
    monthlbl.textColor=[UIColor colorWithRed:250/255.0 green:51/255.0 blue:26/255.0 alpha:1];
    if (self.dataBtnsDic)
    {
        for (DateButton *da in self.dataBtnsDic.allValues)
        {
            if (da)
            {
                [da setNeedsLayout];
            }
        }
    }
}

@end
