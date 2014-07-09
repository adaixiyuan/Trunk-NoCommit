    //
//  RoomMap.m
//  ElongClient
//
//  Created by bin xing on 11-1-6.
//  Copyright 2011 DP. All rights reserved.
//




#import "HotelMap.h"
#import "ScalableView.h"
#import "HotelDetailController.h"
#import "NSString+URLEncoding.h"
#import "StreetscapeViewController.h"

@interface HotelMap()
@property (nonatomic,retain) NSArray *routes_driving;
@property (nonatomic,retain) NSArray *routes_walking;
@property (nonatomic,retain) NSArray *steps_driving;
@property (nonatomic,retain) NSArray *steps_walking;
@property (nonatomic,retain) NSString *start_address;
@property (nonatomic,retain) NSString *end_address;
@property (nonatomic,retain) NSString *distance_walking;
@property (nonatomic,retain) NSString *distance_driving;
@property (nonatomic,retain) NSString *duration_walking;
@property (nonatomic,retain) NSString *duration_driving;
@property (nonatomic,assign) BOOL detailEnabled;
@end

@implementation HotelMap

@synthesize routes_driving;
@synthesize routes_walking;
@synthesize steps_driving;
@synthesize steps_walking;
@synthesize start_address;
@synthesize end_address;
@synthesize distance_walking;
@synthesize duration_walking;
@synthesize distance_driving;
@synthesize duration_driving;
@synthesize showAround = _showAround;
@synthesize hotelTitle;
@synthesize hotelSubtitle;
@synthesize hotelPhone;
@synthesize international;
@synthesize groupon;

- (void)dealloc {    
    [directionUtil cancel];
    [directionUtil release],directionUtil = nil;
    
    [poiUtil cancel];
    [poiUtil release],poiUtil = nil;
    
    [poiDict release];
    [poiAnnotations release];
    
    self.routes_driving = nil;
    self.routes_walking = nil;
    self.steps_driving = nil;
    self.steps_walking = nil;
    self.start_address = nil;
    self.end_address = nil;
    self.distance_walking = nil;
    self.duration_walking = nil;
    self.distance_driving = nil;
    self.duration_driving = nil;
    [super dealloc];
}

- (id) initWithFrame:(CGRect)frame latitude:(double) lat longitude:(double)lng{
    return [self initWithFrame:frame latitude:lat longitude:lng detailEnabled:NO];
}

- (id) initWithFrame:(CGRect)frame latitude:(double) lat longitude:(double)lng detailEnabled:(BOOL)detailEnabled{
    if (self = [super initWithFrame:frame]) {
        ccld.latitude= lat;
		ccld.longitude=lng;
        
        self.detailEnabled = detailEnabled;

        [self initMap];
        
        if (MONKEY_SWITCH){
            // 开启monkey时，地图屏蔽版权点击区域
            UIView *mapCover = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, 50, 30)];
            mapCover.backgroundColor = [UIColor clearColor];
            [self addSubview:mapCover];
            [mapCover release];
        }
    }
    return self;
}

