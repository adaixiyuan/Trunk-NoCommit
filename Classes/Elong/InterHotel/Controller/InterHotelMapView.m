//
//  InterHotelMapVC.m
//  ElongClient
//
//  Created by 赵 海波 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelMapView.h"
#import "InterHotelListResultVC.h"
#import "InterHotelSearcher.h"
#import "PriceAnnotation.h"
#import "InterHotelDefine.h"
#import "PinAnnotation.h"
#import "RatingView.h"
#import "PositioningManager.h"
#import "InterHotelDetailCtrl.h"
#import "ElongURL.h"
#import "DefineHotelResp.h"

#define INTERHOTEL_PIN_BG_TAG       4001
#define INTERHOTEL_PIN_PRICE_TAG    4002
#define INTERHOTEL_PIN_STAR_TAG     4003
#define INTERHOTEL_DETAIL_TAG       4004

@interface InterHotelMapView()
@property (nonatomic,retain) NSMutableArray *mapAnnotations;
@end

@implementation InterHotelMapView
@synthesize rootController;
@synthesize mapAnnotations;

- (void) dealloc{
    if (moreHotelReq) {
        [moreHotelReq cancel];
        SFRelease(moreHotelReq);
    }
    if (poiHotelReq) {
        [poiHotelReq cancel];
        SFRelease(poiHotelReq);
    }
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 地图标签
        self.mapAnnotations = [[[NSMutableArray alloc] init] autorelease];
        
        // 地图
        mapView = [[MKMapView alloc] initWithFrame:self.bounds];
        mapView.delegate = self;
        mapView.showsUserLocation = YES;
        [self addSubview:mapView];
        [mapView release];
        
        noDataTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, MAINCONTENTHEIGHT / 2 - 40, 280, 40)];
        noDataTipLabel.backgroundColor	= [UIColor clearColor];
        noDataTipLabel.text				= @"未找到酒店位置信息";
        noDataTipLabel.textAlignment	= UITextAlignmentCenter;
        noDataTipLabel.textColor        = RGBACOLOR(93, 93, 93, 1);
        noDataTipLabel.font				= [UIFont boldSystemFontOfSize:16];
        noDataTipLabel.hidden			= YES;
        [self addSubview:noDataTipLabel];
        
        // 添加长按手势
        [self addLongPressGesture];
        
        // 刷新地图数据
        [self refreshMap];
        
        if (UMENG) {
            //国际酒店列表切换地图
            [MobClick event:Event_InterHotelList_Map];
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
    return self;
}

#pragma mark -
#pragma mark PrivateMethods

// 长按手势
- (void) addLongPressGesture{
    if (IOSVersion_4) {
		// 加入长按手势
		UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setPin:)];
		[mapView addGestureRecognizer:recognizer];
		[recognizer release];
		
		// 加入长按提示栏
		UILabel *tipLabel			= [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 320, 20)];
		tipLabel.backgroundColor	= [UIColor clearColor];
		tipLabel.text				= @"长按地图设定搜索地点";
		tipLabel.textColor			= [UIColor whiteColor];
		tipLabel.textAlignment		= UITextAlignmentCenter;
		tipLabel.font				= [UIFont systemFontOfSize:12];
        
        tipBar = [[UIView alloc] initWithFrame:CGRectMake(0, - 8, 320, 28)];
        tipBar.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        [tipBar addSubview:tipLabel];
        [tipLabel release];
        [self addSubview:tipBar];
        [tipBar release];
	}
}

