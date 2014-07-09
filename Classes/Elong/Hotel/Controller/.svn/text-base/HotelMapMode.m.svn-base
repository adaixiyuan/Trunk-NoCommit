//
//  HotelMapMode.m
//  ElongClient
//
//  Created by bin xing on 11-1-20.
//  Copyright 2011 DP. All rights reserved.
//

#define MAP_ZOOM_LEVEL			0.05
#define HOTELLIST		0
#define HOTELDETAIL		1
#define MOREHOTEL		2
#define PRICELABELTAG	2222
#define STARLABELTAG	3333
#define TIPBARTAG		2223
#define LONGCUITAG	    4444
#define LASTMINITETAG	5555
#define HOTELINDEXTAG	6666
#define MAPPRICEIMAGE   7777
#define UnSignedLabelTAG   8888

#import "HotelMapMode.h"
#import "HotelConditionRequest.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "PinAnnotation.h"
#import "SearchBarView.h"
#import "CountlyEventClick.h"
#import "HotelPromotionInfoRequest.h"
#import "CountlyEventShow.h"


@implementation HotelMapMode
@synthesize hotelCount;
@synthesize mapView;
@synthesize isResearch;
@synthesize rootController;
@synthesize posiArray;
@synthesize savedSearchTerm;
@synthesize searchDC;
@synthesize moreHotelUtil;
@synthesize locationUtil;
@synthesize posiUtil;
@synthesize requestBlock;


- (id)init {
	if (self=[super init]) {
		mapAnnotations = [[NSMutableArray alloc] init];
		
		requestBlock = NO;
		selfIsDealloc = NO;
	}
	
	return self;
}



- (void)addAnnotationFromDictionary:(NSDictionary *)dic {
	int index = [mapAnnotations count];
	double r = [[dic safeObjectForKey:RespHL__Latitude_D] doubleValue];
	double l = [[dic safeObjectForKey:RespHL__Longitude_D] doubleValue];
    
    // 需要纠偏
    if([PublicMethods needSwitchWgs84ToGCJ_02]){
        [PublicMethods wgs84ToGCJ_02WithLatitude:&r longitude:&l];
    }
	
	NSString *titlestring = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:RespHL__HotelName_S]];
	NSString *hoteladress = [NSString stringWithFormat:_string(@"s_map_address"),[dic safeObjectForKey:RespHL__Address_S]];
	
	PriceAnnotation *priceAnnotation	= [[PriceAnnotation alloc] init];
	priceAnnotation.title				= titlestring;
	priceAnnotation.subtitle			= hoteladress;
	//priceAnnotation.hotelSpecialType    = Default;
    
    //是否未签约
    priceAnnotation.isUnsigned=NO;
    if ([dic safeObjectForKey:@"IsUnsigned"]&&[[dic safeObjectForKey:@"IsUnsigned"] boolValue])
    {
        priceAnnotation.isUnsigned=YES;
    }
    
	// 酒店星级
	int level = [[dic safeObjectForKey:RespHL__StarCode_I] intValue];
	
    NSString *starStr = [PublicMethods getStar:level];
    
	priceAnnotation.priceStr	= [NSString stringWithFormat:@"¥%.f",[[dic safeObjectForKey:RespHL__LowestPrice_D] doubleValue]];
    priceAnnotation.truePrice=[[dic safeObjectForKey:RespHL__LowestPrice_D] doubleValue];
	priceAnnotation.starLevel	= starStr;
	priceAnnotation.index		= index + 1;
	priceAnnotation.hotelid		= [dic safeObjectForKey:RespHL__HotelId_S];
	[priceAnnotation setCoordinateStruct:r l:l];
	
    if([[dic safeObjectForKey:RespHL_HotelSpecialType] intValue]==2)
        priceAnnotation.hotelSpecialType=Longcui;
    
    if([dic safeObjectForKey:RespHL_LastMinutesDesp]!=[NSNull null]&&![[dic safeObjectForKey:RespHL_LastMinutesDesp] isEqualToString:@""]){
        if(priceAnnotation.hotelSpecialType==Longcui)
            priceAnnotation.hotelSpecialType=LongCuiAndLM;
        else
            priceAnnotation.hotelSpecialType=LastMinute;
    }
    
    
    // 今日特价
    // 非特价搜索时
    NSString *discountStr = [dic safeObjectForKey:@"LastMinutesDesp"];
    BOOL isLM = NO;
    if ([discountStr isKindOfClass:[NSString class]] && discountStr.length > 0) {
        isLM = YES;
    }
    priceAnnotation.isLM = isLM;

    
    
	[mapAnnotations addObject:priceAnnotation];
	[priceAnnotation release];
}


- (void)addAnnotationsFromArray:(NSArray *)array {
	NSArray *oriArray = [NSArray arrayWithArray:mapAnnotations];
	for (NSDictionary *hotel in array) {
		[self addAnnotationFromDictionary:hotel];
	}
	
	NSMutableArray *nowArray = [NSMutableArray arrayWithArray:mapAnnotations];
	[nowArray removeObjectsInArray:oriArray];
	[mapView addAnnotations:nowArray];
}


- (void)addMapLoadingView {
	if (!smallLoading) {
		smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake(135, (self.view.frame.size.height-50) / 2, 50, 50)];
		[self.view addSubview:smallLoading];
	}
	
	[smallLoading startLoading];
}


- (void)removeMapLoadingView {
	[smallLoading stopLoading];
}

// 获取指定坐标点的名称
- (void)getReverseGeocodingWithCoordinate:(CLLocationCoordinate2D)coordinate {
	if (searchGeocoder) {
		[searchGeocoder cancel];
		searchGeocoder.delegate = nil;
        [searchGeocoder release];
		searchGeocoder = nil;
	}
	searchGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
	searchGeocoder.delegate = self;
	[searchGeocoder start];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	geoTime  = 5;
	geoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(geoTimeDown) userInfo:nil repeats:YES];
}


