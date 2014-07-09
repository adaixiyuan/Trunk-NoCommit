//
//  FOrderSeatPassengerInfo.m
//  ElongClient
//
//  Created by bruce on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FOrderSeatPassengerInfo.h"

@implementation FOrderSeatPassengerInfo

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    //
    _name = [dictionaryResultJson safeObjectForKey:@"Name"];
    
    //
    _certificateType = [dictionaryResultJson safeObjectForKey:@"CertificateType"];
    
    _certificateNumber = [dictionaryResultJson safeObjectForKey:@"CertificateNumber"];
    
    _birthday = [dictionaryResultJson safeObjectForKey:@"Birthday"];
    
    _passengerType = [dictionaryResultJson safeObjectForKey:@"PassengerType"];
    
}

@end
