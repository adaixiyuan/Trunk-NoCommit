//
//  HotelSearch.m
//  ElongClient
//
//  Created by bin xing on 11-2-25.
//  Copyright 2011 DP. All rights reserved.
//

#import "HotelSearch.h"
#import "HotelSearchConditionViewCtrontroller.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "HotelConditionRequest.h"
#import "FastPositioning.h"
#import "TipsBadgeImage.h"
#import "StringFormat.h"
#import "TimeUtils.h"
#import "TodayOffHotelRequest.h"
#import "CustomSegmented.h"
#import "ElongClientAppDelegate.h"
#import "HotelKeywordListRequest.h"
#import "HotelFavorite.h"
#import "InterHotelSearcher.h"
#import "InterHotelListResultVC.h"
#import "InterHotelDefine.h"
#import "FastPositioning.h"
#import "MyElongCenter.h"
#import "GuaranteeIntroductionView.h"
#import "IFlyMSCViewController.h"
#import "CountlyEventShow.h"
#import "CountlyEventHotelSearchPageNearby.h"
#import "CountlyEventHotelSearchPageSearch.h"
#import "CalendarHelper.h"
#import "XGHomeSearchViewController.h"
#import "XGApplication+Common.h"


#define CITY_STATE              0
#define AROUND_STATE            1

#define SEARCHHOTELLIST         0
#define SEARCHHOTELDETAIL       1
#define SEARCHFAVORITE          2
#define SEARCHTODAYOFFHOTEL     3
#define SEARCHTODAYOFFCITYS     4
#define MYFAVOURITE             5
#define SEARCHHOTELLISTNEARBY   6
#define REPOSITION_ALERT        4202

#define kInlandButtonTag 1024
#define kInternationalButtonTag (kInlandButtonTag + 1)
#define kFlyButtonFlag  (kInlandButtonTag + 2)
#define kSlideArrowImageViewTag (kInlandButtonTag + 3)

static  NSMutableArray *hotels;
static NSMutableArray *tonightHotels;
static int hotelCount;
static int currentIndex = 0;
static int tonightHotelCount;
static float tonightMinPrice;
static BOOL isPositioning;
static HotelSearch *hotelSearch;

@interface HotelSearch(){
@private
    UIView *coverView;
}
@property (nonatomic, retain) UIBarButtonItem *rightBarBtnItem;
@end

@implementation HotelSearch

@synthesize m_keywordsTextField;
@synthesize m_cityTextField;
@synthesize todayforsalelabelstring;//今日特价城市内容
@synthesize keywordlabelstring;
@synthesize regularcitylabelstring;//常规查询城市内容
@synthesize m_checkindate;
@synthesize m_checkoutdate;
@synthesize favouritehotelid;


#pragma mark -
#pragma mark Static Methods

// 是否是周边搜索
+(BOOL)isPositioning{
	return isPositioning;
}

+(void)setPositioning:(BOOL)positioning{
	isPositioning = positioning;
}

// 记录列表中选中项
+ (int)currentIndex{
    return currentIndex;
}

+ (void)setCurrentIndex:(int)index{
    currentIndex = index;
}

// 记录搜索结果数量
+(int)hotelCount{
	return hotelCount;
}

+(void)setHotelCount:(int)count{
	hotelCount = count;
}

// 记录特价酒店数量
+(int)tonightHotelCount{
    return tonightHotelCount;
}

+(void)setTonightHotelCount:(int)count{
    tonightHotelCount = count;
}

// 记录今日特价最低价格
+(float)tonightMinPrice{
    return tonightMinPrice;
}

+(void)setTonightMinPrice:(float)price{
    tonightMinPrice = price;
}

// 今日特价列表
+(NSMutableArray *)tonightHotels{
    @synchronized(self){
        if (!tonightHotels) {
            tonightHotels = [[NSMutableArray alloc] init];
        }
    }
    return tonightHotels;
}

// 记录搜索结果
+ (NSMutableArray *)hotels{
	@synchronized(self) {
		if(!hotels) {
			hotels = [[NSMutableArray alloc] init];
		}
	}
	return hotels;
}
// 返回已存在实例
+ (HotelSearch *)hotelSearch{
    return hotelSearch;
}

#pragma mark -
#pragma mark MemoryDealloc

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

	[[HotelKeywordListRequest shared] clearData];
}

- (void)viewDidUnload{
    [super viewDidUnload];
	
	[m_cityTextField removeObserver:self forKeyPath:@"text"];
	[m_keywordsTextField removeObserver:self forKeyPath:@"text"];
	
	[chooseCityBtn		release];
	[chooseCondition	release];
	[chooseCheckInBtn	release];
	[m_cityView release];
	[m_dateView release];
	
	[checkInDayLabel release];
	[checkInMonthLabel release];
	[checkInWeekDayLabel release];
	[checkOutDayLabel release];
	[checkOutMonthLabel release];
	[checkOutWeekDayLabel release];
	[m_cityTextField release];
	[m_keywordsTextField release];
	[format release];
	[oFormat release];
	
    chooseCityBtn        = nil;
    chooseCondition      = nil;
    chooseCheckInBtn     = nil;
    
    m_cityView           = nil;
    m_dateView           = nil;
	
    checkInDayLabel      = nil;
    checkInMonthLabel    = nil;
    checkInWeekDayLabel  = nil;
    checkOutDayLabel     = nil;
    checkOutMonthLabel   = nil;
    checkOutWeekDayLabel = nil;
    m_cityTextField      = nil;
    m_keywordsTextField  = nil;
    format               = nil;
    oFormat              = nil;
}

- (void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHotelLastSelectedCityKey];
    
	[[HotelConditionRequest shared] clearData];
    
	[m_cityTextField removeObserver:self forKeyPath:@"text"];
	[m_keywordsTextField removeObserver:self forKeyPath:@"text"];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.todayforsalelabelstring = nil;
	self.keywordlabelstring = nil;
	self.regularcitylabelstring = nil;
	self.m_checkindate = nil;
	self.m_checkoutdate = nil;
    self.favouritehotelid = nil;
    self.checkInDate = nil;
    self.checkOutDate = nil;
    self.guaranteeLabel = nil;
    
	[chooseCityBtn		release];
	[chooseCondition	release];
	[chooseCheckInBtn	release];
    
	[m_cityView release];
	[m_dateView release];
	
	[checkInDayLabel release];
	[checkInMonthLabel release];
	[checkInWeekDayLabel release];
	[checkOutDayLabel release];
	[checkOutMonthLabel release];
	[checkOutWeekDayLabel release];
	[m_cityTextField release];
	[m_keywordsTextField release];
    
	[format release];
	[oFormat release];
	[m_tabItemsArray release];
    
    [_searchContainer release];
    
    [_otherLabel release];
	
    [splitLine0 release];
    [splitLine1 release];
    [splitLine2 release];
    [splitLine3 release];
    [splitLine4 release];
    [splitLine5 release];
    
    hotelSearch = nil;
    self.rightBarBtnItem = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [super dealloc];
}

#pragma mark -
#pragma mark Init

- (id)initWithNaviType:(HotelNaviType)naviType condition:(NSDictionary *)condition{
    id obj = [self initWithShake:NO];
    switch (naviType) {
        case HotelNaviPOI:{
            if (condition) {
                netstate = SEARCHHOTELLISTNEARBY;
                
                [self performSelector:@selector(searchHotelAt:) withObject:condition afterDelay:0.6];
            }else{
                if ([[PositioningManager shared] myCoordinate].longitude ==0 && [[PositioningManager shared] myCoordinate].latitude == 0) {
                    
                }else{
                    netstate = SEARCHHOTELLISTNEARBY;
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:[[PositioningManager shared] myCoordinate].latitude],@"lat",[NSNumber numberWithFloat:[[PositioningManager shared] myCoordinate].longitude],@"lng", nil];
                    [self performSelector:@selector(searchHotelAt:) withObject:dict afterDelay:0.6];
                }
            }
            [self setLoadingState];
        }
            break;
        case HotelNaviList:{
            if (condition) {
                [self performSelector:@selector(searchHotelAtCity:) withObject:condition afterDelay:0.6];
            }
            [self setLoadingState];
        }
            break;
        default:{
            
        }
            break;
    }
    return obj;
}

