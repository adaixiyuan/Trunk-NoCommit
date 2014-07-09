//
//  FlightList.m
//  ElongClient
//
//  Created by dengfang on 11-1-13.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "FlightList.h"
#import "FlightListCell.h"
#import "FlightDetail.h"
#import "Utils.h"
#import "FlightDataDefine.h"
#import "FlightSearch.h"
#import "FlightFilterSelectable.h"
#import <QuartzCore/QuartzCore.h>
#import "ElongInsurance.h"
#import "LowPriceItem.h"

#define kTrainListFilterButtonBadgeWidth            4
#define kTrainListFilterButtonBadgeHeight           4
#define kTrainListSortPriceIconWidth                21
#define kTrainListSortPriceIconHeight               17
#define kTrainListSortTimeIconWidth                 25
#define kTrainListSortTimeIconHeight                17
#define kTrainListFilterIconWidth                   14
#define kTrainListFilterIconHeight                  17
#define kTrainListNavBarHeight                      44
#define kTrainListBottomViewHeight                  44
#define kTrainListBottomMiddleYMargin               3

#define kCellLineViewTag                            1024

// 控件Tag
enum TrainListVCTag {
    kTrainListTopPredayButtonTag = 100,
    kTrainListTopViewShadowTag,
    kTrainListTopCurdayButtonTag,
    kTrainListTopNextdayButtonTag,
    kTrainListTopLeftArrowIconTag,
    kTrainListTopRightArrowIconTag,
    kTrainListDateInitLabelTag,
    kTrainListTopPredayHintLabelTag,
    kTrainListTopCurdayDateLabelTag,
    kTrainListTopCurdayWeekLabelTag,
    kTrainListTopNextdayHintLabelTag,
    kTrainListSortPriceButtonTag,
    kTrainListSortTimeButtonTag,
    kTrainListSortPriceIconTag,
    kTrainListSortPriceLabelTag,
    kTrainListSortTimeIconTag,
    kTrainListSortTimeLabelTag,
    kTrainListFilterIconTag,
    kTrainListFilterLabelTag,
    kTrainListBottomFilterButtonTag,
    kTrainListBottomFilterButtonBadgeTag,
    kTrainListBottomSortButtonTag,
    kTrainListCellTrainInfoR1ViewTag,
    kTrainListCellTrainInfoR2ViewTag,
    kTrainListCellTrainNumberLabelTag,
    kTrainListCellRightArrowTag,
    kTrainListCellPriceHintLabelTag,
    kTrainListCellPriceLabelTag,
    kTrainListCellCurrencySignLabelTag,
    kTrainListCellDepartIconTag,
    kTrainListCellArriveIconTag,
    kTrainListCellDepartStationLabelTag,
    kTrainListCellArriveStationLabelTag,
    kTrainListCellDepartTimeLabelTag,
    kTrainListCellArriveTimeLabelTag,
    kTrainListCellYpMessageLabelTag,
    kTrainListCellDurationLabelTag,
    kTrainListCellTicketInfoLabelTag,
    kTrainListCellTrainInfoDepartViewTag,
    kTrainListCellTrainInfoArriveViewTag,
    kTrainListCellCellNoResultHintLabelTag,
};

// 网络请求Tag
enum FlightListNetworkTag
{
	kFListNetworkDetail = 200,
	kFListNetworkLowPrice,
};

@implementation FlightList
@synthesize dataSourceArray;
@synthesize tAirCorpArray;
@synthesize tAirPortArray;
@synthesize tabView;
@synthesize dateLabel;
@synthesize currentJSONDate;
@synthesize currentOrder;


- (id)initWithTitle:(NSString *)title displayTransFlight:(BOOL)isDisplay {
    displayTransFlight = isDisplay;
    
    if (self = [super initWithTopImagePath:@"" andTitle:title style:_NavNormalBtnStyle_]) {
    }
    
    return self;
}

#pragma mark -
#pragma mark Action
#pragma mark moreFlight
-(void)moreFlight{
	tapCount++;
	if ([[SettingManager instanse] defaultFlightListCount] * tapCount>=[dataSourceArray count] || [[SettingManager instanse] defaultFlightListCount]>50) {
		tabView.tableFooterView = nil;
	}
    //	[tabView reloadData];
    [self loadListData];
}


#pragma mark -
typedef enum {
	NavBarStateShow = 0,
	NavBarStateHidden = 1
} NavBarState;

#pragma mark -
#pragma mark Private
//

NSInteger sortFlightPrice(id flight1, id flight2, void *context) {
	int f1 = [[flight1 getPrice] intValue];
	int f2 = [[flight2 getPrice] intValue];
	//递增（小-->大）
	if (f1 < f2)
		return NSOrderedAscending;
	else if (f1 > f2)
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

//价格降序
NSInteger sortFlightPriceDescending(id flight1, id flight2, void *context) {
	int f1 = [[flight2 getPrice] intValue];
	int f2 = [[flight1 getPrice] intValue];
	//递增（小-->大）
	if (f1 < f2)
		return NSOrderedAscending;
	else if (f1 > f2)
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

//时间升序
NSInteger sortFlightTime(id flight1, id flight2, void* context) {
	//NSDate *f1 = [Utils getDateByElongDate:[flight1 getDepartTime]];
    //	NSDate *f2 = [Utils getDateByElongDate:[flight2 getDepartTime]];
	NSDate *f1 = [TimeUtils parseJsonDate:[flight1 getDepartTime]];
	NSDate *f2 = [TimeUtils parseJsonDate:[flight2 getDepartTime]];
	return [f1 compare:f2];
}


//时间降序
NSInteger sortFlightTimeDescending(id flight1, id flight2, void* context) {
	//NSDate *f1 = [Utils getDateByElongDate:[flight1 getDepartTime]];
    //	NSDate *f2 = [Utils getDateByElongDate:[flight2 getDepartTime]];
	NSDate *f1 = [TimeUtils parseJsonDate:[flight1 getDepartTime]];
	NSDate *f2 = [TimeUtils parseJsonDate:[flight2 getDepartTime]];
	return [f2 compare:f1];
}


- (NSMutableArray *)getAirlinesArray:(NSMutableArray *)dataArray {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (Flight *flight in dataArray) {
		BOOL isHave = NO;
		for (NSString *str in array) {
			if ([[flight getAirCorpName] isEqualToString:str]) {
				isHave = YES;
				break;
			}
		}
		if (!isHave) {
			//isHave = NO;
			[array addObject:[flight getAirCorpName]];
		}
	}
	
	
	return [array autorelease];
}

- (NSMutableArray *)getDepartArray:(NSMutableArray *)dataArray {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (Flight *flight in dataArray) {
		BOOL isHave = NO;
		for (NSString *str in array) {
			if ([[flight getDepartAirport] isEqualToString:str]) {
				isHave = YES;
				break;
			}
		}
		if (!isHave) {
			//isHave = NO;
			[array addObject:[flight getDepartAirport]];
		}
	}
    
	return [array autorelease];
}

- (NSMutableArray *)getArrivalArray:(NSMutableArray *)dataArray {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (Flight *flight in dataArray) {
		BOOL isHave = NO;
		for (NSString *str in array) {
			if ([[flight getArriveAirport] isEqualToString:str]) {
				isHave = YES;
				break;
			}
		}
		if (!isHave) {
			//isHave = NO;
			[array addObject:[flight getArriveAirport]];
		}
	}
	
	return [array autorelease];
}

- (void)loadListData {
    //	dataSourceArray = [[NSMutableArray alloc] init];
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.dataSourceArray = tempArray;
	[tempArray release];
    
	if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP)
    {
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP)
        { //1=往返
            // 判断并设置返程日期
            NSString *departDateString = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE];
            NSString *returnDateString = [[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_DATE];
            
            if (STRINGHASVALUE(departDateString) && STRINGHASVALUE(returnDateString))
            {
                NSDate *departDate = [_oFormat dateFromString:departDateString];
                NSDate *returnDate = [_oFormat dateFromString:returnDateString];
                
                // 出发日期和返回日期比较
//                if ([returnDate compare:departDate] == NSOrderedAscending ||
//                    [returnDate compare:departDate] == NSOrderedSame)
                if ([returnDate compare:departDate] == NSOrderedAscending)
                {
                    NSDate *returnDateNew = [NSDate dateWithTimeInterval:1*24*60*60 sinceDate:departDate];
                    
                    [[FlightData getFDictionary] safeSetObject:[_oFormat stringFromDate:returnDateNew] forKey:KEY_RETURN_DATE];
                }
            }
        }
        
        
		dateLabel.text = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE];
		if ([[FlightData getFArrayGo] count] > 0)
        {
			[dataSourceArray addObjectsFromArray:[FlightData getFArrayGo]];
		}
	} else {
		dateLabel.text = [[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_DATE];
		if ([[FlightData getFArrayReturn] count] > 0) {
			[dataSourceArray addObjectsFromArray:[FlightData getFArrayReturn]];
		}
	}
	
	if ([dataSourceArray count] <= 0) {
		tabView.hidden = YES;
		blogView.hidden = NO;
	} else {
        tabView.hidden = NO;
        blogView.hidden = YES;
	}
    
    NSMutableArray *tempMutableArray = [NSMutableArray arrayWithArray:dataSourceArray];
    self.filterArray = tempMutableArray;
    
    
     [self reloadDataByConditions];
    
    if (_viewBottom != nil)
    {
        [self setupViewBottomSubs:_viewBottom];
    }
    
    // 刷新筛选项
    _filterReset = YES;
}

