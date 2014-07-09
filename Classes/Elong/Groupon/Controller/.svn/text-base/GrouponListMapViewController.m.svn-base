//
//  GrouponListMapViewController.m
//  ElongClient
//
//  Created by Dawn on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponListMapViewController.h"
#import "GrouponHomeViewController.h"
#import "GrouponDetailViewController.h"
#import "PositioningManager.h"
#import "DefineHotelResp.h"
#import "GListRequest.h"
#import "SearchBarView.h"


#define MAP_ZOOM_LEVEL			0.2

#define HOTELLIST		0
#define HOTELDETAIL		1

#define PRICELABELTAG	2222
#define STARLABELTAG	3333
#define CHANGECITY			10


@interface GrouponListMapViewController ()
@property (nonatomic,retain) NSMutableArray *posiArray;
@property (nonatomic,retain) NSString *savedSearchTerm;
@property (nonatomic, retain) PinAnnotation *pinAnnotation;
@end

@implementation GrouponListMapViewController
@synthesize mapView;
@synthesize hoomVC;
@synthesize savedSearchTerm;
@synthesize posiArray;
@synthesize pinAnnotation;

- (void)dealloc {
	mapView.delegate = nil;
    self.pinAnnotation = nil;
    self.savedSearchTerm = nil;
    self.posiArray = nil;
    
    searchDC.delegate = nil;
    searchDC.searchResultsDelegate = nil;
    searchDC.searchResultsDataSource = nil;
    
    [moreHotelUtil cancel];
    SFRelease(moreHotelUtil);
    
    [poiSearchUtil cancel];
    SFRelease(poiSearchUtil);
    
    [posiUtil cancel];
    SFRelease(posiUtil);
	
	[mapView		release];
	[mapAnnotations release];
	[smallLoading	release];
	[mapAnnotationDic release];
	[noDataTipLabel release];
    [searchDC release];
	
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44);
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44 - 44)];
    [self.view addSubview:mapView];
    
    mapAnnotations = [[NSMutableArray alloc] initWithCapacity:2];
    mapAnnotationDic = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    mapView.delegate			= self;
    mapView.showsUserLocation	= YES;
    
    noDataTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, MAINCONTENTHEIGHT / 2 - 40, 280, 40)];
    noDataTipLabel.backgroundColor	= [UIColor clearColor];
    noDataTipLabel.text				= @"未找到酒店位置信息";
    noDataTipLabel.textAlignment	= UITextAlignmentCenter;
    noDataTipLabel.font				= [UIFont boldSystemFontOfSize:16];
    noDataTipLabel.hidden			= YES;
    noDataTipLabel.textColor        = RGBACOLOR(93, 93, 93, 1);
    [self.view addSubview:noDataTipLabel];
    
    [self performSelector:@selector(resetAnnotations)];
    
    // 长按手势
    [self addLongPressGes];
    
    // 添加搜索条
    [self addSearchBar];
    
    if (UMENG) {
        //团购酒店列表切换地图
        [MobClick event:Event_GrouponHotelList_Map];
    }
    
    if (MONKEY_SWITCH)
    {
        // 开启monkey时，地图屏蔽版权点击区域
        UIView *mapCover = [[UIView alloc] initWithFrame:CGRectMake(0, mapView.bounds.size.height - 30, 50, 30)];
        mapCover.backgroundColor = [UIColor clearColor];
        [mapView addSubview:mapCover];
        [mapCover release];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setKeyword];
}


#pragma mark -
#pragma mark Private Method

- (void) addLongPressGes{
    // 加入长按手势
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setPin:)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
    
    // 加入长按提示栏
    UILabel *tipLabel			= [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 320, 20)];
    tipLabel.backgroundColor	= [UIColor clearColor];
    tipLabel.text				= @"长按地图设定搜索地点";
    tipLabel.textColor			= [UIColor whiteColor];
    tipLabel.textAlignment		= UITextAlignmentCenter;
    tipLabel.font				= [UIFont systemFontOfSize:12];
    
    tipBar = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 8, 320, 28)];
    tipBar.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    [tipBar addSubview:tipLabel];
    [tipLabel release];
    [self.view addSubview:tipBar];
    [tipBar release];
}