- (void) initMap{
    // 显示周边
    _showAround = YES;
    
    // 设置地图的缩放级别
    float zoomLevel = 0.02;
    
    // 地图内部处理相关的地图委托
    self.delegate = self;
    
    // 地图显示区域
    MKCoordinateRegion region = MKCoordinateRegionMake(ccld,MKCoordinateSpanMake(zoomLevel,zoomLevel));
    [self setRegion:[self regionThatFits:region] animated:YES];
    
    // 酒店位置annotation
    hotelAnnotation = [[PriceAnnotation alloc] init];
    hotelAnnotation.coordinate = ccld;
    hotelAnnotation.hotelSpecialType = MapHome;
    [self addAnnotation:hotelAnnotation];
    [hotelAnnotation release];
    
    // 选中酒店位置
    [self performSelector:@selector(selectTheHotel:) withObject:hotelAnnotation afterDelay:0.7];
    
    // 获取当前的定位坐标
    currentld = [[PositioningManager shared] myCoordinate];
    
    
    // 导航
    NSArray *imageArray = [NSArray arrayWithObjects:@"nav_0.png",@"nav_1.png",@"nav_2.png", nil];
    NSArray *hightlightedImageArray = [NSArray arrayWithObjects:@"nav_0_l.png",@"nav_1_l.png",@"nav_2_l.png", nil];
    
    navScalableView = [[ScalableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 166, 70, 160, 45)
                                                   images:imageArray
                                        highlightedImages:hightlightedImageArray];
    [self addSubview:navScalableView];
    navScalableView.delegate = self;
    [navScalableView release];
    
    // 周边
    imageArray = [NSArray arrayWithObjects:@"poi_0.png",@"poi_1.png",@"poi_2.png",@"poi_3.png",@"poi_4.png",@"poi_5.png", nil];
    hightlightedImageArray = [NSArray arrayWithObjects:@"poi_0_l.png",@"poi_1_l.png",@"poi_2_l.png",@"poi_3_l.png",@"poi_4_l.png",@"poi_5_l.png", nil];
    poiScalableView = [[ScalableView alloc] initWithFrame:CGRectMake(8, 22, SCREEN_WIDTH-16, 45)
                                                   images:imageArray
                                        highlightedImages:hightlightedImageArray];
    [self addSubview:poiScalableView];
    poiScalableView.delegate = self;
    [poiScalableView release];
    
    // 默认展开周边
    [poiScalableView moveOut];
    
    // 分段导航容器
    stepsContentView = [[UIView alloc] initWithFrame:CGRectMake(0, -(STEPTVHEIGHT + 20) - 10, SCREEN_WIDTH, STEPTVHEIGHT + 20)];
    [self addSubview:stepsContentView];
    [stepsContentView release];
    
    navTipsView = [[UIView alloc] initWithFrame:CGRectMake(0, stepsContentView.frame.size.height - 20, SCREEN_WIDTH, 20)];
    navTipsView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    
    UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    expandBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    [navTipsView addSubview:expandBtn];
    //[expandBtn addTarget:self action:@selector(expandStepsView:) forControlEvents:UIControlEventTouchUpInside];
    
    [stepsContentView addSubview:navTipsView];
    [navTipsView release];
    
    UILabel *tipslbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    tipslbl.font = [UIFont systemFontOfSize:14.0f];
    tipslbl.textColor = [UIColor whiteColor];
    tipslbl.tag = TIPSLBL;
    tipslbl.backgroundColor = [UIColor clearColor];
    tipslbl.textAlignment = UITextAlignmentCenter;
    [navTipsView addSubview:tipslbl];
    [tipslbl release];
    
    
    
    stepsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, STEPTVHEIGHT)];
    stepsTableView.rowHeight = 40;
    stepsTableView.delegate = self;
    stepsTableView.dataSource = self;
    
    
    
    [stepsContentView addSubview:stepsTableView];
    [stepsTableView release];
    //
    
    poiDict = [[NSMutableDictionary alloc] initWithCapacity:5];
    poiIndex = -1;
    poiAnnotations = [[NSMutableArray alloc] init];
}



// 是否显示周边查询
- (void) setShowAround:(BOOL)showAround{
    _showAround = showAround;
    if (_showAround) {
        
    }else{
        [poiScalableView removeFromSuperview];
        poiScalableView = nil;
    
        navScalableView.frame = CGRectMake(SCREEN_WIDTH - 166, 22, 160, 45);
    }
}

// 设置大头针title
- (void) setHotelTitle:(NSString *)hotelTitle_{
    hotelAnnotation.title = hotelTitle_;
}

- (NSString *) hotelTitle{
    return hotelAnnotation.title;
}

// 设置大头针subtitle
- (void) setHotelSubtitle:(NSString *)hotelSubtitle_{
    hotelAnnotation.subtitle = hotelSubtitle_;
}

- (NSString *) hotelSubtitle{
    return hotelAnnotation.subtitle;
}

- (void) expandStepsView:(id)sender{
    if (stepsContentView.frame.origin.y == 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        stepsContentView.frame = CGRectMake(0, -STEPTVHEIGHT, SCREEN_WIDTH, STEPTVHEIGHT + 20);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        stepsContentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, STEPTVHEIGHT + 20);
        [UIView commitAnimations];
    }
}


- (void)selectTheHotel:(PriceAnnotation *)annotion {
	[self selectAnnotation:annotion animated:YES];
}


// 显示导航模式选择框
- (void)showalert{
    UIActionSheet* chooseSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"显示路线", @"导航(离开应用)", nil];
    [chooseSheet showInView:self];
    chooseSheet.tag = 102;
    [chooseSheet release];
    
}

// 地图导航方式
- (void)gotonextstep:(int)_index{
    if (_index==1) {
        double latitude ;
        double longitude ;
        
        latitude = ccld.latitude;
		longitude = ccld.longitude;
        
        
        if (latitude != 0 || longitude != 0) {
            [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(latitude, longitude) title:hotelAnnotation.title];
        }
        else {
            // 酒店没有坐标时用酒店地址导航
            [PublicMethods pushToMapWithDestName:[[HotelDetailController hoteldetail] safeObjectForKey:ADDRESS_GROUPON]];
        }
	}
    else if (_index==0){
        [self searchDirectionWithLoading:NO];
    }
}


