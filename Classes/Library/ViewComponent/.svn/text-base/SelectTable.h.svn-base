//
//  SelectTable.h
//  ElongClient
//
//  Created by dengfang on 11-2-9.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPViewTopBarDelegate.h"
#import "DPViewTopBar.h"


@protocol SelectDelegate;

#define SELECT_TABLE_DATA_MAX_NUM 7
@interface SelectTable : UIViewController <UITableViewDelegate, UITableViewDataSource, DPViewTopBarDelegate> {
	DPViewTopBar *dpViewTopBar;
	UITableView *tabView;

	int m_iTable;
	int m_iSelectedTable;
	int m_iFrom;
	int m_iMaxNum;
	
	NSMutableArray	*iconNameArray;
	NSMutableArray	*dataArray;
	NSMutableDictionary *selectedDictionary;
	
	NSArray *titleArray;
	NSArray *otherDataArray;
	
	BOOL m_Saved;
}

typedef enum {
	SelectedTableClass = 0,			// 舱位
	SelectedTableCertificate = 1,	// 证件
	SelectedTableBank = 2,			// 发卡行
	SelectedTableAirlines = 3,		// 航空公司
	SelectedTableStarLevel = 4,		// 酒店星级
	SelectedTableRailwayDeparture,	// 列车出发时间
	SelectedTableRailwayArrival,	// 列车到达时间
	SelectedTableTrain,				// 列车查询
	SelectedTableTrainStation,		// 列车车站查询
	SelectedTableInvoice,			// 发票类型选择
	SelectedTableGroupOrder,         //团购订单管理筛选
	SelectedTableHotelOrder,          //酒店订单筛选
	SelectedTableHotelList,			// 酒店列表
	SelectedTableFlightOrder,         //机票订单筛选
	SelectedTableGroupon,           //消费券筛选
	SelectedTableTrainSort,           //火车排序
	SelectedTableTrainSortStation,    //火车车站排序
    SelectedTableAirLineSort,
} SelectedTable;

typedef enum {
	FromAddFlightCustomer = 10,
	FromAddCard,
	FromFlightList,
	FromHotelSearch,
	FromRailWay,
	FromAddCustomer,
	FromAddAndEditCard,
	FromGrouponOrder,
	FromHotelOrder,
	FromFlightOrder,
	FromGroupon,
	FromTrainSort,
	FromTrainSortStation,
    FromAirLineSort
} From;//来自哪个类


typedef enum {
	ClassTypeAll = 0,
	ClassTypeEconomy = 1,
	ClassTypeBusiness = 2,
	ClassTypeFrist = 3
} ClassType;


@property (nonatomic) int m_iSelectedTable;
@property (nonatomic) int m_iFrom;
@property (nonatomic) int m_iMaxNum;
@property (nonatomic) int addtionHeight;
@property (nonatomic) BOOL isShow;
@property (nonatomic,assign) id<SelectDelegate> delegate;
@property (nonatomic,retain)UITableView *tabView;

- (id)init:(int)table;
- (id)initWithType:(SelectedTable)table;
- (id)init:(int)table from:(int)from;
- (id)init:(int)table iSelect:(int)iSelect;
- (id)init:(int)table iSelect:(int)iSelect saved:(BOOL)saved;
- (id)init:(int)table from:(int)from data:(NSMutableArray *)array;

- (void)showSelectTable:(UIViewController *)controller;
- (void)dpViewLeftBtnPressed;

- (id)initWithCard:(NSMutableArray *)array;
- (void)updateDataArray:(NSMutableArray *)array;
- (void)setDisplayName:(NSString *)nameStr;				// 设置默认选项
//- (void)setDataArray:(NSArray*)array;

- (BOOL)checkSelectedValue;
- (void)noChooseTip;
- (void)setselectedrowoftable:(NSString*)selected_index;
@end

@protocol SelectDelegate
@optional

// 获取本页选中行的文字
- (void)getParamStrings:(NSArray *)strArray;

@end
