//
//  XGSearchFilter.h
//  ElongClient
//
//  Created by guorendong on 14-4-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XGHotelSearch.h"
#define timeOutMinute 10
#define NotifactionXGSearchFilterMessage @"XGSearchFilterPostNumber"//推送消息设置
@interface XGSearchFilter : NSObject<NSCoding>


-(NSString *)getCheckinString;
-(NSString *)getCheckoutString;

// by lc
@property(nonatomic,strong)NSDate *cinDate;
@property(nonatomic,strong)NSDate *coutDate;
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *cityArea;
@property(nonatomic,strong)NSString *maxPrice;
@property(nonatomic,strong)NSString *minPrice;
@property(nonatomic,strong)NSNumber *longtitude;
@property(nonatomic,strong)NSNumber *lattitude;
@property(nonatomic,strong)NSNumber *searchType;
@property(nonatomic,strong)NSString *FacilitiesFilter;//102大床房 103 双床房 不限的话为空或者nil 或者@""

//以上属性勿动
@property(nonatomic,strong)XGHotelSearch *hotelSearch;//开始日期
@property(nonatomic,strong)NSString *reqId;//请求ID用于保存
@property(nonatomic) long long timestamp;
#pragma mark - 用于记录请求时间等信息
@property(nonatomic)int sendNum;//发送给多少家酒店
@property(nonatomic)int reponseReplayNum;//后面又有多少家酒店回应了你的请求
@property(nonatomic)int perResponseNum;//上次请求的数据响应的数量
@property(nonatomic,strong)NSDate *customerRequestDate;//开始请求时间
@property(nonatomic,assign)float pinglvForgetResponseCount;//获取回应数据的频率


-(BOOL)isTimingOut;//是否已经超过预定时间
-(NSInteger)loadingDate;//过了多少秒了
-(NSInteger)remainDate;//剩余多少秒了0
//保存到本地文件
-(void)saveFilter;
//获取
+(XGSearchFilter *)getFilter;
//保存上一个查询filter
-(void)savePerFilter;

+(XGSearchFilter *)getPerFilter;

//当前时间与上面时间的误差 当前时间减去参数时间
-(NSTimeInterval)getDifferentSecond:(NSDate *)date;

-(void)setHotelSearchFilterForSelf;


// by lc
//清理酒店搜索条件
-(void)clearSearChCondition;

-(BOOL)hadEqualAndNoTimeOut:(XGSearchFilter *)filter;

@end
