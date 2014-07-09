//
//  HotelSearch.h
//  ElongClient
//  酒店查询
//
//  Created by bin xing on 11-2-25.
//  Copyright 2011 DP. All rights reserved.
//
//  增加日历在从后台切回时自动刷新的功能 by 赵海波 on 14-03-23

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "InterHotelKeywordSearchController.h"
#import "ELCalendarViewController.h"
#import "iflyMSC/IFlySpeechUser.h"
#import "IFlyMSCViewController.h"
#import "HotelSearchConditionViewCtrontroller.h"

typedef enum {
    HotelSearchInland,
    HotelSearchInternational
}HotelSearchType;

typedef enum {
    HotelNaviPOI,
    HotelNaviList
}HotelNaviType;

@class CustomSegmented;
@class PriceRange;
@class SelectTable;
@class RoundBadgeImage;

@interface HotelSearch : DPNav<InterHotelKeywordSearchDelegate,ElCalendarViewSelectDelegate,IFlyMSCViewControllerDelegate,HotelSearchConditionDelegate> {
@public
    	int currentTag;
@private
    IBOutlet UIButton *chooseCityBtn;
	IBOutlet UIButton *chooseCondition;
	IBOutlet UIButton *chooseCheckInBtn;
	UIButton *searchBtn;
    UIButton *c2cSearchBtn;
	
	IBOutlet UIView *m_cityView;
	IBOutlet UIView *m_dateView;
	
	IBOutlet UILabel *checkInDayLabel;
	IBOutlet UILabel *checkInMonthLabel;
	IBOutlet UILabel *checkInWeekDayLabel;
    
	IBOutlet UILabel *checkOutDayLabel;
	IBOutlet UILabel *checkOutMonthLabel;
	IBOutlet UILabel *checkOutWeekDayLabel;
	
	PriceRange *m_priceRangeController;
	CGRect m_dateFrame;
	CGRect m_dateCacheFrame;
	CGRect m_cityFrame;
	CGRect m_otherFrame;
	CGRect m_buttonFrame;
    int netstate;
	int preTag;
	int lastIndex;
	NSMutableArray *m_tabItemsArray;
	CustomSegmented *seg;
	BOOL isShaked;						// 是否是通过摇动进入
	
	NSDateFormatter *format;
	NSDateFormatter *oFormat;
    
    NSString *todayforsalelabelstring;  //今日特价城市内容
    NSString *keywordlabelstring;
    NSString *regularcitylabelstring;   //常规查询城市内容
	NSDate *m_checkindate;              //入住
	NSDate *m_checkoutdate;             //离店
    NSString *favouritehotelid;
    int midnighthour;
    
    // 分割线
    IBOutlet UIImageView *splitLine0;
    IBOutlet UIImageView *splitLine1;
    IBOutlet UIImageView *splitLine2;
    IBOutlet UIImageView *splitLine3;
    IBOutlet UIImageView *splitLine4;
    IBOutlet UIImageView *splitLine5;
    
    BOOL isDawn;
    
    int timeZoneOffset;  //时区偏移量
}

@property (nonatomic, assign) HotelSearchType hotelSearchType;              // 酒店搜索类型,0:国内酒店;1:国际酒店

@property (nonatomic, copy) NSString *favouritehotelid;
@property (nonatomic, copy) NSString *todayforsalelabelstring;              //今日特价城市内容
@property (nonatomic, copy) NSString *keywordlabelstring;
@property (nonatomic, copy) NSString *regularcitylabelstring;               //常规查询城市内容
@property (nonatomic, retain) NSDate *m_checkindate;
@property (nonatomic, retain) NSDate *m_checkoutdate;

@property (nonatomic, retain) IBOutlet UITextField *m_keywordsTextField;    //常规查询关键字
@property (nonatomic, retain) IBOutlet UITextField *m_cityTextField;        //常规查询城市选择

@property (nonatomic, assign) IBOutlet UITextField *interHotelKeywordTextField;
@property (nonatomic, assign) IBOutlet UIImageView *keywordsArrow;
@property (nonatomic, assign) IBOutlet UILabel *interHotelNotice;

@property (nonatomic, retain) IBOutlet UIView *searchContainer;

@property (nonatomic, retain) NSDate *checkInDate;
@property (nonatomic, retain) NSDate *checkOutDate;
@property (nonatomic, retain) IBOutlet UILabel *otherLabel;
@property (nonatomic, retain) IBOutlet UIButton *guaranteeLabel;
//- (IBAction)tempc2c_goin:(id)sender;

- (IBAction)searchHotelNearBy:(id)sender;
- (IBAction)clickCondition;
- (IBAction)clickCheckInDate;
- (IBAction)clickCitySelect;
- (IBAction)guarantee:(id)sender;
- (id)initWithShake:(BOOL)shaked;
- (void)resetSearchCondition;
- (id)initWithNaviType:(HotelNaviType)naviType condition:(NSDictionary *)condition;
- (void)combinationCheckInDateWithDate:(NSDate *)date;
- (void)combinationCheckOutDateWithDate:(NSDate *)date;
+ (int)hotelCount;
+ (void)setHotelCount:(int)count;
+ (int)currentIndex;
+ (void)setCurrentIndex:(int)index;
+ (NSMutableArray *)hotels;
+ (int)tonightHotelCount;
+ (void)setTonightHotelCount:(int)count;
+ (float)tonightMinPrice;
+ (void)setTonightMinPrice:(float)price;
+ (NSMutableArray *)tonightHotels;
+ (BOOL)isPositioning;
+ (void)setPositioning:(BOOL)positioning;
/**
 返回已存在的HotelSearch，如果不存在，返回nil
 */
+ (HotelSearch *)hotelSearch;
@end
