//
//  TaxiUtils.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiUtils.h"
#import "RentCity.h"
#import "RentFlight.h"
#import "ChineseToPinyin.h"
#import "TaxiFillManager.h"


#define STORE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"RentCar"]
#define RENT_FLIGHT_PATH @"/FlightHistory"
#define RENT_AIRPORT_PATH @"/AirportHistory"

#define Tip_TimeUnAvailable_less @"您所选择的时间太紧,无法及时为您提供服务,请调整用车时间"
#define Tip_TimeUnAvailable_pass @"您所选择的用车时间已过，请重新设置"

@implementation TaxiUtils

+(NSString *)checkDateOffTheGievnDateString:(NSString *)_string{

    NSString *string = nil;
    NSString *s_current = [TimeUtils displayDateWithNSDate:[NSDate date] formatter:TIME_FORMATTER_Flight];
    NSDate *tipDate = [NSDate dateFromString:[s_current stringByAppendingFormat:@" %@",_string] withFormat:TIME_FORMATTER_Airport];
    if ([tipDate compare:[NSDate date]] == NSOrderedAscending) {
        //返回第二天
        string = [TimeUtils displayDateWithNSDate:[NSDate  dateWithTimeInterval:2*60*60 sinceDate:[NSDate date]] formatter:TIME_FORMATTER_Flight];
    }else{
        //今天
        string = s_current;
    }
    return string;
}

+(NSString *)getDateOfHours:(int)hours MinsByTen:(BOOL)accturate{
    //N小时之后 再加分钟数取整
    NSString *string = nil;
    NSDate *future = [NSDate dateWithTimeIntervalSinceNow:hours*60*60];
    NSString *s_current = [TimeUtils displayDateWithNSDate:future formatter:TIME_FORMATTER_Airport];
    
    if (!accturate) {
        return s_current;
    }
    
    NSRange range = NSMakeRange([s_current length]-1, 1);
    
    NSString *lastMin = [s_current substringWithRange:range];
    //对时间四舍五入
    if ([lastMin intValue] < 5) {
        s_current = [TaxiUtils getFutureTimeWithSinceDate:future Mins:20 WithFormatter:TIME_FORMATTER_Airport];
    }else{
        s_current = [TaxiUtils getFutureTimeWithSinceDate:future Mins:30 WithFormatter:TIME_FORMATTER_Airport];
    }
    string = [s_current stringByReplacingCharactersInRange:range withString:@"0"];
    return string;
}

+(NSString *)getFutureTimeWithSinceDate:(NSDate *)since Mins:(int)mins WithFormatter:(NSString *)formatter{

    return [TimeUtils displayDateWithNSDate:[NSDate dateWithTimeInterval:mins*60 sinceDate:since] formatter:formatter];
}

+(NSArray *)getDateArraysFromNowWithDays:(int)days{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:days];
    
    //  先定义一个遵循某个历法的日历对象
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    for (int i = 0; i<days; i++) {
        //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
            
        NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit  fromDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60*i]];
        //  Sunday:1, Monday:2, Tuesday:3, Wednesday:4, Thursday, 5 Friday:6, Saturday:7
        NSString *weekDay = nil;
        switch (dateComponents.weekday) {
            case 1:
                weekDay = @"周日";
                break;
            case 2:
                weekDay = @"周一";
                break;
            case 3:
                weekDay = @"周二";
                break;
            case 4:
                weekDay = @"周三";
                break;
            case 5:
                weekDay = @"周四";
                break;
            case 6:
                weekDay = @"周五";
                break;
            case 7:
                weekDay = @"周六";
                break;
            default:
                break;
        }
        
        switch (i) {
            case 0:
                weekDay = @"今天";
                break;
            case 1:
                weekDay = @"明天";
                break;
            case 2:
                weekDay = @"后天";
                break;
            default:
                break;
        }
        NSString *value = [NSString stringWithFormat:@"%d-%d-%d %@",dateComponents.year,dateComponents.month,dateComponents.day,weekDay];
        [array addObject:value];
    }
    [greCalendar release];
    return array;
}

