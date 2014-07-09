//
//  XGMapViewController.h
//  ElongClient
//
//  Created by licheng on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseViewController.h"
#import "HotelMap.h"
@interface XGMapViewController : XGBaseViewController
{
    HotelMap *mapView;
    UILabel *addressTipsLbl;
}
@property(nonatomic,copy)NSString * lat;
@property(nonatomic,copy)NSString * lng;

@property(nonatomic,copy)NSString *hotelName;
@property(nonatomic,copy)NSString *hotelSubtitle;

@end