// 提交订单时设置为loading状态
- (void)setLoadingState{
    if (!coverView) {
        [self setNavTitle:@""];
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        coverView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];;
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (MAINCONTENTHEIGHT - 25)/2, SCREEN_WIDTH, 50)];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.text = @"正在跳转...";
        loadingLabel.textColor = [UIColor blackColor];
        loadingLabel.textAlignment = UITextAlignmentCenter;
        loadingLabel.font = FONT_20;
        [coverView addSubview:loadingLabel];
        [loadingLabel release];
        
        [self.view addSubview:coverView];
        [coverView release];
        
        self.rightBarBtnItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void) removeLoadingState{
    if (coverView){
        [self setNavTitle:@"酒店搜索"];
        [coverView removeFromSuperview];
        coverView = nil;
        self.rightBarBtnItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"我的收藏"
                                                                       Target:self
                                                                       Action:@selector(getFavList:)];
		self.navigationItem.rightBarButtonItem = _rightBarBtnItem;
    }
}

- (void) searchHotelAt:(NSDictionary *)condition{
    [self searchHotelAtLat:[[condition safeObjectForKey:@"lat"] floatValue] lng:[[condition safeObjectForKey:@"lng"] floatValue]];
}

- (void) searchHotelAtCity:(NSDictionary *)condition{
    m_cityTextField.text = [condition safeObjectForKey:@"city"];
    [self clickSearchHotel];
}

- (id)initWithShake:(BOOL)shaked{
	isShaked = shaked;
	
	if (self = [super initWithTopImagePath:nil andTitle:@"酒店搜索" style:_NavOlnyHotelBookmark_]) {
		[HotelSearch setPositioning:YES];
		
		HotelKeywordListRequest *hklReq = [HotelKeywordListRequest shared];
		hklReq.currentCityID = nil;				// 清空上次的搜索城市
        
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        searcher.isInterHotelProgress = NO;     // 默认进入后是国内城市
		
		if (isShaked) {
			[self performSelector:@selector(searchHotelNearBy:) withObject:nil afterDelay:0.1];
		}
		
        // register notification
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receiveCityTypeNoti:)
													 name:NOTI_HOTELCITY_TYPE
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keywordChangeNoti:)
                                                     name:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resetSearchConditionNoti:)
                                                     name:NOTI_HOTELSEARCH_RESET
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(interKeywordChangeNoti:)
                                                     name:NOTI_HOTELSEARCH_INTERKEYWORDCHANGE
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notiApplicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        
        self.rightBarBtnItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"我的收藏"
                                                                       Target:self
                                                                       Action:@selector(getFavList:)];
		self.navigationItem.rightBarButtonItem = _rightBarBtnItem;
	}
    hotelSearch = self;
	return self;
}

- (void)back{
    // countly 后退点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELSEARCHPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_BACK;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    // 清空搜索条件
	[Utils clearHotelData];
	if ([self.navigationController.viewControllers count] > 2) {
		[super back];
	}
	else {
		[PublicMethods closeSesameInView:self.navigationController.view];
	}
}

- (void)viewDidLoad{
	[super viewDidLoad];
    
    // 监听keyword修改，waiting for modify by dawn
    [m_keywordsTextField addObserver:self
						  forKeyPath:@"text"
							 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
							 context:nil];
	
	m_cityFrame = m_cityView.frame;
	
    // 日期格式
	format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"E,MMMM,d"];
	oFormat = [[NSDateFormatter alloc] init];
	[oFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *defaultCheckInDate;
    NSDate *defaultCheckOutDate;
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSHourCalendarUnit) fromDate:date];
    
    timeZoneOffset=[NSTimeZone localTimeZone].secondsFromGMT;
    
    // 判断是否在凌晨
    if (comps.hour < 2) {
        isDawn = YES;
    }
    if (comps.hour < 2 && self.hotelSearchType == HotelSearchInland) {
        defaultCheckInDate = [NSDate dateWithTimeInterval:-86400 sinceDate:[NSDate date]];
        defaultCheckOutDate = [NSDate date];
        
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps0;
        comps0 = [calendar components:(kCFCalendarUnitDay) fromDate:date];
        
        NSDate *yesterday = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:date];
        NSDateComponents *comps1;
        comps1 = [calendar components:(kCFCalendarUnitDay) fromDate:yesterday];
        
        self.otherLabel.hidden = NO;
        self.otherLabel.text = [NSString stringWithFormat:@"%d日凌晨0至5点入住，日期请选%d日深夜", comps0.day, comps1.day];
    }
    else {
        defaultCheckInDate = [NSDate date];
        defaultCheckOutDate = [NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]];
        
        self.otherLabel.hidden = YES;
    }
	
	// 初始使用默认日期
    if (m_checkindate) {
        [self combinationCheckInDateWithDate:m_checkindate];
    }
    else{
        [self combinationCheckInDateWithDate:defaultCheckInDate];
    }
    
    if (m_checkoutdate) {
        [self combinationCheckOutDateWithDate:m_checkoutdate];
    }
    else{
        [self combinationCheckOutDateWithDate:defaultCheckOutDate];
    }
    
	if ([regularcitylabelstring length]>0) {
        m_cityTextField.text = regularcitylabelstring;
    }
    else{
        m_cityTextField.text = [[PositioningManager shared] currentCity];
    }
	[m_cityTextField addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    if (STRINGHASVALUE(keywordlabelstring) && ![m_keywordsTextField.text isEqualToString:@"酒店名、地址等"]) {
        m_keywordsTextField.text =keywordlabelstring;
    }
	
	[self footerView];
    
    // 设置为国内酒店搜索模式
    [self setHotelSearchType:HotelSearchInland];
    
    
    // 设置分割线
    splitLine0.image = [UIImage noCacheImageNamed:@"dashed.png"];
    splitLine1.image = [UIImage noCacheImageNamed:@"dashed.png"];
    splitLine2.image = [UIImage noCacheImageNamed:@"dashed.png"];
    splitLine3.image = [UIImage noCacheImageNamed:@"dashed.png"];
    splitLine4.image = [UIImage noCacheImageNamed:@"dashed.png"];
    splitLine5.image = [UIImage noCacheImageNamed:@"dashed.png"];
    
    float scale = SCREEN_SCALE;
    splitLine0.frame = CGRectMake(splitLine0.frame.origin.x, splitLine0.frame.origin.y, splitLine0.frame.size.width, scale);
    splitLine1.frame = CGRectMake(splitLine1.frame.origin.x, splitLine1.frame.origin.y - scale, splitLine1.frame.size.width, scale);
    splitLine2.frame = CGRectMake(splitLine2.frame.origin.x, splitLine2.frame.origin.y, splitLine2.frame.size.width, scale);
    splitLine3.frame = CGRectMake(splitLine3.frame.origin.x, splitLine3.frame.origin.y, splitLine3.frame.size.width, scale);
    splitLine4.frame = CGRectMake(splitLine4.frame.origin.x, splitLine4.frame.origin.y, splitLine4.frame.size.width, scale);
    splitLine5.frame = CGRectMake(splitLine5.frame.origin.x, splitLine5.frame.origin.y + scale, splitLine5.frame.size.width, scale);
    
    if (SCREEN_HEIGHT > 480.0f) {
        self.guaranteeLabel.hidden = YES;
    }
    else {
        self.guaranteeLabel.hidden = YES;
    }
    
    // countly show
    CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
    countlyEventShow.ch = COUNTLY_CH_HOTEL;
    countlyEventShow.page = COUNTLY_PAGE_HOTELSEARCHPAGE;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];
}

#pragma mark - Inland and international change.
- (void)inlandSelect
{
    UIButton *inlandButton = (UIButton *)[self.view viewWithTag:kInlandButtonTag];
    UIButton *internationalButton = (UIButton *)[self.view viewWithTag:kInternationalButtonTag];
    inlandButton.selected = YES;
    internationalButton.selected = NO;
    
    if ([[[PositioningManager shared] currentCity] length] > 0) {
        m_cityTextField.text = [[PositioningManager shared] currentCity];
    }
    else{
        m_cityTextField.text = @"北京";
    }
    
    UIImageView *slideArrow = (UIImageView *)[self.view viewWithTag:kSlideArrowImageViewTag];
    [UIView animateWithDuration:0.1f animations:^(void){
        slideArrow.frame = CGRectMake(73.5, slideArrow.frame.origin.y, 13.0f, 6.0f);
    }];
    
    [self setHotelSearchType:HotelSearchInland];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELCITY_TYPE object:[NSNumber numberWithBool:NO]];
    
    // 校正日期
    [self notiApplicationDidBecomeActive:nil];
    
    // 国内点击事件 countly
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELSEARCHPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_DOMESTIC;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

