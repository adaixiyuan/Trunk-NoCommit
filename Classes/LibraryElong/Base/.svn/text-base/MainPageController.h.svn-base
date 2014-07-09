//
//  RooController.h
//  ElongClient
//
//  Created by bin xing on 10-12-31.
//  Copyright 2010 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "AccountManager.h"
#import "ElongClientSetting.h"
#import "PositioningManager.h"
#import "GetCityWithPositioning.h"
#import "FAQ.h"
#import "HotelSearch.h"
#import "Notification.h"
#import "GrouponUserGuideView.h"

#define kAccelerationThreshold        2.0
#define kUpdateInterval               (1.0f/60.0f)

typedef enum {
	MainTypeHotel = 0,
	MainShakeType,
	MainTypeGroupon,
	MainTypeAirplane,
	MainTypeTrain,
	MainTypePerson,
	MainTypeMessage,
	MainTypeFeedback,
	MainTypeSetting,
	MainTypeFAQ,
    MainTypeAboutUs,
    MainTypeExchangeRate,
    MainTypeWebAds,
    MainTypeFlightStatus,
    MainTypePackingList,
    MainTypeMessageBox,
    MainTypeHotelDetail,
    MainTypeHotelDetailFromH5,
    MainTypeTaxi,
    MainTypeLMHotel,
    MainTypeTravelingTips,
    MainTypeEveryDayShopping,
    MainTypeTicket,
    MainTypeGrouponDetail,
    MainTypeGrouponDetailFromH5,
    MainTypeHotelPOI,
    MainTypeHotelList,
    MainTypeGrouponPOI,
    MainTypeService,
    MainTypeHotelComment,
    MainTypeCashAccount,
    MainTypeHotelFeedback,
    MainTypeHotelOrderList,
    MainTypeHotelOrderDetail
}MainType;

@interface MainPageController : DPNav <GrouponUserGuideDelegate>{
	ElongClientAppDelegate *appDelegate;
    NSInteger linktype;
}
@property (nonatomic,retain) id object;
@property (nonatomic,retain) id object1;
@property (nonatomic,assign) BOOL active;
@property (nonatomic,copy) NSString *checkInDate;
@property (nonatomic,copy) NSString *checkOutDate;

- (void) goModule:(MainType)sender;
- (void) goModule:(MainType)sender object:(id)object;
- (void) goModule:(MainType)sender object:(id)object object1:(id)object1;

- (void) goModuleActive:(MainType)sender;
- (void) goModuleActive:(MainType)sender object:(id)object;
- (void) goModuleActive:(MainType)sender object:(id)object object1:(id)object1;
@end