- (void)reloadDataByConditions
{
	NSDate *currentDate = [TimeUtils NSStringToNSDate:dateLabel.text formatter:@"yyyy-MM-dd"];
	self.currentJSONDate = [TimeUtils makeJsonDateWithUTCDate:currentDate];
	
    NSArray *array = nil;
    switch (currentOrder) {
        case 0:
            // 时间从早到晚排序
            array = [_filterArray sortedArrayUsingFunction:sortFlightTime context:nil];
            break;
        case 1:
            // 时间从晚到早排序
            array = [_filterArray sortedArrayUsingFunction:sortFlightTimeDescending context:nil];
            break;
        case 2:
            // 价格从低到高排序
            array = [_filterArray sortedArrayUsingFunction:sortFlightPrice context:nil];
            break;
        case 3:
            // 价格从高到低排序
            array = [_filterArray sortedArrayUsingFunction:sortFlightPriceDescending context:nil];
            break;
        default:
            break;
    }
    
    // 将已售完的航班置底
    NSMutableArray *arrayTmp = [NSMutableArray arrayWithArray:array];
    NSMutableArray *arrayTarget = [NSMutableArray array];
    
    for (NSInteger i=0; i<[array count]; i++)
    {
        Flight *flight = [array safeObjectAtIndex:i];
        if (flight != nil && [flight ticketCount] != nil && [[flight ticketCount] boolValue] == NO)
        {
            [arrayTarget addObject:flight];
        }
    }
    // 处理数据
    if ([arrayTarget count] > 0)
    {
        [arrayTmp removeObjectsInArray:arrayTarget];
        [arrayTmp addObjectsFromArray:arrayTarget];
    }
    
    [_filterArray removeAllObjects];
    [_filterArray addObjectsFromArray:arrayTmp];
	
	if ([_filterArray count] <= 0) {
		tabView.hidden = YES;
		blogView.hidden = NO;
	} else {
        tabView.hidden = NO;
        blogView.hidden = YES;
	}
    
    NSInteger index = 0;
    for (Flight *flight in _filterArray) {
        if ([_cellHeightArray safeObjectAtIndex:index] == nil) {
            if (flight.stopNumber > 0) {
                [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", 88.0f]];
            }
            else {
                [_cellHeightArray addObject:[NSString stringWithFormat:@"%f", 78.0f]];
            }
        }
        else {
            if (flight.stopNumber > 0) {
                [_cellHeightArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%f", 88.0f]];
            }
            else {
                [_cellHeightArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%f", 78.0f]];
            }
        }
        
        index++;
    }
	
	[tabView reloadData];
	[self updateAirCorpArray];
	[self updateAirPortArray];
    
    [tabView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (UIImage *)imageWithColor:(UIColor *)color  inRect:(CGRect)rect{
    //    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -
#pragma mark IBAction
- (void)priceButtonPressed:(int)num{
    _isPriceAscending = !_isPriceAscending;
    _isTimeReset = YES;
    _isPriceReset = NO;
    
	if (_isPriceAscending) {
        currentOrder = 2;
        NSArray *array = [_filterArray sortedArrayUsingFunction:sortFlightPrice context:nil];
		[_filterArray removeAllObjects];
		[_filterArray addObjectsFromArray:array];
        [self reloadDataByConditions];
        
    }
    else
    {
        currentOrder = 3;
        NSArray *array = [_filterArray sortedArrayUsingFunction:sortFlightPriceDescending context:nil];
		[_filterArray removeAllObjects];
		[_filterArray addObjectsFromArray:array];
        [self reloadDataByConditions];
    }
    
	if ([_filterArray count] > 0){
		[tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
    
    // 刷新界面
    if (_viewBottom != nil)
    {
        [self setupViewBottomSubs:_viewBottom];
    }
}

- (void)timeButtonPressed:(int)num{
    _isTimeAscending = !_isTimeAscending;
    _isPriceReset = YES;
    _isTimeReset = NO;
    
	if (_isTimeAscending) {
        currentOrder = 0;
		NSArray *array = [_filterArray sortedArrayUsingFunction:sortFlightTime context:nil];
		[_filterArray removeAllObjects];
		[_filterArray addObjectsFromArray:array];
        [self reloadDataByConditions];
		
	}
	else
	{
        currentOrder = 1;
		NSArray *array = [_filterArray sortedArrayUsingFunction:sortFlightTimeDescending context:nil];
		[_filterArray removeAllObjects];
		[_filterArray addObjectsFromArray:array];
        [self reloadDataByConditions];
		
	}
	
	if ([_filterArray count] > 0){
		[tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
    
    // 刷新界面
    if (_viewBottom != nil)
    {
        [self setupViewBottomSubs:_viewBottom];
    }
}

- (BOOL)isFirstMoreThan:(NSDate *)firstDate secondDate:(NSDate *)secondDate {
	double fDate = [firstDate timeIntervalSince1970];
	double sDate = [secondDate timeIntervalSince1970];
	
	if (fDate > sDate) {
		return YES;
	}
	return NO;
}

#pragma mark - 事件函数


- (void)updateAirCorpArray {
	if (FillerTable != nil && [dataSourceArray count] > 0) {
		[FillerTable.selectTable updateDataArray:[self getAirlinesArray:dataSourceArray]];
		[tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
	
}

- (void)updateAirPortArray {
	if (FillerTable != nil && [dataSourceArray count] > 0) {
		[FillerTable.airPortTable updateDepartArray:[self getDepartArray:dataSourceArray] arrivalArray:[self getArrivalArray:dataSourceArray]];
		[tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
}


- (void)filterButtonPressed:(UIButton*)sender {
    NSMutableArray *airlinesArray = [NSMutableArray arrayWithArray:[self getAirlinesArray:dataSourceArray]];
    NSMutableArray *departArray = [NSMutableArray arrayWithArray:[self getDepartArray:dataSourceArray]];
    NSMutableArray *arrivalArray = [NSMutableArray arrayWithArray:[self getArrivalArray:dataSourceArray]];
    
    if (_filterNav == nil) {
        FlightSearchFilterController *flightFilterTmp = [[FlightSearchFilterController alloc] initWithAirlineArray:airlinesArray departureAirportArray:departArray arrivalAirportArray:arrivalArray];
        flightFilterTmp.filterDelegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:flightFilterTmp];
        [flightFilterTmp release];
        self.filterNav = nav;
        [nav release];
    }
    
    FlightSearchFilterController *flightFilterVC = (FlightSearchFilterController *)_filterNav.viewControllers[0];
    if (flightFilterVC != nil && (_filterReset))
    {
        [flightFilterVC reset];
    }
    
    
    if (IOSVersion_7) {
        _filterNav.transitioningDelegate = [ModalAnimationContainer shared];
        _filterNav.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:_filterNav animated:YES completion:nil];
    }else{
        [self presentModalViewController:_filterNav animated:YES];
    }
}


- (void)PopSortCondition:(UIButton*)sender {
	if (!sortSelectTable.view.superview) {
		if (!sortSelectTable) {
			sortSelectTable = [[FilterView alloc] initWithTitle:@"排序"
														  Datas:[NSArray arrayWithObjects:@"时间从早到晚", @"时间从晚到早", @"价格从低到高", @"价格从高到低", nil]];
			sortSelectTable.delegate = self;
		}
		
		[self.view addSubview:sortSelectTable.view];
	}
	
    [sortSelectTable showInView];
}

// 获取低价日历
- (void)getLowPriceStart
{
    // 组织Json
	NSMutableDictionary *dictionaryJson = [[NSMutableDictionary alloc] init];
    
    // 请求头
    NSMutableDictionary *headDic = [PostHeader header];
    if (DICTIONARYHASVALUE(headDic))
    {
        [dictionaryJson safeSetObject:headDic forKey:Resq_Header];
    }
    
    // 起飞地点
    NSString *departCity = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY];
    // 降落地点
    NSString *arriveCity = [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY];
    
    // 查询开始日期
    NSString * departDateString = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE];
    NSDate *startDate = [NSDate date];
    if ([[_oFormat dateFromString:departDateString] timeIntervalSinceDate:[NSDate date]] > 3*24*60*60)
    {
        startDate = [NSDate dateWithTimeInterval:-3*24*60*60 sinceDate:[_oFormat dateFromString:departDateString]];
    }
    NSString *startDateString = [_oFormat stringFromDate:startDate];
    
    
    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP)
    { //1=往返
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_RETURN_TRIP)    // 返程
        {
            departCity = [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY];
            arriveCity = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY];
            
            startDate = [_oFormat dateFromString:departDateString];
            startDateString = departDateString;

            NSString *returnDateString = [[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_DATE];
            
            if (STRINGHASVALUE(returnDateString))
            {
                NSDate *departDate = [_oFormat dateFromString:departDateString];
                NSDate *returnDate = [_oFormat dateFromString:returnDateString];
                
                // 出发日期和returnDate 前3天比较
                if ([departDate compare:[NSDate dateWithTimeInterval:-3*24*60*60 sinceDate:returnDate]] == NSOrderedAscending ||
                    [departDate compare:[NSDate dateWithTimeInterval:-3*24*60*60 sinceDate:returnDate]] == NSOrderedSame)
                {
                    startDate = [NSDate dateWithTimeInterval:-3*24*60*60 sinceDate:returnDate];
                }
                // 出发日期和returnDate 前2天比较
                else if ([departDate compare:[NSDate dateWithTimeInterval:-2*24*60*60 sinceDate:returnDate]] == NSOrderedAscending ||
                         [departDate compare:[NSDate dateWithTimeInterval:-2*24*60*60 sinceDate:returnDate]] == NSOrderedSame)
                {
                    startDate = [NSDate dateWithTimeInterval:-2*24*60*60 sinceDate:returnDate];
                }
                // 出发日期和returnDate 前1天比较
                else if ([departDate compare:[NSDate dateWithTimeInterval:-1*24*60*60 sinceDate:returnDate]] == NSOrderedAscending ||
                         [departDate compare:[NSDate dateWithTimeInterval:-1*24*60*60 sinceDate:returnDate]] == NSOrderedSame)
                {
                    startDate = [NSDate dateWithTimeInterval:-1*24*60*60 sinceDate:returnDate];
                }
                // 出发日期和returnDate 比较
                else if ([departDate compare:returnDate] == NSOrderedAscending ||
                         [departDate compare:returnDate] == NSOrderedSame)
                {
                    startDate = [_oFormat dateFromString:returnDateString];
                }
                
                //
                startDateString = [_oFormat stringFromDate:startDate];
            }
        }
    }
    // 出票城市名称
    NSString *issueCityName = departCity;
    
    // 查询结束日期
    NSDate *endDate = [NSDate dateWithTimeInterval:6*24*60*60 sinceDate:startDate];
    NSString *endDateString = [_oFormat stringFromDate:endDate];
    
    
    if (STRINGHASVALUE(departCity))
    {
        [dictionaryJson safeSetObject:departCity forKey:@"DepartCity"];
    }
    if (arriveCity != nil)
    {
        [dictionaryJson safeSetObject:arriveCity forKey:@"ArriveCity"];
    }
    if (STRINGHASVALUE(issueCityName))
    {
        [dictionaryJson safeSetObject:issueCityName forKey:@"IssueCityName"];
    }
    if (startDateString != nil)
    {
        [dictionaryJson safeSetObject:startDateString forKey:@"StartDate"];
    }
    if (STRINGHASVALUE(endDateString))
    {
        [dictionaryJson safeSetObject:endDateString forKey:@"EndDate"];
    }
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    [dictionaryJson release];
    
    // 请求url
    NSString *url = [PublicMethods requesString:@"GetLowestPrices" andIsCompress:YES andParam:paramJson];
    
    if (url != nil)
    {
        // 价格日历开始加载
        [_cheapCalendarView calendarStartLoading];
        
        _netType = kFListNetworkLowPrice;
        
        HttpUtil *getPriceListUtilTmp = [[HttpUtil alloc] init];
        [self setGetPriceListUtil:getPriceListUtilTmp];
        [getPriceListUtilTmp release];
        
        [_getPriceListUtil connectWithURLString:FLIGHT_SERACH
                                        Content:url
                                   StartLoading:NO
                                     EndLoading:NO
                                       Delegate:self];
    }
}

#pragma mark - 辅助函数

// 低价数据处理
- (void)lowPriceDataProcess
{
    if (_flightLowPrice != nil)
    {
        NSArray *arrayPriceList = [_flightLowPrice arrayPriceList];
        if (ARRAYHASVALUE(arrayPriceList))
        {
            NSMutableArray *arrayDate = [NSMutableArray array];
            NSMutableArray *arrayPrice = [NSMutableArray array];
            
            // 查询日期
            JFlightSearch *jFlightSearch = [FlightPostManager flightSearcher];
            NSString *queryDate = [jFlightSearch getDepartDate];
            
            NSInteger listCount = [arrayPriceList count];
            for (NSInteger i=0; i<listCount; i++)
            {
                LowPriceItem *priceItem = [arrayPriceList safeObjectAtIndex:i];
                if (priceItem != nil)
                {
                    // 日期
                    NSString *flightDateString = [priceItem flightDate];
                    if (STRINGHASVALUE(flightDateString))
                    {
                        
                        NSDate *flightDate=[TimeUtils parseJsonDate:flightDateString];
                        
                        // 日期为周几
                        NSString *weekInfo = [Utils getShortWeekend:flightDate];
                        
                        NSString *monthDate = [_priceDateFormate stringFromDate:flightDate];
                        
                        // 去除0x中的0
                        NSArray *arrayDateValue = [monthDate componentsSeparatedByString:@"-"];
                        if (ARRAYHASVALUE(arrayDateValue) && [arrayDateValue count] > 1)
                        {
                            NSString *cMonth = [arrayDateValue safeObjectAtIndex:0];
                            NSString *cDay = [arrayDateValue safeObjectAtIndex:1];
                            
                            if ([cMonth integerValue] < 10)
                            {
                                cMonth = [cMonth stringByReplacingOccurrencesOfString:@"0" withString:@""];
                            }
                            if ([cDay integerValue] < 10)
                            {
                                cDay = [cDay stringByReplacingOccurrencesOfString:@"0" withString:@""];
                            }
                            monthDate = [NSString stringWithFormat:@"%@-%@",cMonth,cDay];
                        }
                        
                        [arrayDate addObject:[NSString stringWithFormat:@"%@%@",monthDate,weekInfo]];
                        
                        // 获取查询日期的index
                        if (STRINGHASVALUE(queryDate) && [queryDate isEqualToString:flightDateString])
                        {
                            _lowPriceSelectIndex = i;
                        }
                    }
                    
                    // 价格
                    NSNumber *lowestPrice = [priceItem lowestPrice];
                    if (lowestPrice != nil && [lowestPrice integerValue] > 0)
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"¥ %d",[lowestPrice integerValue]]];
                    }
                    else
                    {
                        [arrayPrice addObject:[NSString stringWithFormat:@"暂无"]];
                    }
                }
            }
            
            if ([arrayDate count] > 0)
            {
               [_cheapCalendarView setArrayRow1:arrayDate];
            }
            if ([arrayPrice count] > 0)
            {
                [_cheapCalendarView setArrayRow2:arrayPrice];
            }
            
            // 设置item个数
            [_cheapCalendarView setItemCount:listCount];
            
            // 设置当前查询日期在日历中位置
            [self setCheapCalendarSelectedItem];
        }
    }
}

// 高亮选择的低价日历项
- (void)setCheapCalendarSelectedItem
{
    [_cheapCalendarView setItemHighlight:_lowPriceSelectIndex];
}

#pragma mark - 界面创建

// 创建筛选按钮
- (void)setupFilterButton:(UIButton *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // 筛选提示文案
    NSString *filterText = @"筛选";
    CGSize filterTextSize = [filterText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    
    // =====================================================
    // 筛选图标
    // =====================================================
    CGSize iconSize = CGSizeMake(kTrainListFilterIconWidth, kTrainListFilterIconHeight);
    
    // 计算间隔
    NSInteger spaceYmargin = (parentFrame.size.height-filterTextSize.height-iconSize.height)/2;
    spaceYStart += spaceYmargin;
    
    UIImageView *filterIcon = (UIImageView *)[viewParent viewWithTag:kTrainListFilterIconTag];
    if (filterIcon == nil)
    {
        filterIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [filterIcon setImage:[UIImage imageNamed:@"ico_filterbuttonicon.png"]];
        [filterIcon setTag:kTrainListFilterIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:filterIcon];
        [filterIcon release];
        
    }
    [filterIcon setFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2, spaceYStart, iconSize.width, iconSize.height)];
    
    // =====================================================
    // 筛选标志Icon
    // =====================================================
    CGSize filterBadgeSize = CGSizeMake(kTrainListFilterButtonBadgeWidth, kTrainListFilterButtonBadgeHeight);
    UIImageView *badgeIcon = (UIImageView *)[viewParent viewWithTag:kTrainListBottomFilterButtonBadgeTag];
    if (badgeIcon == nil)
    {
        badgeIcon = [[UIImageView alloc] initWithFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2+iconSize.width*1.3, spaceYStart, filterBadgeSize.width, filterBadgeSize.height)];
        [badgeIcon setImage:[UIImage imageNamed:@"filterButtonBadge.png"]];
        [badgeIcon setTag:kTrainListBottomFilterButtonBadgeTag];
        //        [badgeIcon setHidden:YES];
        if ([_filterArray count] == [dataSourceArray count]) {
            badgeIcon.hidden = YES;
        }
        else {
            badgeIcon.hidden = NO;
        }
        self.badgeImageView = badgeIcon;
        [viewParent addSubview:badgeIcon];
        [badgeIcon release];
    }
    
    // 子窗口大小
    spaceYStart += iconSize.height;
    // 间隔
    spaceYStart += kTrainListBottomMiddleYMargin;
    
    
    // =====================================================
    // 筛选提示文字
    // =====================================================
    UILabel *labelText = (UILabel *)[viewParent viewWithTag:kTrainListFilterLabelTag];
    if (labelText == nil)
    {
        labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelText setBackgroundColor:[UIColor clearColor]];
        [labelText setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
        [labelText setTextColor:[UIColor whiteColor]];
        [labelText setTextAlignment:UITextAlignmentCenter];
        [labelText setTag:kTrainListFilterLabelTag];
        // 保存
        [viewParent addSubview:labelText];
        [labelText release];
    }
    [labelText setFrame:CGRectMake((parentFrame.size.width-filterTextSize.width)/2, spaceYStart, filterTextSize.width, filterTextSize.height)];
    [labelText setText:filterText];
}

// 创建价格排序按钮
- (void)setupSortPriceButton:(UIButton *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // 排序提示文案
    //    NSString *sortText = @"价格从低到高";
    //    if (!_isPriceAscending)
    //    {
    //        sortText = @"价格从高到低";
    //    }
    NSString *sortText = @"价格";
    CGSize sortTextSize = [sortText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    
    // =====================================================
    // 排序图标
    // =====================================================
    CGSize iconSize = CGSizeMake(kTrainListSortPriceIconWidth, kTrainListSortPriceIconHeight);
    
    // 计算间隔
    NSInteger spaceYmargin = (parentFrame.size.height-sortTextSize.height-iconSize.height)/2;
    spaceYStart += spaceYmargin;
    
    UIImageView *sortIcon = (UIImageView *)[viewParent viewWithTag:kTrainListSortPriceIconTag];
    if (sortIcon == nil)
    {
        sortIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        if (_isPriceReset)
        {
            [sortIcon setImage:[UIImage imageNamed:@"ico_priceorder_normal.png"]];
        }
        else
            //ico_priceorder_ascending.png
        {
            [sortIcon setImage:_isPriceAscending ? [UIImage imageNamed:@"ico_priceorder_descending.png"] : [UIImage imageNamed:@"ico_priceorder_ascending.png"]];
        }
        
        [sortIcon setTag:kTrainListSortPriceIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:sortIcon];
        [sortIcon release];
        
    }
    [sortIcon setFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2, spaceYStart, iconSize.width, iconSize.height)];
    // 子窗口大小
    spaceYStart += iconSize.height;
    // 间隔
    spaceYStart += kTrainListBottomMiddleYMargin;
    
    // =====================================================
    // 排序提示文字
    // =====================================================
    UILabel *labelText = (UILabel *)[viewParent viewWithTag:kTrainListSortPriceLabelTag];
    if (labelText == nil)
    {
        labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelText setBackgroundColor:[UIColor clearColor]];
        [labelText setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
        [labelText setTextColor:[UIColor whiteColor]];
        [labelText setTextAlignment:UITextAlignmentCenter];
        [labelText setTag:kTrainListSortPriceLabelTag];
        // 保存
        [viewParent addSubview:labelText];
        [labelText release];
    }
    [labelText setFrame:CGRectMake((parentFrame.size.width-sortTextSize.width)/2, spaceYStart, sortTextSize.width, sortTextSize.height)];
    [labelText setText:sortText];
    
    
    
}

// 创建时间排序按钮
- (void)setupSortTimeButton:(UIButton *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    NSString *sortText = @"时间";
    CGSize sortTextSize = [sortText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    
    // =====================================================
    // 排序图标
    // =====================================================
    CGSize iconSize = CGSizeMake(kTrainListSortTimeIconWidth, kTrainListSortTimeIconHeight);
    
    // 计算间隔
    NSInteger spaceYmargin = (parentFrame.size.height-sortTextSize.height-iconSize.height)/2;
    spaceYStart += spaceYmargin;
    
    UIImageView *sortIcon = (UIImageView *)[viewParent viewWithTag:kTrainListSortTimeIconTag];
    if (sortIcon == nil)
    {
        sortIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        if (_isTimeReset)
        {
            [sortIcon setImage:[UIImage imageNamed:@"ico_timeorder_normal.png"]];
        }
        else
        {
            [sortIcon setImage:_isTimeAscending ? [UIImage imageNamed:@"ico_timeorder_descending.png"] : [UIImage imageNamed:@"ico_timeorder_ascending.png"]];
        }
        
        [sortIcon setTag:kTrainListSortTimeIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:sortIcon];
        [sortIcon release];
        
    }
    [sortIcon setFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2, spaceYStart, iconSize.width, iconSize.height)];
    // 子窗口大小
    spaceYStart += iconSize.height;
    // 间隔
    spaceYStart += kTrainListBottomMiddleYMargin;
    
    // =====================================================
    // 排序提示文字
    // =====================================================
    UILabel *labelText = (UILabel *)[viewParent viewWithTag:kTrainListSortTimeLabelTag];
    if (labelText == nil)
    {
        labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelText setBackgroundColor:[UIColor clearColor]];
        [labelText setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
        [labelText setTextColor:[UIColor whiteColor]];
        [labelText setTextAlignment:UITextAlignmentCenter];
        [labelText setTag:kTrainListSortTimeLabelTag];
        // 保存
        [viewParent addSubview:labelText];
        [labelText release];
    }
    [labelText setFrame:CGRectMake((parentFrame.size.width-sortTextSize.width)/2, spaceYStart, sortTextSize.width, sortTextSize.height)];
    [labelText setText:sortText];
}

// 创建BottomView的子界面
- (void)setupViewBottomSubs:(UIView *)viewParent
{
    // 移除子view
    for(UIView *subview in [viewParent subviews])
    {
        if (subview != nil)
        {
            [subview removeFromSuperview];
        }
    }
    
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    
    
    
    // =====================================================
    // 时间排序按钮
    // =====================================================
    CGSize sortBtnSize = CGSizeMake(parentFrame.size.width/3, parentFrame.size.height);
    
    UIButton *buttonSortTime = (UIButton *)[viewParent viewWithTag:kTrainListSortTimeButtonTag];
    if (buttonSortTime == nil)
    {
        buttonSortTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonSortTime addTarget:self action:@selector(timeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonSortTime setTag:kTrainListSortTimeButtonTag];
        // 保存
        [viewParent addSubview:buttonSortTime];
    }
    [buttonSortTime setFrame:CGRectMake(spaceXStart, 0, sortBtnSize.width, sortBtnSize.height)];
    
    // 子窗口大小
    spaceXStart += sortBtnSize.width;
    
    // 创建子界面
    [self setupSortTimeButton:buttonSortTime];
    
    // =====================================================
    // 价格排序按钮
    // =====================================================
    // 事件按钮
    CGSize priceBtnSize = CGSizeMake(parentFrame.size.width/3, parentFrame.size.height);
    
    UIButton *buttonSortPrice = (UIButton *)[viewParent viewWithTag:kTrainListSortPriceButtonTag];
    if (buttonSortPrice == nil)
    {
        buttonSortPrice = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonSortPrice addTarget:self action:@selector(priceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonSortPrice setTag:kTrainListSortPriceButtonTag];
        // 保存
        [viewParent addSubview:buttonSortPrice];
    }
    [buttonSortPrice setFrame:CGRectMake(spaceXStart, 0, priceBtnSize.width, priceBtnSize.height)];
    
    // 创建子界面
    [self setupSortPriceButton:buttonSortPrice];
    
    
    // =====================================================
    // 筛选按钮
    // =====================================================
    // 子窗口大小
    CGSize filterBtnSize = CGSizeMake(parentFrame.size.width/3, parentFrame.size.height);
    spaceXStart += filterBtnSize.width;
    
    UIButton *buttonFilter  = (UIButton *)[viewParent viewWithTag:kTrainListBottomFilterButtonTag];
    if (buttonFilter == nil)
    {
        buttonFilter = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonFilter addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonFilter setTag:kTrainListBottomFilterButtonTag];
        // 保存
        [viewParent addSubview:buttonFilter];
    }
    [buttonFilter setFrame:CGRectMake(spaceXStart, 0, filterBtnSize.width, filterBtnSize.height)];
    
    
    
    // 创建子界面
    [self setupFilterButton:buttonFilter];
    
    
    
    
}

- (void)back {
	if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_RETURN_TRIP) {
		// 如是返程，重设为去程
		[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_GO_TRIP] forKey:KEY_CURRENT_FLIGHT_TYPE];
	}
	
	[super back];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *tempMutableArray = [NSMutableArray arrayWithCapacity:0];
    self.cellHeightArray = tempMutableArray;
    
    self.view.backgroundColor = [UIColor colorWithRed:254.0f / 255 green:254.0f / 255 blue:254.0f / 255 alpha:1.0f];
	tapCount = 1;
	currentOrder = 2;

    // 低价日历View
    CheapCalendarView *cheapCalendarViewTmp = [[CheapCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [cheapCalendarViewTmp setDelegate:self];
    [self.view addSubview:cheapCalendarViewTmp];
    [self setCheapCalendarView:cheapCalendarViewTmp];
    [cheapCalendarViewTmp release];
    
    // 时间格式定义
    NSDateFormatter *oFormatTmp = [[NSDateFormatter alloc] init];
    [oFormatTmp setDateFormat:@"yyyy-MM-dd"];
    [self setOFormat:oFormatTmp];
    [oFormatTmp release];
    
    //
    NSDateFormatter *priceDateFormateTmp = [[NSDateFormatter alloc] init];
    [priceDateFormateTmp setDateFormat:@"MM-dd"];
    [self setPriceDateFormate:priceDateFormateTmp];
    [priceDateFormateTmp release];
    
    
    tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, MAINCONTENTHEIGHT - 44 - 44)];
    tabView.backgroundColor = [UIColor colorWithRed:254.0f / 255 green:254.0f / 255 blue:254.0f / 255 alpha:1.0f];
	tabView.delegate = self;
	tabView.dataSource = self;
	tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tabView];
	[tabView release];
    
	blogView = [Utils addView:@"未找到匹配航班"];
	[self.view addSubview:blogView];
    
    //data
	[self loadListData];
	
	
	
	if ([[SettingManager instanse] defaultFlightListCount] * tapCount<[dataSourceArray count] && [[SettingManager instanse] defaultFlightListCount]<=50) {
		UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
		tabView.tableFooterView = detailView;
		[detailView release];
		
		UIButton *morebutton = [UIButton uniformMoreButtonWithTitle:@"更多航班"
															 Target:self
															 Action:@selector(moreFlight)
															  Frame:CGRectMake(0, 0, 320, 44)];
		[detailView addSubview:morebutton];
	}
    
    // 初始化排序为升序
    _isTimeAscending = NO;
    _isPriceReset = YES;
    
    // =======================================================================
    // 底部视图
    // =======================================================================
    UIView *viewBottomTmp = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - kTrainListBottomViewHeight, SCREEN_WIDTH, kTrainListBottomViewHeight)];
    [viewBottomTmp setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]];
    [self setupViewBottomSubs:viewBottomTmp];
    [self.view addSubview:viewBottomTmp];
    self.viewBottom = viewBottomTmp;
    [viewBottomTmp release];
    
    //    [self priceButtonPressed:0];
    [self timeButtonPressed:0];
    
    // Insurance related.
    [[ElongInsurance shareInstance] getInsuranceData];
    
    
    // 获取低价日历
    [self getLowPriceStart];
    
}