// soso街景地图
- (void) showDetails:(id)sender{
    //ccld
    if ([self.hotelMapDelegate respondsToSelector:@selector(hotelMapShowDetail:position:hotelName:)]) {
        [self.hotelMapDelegate hotelMapShowDetail:self position:ccld hotelName:self.hotelTitle];
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self gotonextstep:buttonIndex];
}

#pragma mark -
#pragma mark ScalableViewDelegate
- (void) scalableViewDidMoveout:(ScalableView *)scalableView{
    if (scalableView == navScalableView) {
        [poiScalableView moveBack];
    }else if(scalableView == poiScalableView){
        [navScalableView moveBack];
    }
}

- (void) scalableView:(ScalableView *)scalableView didSelectedAtIndex:(NSInteger)index{
    if (scalableView == navScalableView){
        [scalableView moveBack];
    }
    if (navScalableView == scalableView) {
        [poiScalableView moveBack];
        if (index == 0) {
            // 驾车
            travelMode = Driving;
            if (UMENG && self.groupon) {
                //团购酒店地图点击驾车
                [MobClick event:Event_GrouponHotelMap_Nav_Car];
            }else if(UMENG && self.international){
                //国际酒店地图点击驾车
                [MobClick event:Event_InterHotelMap_Nav_Car];
            }else if(UMENG){
                // 酒店地图点击驾车
                [MobClick event:Event_HotelMap_Nav_Car];
                UMENG_EVENT(UEvent_Hotel_Detail_MapDrive)
            }
                        
            [self showalert];
        }else{
            // 步行
            travelMode = Walking;
            if (UMENG && self.groupon) {
                //团购酒店地图点击步行
                [MobClick event:Event_GrouponHotelMap_Nav_Walk];
            }else if(UMENG && self.international){
                //国际酒店地图点击步行
                [MobClick event:Event_InterHotelMap_Nav_Walk];
            }else if (UMENG) {
                // 酒店地图点击驾车
                [MobClick event:Event_HotelMap_Nav_Walk];
                UMENG_EVENT(UEvent_Hotel_Detail_MapWalk)
            }
            
            if (!routes_walking) {
                [self searchDirectionWithLoading:NO];
            }else{
                [self updateRouteView];
            }
        }
        
    }else if(poiScalableView == scalableView){
        poiIndex = index;
        NSString *key = [NSString stringWithFormat:@"%d",index];
        NSObject *obj = [poiDict safeObjectForKey:key];
        if (obj && obj != [NSNull null]) {
            [self updatePoiView];
        }else{
            switch (index) {
                case 0:{
                    if (self.international) {
                        [self searchPoiByGoogleKeyword:@"bank"];
                    }else{
                        [self searchPoiWithLoading:NO keyword:@"银行"];
                        if (UMENG && self.groupon) {
                            //团购酒店地图点击银行
                            [MobClick event:Event_GrouponHotelMap_Bank];
                        }else if(UMENG && self.international){
                            // 国际酒店地图点击银行
                            [MobClick event:Event_InterHotelMap_Bank];
                        }else if (UMENG) {
                            // 酒店地图点击银行
                            [MobClick event:Event_HotelMap_Bank];
                            UMENG_EVENT(UEvent_Hotel_Detail_MapBank)
                        }
                    }
                    break;
                }
                case 1:{
                    if (self.international) {
                        [self searchPoiByGoogleKeyword:@"park"];
                    }else{
                        [self searchPoiWithLoading:NO keyword:@"景点"];
                        if (UMENG && self.groupon) {
                            //团购酒店地图点击景区
                            [MobClick event:Event_GrouponHotelMap_Scenic];
                        }else if(UMENG && self.international){
                            //国际酒店地图点击景区
                            [MobClick event:Event_InterHotelMap_Scenic];
                        }else if(UMENG){
                            //酒店地图点击景区
                            [MobClick event:Event_HotelMap_Scenic];
                            UMENG_EVENT(UEvent_Hotel_Detail_MapScenery)
                        }
                    }
                    break;
                }
                case 2:{
                    if (self.international) {
                        [self searchPoiByGoogleKeyword:@"food"];
                    }else{
                        [self searchPoiWithLoading:NO keyword:@"餐饮"];
                        if (UMENG && self.groupon) {
                            //团购酒店地图点击美食
                            [MobClick event:Event_GrouponHotelMap_Cate];
                        }else if(UMENG && self.international){
                            // 国际酒店地图点击美食
                            [MobClick event:Event_InterHotelMap_Cate];
                        }else if (UMENG) {
                            // 酒店地图点击美食
                            [MobClick event:Event_HotelMap_Cate];
                            UMENG_EVENT(UEvent_Hotel_Detail_MapFood)
                        }
                    }
                    
                    break;
                }
                case 3:{
                    if (self.international) {
                        [self searchPoiByGoogleKeyword:@"shopping_mall"];
                    }else{
                        [self searchPoiWithLoading:NO keyword:@"购物"];
                        if (UMENG && self.groupon) {
                            //团购酒店地图点击购物
                            [MobClick event:Event_GrouponHotelMap_Shopping];
                        }else if(UMENG && self.international){
                            // 国际酒店地图点击购物
                            [MobClick event:Event_InterHotelMap_Shopping];
                        }else if (UMENG) {
                            // 酒店地图点击购物
                            [MobClick event:Event_HotelMap_Shopping];
                            UMENG_EVENT(UEvent_Hotel_Detail_MapShopping)
                        }
                    }
                    break;
                }
                case 4:{
                    if (self.international) {
                        [self searchPoiByGoogleKeyword:@"night_club"];
                    }else{
                        [self searchPoiWithLoading:NO keyword:@"娱乐"];
                        if (UMENG && self.groupon) {
                            //团购酒店地图点击娱乐
                            [MobClick event:Event_GrouponHotelMap_Entertainment];
                        }else if(UMENG && self.international){
                            // 国际酒店地图点击娱乐
                            [MobClick event:Event_InterHotelMap_Entertainment];
                        }else if (UMENG) {
                            // 酒店地图点击娱乐
                            [MobClick event:Event_HotelMap_Entertainment];
                            UMENG_EVENT(UEvent_Hotel_Detail_MapEntertainment)
                        }
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation_ {
	// If it's the user location, just return nil.
	if ([annotation_ isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
	
	// Handle any custom annotations.
    if ([annotation_ isKindOfClass:[PriceAnnotation class]]) {
		static NSString *PriceIdentifier = @"PriceIdentifier";
        MKAnnotationView* pinView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:PriceIdentifier];
		PriceAnnotation *annotation = (PriceAnnotation *)annotation_;
        if (!pinView){
			// 大头针注解
			pinView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PriceIdentifier] autorelease];
            pinView.canShowCallout  = YES;
			pinView.opaque			= NO;
            pinView.frame			= CGRectMake(0, 0, 32, 38);
		}
		else {
			pinView.annotation = annotation;
		}
        
        /*
         {
         pinView.image			= [UIImage imageNamed:@"maphome_pin.png"];
         break;
         }
         */
       
		switch (annotation.hotelSpecialType) {
            case MapHome:
            case StartPoint:{
                static NSString *PinIdentifier = @"PinIdentifier";
                MKPinAnnotationView* pinView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
                
                if (!pinView){
                    // 大头针注解
                    MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                                           reuseIdentifier:PinIdentifier] autorelease];
                    annotationView.canShowCallout = YES;
                    annotationView.animatesDrop = YES;
                    if (annotation.hotelSpecialType == MapHome) {
                        annotationView.pinColor = MKPinAnnotationColorRed;
                    }else{
                        annotationView.pinColor = MKPinAnnotationColorGreen;
                    }
                    
                    if (self.detailEnabled) {
                        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        rightButton.frame = CGRectMake(0, 0, 30, 40);
                        [rightButton setImage:[UIImage noCacheImageNamed:@"streetscale_icon.png"] forState:UIControlStateNormal];
                        [rightButton setTitle:self.hotelTitle forState:UIControlStateNormal];
                        [rightButton addTarget:self
                                        action:@selector(showDetails:)
                              forControlEvents:UIControlEventTouchUpInside];
                        annotationView.rightCalloutAccessoryView = rightButton;
                    }
                   
                    
                    return annotationView;
                }
                else {
                    pinView.annotation = annotation;
                }
                
                return pinView;
                break;
            }
            case Bank:{
                pinView.image			= [UIImage imageNamed:@"poi_bank.png"];
                break;
            }
            case Sight:{
                pinView.image			= [UIImage imageNamed:@"poi_sight.png"];
                break;
            }
            case Cate:{
                pinView.image			= [UIImage imageNamed:@"poi_cate.png"];
                break;
            }
            case Shopping:{
                pinView.image			= [UIImage imageNamed:@"poi_shopping.png"];
                break;
            }
            case Entertainment:{
                pinView.image			= [UIImage imageNamed:@"poi_entertainment.png"];
                break;
            }
            default:
                break;
        }
       
        
		return pinView;
	}	
	return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]]){
    
        MKPolylineView *lineview = [[MKPolylineView alloc] initWithOverlay:overlay] ;
        //路线颜色
        lineview.strokeColor = MAPROUTECOLOR;
        lineview.lineWidth = 10.0;
        return [lineview autorelease];
    }
    return nil;
}



