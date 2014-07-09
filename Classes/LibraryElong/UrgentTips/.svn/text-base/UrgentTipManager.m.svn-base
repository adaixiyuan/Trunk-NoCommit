//
//  UrgentTipManager.m
//  ElongClient
//
//  Created by Ivan.xu on 14-4-22.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "UrgentTipManager.h"
#import "SynthesizeSingletonCopy.h"
#import "UrgentTipModel.h"

NSString * const HotelSearchUrgentTip = @"HotelSearchUrgentTip";
NSString * const FlightSearchUrgentTip = @"FlightSearchUrgentTip";
NSString * const TrainSearchUrgentTip  = @"TrainSearchUrgentTip";

NSString * const HotelCalendarUrgentTip  = @"HotelCalendarUrgentTip" ;
NSString * const FlightCalendarUrgentTip  = @"FlightCalendarUrgentTip";
NSString * const TrainCalendarUrgentTip  = @"TrainCalendarUrgentTip";

NSString * const HotelFillOrderUrgentTip  = @"HotelFillOrderUrgentTip";
NSString * const FlightFillOrderUrgentTip  = @"FlightFillOrderUrgentTip";
NSString * const GrouponFillOrderUrgentTip  = @"GrouponFillOrderUrgentTip";
NSString * const TrainFillOrderUrgentTip  = @"TrainFillOrderUrgentTip";

NSString * const HotelUnifromCounterUrgentTip  = @"HotelUnifromCounterUrgentTip";
NSString * const FlightUnifromCounterUrgentTip  = @"FlightUnifromCounterUrgentTip";
NSString * const GrouponUnifromCounterUrgentTip  = @"GrouponUnifromCounterUrgentTip";


#define HOTEL @"Hotel"
#define FLIGHT @"Flight"
#define GROUPON @"Groupon"
#define TRAIN @"Railway"

@interface UrgentTipManager ()

@property (nonatomic,retain) HttpUtil *urgentUtil;

-(void)getUrgentTipFromServerByCategory:(NSString *)category;       //获取紧急提示信息请求

@end

@implementation UrgentTipManager

SYNTHESIZE_SINGLETON_FOR_CLASS(UrgentTipManager);

- (void)dealloc
{
    [_urgentUtil cancel];
    [_urgentUtil release];
    
    [_urgentBlock release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _urgentUtil = [[HttpUtil alloc] init];
    }
    return self;
}

//取消显示紧急提示
-(void)cancelUrgentTip{
    [self.urgentUtil cancel];
    self.urgentBlock = nil;
}

-(void)urgentTipViewofCategory:(NSString *)category completeHandle:(UrgentManagerBlock)callback{
    self.urgentBlock = callback;
    
    [self getUrgentTipFromServerByCategory:category];
}

-(void)getUrgentTipFromServerByCategory:(NSString *)category{
    NSDictionary *params = [self postParams:category];
    NSString * reqStr = [PublicMethods composeNetSearchUrl:@"mtools" forService:@"contentResource" andParam: [params JSONString]];

    [self.urgentUtil requestWithURLString:reqStr Content:nil StartLoading:NO EndLoading:NO Delegate:self];
}

-(NSDictionary *)postParams:(NSString *)category{
    NSMutableDictionary *tmpCategory = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *channelValue = @"";
    NSString *pageValue = @"";
    NSString *positionId = @"";
    if([category isEqualToString:HotelSearchUrgentTip]){
        //酒店搜索页面
        channelValue = HOTEL;
        pageValue = @"HotelSearch";
        positionId = @"bottom";
    }else if([category isEqualToString:HotelFillOrderUrgentTip]){
        channelValue = HOTEL;
        pageValue = @"HotelOrderFillin";
        positionId = @"bottom";
//        channelValue = @"MyElong";
//        pageValue = @"ReturnCashList";
//        positionId = @"ReturnCashDescription";
    }else if([category isEqualToString:HotelCalendarUrgentTip]){
        channelValue = HOTEL;
        pageValue = @"HotelCalendar";
        positionId = @"top";
    }else if([category isEqualToString:HotelUnifromCounterUrgentTip]){
        channelValue = HOTEL;
        pageValue = @"HotelPayCounter";
        positionId = @"bottom";
    }else if([category isEqualToString:FlightSearchUrgentTip]){
        channelValue = FLIGHT;
        pageValue = @"FlightSearch";
        positionId = @"bottom";
    }else if([category isEqualToString:FlightFillOrderUrgentTip]){
        channelValue = FLIGHT;
        pageValue = @"FlightOrderFillin";
        positionId = @"bottom";
    }else if([category isEqualToString:FlightCalendarUrgentTip]){
        channelValue = FLIGHT;
        pageValue = @"FlightCalendar";
        positionId = @"top";
    }else if([category isEqualToString:FlightUnifromCounterUrgentTip]){
        channelValue = FLIGHT;
        pageValue = @"FlightPayCounter";
        positionId = @"bottom";
    }else if([category isEqualToString:TrainSearchUrgentTip]){
        channelValue = TRAIN;
        pageValue = @"RailwaySearch";
        positionId = @"bottom";
    }else if([category isEqualToString:TrainCalendarUrgentTip]){
        channelValue = TRAIN;
        pageValue = @"RailwayCalendar";
        positionId = @"top";
    }else if([category isEqualToString:TrainFillOrderUrgentTip]){
        channelValue = TRAIN;
        pageValue = @"RailwayOrderFillin";
        positionId = @"bottom";
    }else if([category isEqualToString:GrouponFillOrderUrgentTip]){
        channelValue = GROUPON;
        pageValue = @"GrouponOrderFillin";
        positionId = @"bottom";
    }else if([category isEqualToString:GrouponUnifromCounterUrgentTip]){
        channelValue = GROUPON;
        pageValue = @"GrouponPayCounter";
        positionId = @"bottom";
    }
    
    [tmpCategory  safeSetObject:channelValue forKey:@"channel"];
    [tmpCategory safeSetObject:pageValue forKey:@"page"];
    [tmpCategory safeSetObject:positionId forKey:@"positionId"];
    [tmpCategory safeSetObject:@"Iphone" forKey:@"productLine"];
    
    return tmpCategory;
}


#pragma mark - HttpUtil delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if (util==self.urgentUtil)
    {
        if ([Utils checkJsonIsErrorNoAlert:root]){
            return;
        }
        NSArray *contentList = [root safeObjectForKey:@"contentList"];
        if(ARRAYHASVALUE(contentList)){
            NSMutableArray *tips = [NSMutableArray arrayWithCapacity:0];
            for(NSDictionary *content in contentList){
                UrgentTipModel *tipModel = [[UrgentTipModel alloc] initWithJson:content];
                [tips addObject:tipModel];
                [tipModel release];
            }
            
            UrgentTipView *tipView = [[UrgentTipView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
            [tipView setTipModel:(UrgentTipModel *)[tips objectAtIndex:0]];
            
            self.urgentBlock(tipView);
        }
        
    }
}

@end
