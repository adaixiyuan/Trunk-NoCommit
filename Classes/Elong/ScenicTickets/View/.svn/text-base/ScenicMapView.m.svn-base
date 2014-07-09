//
//  ScenicMapView.m
//  ElongClient
//
//  Created by nieyun on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicMapView.h"
#import "SearchBarView.h"
#import "PositioningManager.h"
#import "ScenicAnnitoanView.h"
#import "SceneryList.h"

@implementation ScenicMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
      
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame  withAnnotionAr:(NSArray *)annotionAr
{
    self  =  [super  initWithFrame:frame];
    if (self) {
        // Initialization code
         allAnnotionAr = [[NSMutableArray  alloc]init];
        addFlag = 0;
        [self  addSearchBar];
        [self  addMapView];
        [self  anntionSet];
        [self  addMapFooterView];
       
        [self parserAnnotion:annotionAr];
        [self  addAnnotionAction];
        
        UILongPressGestureRecognizer  *longaPress = [[UILongPressGestureRecognizer  alloc]initWithTarget:self action:@selector(longPressAction:)];
        [map  addGestureRecognizer:longaPress];
        [longaPress release];
    
    }
    return self; 
    
}

- (void)longPressAction:(UILongPressGestureRecognizer  *)gesture
{

    NSLog(@"%d",gesture.state);
    
    // 防止长按手势2次执行
	if (UIGestureRecognizerStateBegan == gesture.state) {
        CGPoint  point = [gesture  locationInView:map];
        CLLocationCoordinate2D  coordinate = [map  convertPoint:point toCoordinateFromView:map];
        [self  addPressAnnotion:coordinate];
        if ([self.delegate  respondsToSelector:@selector(longpress:)])
        {
            [self.delegate  longpress:coordinate];
        }
    }
    
}

- (void)addPressAnnotion:(CLLocationCoordinate2D )cood
{
    //删除之前的标注
    for (id  annotion in map.annotations)
    {
        if ([annotion isKindOfClass:[DesAnnotion  class]]) {
            [map  removeAnnotation:annotion];
        }
    }
    DesAnnotion  *annotion = [[DesAnnotion alloc]init];
    annotion.coordinate = cood;
    annotion.title = [[PositioningManager  shared]getAddressName];
    [map addAnnotation:annotion];
    [annotion release];
}
- (void)addAnnotionAction
{
   
   if (addFlag >=  allAnnotionAr.count )
    {
        [NSObject  cancelPreviousPerformRequestsWithTarget:self];
        return;
    }
    ScenicAnnotion *sAnnotion = [allAnnotionAr safeObjectAtIndex:addFlag];
    [map  addAnnotation:sAnnotion];
     addFlag ++;
    [self  performSelector:@selector(addAnnotionAction) withObject:sAnnotion afterDelay:0.5];
}
- (void) addSearchBar
{
    SearchBarView  *searchBar = [[SearchBarView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 44)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    searchBar.placeholder = @"输入城市/景点名";
    [self addSubview:searchBar];
    [searchBar  release];
    
}


- (void)anntionSet
{
    NSMutableArray  *ar = [NSMutableArray  array];
    for (int i = 0; i <10; i++)
    {
        ScenicAnnotion  *annotion = [[ScenicAnnotion  alloc]init];
        annotion.coordinate = CLLocationCoordinate2DMake(39.9833 + i*0.0001, 116.4675 + i *0.0001);
        annotion.title = @"nienie";
        annotion.price = @"188";
        annotion.name = @"望京haha";
        [ar  addObject:annotion];
    }
    [allAnnotionAr  addObjectsFromArray:ar];
    
}
- (void)addMapView
{
     float zoomLevel = MAP_ZOOM_LEVEL;
    map = [[MKMapView  alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44 - 45)];
    map.delegate =self;
    MKCoordinateRegion region = MKCoordinateRegionMake([[PositioningManager shared] myCoordinate],MKCoordinateSpanMake(zoomLevel,zoomLevel));
	[map  setRegion:[map regionThatFits:region] animated:NO];
	map.showsUserLocation = YES;
    [self  addSubview:map];

}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if (views .count > 0)
    {
        for (int i = 0;i < views.count;i ++)
        {
            if ([[views  objectAtIndex:i] isKindOfClass:[ScenicAnnitoanView  class]]) {
                ScenicAnnitoanView *annotionView = [views  objectAtIndex:i];
                [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
                    annotionView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionBeginFromCurrentState animations:^{
                        annotionView.transform = CGAffineTransformMakeScale(1, 1);
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
                
//                [UIView  animateWithDuration:1 animations:^{
//                    annotionView.alpha = 1;
//                    annotionView.transform = CGAffineTransformMakeScale(1.2,1.2);
//                } completion:^(BOOL finished){
//                    [UIView  animateWithDuration:0.5 animations:^{
//                        annotionView.transform = CGAffineTransformIdentity;
//                    }];
//                }];
                
            }
        }
    }
}
- (MKAnnotationView  *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation  isKindOfClass:[MKUserLocation class]] ||[annotation  isKindOfClass:[DesAnnotion  class]])
    {
        static  NSString  *user = @"userlocation";
        MKPinAnnotationView  *pinView = [[[MKPinAnnotationView  alloc]initWithAnnotation:annotation reuseIdentifier:user] autorelease];
        pinView.canShowCallout = YES;
        pinView.pinColor = [UIColor  redColor];
        pinView.animatesDrop = YES;
        return pinView;
    }
    
    static  NSString  *str = @"annotion";
    ScenicAnnitoanView  *annontionView = (ScenicAnnitoanView  *)[mapView dequeueReusableAnnotationViewWithIdentifier:str];
        if (!annontionView)
        {
            annontionView  = [[[ScenicAnnitoanView  alloc ]initWithFrame:CGRectMake(0, 0,49, 35) annotation:annotation reuseIdentifier:str] autorelease];
        }

        annontionView.modelAnnotion = annotation;
        return annontionView;
    
}


