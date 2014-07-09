//
//  XGOrderSucessInfoModel.m
//  ElongClient
//
//  Created by guorendong on 14-5-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGOrderSucessInfoModel.h"

@implementation XGOrderSucessInfoModel
-(void)convertObjectFromGievnDictionary:(NSDictionary *)dict relySelf:(BOOL)yes
{
    [super convertObjectFromGievnDictionary:dict relySelf:yes];
    NSDictionary *roomDict =dict[@"HotelInfo"][@"RoomInfo"];
    self.RoomInfo =[[XGRoomStyle alloc] init];
    [self.RoomInfo convertObjectFromGievnDictionary:roomDict relySelf:yes];
    self.HotelInfo =[[XGHotelInfo alloc] init];
    [self.HotelInfo convertObjectFromGievnDictionary:dict[@"HotelInfo"] relySelf:yes];
    
    self.HotelPhone =self.HotelInfo.HotelPhone; //self.Phone.length>0?self.Phone:self.HotelPhone;

}
@end
