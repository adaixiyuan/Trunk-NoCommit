//
//  FlightListViewController.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"

@class RentFlight;
@protocol SelectedAirPortDelegate <NSObject>

-(void)getTheSelectedAirport:(RentFlight *)flight andFlightNum:(NSString *)flightNo;

@end

@interface FlightListViewController : ElongBaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate>{

    UITableView *_tableView;
    HttpUtil *httpUti;
    
    id<SelectedAirPortDelegate>_delegate;
    BOOL searchActive;
    
    float searchBarHeight;
}
@property (nonatomic,assign)    id<SelectedAirPortDelegate>delegate;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) NSMutableArray *historySource;
@property (nonatomic,copy) NSString *flightNo;
@end