#pragma mark -
#pragma mark network back data
- (void) searchDirectionWithLoading:(BOOL)loading{    
    NSString *postString = nil;
    CLLocationCoordinate2D userloacation =self.userLocation.location.coordinate;
    
    postString = [NSString stringWithFormat:@"%@?from=nav&latOrigin=%f&lngOrgin=%f&latDes=%f&lngDes=%f&mode=%@",
                  AUTONAVI,
                  userloacation.latitude,
                  userloacation.longitude,
                  ccld.latitude,
                  ccld.longitude,
                  (travelMode == Driving?@"driving":@"walking")];
    
    [self searchDirectionWithURLString:postString];

}

- (void) searchPoiWithLoading:(BOOL)loading keyword:(NSString *)keyworkd{
    NSString *postString = nil;
    postString = [NSString stringWithFormat:@"%@?from=poi&lat=%f&lng=%f&keyword=%@",
                  AUTONAVI,
                  ccld.latitude,
                  ccld.longitude,
                  keyworkd];
    
    [self searchPoiWithURLString:postString];

}

- (void) searchPoiByGoogleKeyword:(NSString *)keyword{
    NSString *postString = nil;
    
    postString = [NSString stringWithFormat:@"%@?from=poi_g&lat=%f&lng=%f&keyword=%@",
                  AUTONAVI,
                  ccld.latitude,
                  ccld.longitude,
                  keyword];
    
    
    [self searchPoiWithURLString:postString];
}