+(NSMutableArray *)getTheCustomAirPortOrTerminalsByGivenArrays:(NSArray *)array{

    NSMutableArray *customArray = [[NSMutableArray alloc] init];
    
    for (RentCity *city in array) {
        NSString *name = city.cityName;
        NSString *cityCode = city.cityCode;
        NSString *longititude = @"";
        NSString *latitude = @"";
        NSString *airportCode = @"";
        
        for (NSDictionary *airPort in city.airPortLst) {
            
            airportCode = [airPort safeObjectForKey:@"airPortCode"];
            
            if (nil == [airPort safeObjectForKey:@"terminalList"] || [[airPort safeObjectForKey:@"terminalList"] count] == 0) {
                //机场无航站楼
                name = [airPort safeObjectForKey:@"airPortName"];
                longititude = [airPort safeObjectForKey:@"airPortLng"];
                latitude = [airPort safeObjectForKey:@"airPortLat"];
                //
                CustomAirportTerminal *model = [[CustomAirportTerminal alloc] init];
                model.name = name;
                model.cityName = city.cityName;
                model.cityCode = cityCode;
                model.longitude = longititude;
                model.latitude = latitude;
                model.airPortCode = airportCode;
                [customArray addObject:model];
                [model release];
                
            }else{
                //机场有航站楼
                for (NSDictionary *terminal in [airPort safeObjectForKey:@"terminalList"]) {
                    
                    name = [terminal safeObjectForKey:@"termName"];
                    longititude = [terminal safeObjectForKey:@"termLng"];
                    latitude = [terminal safeObjectForKey:@"termLat"];
                    
                    CustomAirportTerminal *model = [[CustomAirportTerminal alloc] init];
                    model.name = name;
                    model.cityName = city.cityName;
                    model.cityCode = cityCode;
                    model.longitude = longititude;
                    model.latitude = latitude;
                    model.airPortCode = airportCode;
                    [customArray addObject:model];
                    [model release];
                }
            }
        }
    }
    return [customArray autorelease];
}

+(NSString *)getTheServiceStatusByGivenCity:(NSString *)city andSources:(NSArray *)array{

    NSString *status = nil;
    for (RentCity *model in array) {
        //
        NSComparisonResult result1 = [model.cityName compare:city options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [city length])];
        NSComparisonResult result2 = [city compare:model.cityName options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [model.cityName length])];

        if (result1 == NSOrderedSame || result2 == NSOrderedSame) {
            status = model.cityCode;
            break;
        }
    }
    return status;
}

+(BOOL)checkTheTimeIsAvailable:(NSString *)dateString{
    
    NSArray *compents = [dateString componentsSeparatedByString:@" "];
    if ([compents count] > 1) {
        NSString *ms = [compents objectAtIndex:1];//获取到时间的小时分钟数
        if ([ms length] <= 5) {
            dateString = [dateString stringByAppendingString:@":00"];
        }
    }
    NSDate *current = [NSDate date];
    NSDate *time = [NSDate dateFromString:dateString withFormat:TIME_FORMATTER_WITH_SS];
    if ([time  timeIntervalSinceDate:current] >= 2*60*60) {
        return YES;
    }else if ([time timeIntervalSinceDate:current] > 0 && [time timeIntervalSinceDate:current] < 2*60*60){
        [Utils alert:Tip_TimeUnAvailable_less];
        return NO;
    }else{
        [Utils alert:Tip_TimeUnAvailable_pass];
        return NO;
    }
}

//获取租车业务中 读取历史记录
+(NSMutableArray *)getRentCarHistoryWithGivenType:(RentHistory_type)type{

    NSString *path =[STORE_PATH stringByAppendingString:(type == RentHistory_Flight)?RENT_FLIGHT_PATH:RENT_AIRPORT_PATH];
    NSFileManager *manager= [ NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        
        NSArray *array = [[[NSArray alloc] initWithContentsOfFile:path] autorelease];
        NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
        for (NSDictionary *dic in array) {
            if (type == RentHistory_Flight) {
                RentFlight *flight = [[RentFlight alloc] init];
                [flight convertObjectFromGievnDictionary:dic relySelf:YES];
                [returnArray addObject:flight];
                [flight release];
            }else{
                CustomAirportTerminal *termal = [[CustomAirportTerminal alloc] init];
                [termal convertObjectFromGievnDictionary:dic relySelf:YES];
                [returnArray addObject:termal];
                [termal  release];
            }
        }
        
        return [returnArray autorelease];
    }else{
        BOOL isDir;
        //先检测目录可用性
        if (![manager fileExistsAtPath:STORE_PATH isDirectory:&isDir]) {
            NSError *error;
            [manager createDirectoryAtPath:STORE_PATH withIntermediateDirectories:Nil attributes:nil error:&error];
        }
        //创建文件
        BOOL success = [manager createFileAtPath:path contents:nil attributes:nil];
        if (success) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            return [array autorelease];
        }else{
            NSLog(@"There is a Error happend when you try to create The RentCar File ");
            return nil;
        }
    }
}

