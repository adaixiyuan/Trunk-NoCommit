//
//  IFlyDataAnalyzer.h
//  ElongClient
//
//  Created by Dawn on 14-3-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlyConfig.h"

typedef enum {
    IFlyDataAnalyzerUnFindPOI,
    IFlyDataAnalyzerNotHotel
}IFlyDataAnalyzerErrorCode;

@protocol IFlyDataAnalyzerDelegate;
@interface IFlyDataAnalyzer : NSObject

@property (nonatomic,assign) id<IFlyDataAnalyzerDelegate> delegate;

/** 
 @brief 处理讯飞识别返回结果
 @param results 讯飞切词结果
 */
- (void) dealWithResult:(NSArray *)results;
@end

@protocol IFlyDataAnalyzerDelegate <NSObject>
@optional
- (void) iFlyDataAnalyzer:(IFlyDataAnalyzer *)analyzer doneWithContent:(NSDictionary *)content;
- (void) iFlyDataAnalyzerFailed:(IFlyDataAnalyzer *)analyzer errorCode:(IFlyDataAnalyzerErrorCode)errorCode;
@end