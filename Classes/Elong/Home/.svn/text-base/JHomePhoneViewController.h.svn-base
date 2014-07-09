//
//  HomePhoneViewController.h
//  ElongClient
//
//  Created by Dawn on 13-12-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "PhoneChannel.h"
#import "HotScenicButton.h"
#import "HotelOrderListRequest.h"
#define HIDDEN_HOTELORDERS @"hidden_hotelOrders"
#import "HotelOrderIsNomListRst.h"
#import "LoginManager.h"
#import "PhonePubLic.h"

@interface JHomePhoneViewController : ElongBaseViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,HotelOrderListRequestDelegate,HotelOrderIsNomListDelegate,LoginManagerDelegate,UIActionSheetDelegate,HttpUtilDelegate>{
    
    PhoneChannel  *phoneView;
    UITableView  *phoneTable;
    HotelOrderListRequest   *listRequest;
    NSMutableArray *_hotelOrdersArray;      //过滤隐藏的订单数据
    NSMutableArray *_originOrdersArray;     //未过滤的订单数据s
    NSDictionary   *confirmDic;
    int hasConfirmList;
    NSArray  *imageAr;
    HotelOrderIsNomListRst  *NoNomlistReq;
    PhoneType  callType;
    HttpUtil  *scoreUtil;
    HttpUtil  *cashUtil;
    NSMutableString  *integralStr;
    NSMutableString   *cashStr;
}
@property  (nonatomic,retain) NSMutableArray  *localOrderArray;
@property  (nonatomic,assign) id<HotelOrderListRequestDelegate> requestDelegate;

@end
