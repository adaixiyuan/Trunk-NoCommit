//
//  DateButton.h
//  Calendar
//  自定义的日历button
//  Created by garin on 13-11-28.
//  Copyright (c) 2013年 garin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarHelper.h"

//按钮状态
enum
{
    None,       //正常状态
    CheckIn,    //入住
    CheckOut,   //离店
    CommonCheck, //普通选中，入住和离店之间
};
typedef int DateButtonState;

//日历类型
enum
{
    HotelCalendar,       //酒店
    GlobelHotelCalendar,  //国际酒店
    FlightCalendarGo,    //机票去程
    FlightCalendarBack,      //机票返程
    TrainCalendar,   //火车
    UseTaxi,         //用车
};
typedef int CalendarType;

@interface DateButton : UIButton
{
    UILabel *holidayLbl;
    UILabel *upLbl;
    UILabel *downLbl;
    DateButtonState curState;
    UIImageView *imgView;
}
@property (nonatomic, retain) NSDate *date;  //日期
@property (nonatomic, retain) NSString *txt; //实际日期
@property (nonatomic, retain) NSString *trueHoliday; //实际日期
@property (nonatomic) BOOL isMidNight; //是否是午夜
@property (nonatomic) BOOL couldNotSelectByCheckIn; //不能被checkin选中
@property (nonatomic) CalendarType type;
@property (nonatomic) BOOL isGreenDay; //是公休日（周末和十一，五一之类）


//设置日期和title
- (void)setDateAndTitle:(NSDate *)aDate;
//选中状态
-(void) setCheckState:(DateButtonState) state;
//设置是否可用 YES:可用 NO:不可用
-(void) setBtnEnabled:(BOOL) ennable;
//设置节假日
-(void) setHoliday:(NSString *) holidayString;
//得到状态
-(DateButtonState) getCheckState;
@end
