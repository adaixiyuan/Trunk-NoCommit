//
//  WebAppUtil.m
//  ElongClient
//
//  Created by garin on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "WebAppUtil.h"

@implementation WebAppUtil

+(BOOL) isMatchRegex:(NSString *) txt regexStr:(NSString *) regexStr
{
    if (!STRINGHASVALUE(txt))
    {
        return NO;
    }
    
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSInteger matchCnt = [regex numberOfMatchesInString:txt options:0 range:NSMakeRange(0, txt.length)];
    
    return matchCnt>0;
}

//解析queryString
+(NSDictionary *)parseQueryString:(NSString *)query
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs)
    {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if (elements.count!=2)
        {
            continue;
        }
        
        NSString *key = [[elements safeObjectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements safeObjectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict safeSetObject:val forKey:key];
    }
    
    return dict;
}

+(NSDictionary *) getBookingRoom:(NSArray *) rooms currentRoomIndex:(int *)currentRoomIndex findRoomId:(NSString *) findRoomid
                  findRatePlanId:(NSString *) findRatePlanId
{
    for (int i=0; i<rooms.count; i++)
    {
        NSDictionary *temRoom = [rooms safeObjectAtIndex:i];
        
        NSString *roomTypeId=[NSString stringWithFormat:@"%@",[temRoom safeObjectForKey:@"RoomTypeId"]];
        NSString *ratePlanId=[NSString stringWithFormat:@"%@",[temRoom safeObjectForKey:@"RatePlanId"]];
        
        if ([roomTypeId isEqualToString:findRoomid] &&[ratePlanId isEqualToString:findRatePlanId])
        {
            *currentRoomIndex = i;
            return temRoom;
        }
    }
    
    *currentRoomIndex = -1;
    return nil;
}

@end
