//
//  Update.m
//  ElongClient
//
//  Created by elong lide on 11-11-3.
//  Copyright 2011 elong. All rights reserved.
//

#import "Update.h"
#import "LoadingView.h"
#import "jUpdate.h"
#import "ElongURL.h"
#import "NSDate+Helper.h"

@implementation Update


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
        // Initialization code.
		
    }
    return self;
}

//小数字符串转换成整数
-(int)stringConvertToint:(NSString*)string{
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

-(void)initData{
	jUpdate *jupdate = [[jUpdate alloc] init];
    updateUtil = [[HttpUtil alloc] init];
    [updateUtil connectWithURLString:OTHER_SEARCH
                          Content:[jupdate requesString:YES]
                     StartLoading:NO
                       EndLoading:NO
                         Delegate:self];
    [updateUtil release];
    [jupdate release];
    
    CacheConfigRequest *cacheConfig = [[[CacheConfigRequest alloc] init] autorelease];
    cacheManageUtil = [[HttpUtil alloc] init];
    [cacheManageUtil connectWithURLString:OTHER_SEARCH
                                  Content:[cacheConfig requesString]
                             StartLoading:NO
                               EndLoading:NO
                                 Delegate:self];
    [cacheManageUtil release];
}

//设置里面的版本更新检测
-(void)checkUpdateFromServer{
    jUpdate *jupdate = [[jUpdate alloc] init];
    
    if (checkUpdateUtil)
    {
        [checkUpdateUtil cancel];
        SFRelease(checkUpdateUtil);
    }
    
    checkUpdateUtil = [[HttpUtil alloc] init];
    [checkUpdateUtil connectWithURLString:OTHER_SEARCH
                             Content:[jupdate requesString:YES]
                        StartLoading:YES
                          EndLoading:YES
                            Delegate:self];
    
    [jupdate release];
}


-(void)GoToUpdate{
	if (m_downLoadUrl != nil && [m_downLoadUrl length] > 0) {
		NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
		NSDate* m_date = [NSDate date];
		NSTimeInterval date = [m_date timeIntervalSince1970];
		NSString* str_date = [NSString stringWithFormat:@"%f",date];
		//点击升级时间
		[dater setValue:str_date forKey:@"updatetime"];
		//没有更新完
		[dater setValue:@"1" forKey:@"halfupdate"];
		[dater synchronize];
		
		//m_downLoadUrl = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=388089858";
		
		[[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:m_downLoadUrl]];
	}
}

-(void)NotNoticeEvent{
	NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
	//是否不再提醒
	[dater setValue:@"1" forKey:@"update"];
	[dater synchronize];
	[self removeFromSuperview];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //左边的按钮
    if (buttonIndex == 1 ) {
        [self GoToUpdate];
    }
    //右边的按钮
    else
    {
        [self NotNoticeEvent];
    }
}


- (void)drawRect:(CGRect)rect {
    // Drawing code.
}


- (void)dealloc {
    
    if (cacheManageUtil)
    {
        [cacheManageUtil cancel];
        SFRelease(cacheManageUtil);
    }
    
    if (updateUtil)
    {
        [updateUtil cancel];
        SFRelease(updateUtil);
    }
    
    [checkUpdateUtil cancel];
    SFRelease(checkUpdateUtil);
    
	[m_downLoadUrl release];
    [trainCityUpdate release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	
    NSDictionary *root = [PublicMethods unCompressData:responseData];
	if ([Utils checkJsonIsErrorNoAlert:root]) {
		return ;
	}
	
    if (util == updateUtil) {
        NSArray *switchArray = [root safeObjectForKey:@"SwitchInfos"];
        if (ARRAYHASVALUE(switchArray)) {
            for (NSDictionary *dic in switchArray) {
                NSString *key = [dic safeObjectForKey:@"Key"];
                NSNumber *isOpen = [dic safeObjectForKey:@"IsOpen"];
                if (STRINGHASVALUE(key) && !OBJECTISNULL(isOpen)) {
                    if ([key isEqualToString:@"notMemberBooking"]) {
                        [ProcessSwitcher shared].allowNonmember = [isOpen boolValue];
                    }
                    else if([key isEqualToString:@"flightAlipay"]){
                        [ProcessSwitcher shared].allowAlipayForFlight = [isOpen boolValue];
                    }
                    else if([key isEqualToString:@"groupAlipay"]){
                        [ProcessSwitcher shared].allowAlipayForGroupon = [isOpen boolValue];
                    }
                    else if([key isEqualToString:@"passbookHotel"]){
                        [ProcessSwitcher shared].hotelPassOn = [isOpen boolValue];
                    }
                    else if([key isEqualToString:@"passbookGroupon"]){
                        [ProcessSwitcher shared].grouponPassOn = [isOpen boolValue];
                    }
                    else if([key isEqualToString:Html_Hotel_Switch]){
                        [ProcessSwitcher shared].hotelHtml5On = [isOpen boolValue];
                    }
                    else if([key isEqualToString:Html_Flight_Switch]){
                        [ProcessSwitcher shared].flightHtml5On = [isOpen boolValue];
                    }
                    else if([key isEqualToString:Html_Groupon_Switch]){
                        [ProcessSwitcher shared].grouponHtml5On = [isOpen boolValue];
                    }
                    else if ([key isEqualToString:Cache_Local_Switch]) {
                        [[CacheManage manager] setCanUseCache:[isOpen boolValue]];
                    }else if([key isEqualToString:IFLY_VoiceSearch]){
                        [ProcessSwitcher shared].allowIFlyMSC = [isOpen boolValue];
                    }else if([key isEqualToString:HTTPSORHTTP]){
                        [ProcessSwitcher shared].allowHttps = [isOpen boolValue];
                    }else if([key isEqualToString:SHOWC2CINHOTELSEARCH]){
                        [ProcessSwitcher shared].showC2CInHotelSearch = [isOpen boolValue];
                    }else if([key isEqualToString:SHOWC2CORDER]){
                        [ProcessSwitcher shared].showC2COrder = [isOpen boolValue];
                    }
                }
            }     
        }
        
        // 数据版本
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSArray *dataVersions = [root safeObjectForKey:@"DataVersions"];
        if (ARRAYHASVALUE(dataVersions))
        {
            for (NSDictionary *dic in dataVersions)
            {
                NSString *dataName = [dic safeObjectForKey:@"DataName"];
                NSString *currentDataVersion = [dic safeObjectForKey:@"CurrentVersion"];
                if (STRINGHASVALUE(dataName) && STRINGHASVALUE(currentDataVersion))
                {
                    // 列车车站数据版本
                    if ([dataName isEqualToString:@"TrainStationList"])
                    {
                        // 判断数据版本
                        NSString* trainCityVersion = [defaults objectForKey:@"trainCityVersion"];
                        if (trainCityVersion == nil || ([self stringConvertToint:trainCityVersion] < [self stringConvertToint:currentDataVersion]))
                        {
                            // 本地存储新的版本号备份
                            [defaults setValue:currentDataVersion forKey:@"trainCityVersionTmp"];
                            [defaults synchronize];
                            
                            // 更新列车车站数据
                            trainCityUpdate = [[TrainCityUpdate alloc] init];
                            [trainCityUpdate trainCityUpdateStart];
                        }
                    }
                    //城市列表版本
                    else if ([dataName isEqualToString:@"Cities"])
                    {
                        //处理城市版本，检验是否更新,不要释放，sendUpdateReq用完内部自动释放
                        HotelCityUpdater *hotelCityUpdater=[[HotelCityUpdater alloc] init:currentDataVersion];
                        [hotelCityUpdater sendUpdateReqThenDealloc];
                        hotelCityUpdater=nil;
                    }
                }
            }
        }

        
        //现在版本
        NSString* verson = [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:@"CFBundleVersion"];
        int m_ver = [self stringConvertToint:verson];
        //app 上的版本
        NSString* appver = [root safeObjectForKey:@"CurrentVersion"];
        int m_appver = [self stringConvertToint:appver];
        
        //如果现在小于app 上的 版本
        if (m_ver < m_appver) {
            NSString* m_downUrl = [root safeObjectForKey:@"DownloadUrl"];
            m_downLoadUrl = [[NSString alloc] initWithString:m_downUrl];
            
            NSMutableString* m_message = [[[NSMutableString alloc] init] autorelease];
            
            NSMutableArray* m_messageArray = [[NSMutableArray alloc] initWithArray:[root safeObjectForKey:@"WhatsNews"]];
            for (int i = 0; i<[m_messageArray count]; i++) {
                NSString* str = [NSString stringWithFormat:@"%i.%@\r\n",i+1,[m_messageArray safeObjectAtIndex:i]];
                [m_message appendString:str];
            }
            
            [m_messageArray release];
            
            
            NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
            NSString* update_str = [dater objectForKey:@"update"];
            NSString* tomozero = [dater objectForKey:@"tomorZeroDate"];
            
            if (tomozero != nil){
                NSDate* date = [NSDate date];
                NSDate* tomorze = [NSDate dateFromString:tomozero];
                NSComparisonResult rst = [tomorze compare:date];
                //现在的时间比记录的明天零点大，则再提醒他
                if (rst == NSOrderedAscending) {
                }
            }
            
            if (update_str != nil ) {
                //没有更新完
                if ([update_str isEqualToString:@"1"])
                {
                    
                    if (tomozero != nil && [tomozero length] > 4) {
                        NSDate* date = [NSDate date];
                        NSDate* tomorze = [NSDate dateFromString:tomozero];
                        NSComparisonResult rst = [tomorze compare:date];
                        if (rst == NSOrderedAscending) {
                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                                            message:m_message
                                                                           delegate:self
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:@"以后提醒",@"更新", nil];
                            
                            //记录明天的零时的时间
                            //判断时间提醒
                            NSDate* nowdate = [NSDate date];
                            //得到今日零点时间
                            NSDate* zerodate = [nowdate cc_dateByMovingToBeginningOfDay];
                            NSTimeInterval nowInterval = [zerodate timeIntervalSince1970];
                            
                            //明天零点的
                            NSDate* tomorZeroDate = [NSDate dateWithTimeIntervalSince1970:(nowInterval + 60*60*24)];
                            
                            [dater setValue:[tomorZeroDate string] forKey:@"tomorZeroDate"];
                            [dater synchronize];
                            
                            for(UIView* view in [alert subviews])
                            {
                                if ([view isKindOfClass:[UILabel class]]) {
                                    UILabel* lable = (UILabel*)view;
                                    if ([lable.text isEqualToString:@"发现新版本"]) {
                                        continue;
                                    }
                                    lable.textAlignment = UITextAlignmentLeft;
                                }
                            }
                            
                            alert.tag = 12;
                            [alert show];
                            [alert release];
                        }
                    }
                }
                return;
            }
                
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                            message:m_message
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"以后提醒",@"更新", nil];
            
            //记录明天的零时的时间
            //判断时间提醒
            NSDate* nowdate = [NSDate date];
            //得到今日零点时间
            NSDate* zerodate = [nowdate cc_dateByMovingToBeginningOfDay];
            NSTimeInterval nowInterval = [zerodate timeIntervalSince1970];
            
            //明天零点的
            NSDate* tomorZeroDate = [NSDate dateWithTimeIntervalSince1970:(nowInterval + 60*60*24)];
            
            [dater setValue:[tomorZeroDate string] forKey:@"tomorZeroDate"];
            [dater synchronize];
            
            for(UIView* view in [alert subviews])
            {
                if ([view isKindOfClass:[UILabel class]]) {
                    UILabel* lable = (UILabel*)view;
                    if ([lable.text isEqualToString:@"发现新版本"]) {
                        continue;
                    }
                    lable.textAlignment = UITextAlignmentLeft;
                }
            }
            
            alert.tag = 12;
            [alert show];
            [alert release];
        }
    }
    else if (util == cacheManageUtil) {
        [[CacheManage manager] setCacheValueFromDataSource:root];
    }else if (util == checkUpdateUtil) {
        // 数据版本
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSArray *dataVersions = [root safeObjectForKey:@"DataVersions"];
        if (ARRAYHASVALUE(dataVersions))
        {
            for (NSDictionary *dic in dataVersions)
            {
                NSString *dataName = [dic safeObjectForKey:@"DataName"];
                NSString *currentDataVersion = [dic safeObjectForKey:@"CurrentVersion"];
                if (STRINGHASVALUE(dataName) && STRINGHASVALUE(currentDataVersion))
                {
                    // 列车车站数据版本
                    if ([dataName isEqualToString:@"TrainStationList"])
                    {
                        // 判断数据版本
                        NSString* trainCityVersion = [defaults objectForKey:@"trainCityVersion"];
                        if (trainCityVersion == nil || ([self stringConvertToint:trainCityVersion] < [self stringConvertToint:currentDataVersion]))
                        {
                            // 本地存储新的版本号备份
                            [defaults setValue:currentDataVersion forKey:@"trainCityVersionTmp"];
                            [defaults synchronize];
                            
                            // 更新列车车站数据
                            trainCityUpdate = [[TrainCityUpdate alloc] init];
                            [trainCityUpdate trainCityUpdateStart];
                        }
                    }
                }
            }
        }
        
        
        //现在版本
        NSString* verson = [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:@"CFBundleVersion"];
        int m_ver = [self stringConvertToint:verson];
        //app 上的版本
        NSString* appver = [root safeObjectForKey:@"CurrentVersion"];
        int m_appver = [self stringConvertToint:appver];
        
        //如果现在小于app 上的 版本
        if (m_ver < m_appver) {
            NSString* m_downUrl = [root safeObjectForKey:@"DownloadUrl"];
            m_downLoadUrl = [[NSString alloc] initWithString:m_downUrl];
            
            NSMutableString* m_message = [[[NSMutableString alloc] init] autorelease];
            
            NSMutableArray* m_messageArray = [[NSMutableArray alloc] initWithArray:[root safeObjectForKey:@"WhatsNews"]];
            for (int i = 0; i<[m_messageArray count]; i++) {
                NSString* str = [NSString stringWithFormat:@"%i.%@\r\n",i+1,[m_messageArray safeObjectAtIndex:i]];
                [m_message appendString:str];
            }
            
            [m_messageArray release];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                            message:m_message
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"以后提醒",@"更新", nil];
            alert.tag = 12;
            [alert show];
            [alert release];
        }else{
            [PublicMethods showAlertTitle:@"" Message:@"当前版本为最新版本"];
        }
    }
}




@end
