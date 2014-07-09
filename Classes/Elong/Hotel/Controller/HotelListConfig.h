//
//  HotelListConfig.h
//  ElongClient
//
//  Created by Dawn on 14-1-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelListConfig : NSObject
@property (nonatomic,assign) BOOL singleTap;
+ (HotelListConfig *) share;
@end
