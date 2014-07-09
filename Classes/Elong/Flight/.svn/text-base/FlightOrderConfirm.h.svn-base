//
//  FlightOrderComfirm.h
//  ElongClient
//  机票订单确认
//  Created by dengfang on 11-1-31.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "ElongURL.h"
#import "UniformCounterViewController.h"

@class FXLabel;
@interface FlightOrderConfirm : DPNav <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    UITableView *contentTable;
    NSMutableArray *flights;
    NSMutableArray *returnFlights;
	
	IBOutlet UIView *bgView_3;
	IBOutlet UILabel *contactLabel;
	IBOutlet UILabel *addressTitleLabel;
	IBOutlet UILabel *addressLabel;
	IBOutlet UIView *priceView;
	FXLabel *priceLabel;
	
	IBOutlet UIScrollView *rootScrollView;
    UIButton *departRuleButton;            // 去程退改签按钮（或中转上半段）
    UIButton *tDepartRuleButton;           // 去程中转退改签按钮（下半段）
    UIButton *arriveRuleButton;            // 返程退改签按钮（或中转上半段）
    UIButton *tArriveRuleButton;           // 返程中转退改签按钮（下半段）
	IBOutlet UIView *middleView;
	NSMutableArray *customersArray;
    NSMutableArray *tableHeights;
    NSMutableArray *selectedCells;         // 纪录打开退改签的行数
	NSDictionary *cardDict;
    UIImage *passtosuccessimg;
    
    CGRect rectDepartRule;            // 去程退改签frame（或中转上半段）
    CGRect rectTdepartRule;           // 去程中转退改签frame（或中转上半段）
    CGRect rectArriveRule;            // 返程退改签frame（或中转上半段）
    CGRect rectTarriveRule;           // 返程中转退改签frame（或中转上半段）
    
    NSInteger heightDepartRule;       // 去程退改签高度（或中转上半段）
    NSInteger heightTdepartRule;      // 去程中转退改签高度（或中转上半段）
    NSInteger heightArriveRule;       // 返程退改签高度（或中转上半段）
    NSInteger heightTarriveRule;      // 返程中转退改签高度（或中转上半段）
    NSInteger couponCount;            // 消费券使用额
    
    NSInteger netType;
}

@property (nonatomic, assign) BOOL isRoundTrip;
@property (nonatomic, assign) NSUInteger passengerCellHeight;
@property (nonatomic, assign) NSInteger allCostPrice;
@property (nonatomic, assign) NSInteger costPrice;
@property (nonatomic, assign) NSInteger costOilTaxPrice;
@property (nonatomic, assign) NSInteger costAirTaxPrice;
@property (nonatomic, assign) NSInteger costInsurancePrice;
@property (nonatomic, assign) BOOL isPriceDetailSelected;

- (UIImage *)captureView;
- (id)init:(NSString *)name style:(NavBtnStyle)style card:(NSMutableDictionary *)dict;

- (void)nextState:(UniformPaymentType)paymentType;          // 根据选择的支付方式进行下一步

@end