- (void)setPin:(UITapGestureRecognizer *)recognizer {
	// 防止长按手势2次执行
	if (UIGestureRecognizerStateBegan == recognizer.state) {
		// 长按处加入大头针
		
		CGPoint location = [recognizer locationInView:mapView];
        CLLocationCoordinate2D coordinate = [mapView convertPoint:location toCoordinateFromView:mapView];

        [self addPinWithCoordinate:coordinate];
        
        UMENG_EVENT(UEvent_Groupon_ListMap_LongPress)
        
        // 重置keyword
        self.hoomVC.keyword = nil;
        
        // 如果用户发生长按操作，就把地图上方的提示栏去掉
        if (tipBar) {
            [UIView animateWithDuration:0.5 animations:^{
                tipBar.center = CGPointMake(tipBar.center.x, tipBar.center.y - tipBar.frame.size.height);
            } completion:^(BOOL finished) {
                [tipBar removeFromSuperview];
                tipBar = nil;
            }];
        }
	}
}


// 设置插杆点
- (void)addPinWithCoordinate:(CLLocationCoordinate2D)coordinate {
    // 当目的地发生变化时，删除旧得数据，重新搜索新的酒店
	if (self.pinAnnotation) {
		[mapView removeAnnotation:self.pinAnnotation];
	}
	PinAnnotation *annotation = [[PinAnnotation alloc] init];
	[annotation setCoordinate:coordinate];
	self.pinAnnotation = annotation;
	[mapView addAnnotation:pinAnnotation];
	[annotation release];
    
 
}

- (void) addSearchBar{
    // 搜索框
    searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchBar.placeholder = @"地址、地标、关键词";
	searchBar.barStyle =  UIBarStyleDefault;
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
	[searchBar release];
    
    
    // 赋值，把列表中的关键词带入地图
    if (self.hoomVC.keyword) {
        searchBar.text = [NSString stringWithFormat:@"%@",self.hoomVC.keyword];
    }
    
	
	//self.parentViewController
	searchDC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self] ;
	searchDC.searchResultsDelegate = self;
	searchDC.searchResultsDataSource = self;
    searchDC.delegate = self;
    
    [searchDC.searchResultsTableView setBackgroundColor:[UIColor whiteColor]];
    [searchDC.searchResultsTableView setRowHeight:60];
    [searchDC.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)addAnnotationFromDictionary:(NSDictionary *)dic {
	int index = [mapAnnotations count];
	
	NSMutableArray *hotelsArray = [NSMutableArray arrayWithCapacity:2];		// 记录与团购对应的所有酒店
    //插入地图的个数
    int insertCnt=0;
	for (NSDictionary *paramDic in [dic safeObjectForKey:HOTELDETAILINFOS_RESP]) {
		// 一个酒店可能具有多家分店
		double r = 0;
		double l = 0;
		
		if (![[paramDic safeObjectForKey:RespHL__Latitude_D] isEqual:[NSNull null]]) {
			r = [[paramDic safeObjectForKey:RespHL__Latitude_D] doubleValue];
		}
		
		if (![[paramDic safeObjectForKey:RespHL__Longitude_D] isEqual:[NSNull null]]) {
			l = [[paramDic safeObjectForKey:RespHL__Longitude_D] doubleValue];
		}
		
		if (r != 0 || l != 0) {
            
            if ([PublicMethods needSwitchWgs84ToGCJ_02Groupon]) {
                [PublicMethods wgs84ToGCJ_02WithLatitude:&r longitude:&l];
            }
            
			// 没有坐标值的不显示
			NSString *titlestring = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:PRODNAME_GROUPON]];
			NSString *hoteladress = [NSString stringWithFormat:@"区域：%@",[paramDic safeObjectForKey:BIZSECTIONNAME_RESP]];
			
			PriceAnnotation *priceAnnotation	= [[PriceAnnotation alloc] init];
			priceAnnotation.title				= titlestring;
			priceAnnotation.subtitle			= hoteladress;
			
			NSString *starStr = @"";
			// 酒店星级
			if (![[paramDic safeObjectForKey:STAR_RESP] isEqual:[NSNull null]]) {
				int starlevel = [[paramDic safeObjectForKey:STAR_RESP] intValue];
                if (starlevel<10) {
                    starlevel*=10;
                }
                starStr = [PublicMethods getStar:starlevel];
			}
            
			priceAnnotation.priceStr	= [NSString stringWithFormat:@"¥%.f",[[dic safeObjectForKey:SALEPRICE_GROUPON] doubleValue]];
			priceAnnotation.starLevel	= starStr;
			priceAnnotation.index		= index + 1;
			priceAnnotation.hotelid		= [NSString stringWithFormat:@"%@", [dic safeObjectForKey:PRODID_GROUPON]];
			[priceAnnotation setCoordinateStruct:r l:l];
			
			[mapAnnotations addObject:priceAnnotation];
			[hotelsArray addObject:priceAnnotation];
			[priceAnnotation release];
            
            insertCnt++;
            
            //多店最多显示15家
            if (insertCnt>15)
            {
                break;
            }
		}
	}
	
	[mapAnnotationDic safeSetObject:hotelsArray forKey:[dic safeObjectForKey:PRODID_GROUPON]];
}


