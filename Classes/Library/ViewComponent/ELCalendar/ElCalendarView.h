//
//  ElCalendarView.h
//  Calendar
//  日历view
//  Created by garin on 13-11-28.
//  Copyright (c) 2013年 garin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarHelper.h"
#import "CalendarContentCell.h"
#import "DPNav.h"

@class DPNav;

@interface ElCalendarView : UIView<UITableViewDataSource,UITableViewDelegate,SelectDayDelegate>
{
    UIView *dayWeekView;        //星期栏
    UITableView *calendarView;  //滚动的日历
    CalendarType calendarTypeType;  //日类类型
    int scrollToIndex;                //滚动到到的index;
    BOOL isFirstSelect;               //是否第一次选择
    
}

@property (nonatomic,retain) NSDate *curDate;    //当前时间

@property (nonatomic,copy) NSDate *trueFirstDate;    //实际开始时间

@property (nonatomic,retain) DateButton *checkInDateBtn; //选中的入住日期
@property (nonatomic,retain) DateButton *checkOutDateBtn; //选中的离店日期

@property (nonatomic,retain) NSDate *startCheckInDate;     //初始化的入住日期
@property (nonatomic,retain) NSDate *startCheckOutDate;    //初始化的离店日期
@property (nonatomic,assign) DPNav *parentViewController;

@property (nonatomic,retain)     UIView *sectionHeaderView;     //表头

//
- (id)initWithFrame:(CGRect)frame cinDate:(NSDate *) cinDate coutDate:(NSDate *) coutDate type:(CalendarType) type parentViewController:(DPNav *)parentViewController_;

//返回tableViewCellStaticList
+(NSMutableArray *) getTableViewCellStaticList;

//删除缓存
-(void) deleteTableViewCellStaticList;

//得到滑动到的年份
-(NSString *) getCurYearTxt;

@end