//
//  CacheManage.m
//  ElongClient
//
//  Created by 赵 海波 on 13-4-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CacheManage.h"
#import "UIDevice-Hardware.h"
#import <CommonCrypto/CommonDigest.h>

/*
 * Cache Default Config
 */
#define Default_Cache_Version               @"0.0"  // 默认本地缓存版本号
#define Cache_Hotel_Suggest_Time            172800  // 酒店suggest缓存保留时间（秒）
#define Cache_Hotel_Suggest_Size            100000  // 酒店suggest缓存文件夹最大size（最少能容纳5个城市的数据, byte）
#define Cache_HotelList_Time                600     // 酒店列表缓存保留时间（秒）
#define Cache_HotelList_Count               10      // 酒店列表缓存数
#define Cache_HotelList_Image_Time          9999999 // 酒店列表图片缓存时间（秒）
#define Cache_HotelList_Image_Size          2000000 // 酒店列表缓存大小（byte）
#define Cache_HotelDetail_Time              180     // 酒店详情缓存时间（秒）
#define Cache_HotelDetail_Count             10      // 酒店详情缓存数
#define Cache_GrouponList_Time              600     // 团购列表的保存时间
#define Cache_GrouponList_Count             10      // 团购列表的保存数
#define Cache_GrouponDetail_Time            300     // 团购详情的保存时间
#define Cache_GrouponDetail_Count           10      // 团购详情的保存数
#define Cache_Bank_Time                     2592000 // 银行列表缓存时间（秒）
#define Cache_Area_Time                     10080   // 行政区、商圈缓存时间（秒）

#define CanUse_Hotel_SuggestCache           YES
#define CanUse_AreaCache                    YES
#define CanUse_HotelList_Cache              YES
#define CanUse_HotelList_ImageCache         YES
#define CanUse_HotelDetail_Cache            YES
#define CanUse_GrouponList_Cache            YES
#define CanUse_GrouponDetail_Cache          YES
#define CanUse_BankCache                    YES

/*
 * Cache Path
 */
#define CACHE_EXTENSION         @"cache"
#define CACHE_CONFIG            @"Documents/LocalCache/config"
#define CACHE_HOTEL_SUGGEST     @"Documents/LocalCache/HotelSuggest/"
#define CACHE_HOTEL_LIST        @"Documents/LocalCache/HotelList/"
#define CACHE_HOTEL_LIST_IMAGE  @"Documents/LocalCache/HotelListImage/"
#define CACHE_HOTEL_DETAIL      @"Documents/LocalCache/HotelDetail/"
#define CACHE_GROUPON_LIST      @"Documents/LocalCache/GrouponList/"
#define CACHE_GROUPON_DETAIL    @"Documents/LocalCache/GrouponDetail/"
#define CACHE_BANK              @"Documents/LocalCache/bankList"
#define CACHE_AREA              @"Documents/LocalCache/areaList"

/*
 * Cache Keys
 */
#define CACHE_ITEMS                 @"Items"
#define CACHE_KEY                   @"Key"
#define CACHE_MODE                  @"Mode"
#define CACHE_TIME_MINUTES          @"CacheTimeMinutes"
#define CACHE_SIZE                  @"Size"
#define CACHE_HOTELLIST_IMAGE_KEY   @"hotellistpiccachesize"
#define CACHE_HOTELLIST_KEY         @"hotellist"
#define CACHE_HOTELDETAIL_KEY       @"hoteldetail"
#define CACHE_HOTE_SUGGEST_KEY      @"suggestdata"
#define CACHE_GROUPONLIST_KEY       @"grouponlist"
#define CACHE_GROUPONDETAIL_KEY     @"groupondetail"
#define CACHE_BANKLIST_KEY          @"banklist"
#define CACHE_BIZDISTRICT_KEY       @"bizdistrict"

static CacheManage *cacheManager = nil;

@implementation CacheManage

@synthesize canUseCache;
@synthesize cacheVersion;
@synthesize currentDelFile;


+ (id)manager {
    @synchronized(cacheManager) {
        if (!cacheManager) {
            cacheManager = [[CacheManage alloc] init];
        }
    }
    
    return cacheManager;
}


- (void)dealloc {
    [fileManager release];
    [device release];
    
    self.cacheVersion = nil;
    self.currentDelFile = nil;
    
    [super dealloc];
}