- (void)stopGeocoding {
	// 停止地理位置反编码
	[geoTimer invalidate];
	geoTimer = nil;
	
	if (searchGeocoder) {
		[searchGeocoder cancel];
		searchGeocoder.delegate = nil;
		[searchGeocoder release];
        searchGeocoder = nil;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
}


- (void)geoTimeDown {
	if (geoTime > 0) {
		geoTime --;
	}
	else {
		// 到时自动停止请求
		[self stopGeocoding];
	}
}


// 重新设置大头针后执行的动作
- (void)researchHotelInCoordinate:(CLLocationCoordinate2D)coordinate {
	// 改变地图中心为大头针所在位置
	//[mapView setCenterCoordinate:coordinate animated:YES];
	[self getReverseGeocodingWithCoordinate:coordinate];
	
    // 重置筛选条件
    if ([HotelSearch hotelSearch]) {
        [[HotelSearch hotelSearch] resetSearchCondition];
    }
   
    
	JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
	[hotelsearcher resetPage];
	[hotelsearcher setCurrentPos:searchRadius Longitude:coordinate.longitude Latitude:coordinate.latitude];
	linktype = HOTELLIST;
	
    if (USENEWNET) {
        if (locationUtil) {
            [locationUtil cancel];
            SFRelease(locationUtil);
        }
        
        locationUtil = [[HttpUtil alloc] init];
        [locationUtil connectWithURLString:HOTELSEARCH
                                   Content:[hotelsearcher requesString:YES]
                                 StartLoading:NO
                                   EndLoading:NO
                                     Delegate:self];
    }
	
	[self addMapLoadingView];
}


- (void)addMapAnnotations:(NSArray *)annotations {
	for (NSDictionary *hotel in annotations) {
		[self addAnnotationFromDictionary:hotel];
	}
	
    [mapView addAnnotations:mapAnnotations];
	
	if ([mapAnnotations count] <= 0 && !pinAnnotation) {
		// 没有数据不显示地图
		mapView.hidden = YES;
		noDataTipLabel.hidden = NO;
	}
	else {
		mapView.hidden = NO;
		noDataTipLabel.hidden = YES;
	}
	
	if (hotelCount == [HotelSearch hotelCount] ||
		rootController.isMaximum) {
		// 最大数量时禁止点击更多搜索
		[rootController forbidSearchMoreHotel];
	}
	else {
		[rootController restoreSearchMoreHotel];
	}
    
    //校正定位视野
    [self centerMap];
}


// 重设地图上的价格标签
- (void)resetAnnotations {
	[mapView removeAnnotations:mapAnnotations];
	[mapAnnotations removeAllObjects];
	
	[self addMapAnnotations:[HotelSearch hotels]];
}


// 设置插杆点
- (void)addPinWithCoordinate:(CLLocationCoordinate2D)coordinate {
	// 当目的地发生变化时，删除旧得数据，重新搜索新的酒店
	if (pinAnnotation) {
		[mapView removeAnnotation:pinAnnotation];
	}
	
	PinAnnotation *annotation = [[PinAnnotation alloc] init];
	[annotation setCoordinate:coordinate];
	pinAnnotation = annotation;
	[mapView addAnnotation:pinAnnotation];
	[annotation release];
}


- (void)addmark {
	[self resetAnnotations];
	
	if (!pinAnnotation) {
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = 0.;
		coordinate.longitude = 0.;
		
		if ([HotelSearch isPositioning]) {
			// 周边查询时，以用户的坐标作为默认的插杆点的坐标
            JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
            coordinate.latitude = [hotelsearcher getLatitude];
            coordinate.longitude = [hotelsearcher getLongitude];
			//coordinate = [[PositioningManager shared] myCoordinate];
		}
		else {
			// 普通查询时
			double lng = [[[HotelConditionRequest shared] keywordFilter] lng];
			double lat = [[[HotelConditionRequest shared] keywordFilter] lat];
            
			if (lng != 0 && lat != 0) {
				// 有具体位置时，用其作为插杆点
				coordinate.latitude	 = lat;
				coordinate.longitude = lng;
			}
			else if ([mapAnnotations count] > 0) {
				// 以第一个价格标签的坐标作为默认的插杆点的坐标
				PriceAnnotation *firstAnnotation = [mapAnnotations safeObjectAtIndex:0];
				coordinate = firstAnnotation.coordinate;
			}
		}
		
		[self addPinWithCoordinate:coordinate];
		[self getReverseGeocodingWithCoordinate:coordinate];
	}
}


- (void)viewDidLoad {
    if (UMENG) {
        // 酒店列表切换地图
        [MobClick event:Event_HotelList_Map];
    }
    
    //countly 页面展示事件
    CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
    countlyEventShow.page = COUNTLY_PAGE_HOTELMAPPAGE;
    countlyEventShow.ch = COUNTLY_CH_HOTEL;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];
    
	JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
	searchRadius = [hotelsearcher getCurrentPos];
	if (0 == searchRadius) {
		searchRadius = 3000;
	}
	
	canLocationSearch = NO;
	
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-20-44-45)];
	contentView.backgroundColor=[UIColor clearColor];
	self.view=contentView;
	[contentView release];
	
	noDataTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160 * COEFFICIENT_Y, 280, 40)];
	noDataTipLabel.backgroundColor	= [UIColor clearColor];
	noDataTipLabel.text				= @"未找到酒店位置信息";
	noDataTipLabel.textAlignment	= UITextAlignmentCenter;
    noDataTipLabel.textColor        = RGBACOLOR(93, 93, 93, 1);
	noDataTipLabel.font				= [UIFont boldSystemFontOfSize:16];
	noDataTipLabel.hidden			= YES;
	[self.view addSubview:noDataTipLabel];
	
	self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 44, 320, SCREEN_HEIGHT- 20 - 44 - 45 - 44)] autorelease];
    [self.view addSubview:mapView];
    
    
	if (IOSVersion_4) {
		// 加入长按手势
		UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setPin:)];
		[mapView addGestureRecognizer:recognizer];
		[recognizer release];
		
		// 加入长按提示栏
		UILabel *tipLabel			= [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 320, 20)];
		tipLabel.backgroundColor	= [UIColor clearColor];
		tipLabel.text				= @"长按地图设定搜索地点";
		tipLabel.textColor			= [UIColor whiteColor];
		tipLabel.textAlignment		= UITextAlignmentCenter;
		tipLabel.font				= [UIFont systemFontOfSize:12];
        
        UIView *tipBar = [[UIView alloc] initWithFrame:CGRectMake(0,  44 - 8, 320, 40)];
        tipBar.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        [tipBar addSubview:tipLabel];
        tipBar.tag = TIPBARTAG;
        [tipLabel release];
        [self.view addSubview:tipBar];
        [tipBar release];
	}
	
	float zoomLevel = MAP_ZOOM_LEVEL;
	
	MKCoordinateRegion region = MKCoordinateRegionMake([[PositioningManager shared] myCoordinate],MKCoordinateSpanMake(zoomLevel,zoomLevel));
	[mapView setRegion:[mapView regionThatFits:region] animated:NO];
	mapView.delegate=self;
	mapView.showsUserLocation = YES;
	
	if ([HotelSearch isPositioning]) {
		if (NSClassFromString(@"MKCircle")) {
            CLLocationCoordinate2D coordinate;
            JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
            coordinate.latitude = [hotelsearcher getLatitude];
            coordinate.longitude = [hotelsearcher getLongitude];
            
			[mapView addOverlay:[MKCircle circleWithCenterCoordinate:coordinate radius:searchRadius]];
			
		}
	}
	
	pinAnnotation = nil;
	[self addmark];
    hotelCount = [[HotelSearch hotels] count];
    
	
	
	
	[self selectPin];
    
    
    // 搜索框
    searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	//searchBar.tintColor =  [UIColor colorWithRed:181.0/255.0 green:180.0/255.0 blue:178.0/255.0 alpha:1];
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchBar.placeholder = @"地址、地标、关键词";
	searchBar.barStyle =  UIBarStyleDefault;
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
	[searchBar release];
        
    // 赋值，把列表中的关键词带入地图
    if (self.rootController.keyword) {
        searchBar.text = [NSString stringWithFormat:@"%@",self.rootController.keyword];
    }
    
	
	//self.parentViewController
	searchDC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self] ;
	searchDC.searchResultsDelegate = self;
	searchDC.searchResultsDataSource = self;
    searchDC.delegate = self;
    
    [searchDC.searchResultsTableView setBackgroundColor:[UIColor whiteColor]];
    [searchDC.searchResultsTableView setRowHeight:60];
    [searchDC.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    if (MONKEY_SWITCH)
    {
        // 开启monkey时，地图屏蔽版权点击区域
        UIView *mapCover = [[UIView alloc] initWithFrame:CGRectMake(0, mapView.bounds.size.height - 30, 50, 30)];
        mapCover.backgroundColor = [UIColor clearColor];
        [mapView addSubview:mapCover];
        [mapCover release];
    }
}