//租车业务中保存历史记录
+(void)saveTheHistoryData:(NSMutableArray *)array Type:(RentHistory_type )type{

    NSString *path =[STORE_PATH stringByAppendingPathComponent:(type == RentHistory_Flight)?RENT_FLIGHT_PATH:RENT_AIRPORT_PATH];
    NSFileManager *manager= [ NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        /*由于写文件不支持自定义对象，此处处理方式有两种
         *1、使用归档，Model类实现 NSCoding协议
         *2、将Model转化为字典形式 存储
         *考虑到Model属性值较多，转化成字典有现成的方法，因此采用第二种方式
         */
        NSMutableArray   *writeArray = [NSMutableArray arrayWithCapacity:[array count]];
        if (type == RentHistory_Flight) {
            //
            for (RentFlight *flight  in array) {
                NSDictionary *dic = [flight convertDictionaryFromObjet];
                [writeArray addObject:dic];
            }
        }else{
            for (CustomAirportTerminal *termal  in array) {
                NSDictionary *dic = [termal convertDictionaryFromObjet];
                [writeArray addObject:dic];
            }
        }
        [writeArray writeToFile:path atomically:NO];
    }else{
        //创建文件
        BOOL success = [manager createFileAtPath:path contents:nil attributes:nil];
        if (success) {
            [array writeToFile:path atomically:YES];
        }else{
            NSLog(@"There is a Error happend when you try to create The RentCar File ");
        }
    }
}

+(NSString *)addsecsStringByGivenTimeString:(NSString *)time{

    return [time stringByAppendingFormat:@":00"];
}

+(CustomAirportTerminal *)getTheDefaultAirportByLocationCity:(NSString *)cityName andCustomAirports:(NSArray *)source{

    if (nil == source || [source count] == 0) {
        return nil;
    }
    
    CustomAirportTerminal *model = nil;
    if (STRINGHASVALUE(cityName)) {
        for (CustomAirportTerminal *city  in source) {
            //支持英文环境下的城市定位匹配
            NSString *e_source = [ChineseToPinyin pinyinFromChiniseString:city.cityName];
            NSString *e_city = [ChineseToPinyin pinyinFromChiniseString:cityName];
            
            NSComparisonResult result1 = [city.cityName compare:cityName options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [cityName length])];
            NSComparisonResult result2 = [cityName compare:city.cityName options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [city.cityName length])];
            NSComparisonResult result3 = [e_source compare:e_city options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [e_city length])];
            NSComparisonResult result4 = [e_city compare:e_source options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [e_source length])];
            if (result1 == NSOrderedSame || result2 == NSOrderedSame || result3 == NSOrderedSame || result4 == NSOrderedSame) {
                {
                    return city;
                }
            }
        }
    }
    if (nil == model) {
        //return 北京T1
        model = [[[CustomAirportTerminal alloc] init] autorelease];
        model.cityName = @"北京";
        model.cityCode = @"015";
        model.airPortCode = @"PEK";
        model.name = @"北京首都机场1号航站楼";
        model.longitude = @"116.59457397461";
        model.latitude = @"40.085968017578";
        return model;
    }
    return nil;
}


