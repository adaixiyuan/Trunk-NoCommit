//
//  HotelFilterView.h
//  ElongClient
//
//  Created by 赵 海波 on 12-9-11.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterView.h"


@interface HotelFilterView : FilterView {
@private
    NSArray *nArray;
    BOOL showDistanceSort;
    BOOL fromTonightHotelList;
}

@property (nonatomic, assign) BOOL showDistanceFilter;

- (id)initWithShowDistanceSort:(BOOL)setting fromTonightHotelList:(BOOL) fromTonightHotelList;

@end