- (void)internationalSelect
{
    UIButton *inlandButton = (UIButton *)[self.view viewWithTag:kInlandButtonTag];
    UIButton *internationalButton = (UIButton *)[self.view viewWithTag:kInternationalButtonTag];
    inlandButton.selected = NO;
    internationalButton.selected = YES;
    
    NSString *cityID = nil;     // 纪录国内/国际酒店的cityID
	InterHotelSearcher *searcher = [InterHotelSearcher shared];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"InternalHotelCity" ofType:@"plist"];
    
	NSDictionary *dict = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    if (!DICTIONARYHASVALUE(dict))
        return;
    
	
	NSArray *allkeys = [dict allKeys];
	int count = [allkeys count];
    NSMutableArray *internationalHotels = [[[NSMutableArray alloc] init] autorelease];
    if (count > 0) {
        if ([[dict safeObjectForKey:[allkeys safeObjectAtIndex:0]] isKindOfClass:[NSArray class]]) {
            [internationalHotels addObjectsFromArray:[dict safeObjectForKey:[allkeys safeObjectAtIndex:0]]];
        }
    }
    
    //////////
    NSArray *cityArray = [internationalHotels safeObjectAtIndex:0];
    searcher.cityId = [cityArray lastObject];
    cityID = searcher.cityId;
    
    searcher.cityNameEn = [cityArray safeObjectAtIndex:4];
    searcher.cityDescription = [cityArray safeObjectAtIndex:0];
    
    m_cityTextField.text = [cityArray safeObjectAtIndex:1];
	NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
    [dater setValue:cityID forKey:kHotelLastSelectedCityKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELCITY_TYPE object:[NSNumber numberWithBool:YES]];
    
    UIImageView *slideArrow = (UIImageView *)[self.view viewWithTag:kSlideArrowImageViewTag];
    [UIView animateWithDuration:0.1f animations:^(void){
        slideArrow.frame = CGRectMake(73.5 + 160.0f, slideArrow.frame.origin.y, 13.0f, 6.0f);
    }];
    
    [self setHotelSearchType:HotelSearchInternational];
    
    // 国际点击事件 countly
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELSEARCHPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_INTERNATIONAL;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

#pragma mark -
#pragma mark Private Methods

- (void)setHotelSearchType:(HotelSearchType)hotelSearchType{
    if (hotelSearchType != self.hotelSearchType) {
        _hotelSearchType = hotelSearchType;
        
        UIButton *flyBtn = (UIButton *)[_searchContainer viewWithTag:kFlyButtonFlag];
        if (hotelSearchType == HotelSearchInland) {
//            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            self.navigationItem.rightBarButtonItem = _rightBarBtnItem;
            self.interHotelKeywordTextField.hidden = YES;
            self.interHotelKeywordTextField.text = nil;
            self.m_keywordsTextField.hidden = NO;
            self.keywordsArrow.hidden = NO;
            self.interHotelNotice.hidden = YES;
            // 3.5寸屏不理会
            if (SCREEN_HEIGHT > 480.0f) {
                self.guaranteeLabel.hidden = YES;
            }
            
            //searchBtn.frame =  CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2, 230, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT);
            
            if ([m_cityTextField.text isEqualToString:@"北京"]) {
                c2cSearchBtn.hidden = NO;
                searchBtn.frame =  CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2 + 80 + 10, 230, BOTTOM_BUTTON_WIDTH - 80 - 10, BOTTOM_BUTTON_HEIGHT);
            }else{
                c2cSearchBtn.hidden = YES;
                searchBtn.frame =  CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2, 230, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT);
            }
            
            flyBtn.hidden = NO;
        }
        else {
//            self.navigationItem.rightBarButtonItem.customV]iew.hidden = YES;
            self.navigationItem.rightBarButtonItem = nil;
            self.interHotelKeywordTextField.hidden = NO;
            self.m_keywordsTextField.hidden = YES;
            self.m_keywordsTextField.text = nil;
            self.keywordsArrow.hidden = YES;
            self.interHotelNotice.hidden = NO;
            self.guaranteeLabel.hidden = YES;
            searchBtn.frame =  CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2, 230, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT);
            flyBtn.hidden = YES;
            c2cSearchBtn.hidden = YES;
        }
        
        [self combinationCheckInDateWithDate:self.checkInDate];
        [self combinationCheckOutDateWithDate:self.checkOutDate];
    }
}

