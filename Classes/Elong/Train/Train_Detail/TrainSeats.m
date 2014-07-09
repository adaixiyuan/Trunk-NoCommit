//
//  TrainSeats.m
//  ElongClient
//
//  Created by bruce on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainSeats.h"

@implementation TrainSeats


// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 座席代码
    _code = [dictionaryResultJson safeObjectForKey:@"code"];
    
    // 座席名称，如软卧、硬座、无座等
    _name = [dictionaryResultJson safeObjectForKey:@"name"];
    
    // 座席剩余量（余票）信息
    _yupiao = [dictionaryResultJson safeObjectForKey:@"yp"];
    
    // 票价
    _price = [dictionaryResultJson safeObjectForKey:@"price"];
    
    // 最低票价
    _lowPrice = [dictionaryResultJson safeObjectForKey:@"lowPrice"];
    
    // 余票状态码
    _ypCode = [dictionaryResultJson safeObjectForKey:@"seatYpCode"];
    
    // 余票状态信息
    _ypMessage = [dictionaryResultJson safeObjectForKey:@"seatYpName"];
    
    NSArray *tempAvailableTypesJson = [dictionaryResultJson safeObjectForKey:@"availablePassengerTypes"];
    if (tempAvailableTypesJson != nil) {
        _availableTypes = tempAvailableTypesJson;
    }
    
    _currentTicketType = @"1";
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    TrainSeats *trainSeats = [[[self class] allocWithZone:zone] init];
    trainSeats.code = self.code;
    trainSeats.name = self.name;
    trainSeats.yupiao = self.yupiao;
    trainSeats.price = self.price;
    trainSeats.lowPrice = self.lowPrice;
    trainSeats.ypCode = self.ypCode;
    trainSeats.ypMessage = self.ypMessage;
    trainSeats.availableTypes = self.availableTypes;
    trainSeats.currentTicketType = self.currentTicketType;
    
    return trainSeats;
}

@end
