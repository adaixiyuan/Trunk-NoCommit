//
//  GrouponMapView.m
//  ElongClient
//
//  Created by 赵 海波 on 12-3-22.
//  Copyright 2012 elong. All rights reserved.
//

#import "GrouponMapView.h"
#import "GrouponHomeViewController.h"
#import "GrouponDetailViewController.h"
#import "PositioningManager.h"
#import "DefineHotelResp.h"
#import "GListRequest.h"

#define MAP_ZOOM_LEVEL			0.2

#define HOTELLIST		0
#define HOTELDETAIL		1

#define PRICELABELTAG	2222
#define STARLABELTAG	3333


@implementation GrouponMapView

@synthesize mapView;


- (void)dealloc {
	rootCtr = nil;
	mapView.delegate = nil;
    
    [moreHotelUtil cancel];
    SFRelease(moreHotelUtil);
	
	[mapView		release];
	[mapAnnotations release];
	[smallLoading	release];
	[mapAnnotationDic release];
	[noDataTipLabel release];
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame Root:(GrouponHomeViewController *)root {
    self = [super initWithFrame:frame];
    if (self) {
		rootCtr = root;
		
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44)];
		[self addSubview:mapView];
		
		mapAnnotations = [[NSMutableArray alloc] initWithCapacity:2];
		mapAnnotationDic = [[NSMutableDictionary alloc] initWithCapacity:2];
		
		mapView.delegate			= self;
		mapView.showsUserLocation	= YES;
		
		noDataTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, MAINCONTENTHEIGHT / 2 - 40, 280, 40)];
		noDataTipLabel.backgroundColor	= [UIColor whiteColor];
		noDataTipLabel.text				= @"未找到酒店位置信息";
		noDataTipLabel.textAlignment	= UITextAlignmentCenter;
		noDataTipLabel.font				= [UIFont boldSystemFontOfSize:16];
		noDataTipLabel.hidden			= YES;
		[self addSubview:noDataTipLabel];
		
		[self performSelector:@selector(resetAnnotations)];
    }
	
    return self;
}


#pragma mark -
#pragma mark Private Method

- (void)addAnnotationFromDictionary:(NSDictionary *)dic {
	int index = [mapAnnotations count];
	
	NSMutableArray *hotelsArray = [NSMutableArray arrayWithCapacity:2];		// 记录与团购对应的所有酒店
	for (NSDictionary *paramDic in [dic objectForKey:HOTELDETAILINFOS_RESP]) {
		// 一个酒店可能具有多家分店
		double r = 0;
		double l = 0;
		
		if (![[paramDic objectForKey:RespHL__Latitude_D] isEqual:[NSNull null]]) {
			r = [[paramDic objectForKey:RespHL__Latitude_D] doubleValue]; 
		}
		
		if (![[paramDic objectForKey:RespHL__Longitude_D] isEqual:[NSNull null]]) {
			l = [[paramDic objectForKey:RespHL__Longitude_D] doubleValue];
		}
		
		if (r != 0 && l != 0) {
			// 没有坐标值的不显示
			NSString *titlestring = [NSString stringWithFormat:@"%@",[dic objectForKey:PRODNAME_GROUPON]];
			NSString *hoteladress = [NSString stringWithFormat:@"区域：%@",[paramDic objectForKey:BIZSECTIONNAME_RESP]];
			
			PriceAnnotation *priceAnnotation	= [[PriceAnnotation alloc] init];
			priceAnnotation.title				= titlestring;
			priceAnnotation.subtitle			= hoteladress;
			
			NSString *starStr = @"";
			// 酒店星级
			if (![[paramDic objectForKey:STAR_RESP] isEqual:[NSNull null]]) {
				int starlevel = [[paramDic objectForKey:STAR_RESP] intValue];
				if (starlevel < 3) {
					starlevel = 0;
				}else if (starlevel > 5) {
					starlevel = 5;
				}
				
				switch (starlevel) {
					case 0:
						starStr = @"";
						break;
					case 1:
						starStr = @"★";
						break;
					case 2:
						starStr = @"★★";
						break;
					case 3:
						starStr = @"★★★";
						break;
					case 4:
						starStr = @"★★★★";
						break;
					case 5:
						starStr = @"★★★★★";
						break;
					default:
						break;
				}		
			}
			
			priceAnnotation.priceStr	= [NSString stringWithFormat:@"¥%.f",[[dic objectForKey:SALEPRICE_GROUPON] doubleValue]];
			priceAnnotation.starLevel	= starStr;
			priceAnnotation.index		= index + 1;
			priceAnnotation.hotelid		= [NSString stringWithFormat:@"%@", [dic objectForKey:PRODID_GROUPON]];
			[priceAnnotation setCoordinateStruct:r l:l];
			
			[mapAnnotations addObject:priceAnnotation];
			[hotelsArray addObject:priceAnnotation];
			[priceAnnotation release];
		}
	}
	
	[mapAnnotationDic setObject:hotelsArray forKey:[dic objectForKey:PRODID_GROUPON]];
}


