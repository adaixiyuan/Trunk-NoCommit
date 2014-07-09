//
//  UrgentTipManager.h
//  ElongClient
//
//  Created by Ivan.xu on 14-4-22.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrgentTipView.h"
#import "UrgentTipModel.h"

extern NSString * const HotelSearchUrgentTip;
extern NSString * const FlightSearchUrgentTip;
extern NSString * const TrainSearchUrgentTip;

extern NSString * const HotelCalendarUrgentTip;
extern NSString * const FlightCalendarUrgentTip;
extern NSString * const TrainCalendarUrgentTip;

extern NSString * const HotelFillOrderUrgentTip;
extern NSString * const FlightFillOrderUrgentTip;
extern NSString * const GrouponFillOrderUrgentTip;
extern NSString * const TrainFillOrderUrgentTip;

extern NSString * const HotelUnifromCounterUrgentTip;
extern NSString * const FlightUnifromCounterUrgentTip;
extern NSString * const GrouponUnifromCounterUrgentTip;




typedef void (^UrgentManagerBlock)(UrgentTipView *urgentTipView);
@interface UrgentTipManager : NSObject<HttpUtilDelegate>

@property (nonatomic,copy) UrgentManagerBlock urgentBlock;

+ (UrgentTipManager *)sharedInstance;

-(void)urgentTipViewofCategory:(NSString *)category completeHandle:(UrgentManagerBlock)callback;
-(void)cancelUrgentTip;     //取消显示紧急提示

@end