- (void)addAllButtons{
    chooseCityBtn.exclusiveTouch = YES;
    
    chooseCondition.exclusiveTouch = YES;
    
    chooseCheckInBtn.exclusiveTouch = YES;
    
	searchBtn = [UIButton uniformButtonWithTitle:@""
									   ImagePath:Nil
                                          Target:self
										  Action:@selector(clickSearchHotel)
										   Frame:CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2 + 80 + 10 , 230, BOTTOM_BUTTON_WIDTH - 80 - 10, BOTTOM_BUTTON_HEIGHT)];
    searchBtn.exclusiveTouch = YES;
	[_searchContainer addSubview:searchBtn];
	m_buttonFrame = searchBtn.frame;
    [searchBtn setTitle:@"查 询" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = FONT_B18;
    
    c2cSearchBtn = [UIButton uniformButtonWithTitle:@""
                                          ImagePath:Nil
                                             Target:self
                                             Action:@selector(c2cSearchBtnClick)
                                              Frame:CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2 , 230, 80, BOTTOM_BUTTON_HEIGHT)];
    [_searchContainer addSubview:c2cSearchBtn];
    [c2cSearchBtn setTitle:@"酒店直销" forState:UIControlStateNormal];
    [c2cSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [c2cSearchBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
	[c2cSearchBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
    c2cSearchBtn.titleLabel.font = FONT_B16;
    [self checkC2C];
    

    int bottomButtonHeight = SCREEN_4_INCH ? 44 : 39;
    // 国内、国际添加在搜索页
    UIButton *inlandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inlandButton.tag = kInlandButtonTag;
    inlandButton.frame = CGRectMake(0.0f, MAINCONTENTHEIGHT - bottomButtonHeight, 160.0f, bottomButtonHeight);
    inlandButton.backgroundColor = RGBCOLOR(60, 60, 60, 1);
    inlandButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [inlandButton setTitle:@"国内" forState:UIControlStateNormal];
    [inlandButton setTitleColor:[UIColor colorWithRed:252.0f / 255 green:152.0f / 255 blue:44.0f / 255 alpha:1.0f] forState:UIControlStateHighlighted];
    [inlandButton setTitleColor:[UIColor colorWithRed:252.0f / 255 green:152.0f / 255 blue:44.0f / 255 alpha:1.0f] forState:UIControlStateSelected];
    [inlandButton setTitleColor:[UIColor colorWithRed:247.0f / 255 green:247.0f / 255 blue:247.0f / 255 alpha:1.0f] forState:UIControlStateNormal];
    inlandButton.selected = YES;
    inlandButton.exclusiveTouch = YES;
    [inlandButton addTarget:self action:@selector(inlandSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inlandButton];
    
    UIButton *internationalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    internationalButton.tag = kInternationalButtonTag;
    internationalButton.frame = CGRectMake(160.0f, MAINCONTENTHEIGHT - bottomButtonHeight, 160.0f, bottomButtonHeight);
    internationalButton.backgroundColor = RGBCOLOR(60, 60, 60, 1);
    internationalButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [internationalButton setTitle:@"国际" forState:UIControlStateNormal];
    [internationalButton setTitleColor:[UIColor colorWithRed:252.0f / 255 green:152.0f / 255 blue:44.0f / 255 alpha:1.0f] forState:UIControlStateHighlighted];
    [internationalButton setTitleColor:[UIColor colorWithRed:252.0f / 255 green:152.0f / 255 blue:44.0f / 255 alpha:1.0f] forState:UIControlStateSelected];
    [internationalButton setTitleColor:[UIColor colorWithRed:247.0f / 255 green:247.0f / 255 blue:247.0f / 255 alpha:1.0f] forState:UIControlStateNormal];
    internationalButton.selected = NO;
    internationalButton.exclusiveTouch = YES;
    [internationalButton addTarget:self action:@selector(internationalSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:internationalButton];
    
    UIImageView *slideArrow = [[UIImageView alloc] initWithFrame:CGRectMake(73.5, MAINCONTENTHEIGHT - bottomButtonHeight, 13, 6)];
    slideArrow.tag = kSlideArrowImageViewTag;
    slideArrow.image = [UIImage noCacheImageNamed:@"hotel_search_slide.png"];
    [self.view addSubview:slideArrow];
    [slideArrow release];
    
    // 白色竖线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(160.0f, MAINCONTENTHEIGHT - bottomButtonHeight + (bottomButtonHeight - 24) / 2, 1.0f, 24.0f)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    [lineView release];
}

// 入住日期校验
- (void)combinationCheckInDateWithDate:(NSDate *)date{
    self.checkInDate = date;
	// 组合入住日期
	NSArray *dateCompents = [self switchMonth:[[format stringFromDate:date] componentsSeparatedByString:@","]];
    NSArray *nowDateCompents = [self switchMonth:[[format stringFromDate:[NSDate date]] componentsSeparatedByString:@","]];
    if ([[dateCompents safeObjectAtIndex:1] isEqual:[nowDateCompents safeObjectAtIndex:1]]) {
        // 月份相等的情况
        if (self.hotelSearchType == HotelSearchInland && ([[dateCompents safeObjectAtIndex:2] isEqual:[nowDateCompents safeObjectAtIndex:2]])) {
            // 日期相等
            checkInWeekDayLabel.text = @"今天";
        }
        else if (self.hotelSearchType == HotelSearchInland && ([[dateCompents safeObjectAtIndex:2] intValue] == [[nowDateCompents safeObjectAtIndex:2] intValue] + 1)) {
            checkInWeekDayLabel.text = @"明天";
        }
        else {
            checkInWeekDayLabel.text = [dateCompents safeObjectAtIndex:0];
        }
    }
    else {
        // 月份不相等
        checkInWeekDayLabel.text = [dateCompents safeObjectAtIndex:0];
    }
	
	checkInMonthLabel.text = [dateCompents safeObjectAtIndex:1];
	
	NSString *dayStr = [dateCompents safeObjectAtIndex:2];
	if ([dayStr intValue] < 10) {
		dayStr = [NSString stringWithFormat:@"0%@",dayStr];
	}
	checkInDayLabel.text = dayStr;
}

// 离店日期校验
- (void)combinationCheckOutDateWithDate:(NSDate *)date{
    self.checkOutDate = date;
	// 组合离店日期
	NSArray *dateCompents = [self switchMonth:[[format stringFromDate:date] componentsSeparatedByString:@","]];
    NSArray *nowDateCompents = [self switchMonth:[[format stringFromDate:[NSDate date]] componentsSeparatedByString:@","]];
    if ([[dateCompents safeObjectAtIndex:1] isEqual:[nowDateCompents safeObjectAtIndex:1]]) {
        // 月份相等的情况
        if (self.hotelSearchType == HotelSearchInland && ([[dateCompents safeObjectAtIndex:2] isEqual:[nowDateCompents safeObjectAtIndex:2]])) {
            // 日期相等
            checkOutWeekDayLabel.text = @"今天";
        }
        else if (self.hotelSearchType == HotelSearchInland && ([[dateCompents safeObjectAtIndex:2] intValue] == [[nowDateCompents safeObjectAtIndex:2] intValue] + 1)) {
            checkOutWeekDayLabel.text = @"明天";
        }
        else {
            checkOutWeekDayLabel.text = [dateCompents safeObjectAtIndex:0];
        }
    }
    else {
        // 月份不相等
        checkOutWeekDayLabel.text = [dateCompents safeObjectAtIndex:0];
    }
	
	checkOutMonthLabel.text = [dateCompents safeObjectAtIndex:1];
	
	NSString *dayStr = [dateCompents safeObjectAtIndex:2];
	if ([dayStr intValue] < 10) {
		dayStr = [NSString stringWithFormat:@"0%@",dayStr];
	}
	checkOutDayLabel.text = dayStr;
}

// 月份转换函数，一月转为1月
- (NSArray *) switchMonth:(NSArray *)dateCompents{
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *item in dateCompents) {
        if ([item isEqualToString:@"一月"]) {
            [newArray addObject:@"1月"];
        }else if([item isEqualToString:@"二月"]) {
            [newArray addObject:@"2月"];
        }else if([item isEqualToString:@"三月"]) {
            [newArray addObject:@"3月"];
        }else if([item isEqualToString:@"四月"]) {
            [newArray addObject:@"4月"];
        }else if([item isEqualToString:@"五月"]) {
            [newArray addObject:@"5月"];
        }else if([item isEqualToString:@"六月"]) {
            [newArray addObject:@"6月"];
        }else if([item isEqualToString:@"七月"]) {
            [newArray addObject:@"7月"];
        }else if([item isEqualToString:@"八月"]) {
            [newArray addObject:@"8月"];
        }else if([item isEqualToString:@"九月"]) {
            [newArray addObject:@"9月"];
        }else if([item isEqualToString:@"十月"]) {
            [newArray addObject:@"10月"];
        }else if([item isEqualToString:@"十一月"]) {
            [newArray addObject:@"11月"];
        }else if([item isEqualToString:@"十二月"]) {
            [newArray addObject:@"12月"];
        }else{
            [newArray addObject:item];
        }
    }
    return newArray;
}

- (void)footerView{
	m_cityView.hidden = NO;
	m_dateFrame = m_dateView.frame;
	CGRect newFrame = m_dateView.frame;
	newFrame.origin.y = newFrame.origin.y-30;
	m_dateCacheFrame = newFrame;
	
	[self addAllButtons];
}

// 处理国内酒店返回数据
- (void)goHotelListWithDictionary:(NSDictionary *)dataDic{
    // 周边搜索情况，传入品牌和星级信息
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    [hotelsearcher setBrandAndStar:dataDic];
    
    
    // psg推荐
    NSMutableArray *hotelArray = [NSMutableArray arrayWithArray:[dataDic safeObjectForKey:RespHL_HotelList_A]];
    if ([dataDic safeObjectForKey:RespHL_PSGHotels] != [NSNull null]) {
        NSArray *psgHotelArray = [dataDic safeObjectForKey:RespHL_PSGHotels];
        if (psgHotelArray && psgHotelArray.count) {
            for (int i = 0; i < psgHotelArray.count; i++) {
                NSInteger recommendIndex = [[[psgHotelArray objectAtIndex:i] objectForKey:@"RecommendIndex"] intValue];
                if (recommendIndex > 0) {
                    recommendIndex = recommendIndex - 1;
                }
                if (recommendIndex + i < hotelArray.count) {
                    [hotelArray insertObject:[psgHotelArray objectAtIndex:i] atIndex:i + recommendIndex];
                }else{
                    [hotelArray addObject:[psgHotelArray objectAtIndex:i]];
                }
            }
        }
    }
    
    [[HotelSearch hotels] removeAllObjects];
    [[HotelSearch hotels] addObjectsFromArray:hotelArray];
    hotelCount = [[HotelSearch hotels] count];
    [HotelSearch setHotelCount:[[dataDic safeObjectForKey:RespHL_HotelCount_I] intValue]];
    // 设置今日特价信息
    if ([dataDic safeObjectForKey:@"HotelLmCnt"] != [NSNull null] && [dataDic safeObjectForKey:@"HotelLmCnt"]) {
        [HotelSearch setTonightHotelCount:[[dataDic safeObjectForKey:@"HotelLmCnt"] intValue]];
    }else{
        [HotelSearch setTonightHotelCount:0];
    }
    if ([dataDic safeObjectForKey:@"MinPrice"] != [NSNull null] && [dataDic safeObjectForKey:@"MinPrice"]) {
        [HotelSearch setTonightMinPrice:[[dataDic safeObjectForKey:@"MinPrice"] floatValue]];
    }else{
        [HotelSearch setTonightMinPrice:0.0f];
    }
    
    NSString *listTitle = nil;
    switch (currentTag) {
        case CITY_STATE:
            listTitle = m_cityTextField.text;
            break;
        case AROUND_STATE:
            listTitle = [[PositioningManager shared] currentCity];
            break;
        default:
            break;
    }
    
    [hotelsearcher setCityName:listTitle];
    [hotelsearcher setSearchGPS:[dataDic safeObjectForKey:@"IsDataFromKPI"]];
    
    HotelSearchResultManager *searchresult = [[HotelSearchResultManager alloc] initWithTitle:listTitle];
    if (currentTag == CITY_STATE) {
        searchresult.keyword = self.m_keywordsTextField.text;
    }
    else {
        searchresult.keyword = @"";
    }
    [self.navigationController pushViewController:searchresult animated:YES];
    [searchresult release];
}

// 处理国际酒店返回数据
- (void)goInternationalHotelListWithDictionary:(NSDictionary *)dic{
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    [searcher setHotelCount:[[dic safeObjectForKey:RespHL_HotelCount_I] integerValue]];
    [searcher setHotelList:[dic safeObjectForKey:RespHL_HotelList_A]];
    
    if (searcher.hotelList.count > 0) {
        searcher.countryId = [[searcher.hotelList safeObjectAtIndex:0] safeObjectForKey:@"CountryCode"];
        searcher.cityNameEn = [[searcher.hotelList safeObjectAtIndex:0] safeObjectForKey:@"CityEnName"];
    }
    
    InterHotelListResultVC *listVC = [[InterHotelListResultVC alloc] initWithTitle:m_cityTextField.text];
    [self.navigationController pushViewController:listVC animated:YES];
    [listVC release];
}

// 获取收藏酒店，分城市展示
- (void) getFavList:(id)sender{
    [self.interHotelKeywordTextField resignFirstResponder];
    if (UMENG) {
        // 搜索页进收藏酒店列表页面
        [MobClick event:Event_FavHotelList_Search];
    }
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (islogin) {
        netstate = MYFAVOURITE;
        
        HotelFavoriteRequest *jghf=[HotelPostManager favorite];
        jghf.cityId = nil;
        [Utils request:HOTELSEARCH req:[jghf request] delegate:self];
    }else {
        HotelFavoriteRequest *jghf=[HotelPostManager favorite];
        jghf.cityId = nil;
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_HotelGetFavorite];
        [delegate.navigationController pushViewController:login animated:YES];
        [login release];
    }
    if (self.hotelSearchType == HotelSearchInland) {
        UMENG_EVENT(UEvent_Hotel_Search_FavList)
        
        // 我的收藏点击事件 countly
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_HOTELSEARCHPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_MYCOLLECTION;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
    }
}

// 时区检测，判断用户所在位置是否为东八区
- (void) checkLocalTimeZone{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.timezoneCheckNeeded) {
        return;
    }
    
    BOOL result = NO;
    
    if([[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Chongqing"].location == 0 ||
       [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Harbin"].location == 0 ||
       [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Hong_Kong"].location == 0 ||
       [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Macau"].location == 0 ||
       [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Shanghai"].location == 0 ||
       [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Taipei"].location == 0){
        result = YES;
    }
    if (!result) {
        [PublicMethods showAlertTitle:nil Message:@"目前您系统的时区为非东八区，为了确保您预订日期准确，建议您修改系统时区"];
    }
    appDelegate.timezoneCheckNeeded = NO;
}

#pragma mark -
#pragma mark ObserveValues

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	if (object == m_cityTextField && ![[change safeObjectForKey:@"new"] isEqual:[change safeObjectForKey:@"old"]]) {
		// 切换城市时清空搜索条件
        self.regularcitylabelstring = [change safeObjectForKey:@"new"];
		[[HotelConditionRequest shared] clearData];
		m_keywordsTextField.text = @"";
        self.interHotelKeywordTextField.text = @"";
	}
    
    if ([keyPath isEqual:@"text"]) {
        if ([object isEqual:m_keywordsTextField]) {
            self.keywordlabelstring = [change safeObjectForKey:@"new"];
        }
	}
}

#pragma mark-
#pragma mark Notification

- (void)receiveCityTypeNoti:(NSNotification *)noti {
    self.hotelSearchType = [[noti object] boolValue];
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    searcher.isInterHotelProgress = _hotelSearchType;
    
    if (isDawn && self.hotelSearchType == HotelSearchInland) {
        self.otherLabel.hidden = NO;
    }else{
        self.otherLabel.hidden = YES;
    }
    
    UIButton *inlandButton = (UIButton *)[self.view viewWithTag:kInlandButtonTag];
    UIButton *internationalButton = (UIButton *)[self.view viewWithTag:kInternationalButtonTag];
    UIButton *flyBtn = (UIButton *)[_searchContainer viewWithTag:kFlyButtonFlag];
    if (self.hotelSearchType) {
        inlandButton.selected = NO;
        internationalButton.selected = YES;
        
        searchBtn.frame =  CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2, 230, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT);
        flyBtn.hidden = YES;
        c2cSearchBtn.hidden = YES;
        
        
        UIImageView *slideArrow = (UIImageView *)[self.view viewWithTag:kSlideArrowImageViewTag];
        [UIView animateWithDuration:0.1f animations:^(void){
            slideArrow.frame = CGRectMake(73.5 + 160.0f, slideArrow.frame.origin.y, 13.0f, 6.0f);
        }];
    }
    else {
        inlandButton.selected = YES;
        internationalButton.selected = NO;
        
        searchBtn.frame =  CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2, 230, BOTTOM_BUTTON_WIDTH , BOTTOM_BUTTON_HEIGHT);
        flyBtn.hidden = NO;
        
        [self checkC2C];
        
        UIImageView *slideArrow = (UIImageView *)[self.view viewWithTag:kSlideArrowImageViewTag];
        [UIView animateWithDuration:0.1f animations:^(void){
            slideArrow.frame = CGRectMake(73.5, slideArrow.frame.origin.y, 13.0f, 6.0f);
        }];
    }
}

- (void) keywordChangeNoti:(NSNotification *)noti{
    NSDictionary* info = [noti userInfo];
    NSString *keyword = [NSString stringWithFormat:@"%@",[info objectForKey:HOTEL_SEARCH_KEYWORD]];
    self.keywordlabelstring = keyword;
    self.m_keywordsTextField.text = keyword;
}

- (void) resetSearchConditionNoti:(NSNotification *)noti{
    [self resetSearchCondition];
}

- (void) interKeywordChangeNoti:(NSNotification *)noti{
    NSDictionary* info = [noti userInfo];
    NSString *keyword = [NSString stringWithFormat:@"%@",[info objectForKey:HOTEL_SEARCH_KEYWORD]];
    self.interHotelKeywordTextField.text = keyword;
}

- (void)notiApplicationDidBecomeActive:(NSNotification *)noti
{
    /*
     * 1.时区切换，用默认值
       2.时间流逝 1:>不合法情况用默认值  2:>合法用上一次值
     */
    
    int curTimeZoneOffset=[NSTimeZone localTimeZone].secondsFromGMT;
    
    NSDate *currentTimeDate=[NSDate date];
    NSDate *yesterdayDate=[currentTimeDate dateByAddingTimeInterval:-(24*3600)];
    NSDate *torrowDate = [NSDate dateWithTimeInterval:(24*3600) sinceDate:currentTimeDate];
    if (curTimeZoneOffset!=timeZoneOffset)
    {
        [CalendarHelper reset];
    }
    
    CalendarHelper *helper = [CalendarHelper shared];
    self.otherLabel.text = [NSString stringWithFormat:@"%d日凌晨0至5点入住，日期请选%d日深夜", [helper day:currentTimeDate], [helper day:yesterdayDate]];
    
    int hour = [helper hour:currentTimeDate];
    // 判断是否在凌晨
    if (hour < 2)
    {
        isDawn = YES;
    }
    else
    {
        isDawn = NO;
    }
    
    //凌晨预定，默认昨天，今天
    if (isDawn && self.hotelSearchType == HotelSearchInland)
    {
        //提示文字状态改变
        if (self.otherLabel.hidden==YES)
        {
            if (curTimeZoneOffset!=timeZoneOffset)
            {
                [self combinationCheckInDateWithDate:yesterdayDate];
                [self combinationCheckOutDateWithDate:currentTimeDate];
                timeZoneOffset=curTimeZoneOffset;
            }
            else
            {
                if ([helper compareDate:yesterdayDate withCheckOutDate:_checkInDate]==1   //入住日期小于昨天
                    ||[helper compareDate:yesterdayDate withCheckOutDate:_checkOutDate]>=0) //离店日期小于等于昨天
                {
                    [self combinationCheckInDateWithDate:yesterdayDate];
                    [self combinationCheckOutDateWithDate:currentTimeDate];
                }
                else
                {
                    [self combinationCheckInDateWithDate: _checkInDate];
                    [self combinationCheckOutDateWithDate:_checkOutDate];
                }
            }

            self.otherLabel.hidden = NO;
            return;
        }
        
        if (curTimeZoneOffset!=timeZoneOffset)
        {
            [self combinationCheckInDateWithDate:yesterdayDate];
            [self combinationCheckOutDateWithDate:currentTimeDate];
            timeZoneOffset=curTimeZoneOffset;
        }
        else
        {
            if ([helper compareDate:yesterdayDate withCheckOutDate:_checkInDate]==1   //入住日期小于昨天
                ||[helper compareDate:yesterdayDate withCheckOutDate:_checkOutDate]>=0) //离店日期小于等于昨天
            {
                [self combinationCheckInDateWithDate:yesterdayDate];
                [self combinationCheckOutDateWithDate:currentTimeDate];
            }
        }
    }
    //正常情况，默认今天，明天
    else
    {
        //提示文字状态改变
        if (self.otherLabel.hidden==NO)
        {
            if (curTimeZoneOffset!=timeZoneOffset)
            {
                [self combinationCheckInDateWithDate:currentTimeDate];
                [self combinationCheckOutDateWithDate:torrowDate];
                timeZoneOffset=curTimeZoneOffset;
            }
            else
            {
                if ([helper compareDate:currentTimeDate withCheckOutDate:_checkInDate]==1  //入住日期小于今天
                    ||[helper compareDate:currentTimeDate withCheckOutDate:_checkOutDate]>=0)  //离店日期小于等于今天
                {
                    [self combinationCheckInDateWithDate:currentTimeDate];
                    [self combinationCheckOutDateWithDate:torrowDate];
                }
                else
                {
                    [self combinationCheckInDateWithDate:_checkInDate];
                    [self combinationCheckOutDateWithDate:_checkOutDate];
                }
            }
    
            self.otherLabel.hidden = YES;
            return;
        }
        
        if (curTimeZoneOffset!=timeZoneOffset)
        {
            [self combinationCheckInDateWithDate:currentTimeDate];
            [self combinationCheckOutDateWithDate:torrowDate];
            timeZoneOffset=curTimeZoneOffset;
        }
        else
        {
            //过期更新
            if ([helper compareDate:currentTimeDate withCheckOutDate:_checkInDate]==1  //入住日期小于今天
                ||[helper compareDate:currentTimeDate withCheckOutDate:_checkOutDate]>=0)  //离店日期小于等于今天
            {
                [self combinationCheckInDateWithDate:currentTimeDate];
                [self combinationCheckOutDateWithDate:torrowDate];
            }
        }
    }
}

#pragma mark -
#pragma mark IBActions

// 艺龙消费者保障计划
- (IBAction)guarantee:(id)sender{
    GuaranteeIntroductionView *msg = [[GuaranteeIntroductionView alloc] init];
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:msg];
    [msg release];
    msg.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        msg.alpha = 1.0f;
    }];
    
    UMENG_EVENT(UEvent_Hotel_Search_Guarantee)
}

// 选择城市
-(IBAction)clickCitySelect{
	SelectCity *selectCity =[[SelectCity alloc] init:_string(@"s_incity") style:_NavOnlyBackBtnStyle_ citylable:m_cityTextField cityType:SelectCityTypeHotel isSave:NO];
	[self.navigationController pushViewController:selectCity animated:YES];
	[selectCity release];

    if (_hotelSearchType) {
        // 如果是国际酒店流程，切换国际酒店列表
        selectCity.hotelSeg.selectedIndex = 1;
    }else{
        UMENG_EVENT(UEvent_Hotel_Search_CityChoice)
        
        // 城市点击事件 countly
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_HOTELSEARCHPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_CITY;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
    }
}

// 选择关键词
- (IBAction)clickCondition{
    currentTag = CITY_STATE;
    
    if (self.hotelSearchType == HotelSearchInland) {
        self.favouritehotelid = nil;
        
        // 按条件搜索
        [[HotelConditionRequest shared] setIsFromLastMinute:NO];
        HotelSearchConditionViewCtrontroller *controller = [[HotelSearchConditionViewCtrontroller alloc] initWithSearchCity:m_cityTextField.text title:@"关键词" navBarBtnStyle:NavBarBtnStyleOnlyBackBtn displaySearchBar:YES];
        controller.nearByIsShow = YES;
        
        controller.delegate = self;
        controller.independent = YES;
        HotelConditionRequest *conditionReq = [HotelConditionRequest shared];
        controller.keywordFilter = conditionReq.keywordFilter;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
        UMENG_EVENT(UEvent_Hotel_Search_Keyword);
        
        // 关键词点击事件 countly
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_HOTELSEARCHPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_ENTRYBAR;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
    }
    else {
        InterHotelKeywordSearchController *keywordController = [[[InterHotelKeywordSearchController alloc] initWithNibName:nil bundle:nil] autorelease];
        keywordController.keyword = self.interHotelKeywordTextField.text;
        keywordController.delegate = self;
        
        if (IOSVersion_7) {
            keywordController.transitioningDelegate = [ModalAnimationContainer shared];
            keywordController.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [self presentViewController:keywordController animated:YES completion:nil];
        }else{
            [self presentModalViewController:keywordController animated:YES];
        }
    }
}

// 选择入离店日期
-(IBAction)clickCheckInDate{
    CalendarType calendarType = HotelCalendar;
    if (self.hotelSearchType == HotelSearchInland) {
        calendarType = HotelCalendar;
        
        // 日期点击事件 countly
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_HOTELSEARCHPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_DATE;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
    }else{
        calendarType = GlobelHotelCalendar;
    }

    ELCalendarViewController *vc=[[ELCalendarViewController alloc] initWithCheckIn:self.checkInDate checkOut:self.checkOutDate type:calendarType];
    vc.delegate=self;
   	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}

// 周边搜索
- (IBAction)searchHotelNearBy:(id)sender{
    netstate = SEARCHHOTELLISTNEARBY;
    
    // 定位判断
    if ([[PositioningManager shared] myCoordinate].longitude ==0 && [[PositioningManager shared] myCoordinate].latitude == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败，请确认已打开手机定位功能"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"重新定位", nil];
        alert.tag = REPOSITION_ALERT;
        [alert show];
        [alert release];
        return ;
    }
    
    // 重新定位
    if ([[PositioningManager shared] isGpsing]) {
        [Utils alert:@"正在校准定位，请稍后尝试"];
        FastPositioning *position = [FastPositioning shared];
        position.autoCancel = YES;
        [position fastPositioning];
        
        return ;
    }
    
    if (![[FastPositioning shared] abroad]) {
        // 国内酒店
        [[HotelConditionRequest shared] setIsFromLastMinute:NO];
        FastPositioning *position = [FastPositioning shared];
        position.autoCancel = NO;
        [position fastPositioning];
        
        [self searchHotelAtLat:[[PositioningManager shared] myCoordinate].latitude lng:[[PositioningManager shared] myCoordinate].longitude];
        
        
        // 周边搜索国内酒店时区判断
        [self checkLocalTimeZone];
        
        UMENG_EVENT(UEvent_Hotel_Search_SearchAround);
        
        // countly nearby
        CountlyEventHotelSearchPageNearby *countlyNearby = [[CountlyEventHotelSearchPageNearby alloc] init];
        countlyNearby.latitude = [NSNumber numberWithFloat:[[PositioningManager shared] myCoordinate].latitude];
        countlyNearby.longitude = [NSNumber numberWithFloat:[[PositioningManager shared] myCoordinate].longitude];
        [countlyNearby sendEventCount:1];
        [countlyNearby release];
    }
    else {
        // 国际酒店
        FastPositioning *position = [FastPositioning shared];
        position.autoCancel = NO;
        [position fastPositioning];
        
        netstate = SEARCHHOTELLISTNEARBY;
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        
        [searcher reset];
        [searcher setCheckInDate:[oFormat stringFromDate:self.checkInDate]];
        [searcher setCheckOutDate:[oFormat stringFromDate:self.checkOutDate]];
        
        [searcher setCoordinateWithLatitude:[[PositioningManager shared] myCoordinate].latitude
                              withLongitude:[[PositioningManager shared] myCoordinate].longitude
                                 withRadius:(HOTEL_NEARBY_RADIUS/1000.0f)
                                   withName:@"当前位置"];
        
        [Utils request:INTER_SEARCH req:[searcher request] policy:CachePolicyHotelList delegate:self];
    }
}

- (void) searchHotelAtLat:(float)lat lng:(float)lng{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    [hotelsearcher clearBuildData];
    [HotelSearch setPositioning:YES];
    [hotelsearcher setMutipleFilter:@"52"];
    
    [hotelsearcher setCurrentPos:HOTEL_NEARBY_RADIUS
                       Longitude:lng
                        Latitude:lat];
    
    
    [hotelsearcher setCheckData:[oFormat stringFromDate:self.checkInDate] checkoutdate:[oFormat stringFromDate:self.checkOutDate]];
    
    [hotelsearcher setCityName:[[PositioningManager shared] currentCity]];
    
    currentTag = AROUND_STATE;
    [Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] policy:CachePolicyHotelList delegate:self];
}

- (void) iflyBtn:(id)sender{
    IFlyMSCViewController *iflyMSCVC = [[IFlyMSCViewController alloc] initWithTitle:@"语音搜索" style:NavBarBtnStyleOnlyBackBtn];
    iflyMSCVC.delegate = self;
    iflyMSCVC.iflyMSCType = IFlyMSCTypeHotelSemantics;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:iflyMSCVC];
    [iflyMSCVC release];

    [self presentModalViewController:nav animated:YES];
    [nav release];
}

