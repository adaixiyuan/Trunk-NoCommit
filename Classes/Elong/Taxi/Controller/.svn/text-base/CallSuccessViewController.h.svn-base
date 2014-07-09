//
//  CallSuccessViewController.h
//  ElongClient
//
//  Created by nieyun on 14-2-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//
//
//typedef enum{
//    AutoNavi,
//    GoogleMap,
//    EmptyMapData
//}HotelMapDataFrom;



#import "DPNav.h"
#import "TaxiDetaileModel.h"
#import "HotelMap.h"
#import "AttributedLabel.h"
#import "SendTaxiContrl.h"
#define  TABLEBODYHEIGHT  100
#define TABLEFOOTHEIGHT  20
#define TIP   @"如需取消用车，请及时联系司机，以免引起司机投诉哦～"
#define SUCCESSTIP @""


@interface CallSuccessViewController : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,HttpUtilDelegate>
{
    UITableView  *tablebView;
    UIView  *callSucessView;
     HttpUtil *directionUtil;
    HttpUtil  *driverUtil;
    HotelMapTravelMode  travelMode;
    HotelMapDataFrom   mapDataFrom;
    AttributedLabel *distanceLabel;
    CALLSUCESS_SHOW  showType;
    int  IsFirst;
}
@property  (nonatomic,retain)TaxiDetaileModel  *detaileModel;
@property  (nonatomic,retain) NSString  *orderId;


@end