- (void)addMapLoadingView {
	if (!smallLoading) {
		smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake(135, (self.view.frame.size.height-50) / 2, 50, 50)];
		[self.view addSubview:smallLoading];
	}
	
	[smallLoading startLoading];
}

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

- (void)addMapAnnotations:(NSArray *)annotations {
	for (NSDictionary *hotel in annotations) {
		[self addAnnotationFromDictionary:hotel];
	}
    
    
    [mapView addAnnotations:mapAnnotations];
    
	
	if ([mapAnnotations count] <= 0) {
		// 没有数据不显示地图
		//mapView.hidden = YES;
		//noDataTipLabel.hidden = NO;
	}
	else {
		[self.view removeTipMessage];
		mapView.hidden = NO;
		noDataTipLabel.hidden = YES;
	}
}


- (void)removeMapAnnotationsInRange:(NSRange)range {
	NSArray *delGroupons = [[self.hoomVC getAllGrouponList] objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
	for (NSDictionary *dic in delGroupons) {
		// 删除一个团购项目的所有酒店
		NSNumber *prodID = [dic safeObjectForKey:PRODID_GROUPON];
		
		NSMutableArray *hotelsArray = [mapAnnotationDic safeObjectForKey:prodID];
		[mapView removeAnnotations:hotelsArray];
		[mapAnnotations removeObjectsInArray:hotelsArray];
		[mapAnnotationDic removeObjectForKey:prodID];
	}
}


- (void)removeMapLoadingView {
	[smallLoading stopLoading];
}


- (void)resetAnnotations {
	[mapView removeAnnotations:mapAnnotations];
	[mapAnnotations removeAllObjects];
	[self addMapAnnotations:[self.hoomVC getAllGrouponList]];
	
	//[self performSelector:@selector(goGrouponHotel)];
    [self centerMap];
}


- (void)showDetails:(id)sender {
	UIButton *btn = (UIButton *)sender;
	NSString *hotelId = [btn currentTitle];
	
	[self.hoomVC searchDetailInfoByHotelID:hotelId];
    
    UMENG_EVENT(UEvent_Groupon_ListMap_DetailEnter)
}


- (void)goGrouponHotel {
	// 地图缩放到第一个酒店位置
	float zoomLevel = MAP_ZOOM_LEVEL;
	
	if ([mapAnnotations count] > 0) {
		PriceAnnotation *priceAnnotation = [mapAnnotations safeObjectAtIndex:0];
		
		MKCoordinateRegion region = MKCoordinateRegionMake(priceAnnotation.coordinate, MKCoordinateSpanMake(zoomLevel,zoomLevel));
		[mapView setRegion:[mapView regionThatFits:region] animated:YES];
	}
}

- (void) searchPosiWithURLString:(NSString *)url{
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

// 通过坐标搜索团购
- (void) searchGrouponByCoordinate:(CLLocationCoordinate2D)coordinate{
        // 重新设置地图图钉
    [mapView removeAnnotations:mapAnnotations];
    if (poiSearchUtil) {
        [poiSearchUtil cancel];
        SFRelease(poiSearchUtil);
    }
    // 重置数据
    self.hoomVC.linkType = CHANGECITY;
    
   
    [self setKeyword];
    
    GListRequest *cityListReq = [GListRequest shared];
    cityListReq.aioCondition = nil;
    [cityListReq clearData];
    [cityListReq setCityName:hoomVC.currentGrouponCity];
    self.hoomVC.currentOrder = @"";
    cityListReq.ImageSizeType   = 1;
    [cityListReq restoreGrouponListReqest];
    [cityListReq setLatitude:coordinate.latitude];
    [cityListReq setLongitude:coordinate.longitude];
    
    //重置底部栏的状态
    [self.hoomVC setBarItemDefaultStyle];
    [self.hoomVC updateFilterIcon];
    
    self.hoomVC.displayName = @"所选位置";
    
    if(poiSearchUtil) {
        [poiSearchUtil cancel];
        SFRelease(poiSearchUtil);
    }
    
    poiSearchUtil = [[HttpUtil alloc] init];
    [poiSearchUtil connectWithURLString:GROUPON_SEARCH Content:[cityListReq grouponListCompress:YES] StartLoading:NO EndLoading:NO Delegate:self];
    
    [self performSelector:@selector(addMapLoadingView) withObject:nil afterDelay:0.2];
}

#pragma mark -
#pragma mark Public Methods

- (void) setKeyword{
    // 赋值，把列表中的关键词带入地图
    if (self.hoomVC.keyword) {
        searchDC.delegate = nil;
        searchDC.searchResultsDelegate = nil;
        searchDC.searchResultsDataSource = nil;
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
        
        searchBar.text = [NSString stringWithFormat:@"%@",self.hoomVC.keyword];
        
        
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

- (void)goUserLoacation {
	float zoomLevel = MAP_ZOOM_LEVEL;
	MKCoordinateRegion currentRegion = mapView.region;
	
	if (currentRegion.span.latitudeDelta > zoomLevel) {
		currentRegion = MKCoordinateRegionMake([[PositioningManager shared] myCoordinate], MKCoordinateSpanMake(zoomLevel,zoomLevel));
	}
	else {
		currentRegion = MKCoordinateRegionMake([[PositioningManager shared] myCoordinate], currentRegion.span);
	}
    
	[mapView setRegion:currentRegion animated:YES];
}


- (void)searchMoreHotel {
    if (UMENG) {
        //团购酒店列表加载更多
        [MobClick event:Event_GrouponHotelList_More];
    }
    
    UMENG_EVENT(UEvent_Groupon_ListMap_More)
    
	// 请求下页数据
	if (self.hoomVC.moreBtn.enabled) {
		self.hoomVC.moreBtn.enabled = NO;
		linkType = kRequest_More;
		self.hoomVC.linkType = kRequest_More;
		GListRequest *cityListReq = [GListRequest shared];
		[cityListReq nextPage];
        
        if (USENEWNET) {
            if(moreHotelUtil) {
                [moreHotelUtil cancel];
                SFRelease(moreHotelUtil);
            }
            
            moreHotelUtil = [[HttpUtil alloc] init];
            [moreHotelUtil connectWithURLString:GROUPON_SEARCH Content:[cityListReq grouponListCompress:YES] StartLoading:NO EndLoading:NO Delegate:self];
        }
        
		[self addMapLoadingView];
        
	}
}


#pragma mark -
#pragma mark MapView Delegate

- (void)mapView:(MKMapView *)map didAddAnnotationViews:(NSArray *)views {
	MKAnnotationView *pinView = [views safeObjectAtIndex:0];
    if ([pinView isKindOfClass:[MKPinAnnotationView class]]) {
        // 通过坐标搜索团购
        [self searchGrouponByCoordinate:pinAnnotation.coordinate];
    }
}

- (void)mapView:(MKMapView *)map annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {

	if (MKAnnotationViewDragStateNone == newState) {
        // 通过坐标搜索团购
		[self searchGrouponByCoordinate:annotationView.annotation.coordinate];
	}
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
	}else{
        static NSString *priceIdentifier = @"priceIdentifier";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:priceIdentifier];
        
        if (!annotationView) {
            // 价格注解
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:priceIdentifier] autorelease];
            annotationView.canShowCallout	= YES;
            annotationView.opaque			= NO;
            annotationView.image			= [UIImage imageNamed:@"mapAnnotation_Icon.png"];
            annotationView.frame			= CGRectMake(0, 0, 49, 35);
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, annotationView.frame.size.width, 15)];
            priceLabel.font				= [UIFont boldSystemFontOfSize:14];
            priceLabel.backgroundColor	= [UIColor clearColor];
            priceLabel.textColor		= [UIColor whiteColor];
            priceLabel.textAlignment	= UITextAlignmentCenter;
            priceLabel.tag				= PRICELABELTAG;
            priceLabel.adjustsFontSizeToFitWidth = YES;
            [annotationView addSubview:priceLabel];
            [priceLabel release];
            
            UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, annotationView.frame.size.width, 10)];
            starLabel.font				= [UIFont systemFontOfSize:10];
            starLabel.backgroundColor	= [UIColor clearColor];
            starLabel.textColor			= [UIColor whiteColor];
            starLabel.textAlignment		= UITextAlignmentCenter;
            starLabel.tag				= STARLABELTAG;
            [annotationView addSubview:starLabel];
            [starLabel release];
        }
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        PriceAnnotation *ba = (PriceAnnotation *)annotation;
        [rightButton setTitle:ba.hotelid forState:UIControlStateNormal];
        [rightButton addTarget:self
                        action:@selector(showDetails:)
              forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = rightButton;
        
        UILabel *priceLabel = (UILabel *)[annotationView viewWithTag:PRICELABELTAG];
        priceLabel.text = [NSString stringWithFormat:@"%@",((PriceAnnotation *)annotation).priceStr];
        
        UILabel *starLabel = (UILabel *)[annotationView viewWithTag:STARLABELTAG];
        starLabel.text = [NSString stringWithFormat:@"%@",((PriceAnnotation *)annotation).starLevel];
        
        if (![starLabel.text isEqualToString:@""]) {
            priceLabel.frame = CGRectMake(0, 3, annotationView.frame.size.width, 13);
        }
        else {
            priceLabel.frame = CGRectMake(0, 7, annotationView.frame.size.width, 13);
        }
        
        return annotationView;
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



- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    self.posiArray = nil;
	NSString *searchStr = [NSString stringWithString:controller.searchBar.text];
	if (STRINGHASVALUE(searchStr)) {
		controller.searchBar.text = searchStr;				// 启动搜索表格
	}
    hoomVC.moreBtn.hidden = YES;
}


- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    if (posiUtil) {
        [posiUtil cancel];
        [posiUtil release],posiUtil = nil;
    }
    
    
    //    [loadingView stopAnimating];
    // 网络加载符
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    hoomVC.moreBtn.hidden = NO;
    
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    if (hoomVC.keyword) {
        [self performSelector:@selector(setKeyword) withObject:nil afterDelay:0.1];
    }
}

- (void) searchPosiWithLoading:(BOOL)loading{
    NSString *postString = nil;
    if ([self.hoomVC.currentGrouponCity isEqualToString:@"当前位置"]||[self.hoomVC.currentGrouponCity isEqualToString:@"周边"]) {
        postString = [NSString stringWithFormat:@"%@?keyword=%@&city=%@",AUTONAVI,self.savedSearchTerm,[[PositioningManager shared] currentCity]];
    }else{
        postString = [NSString stringWithFormat:@"%@?keyword=%@&city=%@",AUTONAVI,self.savedSearchTerm,self.hoomVC.currentGrouponCity];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //[self searchPosiWithLoading:YES];
    if (self.posiArray) {
        if (self.posiArray.count) {
            //[searchDC.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:searchDC.searchResultsTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            UMENG_EVENT(UEvent_Groupon_ListMap_Keyword)
        }
    }
    [searchDC setActive:NO animated:YES];
    
    hoomVC.moreBtn.hidden = NO;
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar_{
    if (searchBar.text && ![searchBar.text isEqualToString:@""]) {
        self.hoomVC.keyword = [NSString stringWithFormat:@"%@",searchBar.text];
    }else{
        if (self.hoomVC.keyword) {
            [self.hoomVC searchGrouponWithKeyword:nil hitType:0];
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
        //[searchBar performSelector:@selector(setText:) withObject:poiName afterDelay:0.1];
        self.hoomVC.keyword = poiName;
    }else if([dict safeObjectForKey:@"formatted_address"] && [dict safeObjectForKey:@"formatted_address"] != [NSNull null]){
        poiName = [dict safeObjectForKey:@"formatted_address"];
        //[searchBar performSelector:@selector(setText:) withObject:poiName afterDelay:0.1];
        self.hoomVC.keyword = poiName;
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
    
    
    
    [self addPinWithCoordinate:myCoordinate];
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
#pragma mark Net Delegate

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
    if(util == posiUtil){
        //       [loadingView stopAnimating];
        // 网络加载符
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    [self removeMapLoadingView];
}

- (void) httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    if(util == posiUtil){
        //       [loadingView stopAnimating];
        // 网络加载符
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    [self removeMapLoadingView];
}


- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    [self performSelector:@selector(removeMapLoadingView) withObject:nil afterDelay:0.3];
    
    NSDictionary *root = nil;
    if (util == posiUtil) {
        // 高德搜索数据
        NSString *outStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        root = [outStr JSONValue];
        [outStr release];
        
        [self dealWithSearchResult:root];
    }else{
        root = [PublicMethods unCompressData:responseData];
        
        if ([Utils checkJsonIsError:root]) {
            return;
        }
        
        if (util == moreHotelUtil) {
            
            
            // 更新本页数据(排序，切换地区)
            [self.hoomVC restoreSearchMoreHotel];
            [self.hoomVC setListGrouponInfo:root];
            
           
            
            // 回到原来为位置
            [self centerMap];
        }else if(util == poiSearchUtil){
            [self.hoomVC setGrouponCity:self.hoomVC.displayName];
            [self.hoomVC restoreSearchMoreHotel];
            [self.hoomVC resetListData:root];
            [self resetAnnotations];
            
            
            // 从pin位置居中显示
            float zoomLevel = MAP_ZOOM_LEVEL;
            CLLocationCoordinate2D myCoordinate = self.pinAnnotation.coordinate;
            MKCoordinateRegion region = MKCoordinateRegionMake(myCoordinate,MKCoordinateSpanMake(zoomLevel,zoomLevel));
            [mapView setRegion:[mapView regionThatFits:region] animated:YES];
        }else {
            // 进入详情页面
            [PublicMethods showAvailableMemory];
            GrouponDetailViewController *controller = [[GrouponDetailViewController alloc] initWithDictionary:root];
            controller.hotelDescription = [root safeObjectForKey:@"Description"];
            [self.hoomVC.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    }
}


@end