#pragma mark -
#pragma mark IFlyMSCViewControllerDelegate
- (void) iflyMSCVCSearch:(IFlyMSCViewController *)iflyMSCVC{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    self.m_cityTextField.text = hotelsearcher.cityName;
    [self combinationCheckInDateWithDate:[oFormat dateFromString:[hotelsearcher getCheckinDate]]];
    [self combinationCheckOutDateWithDate:[oFormat dateFromString:[hotelsearcher getCheckoutDate]]];
    
    HotelConditionRequest *request = [HotelConditionRequest shared];
    if (request.keywordFilter.keywordType == HotelKeywordTypeBusiness
        ||request.keywordFilter.keywordType == HotelKeywordTypeDistrict
        ||request.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation
        ||request.keywordFilter.keywordType == HotelKeywordTypeSubwayStation
        ||request.keywordFilter.keywordType == HotelKeywordTypePOI
        ||request.keywordFilter.keywordType == HotelKeywordTypeNormal) {
        self.m_keywordsTextField.text = request.keywordFilter.keyword;
    }
    //netstate = SEARCHHOTELLIST;
    
    //[Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] policy:CachePolicyHotelList delegate:self];
}

#pragma mark -
#pragma mark ElCalendarViewSelectDelegate

-(void) ElcalendarViewSelectDay:(ELCalendarViewController *) elViewController checkinDate:(NSDate *) cinDate checkoutDate:(NSDate *) coutDate{
    [self combinationCheckInDateWithDate:cinDate];
    [self combinationCheckOutDateWithDate:coutDate];
    
    if (self.hotelSearchType == HotelSearchInland) {
        UMENG_EVENT(UEvent_Hotel_Search_DateChoice);
    }
}

