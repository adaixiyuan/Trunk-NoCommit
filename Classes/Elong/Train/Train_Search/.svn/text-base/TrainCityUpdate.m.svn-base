//
//  TrainCityUpdate.m
//  ElongClient
//
//  Created by bruce on 13-11-6.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainCityUpdate.h"
#import "StringEncryption.h"
#import "NSString+URLEncoding.h"
#import "TrainCity.h"

@implementation TrainCityUpdate

- (id)init
{
    if (self = [super init])
    {
        
	}
    
	return self;
}

// 解析结果数据
- (void)parseTrainCityUpdateResult:(NSDictionary *)dictionaryResultJson
{
    // =======================================================================
	// 车站数据
	// =======================================================================
    NSMutableArray *arrayTrainCityTmp = [[NSMutableArray alloc] init];
	NSArray *arrayCityUpdateResultJson = [dictionaryResultJson safeObjectForKey:@"stations"];
    
    if(arrayCityUpdateResultJson != nil)
	{
		// 车站数目
		NSUInteger cityCount = [arrayCityUpdateResultJson count];
		
		for(NSUInteger i = 0; i < cityCount; i++)
		{
			NSDictionary *dictionaryCityJson = [arrayCityUpdateResultJson objectAtIndex:i];
			if(dictionaryCityJson != nil)
			{
				// 解析该车站对象
				TrainCity *trainCity = [[TrainCity alloc] init];
				[trainCity parseSearchResult:dictionaryCityJson];
				[arrayTrainCityTmp addObject:trainCity];
			}
		}
	}
	_arrayStations = arrayTrainCityTmp;
    
    // =======================================================================
    // 来源厂商Id
    // =======================================================================
    _wrapperId = [dictionaryResultJson safeObjectForKey:@"wrapperId"];
    
    // 是否出错
    _isError = [dictionaryResultJson safeObjectForKey:@"IsError"];
    
    // 出错时显示出错代码
    _errorCode = [dictionaryResultJson safeObjectForKey:@"ErrorCode"];
    
    // 错误信息
    _errorMessage = [dictionaryResultJson safeObjectForKey:@"ErrorMessage"];
}



- (void)trainCityUpdateStart
{
    // ===========================================
    // 中途车站搜索
    // ===========================================
    // 组织Json
	NSMutableDictionary *dictionaryJson = [[NSMutableDictionary alloc] init];
    
    
    // ota 代理商
    [dictionaryJson safeSetObject:@"ika0000000" forKey:@"wrapperId"];
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods composeNetSearchUrl:@"mytrain"
                                            forService:@"getStationList"
                                              andParam:paramJson];
    
    if (url != nil)
    {
        [HttpUtil requestURL:url postContent:nil delegate:self disablePop:YES disableClosePop:YES disableWait:YES];
    }
    
}




- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
//    NSLog(@"%@", root);
    
    
    // 解析结果数据
    [self parseTrainCityUpdateResult:root];
    
    if (_isError !=nil && [_isError boolValue] == NO)
    {
        // 格式化数据并保存本地
        [self formatAndSaveTrainCityData];
        
        // 将版本号保存本地
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* trainCityVersionTmp = [defaults objectForKey:@"trainCityVersionTmp"];
        // 保存为正式版本号
        if (STRINGHASVALUE(trainCityVersionTmp))
        {
            [defaults setValue:trainCityVersionTmp forKey:@"trainCityVersion"];
            [defaults synchronize];
        }
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
//    NSLog(@"trainCityUpdate Error");
}


// 热门城市
- (NSArray *)getTrainHotcity
{
    NSArray *hotCityName = [NSArray arrayWithObjects:@"北京",@"上海",@"石家庄",@"南京",@"郑州",@"深圳",@"福州",@"广州",@"杭州",@"苏州",@"济南",@"西安",@"太原",@"成都",@"青岛",@"天津",@"厦门",@"徐州",@"温州",@"义乌", nil];
    
    NSMutableArray *arrayHotCity = [[NSMutableArray alloc] init];
    NSArray *cityTmp = nil;
    if (_arrayStations != nil && [_arrayStations count] > 0)
    {
        for (NSInteger i=0; i<[hotCityName count]; i++)
        {
            NSString *curHotCity = [hotCityName safeObjectAtIndex:i];
            if (curHotCity != nil)
            {
                for (NSInteger j=0; j<[_arrayStations count]; j++)
                {
                    TrainCity *trainCity = [_arrayStations safeObjectAtIndex:j];
                    if (trainCity != nil)
                    {
                        NSString *cityName = [trainCity stationName];
                        if (cityName != nil && ([cityName isEqualToString:curHotCity]))
                        {
                            cityTmp = [NSArray arrayWithObjects:cityName,[trainCity stationPY],[trainCity stationPYS], nil];
                            
                            [arrayHotCity addObject:cityTmp];
                        }
                    }
                }
            }
        }
        
        return arrayHotCity;
    }
    
    return nil;
}


//
- (void)formatAndSaveTrainCityData
{
    // ===============================================
    // 格式化数据
    // ===============================================
    NSArray *arrayKey = [NSArray arrayWithObjects: @"热门",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N",@"P", @"Q", @"R", @"S",@"T", @"W", @"X", @"Y", @"Z", nil];
    
    // 
    NSMutableDictionary *dictCityPlist = [[NSMutableDictionary alloc ] init];
    
    if (_arrayStations != nil && [_arrayStations count] > 0)
    {
        // 根据key来填充值
        for (NSInteger i=0; i<[arrayKey count]; i++)
        {
            NSString *keyValue = [arrayKey safeObjectAtIndex:i];
            
            // 热门城市
            if ((i==0) && [self getTrainHotcity] != nil)
            {
                [dictCityPlist safeSetObject:[self getTrainHotcity] forKey:keyValue];
            }
            // 其余城市
            else
            {
                NSMutableArray *arrayCity = [[NSMutableArray alloc] init];
                NSArray *cityTmp = nil;
                
                for (NSInteger i=0; i<[_arrayStations count]; i++)
                {
                    TrainCity *trainCity = [_arrayStations safeObjectAtIndex:i];
                    if (trainCity != nil)
                    {
                        NSString *cityPY = [trainCity stationPY];
                        if (cityPY != nil)
                        {
                            NSString *firstStr=[cityPY substringWithRange:NSMakeRange(0, 1)];
                            if ([firstStr caseInsensitiveCompare:keyValue] == NSOrderedSame)
                            {
                                cityTmp = [NSArray arrayWithObjects:[trainCity stationName],[trainCity stationPY],[trainCity stationPYS], nil];
                                [arrayCity addObject:cityTmp];
                            }
                        }
                    }
                }
                
                // 填充到字典中
                [dictCityPlist safeSetObject:arrayCity forKey:keyValue];
            }
        }
    }
    
    // ===============================================
    // 保存
    // ===============================================
    // 获取document文件夹位置
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    // 写入文件中
    NSString *fTrainCityPath = [documentDirectory stringByAppendingPathComponent:@"railwaycity.plist"];
    [dictCityPlist writeToFile:fTrainCityPath atomically:YES];
    
}


@end
