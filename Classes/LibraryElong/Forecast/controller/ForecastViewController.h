//
//  ForecastViewController.h
//  ElongClient
//
//  Created by chenggong on 14-6-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"

#define kForecastViewWidth    78.0f
#define kForecastViewHeight   48.0f
#define kForecastPopUpViewHeight    184.0f
#define kForecastHorizontalMargin   20.0f

//typedef enum {
//    ForecastBuildIn,
//    ForecastPopUp
//}ForecastType;

@protocol ForecastDelegate;

@interface ForecastViewController : ElongBaseViewController<HttpUtilDelegate>

@property (nonatomic, assign) id<ForecastDelegate> delegate;

- (void)startRequestWithCity:(NSString *)city withDate:(NSString *)date;
- (void)buildupForcastPopView;

@end

@protocol ForecastDelegate <NSObject>

- (void)forecastViewShouldPopUp;

@end
