//
//  ForecastViewController.m
//  ElongClient
//
//  Created by chenggong on 14-6-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ForecastViewController.h"
#import "ForecastInformation.h"

#define kForecastCityTag                    1024
#define kForecastDaytimeTemperatureTag      (kForecastCityTag + 1)
#define kForecastDaytimeMPTag               (kForecastCityTag + 2)
#define kForecastNightTemperatureTag        (kForecastCityTag + 3)
#define kForecastNightMPTag                 (kForecastCityTag + 4)
#define kForecastTemperatureTag             (kForecastCityTag + 5)
#define kForecastMPTag                      (kForecastCityTag + 6)
#define kForecastAdviceTag                  (kForecastCityTag + 7)
#define kForecastDaytimeDesTag              (kForecastCityTag + 8)
#define kForecastNightDesTag                (kForecastCityTag + 9)

#define kForecastViewMargin                 2.0f
#define kForecastViewCityHeight             15.0f
#define kForecastViewTemperatureHeight      18.0f
#define kForecastViewMPHeight               12.0f

@interface ForecastViewController ()

@property (nonatomic, retain) HttpUtil *httpUtil;
@property (nonatomic, copy) NSString *forecastCity;
@property (nonatomic, copy) NSString *forecastDate;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, assign) CGRect daytimeDesRect;
@property (nonatomic, assign) CGRect daytimeTemperatureRect;
@property (nonatomic, assign) CGRect daytimeMPRect;

@property (nonatomic, assign) CGRect nightDesRect;
@property (nonatomic, assign) CGRect nightTemperatureRect;
@property (nonatomic, assign) CGRect nightMPRect;

@end

@implementation ForecastViewController

