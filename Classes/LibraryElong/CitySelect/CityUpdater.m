//
//  CityUpdater.m
//  ElongClient
//
//  Created by garin on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CityUpdater.h"
@implementation CityUpdater

-(void)dealloc
{
    if (cityListRequest)
    {
        [cityListRequest cancel];
        SFRelease(cityListRequest);
    }
    
    [apiCityVersion release];
    
    NSLog(@"CityUpdater is dellloced");
    
    [super dealloc];
}

-(id) init:(NSString *) apiCityVersion_
{
    if (self=[super init])
    {
        apiCityVersion=apiCityVersion_;
        [apiCityVersion retain];
    }
    
    return self;
}

//发送更新请求,自动释放自己
-(void) sendUpdateReqThenDealloc
{
    //不需要更新，返回
    if (![self isNeedUpdate])
    {
        [self release];
        return;
    }
    
    //城市列表
    NSString *url = [self getCityUrl];
    
    if (!STRINGHASVALUE(url))
    {
        [self release];
        return;
    }
    
    if (cityListRequest)
    {
        [cityListRequest cancel];
        SFRelease(cityListRequest);
    }
    
    cityListRequest = [[HttpUtil alloc] init];
    [cityListRequest requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
}

//小数字符串转换成整数
+(int) stringConvertToint:(NSString*)string
{
	int m_intNum;
	NSMutableString* m_temp = [[NSMutableString alloc] init];
	NSArray *m_array = [string componentsSeparatedByString:@"."];
	NSEnumerator* enumerator = [m_array objectEnumerator];
	
	NSString *obj;
	
	while(obj = [enumerator nextObject])
	{
		[m_temp appendString:obj];
		
	}
	m_intNum = [m_temp intValue];
	[m_temp release];
	return m_intNum;
	
}

//是否需要更新检测,子类去实现
-(BOOL) isNeedUpdate
{
    //api没有配置不更新
    if (!STRINGHASVALUE(apiCityVersion))
    {
        return NO;
    }
    
    //获取本地城市版本
    [self setLocalCityVersion];
    
    if (!STRINGHASVALUE(localCityVersion))
    {
        return YES;
    }
    
    if ([CityUpdater stringConvertToint:localCityVersion]<[CityUpdater stringConvertToint:apiCityVersion])
    {
        return YES;
    }
    
    return NO;
}

//赋值本地版本,子类实现
-(void) setLocalCityVersion
{

}

//得到请求的url,子类实现
-(NSString *) getCityUrl
{
    return nil;
}

#pragma mark -
#pragma mark 更新本地数据
//酒店城市列表更新，子类实现
-(void) updateCityListData:(NSDictionary *) dict
{
    
}

#pragma mark -
#pragma mark HttpDelegate

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    [self release];
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    if (util!=cityListRequest)
    {
        [self release];
        return;
    }
    
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if ([Utils checkJsonIsErrorNoAlert:root])
    {
        [self release];
        return;
    }
    
    //更新数据
    [self updateCityListData:root];
    
    [self release];
}
@end
