//
//  FlightList.h
//  ElongClient
//  航班列表
//
//  Created by dengfang on 11-1-13.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "SelectTable.h"
#import "FlightPostManager.h"
#import "ElongURL.h"
#import "FlightAirPortTable.h"
#import "FilterView.h"
#import "FlightSearchFilterController.h"
#import "CheapCalendarView.h"
#import "FlightLowPrice.h"

@class FlightFilterSelectable;

@interface FlightList : DPNav <UITableViewDelegate, UITableViewDataSource,  FilterDelegate, SearchFilterDelegate, CheapCalendarViewDelgt>
{
	int m_iSortType;
	
	NSMutableArray *dataSourceArray;
	
	NSDictionary *goDic;
	
	NSMutableArray *tAirCorpArray;	//airCorp 筛选后的数组
	NSMutableArray *tAirPortArray;	//airPort 筛选后的数组
	
	FlightFilterSelectable* FillerTable; // 筛选框
	SelectTable *selectTable;
	FlightAirPortTable *airPortTable;
    BOOL displayTransFlight;      // 是否显示中转航班
    
    FilterView *sortSelectTable; //排序框
    
	int tapCount;
	int m_selectRow;
	
	UIView *blogView;
}

@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, retain) NSMutableArray *tAirCorpArray;
@property (nonatomic, retain) NSMutableArray *tAirPortArray;
@property (nonatomic, copy) NSString *currentJSONDate;
@property (nonatomic, retain) UITableView *tabView;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic) NSInteger currentOrder;		// 当前的排序条件

@property (nonatomic, assign) NSUInteger cellheight;
@property (nonatomic, retain) UIView *viewBottom;
@property (nonatomic, assign) BOOL isPriceAscending;                 // 价格排序是否升序
@property (nonatomic, assign) BOOL isTimeAscending;                  // 时间排序是否升序// 底部区域
@property (nonatomic, assign) BOOL isTimeReset;
@property (nonatomic, assign) BOOL isPriceReset;

@property (nonatomic, retain) UINavigationController *filterNav;
@property (nonatomic, retain) NSMutableArray *filterArray;

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@property (nonatomic, retain) UIImageView *badgeImageView;
@property (nonatomic, retain) NSMutableArray *cellHeightArray;

@property (nonatomic, retain) CheapCalendarView *cheapCalendarView;
@property (nonatomic, assign) NSInteger netType;                    // 网络请求类型
@property (nonatomic, strong) NSDateFormatter *oFormat;             // 时间显示格式
@property (nonatomic, strong) NSDateFormatter *priceDateFormate;    // 低价日历时间显示格式
@property (nonatomic, strong) FlightLowPrice *flightLowPrice;       // 低价日历数据
@property (nonatomic, strong) HttpUtil *getPriceListUtil;
@property (nonatomic, assign) NSInteger lowPriceSelectIndex;        // 低价日历选择项index
@property (nonatomic, assign) BOOL filterReset;                     // 筛选重置
@property (nonatomic, assign) BOOL isSelectOneHour;                 // 是否选择了一小时飞人

- (id)initWithTitle:(NSString *)title displayTransFlight:(BOOL)isDisplay;

- (void)priceButtonPressed:(int)num;
- (void)timeButtonPressed:(int)num;

- (void)updateAirCorpArray;
- (void)updateAirPortArray;
- (void)selectedIndex:(NSInteger)index;

- (void)loadListData;
- (void)reloadDataByConditions;

// 高亮选择的低价日历项
- (void)setCheapCalendarSelectedItem;

@end


//价格降序
NSInteger sortFlightPrice(id flight1, id flight2, void *context) ;
//价格降序
NSInteger sortFlightPriceDescending(id flight1, id flight2, void *context) ;
//时间升序
NSInteger sortFlightTime(id flight1, id flight2, void* context) ;
//时间降序
NSInteger sortFlightTimeDescending(id flight1, id flight2, void* context) ;
