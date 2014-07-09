//
//  FlightOrderDetailCell.h
//  ElongClient
//
//  Created by Janven on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightOrderDetail.h"
@class  FlightOrderDetailCell;
@protocol OrderDetailCellDelegate <NSObject>

-(void)gotoTheChooseSeatsViewController;
//by lc
-(void)orderDetailCellDelegate:(FlightOrderDetailCell *)sender refundgo:(BOOL)refundgo refundback:(BOOL)refundback refund:(BOOL)refund actionBTN:(UIButton *)actionBTN;

@end

@interface FlightOrderDetailCell : UITableViewCell{

    id<OrderDetailCellDelegate>_delegate;
}
@property (nonatomic,assign)id<OrderDetailCellDelegate>delegate;
@property (nonatomic,retain) AirLineInfo *airInfo;

//OrderRelated
@property (retain, nonatomic) IBOutlet UILabel *OrderPostAddress;
@property (retain, nonatomic) IBOutlet UILabel *OrderNum;
@property (retain, nonatomic) IBOutlet UILabel *OrderTime;
@property (retain, nonatomic) IBOutlet UILabel *OrderTotalMoney;
@property (retain, nonatomic) IBOutlet UILabel *FlightMoney;
@property (retain, nonatomic) IBOutlet UILabel *InsuranceMoney;
@property (retain, nonatomic) IBOutlet UILabel *AirportFee;
@property (retain,nonatomic) IBOutlet UILabel *ServiceFee;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UILabel *orderTip;
@property (retain, nonatomic) IBOutlet UIButton *chooseSeatBtn;


//FlightRelated
@property (retain, nonatomic) IBOutlet UIImageView *TypeIcon;
@property (retain, nonatomic) IBOutlet UILabel *FlightType;
@property (retain, nonatomic) IBOutlet UILabel *FlightDateAndAirline;
@property (retain, nonatomic) IBOutlet UILabel *FlightStatus;
@property (retain, nonatomic) IBOutlet UILabel *FlightStartTime;
@property (retain, nonatomic) IBOutlet UILabel *FlightStartAirport;
@property (retain, nonatomic) IBOutlet UILabel *FlightEndTime;
@property (retain, nonatomic) IBOutlet UILabel *FlightEndAirport;
@property (retain, nonatomic) IBOutlet UILabel *FlightCabin;
@property (retain, nonatomic) IBOutlet UIButton *Ruels;

//PassengersRelated
@property (retain, nonatomic) IBOutlet UILabel *PassengerName;
@property (retain, nonatomic) IBOutlet UILabel *IdentifierAndNum;
@property (retain, nonatomic) IBOutlet UILabel *HasInsurance;
@property (retain, nonatomic) IBOutlet UIButton *refundgo;  //去程退票
@property (retain, nonatomic) IBOutlet UIButton *refundback; //返程退票
@property (retain, nonatomic) IBOutlet UIButton *refund;     //申请退票
@property(nonatomic,retain)UIImageView * topLineImgView;      //上边的线
@property(nonatomic,retain)UIImageView * bottomLineImgView;   //下边的线


//返程
-(IBAction)applygoTikets:(id)sender;  //申请去程退票
-(IBAction)applybackTikets:(id)sender;  //申请返程退票
//单程
-(IBAction)applysingelTikets:(id)sender;  //申请退票


- (IBAction)tapAndGoRuels:(id)sender;
- (IBAction)chooseSeatsAction:(id)sender;

//PassengerSeatsRelated
@property (retain, nonatomic) IBOutlet UILabel *passenger;
@property (retain, nonatomic) IBOutlet UILabel *flight;
@property (retain, nonatomic) IBOutlet UILabel *startToEnd;
@property (retain, nonatomic) IBOutlet UILabel *seatStatus;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

-(void)bindTheDisplayOrder:(FlightOrderDetail *)model;
-(void)bindTheDisplayModelOfTicketsRelated:(TicketInfo *)ticketInfo andFlyType:(NSString *)type;
-(void)bindTheDisplayModelOfPassenger:(PassengerTiketInfo *)passenger isBackandForth:(BOOL)isBackandForth cellrow:(int)cellrow passengerCount:(int)passengerCount;
@end