- (void)searchPoiWithURLString:(NSString *)url{
    
    NSString *getUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (USENEWNET) {
        if (poiUtil) {
            [poiUtil cancel];
            SFRelease(poiUtil);
        }
        
        
        poiUtil = [[HttpUtil alloc] init];
        [poiUtil connectWithURLString:getUrl
                              Content:nil
                         StartLoading:NO
                           EndLoading:NO
                             Delegate:self];
    }
    
    // 网络加载符
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}

- (void) searchDirectionWithURLString:(NSString *)url{
    
    NSString *getUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (USENEWNET) {
        if (directionUtil) {
            [directionUtil cancel];
            SFRelease(directionUtil);
        }
        
        
        directionUtil = [[HttpUtil alloc] init];
        [directionUtil connectWithURLString:getUrl
                               Content:nil
                          StartLoading:NO
                            EndLoading:NO
                              Delegate:self];
    }
    
    // 网络加载符
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}

- (void) dealWithPoiResult:(NSDictionary *)root{
    NSObject *listObj = nil;
    if (self.international) {
        listObj = [root safeObjectForKey:@"results"];
    }else{
        listObj = [root safeObjectForKey:@"list"];
    }
    if (listObj && listObj != [NSNull null]) {
        NSArray *listArray = (NSArray *)listObj;
        if ([listArray count] > 0) {
            [poiDict safeSetObject:listArray forKey:[NSString stringWithFormat:@"%d",poiIndex]];
        }else{
            [poiDict safeSetObject:[NSNull null] forKey:[NSString stringWithFormat:@"%d",poiIndex]];
        }
    }else{
        [poiDict safeSetObject:[NSNull null] forKey:[NSString stringWithFormat:@"%d",poiIndex]];
    }
    [self updatePoiView];
}