#pragma mark -
#pragma mark FilterDelegate

- (void)selectedIndex:(NSInteger)index {
	[self selectedIndex:index inFilterView:sortSelectTable];
}


- (void)selectedIndex:(NSInteger)index inFilterView:(FilterView *)filterView {
    currentOrder = index;
    switch (index) {
        case 0:
        {
            [self timeButtonPressed:0];
            UMENG_EVENT(UEvent_Flight_List_SortTime)
        }
            break;
        case 1:
        {
            [self timeButtonPressed:1];
            UMENG_EVENT(UEvent_Flight_List_SortTime)
        }
            break;
        case 2:
        {
            [self priceButtonPressed:0];
            UMENG_EVENT(UEvent_Flight_List_SortPrice)
        }
            break;
            
        case 3:
        {
            [self priceButtonPressed:1];
            UMENG_EVENT(UEvent_Flight_List_SortPrice)
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_getPriceListUtil cancel];
    [_getPriceListUtil setDelegate:nil];
    [_cheapCalendarView setDelegate:nil];
    
	[FillerTable release];
    sortSelectTable.delegate = nil;
    [sortSelectTable release];
	[dateLabel release];
	[dataSourceArray release];
	[selectTable release];
	[airPortTable release];
	[tAirCorpArray release];
	[tAirPortArray release];
	[goDic release];
	[currentJSONDate release];
    
    self.viewBottom = nil;
    
    self.filterNav = nil;
    self.filterArray = nil;
    self.selectedIndexPath = nil;
    self.badgeImageView = nil;
    self.cellHeightArray = nil;
    
    SFRelease(_cheapCalendarView);
    SFRelease(_oFormat);
    SFRelease(_priceDateFormate);
    SFRelease(_flightLowPrice);
    SFRelease(_getPriceListUtil);
    
    [super dealloc];
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if ([Utils checkJsonIsError:root]) {
		return;
	}
    
    if (_netType == kFListNetworkLowPrice)
    {
        // 价格日历结束加载
        [_cheapCalendarView calendarEndLoading];
        
        // 解析结果数据
        FlightLowPrice *flightLowPriceTmp = [[FlightLowPrice alloc] init];
        [flightLowPriceTmp parseSearchResult:root];
        
        // 保存
        [self setFlightLowPrice:flightLowPriceTmp];
        [flightLowPriceTmp release];
        
        // 请求结果判断
        NSNumber *isError = [_flightLowPrice isError];
        if (isError !=nil && [isError boolValue] == NO)
        {
            //
            if ([_flightLowPrice arrayPriceList] != nil && ([[_flightLowPrice arrayPriceList] count] > 0))
            {
                // 对结果进行处理
                [self lowPriceDataProcess];
                
            }
        }
        else
        {
            // 显示错误信息
            NSString *errorMessage = [_flightLowPrice errorMessage];
            if (STRINGHASVALUE(errorMessage))
            {
                [Utils alert:errorMessage];
            }
        }
    }
    else
    {
        // 取航站楼
        NSArray *terminals = [root safeObjectForKey:@"FlightTerminals"];
        NSString *departTerminal = @"";
        NSString *arriveTerminal = @"";
        if ([terminals count] == 1) {
            // 非中转
            departTerminal = [[terminals safeObjectAtIndex:0] safeObjectForKey:@"Departure"];
            arriveTerminal = [[terminals safeObjectAtIndex:0] safeObjectForKey:@"Destination"];
        }
        else if ([terminals count] > 1) {
            // 中转
            departTerminal = [[terminals safeObjectAtIndex:0] safeObjectForKey:@"Departure"];
            arriveTerminal = [[terminals lastObject] safeObjectForKey:@"Destination"];
        }
        
        NSArray *segments = [[root safeObjectForKey:@"Flight"] safeObjectForKey:@"Segments"];
        NSMutableArray *sites = [[segments safeObjectAtIndex:0] safeObjectForKey:@"Sites"];		// 舱位信息
        
        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP)
        {
            if ([sites count] > 0) {
                [[FlightData getFDictionary] safeSetObject:sites forKey:KEY_RETURN_REGULATE_1];
                
                [[FlightData getFDictionary] safeSetObject:departTerminal forKey:KEY_TERMINAL_1];
                [[FlightData getFDictionary] safeSetObject:[[terminals lastObject] safeObjectForKey:@"Departure"] forKey:KEY_TRANS_TERMINAL_1];
                [[FlightData getFDictionary] safeSetObject:arriveTerminal forKey:KEY_ARRIVE_TERMINAL_1];
            }
        }
        else {
            if ([sites count] > 0) {
                [[FlightData getFDictionary] safeSetObject:sites forKey:KEY_RETURN_REGULATE_1];
                
                [[FlightData getFDictionary] safeSetObject:departTerminal forKey:KEY_TERMINAL_2];
                [[FlightData getFDictionary] safeSetObject:[[terminals lastObject] safeObjectForKey:@"Departure"] forKey:KEY_TRANS_TERMINAL_2];
                [[FlightData getFDictionary] safeSetObject:arriveTerminal forKey:KEY_ARRIVE_TERMINAL_2];
            }
        }
        
        Flight *flight = [_filterArray safeObjectAtIndex:m_selectRow];   // 纪录api传回的航班参数
        [flight setSiteseatArray:sites];
        
        // Add 2014/02/12
        //    NSLog(@"%@", [[segments safeObjectAtIndex:0] safeObjectForKey:@"FlightItemTaxs"]);
        NSDictionary *flightItemTaxs = [[segments safeObjectAtIndex:0] safeObjectForKey:@"FlightItemTaxs"];
        if ([flightItemTaxs count] > 0) {
            [flight setAdultAirTax:[[flightItemTaxs safeObjectForKey:@"AdultAirTax"] doubleValue]];
            [flight setAdultOilTax:[[flightItemTaxs safeObjectForKey:@"AdultOilTax"] doubleValue]];
            [flight setChildAirTax:[[flightItemTaxs safeObjectForKey:@"ChildAirTax"] doubleValue]];
            [flight setChildOilTax:[[flightItemTaxs safeObjectForKey:@"ChildOilTax"] doubleValue]];
        }
        
        // End
        if (flight.isTransited) {
            NSArray *transRules = [[[[root safeObjectForKey:@"Flight"] safeObjectForKey:@"Segments"] safeObjectAtIndex:1] safeObjectForKey:@"Sites"];		// 中转退改签
            if ([transRules count] > 0) {
                if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
                    [[FlightData getFDictionary] safeSetObject:transRules forKey:KEY_RETURN_REGULATE_t];
                } else {
                    [[FlightData getFDictionary] safeSetObject:transRules forKey:KEY_RETURN_REGULATE_t];
                }
            }
        }
        
        
        FlightDetail *controller = [[FlightDetail alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@",[flight getAirCorpName],[flight getFlightNumber]]
                                                                 style:_NavOnlyBackBtnStyle_];
        [controller setIsOneHour:_isSelectOneHour];
        [self.navigationController pushViewController:controller animated:YES];
        if (flight.stopNumber > 0) {
            controller.parentvcselectedindex = m_selectRow;
            [controller performSelector:@selector(requestStopInfo) withObject:nil afterDelay:0.1];
        }
        
        [controller release];
    }
}