// 重置地图数据
- (void) refreshMap{
    lastHotelId = 0;
    
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    if (self.mapAnnotations) {
        [mapView removeAnnotations:self.mapAnnotations];
    }
    
    [self.mapAnnotations removeAllObjects];
    
    for (NSDictionary *hotel in searcher.hotelList) {
		[self addAnnotationFromDictionary:hotel];
	}
    
    
    
    [mapView addAnnotations:self.mapAnnotations];
    
    [self centerMap];
    
    [self addmark];
    
    [self checkFoot];
    
    if (searcher.hotelList.count) {
        mapView.hidden = NO;
        noDataTipLabel.hidden = YES;
        if(tipBar){
            tipBar.hidden = NO;
        }
    }else{
        mapView.hidden = YES;
        noDataTipLabel.hidden = NO;
        if(tipBar){
            tipBar.hidden = YES;
        }
    }
}

// 对外公开，有更多数据时调用刷新
- (void) addMoreData{
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    if (self.mapAnnotations) {
        [mapView removeAnnotations:self.mapAnnotations];
    }
    
    [self.mapAnnotations removeAllObjects];
    
    for (NSDictionary *hotel in searcher.hotelList) {
		[self addAnnotationFromDictionary:hotel];
	}
    
    
    
    [mapView addAnnotations:self.mapAnnotations];
    
    [self centerMap];
    
    [self addmark];
    
    [self checkFoot];
}

// 检测是否还有更多酒店需要加载
- (void)checkFoot {
    [rootController restoreSearchMoreHotel];
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
	if (searcher.hotelList.count % HOTEL_PAGESIZE != 0 || searcher.hotelList.count == 0) {
        // 不满足页数最大容量,肯定不会有下一页
		rootController.isMaximum = YES;
		[rootController forbidSearchMoreHotel];
	}
    else {
        // 满足最大容量时，再判断是否发送了重复请求
        
        NSNumber *currentIdNum = [[searcher.hotelList lastObject] safeObjectForKey:HOTELID_REQ];
        NSInteger currentHotelId = 0;           // 取出当前列表里最后一个酒店的hotelid
        if (!OBJECTISNULL(currentIdNum)) {
            currentHotelId = [currentIdNum intValue];
        }
        
        if (currentHotelId != lastHotelId) {
            // 列表里数据不同，确实存在下一页
            rootController.isMaximum = NO;
        }
        else {
            // 列表里存在2组相同数据，禁止再次翻页
            rootController.isMaximum = YES;
            [rootController forbidSearchMoreHotel];
        }
        
        lastHotelId = currentHotelId;
	}
}

// 长按手势
- (void)setPin:(UITapGestureRecognizer *)recognizer {
	// 防止长按手势2次执行
	if (UIGestureRecognizerStateBegan == recognizer.state) {
		// 长按处加入大头针
		
		
        CGPoint location = [recognizer locationInView:mapView];
        CLLocationCoordinate2D coordinate = [mapView convertPoint:location toCoordinateFromView:mapView];
        
        // 通过坐标搜索团购
        [self addPinWithCoordinate:coordinate];
        [self searchHotelByCoordinate:coordinate];
        
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

// 添加地图标记
- (void)addAnnotationFromDictionary:(NSDictionary *)dic {
    
	int index = [self.mapAnnotations count];
	double r = [[dic safeObjectForKey:@"Latitude"] doubleValue];
	double l = [[dic safeObjectForKey:@"Longitude"] doubleValue];
    
    // 需要纠偏
    if([PublicMethods needSwitchWgs84ToGCJ_02Abroad]){
        [PublicMethods wgs84ToGCJ_02WithLatitude:&r longitude:&l];
    }
	
	NSString *titlestring = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:InterHotel_Name]];
	NSString *hoteladress = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:InterHotel_Address]];
    
	PriceAnnotation *priceAnnotation	= [[PriceAnnotation alloc] init];
	priceAnnotation.title				= titlestring;
	priceAnnotation.subtitle			= hoteladress;
	//priceAnnotation.hotelSpecialType    = Default;
    
	// 酒店星级
		
	priceAnnotation.priceStr	= [NSString stringWithFormat:@"%d",[[dic safeObjectForKey:InterHotel_LowRate] intValue]];
    priceAnnotation.truePrice   = [[dic safeObjectForKey:InterHotel_LowRate] intValue];
	priceAnnotation.starLevel	= [dic safeObjectForKey:InterHotel_Rating];
	priceAnnotation.index		= index;
	priceAnnotation.hotelid		= [NSString stringWithFormat:@"%@",[dic safeObjectForKey:InterHotel_HotelId]];
	[priceAnnotation setCoordinateStruct:r l:l];
	
	[self.mapAnnotations addObject:priceAnnotation];
	[priceAnnotation release];
}

