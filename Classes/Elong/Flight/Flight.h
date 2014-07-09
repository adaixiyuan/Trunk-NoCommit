//
//  Flight.h
//  ElongClient
//  单个航班信息
//  Created by dengfang on 11-2-11.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlightDataDefine.h"

@interface Flight : NSObject {
	NSMutableString *departTime;
	NSMutableString *arriveTime;
	NSMutableString *airCorpCode;			//add
	NSMutableString *departAirportCode;		//add
	NSMutableString *departAirport;
	NSMutableString *arriveAirportCode;		//add
	NSMutableString *arriveAirport;
	NSMutableString *airCorpName;
	NSMutableString *flightNumber;
	NSMutableString *planeType;
	NSMutableString *classTag;
	NSMutableString *typeName;
	NSMutableString *timeOfLastIssued;
	NSMutableArray* siteseatArray;
	
	NSNumber *oilTax;		//double
	NSNumber *airTax;		//int
	NSNumber *classType;
	NSNumber *price;
	NSMutableString *ticktenum;
	NSNumber *discount;
	NSNumber *isEticket;
	NSNumber *promotionID;      //促销id
	NSNumber *kilometers;       //int
	NSNumber *isPromotion;      //是否促销
	NSNumber *stops;            //是否经停
	NSNumber *issueCityId;      //收集后直接提交订单用
	
	NSMutableDictionary *vertifyFlightClassDict;
	
    // Add 2014/02/12
    NSNumber *adultAirTax;
    NSNumber *adultOilTax;
    NSNumber *childAirTax;
    NSNumber *childOilTax;
    NSNumber *adultPrice;
    NSNumber *childPrice;
    // End
}

@property (nonatomic, copy) NSString *returnRule;
@property (nonatomic, copy) NSString *changeRule;
@property (nonatomic, copy) NSString *signRule;             // 签转规则
@property (nonatomic, copy) NSString *tReturnRule;          // 中转退票规定
@property (nonatomic, copy) NSString *tChangeRule;          // 中转改签规定
@property (nonatomic, copy) NSString *transInfo;            // 中转信息
@property (nonatomic, copy) NSString *tAirCorp;             // 中转航空公司
@property (nonatomic, copy) NSString *tDepartAirPort;       // 中转出发机场
@property (nonatomic, copy) NSString *tDepartAirPortCode;   // 中转出发机场代号
@property (nonatomic, copy) NSString *tArrivalAirPort;      // 中转到达机场
@property (nonatomic, copy) NSString *tArrivalAirPortCode;  // 中转到达机场
@property (nonatomic, copy) NSString *tFlightNum;           // 中转航班号
@property (nonatomic, copy) NSString *tAirFlightType;       // 中转航班类型
@property (nonatomic, copy) NSString *tDepartTime;          // 中转出发时间
@property (nonatomic, copy) NSString *tArrivalTime;         // 中转到达时间
@property (nonatomic, copy) NSString *tAirCorpCode;         // 中转机场编号
@property (nonatomic, copy) NSString *stopDescription;      // 经停机场和时间
@property (nonatomic, copy) NSString *defaultCoupon;        // 机票默认返现金额（列表）
@property (nonatomic, retain) NSNumber *currentCoupon;      // 机票使用的返现金额（详情）
@property (nonatomic, retain) NSNumber *tKilometers;        // 中转航班行程
@property (nonatomic, assign) NSInteger stopNumber;         // 经停次数
@property (nonatomic, assign) BOOL isTransited;             // 是否中转
@property (nonatomic, assign) BOOL isLegislationPirce;      // 是否是立减价格
@property (nonatomic, assign) BOOL isContainLegislation;    // 是否有立减
@property (nonatomic, retain) NSMutableDictionary *vertifyFlightClassDict;
@property (nonatomic, retain) NSArray *stopInfos;           // 经停信息
@property (nonatomic, copy) NSString *originalPrice;        // 机票原价

@property (nonatomic, copy) NSString *shoppingOrderParams;  // Shopping产品成单相关参数集合
@property (nonatomic, retain) NSNumber *ticketChannel;      // 机票渠道来源分类
@property (nonatomic, retain) NSDictionary *sitePricesDetail;   // 51产品仓位价格详细

@property (nonatomic, retain) NSNumber *ticketCount;        // 剩余票量
@property (nonatomic, retain) NSNumber *isSharedProduct;    // 是否是共享产品
@property (nonatomic, retain) NSNumber *isOneHour;          // 是否一小时飞人

- (void)buildPostData:(BOOL)clearFlightClass;
- (NSString *)requesString:(BOOL)iscompress;

- (void)setSiteseatArray:(NSMutableArray *)data;
- (NSMutableArray *)getSiteseatArray;

- (void)setDepartTime:(NSString *)data;
- (NSMutableString *)getDepartTime;
- (void)setArriveTime:(NSString *)data;
- (NSMutableString *)getArriveTime;
- (void)setAirCorpCode:(NSString *)data;
- (NSMutableString *)getAirCorpCode;
- (void)setDepartAirportCode:(NSString *)data;
- (NSMutableString *)getDepartAirportCode;
- (void)setDepartAirport:(NSString *)data;
- (NSMutableString *)getDepartAirport;
- (void)setArriveAirportCode:(NSString *)data;
- (NSMutableString *)getArriveAirportCode;
- (void)setArriveAirport:(NSString *)data;
- (NSMutableString *)getArriveAirport;
- (void)setAirCorpName:(NSString *)data;
- (NSMutableString *)getAirCorpName;
- (void)setFlightNumber:(NSString *)data;
- (NSMutableString *)getFlightNumber;
- (void)setPlaneType:(NSString *)data;
- (NSMutableString *)getPlaneType;
- (void)setClassTag:(NSString *)data;
- (NSMutableString *)getClassTag;
- (void)setTypeName:(NSString *)data;
- (NSMutableString *)getTypeName;
- (void)setTimeOfLastIssued:(NSString *)data;
- (NSMutableString *)getTimeOfLastIssued;

- (void)setTicketnum:(NSString*)data;
- (NSMutableString *)getTicketnum;
- (void)setOilTax:(double)data;
- (NSNumber *)getOilTax;
- (void)setAirTax:(int)data;
- (NSNumber *)getAirTax;
- (void)setClassType:(int)data;
- (NSNumber *)getClassType;
- (void)setDiscount:(double)data;
- (NSNumber *)getDiscount;
- (void)setPrice:(int)data;
- (NSNumber *)getPrice;
- (void)setIsEticket:(BOOL)data;
- (NSNumber *)getIsEticket;
- (void)setPromotionID:(int)data;
- (NSNumber *)getPromotionID;
- (void)setKilometers:(int)data;
- (NSNumber *)getKilometers;
- (void)setIsPromotion:(BOOL)data;
- (NSNumber *)getIsPromotion;
- (void)setStops:(BOOL)data;
- (NSNumber *)getStops;
- (void)setIssueCityId:(int)data;
- (NSNumber *)getIssueCityId;

// Add 2014/02/12
- (void)setAdultAirTax:(double)adAirTax;
- (NSNumber *)getAdultAirTax;
- (void)setAdultOilTax:(double)adOilTax;
- (NSNumber *)getAdultOilTax;
- (void)setChildAirTax:(double)chAirTax;
- (NSNumber *)getChildAirTax;
- (void)setChildOilTax:(double)chOilTax;
- (NSNumber *)getChildOilTax;

- (void)setAdultPrice:(double)adPrice;
- (NSNumber *)getAdultPrice;
- (void)setChildPrice:(double)chPrice;
- (NSNumber *)getChildPrice;
// End

@end
