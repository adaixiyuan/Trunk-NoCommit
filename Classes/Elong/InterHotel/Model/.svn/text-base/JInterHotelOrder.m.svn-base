//
//  JInterHotelOrder.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "JInterHotelOrder.h"
#import "Utils.h"
#import "InterHotelDefine.h"
#import "AccountManager.h"
#import "PostHeader.h"

@interface JInterHotelOrder ()

@property(nonatomic,retain) NSMutableDictionary *contents;

-(int)convertLandCertificateTypeToInter:(int)type;          //将国内的证件标识转化为国际标准形式。-----注意不要忽略-----
@end

@implementation JInterHotelOrder
@synthesize contents;

- (void)dealloc
{
    [contents release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        if(!contents){
            contents = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        [self.contents removeAllObjects];
        [self buildPostData:YES];
    }
    return self;
}

//是否重置数据
- (void)buildPostData:(BOOL)clearRoomPost{
    if(clearRoomPost){
        [self.contents safeSetObject:[PostHeader header] forKey:Resq_Header];
        [contents safeSetObject:[NSNull null] forKey:Req_ClientOrderId];
        [contents safeSetObject:[NSNull null] forKey:Req_MemberShip];
        [contents safeSetObject:[NSNull null] forKey:Req_ContactPerson];
        [contents safeSetObject:[NSNull null] forKey:Req_Invoices];
        [contents safeSetObject:[NSNull null] forKey:Req_CreditCardInfo];
        NSMutableDictionary *interProducts = [[NSMutableDictionary alloc] initWithCapacity:1];  
        [contents safeSetObject:interProducts forKey:Req_InterHotelProducts];
        [interProducts release];

    }
}

//获取对象
-(id)getObjectForKey:(NSString *)key{
    id obj = [self.contents safeObjectForKey:key];
    
    return obj;
}

//请求Content
- (NSString *)requestString:(BOOL)iscompress{
    if ([[ServiceConfig share] monkeySwitch]) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"action=GlobalHotelCreateOrder&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[self.contents JSONRepresentationWithURLEncoding]];
}


//获得唯一序列号
NSString * gen_uuid()
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL,uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}
//创建唯一序列号
-(void)setGuid{
    NSString *guid = gen_uuid();
    [contents safeSetObject:guid forKey:Req_ClientOrderId];  //创建唯一序列号
    NSLog(@"Current Guid:%@",guid);
}

//创建会见卡号
-(void)setMemberShip{
    NSString *cardNo = [[AccountManager instanse] cardNo];
    [contents safeSetObject:cardNo forKey:Req_MemberShip];
}

//创建联系人信息
-(void)setContactPersonWithEmail:(NSString *)email  telPhone:(NSString *)telPhone{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict safeSetObject:email forKey:Req_Email];
    [dict safeSetObject:telPhone forKey:Req_MobileTelephone];
    NSString *name = [[AccountManager instanse] name];
    [dict safeSetObject:name forKey:Req_ContactPersonName];
    
    [contents safeSetObject:dict forKey:Req_ContactPerson];
    [dict release];
}

//创建发票信息
-(void)setInvoicesInfoWithTitle:(NSArray *)invoiceTitles{
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for(int i=0;i<invoiceTitles.count;i++){
        NSString *invoiceTitle = [invoiceTitles safeObjectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict safeSetObject:invoiceTitle forKey:Req_InvoiceTitle];
        [mutArray addObject:dict];
        [dict release];
    }
    [contents safeSetObject:mutArray forKey:Req_Invoices];
    [mutArray release];
}

//设置订单总价
-(void)setOrderTotalPrice:(float)totalPrice withDiscountTotal:(float)discountTotalPrice{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];

    [dict safeSetObject:[NSNumber numberWithFloat:totalPrice] forKey:Req_OrderTotalPrice];
    [dict safeSetObject:[NSNumber numberWithFloat:discountTotalPrice] forKey:Req_CouponDiscount];      //优惠价格
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

