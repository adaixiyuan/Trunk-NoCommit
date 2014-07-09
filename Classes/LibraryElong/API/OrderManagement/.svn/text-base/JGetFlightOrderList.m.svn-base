//
//  JGetFlightOrderList.m
//  ElongClient
//
//  Created by WangHaibin on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JGetFlightOrderList.h"


@implementation JGetFlightOrderList
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
		[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
		[contents safeSetObject:[NSNumber numberWithInt:10] forKey:@"PageSize"];
		[contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"PageIndex"];
		[contents removeObjectForKey:@"StartTime"];
		[contents removeObjectForKey:@"EndTime"];
	}
}

-(id)init{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] init];
		[self clearBuildData];
	}
	return self;
}

-(void)clearBuildData{
	[self buildPostData:YES];
}

-(void)setHalfYear{
	NSDate* date =  [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60 * 30 * 3)]; 
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *currentDateStr = [dateFormatter stringFromDate:date];
	[contents safeSetObject:currentDateStr forKey:@"StartTime"];
	[contents removeObjectForKey:@"EndTime"];
	//[contents safeSetObject:@"" forKey:@"EndTime"];
	
}

-(void)setOneYear{
	NSDate* date =  [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60 * 30 * 6)]; 
	NSDate* onedate = [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60 * 30 * 12)]; 
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *currentDateStr = [dateFormatter stringFromDate:date];
	NSString* oneDateStr = [dateFormatter stringFromDate:onedate];
	[contents safeSetObject:oneDateStr  forKey:@"StartTime"];
	[contents safeSetObject:currentDateStr forKey:@"EndTime"];
	
	
}


-(void)nextPage{
	int pageIndex = [[contents safeObjectForKey:@"PageIndex"] intValue];
	pageIndex=pageIndex+1;
	[contents safeSetObject:[NSNumber numberWithInt:pageIndex] forKey:@"PageIndex"];
	
}

-(NSString *)requesString:(BOOL)iscompress{
	NSLog(@"request:%@",contents);
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
	COMMONREQUEST(@"%@",[contents JSONRepresentation]);
	return [NSString stringWithFormat:@"action=GetFlightOrderListV2&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