- (void) dealWithDirectionResult:(NSDictionary *)root{
    NSObject *routesObj = [root safeObjectForKey:@"routes"];
    NSObject *listObj = [root safeObjectForKey:@"list"];
    if (routesObj && routesObj != [NSNull null]) {
        mapDataFrom = GoogleMap;
    }else{
        
        if (listObj && listObj != [NSNull null]) {
            mapDataFrom = AutoNavi;
        }else{
            mapDataFrom = EmptyMapData;
        }
    }
    
    if (mapDataFrom == GoogleMap) {
        NSArray *routesArray = (NSArray *)routesObj;
        NSString *routesOK = (NSString *)[root safeObjectForKey:@"status"];
        // 取得正常数据的情况下
        if ([routesArray count] > 0 && [routesOK isEqualToString:@"OK"]) {
            NSString* encodedPoints = [[[routesArray safeObjectAtIndex:0] safeObjectForKey:@"overview_polyline"] safeObjectForKey:@"points"];
            NSMutableString *mencodePoints = [NSMutableString stringWithString:encodedPoints];
            CLLocationCoordinate2D userloacation =self.userLocation.location.coordinate;

            if (travelMode == Walking) {
                self.routes_walking = [self decodePolyLine:mencodePoints:userloacation to:ccld];
            }else if(travelMode == Driving){
                self.routes_driving = [self decodePolyLine:mencodePoints:userloacation to:ccld];
            }
            
            
            NSArray *legs = (NSArray *)[[routesArray safeObjectAtIndex:0] safeObjectForKey:@"legs"];
            
            if ([legs count] > 0) {
                self.start_address = (NSString *)[[legs safeObjectAtIndex:0] safeObjectForKey:@"start_address"];
                self.end_address = (NSString *)[[legs safeObjectAtIndex:0] safeObjectForKey:@"end_address"];
                start_location.longitude = [[[[legs safeObjectAtIndex:0] safeObjectForKey:@"start_location"] safeObjectForKey:@"lng"] doubleValue];
                start_location.latitude = [[[[legs safeObjectAtIndex:0] safeObjectForKey:@"start_location"] safeObjectForKey:@"lat"] doubleValue];
                end_location.longitude = [[[[legs safeObjectAtIndex:0] safeObjectForKey:@"end_location"] safeObjectForKey:@"lng"] doubleValue];
                end_location.latitude = [[[[legs safeObjectAtIndex:0] safeObjectForKey:@"end_location"] safeObjectForKey:@"lat"] doubleValue];
                if (travelMode == Walking) {
                    self.distance_walking = (NSString *)[[[legs safeObjectAtIndex:0] safeObjectForKey:@"distance"] safeObjectForKey:@"text"];
                    self.duration_walking = (NSString *)[[[legs safeObjectAtIndex:0] safeObjectForKey:@"duration"] safeObjectForKey:@"text"];
                    self.steps_walking = [self decodeSteps:[[legs safeObjectAtIndex:0] safeObjectForKey:@"steps"]];
                }else if(travelMode == Driving){
                    self.distance_driving = (NSString *)[[[legs safeObjectAtIndex:0] safeObjectForKey:@"distance"] safeObjectForKey:@"text"];
                    self.duration_driving = (NSString *)[[[legs safeObjectAtIndex:0] safeObjectForKey:@"duration"] safeObjectForKey:@"text"];
                    self.steps_driving = [self decodeSteps:[[legs safeObjectAtIndex:0] safeObjectForKey:@"steps"]];
                }
            }
            
            [self updateRouteView];
            
        }
        
    }
}


#pragma mark -
#pragma adjust mapview to routes
-(void) centerMap {
    
	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
    int count = (travelMode == Walking?routes_walking.count : routes_driving.count);
	for(int idx = 0; idx < count; idx++)
	{
        CLLocation* currentLocation;
        if (travelMode == Walking) {
            currentLocation = [routes_walking safeObjectAtIndex:idx];
        }else{
            currentLocation = [routes_driving safeObjectAtIndex:idx];
        }
		 
		if(currentLocation.coordinate.latitude > maxLat)
			maxLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.latitude < minLat)
			minLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.longitude > maxLon)
			maxLon = currentLocation.coordinate.longitude;
		if(currentLocation.coordinate.longitude < minLon)
			minLon = currentLocation.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + 0.018;
	region.span.longitudeDelta = maxLon - minLon + 0.018;
    
	[self setRegion:region animated:YES];
}

