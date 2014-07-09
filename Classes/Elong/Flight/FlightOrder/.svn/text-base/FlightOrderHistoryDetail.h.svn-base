//
//  FlightOrderHistoryDetail.h
//  ElongClient
//  航班订单详情页面
//  Created by WangHaibin on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "Utils.h"
#import "FlightOrderHistoryDetailFlightInfoViewController.h"
#import "FlightOrderHistroyDetailPassnerInfoViewController.h"
#import "FlightOrderHistoryDetailRestrictionViewController.h"
#import "FlightOrderHistoryDetailDelegate.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "BaseBottomBar.h"

@class FlightOrderHistroyDetailPassnerInfoViewController;
@interface FlightOrderHistoryDetail : DPNav <UIImagePickerControllerDelegate,UINavigationControllerDelegate,EKEventEditViewDelegate,BaseBottomBarDelegate,FlightOrderHistoryDetailFlightInfoDelegate> {
	IBOutlet UIScrollView *rootScrollView;
	
    IBOutlet UIView *topView;
    IBOutlet UILabel *orderNoLabel;
    IBOutlet UILabel *creatDateLabel;
    IBOutlet UILabel *totalPriceLabel;
    IBOutlet UILabel *ticketPriceLabel;
    IBOutlet UILabel *ticketTaxLabel;
    IBOutlet UILabel *insuranceLabel;
    IBOutlet UILabel *postAddressLabel;
    IBOutlet UILabel *postAddressNoteLabel;

    BaseBottomBar *bottomBar;

    NSString *orderStatus;
    NSString *returnRegulateString;
    NSString *changeRegulateString;
    NSString *deliveryAddressString;
    NSString *ticketGetTypeString;
    NSString *deliveryPersonString;
    NSString *deliverString;
    NSString *deliverPostCodeString;

    int ticketGetType;
    int offY;

    NSMutableArray *passArray;
    NSMutableDictionary *sourceDic;
    
    //增加保存到相册
    UIImageView *m_imgview;
    UIImage *captureimage;
    
    UIScrollView *photoview;
    UIImagePickerController *imagePickerController;

    //z支付
    IBOutlet UIButton *againPayBtn;
    NSString *payType;
    id<FlightOrderHistoryDetailDelegate> delegate;
    NSString *netType;

    int flightIndex;
    UIButton *orderBtn;

    UIButton *mapModelBtn;
    UIButton *filterBtn;
    BOOL isStops;
    BOOL jumpToSafari;
    FlightOrderHistroyDetailPassnerInfoViewController *detailPassengerViewCtrl;
}


@property (nonatomic,assign) id<FlightOrderHistoryDetailDelegate> delegate;
@property(nonatomic,copy) NSString *orderStatus;

-(UIImage *) screenshotOnCurrentView;
-(void) shareOrderInfo;
-(UIImage *)captureCurrentView;
- (void)moveview;


- (id)initWithData:(NSDictionary *)dataDic;
-(void)againPayByalipay;
-(void) paySuccess;		//获取支付后的信息
+(FlightOrderHistoryDetail *) instance;
+(void) setInstance:(FlightOrderHistoryDetail *)inst;
- (void) addScheduleToCalendar:(id) sender;
- (void) addSchedule;
-(void)addListFooterView;
-(NSString *) weiboContent;
-(NSString *) mailContent;
-(NSString *) smsContent;
@end

