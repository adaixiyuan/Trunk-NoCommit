//
//  HotelCityUpdater.m
//  ElongClient
//  国内酒店updater
//  Created by garin on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelCityUpdater.h"

#define HotelCityVersion @"HotelCityVersion"   //酒店城市列表的版本key
#define HotelNewPlistName @"hotelcity_s.plist" //最新的城市列表文件名

@implementation HotelCityUpdater

//得到城市列表plist文件路径
+(NSString *) getCityListPlistName:(NSString *)plistName_
{
    NSString *cPath = [HotelCityUpdater getHotelListCityPath];
    //文件不存在，用本地的
    if ([[NSFileManager defaultManager] fileExistsAtPath:cPath])
    {
        return cPath;
    }
    else
    {
        return [[NSBundle mainBundle] pathForResource:plistName_ ofType:@"plist"];
    }
}

//得到从api获得的城市列表本地路径
+(NSString *) getHotelListCityPath
{
    //生成plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:CityDataDirectoryPath];
    cPath = [cPath stringByAppendingPathComponent:HotelNewPlistName];
    
    return cPath;
}

#pragma mark -
#pragma mark 基类方法重写

//是否需要更新检测,子类去实现
-(BOOL) isNeedUpdate
{
    NSString *cPath = [HotelCityUpdater getHotelListCityPath];
    //不存在文件，更新
    if (![[NSFileManager defaultManager] fileExistsAtPath:cPath])
    {
        return YES;
    }
    
    return [super isNeedUpdate];
}

-(void) setLocalCityVersion
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    localCityVersion = [ud objectForKey:HotelCityVersion];
}

//得到请求的url
-(NSString *) getCityUrl
{
    NSDictionary  *dic = [NSDictionary dictionary];
    NSString  *str = [dic JSONString];
    return [PublicMethods composeNetSearchUrl:@"hotel" forService:@"cities" andParam:str];
}

#pragma mark -
#pragma mark 更新本地数据
//酒店城市列表更新
-(void) updateCityListData:(NSDictionary *) dict
{
    //组装数据
    NSArray *allCities=[dict safeObjectForKey:@"allCities"];
    NSArray *hotCities=[dict safeObjectForKey:@"hotCities"];
    
    //有一个数据是没有值，绝对有问题
    if (!ARRAYHASVALUE(allCities)||!ARRAYHASVALUE(hotCities))
    {
        return;
    }
    
    NSArray *groupArray = [NSArray arrayWithObjects: @"热门",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N",@"P", @"Q", @"R", @"S",@"T", @"W", @"X", @"Y", @"Z", nil];
    
    //生成plist data的数据
    NSMutableDictionary *parseData=[NSMutableDictionary dictionary];
    
    //初始化group
    for (NSString * sKey in groupArray)
    {
        [parseData safeSetObject:[NSMutableArray array] forKey:sKey];
    }
    
    for (NSDictionary *tem in allCities)
    {
        //得到拼音
        NSString *pinyin=[tem safeObjectForKey:@"pinYin"];
        NSString *cityId=[tem safeObjectForKey:@"cityId"];
        NSString *cityName=[tem safeObjectForKey:@"cityName"];
        NSString *jianPin=[tem safeObjectForKey:@"jianPin"];
        if (!STRINGHASVALUE(pinyin)||!STRINGHASVALUE(cityId)||!STRINGHASVALUE(cityName)||!STRINGHASVALUE(jianPin))
        {
            continue;
        }
        
        NSString *sectionName=[pinyin substringToIndex:1];
        if (!STRINGHASVALUE(sectionName)) {
            continue;
        }
        
        //首字母大写，做为分组
        sectionName=[sectionName uppercaseString];
        
        //对应的组数据，用来放本字母下的城市数据
        NSMutableArray *arr = [parseData safeObjectForKey:sectionName];
        
        //城市项
        NSArray *cityItem=[NSArray arrayWithObjects:cityName,pinyin,jianPin,cityId,nil];
        
        [arr addObject:cityItem];
    }
    
    //热门数组
    NSMutableArray *arr = [parseData safeObjectForKey:@"热门"];
    for (NSDictionary *tem in hotCities)
    {
        //得到拼音
        NSString *pinyin=[tem safeObjectForKey:@"pinYin"];
        NSString *cityId=[tem safeObjectForKey:@"cityId"];
        NSString *cityName=[tem safeObjectForKey:@"cityName"];
        if (!STRINGHASVALUE(pinyin)||!STRINGHASVALUE(cityId)||!STRINGHASVALUE(cityName))
        {
            continue;
        }
        
        //城市项
        NSArray *cityItem=[NSArray arrayWithObjects:cityName,pinyin,cityId,nil];
        
        [arr addObject:cityItem];
    }
    
    //生成plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:CityDataDirectoryPath];
    
    //检测是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:cPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    cPath = [cPath stringByAppendingPathComponent:HotelNewPlistName];
    
    //保存
    BOOL isSaveSuccess=[parseData writeToFile:cPath atomically:YES];
    
    //保存版本
    if (isSaveSuccess)
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if (STRINGHASVALUE(apiCityVersion))
        {
            [ud setObject:apiCityVersion forKey:HotelCityVersion];
            [ud synchronize];
        }
    }
}

@end