//校正地图视野范围
-(void) centerMap{
    
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

//
- (void)addmark {
	if (!pinAnnotation) {
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = 0.;
		coordinate.longitude = 0.;
		
		// 普通查询时
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        
        if (searcher.latitude != 0 || searcher.longitude != 0) {
            // 有具体位置时，用其作为插杆点
            coordinate.latitude	 = searcher.latitude;
            coordinate.longitude = searcher.longitude;
        }
        else if ([mapAnnotations count] > 0) {
            // 以第一个价格标签的坐标作为默认的插杆点的坐标
            PriceAnnotation *firstAnnotation = [mapAnnotations safeObjectAtIndex:0];
            coordinate = firstAnnotation.coordinate;
        }
		
		[self addPinWithCoordinate:coordinate];
	}
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

// 搜索更多酒店
- (void)searchMoreHotel {
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    [searcher nextPage];
    
    if (moreHotelReq) {
        [moreHotelReq cancel];
        SFRelease(moreHotelReq);
    }
    
    moreHotelReq = [[HttpUtil alloc] init];
    
    [rootController setSwitchButtonActive:NO];
    [moreHotelReq connectWithURLString:INTER_SEARCH
                               Content:[searcher request]
                          StartLoading:NO
                            EndLoading:NO
                            AutoReload:YES
                              Delegate:self];
    
    [self addMapLoadingView];
    
    if (UMENG) {
        [MobClick event:Event_InterHotelList_More];
    }
}


// 显示小加载图标
- (void)addMapLoadingView {
    // loading
    if (!smallLoading) {
        smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 25, self.frame.size.height / 2 - 25, 50, 50)];
        [self addSubview:smallLoading];
        [smallLoading release];
    }

	[smallLoading startLoading];
}


// 移除小加载图标
- (void)removeMapLoadingView {
	[smallLoading stopLoading];
}

- (void) searchHotelByCoordinate:(CLLocationCoordinate2D)coordinate{
    [mapView removeAnnotations:mapAnnotations];
    
    if (poiHotelReq) {
        [poiHotelReq cancel];
        SFRelease(poiHotelReq);
    }
    
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    searcher.currentPage = 0;
    [searcher setCoordinateWithLatitude:coordinate.latitude withLongitude:coordinate.longitude withRadius:5.0 withName:@"当前位置"];
    
    poiHotelReq = [[HttpUtil alloc] init];
    
    [rootController setSwitchButtonActive:NO];
    [poiHotelReq  connectWithURLString:INTER_SEARCH
                               Content:[searcher request]
                          StartLoading:NO
                            EndLoading:NO
                            AutoReload:YES
                              Delegate:self];
    
    [self addMapLoadingView];
    
}


#pragma mark -
#pragma mark Actions
- (void) showDetails:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    InterHotelSearcher *interSearcher = [InterHotelSearcher shared];
    NSMutableDictionary *tmpDic = [interSearcher.hotelList safeObjectAtIndex:button.tag - INTERHOTEL_DETAIL_TAG];
    
    [tmpDic safeSetObject:interSearcher.checkInDate forKey:Req_ArriveDate];     //额外新增入离日期
    [tmpDic safeSetObject:interSearcher.checkOutDate forKey:Req_DepartureDate];
    InterHotelDetailCtrl *interDetail = [[InterHotelDetailCtrl alloc] initWithDataDic:tmpDic];
    [self.rootController.navigationController pushViewController:interDetail animated:YES];
    [interDetail release];
}