- (void)addMapLoadingView {
	if (!smallLoading) {
		smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake(135, (self.frame.size.height-50) / 2, 50, 50)];
		[self addSubview:smallLoading];
	}
	
	[smallLoading startLoading];
}


- (void)addMapAnnotations:(NSArray *)annotations {
	for (NSDictionary *hotel in annotations) {
		[self addAnnotationFromDictionary:hotel];
	}

    [mapView addAnnotations:mapAnnotations];
	
	if ([mapAnnotations count] <= 0) {
		// 没有数据不显示地图
		mapView.hidden = YES;
		noDataTipLabel.hidden = NO;
	}
	else {
		[self removeTipMessage];
		mapView.hidden = NO;
		noDataTipLabel.hidden = YES;
	}
}


- (void)removeMapAnnotationsInRange:(NSRange)range {
	NSArray *delGroupons = [[rootCtr getAllGrouponList] objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
	for (NSDictionary *dic in delGroupons) {
		// 删除一个团购项目的所有酒店
		NSNumber *prodID = [dic objectForKey:PRODID_GROUPON];
		
		NSMutableArray *hotelsArray = [mapAnnotationDic objectForKey:prodID];
		[mapView removeAnnotations:hotelsArray];
		[mapAnnotations removeObjectsInArray:hotelsArray];
		[mapAnnotationDic removeObjectForKey:prodID];
		
		NSLog(@"%d------",[mapAnnotationDic count]);
	}
}


- (void)removeMapLoadingView {
	[smallLoading stopLoading];
}


- (void)resetAnnotations {
	[mapView removeAnnotations:mapAnnotations];
	[mapAnnotations removeAllObjects];
	[self addMapAnnotations:[rootCtr getAllGrouponList]];
	
	[self performSelector:@selector(goGrouponHotel)];
}


- (void)showDetails:(id)sender {
	UIButton *btn = (UIButton *)sender;
	NSString *hotelId = [btn currentTitle];
	
	[rootCtr searchDetailInfoByHotelID:hotelId];
}


- (void)goGrouponHotel {
	// 地图缩放到第一个酒店位置
	float zoomLevel = MAP_ZOOM_LEVEL;
	
	if ([mapAnnotations count] > 0) {
		PriceAnnotation *priceAnnotation = [mapAnnotations objectAtIndex:0];
		
		MKCoordinateRegion region = MKCoordinateRegionMake(priceAnnotation.coordinate, MKCoordinateSpanMake(zoomLevel,zoomLevel));
		[mapView setRegion:[mapView regionThatFits:region] animated:YES];
	}
}


#pragma mark -
#pragma mark Public Methods

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
    
	// 请求下页数据
	if (rootCtr.moreBtn.enabled) {
		rootCtr.moreBtn.enabled = NO;
		NSLog(@"MoreButtonDone");
		
		linkType = kRequest_More;
		rootCtr.linkType = kRequest_More;
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

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	// If it's the user location, just return nil.
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		
		return nil;
	}
	
	static NSString *priceIdentifier = @"priceIdentifier";
	MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:priceIdentifier];
	
	if (!annotationView) {
		// 价格注解
		annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
													   reuseIdentifier:priceIdentifier] autorelease];
		annotationView.canShowCallout	= YES;
		annotationView.opaque			= NO;
		annotationView.image			= [UIImage imageNamed:@"map_price.png"];
		annotationView.frame			= CGRectMake(0, 0, 52, 40);
		
		UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, annotationView.frame.size.width, 15)];
		priceLabel.font				= [UIFont systemFontOfSize:13];
		priceLabel.backgroundColor	= [UIColor clearColor];
		priceLabel.textColor		= [UIColor whiteColor];
		priceLabel.textAlignment	= UITextAlignmentCenter;
		priceLabel.tag				= PRICELABELTAG;
		priceLabel.adjustsFontSizeToFitWidth = YES;
		[annotationView addSubview:priceLabel];
		[priceLabel release];
		
		UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, annotationView.frame.size.width, 10)];
		starLabel.font				= [UIFont systemFontOfSize:8];
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
		priceLabel.frame = CGRectMake(0, 3, annotationView.frame.size.width, 15);
	}
	else {
		priceLabel.frame = CGRectMake(0, 8, annotationView.frame.size.width, 15);
	}
	
	return annotationView;
}


#pragma mark -
#pragma mark Net Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    NSLog(@"grouponList:%@",root);
	if ([Utils checkJsonIsError:root]) {
		return;
	}
	
	if (util == moreHotelUtil) {
       
        
		// 更新本页数据(排序，切换地区)
		NSLog(@"requestEnd");
		rootCtr.moreBtn.enabled = YES;
		[rootCtr setListGrouponInfo:root];
		
		[self removeMapLoadingView];
        
        // 回到原来为位置
        [self goGrouponHotel];
	}
	else {
		// 进入详情页面
		//NSLog(@"root%@",root);
		[PublicMethods showAvailableMemory];
		GrouponDetailViewController *controller = [[GrouponDetailViewController alloc] initWithDictionary:root];
		controller.hotelDescription = [root objectForKey:@"Description"];
		[rootCtr.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}


@end