- (id)init {
    if (self = [super init]) {
        fileManager = [[NSFileManager alloc] init];
        device = [[UIDevice alloc] init];
        
        canUseCache = YES;
        [self configCache];
    }
    
    return self;
}


#pragma mark
#pragma mark Cache Config

- (void)configCache {
    // 配置各缓存项
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:CACHE_CONFIG];
    if ([fileManager fileExistsAtPath:filePath]) {
        // 有配置取出文件
        NSDictionary *cacheDic = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:filePath]];
        
        // 设置缓存版本
        self.cacheVersion = [NSString stringWithFormat:@"%@", [cacheDic safeObjectForKey:CACHE_VERSION]];
        
        // 设置各项缓存的值
        NSArray *configs = [cacheDic safeObjectForKey:CACHE_ITEMS];
        if (ARRAYHASVALUE(configs)) {
            for (NSDictionary *dic in configs) {
                NSString *key = [NSString stringWithFormat:@"%@", [dic safeObjectForKey:CACHE_KEY]];
                if ([key isEqualToString:CACHE_HOTE_SUGGEST_KEY]) {
                    // 配置suggest，有值取值，没值取本地默认配置
                    [self configSuggestCache:dic];
                }
                else if ([key isEqualToString:CACHE_BIZDISTRICT_KEY]) {
                    [self configAreaCache:dic];
                }
                else if ([key isEqualToString:CACHE_HOTELLIST_KEY]) {
                    // 配置酒店列表，有值取值，没值取本地默认配置
                    [self configHotelListCache:dic];
                }
                else if ([key isEqualToString:CACHE_HOTELLIST_IMAGE_KEY]) {
                    // 配置酒店列表图片，有值取值，没值取本地默认配置
                    [self configHotelListImageCache:dic];
                }
                else if ([key isEqualToString:CACHE_HOTELDETAIL_KEY]) {
                    // 配置酒店详情，有值取值，没值取本地默认配置
                    [self configHotelDetailCache:dic];
                }
                else if ([key isEqualToString:CACHE_BANKLIST_KEY]) {
                    // 配置银行列表，有值取值，没值取本地默认配置
                    [self configBankCache:dic];
                }
                else if ([key isEqualToString:CACHE_GROUPONLIST_KEY]) {
                    // 配置团购列表，有值取值，没值取本地默认值
                    [self configGrouponListCache:dic];
                }
                else if ([key isEqualToString:CACHE_GROUPONDETAIL_KEY]) {
                    // 配置团购详情，有值取值，没值取本地默认值
                    [self configGrouponDetailCache:dic];
                }
            }
        }
    }
    else {
        // 没有配置，用默认值作为配置
        self.cacheVersion = Default_Cache_Version;
        
        canUseHotelSuggestCache         = CanUse_Hotel_SuggestCache;
        cacheHotelSuggestTime           = Cache_Hotel_Suggest_Time;
        cacheHotelSuggestSize           = Cache_Hotel_Suggest_Size;
        canUseHotelListCache            = CanUse_HotelList_Cache;
        cacheHotelListTime              = Cache_HotelList_Time;
        cacheHotelListCount             = Cache_HotelList_Count;
        canUseHotelListImageCache       = CanUse_HotelList_ImageCache;
        cacheHotelListImageTime         = Cache_HotelList_Image_Time;
        cacheHotelListImageSize         = Cache_HotelList_Image_Size;
        canUseHotelDetailCache          = CanUse_HotelDetail_Cache;
        cacheHotelDetailTime            = Cache_HotelDetail_Time;
        cacheHotelDetailCount           = Cache_HotelDetail_Count;
        canUseGrouponListCache          = CanUse_GrouponList_Cache;
        cacheGrouponListTime            = Cache_GrouponList_Time;
        cacheGrouponListCount           = Cache_GrouponList_Count;
        canUseGrouponDetailCache        = CanUse_GrouponDetail_Cache;
        cacheGrouponDetailTime          = Cache_GrouponDetail_Time;
        cacheGrouponDetailCount         = Cache_GrouponDetail_Count;
        canUseHotelAreaCache            = CanUse_AreaCache;
        cacheHotelAreaTime              = Cache_Area_Time;
        canUseBankCache                 = CanUse_BankCache;
        cacheBankTime                   = Cache_Bank_Time;
    }
}


