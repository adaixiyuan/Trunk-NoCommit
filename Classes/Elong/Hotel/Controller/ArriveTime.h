//
//  ArriveTime.h
//  ElongClient
//
//  Created by bin xing on 11-1-16.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
@class DPViewTopBar;
@class FillHotelOrder;

@interface ArriveTime : UIViewController<UITableViewDelegate,UITableViewDataSource,DPViewTopBarDelegate> {
	DPViewTopBar *dpViewTopBar;
	UITableView *defaultTableView;
	NSMutableArray *dataSource;
	FillHotelOrder *parentController;
}

-(id)initWithFillHotelOrder:(FillHotelOrder *)controler;

@property (nonatomic,retain) NSMutableArray *dataSource;

- (void)setArriveTime:(NSString *)timeStr;			// 设置时间
- (void)setArriveTimes:(NSArray *)times;			// 设置到达时间数组

- (NSArray *)arriveTimeIndex;
- (NSMutableArray *)arriveTimeLabel;
- (NSMutableArray *)arriveTimeValue;

@end