- (void) centerPoiMap{
    MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
    NSString *key = [NSString stringWithFormat:@"%d",poiIndex];
    NSObject *obj = [poiDict safeObjectForKey:key];
    if (!obj || obj == [NSNull null]) {
        return;
    }
    NSArray *poiArray = (NSArray *)obj;
    
    int count = poiArray.count;
	for(int idx = 0; idx < count; idx++)
	{
        NSDictionary *dict = (NSDictionary *)[poiArray safeObjectAtIndex:idx];
        
        CLLocationCoordinate2D coordinate;
        if (self.international) {
            coordinate.latitude = [[[[dict safeObjectForKey:@"geometry"] safeObjectForKey:@"location"] safeObjectForKey:@"lat"] doubleValue];
            coordinate.longitude = [[[[dict safeObjectForKey:@"geometry"] safeObjectForKey:@"location"] safeObjectForKey:@"lng"] doubleValue];
        }else{
            coordinate.latitude = [[dict safeObjectForKey:@"y"] doubleValue];
            coordinate.longitude = [[dict safeObjectForKey:@"x"] doubleValue];
        }
        
        
		if(coordinate.latitude > maxLat)
			maxLat = coordinate.latitude;
		if(coordinate.latitude < minLat)
			minLat = coordinate.latitude;
		if(coordinate.longitude > maxLon)
			maxLon = coordinate.longitude;
		if(coordinate.longitude < minLon)
			minLon = coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat;// + 0.008;
	region.span.longitudeDelta = maxLon - minLon;// + 0.008;
    
	[self setRegion:region animated:YES];
}

- (void) updatePoiView{
    // 移除地图的其它无用标记
    [self removeOverlays:self.overlays];
    if (currentAnnotation) {
        [self removeAnnotation:currentAnnotation],currentAnnotation = nil;
    }
    
    if ([poiAnnotations count] > 0) {
        [self removeAnnotations:poiAnnotations];
        [poiAnnotations removeAllObjects];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    stepsContentView.frame = CGRectMake(0, -STEPTVHEIGHT - 20, SCREEN_WIDTH, STEPTVHEIGHT + 20);
    [UIView commitAnimations];
    
    
    NSString *key = [NSString stringWithFormat:@"%d",poiIndex];
    NSObject *obj = [poiDict safeObjectForKey:key];
    if (obj && obj != [NSNull null]) {
        NSArray *listArray = (NSArray *)obj;
        for (int i = 0; i < [listArray count]; i++) {
            NSDictionary *dict = (NSDictionary *)[listArray safeObjectAtIndex:i];
            PriceAnnotation *annotation = [[PriceAnnotation alloc] init];
            
            CLLocationCoordinate2D coordinate;
            if (self.international) {
                coordinate.latitude = [[[[dict safeObjectForKey:@"geometry"] safeObjectForKey:@"location"] safeObjectForKey:@"lat"] doubleValue];
                coordinate.longitude = [[[[dict safeObjectForKey:@"geometry"] safeObjectForKey:@"location"] safeObjectForKey:@"lng"] doubleValue];
                annotation.title = [dict safeObjectForKey:@"name"];
                annotation.subtitle = [dict safeObjectForKey:@"vicinity"];
            }else{
                coordinate.latitude = [[dict safeObjectForKey:@"y"] doubleValue];
                coordinate.longitude = [[dict safeObjectForKey:@"x"] doubleValue];
                annotation.title = [dict safeObjectForKey:@"name"];
                annotation.subtitle = [dict safeObjectForKey:@"address"];
            }
            annotation.coordinate = coordinate;
            
            switch (poiIndex) {
                case 0:{
                    annotation.hotelSpecialType = Bank;
                    break;
                }
                case 1:{
                    annotation.hotelSpecialType = Sight;
                    break;
                }
                case 2:{
                    annotation.hotelSpecialType = Cate;
                    break;
                }
                case 3:{
                    annotation.hotelSpecialType = Shopping;
                    break;
                }
                case 4:{
                    annotation.hotelSpecialType = Entertainment;
                    break;
                }
                default:
                    break;
            }
            [self addAnnotation:annotation];
            [annotation release];
            
            [poiAnnotations addObject:annotation];
        }
    }
    
    // 调整地图视野
    [self centerPoiMap];
}

-(void) updateRouteView {
    [self removeOverlays:self.overlays];
    
    if ([poiAnnotations count] > 0) {
        [self removeAnnotations:poiAnnotations];
        [poiAnnotations removeAllObjects];
    }
    
    
    // 导航开始位置annotation
    if (!currentAnnotation) {
        currentAnnotation = [[PriceAnnotation alloc] init];
        currentAnnotation.hotelSpecialType = StartPoint;
        [self addAnnotation:currentAnnotation];
        [currentAnnotation release];
    }
    
    currentAnnotation.coordinate = start_location;
    currentAnnotation.title = start_address;
    
    // 导航终止位置annotation
    hotelAnnotation.coordinate = end_location;
    //hotelAnnotation.title = end_address;
    //hotelAnnotation.subtitle = nil;
    
    [stepsTableView reloadData];
    
    // 导航信息提示
    UILabel *tipslbl = (UILabel *)[navTipsView viewWithTag:TIPSLBL];
    tipslbl.text = [NSString stringWithFormat:@"%@约%@，耗时约%@",(travelMode==Walking?@"步行":@"驾车"),(travelMode==Walking?distance_walking:distance_driving),(travelMode==Walking?duration_walking:duration_driving)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    stepsContentView.frame = CGRectMake(0, -STEPTVHEIGHT, SCREEN_WIDTH, STEPTVHEIGHT + 20);
    [UIView commitAnimations];
    
    int count = (travelMode == Walking?routes_walking.count : routes_driving.count);
    CLLocationCoordinate2D pointsToUse[count];
    
    for (int i = 0; i < count; i++) {
        CLLocationCoordinate2D coords;
        CLLocation *loc;
        if (travelMode == Walking) {
            loc = [routes_walking safeObjectAtIndex:i];
        }else{
            loc = [routes_driving safeObjectAtIndex:i];
        }

        coords.latitude = loc.coordinate.latitude;
        coords.longitude = loc.coordinate.longitude;
        pointsToUse[i] = coords;
    }
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:count];
    [self addOverlay:lineOne];
    
    
    // 调整地图视野
    [self centerMap];
}


-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D) t {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
            if (index >= len) {
                break;
            }
            
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
            if (index >= len) {
                break;
            }
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[[NSNumber alloc] initWithFloat:lat * 1e-5] autorelease];
		NSNumber *longitude = [[[NSNumber alloc] initWithFloat:lng * 1e-5] autorelease];
		printf("[%f,", [latitude doubleValue]);
		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] autorelease];
		[array addObject:loc];
	}
    CLLocation *first = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:f.latitude] floatValue] longitude:[[NSNumber numberWithFloat:f.longitude] floatValue] ] autorelease];
