//
//  Hotel.h
//  ElongClient
//
//  Created by bin xing on 11-1-10.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelDetailController.h"
#import "AccountManager.h"
#import "Utils.h"
#import "HotelConfig.h"

@interface JHotelOrder : NSObject {
	NSMutableDictionary *contents;
}

@property (nonatomic, assign) NSInteger orderCount;         // 纪录订单内间夜数
@property (nonatomic, retain) NSDictionary *invoiceDic;     // 酒店发票对象

-(CGFloat)getTotalPrice;

- (void)setTotalPrice:(double)price;

-(NSString *)getConnectorName;

-(NSString *)getConnectorMobile;

-(int)getRoomCount;

-(NSString *)getArriveDate;

-(NSString *)getLeaveDate;

-(NSString *)getArriveTimeEarly;

-(NSString *)getArriveTimeLate;

-(NSString *)getArriveTime;

- (NSString *)getOnlyArriveTime;			// 获取不含中文说明的时间

-(NSArray *)getGuestNames;

-(NSString *)getCurrency;

- (NSArray *)getCoupons;

-(void)clearBuildData;

-(void)setCoupons:(NSArray *)coupons;

-(void)setClearCoupons;

- (void)setBaseInfo:(int)index;

-(void)setBaseInfo:(int)index useCoupon:(BOOL)useCoupon;

-(void)setBookingInfo:(int)index roomcount:(int)roomcount guestnames:(NSArray *)guestnames;

-(void)setConnectorInfo:(NSString *)mobile;

- (void)setArriveTimeEarly:(NSString *)earlyTime Late:(NSString *)lateTime;

-(void)setBookingDate;

- (void)setToPrePay;

- (void)setVouch:(VouchSetType)vouchSetType vouchMoney:(CGFloat)vouchMoney;
-(void)setVouch:(VouchSetType)vouchSetType vouchMoney:(CGFloat)vouchMoney vouchData:(NSMutableDictionary *)vouchData;

-(NSString *)requesString:(BOOL)iscompress;

-(int)getSelectedCouponsCount;

-(void)setArriveTimeRange:(NSRange)timeRange;

-(void)setOrderNo:(id)orderno;

-(void)setCurrency:(NSString *)currency;

-(long)orderNo;

-(void)setSupperCardNo:(NSString* )SupplierCardNoString;

- (void)setCashAmount:(CGFloat)cashNum;             // 设置现金账户支付数额

- (NSNumber *)getCashAmount;                              // 获取现金账户支付数额
- (void)setInvoiceDic:(NSDictionary *)invoiceDic;   // 设置发票
- (NSDictionary *)getInvoiceDic;        // 获取发票

- (void)setAlipayInfo:(NSString *)returnURL withCancelURL:(NSString *)cancelURL withName:(NSString *)name withBody:(NSString *)body;

- (void) setNotesToElong:(NSString *)notes;

- (void) setNotesToHotel:(NSString *)notes;

@end