- (void) parserAnnotion:(NSArray  *)ar
{
    [allAnnotionAr  removeAllObjects];
    for (int i = 0;i < ar.count ;i ++)
    {
        SceneryList  *list = [ar  safeObjectAtIndex:i];
        ScenicAnnotion  *annotion = [[ScenicAnnotion  alloc]init];
         annotion.bookFlag = [list.bookFlag  intValue];
        if (annotion.bookFlag  == SCENIC_NOBOOK)
        {
           annotion.gradeName = list.gradeName;
        }
        else if (annotion.bookFlag   == SCENIC_BOOK)
        {
            annotion.price = list.price;
        }
        annotion.name =list.sceneryName;
        annotion.coordinate = CLLocationCoordinate2DMake([list.lat floatValue], [list.lon floatValue]);
       
        [allAnnotionAr  addObject:annotion];
        
        [annotion  release];
    }
    
    [self  centerMap];
}

-(void) centerMap
{
    
    if(!allAnnotionAr||allAnnotionAr.count<1)
        return;
    
    
	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
    
    CLLocationDegrees  nowLat ;
    CLLocationDegrees   nowLon;
    int count = allAnnotionAr.count;
   
	for(int idx = 0; idx < count + 1 ; idx++)
	{
        if (idx == 0)
        {
            nowLat = map.region.center.latitude;
            nowLon = map.region.center.longitude;
        }else
        {
            ScenicAnnotion * curAnonotation=((ScenicAnnotion *)[allAnnotionAr safeObjectAtIndex:idx -1]);
            nowLat = curAnonotation.coordinate.latitude;
            nowLon = curAnonotation.coordinate.longitude;
        }
        
        
        if(nowLat==0 && nowLon==0)
            continue;
        
		if(nowLat > maxLat)
			maxLat = nowLat;
		if(nowLat< minLat)
			minLat = nowLat;
		if(nowLon> maxLon)
			maxLon = nowLon;
		if(nowLon < minLon)
			minLon = nowLon;
	}
 
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + (maxLat -minLat)*0.12;
	region.span.longitudeDelta = maxLon - minLon + (maxLon - minLon) *0.22;
    
	[map setRegion:region animated:YES];
    
    
}

-(void)addMapFooterView{
    //
	mapFooterView = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, self.height - 45, 320, 45)];
    mapFooterView.delegate = self;
    //推荐
    BaseBottomBarItem *recommendItem = [[BaseBottomBarItem alloc] initWithTitle:@"当前位置"
                                                                      titleFont:[UIFont systemFontOfSize:12.0f]
                                                                          image:@"basebar_location.png"
                                                                highligtedImage:@"basebar_location_h.png"];
    
    //goCenter
    BaseBottomBarItem *salesItem = [[BaseBottomBarItem alloc] initWithTitle:@"筛选"
                                                                  titleFont:[UIFont systemFontOfSize:12.0f]
                                                                      image:@"basebar_map.png"
                                                            highligtedImage:@"basebar_map_h.png"];
    
    //筛选
    BaseBottomBarItem  *mapFilterItem = [[BaseBottomBarItem alloc] initWithTitle:@"列表"
                                                                       titleFont:[UIFont systemFontOfSize:12.0f]
                                                                           image:@"basebar_filter.png" highligtedImage:@"basebar_filter_h.png"];
    
    
    
    
    
	//switchViews
    NSMutableArray *itemArray = [NSMutableArray array];
    [itemArray addObject:recommendItem];
    recommendItem.allowRepeat = YES;
    recommendItem.autoReverse = YES;
    [recommendItem release];
    
    [itemArray addObject:salesItem];
    salesItem.allowRepeat = YES;
    salesItem.autoReverse = YES;
    [salesItem release];
    
    [itemArray addObject:mapFilterItem];
    mapFilterItem.allowRepeat = YES;
    mapFilterItem.autoReverse = YES;
    [mapFilterItem release];
    
    
    mapFooterView.baseBottomBarItems = itemArray;
    
	[self  insertSubview:mapFooterView aboveSubview:map];
	[mapFooterView release];
}

- (void) selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    
}

- (void)dealloc
{
    [NSObject  cancelPreviousPerformRequestsWithTarget:self];
    [map release];
    if (moreUtil) {
        [moreUtil  cancel];
        SFRelease(moreUtil);
    }
    [allAnnotionAr release];
    [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
