//
//  CalendarContentCell.h
//  Calendar
//  一个cell代表一个月的日历展示
//  Created by garin on 13-11-28.
//  Copyright (c) 2013年 garin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarHelper.h"
#import "DateButton.h"
#import "ChineseCalendar.h"
#import "NSDate+Helper.h"

@protocol SelectDayDelegate;

@interface CalendarContentCell : UITableViewCell
{
    UILabel *monthlbl;          //月份栏
    UIView *contentView;        //日历主体
    
    int dayOfWeek;              //星期几
    int monthDays;              //当前月有几天
    int allRow;                 //有多少行
    float dateBtnWidth;         //button的宽度
    BOOL isMidnight;           //是否是午夜
    CalendarType calendarTypeType;  //日类类型
}

@property (nonatomic,retain) NSDate *curDate;
@property (nonatomic,assign) id<SelectDayDelegate> delegate;

@property (nonatomic,retain) NSDate *startCheckInDate;     //初始化的入住日期
@property (nonatomic,retain) NSDate *startCheckOutDate;    //初始化的离店日期

@property (nonatomic) int cellRowIndex;          //cell的index;

@property (nonatomic,retain) NSMutableDictionary *dataBtnsDic;    //allbutons

//初始化，构造UI
- (void) initWithSth:(NSDate *) cellDate;

//初始化后续的操作
-(void)  doOtherSth:(NSDate *) cInDate cOutdate:(NSDate *) cOutdate selectDayDelegate:(id<SelectDayDelegate>) selectDayDelegate type:(CalendarType) type;

//根据某个日期，找对对应button，没找到，返回nil
-(DateButton *) findButtonInView:(NSDate *) _targetDate;

//初始化节假日
+(void) makeStaicHolidays;

//清空节假日
+(void) clearStaticHolidays;

//激活下
-(void) setCellActive;

@end

@protocol SelectDayDelegate <NSObject>

//选中某个button，选中某一天
-(void) tableCellSelectDay:(DateButton *) dataBtn type:(CalendarType) type isInit:(BOOL) isInit;

//返回了选中了几天
-(void) selectDaysCnt:(int) days;

//滚动到每个index
-(void) scroolToIndex:(int) scroolIndex;

@end
