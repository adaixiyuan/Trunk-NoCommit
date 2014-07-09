//
//  FlightStatusConfig.h
//  ElongClient
//
//  Created by bruce on 14-1-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#ifndef ElongClient_FlightStatusConfig_h
#define ElongClient_FlightStatusConfig_h

#define	kFAttentionFile							    @"flightAttention.dat"
#define	kFAttentionArchiverKey						@"attentionArray"

// ==================================================================
// 归档宏
// ==================================================================
#define	encodeObject(encoder, name, type)		[encoder encode##type:name forKey:[NSStringFromClass([self class]) stringByAppendingString:@#name]]
#define	decodeObject(decoder, name, type)		name = [decoder decode##type##ForKey:[NSStringFromClass([self class]) stringByAppendingString:@#name]]

// ==================================================================
// 机场类型
// ==================================================================
typedef enum FStatusAirportType : NSUInteger
{
    eFStatusDAirport = 0,                           // 出发机场
    eFStatusAAirport,                               // 到达机场
} FStatusAirportType;

// ==================================================================
// 航班动态详情类型
// ==================================================================
typedef enum FSDetailType : NSUInteger
{
    eFStatusSearchDetail = 1,                       // 查询详情
    eFStatusAttentionDetail,                        // 关注详情
} FSDetailType;


// ==================================================================
// 航班动态详情加载类型
// ==================================================================
typedef enum FSDetailLoadType : NSUInteger
{
    eFSDetailInit = 0,                              // 初始化
    eFSDetailLoadSuccess,                           // 加载成功
    eFSDetailLoadFailure,                           // 加载失败
} FSDetailLoadType;

#endif
