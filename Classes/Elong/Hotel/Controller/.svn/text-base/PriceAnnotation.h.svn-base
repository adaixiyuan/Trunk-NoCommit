//
//  PriceAnnotation.h
//  ElongClient
//
//  Created by bin xing on 11-1-28.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <MapKit/MapKit.h>
typedef enum{
    Default=0,          // Default
    Longcui,            // 龙萃
    LastMinute,         // LM
    LongCuiAndLM,       // 龙萃 and LM
    MapHome,            // 终点
    StartPoint,         // 起点
    Bank,               // 银行
    Sight,              // 景点
    Cate,               // 美食
    Shopping,           // 购物
    Entertainment       // 娱乐
}HotelSpecialType;

@interface PriceAnnotation : NSObject <MKAnnotation>
{
	NSString *title; 
    NSString *subtitle; 
	CLLocationCoordinate2D coordinate; 
	NSString *hotelid;
	int index;
}

@property (nonatomic, copy) NSString *hotelid;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle; 
@property (nonatomic, copy) NSString *priceStr;
@property (nonatomic, assign) double truePrice;
@property (nonatomic, copy) NSString *starLevel;
@property (nonatomic, assign) int index;
@property (nonatomic) HotelSpecialType hotelSpecialType;
@property (nonatomic) BOOL isUnsigned;   //是否未签约
@property (nonatomic) BOOL isLM;

-(void)setCoordinateStruct:(double)r l:(double)l;

@end