#pragma mark - 低价日历选择代理回调

- (void) selectPriceDate:(NSInteger)selectIndex
{
    // 保存选择的index
    [self setLowPriceSelectIndex:selectIndex];
    
    // 取出选择的数据
    if (_flightLowPrice != nil)
    {
        NSArray *arrayPriceList = [_flightLowPrice arrayPriceList];
        if (ARRAYHASVALUE(arrayPriceList))
        {
            // 选择的价格日历
            LowPriceItem *priceItem = [arrayPriceList safeObjectAtIndex:selectIndex];
            if (priceItem != nil)
            {
                // 日期
                NSString *flightDateString = [priceItem flightDate];
                if (STRINGHASVALUE(flightDateString))
                {
                    NSDate *flightDate=[TimeUtils parseJsonDate:flightDateString];
                    
                    // 日期为周几
                    NSString *selectDate = [_oFormat stringFromDate:flightDate];
                    
                    // 请求数据
                    JFlightSearch *jFlightSearch = [FlightPostManager flightSearcher];
                    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_RETURN_TRIP)
                    {
                        [[FlightData getFDictionary] safeSetObject:selectDate forKey:KEY_RETURN_DATE];
                        [jFlightSearch setDepartCityName:[[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY] isClearData:NO];
                        [jFlightSearch setArrivalCityName:[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY] isClearData:NO];
                    }
                    else
                    {
                        [[FlightData getFDictionary] safeSetObject:selectDate forKey:KEY_DEPART_DATE];
                        [jFlightSearch setDepartCityName:[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY] isClearData:NO];
                        [jFlightSearch setArrivalCityName:[[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY] isClearData:NO];
                        // 去程重置产品类型
                        [jFlightSearch setProductType:[NSNumber numberWithInt:0] isClearData:NO];
                        [jFlightSearch setIsSearch51Book:[NSNumber numberWithBool:YES] isClearData:NO];
                    }
                    
                    // 单程搜索1小时飞人
                    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP)
                    {
                        [jFlightSearch setIsSearchOneHour:[NSNumber numberWithBool:YES] isClearData:NO];
                    }
                    
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[FlightSearch class]]) {
                            FlightSearch *fs = (FlightSearch *)controller;
                            [jFlightSearch setDepartDate:selectDate isClearData:NO];
                            [Utils request:FLIGHT_SERACH req:[jFlightSearch requesString:YES] delegate:fs];
                            break;
                        }
                    }
                }
            }
        }
    }
}