- (void) setKeyword{
    
    
    
    // 赋值，把列表中的关键词带入地图
    if (self.rootController.keyword) {
        //searchDC.searchResultsTableView.hidden = YES;
        SFRelease(searchDC);
        [searchBar removeFromSuperview];
        searchBar = nil;
        
        // 搜索框
        searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchBar.placeholder = @"地址、地标、关键词";
        searchBar.barStyle =  UIBarStyleDefault;
        searchBar.delegate = self;
        [self.view addSubview:searchBar];
        [searchBar release];

        searchBar.text = [NSString stringWithFormat:@"%@",self.rootController.keyword];
        
        
        searchDC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self] ;
        searchDC.searchResultsDelegate = self;
        searchDC.searchResultsDataSource = self;
        searchDC.delegate = self;
        
        [searchDC.searchResultsTableView setBackgroundColor:[UIColor whiteColor]];
        [searchDC.searchResultsTableView setRowHeight:60];
        [searchDC.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }else{
        searchBar.text = nil;
    }
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    if (STRINGHASVALUE(searchString)) {
		self.savedSearchTerm = searchString;
        [self searchPosiWithLoading:NO];
	}else{
        if (posiUtil) {
            [posiUtil cancel];
            [posiUtil release],posiUtil = nil;
        }
        
        
//        [loadingView stopAnimating];
        // 网络加载符
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        self.posiArray = nil;
        [searchDC.searchResultsTableView reloadData];
    }
    
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    //controller.searchResultsTableView.hidden = NO;
}



- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
//    self.posiArray = nil;
	NSString *searchStr = controller.searchBar.text;
	if (STRINGHASVALUE(searchStr)) {
		controller.searchBar.text = searchStr;				// 启动搜索表格
	}
    rootController.moreBtn.hidden = YES;
}

//
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    controller.searchBar.showsCancelButton = YES;
    
    // Cancel按钮换成中文显示
    UISearchBar *searchBarInside = controller.searchBar;
    UIView *viewTop = IOSVersion_7 ? searchBarInside.subviews[0] : searchBarInside;
    NSString *classString = IOSVersion_7 ? @"UINavigationButton" : @"UIButton";
    
    for (UIView *subView in viewTop.subviews) {
        if ([subView isKindOfClass:NSClassFromString(classString)]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}


- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    if (posiUtil) {
        [posiUtil cancel];
        [posiUtil release],posiUtil = nil;
    }
  
    
//    [loadingView stopAnimating];
    // 网络加载符
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    rootController.moreBtn.hidden = NO;

}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    if (rootController.keyword) {
        [self performSelector:@selector(setKeyword) withObject:nil afterDelay:0.1];
    }
}