#pragma mark -
#pragma mark PublicMethods
- (void)goUserLocation {
	float zoomLevel = 0.05;
	MKCoordinateRegion currentRegion = mapView.region;
    CLLocationCoordinate2D userloacation = mapView.userLocation.location.coordinate;
    if (userloacation.longitude == 0 && userloacation.latitude == 0) {
        userloacation = [[PositioningManager shared] myCoordinate];
    }
	if (currentRegion.span.latitudeDelta > zoomLevel) {
		currentRegion = MKCoordinateRegionMake(userloacation, MKCoordinateSpanMake(zoomLevel,zoomLevel));
	}
    
	else {
		currentRegion = MKCoordinateRegionMake(userloacation, currentRegion.span);
	}
	[mapView setRegion:currentRegion animated:NO];
}

- (void)selectPin {
    //	float zoomLevel = 0.05;
    //	MKCoordinateRegion region = MKCoordinateRegionMake(pinAnnotation.coordinate,MKCoordinateSpanMake(zoomLevel,zoomLevel) );
    //	[mapView setRegion:[mapView regionThatFits:region] animated:NO];
	[mapView setCenterCoordinate:pinAnnotation.coordinate animated:NO];
	[mapView selectAnnotation:pinAnnotation animated:YES];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)map didAddAnnotationViews:(NSArray *)views {
	MKAnnotationView *pinView = [views safeObjectAtIndex:0];
    if ([pinView isKindOfClass:[MKPinAnnotationView class]]) {
        // 通过坐标搜索团购
        //[self searchHotelByCoordinate:pinAnnotation.coordinate];
    }
}

- (void)mapView:(MKMapView *)map annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
	if (MKAnnotationViewDragStateNone == newState) {
        // 通过坐标搜索团购
		[self searchHotelByCoordinate:annotationView.annotation.coordinate];
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
		
        if (!pinView){
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
	}else {
		static NSString *priceIdentifier = @"priceIdentifier";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:priceIdentifier];
		
		if (!annotationView){
            // 价格注解
			annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
														   reuseIdentifier:priceIdentifier] autorelease];
            annotationView.canShowCallout	= YES;
			annotationView.opaque			= NO;
            annotationView.frame			= CGRectMake(0, 0, 49, 35);
            
            UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, annotationView.frame.size.width, annotationView.frame.size.height)];
            bgImageView.tag = INTERHOTEL_PIN_BG_TAG;
            [annotationView addSubview:bgImageView];
            [bgImageView release];
            
            
			UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -4, annotationView.frame.size.width, 12)];
			priceLabel.font				= [UIFont systemFontOfSize:14];
			priceLabel.backgroundColor	= [UIColor clearColor];
			priceLabel.textColor		= [UIColor whiteColor];
			priceLabel.textAlignment	= UITextAlignmentCenter;
			priceLabel.tag				= INTERHOTEL_PIN_PRICE_TAG;
			priceLabel.adjustsFontSizeToFitWidth = YES;
			[annotationView addSubview:priceLabel];
			[priceLabel release];
            
			
            RatingView *ratingView = [[RatingView alloc] initWithFrame:CGRectMake(2, 15, annotationView.frame.size.width-4, 10) starColor:[UIColor whiteColor]];
            ratingView.tag = INTERHOTEL_PIN_STAR_TAG;
			[annotationView addSubview:ratingView];
			[ratingView release];
            
            
		}
        //get price
		UIImageView *bgImageView = (UIImageView *)[annotationView viewWithTag:INTERHOTEL_PIN_BG_TAG];
        bgImageView.image = [UIImage noCacheImageNamed:@"mapAnnotation_Icon.png"]; 
        
		
		UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		PriceAnnotation *ba = (PriceAnnotation *)annotation;
        rightButton.tag = ba.index + INTERHOTEL_DETAIL_TAG;
		[rightButton addTarget:self
						action:@selector(showDetails:)
			  forControlEvents:UIControlEventTouchUpInside];
		annotationView.rightCalloutAccessoryView = rightButton;
		
		UILabel *priceLabel = (UILabel *)[annotationView viewWithTag:INTERHOTEL_PIN_PRICE_TAG];
		priceLabel.text = [NSString stringWithFormat:@"¥%@",((PriceAnnotation *)annotation).priceStr];
		
		RatingView *starView = (RatingView *)[annotationView viewWithTag:INTERHOTEL_PIN_STAR_TAG];
        
        float rating = [((PriceAnnotation *)annotation).starLevel floatValue];
        [starView setRating:rating];

        
		if (rating < 1) {
			priceLabel.frame = CGRectMake(0, 3, annotationView.frame.size.width, 12);
		}
		else {
			priceLabel.frame = CGRectMake(0, 4, annotationView.frame.size.width, 12);
		}
        
        if (rating == 5 || rating == 4.5) {
            starView.frame = CGRectMake(2, 15, annotationView.frame.size.width-4, 10);
        }else if(rating == 4 || rating == 3.5){
            starView.frame = CGRectMake(7, 15, annotationView.frame.size.width-4, 10);
        }else if(rating == 3 || rating == 2.5){
            starView.frame = CGRectMake(12, 15, annotationView.frame.size.width-4, 10);
        }else if(rating == 2 || rating == 1.5){
            starView.frame = CGRectMake(17, 15, annotationView.frame.size.width - 4, 10);
        }else{
            starView.frame = CGRectMake(22, 15, annotationView.frame.size.width - 4, 10);
        }
		
		return annotationView;
	}
	
	return nil;
}