+(CustomAirportTerminal *)getTheDefaultAirportByLocationCity:(NSString *)cityName andSource:(NSArray *)source{

    if (nil == source || [source count] == 0) {
        return nil;
    }
    
    CustomAirportTerminal *model = nil;
    if (STRINGHASVALUE(cityName)) {
        for (RentCity *city  in source) {
            //支持英文环境下的城市定位匹配
            NSString *e_source = [ChineseToPinyin pinyinFromChiniseString:city.cityName];
            NSString *e_city = [ChineseToPinyin pinyinFromChiniseString:cityName];
            
            NSComparisonResult result1 = [city.cityName compare:cityName options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [cityName length])];
            NSComparisonResult result2 = [cityName compare:city.cityName options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [city.cityName length])];
            NSComparisonResult result3 = [e_source compare:e_city options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [e_city length])];
            NSComparisonResult result4 = [e_city compare:e_source options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [e_source length])];
            if (result1 == NSOrderedSame || result2 == NSOrderedSame || result3 == NSOrderedSame || result4 == NSOrderedSame) {
                {
                    model = [[[CustomAirportTerminal alloc] init] autorelease];
                    model.cityName = city.cityName;
                    model.cityCode = city.cityCode;
                    for (NSDictionary *airPort in city.airPortLst) {
                        model.airPortCode = [airPort safeObjectForKey:@"airPortCode"];
                        if (nil == [airPort safeObjectForKey:@"terminalList"] || [[airPort safeObjectForKey:@"terminalList"] count] == 0) {
                            //机场无航站楼
                            model.name = [airPort safeObjectForKey:@"airPortName"];
                            model.longitude = [airPort safeObjectForKey:@"airPortLng"];
                            model.latitude = [airPort safeObjectForKey:@"airPortLat"];
                        }else{
                            //机场有航站楼
                            //取第一个
                            NSDictionary *termimal = [[airPort safeObjectForKey:@"terminalList"] objectAtIndex:0];
                            model.name = [termimal safeObjectForKey:@"termName"];
                            model.longitude = [termimal safeObjectForKey:@"termLng"];
                            model.latitude = [termimal safeObjectForKey:@"termLat"];
                        }
                    }
                    return model;
                }
            }
        }
    }
    if (nil == model) {
        //return 北京T1
         model = [[[CustomAirportTerminal alloc] init] autorelease];
        model.cityName = @"北京";
        model.cityCode = @"015";
        model.airPortCode = @"PEK";
        model.name = @"北京首都机场1号航站楼";
        model.longitude = @"116.59457397461";
        model.latitude = @"40.085968017578";
        return model;
    }
    return nil;
}

+(BOOL)checkIsSameCity:(NSString *)city_a another:(NSString *)city_b{

    //支持英文环境下的城市定位匹配
    NSString *e_source = [ChineseToPinyin pinyinFromChiniseString:city_a];
    NSString *e_city = [ChineseToPinyin pinyinFromChiniseString:city_b];
    
    NSComparisonResult result1 = [city_a compare:city_b options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [city_b length])];
    NSComparisonResult result2 = [city_b compare:city_a options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [city_a length])];
    NSComparisonResult result3 = [e_source compare:e_city options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [e_city length])];
    NSComparisonResult result4 = [e_city compare:e_source options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [e_source length])];
    if (result1 == NSOrderedSame || result2 == NSOrderedSame || result3 == NSOrderedSame || result4 == NSOrderedSame) {
        return YES;
    }
    return NO;
}

+(BOOL)getFlightTimeFromGivenFlight:(RentFlight *)flight{
    
    if ([flight.departTime rangeOfString:@"+"].location != NSNotFound) {
        //跨天了
        return YES;
    }
    return NO;
}

+(CustomAirportTerminal *)getTheAirportTerminalFromGivenPortCode:(NSString *)code{

    NSMutableArray *arrays = [TaxiFillManager shareInstance].customAirports;
    if ([arrays count] > 0) {
        for (CustomAirportTerminal *model in arrays) {
            if ([model.airPortCode isEqualToString:code]) {
                return model;
            }
        }
    }
    return nil;
}

+(FlightType)getTheFlightTypeByGivenString:(NSString *)string{

    if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[1-9A-Z]{1}[A-Z]{1}[0-9]{4}'"] evaluateWithObject:string]) {
        return Inner_Flight;
    }else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '^[1-9A-Z]{1}[A-Z]{1}[0-9]{3}'"] evaluateWithObject:string]){
        return International_Flight;
    }else{
        return Error_Flight;
    }
}

+(NSInteger) convertCertificate:(int ) type
{
    switch (type) {
        case 0://身份证
        case 8001:
            return 8001;
            break;
        case 4: //护照
        case 8002:
            return 8002;
            break;
            case 6://其他
            case 8003:
            return 8003;
            break;
        case 1://军人证
        case 8004:
            return 8004;
            break;
        case 2:
        case 8006://回乡证
            return 8006;
            break;
            
        default:
            return 8003;
            break;
    }
}

+(NSArray *)getOrderRentInfoHeaderShowSuccess:(BOOL)yes{

    NSString *title = @"订单成功!";
    NSString *type = ([[TaxiFillManager shareInstance].productType isEqualToString:RENT_PICKER])?@"接机":@"送机";
    NSString *info = [NSString stringWithFormat:@"%@%@-%@",[TaxiFillManager shareInstance].carUseCity,type,[TaxiFillManager shareInstance].carTypeName];
    NSString *payInfo = @"预订此产品，需要您先预付该车型起租费用。用车结束后，会根据您的行程计算出最终账单，在您核对无误后，再收取剩余费用。";
    return (yes)?[NSArray arrayWithObjects:title,info,payInfo,nil]:[NSArray arrayWithObjects:info,payInfo,nil];
}

@end