- (void)setCacheValueFromDataSource:(NSDictionary *)cacheDic {
    // 判断是否有缓存配置策略更新
    NSArray *configs = [cacheDic safeObjectForKey:CACHE_ITEMS];
    if (ARRAYHASVALUE(configs)) {
        // 设置缓存版本
        self.cacheVersion = [NSString stringWithFormat:@"%@", [cacheDic safeObjectForKey:CACHE_VERSION]];
        
        // 更替原来的缓存文件
        NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:cacheDic];
        if (cacheData.length < [device freeDiskSpaceBytes]) {
            NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:CACHE_CONFIG];
            
            NSString *directoryPath = [filePath stringByDeletingLastPathComponent];
            BOOL isDir;
            if (![fileManager fileExistsAtPath:directoryPath isDirectory:&isDir]) {
                [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            [cacheData writeToFile:filePath atomically:YES];
            
            [self configCache];     // 更新缓存配置
        }
        else {
            NSLog(@"no enough space to save cache config!");
        }
    }
    else {
        NSLog(@"no new cache configuration!");
    }
}


- (void)configSuggestCache:(NSDictionary *)configDic {
    NSNumber *suggestMode = [configDic safeObjectForKey:CACHE_MODE];
    canUseHotelSuggestCache = OBJECTISNULL(suggestMode) ? CanUse_Hotel_SuggestCache : [suggestMode intValue];
    
    NSNumber *suggestTime = [configDic safeObjectForKey:CACHE_TIME_MINUTES];
    cacheHotelSuggestTime = OBJECTISNULL(suggestTime) ?  Cache_Hotel_Suggest_Time : [suggestTime intValue] * 60;
    
    NSNumber *suggestSize = [configDic safeObjectForKey:CACHE_SIZE];
    cacheHotelSuggestSize = OBJECTISNULL(suggestSize) ? Cache_Hotel_Suggest_Size : [suggestSize intValue];
}


- (void)configAreaCache:(NSDictionary *)configDic {
    // 只配置开关和时效，不对大小做限制
    NSNumber *areaMode = [configDic safeObjectForKey:CACHE_MODE];
    canUseHotelAreaCache = OBJECTISNULL(areaMode) ? CanUse_AreaCache : [areaMode intValue];
    
    NSNumber *areaTime = [configDic safeObjectForKey:CACHE_TIME_MINUTES];
    cacheHotelAreaTime = OBJECTISNULL(areaTime) ? Cache_Area_Time : [areaTime intValue] * 60;
}


- (void)configHotelListCache:(NSDictionary *)configDic {
    NSNumber *listMode = [configDic safeObjectForKey:CACHE_MODE];
    canUseHotelListCache = OBJECTISNULL(listMode) ? CanUse_HotelList_Cache : [listMode intValue];
    
    NSNumber *listTime = [configDic safeObjectForKey:CACHE_TIME_MINUTES];
    cacheHotelListTime = OBJECTISNULL(listTime) ?  Cache_HotelList_Time : [listTime intValue] * 60;
    
    NSNumber *listSize = [configDic safeObjectForKey:CACHE_SIZE];
    cacheHotelListCount = OBJECTISNULL(listSize) ? Cache_HotelList_Count : [listSize intValue];
}


- (void)configHotelListImageCache:(NSDictionary *)configDic {
    NSNumber *listImageMode = [configDic safeObjectForKey:CACHE_MODE];
    canUseHotelListImageCache = OBJECTISNULL(listImageMode) ? CanUse_HotelList_ImageCache : [listImageMode intValue];
    
    NSNumber *listImageTime = [configDic safeObjectForKey:CACHE_TIME_MINUTES];
    cacheHotelListImageTime = OBJECTISNULL(listImageTime) ?  Cache_HotelList_Image_Time : [listImageTime intValue] * 60 * 14; // api返回12小时，先强制改为一周
    
    NSNumber *listImageSize = [configDic safeObjectForKey:CACHE_SIZE];
    cacheHotelListImageSize = OBJECTISNULL(listImageSize) ? Cache_HotelList_Image_Size : [listImageSize intValue];
}