#pragma mark -
#pragma mark Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([[SettingManager instanse] defaultFlightListCount] * tapCount<[_filterArray count] && [[SettingManager instanse] defaultFlightListCount]<=50) {
        
		tableView.tableFooterView.hidden = NO;
		return [[SettingManager instanse] defaultFlightListCount] * tapCount;
	} else {
		tableView.tableFooterView.hidden = YES;
		return [_filterArray count];
	}
    
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Flight *flight = [_filterArray safeObjectAtIndex:indexPath.row];
    if (flight.isTransited) {
        if (displayTransFlight) {
            _cellheight = 149.0f;
            return 149.0f;
        }
        else {
            return 0.0f;
        }
    }
    else {
        return [[_cellHeightArray safeObjectAtIndex:indexPath.row] floatValue];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FlightListCellKey = @"FlightListCellKey";
    FlightListCell *cell = (FlightListCell *)[tableView dequeueReusableCellWithIdentifier:FlightListCellKey];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FlightListCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[FlightListCell class]]) {
                cell = (FlightListCell *)oneObject;
                
                cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _cellheight)] autorelease];
                cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
                cell.clipsToBounds = YES;
                
			}
		}
    }
    
    
    UIImageView *lineView = (UIImageView *)[cell viewWithTag:kCellLineViewTag];
    [lineView removeFromSuperview];
    lineView = nil;
    lineView = [UIImageView graySeparatorWithFrame:CGRectMake(0.0f, [[_cellHeightArray safeObjectAtIndex:indexPath.row] floatValue] - SCREEN_SCALE, 320.0f, SCREEN_SCALE)];
    lineView.tag = kCellLineViewTag;
    [cell addSubview:lineView];
    
    
	//set cell
    NSUInteger row = [indexPath row];
	if ([_filterArray count] > 0) {
		Flight *flight = [_filterArray safeObjectAtIndex:row];
        if (flight.isTransited) {
            // 中转航班的显示
            cell.stateLabel.text = flight.transInfo;
            cell.tAirFlightType.text = [NSString stringWithFormat:@"机型%@", flight.tAirFlightType];
            cell.tFlightNumLabel.text = flight.tFlightNum;
            cell.tAirCorpLabel.text = flight.tAirCorp;
            cell.tArrivalAirPortLabel.text = flight.tArrivalAirPort;
            cell.tDepartAirPortLabel.text = flight.tDepartAirPort;
            cell.tArrivalTimeLabel.text = [TimeUtils displayDateWithJsonDate:flight.tArrivalTime formatter:@"HH:mm"];
            cell.tDepartTimeLabel.text = [TimeUtils displayDateWithJsonDate:flight.tDepartTime formatter:@"HH:mm"];
            
            [cell.tFlightIcon setImage:[UIImage imageNamed:[Utils getAirCorpPicName:flight.tAirCorp]]];
            
            [cell setTransitModel:YES];
        }
        else if (flight.stopNumber > 0) {
            // 经停航班
            cell.stateLabel.text = @"经停";
            [cell setTransitModel:NO];
            
        }
        else {
            // 正常航班
            cell.stateLabel.text = @"";
            [cell setTransitModel:NO];
        }
        
		cell.priceLabel.text = [[[NSString alloc] initWithFormat:@"%i", [[flight getPrice] intValue]] autorelease];
        cell.priceSign.textColor = [UIColor colorWithRed:250.0f / 255 green:50.0f / 255 blue:26.0f / 255 alpha:1.0f];
        cell.priceLabel.textColor = [UIColor colorWithRed:250.0f / 255 green:50.0f / 255 blue:26.0f / 255 alpha:1.0f];
        
        CGSize priceSize = [cell.priceLabel.text sizeWithFont:[UIFont fontWithName:@"Heiti SC" size:18.0f]];
        
        cell.priceLabel.frame = CGRectMake(CGRectGetMinX(cell.qiLabel.frame) - priceSize.width, CGRectGetMinY(cell.qiLabel.frame), priceSize.width, priceSize.height);
        cell.rmbLabel.frame = CGRectMake(CGRectGetMinX(cell.priceLabel.frame) - CGRectGetWidth(cell.rmbLabel.frame), CGRectGetMinY(cell.qiLabel.frame), CGRectGetWidth(cell.rmbLabel.frame), CGRectGetHeight(cell.rmbLabel.frame));
        
		NSString* ticket = [flight getTicketnum];
		if ([ticket isEqualToString:@"A"]) {
			cell.ticketlessLabel.hidden = YES;
			cell.ticketpieceLabel.hidden = YES;
			cell.ticketmoreLabel.hidden = NO;
            //			cell.ticketmoreLabel.text = @"充足";
            //            cell.ticketmoreLabel.textColor = [UIColor greenColor];
            cell.ticketmoreLabel.text = @"";
		}
		else if ([ticket isEqualToString:@"0"]) {
			cell.ticketlessLabel.hidden = YES;
			cell.ticketpieceLabel.hidden = YES;
			cell.ticketmoreLabel.hidden = NO;
			cell.ticketmoreLabel.text = @"已售完";
            cell.priceLabel.textColor = [UIColor lightGrayColor];
		}
		else if ([ticket integerValue] < 6){
			cell.ticketlessLabel.hidden = NO;
			cell.ticketpieceLabel.hidden = YES;
			cell.ticketmoreLabel.hidden = YES;
            cell.ticketlessLabel.textColor = [UIColor colorWithRed:197.0f / 255 green:49.0f / 255 blue:28.0f / 255 alpha:1.0f];
			cell.ticketlessLabel.text = [NSString stringWithFormat:@"仅剩%d张", [ticket integerValue]];
		}
        
        // 剩余票量
        NSNumber *ticketCount = [flight ticketCount];
        if (ticketCount != nil)
        {
            if ([ticketCount boolValue] == YES)
            {
                cell.backgroundColor = RGBACOLOR(254, 254, 254, 1.0);
                cell.ticketmoreLabel.text = @"";
                cell.priceLabel.textColor = RGBACOLOR(249, 76, 21, 1.0);
                cell.priceLabel.highlightedTextColor = RGBACOLOR(249, 76, 21, 1.0);
            }
            else    // 已售完航线
            {
                cell.backgroundColor = RGBACOLOR(237, 237, 237, 1.0);
                cell.ticketmoreLabel.text = @"已售完";
                cell.priceLabel.textColor = [UIColor lightGrayColor];
                cell.priceLabel.highlightedTextColor = [UIColor lightGrayColor];
            }
        }
        
        if (!OBJECTISNULL(flight.defaultCoupon)) {
            NSInteger couponValue = [flight.defaultCoupon intValue];
            
            if (-1 == couponValue) {
                // 没有返现的情况
                cell.couponIcon.hidden = YES;
                cell.couponLabel.text = @"";
            }
            else if (0 == couponValue) {
                // 最低价的仓位不返现的情况
                cell.couponIcon.hidden = YES;
                cell.couponLabel.text = @"";
            }
            else {
                // 显示最低价仓位的返现金额
                cell.couponIcon.hidden = NO;
                cell.couponLabel.textColor = [UIColor colorWithRed:250.0f / 255 green:50.0f / 255 blue:26.0f / 255 alpha:1.0f];
                cell.couponLabel.text = [NSString stringWithFormat:@"¥ %d", couponValue];
            }
        }
        else {
            cell.couponLabel.text = @"";
        }
		
		double dd = [[flight getDiscount] doubleValue];
		cell.discountLabel.textColor = [UIColor darkGrayColor];
		if (dd == 1) {
			cell.discountLabel.text = [[[NSString alloc] initWithString:@"全 价"] autorelease];
		} else if (dd == 0) {
			cell.discountLabel.text = [[[NSString alloc] initWithString:@"特 价"] autorelease];
		} else {
			dd *= 10;
			cell.discountLabel.text = [[[NSString alloc] initWithFormat:@"%.1f折", dd] autorelease];
		}
        
        NSString *airCorpName = [flight getAirCorpName];
        CGSize airCorpSize = [airCorpName sizeWithFont:cell.airCorpLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 20.0f)]; //获取字符串的实际大小
        cell.airCorpLabel.frame = CGRectMake(30.0f, 50.0f, airCorpSize.width, 20);
		cell.airCorpLabel.text = [flight getAirCorpName];
        cell.flightNumLabel.frame = CGRectMake(30.0f + airCorpSize.width, 50.0f, 56.0f, 20.0f);
		cell.flightNumLabel.text = [flight getFlightNumber];
		cell.departAirPortLabel.text = [flight getDepartAirport];
		cell.arrivalAirPortLabel.text = [flight getArriveAirport];
		cell.airFlightType.text =[NSString stringWithFormat:@"机型%@",[flight getPlaneType]];
        
        [cell.FlightIcon setImage:[UIImage imageNamed:[Utils getAirCorpPicName:[flight getAirCorpName]]]];
        
		cell.departTimeLabel.text = [TimeUtils displayDateWithJsonDate:[flight getDepartTime] formatter:@"HH:mm"];
		
		cell.arrivalTimeLabel.text = [TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"HH:mm"];
        
        if (flight.isContainLegislation)
        {
            // 如果包含立减机票时，展示特价icon
            if (flight.isLegislationPirce)
            {
                // 如果是最便宜的机票是立减价，显示划价
                [cell setDiscountModel:YES WithOriginPrice:flight.originalPrice];
            }
            else
            {
                [cell setDiscountModel:YES WithOriginPrice:nil];
            }
            
        }
        else
        {
            // 非立减的机票
            [cell setDiscountModel:NO WithOriginPrice:nil];
        }
	}
    
    return cell;
}