- (void) searchPosiWithLoading:(BOOL)loading{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    
    NSString *postString = nil;
    if ([HotelSearch isPositioning]) {
        postString = [NSString stringWithFormat:@"%@?keyword=%@&city=%@",AUTONAVI,self.savedSearchTerm,[[PositioningManager shared] currentCity]];
    }else{
        postString = [NSString stringWithFormat:@"%@?keyword=%@&city=%@",AUTONAVI,self.savedSearchTerm,[hotelsearcher cityName]];
    }
    //
    //
    
    [self searchPosiWithURLString:postString];
    
    if (loading) {
        //[loadingView startAnimating];
    }
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar_
{
    
    
    // 去掉键盘搜索默认置灰
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) ? searchBar_.subviews : [[searchBar_.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_{
    //[self searchPosiWithLoading:YES];
    if (self.posiArray) {
        if (self.posiArray.count) {
            //[searchDC.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:searchDC.searchResultsTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }
    else if ([searchBar_.text isEqualToString:@""])
    {
        self.rootController.keyword = @"";
        JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
        [self setCityName:[hotelsearcher cityName]];
        
        [self hotelDefalutSearch];
    }
    [searchDC setActive:NO animated:YES];
    
    
    rootController.moreBtn.hidden = NO;
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar_{
    if (searchBar.text && ![searchBar.text isEqualToString:@""]) {
        self.rootController.keyword = [NSString stringWithFormat:@"%@",searchBar.text];
    }else{
        if(self.rootController.keyword){
            self.rootController.keyword = nil;
            [self.rootController resetKeywordFromMap];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [searchDC setActive:NO animated:YES];
    
  
    
    NSString *poiName = nil;
    NSDictionary *dict = [self.posiArray safeObjectAtIndex:indexPath.row];
    if ([dict safeObjectForKey:@"name"] && [dict safeObjectForKey:@"name"] != [NSNull null]) {
        poiName = [dict safeObjectForKey:@"name"];
        [searchBar performSelector:@selector(setText:) withObject:poiName afterDelay:0.1];
    }else if([dict safeObjectForKey:@"formatted_address"] && [dict safeObjectForKey:@"formatted_address"] != [NSNull null]){
        poiName = [dict safeObjectForKey:@"formatted_address"];
        [searchBar performSelector:@selector(setText:) withObject:poiName afterDelay:0.1];
    }
    
    
    float zoomLevel = MAP_ZOOM_LEVEL;
    CLLocationCoordinate2D myCoordinate;
    if ([dict safeObjectForKey:@"x"] && [dict safeObjectForKey:@"x"] != [NSNull null]) {
        myCoordinate.latitude = [[dict safeObjectForKey:@"y"] doubleValue];
        myCoordinate.longitude = [[dict safeObjectForKey:@"x"] doubleValue];
    }else if([dict safeObjectForKey:@"geometry"] && [dict safeObjectForKey:@"geometry"] != [NSNull null]){
        myCoordinate.latitude = [[[[dict safeObjectForKey:@"geometry"] safeObjectForKey:@"location"] safeObjectForKey:@"lat"] doubleValue];
        myCoordinate.longitude = [[[[dict safeObjectForKey:@"geometry"] safeObjectForKey:@"location"] safeObjectForKey:@"lng"] doubleValue];
    }else{
        myCoordinate.latitude = 0;
        myCoordinate.longitude = 0;
    }
    
    
	MKCoordinateRegion region = MKCoordinateRegionMake(myCoordinate,MKCoordinateSpanMake(zoomLevel,zoomLevel));
	[mapView setRegion:[mapView regionThatFits:region] animated:YES];

    
    if (!requestBlock) {
        requestBlock = YES;
        canLocationSearch = YES;
        rootController.isMaximum = NO;
        
        [mapView removeAnnotations:mapAnnotations];
        [self addPinWithCoordinate:myCoordinate];
    }
    
    // 设置all in one 搜索条件 POI
    // 取得搜索条件的单例
    HotelConditionRequest *hcReq = [HotelConditionRequest shared];
    hcReq.keywordFilter.keywordType = HotelKeywordTypePOI;
    hcReq.keywordFilter.keyword = poiName;
    hcReq.keywordFilter.lng = myCoordinate.longitude;
    hcReq.keywordFilter.lat = myCoordinate.latitude;
    
    [self.rootController setKeywordFromMap:[NSString stringWithFormat:@"%@",poiName]];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (posiArray) {
        return [posiArray count];
    }else{
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *obj = [self.posiArray safeObjectAtIndex:indexPath.row];
    if (obj && obj != [NSNull null]) {
        NSDictionary *dict = (NSDictionary *)obj;
        if ([dict safeObjectForKey:@"formatted_address"] && [dict safeObjectForKey:@"formatted_address"]!=[NSNull null]) {
            return 40;
        }else{
            return 60;
        }
    }
    return 40;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PosiCell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PosiCell"] autorelease];
    }
    NSObject *obj = [self.posiArray safeObjectAtIndex:indexPath.row];
    if (obj && obj != [NSNull null]) {
        
        if ([obj isKindOfClass:[NSString class]]) {
            cell.textLabel.text = (NSString *)obj;
        }else{
            NSDictionary *posiDict = (NSDictionary *)obj;
            if ([posiDict safeObjectForKey:@"name"] && [posiDict safeObjectForKey:@"name"]!=[NSNull null]) {
                cell.textLabel.text = [posiDict safeObjectForKey:@"name"];
            }else if([posiDict safeObjectForKey:@"formatted_address"] && [posiDict safeObjectForKey:@"formatted_address"]!=[NSNull null]){
                cell.textLabel.text = [posiDict safeObjectForKey:@"formatted_address"];
            }
            if ([posiDict safeObjectForKey:@"type"] && [posiDict safeObjectForKey:@"type"]!=[NSNull null]) {
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",[posiDict safeObjectForKey:@"type"]];
            }
        }
    }
    
    return cell;
}


#pragma mark -
#pragma mark PublicMethods
#pragma mark -
#pragma adjust mapview to routes
//校正地图视野范围
-(void) centerMap
{
    
    if(!mapAnnotations||mapAnnotations.count<1)
        return;


	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
    int count = mapAnnotations.count;
	for(int idx = 0; idx < count; idx++)
	{
        PriceAnnotation * curAnonotation=((PriceAnnotation *)[mapAnnotations safeObjectAtIndex:idx]);
        
        if(curAnonotation.coordinate.latitude==0 && curAnonotation.coordinate.longitude==0)
            continue;
        
		if(curAnonotation.coordinate.latitude > maxLat)
			maxLat = curAnonotation.coordinate.latitude;
		if(curAnonotation.coordinate.latitude < minLat)
			minLat = curAnonotation.coordinate.latitude;
		if(curAnonotation.coordinate.longitude > maxLon)
			maxLon = curAnonotation.coordinate.longitude;
		if(curAnonotation.coordinate.longitude < minLon)
			minLon = curAnonotation.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + 0.012;
	region.span.longitudeDelta = maxLon - minLon + 0.002;
    
	[mapView setRegion:region animated:YES];
}


- (void)reloadMap {
	[self addmark];
	
	isResearch = NO;
}


- (void)setPin:(UITapGestureRecognizer *)recognizer {
	// 防止长按手势2次执行
	if (UIGestureRecognizerStateBegan == recognizer.state) {
		// 长按处加入大头针
		
		if (!requestBlock) {
            UMENG_EVENT(UEvent_Hotel_ListMap_LongPress)
            
			requestBlock = YES;
			canLocationSearch = YES;
			rootController.isMaximum = NO;
			
			CGPoint location = [recognizer locationInView:mapView];
			CLLocationCoordinate2D coordinate = [mapView convertPoint:location toCoordinateFromView:mapView];
			[mapView removeAnnotations:mapAnnotations];
			[self addPinWithCoordinate:coordinate];
			
			// 如果用户发生长按操作，就把地图上方的提示栏去掉
			UIView *tipBar = (UIView *)[self.view viewWithTag:TIPBARTAG];
			if (tipBar.superview) {
				[UIView beginAnimations:nil context:nil];
				[UIView setAnimationDuration:0.5];
				tipBar.center = CGPointMake(tipBar.center.x, tipBar.center.y - tipBar.frame.size.height);
				[UIView commitAnimations];
				[tipBar performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.6];
			}
		}
	}
}


- (void)selectPin {
	[mapView setCenterCoordinate:pinAnnotation.coordinate animated:YES];
	[mapView selectAnnotation:pinAnnotation animated:YES];
}

- (void) searchPosiWithURLString:(NSString *)url{
    if (!selfIsDealloc) {
        
        NSString *getUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (USENEWNET) {
            if (posiUtil) {
                [posiUtil cancel];
                SFRelease(posiUtil);
            }
            
            posiUtil = [[HttpUtil alloc] init];
            [posiUtil connectWithURLString:getUrl
                                   Content:nil
                              StartLoading:NO
                                EndLoading:NO
                                  Delegate:self];
        }
        
        // 网络加载符
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)searchMoreHotel {
	if (!requestBlock) {
        UMENG_EVENT(UEvent_Hotel_ListMap_More)
        
        // countly loadmore
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_HOTELMAPPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_LOADMORE;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
        
		requestBlock = YES;
		rootController.moreBtn.enabled = NO;
		
		linktype = MOREHOTEL;
		JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
		[hotelsearcher nextPage];
		
        if (USENEWNET) {
            if (moreHotelUtil) {
                [moreHotelUtil cancel];
                SFRelease(moreHotelUtil);
            }
            
            moreHotelUtil = [[HttpUtil alloc] init];
            [moreHotelUtil connectWithURLString:HOTELSEARCH
                                        Content:[hotelsearcher requesString:YES]
                                   StartLoading:NO
                                     EndLoading:NO
                                       Delegate:self];
        }
        		
		[self addMapLoadingView];
	}
    
    if (UMENG) {
        [MobClick event:Event_HotelList_More];
    }
}


- (void)stopAllMapReq {
	selfIsDealloc = YES;
	[self stopGeocoding];
    self.rootController = nil;
    
    [moreHotelUtil cancel];
    SFRelease(moreHotelUtil);
    
    [locationUtil cancel];
    SFRelease(locationUtil);
    
    [posiUtil cancel];
    SFRelease(posiUtil);
	
    if (mapView) {
        mapView.delegate = nil;
        self.mapView = nil;
    }
}

- (void)moveCurrentPin {
	if (pinAnnotation) {
		[mapView removeAnnotation:pinAnnotation];
		pinAnnotation = nil;
	}
}


- (void)removeMapAnnotationsInRange:(NSRange)range {
	[mapView removeAnnotations:[mapAnnotations objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]]];
	[mapAnnotations removeObjectsInRange:range];
}


// 酒店默认搜索
- (void)hotelDefalutSearch
{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    
    NSString *checkInDate = [hotelsearcher getCheckinDate];
    NSString *checkOutDate = [hotelsearcher getCheckoutDate];
    [HotelSearch setPositioning:NO];
    [hotelsearcher clearBuildData];
    [hotelsearcher setCityName:_cityName];
    [hotelsearcher setCheckData:checkInDate checkoutdate:checkOutDate];
    
    if (_defaultUtil) {
        [_defaultUtil cancel];
        SFRelease(_defaultUtil);
    }
    
    _defaultUtil = [[HttpUtil alloc] init];
    [_defaultUtil connectWithURLString:HOTELSEARCH
                                Content:[hotelsearcher requesString:YES]
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
    
    [self addMapLoadingView];
}

#pragma mark -
#pragma mark MapView Delegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	MKCircleView* circleView = [[[MKCircleView alloc] initWithOverlay:overlay] autorelease];
	circleView.strokeColor = COLOR_NAV_TITLE;
	circleView.lineWidth = 3.0;
	circleView.fillColor = [UIColor clearColor];
	return circleView;
}


- (void)mapView:(MKMapView *)map didAddAnnotationViews:(NSArray *)views {
	if (canLocationSearch) {
		MKAnnotationView *pinView = [views safeObjectAtIndex:0];
		if ([pinView isKindOfClass:[MKPinAnnotationView class]]) {
            
            
			[self researchHotelInCoordinate:pinAnnotation.coordinate];
			canLocationSearch = NO;
		}
	}
}

//得到价签图片路径
-(NSString *) getPriceAnomationIcon:(double)price
{
    NSString *path=@"lowPrice.png";
    if(price<300)
        path=@"lowPrice.png";
    else if(price>=300&&price<600)
        path=@"middlePrice.png";
    else if(price>=600)
        path=@"highPrice.png";
    
    return path;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	// If it's the user location, just return nil.
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
	
	// Handle any custom annotations.
    if ([annotation isKindOfClass:[PinAnnotation class]]) {
		static NSString *PinIdentifier = @"PinIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
		
        if (!pinView)
        {
			// 大头针注解
			MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
																				   reuseIdentifier:PinIdentifier] autorelease];
            annotationView.canShowCallout = YES;
			annotationView.animatesDrop = YES;
			
			if (IOSVersion_4) {
				annotationView.draggable = YES;
			}
			
			return annotationView;
		}
		else {
			pinView.annotation = annotation;
		}
		
		return pinView;
	}
	else {
		static NSString *priceIdentifier = @"priceIdentifier";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:priceIdentifier];
		
		if (!annotationView)
        {
            // 价格注解
			annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
														   reuseIdentifier:priceIdentifier] autorelease];
            annotationView.canShowCallout	= YES;
			annotationView.opaque			= NO;
            annotationView.frame			= CGRectMake(0, 0, 49, 35);
            
            UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, annotationView.frame.size.width, annotationView.frame.size.height)];
            bgImageView.tag = MAPPRICEIMAGE;
            [annotationView addSubview:bgImageView];
            [bgImageView release];
            
            UILabel *unSignedLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 49, 28)];
            unSignedLbl.backgroundColor=[UIColor clearColor];
            unSignedLbl.tag=UnSignedLabelTAG;
            unSignedLbl.text=@"暂无报价";
            unSignedLbl.font = [UIFont boldSystemFontOfSize:10];
            unSignedLbl.textAlignment=NSTextAlignmentCenter;
            unSignedLbl.textColor=[UIColor whiteColor];
            [bgImageView addSubview:unSignedLbl];
            [unSignedLbl release];
            unSignedLbl.hidden=YES;
            
			UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -4, annotationView.frame.size.width, 12)];
			priceLabel.font				= [UIFont boldSystemFontOfSize:14];
			priceLabel.backgroundColor	= [UIColor clearColor];
			priceLabel.textColor		= [UIColor whiteColor];
			priceLabel.textAlignment	= UITextAlignmentCenter;
			priceLabel.tag				= PRICELABELTAG;
			priceLabel.adjustsFontSizeToFitWidth = YES;
			[annotationView addSubview:priceLabel];
			[priceLabel release];
            
			
			UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, annotationView.frame.size.width, 10)];
			starLabel.font				= [UIFont boldSystemFontOfSize:10];
			starLabel.backgroundColor	= [UIColor clearColor];
			starLabel.textColor			= [UIColor whiteColor];
			starLabel.textAlignment		= UITextAlignmentCenter;
			starLabel.tag				= STARLABELTAG;
			[annotationView addSubview:starLabel];
			[starLabel release];
		}
        //get price
        //NSString *mapPath=[self getPriceAnomationIcon:((PriceAnnotation *)annotation).truePrice];
		UIImageView *bgImageView = (UIImageView *)[annotationView viewWithTag:MAPPRICEIMAGE];        
        bgImageView.image = [UIImage noCacheImageNamed:@"mapAnnotation_Icon.png"]; //[UIImage noCacheImageNamed:mapPath];
        
        BOOL isUnsigned = ((PriceAnnotation *)annotation).isUnsigned;
        UILabel *priceLabel = (UILabel *)[annotationView viewWithTag:PRICELABELTAG];
        UILabel *starLabel = (UILabel *)[annotationView viewWithTag:STARLABELTAG];
        UILabel *unSignedLbl=(UILabel *)[bgImageView viewWithTag:UnSignedLabelTAG];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        PriceAnnotation *ba = (PriceAnnotation *)annotation;
        NSString *rightBtnParam=[NSString stringWithFormat:@"%@-spliter-%d",ba.hotelid,ba.isUnsigned];
        [rightButton setTitle:rightBtnParam forState:UIControlStateNormal];
        [rightButton addTarget:self
                        action:@selector(showDetails:)
              forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = rightButton;
        
        if (isUnsigned)
        {
            bgImageView.image=[UIImage noCacheImageNamed:@"mapAnnotation_not.png"];
            priceLabel.hidden=YES;
            starLabel.hidden=YES;
            unSignedLbl.hidden=NO;
        }
        else
        {
            priceLabel.text = [NSString stringWithFormat:@"%@",((PriceAnnotation *)annotation).priceStr];
            starLabel.text = [NSString stringWithFormat:@"%@",((PriceAnnotation *)annotation).starLevel];
            
    //        HotelSpecialType specialType=((PriceAnnotation *)annotation).hotelSpecialType;
           
           
        
            if (![starLabel.text isEqualToString:@""]) {
                priceLabel.frame = CGRectMake(0, 3, annotationView.frame.size.width, 13);
            }
            else {
                priceLabel.frame = CGRectMake(0, 7, annotationView.frame.size.width, 13);
            }
            
            priceLabel.hidden=NO;
            starLabel.hidden=NO;
            unSignedLbl.hidden=YES;
            
            if (((PriceAnnotation *)annotation).isLM) {
                bgImageView.image=[UIImage noCacheImageNamed:@"mapAnnotation_lm_Icon.png"];
                starLabel.text = @"今日特价";
            }
        }
		
		return annotationView;
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)map annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	if (MKAnnotationViewDragStateNone == newState) {
		// 讲视图中心转到大头针落下的位置
		[mapView removeAnnotations:mapAnnotations];
		[self researchHotelInCoordinate:annotationView.annotation.coordinate];
	}
}

