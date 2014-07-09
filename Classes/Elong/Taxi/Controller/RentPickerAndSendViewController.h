//
//  RentPickUpViewController.h
//  ElongClient
//  租车接送机
//  Created by Jian.Zhao on 14-3-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "CustomSegmented.h"
#import "ELCalendarViewController.h"
#import "ChooseDepartVC.h"
#import "AddressInfo.h"
#import "FlightListViewController.h"
#import "AirportListViewController.h"
#import "TaxiRoot.h"

@class RentFlight,CustomAirportTerminal;
@interface RentPickerAndSendViewController : ElongBaseViewController<CustomSegmentedDelegate,UITableViewDataSource,UITableViewDelegate,ElCalendarViewSelectDelegate,SelectAddressDelegate,SelectedAirPortDelegate,SelectCustomAirportDelegate>{

    UITableView *_tableView;
    UIActionSheet *sheet;
    HttpUtil *httpUti;
    NSMutableArray *_airportArrays;//后台获取的支持接送机的机场列表
    RentCarType _type;
    
    int segmentselectedindex;
    BOOL goList;
    
}
@property (nonatomic,assign) RentCarType  type;
@property (nonatomic,retain) NSMutableArray *airportArrays;
@property (nonatomic,copy) NSString *flightNum;//航班号
@property (nonatomic,retain) RentFlight *selectedFlight;//选择的航班
@property (nonatomic,copy) NSString *flightTime;//航班到达时间
@property (nonatomic,retain) AddressInfo *startPoint;//出发地（送机）
@property  (nonatomic,retain) AddressInfo *destination;//目的地
@property  (nonatomic,copy) NSString *airport;//机场
@property (nonatomic,retain) CustomAirportTerminal *selectedAirport;
@property  (nonatomic,copy) NSString *air_Time;//机场下的用车时间
@property (nonatomic,copy) NSString *cityCode;

@end
