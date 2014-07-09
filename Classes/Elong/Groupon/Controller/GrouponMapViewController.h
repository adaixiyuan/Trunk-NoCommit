//
//  GrouponMapViewController.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import <MapKit/MapKit.h>

@class HotelMap;
@interface GrouponMapViewController : DPNav{
    HotelMap *mapWeb;
}
- (id)initWithDictionary:(NSDictionary *)dictionary latitude:(double)lat longitude:(double)lng;
@end