#pragma mark -
#pragma mark MKReverseGeocoder Delegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	// 收不到地址信息时取消提示,并重新搜索
	pinAnnotation.subtitle = @"";
	[searchGeocoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	if (searchGeocoder) {
		if (selfIsDealloc) {
            [locationUtil cancel];
            [moreHotelUtil cancel];
		}
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		// 收到地址信息时显示地址信息
		NSArray *array = [placemark.addressDictionary safeObjectForKey:@"FormattedAddressLines"];
		NSMutableString *locationStr = [[NSMutableString alloc] initWithCapacity:1];
		for (NSString *str in array) {
			NSComparisonResult result = [str compare:@"邮政编码" options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, 4)];
			if (NSOrderedSame != result) {
				// 不显示邮政编码
				[locationStr appendString:str];
			}
		}
		
		pinAnnotation.subtitle = locationStr;
		[locationStr release];
		
		// 停止计时器
		if ([geoTimer isValid]) {
			[geoTimer invalidate];
			geoTimer = nil;
		}
	}
}

#pragma mark -
#pragma mark NetLink
#pragma mark onPostConnect & onPostConnect

- (void) dealWithSearchResult:(NSDictionary *)root{
    // 网络加载符
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    [loadingView stopAnimating];
    
    if ([root safeObjectForKey:@"list"] && [root safeObjectForKey:@"list"] != [NSNull null]) {
        //results
        self.posiArray = [root safeObjectForKey:@"list"];
    }else if([root safeObjectForKey:@"results"] && [root safeObjectForKey:@"results"] != [NSNull null]){
        self.posiArray = [root safeObjectForKey:@"results"];
    }else{
        self.posiArray = nil;
    }
    
    
    [searchDC.searchResultsTableView reloadData];
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util{
    if (util == moreHotelUtil) {
		//rootController.moreBtn.enabled = YES;
		//[rootController restoreSearchMoreHotel];
		[self removeMapLoadingView];
		
		//requestBlock = NO;
	}
	else if (util == locationUtil || util == _defaultUtil) {
		// 重新存入周边酒店信息
		//rootController.moreBtn.enabled = YES;
		//[rootController restoreSearchMoreHotel];
		[self removeMapLoadingView];
		
		//requestBlock = NO;
	}else if(util == posiUtil){
 //       [loadingView stopAnimating];
        // 网络加载符
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    if (util == moreHotelUtil) {
		rootController.moreBtn.enabled = YES;
		[rootController restoreSearchMoreHotel];
		[self removeMapLoadingView];
		
		requestBlock = NO;
	}
	else if (util == locationUtil || util == _defaultUtil)
    {
		// 重新存入周边酒店信息
		rootController.moreBtn.enabled = YES;
		[rootController restoreSearchMoreHotel];
		[self removeMapLoadingView];
		
		requestBlock = NO;
	}else if(util == posiUtil){
 //       [loadingView stopAnimating];
        // 网络加载符
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    
	NSDictionary *root = nil;
    if (util == posiUtil) {
        NSString *outStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        root = [outStr JSONValue];
        [outStr release];
    }else{
        root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:root]) {
            [self removeMapLoadingView];
            return ;
        }
    }

	if (util == moreHotelUtil) {
		// 添加新获取的酒店信息
		rootController.moreBtn.enabled = YES;
		
		
		NSArray *dataArray = [root safeObjectForKey:RespHL_HotelList_A];
		[[HotelSearch hotels] addObjectsFromArray:dataArray];
		hotelCount += [dataArray count];
		
		[self addMapAnnotations:dataArray];
		[self removeMapLoadingView];
        
         NSLog(@"%d",hotelCount);
        [rootController checkHotelFull];
		 NSLog(@"%d",hotelCount);
        
		requestBlock = NO;
        
        NSLog(@"%d",hotelCount);

	}
    // 默认搜索
    else if (util == _defaultUtil)
    {
        // 添加新获取的酒店信息
		rootController.moreBtn.enabled = YES;
		
		NSArray *dataArray = [root safeObjectForKey:RespHL_HotelList_A];
        [[HotelSearch hotels] removeAllObjects];
		[[HotelSearch hotels] addObjectsFromArray:dataArray];
        
		[HotelSearch setHotelCount:[[root safeObjectForKey:RespHL_HotelCount_I] intValue]];
		
        [rootController restoreSearchMoreHotel];
		[self resetAnnotations];
        hotelCount = [[HotelSearch hotels] count];
		[self removeMapLoadingView];
		[mapView deselectAnnotation:pinAnnotation animated:YES];
		isResearch = YES;
		
		if (25 >= [HotelSearch hotelCount]) {
			// 不满一页时，不再进行更多查询
			[rootController forbidSearchMoreHotel];
		}else {
			[rootController restoreSearchMoreHotel];
		}
        
        requestBlock = NO;
    }
	else if (util == locationUtil) {
        
        // 周边搜索情况，传入品牌和星级信息
        JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
        [hotelsearcher setBrandAndStar:root];
        
        
        
		// 重新存入周边酒店信息
		rootController.moreBtn.enabled = YES;
        
        NSMutableArray *hotelArray = [NSMutableArray arrayWithArray:[root safeObjectForKey:RespHL_HotelList_A]];
        
        /*psg推荐
        if ([root safeObjectForKey:RespHL_PSGHotels] != [NSNull null]) {
            NSArray *psgHotelArray = [root safeObjectForKey:RespHL_PSGHotels];
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
         */
        
		[[HotelSearch hotels] removeAllObjects];
		[[HotelSearch hotels] addObjectsFromArray:hotelArray];
		[HotelSearch setHotelCount:[[root safeObjectForKey:RespHL_HotelCount_I] intValue]];
		
        // 设置今日特价信息
        if ([root safeObjectForKey:@"HotelLmCnt"] != [NSNull null] && [root safeObjectForKey:@"HotelLmCnt"]) {
            [HotelSearch setTonightHotelCount:[[root safeObjectForKey:@"HotelLmCnt"] intValue]];
        }else{
            [HotelSearch setTonightHotelCount:0];
        }
        if ([root safeObjectForKey:@"MinPrice"] != [NSNull null] && [root safeObjectForKey:@"MinPrice"]) {
            [HotelSearch setTonightMinPrice:[[root safeObjectForKey:@"MinPrice"] floatValue]];
        }else{
            [HotelSearch setTonightMinPrice:0.0f];
        }
        
		[rootController restoreSearchMoreHotel];
		[self resetAnnotations];
        hotelCount = [[HotelSearch hotels] count];
		[self removeMapLoadingView];
		[mapView selectAnnotation:pinAnnotation animated:YES];
		//[self performSelector:@selector(selectPin) withObject:nil afterDelay:0.2];
		isResearch = YES;
		
		if (25 >= [HotelSearch hotelCount]) {
			// 不满一页时，不再进行更多查询
			[rootController forbidSearchMoreHotel];
		}else {
			[rootController restoreSearchMoreHotel];
		}
		
		requestBlock = NO;
	}else if(util == posiUtil){
        [self dealWithSearchResult:root];
    }
	else {
		[[HotelDetailController hoteldetail] addEntriesFromDictionary:root];
        [[HotelDetailController hoteldetail] removeRepeatingImage];
        rootController.selRow = -1;
        [rootController goHotelDetail];
        
        
        JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
        NSString *CheckonDate = [hotelsearcher getObject:ReqHS_CheckInDate_ED];
        NSString *CheckoutDate = [hotelsearcher getObject:ReqHS_CheckOutDate_ED];
        HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
        promotionInfoRequest.orderEntrance = OrderEntranceMap;
        promotionInfoRequest.checkinDate = CheckonDate;
        promotionInfoRequest.checkoutDate = CheckoutDate;
        promotionInfoRequest.hotelId = [root safeObjectForKey:RespHL__HotelId_S];
        promotionInfoRequest.hotelName = [root safeObjectForKey:RespHL__HotelName_S];
        promotionInfoRequest.cityName = hotelsearcher.cityName;
        promotionInfoRequest.star = [root safeObjectForKey:@"NewStarCode"];
        
	}
    
	linktype = -1;
}

- (NSString *)getCityNameWithCityID:(NSString *)cityID {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"hotelcity" ofType:@"plist"];
	NSDictionary *dictionary  = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	for (NSArray *keyArray in [dictionary allValues]) {
		for (NSArray *cityArray in keyArray) {
			if ([[cityArray safeObjectAtIndex:3] isEqualToString:cityID]) {
				return [cityArray objectAtIndex:0];
			}
		}
	}
	return @"";
}