- (void)configHotelDetailCache:(NSDictionary *)configDic {
    NSNumber *detailMode = [configDic safeObjectForKey:CACHE_MODE];
    canUseHotelDetailCache = OBJECTISNULL(detailMode) ? CanUse_HotelDetail_Cache : [detailMode intValue];
    
    NSNumber *detailTime = [configDic safeObjectForKey:CACHE_TIME_MINUTES];
    cacheHotelDetailTime = OBJECTISNULL(detailTime) ?  Cache_HotelDetail_Time : [detailTime intValue] * 60;
    
    NSNumber *detailSize = [configDic safeObjectForKey:CACHE_SIZE];
    cacheHotelDetailCount = OBJECTISNULL(detailSize) ? Cache_HotelDetail_Count : [detailSize intValue];
}


- (void)configGrouponListCache:(NSDictionary *)configDic {
    NSNumber *mode = [configDic safeObjectForKey:CACHE_MODE];
    canUseGrouponListCache = OBJECTISNULL(mode) ? CanUse_GrouponList_Cache : [mode intValue];
    
    NSNumber *time = [configDic safeObjectForKey:CACHE_TIME_MINUTES];
    cacheGrouponListTime = OBJECTISNULL(time) ?  Cache_GrouponList_Time : [time intValue] * 60;
    
    NSNumber *size = [configDic safeObjectForKey:CACHE_SIZE];
    cacheGrouponListCount = OBJECTISNULL(size) ? Cache_HotelDetail_Count : [size intValue];
}


- (void)configGrouponDetailCache:(NSDictionary *)configDic {
    NSNumber *mode = [configDic safeObjectForKey:CACHE_MODE];
    canUseGrouponDetailCache = OBJECTISNULL(mode) ? CanUse_GrouponDetail_Cache : [mode intValue];
    
    NSNumber *time = [configDic safeObjectForKey:CACHE_TIME_MINUTES];
    cacheGrouponDetailTime = OBJECTISNULL(time) ?  Cache_GrouponDetail_Time : [time intValue] * 60;
    
    NSNumber *size = [configDic safeObjectForKey:CACHE_SIZE];
    cacheGrouponDetailCount = OBJECTISNULL(size) ? Cache_GrouponDetail_Count : [size intValue];
}


- (void)configBankCache:(NSDictionary *)configDic {
    NSNumber *bankMode = [configDic safeObjectForKey:CACHE_MODE];
    canUseBankCache = OBJECTISNULL(bankMode) ? CanUse_BankCache : [bankMode intValue];
    
    NSNumber *bankTime = [configDic safeObjectForKey:CACHE_TIME_MINUTES];
    cacheBankTime = OBJECTISNULL(bankTime) ?  Cache_Bank_Time : [bankTime intValue] * 60;
}


#pragma mark 
#pragma mark Private Methods

- (unsigned long long)getDirectorySizeAtPath:(NSString *)path withFileOutTime:(long long)seconds {
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:path];
    
    NSString *file;
    unsigned long long directorySize = 0;    // 目录大小
    
    while (file = [dirEnum nextObject]) {
        if ([[file pathExtension] isEqualToString:CACHE_EXTENSION]) {
            NSDictionary *fileAttribute = [self scanFileAtPath:[path stringByAppendingPathComponent:file] withFileOutTime:seconds];
            directorySize += [[fileAttribute safeObjectForKey:NSFileSize] longLongValue];
        }
    }
    
    return directorySize;
}


- (unsigned long long)getImageDirectorySizeAtPath:(NSString *)path withFileOutTime:(long long)seconds {
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:path];
    
    NSString *file;
    unsigned long long directorySize = 0;    // 目录大小
    
    while (file = [dirEnum nextObject]) {
        if ([[file pathExtension] isEqualToString:@""]) {
            NSDictionary *fileAttribute = [self scanFileAtPath:[path stringByAppendingPathComponent:file] withFileOutTime:seconds];
            directorySize += [[fileAttribute safeObjectForKey:NSFileSize] longLongValue];
        }
    }
    
    return directorySize;
}


- (NSInteger)getDirectoryCountAtPath:(NSString *)path withFileOutTime:(long long)seconds {
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:path];
    
    NSString *file;
    NSInteger fileCount = 0;
    
    while (file = [dirEnum nextObject]) {
        if ([[file pathExtension] isEqualToString:CACHE_EXTENSION]) {
            [self scanFileAtPath:[path stringByAppendingPathComponent:file] withFileOutTime:seconds];
            fileCount ++;
        }
    }
    
    return fileCount;
}


