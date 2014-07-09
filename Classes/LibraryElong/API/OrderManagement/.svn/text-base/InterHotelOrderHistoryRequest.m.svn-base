//
//  InterHotelOrderHistoryRequest.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-27.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelOrderHistoryRequest.h"
#import "AccountManager.h"
#import "TimeUtils.h"

@implementation InterHotelOrderHistoryRequest

- (id)init
{
    if (self = [super init]) {
        _countPerPage = 10;
        _currentPage = 1;
    }
    return self;
}

- (void)nextPage
{
    ++_currentPage;
}

- (NSString *)request
{
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    NSUInteger unitFlags =   NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *newDateComponents = [[NSDateComponents alloc] init];
    [newDateComponents setMonth:-6];
    NSDate *date = [chineseClendar dateByAddingComponents:newDateComponents toDate:[NSDate date] options:unitFlags];
    
    NSString *dateStr = [TimeUtils makeJsonDateWithUTCDate:date];
    [chineseClendar release];
    [newDateComponents release];

    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content setValue:[NSNumber numberWithInt:_currentPage] forKey:@"PageIndex"];
	[content setValue:[NSNumber numberWithInt:_countPerPage] forKey:@"PageSize"];
    [content setValue:[NSNumber numberWithInt:0] forKey:@"Status"];
    [content setValue:[[AccountManager instanse] cardNo] forKey:@"MemberShip"];
    [content setValue:dateStr forKey:@"CreateTimeStart"];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	
	return [NSString stringWithFormat:@"action=GetGlobalHotelOrderList&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}

@end