//    CLLocation *end = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:t.latitude] floatValue] longitude:[[NSNumber numberWithFloat:t.longitude] floatValue] ] autorelease];
	[array insertObject:first atIndex:0];
//    [array addObject:end];
	return array;
}


- (NSMutableArray *) decodeSteps:(NSArray *)stepsArray{
    NSMutableArray *stepsMArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [mdict safeSetObject:@"起点位置" forKey:@"tips"];
    [mdict safeSetObject:start_address forKey:@"title"];
    [stepsMArray addObject:mdict];
    [mdict release];
    
    for (int i = 0; i < [stepsArray count]; i++) {
        NSDictionary *dict = (NSDictionary *)[stepsArray safeObjectAtIndex:i];
        mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (travelMode == Walking) {
            [mdict setObject:[NSString stringWithFormat:@"步行%@，耗时%@",
                              [[dict safeObjectForKey:@"distance"] safeObjectForKey:@"text"],
                              [[dict safeObjectForKey:@"duration"] safeObjectForKey:@"text"]]
                      forKey:@"tips"];
        }else{
            [mdict setObject:[NSString stringWithFormat:@"行驶%@，耗时%@",
                              [[dict safeObjectForKey:@"distance"] safeObjectForKey:@"text"],
                              [[dict safeObjectForKey:@"duration"] safeObjectForKey:@"text"]]
                      forKey:@"tips"];
        }
        NSString *html_instructions = (NSString *)[dict safeObjectForKey:@"html_instructions"];
        NSString *regEx = @"<([^>]*)>";
        html_instructions = [html_instructions stringByReplacingOccurrencesOfRegex:regEx withString:@""];
        [mdict safeSetObject:html_instructions forKey:@"title"];
        
        [stepsMArray addObject:mdict];
        [mdict release];
    }
    mdict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [mdict safeSetObject:@"终点位置" forKey:@"tips"];
    [mdict safeSetObject:end_address forKey:@"title"];
    [stepsMArray addObject:mdict];
    [mdict release];
    
    return [stepsMArray autorelease];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (travelMode == Driving) {
        if (steps_driving) {
            return [steps_driving count];
        }else{
            return 0;
        }
    }else{
        if (steps_walking) {
            return [steps_walking count];
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"StepCell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"StepCell"] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict;
    if (travelMode == Driving) {
        dict = (NSDictionary *)[steps_driving safeObjectAtIndex:indexPath.row];
    }else{
        dict = (NSDictionary *)[steps_walking safeObjectAtIndex:indexPath.row];
    }
   
    cell.textLabel.text = [dict safeObjectForKey:@"title"];
    cell.detailTextLabel.text = [dict safeObjectForKey:@"tips"];
    return cell;
}


#pragma mark -
#pragma mark NetLink
#pragma mark onPostConnect & onPostConnect

- (void)httpConnectionDidCanceled:(HttpUtil *)util{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = nil;
    if (util == directionUtil || util == poiUtil) {
        NSString *outStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        root = [outStr JSONValue];
        [outStr release];
    }    
	if(util == directionUtil){
        [self dealWithDirectionResult:root];
    }else if(util == poiUtil){
        [self dealWithPoiResult:root];
    }
    
    
    // 网络加载符
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}



@end
