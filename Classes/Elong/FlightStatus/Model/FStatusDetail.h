//
//  FStatusDetail.h
//  ElongClient
//
//  Created by bruce on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FStatusDetailInfos.h"


// =============================================================================
// 回调协议
// =============================================================================
@protocol FStatusDetailDelgt <NSObject>

// 结果回调
- (void)fStatusDetailBack:(BOOL)isSuccess withMessage:(NSString *)resultMsg;

@end


@interface FStatusDetail : NSObject <NSCoding,HttpUtilDelegate>


@property (nonatomic, strong) NSNumber *isError;                    // 是否出错  
@property (nonatomic, strong) NSString *errorCode;                  // 出错时显示出错代码
@property (nonatomic, strong) NSString *errorMessage;               // 错误信息
@property (nonatomic, strong) NSString *flightDate;                 // 查询航班日期
@property (nonatomic, strong) NSString *flightNote;                 // 查询描述
@property (nonatomic, strong) NSNumber *flightNullCode;             // 查询数据是否为空，1为空，0为有数据
@property (nonatomic, strong) FStatusDetailInfos *detailInfos;      // 航班信息
@property (nonatomic, strong) id <FStatusDetailDelgt> fStatusDelegate;
@property (nonatomic, strong) HttpUtil *getFStatusUtil;

- (void)setDetailInfos:(FStatusDetailInfos *)detailInfos;

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;


- (void)getFlightStatusDetailStart:(NSString *)flightNumber withDate:(NSString *)flightDate andDisableAutoLoad:(BOOL)isDisable;


@end



