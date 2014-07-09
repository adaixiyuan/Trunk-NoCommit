//
//  FlightAirPortTable.h
//  ElongClient
//  航班机场列表控件
//  Created by dengfang on 11-2-23.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPViewTopBarDelegate.h"
#import "DPViewTopBar.h"
#import "CustomSegmentedDelegate.h"

#define AIR_PORT_DATA_MAX_NUM 9

@interface FlightAirPortTable : UIViewController <UITableViewDelegate, UITableViewDataSource, DPViewTopBarDelegate, CustomSegmentedDelegate> {
	
	DPViewTopBar *dpViewTopBar;
	UITableView *dTabView;			//departAirPort
	UITableView *aTabView;			//arrivalAirPort
	
	NSMutableArray *dArray;
	NSMutableArray *aArray;
	NSMutableDictionary *dDictionary;
	NSMutableDictionary *aDictionary;
	NSMutableArray *dSelectRowArray;
	NSMutableArray *aSelectRowArray;
	
	int m_iMaxNum;
	int m_iState;
}

typedef enum {
	SelectStateDepart = 0,
	SelectStateArrival = 1
} SelectState;

- (id)initWithDepartArray:(NSMutableArray *)departArray arrivalArray:(NSMutableArray *)arrivalArray;
- (void)showSelectTable:(UIViewController *)controller;
- (void)updateDepartArray:(NSMutableArray *)departArray arrivalArray:(NSMutableArray *)arrivalArray;
- (BOOL)dpViewRightBtnPressed;

@end