#pragma mark -
#pragma mark HttpResponse

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    [rootController setSwitchButtonActive:YES];
    [self removeMapLoadingView];
    
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]) {
        isRequstMore = NO;
        return ;
    }
    
    if (util == moreHotelReq) {
        // 请求更多酒店
        [rootController checkHotelFull];
        
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        NSArray *dataArray = [root safeObjectForKey:RespHL_HotelList_A];
        [searcher.hotelList addObjectsFromArray:dataArray];
        
        if (searcher.hotelList.count > 0) {
            searcher.countryId = [[searcher.hotelList safeObjectAtIndex:0] safeObjectForKey:@"CountryCode"];
            searcher.cityNameEn = [[searcher.hotelList safeObjectAtIndex:0] safeObjectForKey:@"CityEnName"];
        }
        
        // 更新数据过后，刷新表格与地图得显示
        [rootController refreshListData];
        
        isRequstMore = NO;
        
        [self addMoreData];
    }else if(util == poiHotelReq){
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        NSArray *dataArray = [root safeObjectForKey:RespHL_HotelList_A];
        [searcher.hotelList removeAllObjects];
        [searcher.hotelList addObjectsFromArray:dataArray];
        
        if (searcher.hotelList.count > 0) {
            searcher.countryId = [[searcher.hotelList safeObjectAtIndex:0] safeObjectForKey:@"CountryCode"];
            searcher.cityNameEn = [[searcher.hotelList safeObjectAtIndex:0] safeObjectForKey:@"CityEnName"];
        }
        
        // 更新数据过后，刷新表格与地图得显示
        [rootController resetListData];
        [self refreshMap];
        isRequstMore = NO;
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error {
    if (util == moreHotelReq) {
        isRequstMore = YES;
        [rootController restoreSearchMoreHotel];
        [rootController setSwitchButtonActive:YES];
        [self removeMapLoadingView];
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        [searcher prePage];
    }
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util {
    if (util == moreHotelReq) {
//        isRequstMore = YES;
//        [rootController restoreSearchMoreHotel];
//        [rootController setSwitchButtonActive:YES];
//        [self removeMapLoadingView];
    }
}

@end
