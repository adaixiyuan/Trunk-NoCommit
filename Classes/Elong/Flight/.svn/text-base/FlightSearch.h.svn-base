//
//  FlightSearch.h
//  ElongClient
//  航班查询
//
//  Created by dengfang on 11-1-12.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "FlightPostManager.h"
#import "FilterView.h"
#import "ElongURL.h"
#import "SelectTable.h"
#import "ElongClientSetting.h"
#import "ELCalendarViewController.h"

@interface FlightSearch : DPNav <CustomSegmentedDelegate,  FilterDelegate, ElCalendarViewSelectDelegate> {
	IBOutlet UIView *cityView;
	IBOutlet UIView *departView;
//	IBOutlet UIView *classView;
	
	IBOutlet UILabel *departCityLabel;
	IBOutlet UIButton *departCityButton;
	IBOutlet UILabel *arrivalCityLabel;
	IBOutlet UIButton *arrivalCityButton;
	IBOutlet UILabel *departDateLabel;
	IBOutlet UIButton *departDateButton;
	IBOutlet UILabel *returnDateLabel;
	IBOutlet UIButton *returnDateButton;
	IBOutlet UILabel *dTodayLabel;
	IBOutlet UILabel *rTodayLabel;
	IBOutlet UILabel *dapartDateTitle;
	IBOutlet UIImageView *rightArrow;  //出发时间的右箭头，随tab切换变化位置
	
	IBOutlet UILabel *departDateDayLabel; //出发时间，号
	IBOutlet UILabel *arriveDateDayLabel; //到达时间，号
	IBOutlet UILabel *departDateMonLabel; //出发时间，月
	IBOutlet UILabel *arriveDateMonLabel; //到达时间，月
	IBOutlet UILabel *departDateWeekLabel; //出发时间，周
	IBOutlet UILabel *arriveDateWeekLabel; //到达时间，周
	
	UIButton* queryBtn; //查询按钮
	
	FilterView *selectTable;
    HttpUtil *couponUtil;
    
	IBOutlet UILabel *classLabel;
	IBOutlet UIButton *classButton;
	IBOutlet UIButton *searchButton;
	IBOutlet UIView *backTimeView;
	IBOutlet UIView *classView;
	
	NSDateFormatter *format;
	NSDateFormatter *oFormat;
	
	//data
	int m_iType; //0-单程；1-往返
	NSString *m_iClassType;//舱位类型
	int m_iFlightSearchFrom;
    
    NSString *departcitystring;
    NSString *arrivalcitystriing;
    NSDate *departdate;
    NSDate *arrivaldata;
    NSString *classlabelstring;
    int segmentselectedindex;
}

typedef enum {
	FlightSearchFromSelf = 0,	//FlightSearch
	FlightSearchFromList = 1,	//FlightList
	FlightSearchFromDetail = 2	//FlightDetail
} FlightSearchFrom;
@property (nonatomic, retain) UILabel *departCityLabel;
@property (nonatomic, retain) UILabel *arrivalCityLabel;
@property (nonatomic, retain) UILabel *classLabel;
@property (nonatomic,copy) NSString *m_iClassType;
@property (nonatomic) int m_iFlightSearchFrom;

@property (nonatomic, retain) IBOutlet UIButton *buttonExchange;
@property (nonatomic, assign) ELCalendarViewController *departureCalendarVC;
@property (nonatomic, assign) ELCalendarViewController *arrivalCalendarVC;

- (IBAction)departCityButtonPressed;
- (IBAction)arrivalCityButtonPressed;
- (IBAction)departDateButtonPressed;
- (IBAction)returnDateButtonPressed;
- (IBAction)classButtonPressed;
- (void)searchButtonPressed;
- (void)returnFightSearch;
-(void)fightSearch;

@end
