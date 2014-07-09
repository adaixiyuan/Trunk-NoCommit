//
//  TrainDepartStation.h
//  ElongClient
//
//  Created by bruce on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainDepartStation : NSObject

@property (nonatomic, strong) NSString *isFirst;            // 是否始发站
@property (nonatomic, strong) NSString *name;               // 出发车站名称
@property (nonatomic, strong) NSString *time;               // 列车从出发站出发的时间(发车时间) 格式hh:mm

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