#pragma mark -
#pragma mark Action
#pragma mark hoteldetail

-(void)hoteldetail:(NSString *)hotelId CheckInDate:(NSString *)checkInDate CheckOutDate:(NSString *)checkOutDate isUnsigned:(BOOL) isUnsigned
{
	linktype = HOTELDETAIL;
	JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
	[hoteldetail clearBuildData];
	[hoteldetail setHotelId:hotelId];
    [hoteldetail setIsUnsigned:isUnsigned];
	[hoteldetail setCheckDateByElongDate:checkInDate checkoutdate:checkOutDate];
    
	[Utils request:HOTELSEARCH req:[hoteldetail requesString:YES] policy:CachePolicyHotelDetail  delegate:self];
}

#pragma mark pinContent

-(void)showDetails:(id)sender{
	UIButton *btn = (UIButton *)sender;
    
    if (btn==nil) {
        return;
    }
    
    NSString *cutTitle=[btn currentTitle];
    
    if (!STRINGHASVALUE(cutTitle)) {
        return;
    }
    
    NSArray *arr = [cutTitle componentsSeparatedByString:@"-spliter-"];
    
    if (arr==nil||arr.count!=2) {
        return;
    }
    
    NSString *hotelId=[arr safeObjectAtIndex:0];
    
    if (!STRINGHASVALUE(hotelId)) {
        return;
    }
    
    if ([arr safeObjectAtIndex:1]==nil) {
        return;
    }
    
    BOOL isUnsigned=[[arr safeObjectAtIndex:1] boolValue];
    
	JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
	NSString *CheckonDate = [hotelsearcher getObject:ReqHS_CheckInDate_ED];
	NSString *CheckoutDate = [hotelsearcher getObject:ReqHS_CheckOutDate_ED];
	
	[self hoteldetail:hotelId CheckInDate:CheckonDate CheckOutDate:CheckoutDate isUnsigned:isUnsigned];
    
    UMENG_EVENT(UEvent_Hotel_ListMap_DetailEnter)
    
    // countly 地图-酒店点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELMAPPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_HOTELITEM;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

#pragma mark -
#pragma mark SystemCallBack

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    if (moreHotelUtil)
    {
        [moreHotelUtil cancel];
        SFRelease(moreHotelUtil);
    }
    
    if (locationUtil)
    {
        [locationUtil cancel];
        SFRelease(locationUtil);
    }
    
    if (posiUtil)
    {
        [posiUtil cancel];
        SFRelease(posiUtil);
    }
    
    if (_defaultUtil)
    {
        [_defaultUtil cancel];
        SFRelease(_defaultUtil);
    }
    
    SFRelease(_cityName);
	[smallLoading	release];
	[mapAnnotations release];
	[hotelDetail	release];
	[noDataTipLabel release];
    if (mapView) {
        mapView.delegate = nil;
        self.mapView = nil;
    }

	[searchDC release];
    self.posiArray = nil;
    self.savedSearchTerm = nil;
    [super dealloc];
}

@end
