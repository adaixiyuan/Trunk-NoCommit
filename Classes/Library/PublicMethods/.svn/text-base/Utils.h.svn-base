//
//  Utils.h
//  ElongClient
//
//  Created by bin xing on 11-1-13.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlightData.h"
#import "TimeUtils.h"
#import "HttpUtil.h"

#define DEFAULT_DATEFORMAT (@"yyyy-MM-dd")
#define CHINESE_DATEFORMAT (@"yyyy年MM月dd日")
#define DEFAULT_TIMEFORMAT (@"HH:mm")

typedef enum
{
    IDCARD_IS_VALID = 0,                            //合法身份证
    IDCARD_LENGTH_SHOULD_NOT_BE_NULL,               //身份证号码不能为空
    IDCARD_LENGTH_SHOULD_BE_MORE_THAN_15_OR_18,     //身份证号码长度应该为15位或18位
    IDCARD_SHOULD_BE_15_DIGITS,                     //身份证15位号码都应为数字
    IDCARD_SHOULD_BE_17_DIGITS_EXCEPT_LASTONE,      //身份证18位号码除最后一位外，都应为数字
    IDCARD_BIRTHDAY_SHOULD_NOT_LARGER_THAN_NOW,     //身份证出生年月日不能大于当前日期
    IDCARD_BIRTHDAY_IS_INVALID,                     //身份证出生年月日不是合法日期
    IDCARD_REGION_ENCODE_IS_INVALID,                //输入的身份证号码地域编码不符合大陆和港澳台规则
    IDCARD_IS_INVALID,                              //身份证无效，不是合法的身份证号码
    IDCARD_PARSER_ERROR,                            //解析身份证发生错误
}IdCardValidationType;

@interface Utils : NSObject {
	
}
+ (void)clearFlightData;
+ (void)setButton:(UIButton *)button normalImage:(NSString *)normalImageName pressedImage:(NSString *)pressedImageName;
///view use animation 
+ (void)animationView:(UIView *)aView fromFrame:(CGRect)fromFrame
			  toFrame:(CGRect)toFrame
				delay:(float)delayTime
			 duration:(float)durationTime;

///view use animation
+ (void)animationView:(UIView *)aView
				fromX:(float)fromX
				fromY:(float)fromY
				  toX:(float)toX
				  toY:(float)toY
				delay:(float)delayTime
			 duration:(float)durationTime;
+(BOOL)checkJsonIsError:(NSDictionary *)root;
+(BOOL)checkJsonIsErrorNoAlert:(NSDictionary *)root;
+ (NSNumber *)getCertificateType:(NSString *)key;
+(void)request:(NSString *)url req:(NSString *)req delegate:(id)delegate;			// 用于普通请求，超时时间较短
+ (void)orderRequest:(NSString *)url req:(NSString *)req delegate:(id)delegate;		// 用于订单的请求，超时时间较长
+(void)popSimpleAlert:(NSString *)title msg:(NSString *)msg;
+(void)alert:(NSString *)title;
+(void)alertQuiet:(NSString *)title;

+ (NSString *)getOrderStatusIcon:(int)orderStatus;
+ (NSString *)getTicketStatusName:(NSString *)flightS dict:(NSDictionary *)dict;
+ (int)getTicketStatus:(NSString *)flightS dict:(NSDictionary *)dict;


+ (NSString *)getAirCorpPicName:(NSString *)airCorpName;
+ (NSString *)getAirCorpShortName:(NSString *)airCorpName;
+ (UIColor *)getFlightStatusColor:(NSInteger)statusCode;
+ (UIView *)addView:(NSString *)string;
+ (NSString *)getCertificateName:(int)key;
+ (int)getClassTypeID:(NSString *)name;
+ (NSString *)getClassTypeName:(int)type;
+(void)request:(NSString *)url req:(NSString *)req delegate:(id)delegate disablePop:(BOOL)disablePop disableClosePop:(BOOL)disableClosePop disableWait:(BOOL)disableWait;
+ (void)request:(NSString *)url req:(NSString *)req policy:(CachePolicy)policy delegate:(id)delegate;
+ (void)clearHotelData;

+ (NSDate *) getBirthday: (NSString *)idNumber;
+ (IdCardValidationType)isIdCardNumberValid:(NSString *)idNumber;

// 获取关注信息
+ (NSMutableArray *)arrayAttention;
// 保存关注信息
+ (void)saveAttention:(NSMutableArray *)arrayAttention;
+ (NSArray *) switchMonth:(NSArray *)dateCompents;

// 获取保存的数据
+ (NSMutableArray *)arrayDateSaved:(NSString *)saveFileName andSaveKey:(NSString *)keyName;
// 保存数据
+ (void)saveData:(NSMutableArray *)arrayDataSaved withFileName:(NSString *)saveFileName andSaveKey:(NSString *)keyName;

// 得到星期几
+ (NSString *)getShortWeekend:(NSDate *)newDate;

@end