- (NSString *)getTimeString {
    // 获取当前时间字符串
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSInteger suffixNum = arc4random() % 881888;
    
    NSString *fixTime = [[formatter stringFromDate:[NSDate date]] stringByAppendingFormat:@"%d", suffixNum];
    
    return fixTime;
}


- (NSDictionary *)scanFileAtPath:(NSString *)path withFileOutTime:(long long)seconds {
    // 返回文件信息
    NSDictionary *fileAttribute = [fileManager attributesOfItemAtPath:path error:nil];
    if (DICTIONARYHASVALUE(fileAttribute)) {
        NSDate *modifyDate = [fileAttribute safeObjectForKey:NSFileModificationDate]; // 取出文件上次的修改时间
        if ([[NSDate date] timeIntervalSinceDate:modifyDate] > seconds) {
            // 超时文件删除
            [fileManager removeItemAtPath:path error:nil];
            return nil;
        }
        
        return fileAttribute;
    }
    else {
        return nil;
    }
}


- (BOOL)removeEarliestDataForDirectoryAtPath:(NSString *)path withFileOutTime:(long long)seconds {
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:path];
    
    NSString *file;
    NSDate *earliestDate = nil;     // 纪录最早一个修改文件的时间
    
    while (file = [dirEnum nextObject]) {
        if ([[file pathExtension] isEqualToString:CACHE_EXTENSION]) {
            // 在遍历的过程中自动删除过期数据
            NSDictionary *fileAttribute = [self scanFileAtPath:[path stringByAppendingPathComponent:file] withFileOutTime:seconds];
            NSDate *date = [fileAttribute safeObjectForKey:NSFileModificationDate];
            
            if (!earliestDate) {
                earliestDate = date;
                self.currentDelFile = file;
            }
            else {
                if ([earliestDate compare:date] == NSOrderedDescending) {
                    // 将时间较早的文件置为删除文件
                    earliestDate = date;
                    self.currentDelFile = file;
                }
            }
        }
    }
    
    return [fileManager removeItemAtPath:[path stringByAppendingPathComponent:currentDelFile] error:nil];
}


// 适用于有按搜索条件来存储缓存的情况，有过期时间，先进先出
- (void)setCacheData:(NSData *)data forCondition:(NSString *)condition AtDirectory:(NSString *)dirPath WithOutTime:(long long)outTime AndCapacity:(NSInteger)capacity {
    // 构造缓存路径
    NSString *directoryPath = [NSHomeDirectory() stringByAppendingPathComponent:dirPath];
    NSString *fileName = [condition md5Coding];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:CACHE_EXTENSION]];
    
    BOOL isDir;
    if (![fileManager fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        // 没有suggest缓存目录时先创建目录
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (data.length < [device freeDiskSpaceBytes]) {
        // 判断缓存的条数是否超过上限
        [data writeToFile:filePath atomically:YES];
        
        if ([self getDirectoryCountAtPath:directoryPath withFileOutTime:outTime] > capacity) {
            // 如果超过条数上限，清空较早的数据
            [self removeEarliestDataForDirectoryAtPath:directoryPath withFileOutTime:outTime];
        }
    }
    else {
        NSLog(@"no enough space to save data!");
    }
}


// 适用于有按搜索条件来获取缓存的情况，有过期时间，先进先出
- (NSData *)getCacheDataForCondition:(NSString *)condition AtDectory:(NSString *)dirPath WithOutTime:(long long)outTime {
    NSString *directoryPath = [NSHomeDirectory() stringByAppendingPathComponent:dirPath];
    NSString *fileName = [condition md5Coding];
    
    if (STRINGHASVALUE(fileName)) {
        // 如果存在该文件名，再构造取该文件的地址
        NSString *filePath = [directoryPath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:CACHE_EXTENSION]];
        
        if ([fileManager fileExistsAtPath:filePath] && [[filePath pathExtension] isEqualToString:CACHE_EXTENSION]) {
            // 找到数据后先检查超时情况
            [self scanFileAtPath:filePath withFileOutTime:outTime];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            
            return data;
        }
        else {
            NSLog(@"no such cache file!");
            return nil;
        }
    }
    else {
        NSLog(@"cache file name error!");
        return nil;
    }
}


//- ()
//{
//    NSFileManager* fileManager=[NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
//    
//    NSLog(@"%@",paths);
//    //文件名
//    NSString *uniquePath=[[paths safeObjectAtIndex:0] stringByAppendingPathComponent:@"com.elong.app"];
//    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
//    if (!blHave) {
//        NSLog(@"no  have");
//        return ;
//    }else {
//        NSLog(@" have");
//        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
//        if (blDele) {
//            NSLog(@"dele success");
//        }else {
//            NSLog(@"dele fail");
//        }
//        
//    }
//}