#pragma mark -
#pragma mark HotelSearch

-(void)clickSearchHotel{
    // by dawn 国内酒店检测时区
    if (self.hotelSearchType == HotelSearchInland) {
        [self checkLocalTimeZone];
    }
    
    // 如果城市列表选择结果为“当前位置”则按照周边搜索处理
    if ([m_cityTextField.text isEqualToString:@"当前位置"]) {
        [self searchHotelNearBy:nil];
        return;
    }

    currentTag = CITY_STATE;
    
    if (self.hotelSearchType == HotelSearchInland) {
        UMENG_EVENT(UEvent_Hotel_Search_Search);
        // 记录选择城市历史记录
        [[ElongUserDefaults sharedInstance] setObject:m_cityTextField.text forKey:USERDEFAULT_HOTEL_SEARCHCITYNAME];
        
        // 记录关键词历史记录
        if (STRINGHASVALUE(m_keywordsTextField.text) ) {
            
            // 搜索条件额外参数
            HotelConditionRequest *request = [HotelConditionRequest shared];
            NSString *city = [NSString stringWithFormat:@"%@",m_cityTextField.text];
            NSString *key = [NSString stringWithFormat:@"%@",m_keywordsTextField.text];
            NSNumber *type = nil;
            NSNumber *pid = nil;
            NSNumber *lat = nil;
            NSNumber *lng = nil;
            
            type = NUMBER(request.keywordFilter.keywordType);
            if (request.keywordFilter.keywordType == HotelKeywordTypeBrand) {
                pid = [NSNumber numberWithInt:request.keywordFilter.pid];
            }else if (request.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation
                || request.keywordFilter.keywordType == HotelKeywordTypeSubwayStation
                || request.keywordFilter.keywordType == HotelKeywordTypePOI) {
                lat = [NSNumber numberWithFloat:request.keywordFilter.lat];
                lng = [NSNumber numberWithFloat:request.keywordFilter.lng];
            }
            //保存作为历史使用
            [PublicMethods saveSearchKey:key type:type propertiesId:pid lat:lat lng:lng forCity:city];
        }

        
        // 酒店搜索
        if ([StringFormat isContainedSpecialChar:m_keywordsTextField.text]) {
            [Utils alert: @"酒店名称包含非法字符"];
            return ;
        }
        netstate = SEARCHHOTELLIST;
        JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
        [HotelSearch setPositioning:NO];
        [hotelsearcher clearBuildData];
        [hotelsearcher setCityName:m_cityTextField.text];
        
        HotelConditionRequest *request = [HotelConditionRequest shared];
        request.isFromLastMinute = NO;
        
        if (m_keywordsTextField.text!=nil&&[m_keywordsTextField.text length]>0) {
            // 有搜索条件时
            if (request.keywordFilter.keywordType == HotelKeywordTypeBrand) {
                // 品牌记录
                [hotelsearcher setBrandIDs:[NSString stringWithFormat:@"%d",request.keywordFilter.pid]];
            }else if(request.keywordFilter.keywordType == HotelKeywordTypeBusiness
                     || request.keywordFilter.keywordType == HotelKeywordTypeDistrict){
                // 商圈或行政区
                [hotelsearcher setAreaName:request.keywordFilter.keyword];
            }else if (request.keywordFilter.keywordType == HotelKeywordTypeNormal){
                // 酒店名
                [hotelsearcher setHotelName:request.keywordFilter.keyword];
            }else if (request.keywordFilter.keywordType == HotelKeywordTypePOI
                      || request.keywordFilter.keywordType == HotelKeywordTypeSubwayStation
                      || request.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation){
                // 经纬度搜索
                [hotelsearcher setCurrentPos:HOTEL_NEARBY_RADIUS Longitude:request.keywordFilter.lng Latitude:request.keywordFilter.lat];
            }
        }
        // 增加7天可选性 不加下面一行
        [hotelsearcher setMutipleFilter:@"52"];  // 对应开关110100
        
        [hotelsearcher setCheckData:[oFormat stringFromDate:self.checkInDate] checkoutdate:[oFormat stringFromDate:self.checkOutDate]];
        
        [[Profile shared] start:@"国内酒店搜索"];
        [Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] policy:CachePolicyHotelList delegate:self];
        
        
        
        // countly search
        CountlyEventHotelSearchPageSearch *countlySearch = [[CountlyEventHotelSearchPageSearch alloc] init];
        countlySearch.keyword = [hotelsearcher getHotelName];
        countlySearch.checkInDate = [hotelsearcher getCheckinDate];
        countlySearch.checkOutDate = [hotelsearcher getCheckoutDate];
        countlySearch.city = [hotelsearcher cityName];
        countlySearch.highestPrice = NUMBER([[hotelsearcher getMaxPrice] intValue]);
        countlySearch.lowestPrice = NUMBER([[hotelsearcher getMinPrice] intValue]);
        countlySearch.hotelBrandid = [[hotelsearcher getBrandIDs] componentsJoinedByString:@","];
        countlySearch.isApartment = [NSNumber numberWithBool:[hotelsearcher getIsApartment]];
        countlySearch.isPositioning = [NSNumber numberWithBool:[hotelsearcher getIsPos]];
        countlySearch.latitude = [NSNumber numberWithFloat:[hotelsearcher getLatitude]];
        countlySearch.longitude = [NSNumber numberWithFloat:[hotelsearcher getLongitude]];
        countlySearch.memberLevel = [NSNumber numberWithInt:[hotelsearcher getMemberLevel]];
        countlySearch.mutilpleFilter = [NSNumber numberWithInt:[[hotelsearcher getMutipleFilter] intValue]];
        countlySearch.orderBy =  [NSNumber numberWithInt:[hotelsearcher getOrderBy]];
        countlySearch.pageIndex = [NSNumber numberWithInt:[hotelsearcher getPageIndex]];
        countlySearch.pageSize = [NSNumber numberWithInt:[hotelsearcher getPageSize]];
        countlySearch.radius = [NSNumber numberWithInt:[hotelsearcher getRadius]];
        countlySearch.searchType = [NSNumber numberWithInt:[hotelsearcher getSearchType]];
        countlySearch.starCode = [hotelsearcher getStarCodesStr];
        countlySearch.facilitiesFilter = [[hotelsearcher getFacilitiesFilter] componentsJoinedByString:@","];
        countlySearch.themesFilter = [[hotelsearcher getThemesFilter] componentsJoinedByString:@","];
        countlySearch.filter = [NSNumber numberWithInt:[[hotelsearcher getFilter] intValue]];
        countlySearch.areaName = [hotelsearcher getAreaName];
        [countlySearch sendEventCount:1];
        [countlySearch release];
        
    }
    else if (self.hotelSearchType == HotelSearchInternational) {
        // 酒店搜索
        netstate = SEARCHHOTELLIST;
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        
        // 国际酒店,需要存储3个城市，保持先进先出
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             m_cityTextField.text, Cnname_CityList_InterHotel,      // 存储显示名字
                             searcher.cityId, DESTINATION_CITYLIST_INTERHOTEL,      // 存储destID
                             searcher.cityNameEn, Ename_CityList_InterHotel,        // 存储enname
                             searcher.cityDescription, Description_CityList_InterHotel,  // 存储中文描述
                             nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *cities = [NSMutableArray arrayWithArray:[defaults objectForKey:History_Cities]];
        
        BOOL canSaveCity = YES;      // 标记是否可存储当前城市
        for (NSDictionary *savedCity in cities) {
            if ([[savedCity safeObjectForKey:DESTINATION_CITYLIST_INTERHOTEL] isEqualToString:searcher.cityId]) {
                // 重复的城市不存储
                canSaveCity = NO;
            }
        }
        
        if (canSaveCity) {
            if ([cities count] >= 3) {
                [cities removeLastObject];
            }
            
            [cities insertObject:dic atIndex:0];
            
            [defaults setObject:cities forKey:History_Cities];
            [defaults synchronize];
        }
        
        //把搜索城市和对应条件存入本地
        [PublicMethods saveSearchKey:_interHotelKeywordTextField.text forCity:m_cityTextField.text];
        // ==================================================================
        
        [searcher reset];
        [searcher setCheckInDate:[oFormat stringFromDate:self.checkInDate]];
        [searcher setCheckOutDate:[oFormat stringFromDate:self.checkOutDate]];
        [searcher setKeywords:self.interHotelKeywordTextField.text];
        
        [[Profile shared] start:@"国际酒店搜索"];
        [Utils request:INTER_SEARCH req:[searcher request] policy:CachePolicyHotelList delegate:self];
    }
}