//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedIndexPath = indexPath;
	Flight *flight = [_filterArray safeObjectAtIndex:[indexPath row]];
    
    // 是否选择一小时飞人
    NSNumber *isSelectOneHourObj = [flight isOneHour];
    if (isSelectOneHourObj != nil)
    {
        _isSelectOneHour = [isSelectOneHourObj boolValue];
    }
    
    // 剩余票量
    NSNumber *ticketCount = [flight ticketCount];
    if (ticketCount != nil)
    {
        if ([ticketCount boolValue])
        {
            
#if FLIGHT_NOT_NETWORKED
            FlightDetail *controller = [[FlightDetail alloc] initWithTopImagePath:nil
                                                                         andTitle:[NSString stringWithFormat:@"%@ %@",[flight getAirCorpName],[flight getFlightNumber]]
                                                                            style:_NavOnlyBackBtnStyle_];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
#else
            
            m_selectRow = [indexPath row];
            if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
                for (int i=0; i<[[FlightData getFArrayGo] count]; i++) {
                    Flight *aFlight = [[FlightData getFArrayGo] safeObjectAtIndex:i];
                    if ([flight isEqual:aFlight]) {
                        [[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:i] forKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1];
                        break;
                    }
                }
                //退改签规定
                Flight *flight = [_filterArray safeObjectAtIndex:m_selectRow];
                
                JFlightRestriction *jFlightRestriction = [FlightPostManager flightRestriction];
                NSArray *flightNumbers;
                if (flight.isTransited) {
                    flightNumbers = [NSArray arrayWithObjects:[flight getFlightNumber], flight.tFlightNum, nil];
                }
                else {
                    flightNumbers = [NSArray arrayWithObject:[flight getFlightNumber]];
                }
                
                [jFlightRestriction setDepartFlightNumber:flightNumbers];
                
                JFlightSearch *jFlightSearch = [FlightPostManager flightSearcher];
                if (!goDic) {
                    goDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [jFlightSearch getDepartCityName], @"DepartCityName",
                             [jFlightSearch getArrivalCityName], @"ArrivalCityName",
                             [jFlightSearch getDepartDate], KEY_DEPART_DATE,
                             [jFlightSearch getClassType], @"ClassType",
                             NUMBER(0), @"DepartTimeSpan", nil];
                }
                else {
                    [jFlightRestriction setDepartCity:[goDic safeObjectForKey:@"DepartCityName"]];
                    [jFlightRestriction setArrivalCity:[goDic safeObjectForKey:@"ArrivalCityName"]];
                    [jFlightRestriction setDepartDate:[jFlightSearch getDepartDate]];
                    [jFlightRestriction setClassType:[goDic safeObjectForKey:@"ClassType"]];
                }
                
                // 设置是否搜索51
                [jFlightRestriction setIsSearch51Book:[NSNumber numberWithBool:YES]];
                
                // 是否搜索1小时飞人
                [jFlightRestriction setIsSearchOneHour:[NSNumber numberWithBool:_isSelectOneHour]];
                
                // 搜索ticketchannal
                [jFlightRestriction setProductType:[NSNumber numberWithInt:0] isClearData:NO];
                
                [Utils request:FLIGHT_SERACH req:[jFlightRestriction requesString:YES] delegate:self];
                
            } else {
                for (int i=0; i<[[FlightData getFArrayReturn] count]; i++) {
                    Flight *aFlight = [[FlightData getFArrayReturn] safeObjectAtIndex:i];
                    if ([flight isEqual:aFlight]) {
                        [[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:i] forKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2];
                        break;
                    }
                }
                //退改签规定
                NSArray *flightNumbers;
                if (flight.isTransited) {
                    flightNumbers = [NSArray arrayWithObjects:[flight getFlightNumber], flight.tFlightNum, nil];
                }
                else {
                    flightNumbers = [NSArray arrayWithObject:[flight getFlightNumber]];
                }
                
                JFlightRestriction *jFlightRestriction = [FlightPostManager flightRestriction];
                [jFlightRestriction setReturnFlightNumber:flightNumbers];
                
                
                JFlightSearch *jFlightSearch = [FlightPostManager flightSearcher];
                // 设置是否搜索51
                NSNumber *isSearch51Book = [jFlightSearch getIsSearch51Book];
                if (isSearch51Book != nil)
                {
                    [jFlightRestriction setIsSearch51Book:isSearch51Book];
                    
                }
                
                // 搜索列表时的ticketchannal
                NSNumber *ticketChannal = [jFlightSearch getProduceType];
                if (ticketChannal != nil)  // 产品类型
                {
                    [jFlightRestriction setProductType:ticketChannal isClearData:NO];
                }
                
                [Utils request:FLIGHT_SERACH req:[jFlightRestriction requesString:YES] delegate:self];
            }
