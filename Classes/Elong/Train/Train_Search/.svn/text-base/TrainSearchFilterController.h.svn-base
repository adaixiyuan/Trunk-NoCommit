//
//  TrainSearchFilterController.h
//  ElongClient
//
//  Created by chenggong on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "SearchFilterController.h"
#import "TrainSearchTypeViewController.h"
#import "TrainSearchDepartureTimeViewController.h"
#import "TrainSearchArrivalTimeViewController.h"

#define kFilterTrainType        1000
#define kFilterDepartureTime    (kFilterTrainType * 10)
#define kFilterArrivalTime      (kFilterTrainType * 100)

typedef enum {
    FilterType,             // 车次类型过滤
    FilterDepartureTime,    // 发车时间过滤
    FilterArrivalTime       // 到达时间过滤
}FilterTypes;


@interface TrainSearchFilterController : SearchFilterController<TrainSearchTypeDelegate,
                                                                TrainSearchDepartureTimeDelegate,
                                                                TrainSearchArrivalTimeDelegate>

@property (nonatomic, retain) NSArray *trainType;
@property (nonatomic, retain) NSArray *departureTime;
@property (nonatomic, retain) NSArray *arrivalTime;

@property (nonatomic, retain) NSMutableDictionary *tabHolder;

@property (nonatomic, assign) NSInteger typeIndex;
@property (nonatomic, assign) NSInteger departureTimeIndex;
@property (nonatomic, assign) NSInteger arrivalTimeIndex;

@property (nonatomic, retain) NSDictionary *filterConditions;

- (id)initWithFilterConditions:(NSDictionary *)conditions;

@end
