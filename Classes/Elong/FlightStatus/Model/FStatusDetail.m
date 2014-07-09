//
//  FStatusDetail.m
//  ElongClient
//
//  Created by bruce on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FStatusDetail.h"


#define name [NSStringFromClass([self class]) stringByAppendingString:@#name];

@implementation FStatusDetail

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 是否出错
    _isError = [dictionaryResultJson safeObjectForKey:@"IsError"];
    
    // 出错时显示出错代码
    _errorCode = [dictionaryResultJson safeObjectForKey:@"ErrorCode"];
    
    // 错误信息
    _errorMessage = [dictionaryResultJson safeObjectForKey:@"ErrorMessage"];
    
    // 查询航班日期
    _flightDate = [dictionaryResultJson safeObjectForKey:@"flightDate"];;
    
    // 查询描述
    _flightNote = [dictionaryResultJson safeObjectForKey:@"flightNote"];;
    
    // 查询数据是否为空，1为空，0为有数据
    _flightNullCode = [dictionaryResultJson safeObjectForKey:@"flightNullCode"];;
    
    // 航班信息
    FStatusDetailInfos *detailInfosTmp = [[FStatusDetailInfos alloc] init];
	NSDictionary *dictionaryDetailInfoJson = [dictionaryResultJson safeObjectForKey:@"flightInfo"];
	if(dictionaryDetailInfoJson == nil)
	{
        dictionaryDetailInfoJson = [[NSDictionary alloc] init];
		
	}
	[detailInfosTmp parseSearchResult:dictionaryDetailInfoJson];
    
    _detailInfos = detailInfosTmp;
    
}

- (void)setDetailInfos:(FStatusDetailInfos *)detailInfos
{
    _detailInfos = detailInfos;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    encodeObject(encoder, _flightDate, Object);
	encodeObject(encoder, _flightNote, Object);
	encodeObject(encoder, _flightNullCode, Object);
    encodeObject(encoder, _detailInfos, Object);
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    decodeObject(decoder, _flightDate, Object);
    decodeObject(decoder, _flightNote, Object);
    decodeObject(decoder, _flightNullCode, Object);
    decodeObject(decoder, _detailInfos, Object);
    
	return self;
}

// 详情请求
- (void)getFlightStatusDetailStart:(NSString *)flightNumber withDate:(NSString *)flightDate andDisableAutoLoad:(BOOL)isDisable
{
    // 组织Json
	NSMutableDictionary *dictionaryJson = [[NSMutableDictionary alloc] init];
    
    
    // 航班号
    if (flightNumber != nil)
    {
        [dictionaryJson safeSetObject:flightNumber forKey:@"flightNo"];
    }
    
    // 航班日期
    if (flightDate != nil)
    {
        [dictionaryJson safeSetObject:flightDate forKey:@"Date"];
    }
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods composeNetSearchUrl:@"mtools"
                                            forService:@"flightTrendDetail"
                                              andParam:paramJson];
    
    if (url != nil)
    {
        if (_getFStatusUtil == nil)
        {
            _getFStatusUtil = [[HttpUtil alloc] init];
        }
        [_getFStatusUtil requestWithURLString:url
                                          Content:nil
                                     StartLoading:!isDisable
                                       EndLoading:!isDisable
                                         Delegate:self];
        
        
//        [HttpUtil requestURL:url postContent:nil delegate:self disablePop:isDisable disableClosePop:isDisable disableWait:isDisable];
        
    }
}

// =======================================================================
#pragma mark - 网络请求回调
// =======================================================================
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"%@", root);
    
    // 结果信息
    BOOL isSuccess;
    NSString *resultMsg;
    
    if (root != nil)
    {
        // 解析结果数据
        [self parseSearchResult:root];
        
        // 请求结果判断
        NSNumber *isError = [self isError];
        if (isError !=nil && [isError boolValue] == NO)
        {
            isSuccess = YES;
            resultMsg = nil;
        }
        else
        {
            isSuccess = NO;
            if (_errorMessage)
            {
                resultMsg = _errorMessage;
            }
        }
    }
    else
    {
        isSuccess = NO;
        resultMsg = @"服务器错误";
        
        
    }
    
    // 回调
	if((_fStatusDelegate != nil) && ([_fStatusDelegate respondsToSelector:@selector(fStatusDetailBack:withMessage:)] == YES))
	{
		[_fStatusDelegate fStatusDetailBack:isSuccess withMessage:resultMsg];
	}
}

@end
