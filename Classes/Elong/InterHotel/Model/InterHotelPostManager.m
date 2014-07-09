//
//  InterHotelPostManager.m
//  ElongClient
//
//  Created by Ivan.xu on 13-6-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelPostManager.h"


@implementation InterHotelPostManager

//酒店详情
static JInterHotelDetail *interHotelDetail  = nil;
+(JInterHotelDetail *)interHotelDetail{
    @synchronized(self) {
		if (!interHotelDetail) {
			interHotelDetail = [[JInterHotelDetail alloc] init];
		}
	}
	return interHotelDetail;
}

//酒店房间
static JInterHotelRoom *interHotelRoom = nil;
+(JInterHotelRoom *)interHotelRoom{
    @synchronized(self){
        if(!interHotelRoom){
            interHotelRoom = [[JInterHotelRoom alloc] init];
        }
    }
    return interHotelRoom;
}

//酒店成单
static JInterHotelOrder *interHotelOrder = nil;
+(JInterHotelOrder *)interHotelOrder{
    @synchronized(self){
        if(!interHotelOrder){
            interHotelOrder = [[JInterHotelOrder alloc] init];
        }
    }
    return interHotelOrder;
}


@end