#pragma mark
#pragma mark Public Methods

- (void)setHotelSuggests:(NSDictionary *)paramDic forCity:(NSString *)cityID {
    if (canUseCache && canUseHotelSuggestCache) {
        if (DICTIONARYHASVALUE(paramDic)) {
            NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[CACHE_HOTEL_SUGGEST stringByAppendingPathComponent:[cityID stringByAppendingPathExtension:CACHE_EXTENSION]]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:paramDic];
            
            BOOL isDir;
            NSString *directoryPath = [filePath stringByDeletingLastPathComponent];
            
            if (![fileManager fileExistsAtPath:directoryPath isDirectory:&isDir]) {
                // 没有suggest缓存目录时先创建目录
                [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            // 判断压缩数据是否小于当前可用硬盘量
            if (data.length < [device freeDiskSpaceBytes]) {
                [data writeToFile:filePath atomically:YES];
                
                // 判断suggest文件夹大小是否在规定范围内
                NSString *suggestPath = [NSHomeDirectory() stringByAppendingPathComponent:CACHE_HOTEL_SUGGEST];
                if ([self getDirectorySizeAtPath:suggestPath withFileOutTime:cacheHotelSuggestTime] >= cacheHotelSuggestSize) {
                    // 超过规定大小时，清理时间较早的数据
                    if (![self removeEarliestDataForDirectoryAtPath:suggestPath withFileOutTime:cacheHotelSuggestTime]) {
                        NSLog(@"clear directory failed!");
                    }
                }
            }
            else {
                NSLog(@"no enough space to save data!");
            }
        }
        else {
            NSLog(@"no suggest can be saved!");
        }
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
}


- (id)getHotelSuggestFromCity:(NSString *)cityID {
    if (canUseCache && canUseHotelSuggestCache) {
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[CACHE_HOTEL_SUGGEST stringByAppendingPathComponent:[cityID stringByAppendingPathExtension:CACHE_EXTENSION]]];
        
        if ([fileManager fileExistsAtPath:filePath] && [[filePath pathExtension] isEqualToString:CACHE_EXTENSION]) {
            // 找到数据后先检查超时情况再解压缩
            [self scanFileAtPath:filePath withFileOutTime:cacheHotelSuggestTime];
            
            return [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:filePath]];
        }
        else {
            NSLog(@"no suggest of the city exist!");
            return nil;
        }
    }
    else {
        NSLog(@"cache access is forbidden!!");
        return nil;
    }
}