- (void)resetSearchCondition{
    switch (currentTag) {
        case CITY_STATE:{
            
            netstate = SEARCHHOTELLIST;
            JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
            [HotelSearch setPositioning:NO];
            [hotelsearcher clearBuildData];
            [hotelsearcher setCityName:m_cityTextField.text];
            
            HotelConditionRequest *request = [HotelConditionRequest shared];
            request.isFromLastMinute = NO;
            
            
            // 增加7天可选性 不加下面一行
            [hotelsearcher setMutipleFilter:@"52"];  // 对应开关110100
            
            [hotelsearcher setCheckData:[oFormat stringFromDate:self.checkInDate] checkoutdate:[oFormat stringFromDate:self.checkOutDate]];
            
        }
            break;
        case AROUND_STATE:{
            netstate = SEARCHHOTELLIST;
            
            [[HotelConditionRequest shared] setIsFromLastMinute:NO];
            // 周边搜索时打开定位
            FastPositioning *position = [FastPositioning shared];
            position.autoCancel = NO;
            [position fastPositioning];
            
            JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
            [HotelSearch setPositioning:YES];
            [hotelsearcher clearBuildData];
            
            [hotelsearcher setCityName:[[PositioningManager shared] currentCity]];
            [hotelsearcher setMutipleFilter:@"52"];
            [hotelsearcher setCurrentPos:HOTEL_NEARBY_RADIUS Longitude:[[PositioningManager shared] myCoordinate].longitude Latitude:[[PositioningManager shared] myCoordinate].latitude];
            [hotelsearcher setCheckData:[oFormat stringFromDate:self.checkInDate] checkoutdate:[oFormat stringFromDate:self.checkOutDate]];
        }
            break;
    }
}

