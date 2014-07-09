//
//  JHotelOrderHistory.m
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import "JHotelOrderHistory.h"

@implementation JHotelOrderHistory

-(void)buildPostData:(BOOL)clearhotelsearch
{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
		[contents safeSetObject:[PublicMethods getUserElongCardNO] forKey:@"CardNo"];
		[contents safeSetObject:[NSNumber numberWithInt:10] forKey:@"PageSize"];
		[contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"PageIndex"];
		[contents removeObjectForKey:@"StartTime"];
		[contents removeObjectForKey:@"EndTime"];
	}
}

-(id)init
{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] init];
        pageIndex = 0;
		[self clearBuildData];
	}
	return self;
}

-(void)clearBuildData
{
	[self buildPostData:YES];
}

-(void)setPageSize:(int)aPageSize{
    [contents safeSetObject:[NSNumber numberWithInt:aPageSize] forKey:@"PageSize"];
}

-(void)setHalfYear
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [PublicMethods getPreviousDateWithMonth:-6];
	NSString *str = [df stringFromDate:date];
	
	[contents safeSetObject:str forKey:@"StartTime"];
	[contents removeObjectForKey:@"EndTime"];
	
}

-(void)setOneYear
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [NSDate date];
	NSString *str = [df stringFromDate:date];
	NSArray *array = [str componentsSeparatedByString:@"-"];
	NSString *year,*month,*day;
	day = [array safeObjectAtIndex:2];
	
	if([[array safeObjectAtIndex:1] intValue]<7){
		month =[NSString stringWithFormat:@"%d",[[array safeObjectAtIndex:1] intValue]+12-6];
		year = [NSString stringWithFormat:@"%d",[[array safeObjectAtIndex:0] intValue]-1];
	}else {
		year = [NSString stringWithFormat:@"%d",[[array safeObjectAtIndex:0] intValue]];
		month = [NSString stringWithFormat:@"%d",[[array safeObjectAtIndex:1] intValue]-6];
	}
	
	NSString *endStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
	
	NSString *year1,*month1,*day1;
	year1 = [NSString stringWithFormat:@"%d",[[array safeObjectAtIndex:0] intValue]-1];
	month1 = [array safeObjectAtIndex:1];
	day1 = [array safeObjectAtIndex:2];
	
	NSString *startStr = [NSString stringWithFormat:@"%@-%@-%@",year1,month1,day1];
	[contents safeSetObject:startStr forKey:@"StartTime"];
	[contents safeSetObject:endStr forKey:@"EndTime"];
}

-(void)nextPage
{
    pageIndex ++;
	[contents safeSetObject:[NSNumber numberWithInt:pageIndex] forKey:@"PageIndex"];
}

//上一页
-(void)prePage{
    pageIndex --;
	[contents safeSetObject:[NSNumber numberWithInt:pageIndex] forKey:@"PageIndex"];
}

- (void)setPageZero
{
    pageIndex = 0;
}


-(NSString *)requesString:(BOOL)iscompress
{
	NSLog(@"request:%@",contents);
	[contents safeSetObject:[PublicMethods getUserElongCardNO] forKey:@"CardNo"];
	COMMONREQUEST(@"%@",[contents JSONRepresentation]);
	return [NSString stringWithFormat:@"action=GetHotelOrderList&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