// 设置（获取）行政区、商圈缓存
- (void)setHotelArea:(NSData *)areaData forSearching:(NSString *)searchCondition {
    if (canUseCache && canUseHotelAreaCache) {
        if (areaData.length > 0) {
            [self setCacheData:areaData forCondition:searchCondition AtDirectory:CACHE_AREA WithOutTime:cacheHotelAreaTime AndCapacity:INT_MAX];
        }
        else {
            NSLog(@"no area list can be saved!");
        }
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
}


- (id)getHotelAreaFromSearching:(NSString *)searchCondition {
    if (canUseCache && canUseHotelAreaCache) {
        return [self getCacheDataForCondition:searchCondition AtDectory:CACHE_AREA WithOutTime:cacheHotelAreaTime];
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
    
    return nil;
}


- (void)setHotelListData:(NSData *)listData forSearching:(NSString *)searchCondition {
    if (canUseCache && canUseHotelListCache) {
        if (listData.length > 0) {
            [self setCacheData:listData forCondition:searchCondition AtDirectory:CACHE_HOTEL_LIST WithOutTime:cacheHotelListTime AndCapacity:cacheHotelListCount];
        }
        else {
            NSLog(@"no hotel list can be saved!");
        }
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
}


- (NSData *)getHotelListFromSearching:(NSString *)searchCondition {
    if (canUseCache && canUseHotelListCache) {
        return [self getCacheDataForCondition:searchCondition AtDectory:CACHE_HOTEL_LIST WithOutTime:cacheHotelListTime];
    }
    else {
        NSLog(@"cache access is forbidden!!");
        return nil;
    }
}


- (void)setHotelListImage:(NSData *)imageData forURL:(NSString *)imageURL {
    if (canUseCache && canUseHotelListImageCache) {
        if (imageData.length > 0) {
            if (imageData.length < [device freeDiskSpaceBytes]) {
                if (STRINGHASVALUE(imageURL)) {
                    NSString *directoryPath = [NSHomeDirectory() stringByAppendingPathComponent:CACHE_HOTEL_LIST_IMAGE];
                    BOOL isDir;
                    
                    if (![fileManager fileExistsAtPath:directoryPath isDirectory:&isDir]) {
                        // 没有suggest缓存目录时先创建目录
                        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    else {
                        // 判断image文件夹大小是否在规定范围内
                        if ([self getDirectorySizeAtPath:directoryPath withFileOutTime:cacheHotelListImageTime] >= cacheHotelListImageSize) {
                            // 超过规定大小时，清空所有图片
                            [fileManager removeItemAtPath:directoryPath error:nil];
                            [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
                        }
                    }
                    
                    NSString *imagePath = [directoryPath stringByAppendingPathComponent:[imageURL md5Coding]];
                    
                    [imageData writeToFile:imagePath atomically:YES];
                }
                else {
                    NSLog(@"not a right URL");
                }
            }
            else {
                NSLog(@"no enough space to save data!");
            }
        }
        else {
            NSLog(@"not a image!");
        }
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
}


- (UIImage *)getHotelListImageByURL:(NSString *)imageURL {
    if (canUseCache && canUseHotelListImageCache) {
        NSString *directoryPath = [NSHomeDirectory() stringByAppendingPathComponent:CACHE_HOTEL_LIST_IMAGE];
        NSString *imagePath = [directoryPath stringByAppendingPathComponent:[imageURL md5Coding]];
        
        if ([fileManager fileExistsAtPath:imagePath]) {
            [self scanFileAtPath:imagePath withFileOutTime:cacheHotelListImageTime];
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            if (imageData.length > 0) {
                return [UIImage imageWithData:imageData];
            }
            else {
                return nil;
            }
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}


- (void)setHotelDetailData:(NSData *)detailData forSearching:(NSString *)searchCondition {
    if (canUseCache && canUseHotelDetailCache) {
        if (detailData.length > 0) {
            [self setCacheData:detailData forCondition:searchCondition AtDirectory:CACHE_HOTEL_DETAIL WithOutTime:cacheHotelDetailTime AndCapacity:cacheHotelDetailCount];
        }
        else {
            NSLog(@"no hotel detail can be saved!");
        }
    }
    else {
       NSLog(@"cache access is forbidden!!");
    }
}


- (NSData *)getHotelDetailFromSearching:(NSString *)searchCondition {
    if (canUseCache && canUseHotelDetailCache) {
        return [self getCacheDataForCondition:searchCondition AtDectory:CACHE_HOTEL_DETAIL WithOutTime:cacheHotelDetailTime];
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
    
    return nil;
}


- (void)setGrouponListData:(NSData *)listData forSearching:(NSString *)searchCondition {
    if (canUseCache && canUseGrouponListCache) {
        if (listData.length > 0) {
            [self setCacheData:listData forCondition:searchCondition AtDirectory:CACHE_GROUPON_LIST WithOutTime:cacheGrouponListTime AndCapacity:cacheGrouponListCount];
        }
        else {
            NSLog(@"no groupon list can be saved!");
        }
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
}


- (NSData *)getGrouponListFromSearching:(NSString *)searchCondition {
    if (canUseCache && canUseGrouponListCache) {
        return [self getCacheDataForCondition:searchCondition AtDectory:CACHE_GROUPON_LIST WithOutTime:cacheGrouponListTime];
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
    
    return nil;
}


- (void)setGrouponDetailData:(NSData *)detailData forSearching:(NSString *)searchCondition {
    if (canUseCache && canUseGrouponDetailCache) {
        if (detailData.length > 0) {
            [self setCacheData:detailData forCondition:searchCondition AtDirectory:CACHE_GROUPON_DETAIL  WithOutTime:cacheGrouponDetailTime AndCapacity:cacheGrouponDetailCount];
        }
        else {
            NSLog(@"no groupon list can be saved!");
        }
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
}


- (NSData *)getGrouponDetailFromSearching:(NSString *)searchCondition {
    if (canUseCache && canUseGrouponDetailCache) {
        NSString *directoryPath = [NSHomeDirectory() stringByAppendingPathComponent:CACHE_GROUPON_DETAIL];
        NSString *fileName = [searchCondition md5Coding];
        
        if (STRINGHASVALUE(fileName)) {
            // 如果存在该文件名，再构造取该文件的地址
            NSString *filePath = [directoryPath stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:CACHE_EXTENSION]];
            
            NSDictionary *fileAttribute = [fileManager attributesOfItemAtPath:filePath error:nil];
            if (DICTIONARYHASVALUE(fileAttribute)) {
                NSDate *modifyDate = [fileAttribute safeObjectForKey:NSFileModificationDate]; // 取出文件上次的修改时间
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CACHEFILE_MODITIME object:modifyDate];
            }
            
            return [self getCacheDataForCondition:searchCondition AtDectory:CACHE_GROUPON_DETAIL  WithOutTime:cacheGrouponDetailTime];
        }
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
    
    return nil;
}


- (void)setBankListData:(NSData *)bankData {
    if (canUseCache && canUseBankCache) {
        if (bankData.length > 0) {
            if (bankData.length < [device freeDiskSpaceBytes]) {
                NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[CACHE_BANK stringByAppendingPathExtension:CACHE_EXTENSION]];
                [bankData writeToFile:filePath atomically:YES];
            }
            else {
                NSLog(@"no enough space to save bank list file!");
            }
        }
        else {
            NSLog(@"no bank list can be saved!");
        }
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
}


- (NSData *)getBankListData {
    if (canUseCache && canUseBankCache) {
        // 先打开索引文件查看文件目录
       NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[CACHE_BANK stringByAppendingPathExtension:CACHE_EXTENSION]];
        
        if ([fileManager fileExistsAtPath:filePath] && [[filePath pathExtension] isEqualToString:CACHE_EXTENSION]) {
            [self scanFileAtPath:filePath withFileOutTime:cacheBankTime];
            return [NSData dataWithContentsOfFile:filePath];
        }
        else {
            NSLog(@"no cache for the bank list!");
        }
    }
    else {
        NSLog(@"cache access is forbidden!!");
    }
    
    return nil;
}


// 获取所有图片的缓存大小
- (unsigned long long)getCacheSizeOfImage
{
    unsigned long long totalSize = 0;
    
    // 自定义图片下载方法存入本地的大小
    NSString *customImgPath = [NSHomeDirectory() stringByAppendingPathComponent:CACHE_HOTEL_LIST_IMAGE];
    
    BOOL isDir;
    
    if ([fileManager fileExistsAtPath:customImgPath isDirectory:&isDir])
    {
        // 目录存在时，计算目录内所有图片的大小总和
        totalSize += [self getImageDirectorySizeAtPath:customImgPath withFileOutTime:cacheHotelListImageTime];
    }
    
    // webImageView第三方下载方法存入本地的大小
    NSString *webImgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache/"];
    
    if ([fileManager fileExistsAtPath:webImgPath isDirectory:&isDir])
    {
        // 目录存在时，计算目录内所有图片的大小总和
        totalSize += [self getImageDirectorySizeAtPath:webImgPath withFileOutTime:cacheHotelListImageTime];
    }
    
    return totalSize;
}


// 清空所有图片的缓存
- (void)clearImageCache
{
    // 清空自定义图片下载
    NSString *customImgPath = [NSHomeDirectory() stringByAppendingPathComponent:CACHE_HOTEL_LIST_IMAGE];
    BOOL isDir;

    if ([fileManager fileExistsAtPath:customImgPath isDirectory:&isDir]) {
        // 超过规定大小时，清空所有图片
        [fileManager removeItemAtPath:customImgPath error:nil];
        [fileManager createDirectoryAtPath:customImgPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 清空第三方图片下载
    NSString *webImgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache/"];
    
    if ([fileManager fileExistsAtPath:webImgPath isDirectory:&isDir]) {
        // 超过规定大小时，清空所有图片
        [fileManager removeItemAtPath:webImgPath error:nil];
        [fileManager createDirectoryAtPath:webImgPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 清空app自带缓存文件
    [self deleteFile];
}


- (void)deleteFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    //文件名
    NSString *uniquePath=[[paths safeObjectAtIndex:0] stringByAppendingPathComponent:@"com.elong.app"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}


@end