#pragma mark -
#pragma mark C2C入口
- (void) c2cSearchBtnClick{
    [[XGApplication shareApplication] pushViewAnimation:self.navigationController];
}

- (void) checkC2C{
    if ([m_cityTextField.text isEqualToString:@"北京"] && [ProcessSwitcher shared].showC2CInHotelSearch) {
        c2cSearchBtn.hidden = NO;
        searchBtn.frame =  CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2 + 80 + 10, 230, BOTTOM_BUTTON_WIDTH - 80 - 10, BOTTOM_BUTTON_HEIGHT);
    }else{
        c2cSearchBtn.hidden = YES;
        searchBtn.frame =  CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2, 230, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT);
    }
}

#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == REPOSITION_ALERT) {
        // 重新定位
        if (buttonIndex == 1) {
            [[PositioningManager shared] setGpsing:YES];
            
            FastPositioning *position = [FastPositioning shared];
            position.autoCancel = YES;
            [position fastPositioning];
        }
    }
}

#pragma mark -
#pragma mark HotelSearchConditionDelegate
- (void) hotelSearchConditionViewCtrontroller:(HotelSearchConditionViewCtrontroller *)controller didSelect:(JHotelKeywordFilter *)locationInfo{
    HotelConditionRequest *condition	= [HotelConditionRequest shared];
    [condition clearKeywordFilter];
    [condition.keywordFilter copyDataFrom:locationInfo];
    self.m_keywordsTextField.text = condition.keywordFilter.keyword;
    
    if (locationInfo) {
        [self.navigationController popToViewController:self animated:YES];
    }
    
}

- (void) hotelSearchConditionViewCtrontrollerSearchNearby:(HotelSearchConditionViewCtrontroller *)controller{
    
    [self.navigationController popToViewController:self animated:NO];
    
    [self searchHotelNearBy:nil];
}

#pragma mark -
#pragma mark InterHotelKeywordSearchDelegate

- (void)interHotelKeywordSearchController:(InterHotelKeywordSearchController *)controller searchWithKeyword:(NSString *)keyword{
    self.interHotelKeywordTextField.text = keyword;
    
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)interHotelKeywordSearchControllerDidCanceled:(InterHotelKeywordSearchController *)controller{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark HttpUtilRequestDelegate

- (void)httpConnectionDidCanceled:(HttpUtil *)util{
	if (SEARCHTODAYOFFHOTEL == netstate) {
		seg.selectedIndex = currentTag;
	}
    
    [self removeLoadingState];
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData{
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    [self performSelector:@selector(removeLoadingState) withObject:nil afterDelay:0.8];
    
    if (!DICTIONARYHASVALUE(root)) {
        [PublicMethods showAlertTitle:@"未找到搜索酒店" Message:nil];
        return;
    }
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
	
	switch (netstate) {
        case SEARCHHOTELLISTNEARBY:{
            if (![[FastPositioning shared] abroad]) {
                NSArray *listArray = [root safeObjectForKey:RespHL_HotelList_A];
                if ([listArray isKindOfClass:[NSArray class]] && [listArray count] == 0) {
                    [Utils alert:@"未查询到您搜索的酒店"];
                    return;
                }
                [self goHotelListWithDictionary:root];
            }
            else {
                NSArray *listArray = [root safeObjectForKey:HOTEL_LIST];
                if ([listArray isKindOfClass:[NSArray class]] && [listArray count] == 0) {
                    [Utils alert:@"未查询到您搜索的酒店"];
                    return;
                }
                
                [self goInternationalHotelListWithDictionary:root];
            }
        }
            break;
		case SEARCHHOTELLIST:{
            if (self.hotelSearchType == HotelSearchInland) {
                NSArray *listArray = [root safeObjectForKey:RespHL_HotelList_A];
                if ([listArray isKindOfClass:[NSArray class]] && [listArray count] == 0) {
                    [Utils alert:@"未查询到您搜索的酒店"];
                    return;
                }
                [self goHotelListWithDictionary:root];
                [[Profile shared] end:@"国内酒店搜索"];
            }
            else if (self.hotelSearchType == HotelSearchInternational) {
                NSArray *listArray = [root safeObjectForKey:HOTEL_LIST];
                if ([listArray isKindOfClass:[NSArray class]] && [listArray count] == 0) {
                    [Utils alert:@"未查询到您搜索的酒店"];
                    return;
                }
                
                [self goInternationalHotelListWithDictionary:root];
                [[Profile shared] end:@"国际酒店搜索"];
            }
		}
			break;
		case SEARCHHOTELDETAIL:{
			[[HotelDetailController hoteldetail] removeAllObjects];
			[[HotelDetailController hoteldetail] addEntriesFromDictionary:root];
            [[HotelDetailController hoteldetail] removeRepeatingImage];
			HotelDetailController *hd = [[HotelDetailController alloc] init:_string(@"s_detail") style:_NavNormalBtnStyle_];
			[self.navigationController pushViewController:hd animated:YES];
			[hd release];
		}
			break;
        case MYFAVOURITE:{
            [[MyElongCenter allHotelFInfo] removeAllObjects];
            NSArray *favorArray = [root safeObjectForKey:@"HotelFavorites"];
            if ([favorArray isEqual:[NSNull null]]) {
                favorArray = [NSArray array];
            }
            [[MyElongCenter allHotelFInfo] addObjectsFromArray:favorArray];
            
            HotelFavoriteRequest *jghf=[HotelPostManager favorite];
            
            HotelFavorite *mFavorite = [[HotelFavorite alloc] initWithEditStyle:YES category:jghf.category];
            mFavorite.totalCount = [[root objectForKey:@"TotalCount"] intValue];
            [self.navigationController pushViewController:mFavorite animated:YES];
            [mFavorite release];
        }
			break;
	}
	
	netstate = -1;
}
//临时 c2c 入口
//- (IBAction)tempc2c_goin:(id)sender {
//    [[XGApplication shareApplication] pushViewAnimation:self.navigationController];
//
//    XGHomeSearchViewController *searchvc = [[XGHomeSearchViewController alloc]init];
//    [self.navigationController pushViewController:searchvc animated:[[XGApplication shareApplication] isAnimationForSaerch]];
//    [searchvc release];
//}



@end
