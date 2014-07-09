//
//  FlightFillerSelectable.h
//  ElongClient
//  筛选弹出框
//  Created by li dechen on 12-1-7.
//  Copyright 2012年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DPViewTopBarDelegate.h"
#import "DPViewTopBar.h"
#import "SelectTable.h"
#import "FlightAirPortTable.h"
#import "SelectTableCell.h"
#import "FlightList.h"

@interface FlightFilterSelectable : UIViewController<DPViewTopBarDelegate,CustomSegmentedDelegate> {
    DPViewTopBar *dpViewTopBar;  //顶部的
	SelectTable *selectTable;    //航空公司
	FlightAirPortTable *airPortTable; //机场
	UIViewController* flight;
    
	int m_iType;
	
	NSMutableArray	*dataArray;
    BOOL isShowing;
}

@property (nonatomic,retain)SelectTable *selectTable;    //航空公司
@property (nonatomic,retain)FlightAirPortTable *airPortTable; //机场

//初始化数据
- (id)init:(NSMutableArray*)airArray port:(NSMutableArray*)port Array:(NSMutableArray*)arrivalay datasources:(NSMutableArray*)sourceArray;

- (void)resetAirs:(NSMutableArray*)airArray port:(NSMutableArray*)port Array:(NSMutableArray*)arrivalay datasources:(NSMutableArray*)sourceArray;
- (void)showSelectTable:(UIViewController *)controller; //弹出
- (void)dpViewLeftBtnPressed;

- (void)updateAirCorpArray;
- (void)updateAirPortArray;

@end
