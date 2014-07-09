//
//  HotelRoomBedsRequest.m
//  ElongClient
//
//  Created by Dawn on 14-2-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelRoomBedsRequest.h"


@implementation HotelRoomBedsRequest

- (void)dealloc{
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
	}
	return self;
}

- (NSString *) request{
    
    NSMutableDictionary *contents = [NSMutableDictionary dictionary];
    [contents setValue:self.hotelId  forKey:@"hotelId"];
    [contents setValue:self.roomId forKey:@"roomId"];
    [contents setValue:self.checkInDate forKey:@"checkInDate"];
    [contents setValue:self.checkOutDate forKey:@"checkOutDate"];
    
    NSString *result = [contents JSONString];
    return result;
}
@end