//设置入住人信息
-(void)setTravellers:(NSArray *)travellers{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for(int i=0;i<travellers.count;i++){
        NSString *travellerName = [travellers safeObjectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict safeSetObject:travellerName forKey:Req_TravellerName];
        [mutArray addObject:dict];
        [dict release];
    }
    [dict safeSetObject:mutArray forKey:Req_Travellers];
    [mutArray release];
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

//设置酒店信息
-(void)setOrderHotelId:(NSString *)hotelId hotelName:(NSString *)hotelName address:(NSString *)address{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];

    [dict safeSetObject:hotelId forKey:Req_HotelID];
    [dict safeSetObject:hotelName forKey:Req_HotelName];
    [dict safeSetObject:address forKey:Req_HotelAddress];
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

//设置到店日期和离店日期
-(void)setArrivalDate:(NSString *)arrivalDate andDepartDate:(NSString *)departDate{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];
    
    [dict safeSetObject:arrivalDate forKey:Req_CheckInDate];
    [dict safeSetObject:departDate forKey:Req_CheckOutDate];
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

//设置特殊需求
-(void)setSepecialNeeds:(NSString *)sepecialNeed{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];

    [dict safeSetObject:sepecialNeed forKey:Req_SpecialNeeds];
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

//设置房间信息
-(void)setRoomInfo:(NSArray *)roomList{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];

    [dict safeSetObject:roomList forKey:Req_InterHotelRoomTypes];
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

//设置促销标识
-(void)setPromotionFlag:(int)promotionFlag{ 
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];
    
    [dict safeSetObject:[NSNumber numberWithInt:promotionFlag] forKey:Req_PromotionTag];
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

//设置供应商类型
-(void)setSupplierType:(NSString *)supplierType{    
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];
    
    [dict safeSetObject:supplierType forKey:Req_RoomSupplierType];
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
    
}

-(int)convertLandCertificateTypeToInter:(int)type{
    switch (type) {
        case 0:     //身份证
        case 8001:
            return 8001;
            break;
        case 1: //军人证或军官证
        case 8004:
            return 8004;
            break;
        case 2: //回乡证
        case 8003:
            return 8003;
            break;
        case 3: //港澳通行证
        case 8006:
            return 8006;
            break;
        case 4: //护照
        case 8002:
            return 8002;
            break;
        case 5:     //居留证
        case 8020:
            return 8020;
            break;
        case 6:     //其它
            return 8020;
            break;
        case 7:     //台胞证
        case 8005:
            return 8005;
            break;
        default:
            break;
    }
    return 8001;    //默认
}

//设置信用卡信息
-(void)setCreditCardData:(NSMutableDictionary *)vouchData{
	NSMutableDictionary *creditCardContents=[[NSMutableDictionary alloc] init];
    
    if([vouchData safeObjectForKey:@"CertificateNumber"]){
        int cerType = [[vouchData safeObjectForKey:@"CertificateType"] intValue];
        int interCerType = [self convertLandCertificateTypeToInter:cerType];        //转化为国际--身份证标识代码
        [creditCardContents safeSetObject:[NSNumber numberWithInt:interCerType]  forKey:@"CertificateType"];
        [creditCardContents safeSetObject:[vouchData safeObjectForKey:@"CertificateNumber"]  forKey:@"CertificateNO"];
    }
    
    [creditCardContents safeSetObject:[NSNumber numberWithBool:NO]  forKey:@"IsInternationalID"];   //是否国际信用卡 暂不支持，默认NO
    NSString *creditCardTypeName = @"";
    NSDictionary *dict = [vouchData safeObjectForKey:@"CreditCardType"];
    if(DICTIONARYHASVALUE(dict)){
        if(STRINGHASVALUE([dict safeObjectForKey:@"Name"])){
            creditCardTypeName = [dict safeObjectForKey:@"Name"];
        }
    }
	[creditCardContents safeSetObject:creditCardTypeName  forKey:@"PaymentCreditCardType"];
	[creditCardContents safeSetObject:[vouchData safeObjectForKey:@"CreditCardNumber"]  forKey:@"CreditCardNO"];
	[creditCardContents safeSetObject:[vouchData safeObjectForKey:@"HolderName"] forKey:@"HolderName"];
    if([vouchData safeObjectForKey:@"VerifyCode"]){
        [creditCardContents safeSetObject:[vouchData safeObjectForKey:@"VerifyCode"]  forKey:@"CreditVerifyCode"];
    }
    int year = [[vouchData safeObjectForKey:@"ExpireYear"] intValue];
    int month = [[vouchData safeObjectForKey:@"ExpireMonth"] intValue];
    NSString *expireTime = [NSString stringWithFormat:@"%d-%d",year,month];
	[creditCardContents safeSetObject:[TimeUtils makeJsonDateWithDisplayNSStringFormatter:expireTime formatter:@"yyyy-MM"]   forKey:@"ExpiredTime"];
	[contents safeSetObject:creditCardContents forKey:@"CreditCardInfo"];
	[creditCardContents release];
}

