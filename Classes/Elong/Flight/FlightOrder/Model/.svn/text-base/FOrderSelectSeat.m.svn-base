//
//  FOrderSelectSeat.m
//  ElongClient
//
//  Created by bruce on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FOrderSelectSeat.h"

@implementation FOrderSelectSeat

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 是否出错
    _isError = [dictionaryResultJson safeObjectForKey:@"IsError"];
    
    // 错误信息
    _errorMessage = [dictionaryResultJson safeObjectForKey:@"ErrorMessage"];
    
    // 是否选座成功
    _isSelectSuccess = [dictionaryResultJson safeObjectForKey:@"IsSelectSuccess"];
    
}

@end