- (void)dealloc
{
    _httpUtil.delegate = nil;
    self.httpUtil = nil;
    
    self.forecastCity = nil;
    self.forecastDate = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_delegate) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.view.backgroundColor = [UIColor clearColor];
    }
    
    if (_delegate) {
        CALayer *layer = [self.view layer];
        layer.cornerRadius = 5.0f;
        // 城市名称
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, kForecastViewMargin, SCREEN_WIDTH - 2 * kForecastHorizontalMargin, 32.0f)];
        cityLabel.backgroundColor = [UIColor clearColor];
        cityLabel.tag = kForecastCityTag;
        cityLabel.font = [UIFont systemFontOfSize:18.0f];
        cityLabel.textColor = [UIColor blackColor];
        cityLabel.textAlignment = UITextAlignmentLeft;
        cityLabel.numberOfLines = 1;
        [self.view addSubview:cityLabel];
        [cityLabel release];
        
        // 白天温度描述
        UILabel *dayTimeTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, kForecastViewMargin + cityLabel.frame.size.height, 50.0f, 32.0f)];
        self.daytimeTemperatureRect = dayTimeTemperatureLabel.frame;
        dayTimeTemperatureLabel.backgroundColor = [UIColor clearColor];
        dayTimeTemperatureLabel.tag = kForecastDaytimeTemperatureTag;
        dayTimeTemperatureLabel.font = [UIFont systemFontOfSize:24.0f];
        dayTimeTemperatureLabel.textColor = RGBACOLOR(255, 150, 0, 1);
        dayTimeTemperatureLabel.textAlignment = UITextAlignmentCenter;
        dayTimeTemperatureLabel.numberOfLines = 1;
        [self.view addSubview:dayTimeTemperatureLabel];
        [dayTimeTemperatureLabel release];
        
        // 白天
        UILabel *dayTimeStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayTimeTemperatureLabel.frame.size.width + 5.0f, dayTimeTemperatureLabel.frame.origin.y, 66.0f, 16.0f)];
        self.daytimeDesRect = dayTimeStaticLabel.frame;
        dayTimeStaticLabel.tag = kForecastDaytimeDesTag;
        dayTimeStaticLabel.backgroundColor = [UIColor clearColor];
        dayTimeStaticLabel.font = [UIFont systemFontOfSize:14.0f];
        dayTimeStaticLabel.textColor = [UIColor blackColor];
        dayTimeStaticLabel.text = @"白天";
        dayTimeStaticLabel.textAlignment = UITextAlignmentLeft;
        dayTimeStaticLabel.numberOfLines = 1;
        [self.view addSubview:dayTimeStaticLabel];
        [dayTimeStaticLabel release];
        
        // 白天具体气象数据
        UILabel *dayTimeMPLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayTimeTemperatureLabel.frame.size.width + 5.0f, dayTimeTemperatureLabel.frame.origin.y + 16.0f, 66.0f, 16.0f)];
        self.daytimeMPRect = dayTimeMPLabel.frame;
        dayTimeMPLabel.backgroundColor = [UIColor clearColor];
        dayTimeMPLabel.tag = kForecastDaytimeMPTag;
        dayTimeMPLabel.font = [UIFont systemFontOfSize:14.0f];
        dayTimeMPLabel.textColor = RGBACOLOR(140, 140, 140, 1);
        dayTimeMPLabel.textAlignment = UITextAlignmentLeft;
        dayTimeMPLabel.numberOfLines = 1;
        [self.view addSubview:dayTimeMPLabel];
        [dayTimeMPLabel release];
        
        // 夜间温度描述
        UILabel *nightTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(116.0f + 5.0f, kForecastViewMargin + cityLabel.frame.size.height, 50.0f, 32.0f)];
        self.nightTemperatureRect = nightTemperatureLabel.frame;
        nightTemperatureLabel.backgroundColor = [UIColor clearColor];
        nightTemperatureLabel.tag = kForecastNightTemperatureTag;
        nightTemperatureLabel.font = [UIFont systemFontOfSize:24.0f];
        nightTemperatureLabel.textColor = RGBACOLOR(255, 150, 0, 1);
        nightTemperatureLabel.textAlignment = UITextAlignmentCenter;
        nightTemperatureLabel.numberOfLines = 1;
        [self.view addSubview:nightTemperatureLabel];
        [nightTemperatureLabel release];
        
        // 夜间
        UILabel *nightStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(116.0f + nightTemperatureLabel.frame.size.width + 5.0f, nightTemperatureLabel.frame.origin.y, 66.0f, 16.0f)];
        self.nightDesRect = nightStaticLabel.frame;
        nightStaticLabel.tag = kForecastNightDesTag;
        nightStaticLabel.backgroundColor = [UIColor clearColor];
        nightStaticLabel.font = [UIFont systemFontOfSize:14.0f];
        nightStaticLabel.textColor = [UIColor blackColor];
        nightStaticLabel.text = @"夜间";
        nightStaticLabel.textAlignment = UITextAlignmentLeft;
        nightStaticLabel.numberOfLines = 1;
        [self.view addSubview:nightStaticLabel];
        [nightStaticLabel release];
        
        // 夜间具体气象数据
        UILabel *nightMPLabel = [[UILabel alloc] initWithFrame:CGRectMake(116.0f + nightTemperatureLabel.frame.size.width + 5.0f, nightTemperatureLabel.frame.origin.y + 16.0f, 66.0f, 16.0f)];
        self.nightMPRect = nightMPLabel.frame;
        nightMPLabel.backgroundColor = [UIColor clearColor];
        nightMPLabel.tag = kForecastNightMPTag;
        nightMPLabel.font = [UIFont systemFontOfSize:14.0f];
        nightMPLabel.textColor = RGBACOLOR(140, 140, 140, 1);
        nightMPLabel.textAlignment = UITextAlignmentLeft;
        nightMPLabel.numberOfLines = 1;
        [self.view addSubview:nightMPLabel];
        [nightMPLabel release];
        
        // 天气建议
        UILabel *adviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, nightMPLabel.frame.origin.y + nightMPLabel.frame.size.height, 270.0f, 72.0f)];
        adviceLabel.backgroundColor = [UIColor clearColor];
        adviceLabel.tag = kForecastAdviceTag;
        adviceLabel.font = [UIFont systemFontOfSize:14.0f];
        adviceLabel.textColor = [UIColor blackColor];
        adviceLabel.textAlignment = UITextAlignmentLeft;
        adviceLabel.numberOfLines = 0;
        [self.view addSubview:adviceLabel];
        [adviceLabel release];
    }
    else {
        // 城市名称
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(kForecastViewMargin, kForecastViewMargin, kForecastViewWidth - 2 * kForecastViewMargin, kForecastViewCityHeight)];
        cityLabel.backgroundColor = [UIColor clearColor];
        cityLabel.tag = kForecastCityTag;
        cityLabel.font = [UIFont systemFontOfSize:12.0f];
        cityLabel.textColor = [UIColor blackColor];
        cityLabel.textAlignment = UITextAlignmentLeft;
        cityLabel.numberOfLines = 1;
        [self.view addSubview:cityLabel];
        [cityLabel release];
        
        // 温度
        UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(kForecastViewMargin, kForecastViewMargin + kForecastViewCityHeight, kForecastViewWidth - 2 * kForecastViewMargin, kForecastViewTemperatureHeight)];
        temperatureLabel.backgroundColor = [UIColor clearColor];
        temperatureLabel.tag = kForecastTemperatureTag;
        temperatureLabel.font = [UIFont systemFontOfSize:16.0f];
        temperatureLabel.textColor = RGBACOLOR(140, 140, 140, 1);
        temperatureLabel.textAlignment = UITextAlignmentLeft;
        temperatureLabel.numberOfLines = 1;
        [self.view addSubview:temperatureLabel];
        [temperatureLabel release];
        
        // 气象现象
        UILabel *mpLabel = [[UILabel alloc] initWithFrame:CGRectMake(kForecastViewMargin, kForecastViewMargin + kForecastViewCityHeight + kForecastViewTemperatureHeight, kForecastViewWidth - 2 * kForecastViewMargin, kForecastViewMPHeight)];
        mpLabel.backgroundColor = [UIColor clearColor];
        mpLabel.tag = kForecastMPTag;
        mpLabel.font = [UIFont systemFontOfSize:10.0f];
        mpLabel.textColor = RGBACOLOR(140, 140, 140, 1);
        mpLabel.textAlignment = UITextAlignmentLeft;
        mpLabel.numberOfLines = 1;
        [self.view addSubview:mpLabel];
        [mpLabel release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startRequestWithCity:(NSString *)city withDate:(NSString *)date
{
    if (STRINGHASVALUE(city) && STRINGHASVALUE(date)) {
        HttpUtil *tempHttpUtil = [[HttpUtil alloc] init];
        tempHttpUtil.delegate = self;
        self.httpUtil = tempHttpUtil;
        [tempHttpUtil release];
        
        self.forecastCity = city;
        self.forecastDate = date;
        
        NSMutableDictionary  *jsonDic = [NSMutableDictionary  dictionary];
        [jsonDic safeSetObject:city forKey:@"city"];
        [jsonDic  safeSetObject:date forKey:@"date"];
        NSString *jsonString = [jsonDic  JSONString];
        NSString  *url = [PublicMethods composeNetSearchUrl:@"mtools" forService:@"forecast/getForecastInfo" andParam:jsonString];
        
        if (STRINGHASVALUE(url)) {
            [_httpUtil requestWithURLString:url Content:nil StartLoading:YES EndLoading:YES Delegate:self];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)buildForecastViewAtDay:(NSUInteger)dayIndex
{
    UILabel *cityLabel = (UILabel *)[self.view viewWithTag:kForecastCityTag];
    UILabel *temperatureLabel = (UILabel *)[self.view viewWithTag:kForecastTemperatureTag];
    UILabel *mpLabel = (UILabel *)[self.view viewWithTag:kForecastMPTag];
    
    cityLabel.text = _forecastCity;
    
    NSString *daytimeTemp = [[ForecastInformation shareInstance] getDayTimeTemperatureAtIndex:dayIndex];
    NSString *nightTemp = [[ForecastInformation shareInstance] getNightTemperatureAtIndex:dayIndex];
    
    if (!STRINGHASVALUE(daytimeTemp)) {
        daytimeTemp = @"无";
    }
    else {
        daytimeTemp = [NSString stringWithFormat:@"%@°", daytimeTemp];
    }
    
    if (!STRINGHASVALUE(nightTemp)) {
        nightTemp = @"无";
    }
    else {
        nightTemp = [NSString stringWithFormat:@"%@°", nightTemp];
    }
    
    temperatureLabel.text = [NSString stringWithFormat:@"%@-%@", daytimeTemp, nightTemp];
    
    NSString *daytimeMP = [[ForecastInformation shareInstance] getDaytimeMPAtIndex:dayIndex];
    NSString *nightMP = [[ForecastInformation shareInstance] getNightMPAtIndex:dayIndex];
    
    if (!STRINGHASVALUE(daytimeMP)) {
        daytimeMP = @"无";
    }
    if (!STRINGHASVALUE(nightMP)) {
        nightMP = @"无";
    }
    mpLabel.text = [NSString stringWithFormat:@"%@.%@", daytimeMP, nightMP];
}

- (void)buildForecastPopUpViewAtDay:(NSUInteger)dayIndex
{
    UILabel *cityLabel = (UILabel *)[self.view viewWithTag:kForecastCityTag];
    UILabel *daytimeTemperatureLabel = (UILabel *)[self.view viewWithTag:kForecastDaytimeTemperatureTag];
    UILabel *daytimeMPLabel = (UILabel *)[self.view viewWithTag:kForecastDaytimeMPTag];
    UILabel *nightTemperatureLabel = (UILabel *)[self.view viewWithTag:kForecastNightTemperatureTag];
    UILabel *nightMPLabel = (UILabel *)[self.view viewWithTag:kForecastNightMPTag];
    UILabel *adviceLabel = (UILabel *)[self.view viewWithTag:kForecastAdviceTag];
    UILabel *daytimeStaticLabel = (UILabel *)[self.view viewWithTag:kForecastDaytimeDesTag];
    UILabel *nightStaticLabel = (UILabel *)[self.view viewWithTag:kForecastNightDesTag];
    
    cityLabel.text = [NSString stringWithFormat:@"%@/ %@-%@", _forecastCity, [_forecastDate substringWithRange:NSMakeRange(4, 2)], [_forecastDate substringWithRange:NSMakeRange(6, 2)]];
    
    NSString *daytimeTemperatureString = [[ForecastInformation shareInstance] getDayTimeTemperatureAtIndex:dayIndex];
    if (!STRINGHASVALUE(daytimeTemperatureString)) {
        daytimeTemperatureString = @"无";
        daytimeStaticLabel.hidden = YES;
        daytimeMPLabel.hidden = YES;
        daytimeStaticLabel.hidden = YES;
        
        CGRect nightTemperatureRect = _nightTemperatureRect;
        nightTemperatureRect.origin.x -= 50;
        nightTemperatureLabel.frame = nightTemperatureRect;
        
        CGRect nightStaticRect = _nightDesRect;
        nightStaticRect.origin.x -= 50;
        nightStaticLabel.frame = nightStaticRect;
        
        CGRect nightMPRect = _nightMPRect;
        nightMPRect.origin.x -= 50;
        nightMPLabel.frame = nightMPRect;
    }
    else {
        daytimeTemperatureLabel.text = [NSString stringWithFormat:@"%@°", daytimeTemperatureString];
        daytimeStaticLabel.hidden = NO;
        daytimeMPLabel.hidden = NO;
        daytimeStaticLabel.hidden = NO;
    }
    
    NSString *nightTemperatureString = [[ForecastInformation shareInstance] getNightTemperatureAtIndex:dayIndex];
    if (!STRINGHASVALUE(nightTemperatureString)) {
        nightTemperatureString = @"无";
        
        nightStaticLabel.hidden = YES;
        nightMPLabel.hidden = YES;
        nightStaticLabel.hidden = YES;
        
        CGRect daytimeTemperatureRect = _daytimeTemperatureRect;
        daytimeTemperatureRect.origin.x += 50;
        daytimeTemperatureLabel.frame = daytimeTemperatureRect;
        
        CGRect daytimeStaticRect = _daytimeDesRect;
        daytimeStaticRect.origin.x += 50;
        daytimeStaticLabel.frame = daytimeStaticRect;
        
        CGRect daytimeMPRect = _daytimeMPRect;
        daytimeMPRect.origin.x += 50;
        daytimeMPLabel.frame = daytimeMPRect;
    }
    else {
        nightTemperatureLabel.text = [NSString stringWithFormat:@"%@°", nightTemperatureString];
        
        nightStaticLabel.hidden = NO;
        nightMPLabel.hidden = NO;
        nightStaticLabel.hidden = NO;
    }
    
    NSString *daytimeMPString = [[ForecastInformation shareInstance] getDaytimeMPAtIndex:dayIndex];
    if (!STRINGHASVALUE(daytimeMPString)) {
        daytimeMPString = @"无";
    }
    daytimeMPLabel.text = daytimeMPString;
    
    NSString *nightMPString = [[ForecastInformation shareInstance] getNightMPAtIndex:dayIndex];
    if (!STRINGHASVALUE(nightMPString)) {
        nightMPString = @"无";
    }
    nightMPLabel.text = nightMPString;
    
    NSString *advice = [[ForecastInformation shareInstance] getAdviceFromIndexesAtIndex:dayIndex];
    if (!STRINGHASVALUE(advice)) {
        advice = @"暂无信息";
    }
    adviceLabel.text = [NSString stringWithFormat:@"穿衣指数:%@", advice];
}

#pragma mark - httpDelegate
- (void) httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
	
	if ([Utils checkJsonIsErrorNoAlert:root]) {
		return ;
	}
    
    NSDate *tempDate = [NSDate dateFromString:_forecastDate withFormat:@"yyyyMMddHHmm"];
    NSTimeInterval distance = -[tempDate timeIntervalSinceNow];
    if (distance < 0) {
        distance = -distance;
    }
    NSUInteger distanceDay = distance / 86400;
    
    self.currentIndex = distanceDay;
    
    NSArray *listInfo = [root safeObjectForKey:@"list"];
    NSArray *indexesInfo = [root safeObjectForKey:@"indexes"];
    if (ARRAYHASVALUE(listInfo)) {
        [[[ForecastInformation shareInstance] list] removeAllObjects];
        [[[ForecastInformation shareInstance] list] addObjectsFromArray:listInfo];
    }
    
    if (ARRAYHASVALUE(indexesInfo)) {
        [[[ForecastInformation shareInstance] indexes] removeAllObjects];
        [[[ForecastInformation shareInstance] indexes] addObjectsFromArray:indexesInfo];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(forecastViewShouldPopUp)]) {
        [self buildForecastPopUpViewAtDay:distanceDay];
        [_delegate forecastViewShouldPopUp];
    }
    else {
        [self buildForecastViewAtDay:distanceDay];
    }
}

- (void)buildupForcastPopView
{
    [self buildForecastPopUpViewAtDay:_currentIndex];
}

@end