-(float)getCashAmount{
    return  0;//[[contents safeObjectForKey:CASHAMOUNT] floatValue];
}

-(void)setCashAmount:(float)cashAmount{
//    [contents safeSetObject:[NSString stringWithFormat:@"%.2f", cashAmount] forKey:CASHAMOUNT];
}

//新增 为了Mis系统显示完全
//设置城市名以及城市Code
-(void)setCityEnName:(NSString *)cityEnName andCountryCode:(NSString *)countryCode{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];

    [dict safeSetObject:cityEnName forKey:Req_HotelCity];
    [dict safeSetObject:countryCode forKey:Req_HotelCountry];
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

-(void)setCurrencyCode:(NSString *)currencyCode{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];

    [dict safeSetObject:currencyCode forKey:Req_CurrencyCode];
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

//设置房间总价 房间单间原价 房间单间现价 和总税
-(void)setAverageBaseRate:(float)baseRate averageRate:(float)rate andSurchargeTotal:(float)surchargeTotal{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];

    [dict safeSetObject:[NSNumber numberWithFloat:baseRate] forKey:Req_AverageBaseRate];         //平均房间原价
    [dict safeSetObject:[NSNumber numberWithFloat:rate] forKey:Req_AverageRate];             //促销价
    [dict safeSetObject:[NSNumber numberWithFloat:surchargeTotal] forKey:Req_SurchargeTotal];        //总税费
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
    
}
//设置今夜最大价钱 今夜房间总价
-(void)setMaxNightRate:(float)maxNightRate nightlyRateTotal:(float)nightlyRateTotal{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];

    [dict safeSetObject:[NSNumber numberWithFloat:maxNightRate] forKey:Req_MaxNightlyRate];   //暂不知道功能何用
    [dict safeSetObject:[NSNumber numberWithFloat:nightlyRateTotal] forKey:Req_NightlyRateTotal];    //用于Mis中价格计算中的房间总价格
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}
//设置房间信息描述
-(void)setRoomANameDesc:(NSString *)roomDesc{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];

    [dict safeSetObject:roomDesc forKey:Req_RoomANameDesc];      //用于Mis系统中，房型信息的提示显示
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

//房型附加信息
-(void)setRoomAddValues:(NSString *)addValues{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];
    
    [dict safeSetObject:addValues forKey:Req_AddValues];      //用于Mis系统中，房型信息的提示显示
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}

//设置取消政策
-(void)setCancelPolicy:(NSString *)policy cancelType:(BOOL)type{
    NSMutableDictionary *dict = [contents safeObjectForKey:Req_InterHotelProducts];
    
    [dict safeSetObject:policy forKey:Req_Cancelpolicy];        //取消政策内容
    [dict safeSetObject:[NSNumber numberWithBool:type] forKey:Req_IsCanCancel];     //是否能取消标识
    [contents safeSetObject:dict forKey:Req_InterHotelProducts];
}


@end
