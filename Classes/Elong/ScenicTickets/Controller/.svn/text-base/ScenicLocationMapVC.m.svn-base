//
//  ScenicLocationMapVC.m
//  ElongClient
//
//  Created by jian.zhao on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicLocationMapVC.h"
#import "PositioningManager.h"
#import "PriceAnnotation.h"

@interface ScenicLocationMapVC ()

@end

@implementation ScenicLocationMapVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc  {

    [_mapView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44-20)];
    _mapView.delegate =self;
    MKCoordinateRegion region = MKCoordinateRegionMake([[PositioningManager shared] myCoordinate],MKCoordinateSpanMake(0.2,0.2));
	[_mapView  setRegion:[_mapView regionThatFits:region] animated:YES];
	//_mapView.showsUserLocation = YES;
    [self.view  addSubview:_mapView];
    
    [self addTheScenicLocation];
    
}


- (void)addTheScenicLocation
{
    PriceAnnotation *annotion = [[PriceAnnotation     alloc] init];
    annotion.title = @"祝标题";
    annotion.subtitle = @"副标题";
    [annotion setCoordinate:CLLocationCoordinate2DMake(40.041, 116.187)];
    [_mapView addAnnotation:annotion];
    [_mapView selectAnnotation:annotion animated:YES];
    [annotion    release];
    
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
}
- (MKAnnotationView  *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[PriceAnnotation class]]) {
        //
        MKPinAnnotationView *newAnnotation = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"] autorelease];
        newAnnotation.pinColor = MKPinAnnotationColorRed;
        newAnnotation.animatesDrop = YES;
        //canShowCallout: to display the callout view by touch the pin
        newAnnotation.canShowCallout=YES;
        return newAnnotation;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