#endif
            
            _netType = kFListNetworkDetail;
            
            UMENG_EVENT(UEvent_Flight_List_DetailEnter)
        }
    }
	
}


- (void)viewDidAppear:(BOOL)animated
{
    UITableViewCell *cell = [tabView cellForRowAtIndexPath:_selectedIndexPath];
    if (cell.isSelected) {
        [cell setSelected:NO animated:YES];
    }
}


#pragma mark -
#pragma mark UIScroll Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height &&
		tabView.tableFooterView) {
		// 滚到底向上拉，并且有更多按钮时，申请更多数据
		[self moreFlight];
	}
}

// =======================================================================
#pragma mark - 筛选回调
// =======================================================================
- (void) searchFilterController:(SearchFilterController *)filter didFinishedWithInfo:(NSDictionary *)info
{
    if (info != nil)
    {
        [_filterArray removeAllObjects];
        
        if (dataSourceArray && [dataSourceArray count] > 0) {
            NSArray *airlineArray = [info safeObjectForKey:[NSString stringWithFormat:@"%d", FilterAirline]];
            if ([airlineArray count] == 0 || [airlineArray count] == [[self getAirlinesArray:dataSourceArray] count]) {
                _filterArray = dataSourceArray;
            }
            else {
                for (NSInteger index = 0; index < [dataSourceArray count]; index++) {
                    Flight *flight = [dataSourceArray safeObjectAtIndex:index];
                    if ([airlineArray containsObject:[flight getAirCorpName]]) {
                        [_filterArray addObject:flight];
                    }
                }
            }
            
            NSArray *departureAirportArray = [info safeObjectForKey:[NSString stringWithFormat:@"%d", FilterDepartureAirport]];
//            if ([departureAirportArray count] != 0 && [departureAirportArray count] != [[self getDepartArray:dataSourceArray] count])
            if ([departureAirportArray count] != 0)
            {
                NSMutableArray *tempMutableArray = [NSMutableArray array];
                for (NSInteger index = 0; index < [_filterArray count]; index++) {
                    Flight *flight = [_filterArray safeObjectAtIndex:index];
                    if (![departureAirportArray containsObject:[flight getDepartAirport]]) {
                        [tempMutableArray addObject:flight];
                    }
                }
                [_filterArray removeObjectsInArray:tempMutableArray];
            }
            
            NSArray *arrivalAirportArray = [info safeObjectForKey:[NSString stringWithFormat:@"%d", FilterArrivalAirport]];
            if ([arrivalAirportArray count] != 0 && [arrivalAirportArray count] != [[self getArrivalArray:dataSourceArray] count]) {
                NSMutableArray *tempMutableArray = [NSMutableArray array];
                for (NSInteger index = 0; index < [_filterArray count]; index++) {
                    Flight *flight = [_filterArray safeObjectAtIndex:index];
                    if (![arrivalAirportArray containsObject:[flight getArriveAirport]]) {
                        [tempMutableArray addObject:flight];
                    }
                }
                [_filterArray removeObjectsInArray:tempMutableArray];
            }
        }
        
        if ([_filterArray count] == [dataSourceArray count]) {
            self.badgeImageView.hidden = YES;
            UMENG_EVENT(UEvent_Flight_List_FilterReset)
        }
        else {
            self.badgeImageView.hidden = NO;
            UMENG_EVENT(UEvent_Flight_List_FilterAction)
        }
        
        // 不刷新筛选项
        _filterReset = NO;
        
        //        [tabView reloadData];
        [self reloadDataByConditions];
    }
}

//
- (void)searchFilterControllerDidCancel:(SearchFilterController *)filter
{
    
}

@end
