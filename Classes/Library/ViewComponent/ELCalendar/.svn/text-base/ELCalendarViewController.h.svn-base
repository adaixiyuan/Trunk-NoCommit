//
//  ELCalendarViewController.h
//  Calendar
//  承载日历的viewcontroller
//  Created by garin on 13-11-27.
//  Copyright (c) 2013年 garin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElCalendarView.h"

@protocol ElCalendarViewSelectDelegate;

@interface ELCalendarViewController : DPNav
{
    ElCalendarView *calendar;
    UILabel *yearLbl;
}

@property (nonatomic,retain) NSDate *checkInDate;
@property (nonatomic,retain) NSDate *checkOutDate;
@property (nonatomic) CalendarType type;

@property (nonatomic,assign) id<ElCalendarViewSelectDelegate> delegate;

- (id) initWithCheckIn:(NSDate *)checkIn checkOut:(NSDate *)checkOut type:(CalendarType)calendarType;
@end

@protocol ElCalendarViewSelectDelegate<NSObject>
@optional
//选中后的回掉
-(void) ElcalendarViewSelectDay:(ELCalendarViewController *) elViewController checkinDate:(NSDate *) cinDate checkoutDate:(NSDate *) coutDate;

//选中了几天
-(void) selectDaysCnt:(int) days;

@end
