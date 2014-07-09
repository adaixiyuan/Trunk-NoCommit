//
//  InterHotelDetailMapCtrl.h
//  ElongClient
//
//  Created by Ivan.xu on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
//#import <GoogleMaps/GoogleMaps.h>

@interface InterHotelDetailMapCtrl : DPNav<UIScrollViewDelegate>{
@private
    UILabel *addressTipsLbl;
    UIImageView *mapImageView;
    CGSize photoSize;
    CGSize newSize;
    NSString *hotelName;
    UIScrollView *mapScrollView;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
