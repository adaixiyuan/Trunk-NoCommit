//
//  TrainOrderDetailViewController.h
//  ElongClient
//
//  Created by chenggong on 13-11-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "TrainTicketRefundView.h"
#import "TrainTicketRefundCheckView.h"
#import "BaseBottomBar.h"

typedef enum {
    OrderStateUnKnown,          // 未知
    ToBePay,                    // 待付款
    PayedAndToBeHandle,         // 已付款，待处理
    CanceledAndToBeRefund,      // 订单取消待退款
    Handling,                   // 处理中
    DraftSuccess,               // 出票成功
    DraftFailToBeRefund,        // 出票失败待退款
    Refunded                    // 已退款
}TrainOrderState;

typedef enum {
    TicketStateUnKnown,                 // 未知
    Refunding,                          // 退票中
    RefundTicketSuccessAndToBeRefund,   // 退票成功，待退款
    RefundTicketSuccessAndRefunded,     // 退票成功，已退款
    RefundTicketFail                    // 退票失败
}TrainTicketState;

@protocol TrainOrderDetailDelegate <NSObject>

- (void)orderDetailReturn:(NSDictionary *)orderInfo;

@end

@interface TrainOrderDetailViewController : DPNav<BaseBottomBarDelegate>
{
    BOOL jumpToSafari;          // 判断是否跳转到safari完成支付流程
}

@property (nonatomic, retain) IBOutlet UIScrollView *detailScrollView;
@property(nonatomic,retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UILabel *orderNumber;
@property (nonatomic, retain) IBOutlet UILabel *orderState;
@property (nonatomic, retain) IBOutlet UILabel *orderTotalAmount;
@property (nonatomic, retain) IBOutlet UILabel *trainNumber;
@property (nonatomic, retain) IBOutlet UILabel *seatNumber;
@property (nonatomic, retain) IBOutlet UILabel *howmuch;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *orderCreateDate;
@property (nonatomic, retain) IBOutlet UILabel *departureTime;
@property (nonatomic, retain) IBOutlet UILabel *arrivalTime;
@property (nonatomic, retain) IBOutlet UILabel *departureStation;
@property (nonatomic, retain) IBOutlet UILabel *arrivalStation;
@property (nonatomic, retain) IBOutlet UIView *stationView;
@property (nonatomic, retain) IBOutlet UIButton *alipayButton;
@property (nonatomic, retain) IBOutlet UILabel *balanceNotice;
@property (nonatomic, retain) IBOutlet UILabel *duration;
@property (nonatomic, retain) IBOutlet UILabel *tradeNumber;         // 流水号
@property (nonatomic, retain) IBOutlet UILabel *orderNo12306;    // 12306订单号
@property (nonatomic, retain) NSMutableArray *ticketArray;


@property (nonatomic, retain) NSArray *ticketInfoArray;
@property (nonatomic, retain) NSDictionary *orders;
@property (nonatomic, assign) NSUInteger m_netState;
@property (nonatomic, retain) TrainTicketRefundView *ticketRefundView;
@property (nonatomic, retain) TrainTicketRefundCheckView *ticketRefundCheckView;
@property (nonatomic, copy) NSString *checkCodeStream;
@property (nonatomic, retain) NSData *checkCodeData;
@property (nonatomic, retain) NSMutableDictionary *ticketKeys;
@property (nonatomic, assign) NSUInteger currentRefundButtonIndex;
@property (nonatomic, copy) NSString *alipayAddress;
@property (nonatomic, assign) id<TrainOrderDetailDelegate> delegate;
@property (nonatomic, copy) NSString *orderStatusCode;
@property (nonatomic, strong) HttpUtil *getPayStateUtil;
@property (nonatomic, assign) BOOL isPayStateLoading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil orders:(NSDictionary *)dictionary;

- (void)requestRefundInfo;
- (void)getVerificationCode:(id)sender;
- (void)releaseTicketRefundCheckView;
- (void)releaseTicketRefundView;
- (void)confirmRefund;

-(IBAction)alipay:(id)sender;
-(IBAction)goRuleAboutTakeTicket:(id)sender;

@end
