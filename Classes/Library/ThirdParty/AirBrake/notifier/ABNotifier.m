/*
 
 Copyright (C) 2011 GUI Cocoa, LLC.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "ABNotice.h"
#import "ABNotifierFunctions.h"

#import "ABNotifier.h"

#import "GCAlertView.h"
#import <unistd.h>
#import "AccountManager.h"
#import "UIDevice-Hardware.h"
#import "CrashCollectionLog.h"

// internal
static SCNetworkReachabilityRef __reachability = nil;
static id<ABNotifierDelegate> __delegate = nil;
static NSMutableDictionary *__userData;
static NSString * __APIKey = nil;
static BOOL __useSSL = NO;
static BOOL __displayPrompt = YES;

// constant strings     
static NSString * const ABNotifierHostName                  = @"www.baidu.com";		//服务器地址
static NSString * const ABNotifierAlwaysSendKey             = @"AlwaysSendCrashReports";		//总是发送错误报告
NSString * const ABNotifierWillDisplayAlertNotification     = @"ABNotifierWillDisplayAlert";
NSString * const ABNotifierDidDismissAlertNotification      = @"ABNotifierDidDismissAlert";
NSString * const ABNotifierWillPostNoticesNotification      = @"ABNotifierWillPostNotices";
NSString * const ABNotifierDidPostNoticesNotification       = @"ABNotifierDidPostNotices";
NSString * const ABNotifierVersion                          = @"3.2";
NSString * const ABNotifierDevelopmentEnvironment           = @"Development";
NSString * const ABNotifierAdHocEnvironment                 = @"Ad Hoc";
NSString * const ABNotifierAppStoreEnvironment              = @"App Store";
NSString * const ABNotifierReleaseEnvironment               = @"Release";
#ifndef __OPTIMIZE__
NSString * const ABNotifierAutomaticEnvironment             = @"Development";
#else
NSString * const ABNotifierAutomaticEnvironment             = @"Production";
#endif

// reachability callback
void ABNotifierReachabilityDidChange(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info);

@interface ABNotifier ()

// get the path where notices are stored
+ (NSString *)pathForNoticesDirectory;		//iPhone os下创建存放Crash记录目录

// get the path for a new notice given the file name
+ (NSString *)pathForNewNoticeWithName:(NSString *)name;

// get the paths for all valid notices
+ (NSArray *)pathsForAllNotices;

// post all provided notices to airbrake
+ (void)postNoticesWithPaths:(NSArray *)paths;

// post the given notice to the given URL
+ (void)postNoticeWithContentsOfFile:(NSString *)path toURL:(NSURL *)URL;

// caches user data to store that can be read at signal time
+ (void)cacheUserDataDictionary;

// pop a notice alert and perform necessary actions
+ (void)showNoticeAlertForNoticesWithPaths:(NSArray *)paths;

// determine if we are reachable with given flags
+ (BOOL)isReachable:(SCNetworkReachabilityFlags)flags;

@end

@implementation ABNotifier

#pragma mark - initialize the notifier
//开始记录并设置监听
+ (void)startNotifierWithAPIKey:(NSString *)key
                environmentName:(NSString *)name
                         useSSL:(BOOL)useSSL
                       delegate:(id<ABNotifierDelegate>)delegate {
    [self startNotifierWithAPIKey:key
                  environmentName:name
                           useSSL:useSSL
                         delegate:delegate
          installExceptionHandler:YES
             installSignalHandler:YES
                displayUserPrompt:YES];
}
+ (void)startNotifierWithAPIKey:(NSString *)key
                environmentName:(NSString *)name
                         useSSL:(BOOL)useSSL
                       delegate:(id<ABNotifierDelegate>)delegate
        installExceptionHandler:(BOOL)exception
           installSignalHandler:(BOOL)signal {
    [self startNotifierWithAPIKey:key
                  environmentName:name
                           useSSL:useSSL
                         delegate:delegate
          installExceptionHandler:exception
             installSignalHandler:signal
                displayUserPrompt:YES];
}
+ (void)startNotifierWithAPIKey:(NSString *)key
                environmentName:(NSString *)name
                         useSSL:(BOOL)useSSL
                       delegate:(id<ABNotifierDelegate>)delegate
        installExceptionHandler:(BOOL)exception
           installSignalHandler:(BOOL)signal
              displayUserPrompt:(BOOL)display {
    @synchronized(self) {
        static BOOL token = YES;
        if (token) {
            
            // change token5
            token = NO;
            
            // register defaults
	//默认总是发送错误报告为NO
            [[NSUserDefaults standardUserDefaults] registerDefaults:
             [NSDictionary dictionaryWithObject:@"YES" forKey:ABNotifierAlwaysSendKey]];
			
            
            // capture vars
            __userData = [[NSMutableDictionary alloc] init];
            __delegate = delegate;
            __useSSL = useSSL;
            __displayPrompt = display;
            
            // switch on api key
			//************api决定能否Post信息，name决定是否能够打印出信息
            if ([key length]) {
                __APIKey = [key copy];
                __reachability = SCNetworkReachabilityCreateWithName(NULL, [ABNotifierHostName UTF8String]);
                if (SCNetworkReachabilitySetCallback(__reachability, ABNotifierReachabilityDidChange, nil)) {
                    if (!SCNetworkReachabilityScheduleWithRunLoop(__reachability, CFRunLoopGetMain(), kCFRunLoopDefaultMode)) {
                        ABLog(@"Reachability could not be configired. No notices will be posted.");
                    }
                }
            }
            else {
                ABLog(@"The API key must not be blank. No notices will be posted.");
            }
            
            // switch on environment name		
            if ([name length]) {
                
                // vars
                unsigned long length;
                
                // cache signal notice file path
                NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];
                const char *filePath = [[ABNotifier pathForNewNoticeWithName:fileName] UTF8String];
                length = (strlen(filePath) + 1);
				//*****标记并复制Crash文件路径到ab_signal_info,此为ABNotifce文件中的结构体
                ab_signal_info.notice_path = malloc(length);
                memcpy((void *)ab_signal_info.notice_path, filePath, length);
                
                // cache notice payload
		//********name为EnvironmentName（软件运行环境，开发环境还是发布环境还是其它）, ABNotifierBundleVersionKey（软件版本号,plist文件设置）,ABNotifierExecutableKey(软件名称,plist文件设置) ，若增加更多信息，可在NSDictionary修改
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 name, ABNotifierEnvironmentNameKey,
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                                 ABNotifierBundleVersionKey,
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"],
                                 ABNotifierExecutableKey,
                                 nil]];
				
				//*****标记并复制软件信息到ab_signal_info,此为ABNotifce文件中的结构体
                length = [data length];
                ab_signal_info.notice_payload = malloc(length);
                memcpy(ab_signal_info.notice_payload, [data bytes], length);
                ab_signal_info.notice_payload_length = length;
                
                // cache user data
		//ABNotifierPlatformName为平台信息，哪个平台（ipad，ipad2，ipad3等），，ABNotifierOperatingSystemVersion为当前系统固件版本号（ios3.2，ios4，ios6），ABNotifierApplicationVersion应用程序版本，（1.0.0，2.0.0）
                [self addEnvironmentEntriesFromDictionary:
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  ABNotifierPlatformName(), ABNotifierPlatformNameKey,
                  ABNotifierOperatingSystemVersion(), ABNotifierOperatingSystemVersionKey,
                  ABNotifierApplicationVersion(), ABNotifierApplicationVersionKey,
                  nil]];
                
                // start handlers
				//设这异常监听以及Crash监听
                if (exception) {
                    ABNotifierStartExceptionHandler();
                }
                if (signal) {
                    ABNotifierStartSignalHandler();
                }
                
                // log
                ABLog(@"Notifier %@ ready to catch errors", ABNotifierVersion);
                ABLog(@"Environment \"%@\"", name);
                
            }
            else {
                ABLog(@"The environment name must not be blank. No new notices will be logged");
            }
            
        }
    }
}

#pragma mark - accessors
+ (id<ABNotifierDelegate>)delegate {
    @synchronized(self) {
        return __delegate;
    }
}
+ (NSString *)APIKey {
    @synchronized(self) {
        return __APIKey;
    }
}

#pragma mark - write data
//**************打印异常信息，并写入到文件********
+ (void)logException:(NSException *)exception parameters:(NSDictionary *)parameters {
//    NSLog(@"exception");
    
    // Add by chenggong.
    [[CrashCollectionLog sharedInstance] logToFile];
    // End add.
    
    // force all activity onto main thread
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self logException:exception parameters:parameters];
        });
        return;
    }
    
    // get file handle
    NSString *name = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *path = [self pathForNewNoticeWithName:name];
    int fd = ABNotifierOpenNewNoticeFile([path UTF8String], ABNotifierExceptionNoticeType);
    
    // write stuff
    if (fd > -1) {
        @try {
            
            // create parameters
            NSMutableDictionary *exceptionParameters = [NSMutableDictionary dictionary];
            if ([parameters count]) { [exceptionParameters addEntriesFromDictionary:parameters]; }
            [exceptionParameters setValue:ABNotifierResidentMemoryUsage() forKey:@"Resident Memory Usage"];
            [exceptionParameters setValue:ABNotifierVirtualMemoryUsage() forKey:@"Virtual Memory Usage"];

            
            //添加手机号
            NSString *phoneNumber = [[AccountManager instanse] phoneNo];
            if(!STRINGHASVALUE(phoneNumber)){
                phoneNumber = @"user didnot login!";
            }
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr = [df stringFromDate:[NSDate date]];
            [df release];
            [exceptionParameters setValue:dateStr forKey:@"Error Occured Time"];
            [exceptionParameters setValue:phoneNumber forKey:@"TelePhone"];
            [exceptionParameters setValue:[PublicMethods macaddress] forKey:@"macAddress"];
            // 实时更新资源使用情况
            UIDevice *device = [UIDevice currentDevice];
            NSArray *usage = [device cpuUsage];
            NSMutableString *usageStr = [NSMutableString stringWithFormat:@""];
            for (NSNumber *u in usage) {
                [usageStr appendString:[NSString stringWithFormat:@"%.1f%% ", [u floatValue]]];
            }
            NSString *memoryInfo = [NSString stringWithFormat:@"%.1f / %uM", [device freeMemoryBytes] / 1024.0 / 1024.0, [device totalMemoryBytes] / 1024 / 1024];
            NSString *diskInfo = [NSString stringWithFormat:@"%llu / %lluG", [device freeDiskSpaceBytes] / (1024*1024*1024),[device totalDiskSpaceBytes] / (1024*1024*1024)];
            [exceptionParameters setValue:usageStr forKey:@"CPU Information"];
            [exceptionParameters setValue:memoryInfo forKey:@"Memory Information"];
            [exceptionParameters setValue:diskInfo forKey:@"Disk Information"];
            // write exception
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [exception name], ABNotifierExceptionNameKey,
                                        [exception reason], ABNotifierExceptionReasonKey,
                                        [exception callStackSymbols], ABNotifierCallStackKey,
                                        exceptionParameters, ABNotifierExceptionParametersKey,
#if TARGET_OS_IPHONE
                                        ABNotifierCurrentViewController(), ABNotifierControllerKey,
#endif
                                        nil];
            
            NSLog(@"Dictionary: %@", [dictionary description]);
            
            // 保存crash信息
            NSArray *arrayCrashInfoSaved = [Utils arrayDateSaved:kCrashInfoFile andSaveKey:kCrashInfoArchiverKey];
            
            NSMutableArray *arrayCrashInfo = [[NSMutableArray alloc] initWithArray:arrayCrashInfoSaved];
            // 填入当前crash
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            NSString *stringDateNow = [dateFormatter stringFromDate:[NSDate date]];
            
            // 计算启动到奔溃的时间
            NSDate *systemLaunchTime = [[NSUserDefaults standardUserDefaults] objectForKey:kSystemLaunchTimeKey];
            NSString *stringDateLaunch = [dateFormatter stringFromDate:systemLaunchTime];
            NSString *stringInterval = [PublicMethods intervalSinceNow:stringDateLaunch];
            
            // 填充为key值
            NSString *crashDateString = [NSString stringWithFormat:@"%@__%@",stringDateNow,stringInterval];
            NSDictionary *currCrash = [NSDictionary dictionaryWithObject:dictionary forKey:crashDateString];
            [arrayCrashInfo insertObject:currCrash atIndex:0];
            // 将crash信息写入文件
            if (DEBUGBAR_SWITCH)
            {
                [Utils saveData:arrayCrashInfo withFileName:kCrashInfoFile andSaveKey:kCrashInfoArchiverKey];
            }
            [dateFormatter release];
            [arrayCrashInfo release];
            
            // 本地保存crash步骤
            [[CrashCollectionLog sharedInstance] crashLocalSave:crashDateString];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
            unsigned long length = [data length];
            write(fd, &length, sizeof(unsigned long));
            write(fd, [data bytes], length);
            
            // delegate
            id<ABNotifierDelegate> delegate = [self delegate];
            if ([delegate respondsToSelector:@selector(notifierDidLogException:)]) {
                [delegate notifierDidLogException:exception];
            }
            
        }
        @catch (NSException *exception) {
            ABLog(@"Exception encountered while logging exception");
            ABLog(@"%@", exception);
        }
        @finally {
            close(fd);
        }
    }
    
}
+ (void)logException:(NSException *)exception {
    [self logException:exception parameters:nil];
}

//**************测试异常****************
+ (void)writeTestNotice {
    @try {
        NSArray *array = [NSArray array];
        [array objectAtIndex:NSUIntegerMax];
    }
    @catch (NSException *e) {
        [self logException:e];
    }
}

#pragma mark - environment variables
//自己设置变量以及关键字，用于服务器交互信息，此处设置可增加服务器需要信息内容
+ (void)setEnvironmentValue:(NSString *)value forKey:(NSString *)key {
    @synchronized(self) {
        [__userData setObject:value forKey:key];
        [ABNotifier cacheUserDataDictionary];
    }
}
//********将dictionary值赋值到_userData
+ (void)addEnvironmentEntriesFromDictionary:(NSDictionary *)dictionary {
    @synchronized(self) {
        [__userData addEntriesFromDictionary:dictionary];
        [ABNotifier cacheUserDataDictionary];		//重新设置_userData值
    }
}
+ (NSString *)environmentValueForKey:(NSString *)key {
    @synchronized(self) {
        return [__userData objectForKey:key];
    }
}
//清空对应Key的值
+ (void)removeEnvironmentValueForKey:(NSString *)key {
    @synchronized(self) {
        [__userData removeObjectForKey:key];
        [ABNotifier cacheUserDataDictionary];
    }
}
//清空对应keys的值
+ (void)removeEnvironmentValuesForKeys:(NSArray *)keys {
    @synchronized(self) {
        [__userData removeObjectsForKeys:keys];
        [ABNotifier cacheUserDataDictionary];
    }
}

#pragma mark - file utilities
//创建Crash记录目录，iPhone os下设置为NSLibraryDirectory，非iPhone os下为NSApplicationSupportDirectory，目录文件名为 Hoptoad Notices
+ (NSString *)pathForNoticesDirectory {
	//************得到目录文件路径名字******************
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
#if TARGET_OS_IPHONE
        NSArray *folders = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);	//可修改
        path = [folders objectAtIndex:0];
        if ([folders count] == 0) {
            path = NSTemporaryDirectory();
        }
        else {
            path = [path stringByAppendingPathComponent:@"Hoptoad Notices"];	//可修改
        }
#else
        NSArray *folders = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);	//可修改
        path = [folders objectAtIndex:0];
        if ([folders count] == 0) {
            path = NSTemporaryDirectory();
        }
        else {
            path = [path stringByAppendingPathComponent:ABNotifierApplicationName()];
            path = [path stringByAppendingPathComponent:@"Hoptoad Notices"];		//可修改
        }
#endif
	//**************判断目录是否存在，若不存在，创建目录****************
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            [manager
             createDirectoryAtPath:path
             withIntermediateDirectories:YES
             attributes:nil
             error:nil];
        }
        [path retain];
    });
    return path;
}
//*********返回Name命名的文件，以ABNotifierNoticePathExtension命名格式结尾
+ (NSString *)pathForNewNoticeWithName:(NSString *)name {
    NSString *path = [self pathForNoticesDirectory];
    path = [path stringByAppendingPathComponent:name];
    return [path stringByAppendingPathExtension:ABNotifierNoticePathExtension];
}

//遍历Crash目录，得到所有的Crash记录文件路径
+ (NSArray *)pathsForAllNotices {
    NSString *path = [self pathForNoticesDirectory];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *paths = [NSMutableArray arrayWithCapacity:[contents count]];
    [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj pathExtension] isEqualToString:ABNotifierNoticePathExtension]) {
            NSString *noticePath = [path stringByAppendingPathComponent:obj];
            [paths addObject:noticePath];
        }
    }];
    return paths;
}

#pragma mark - post notices
//***********把Crash目录下的相关文件读取出来进行发送************
+ (void)postNoticesWithPaths:(NSArray *)paths {
    
    // assert
    NSAssert(![NSThread isMainThread], @"This method must not be called on the main thread");
    NSAssert([paths count], @"No paths were provided");
    
    // get variables
    if ([paths count] == 0) { return; }
    id<ABNotifierDelegate> delegate = [ABNotifier delegate];
    
    // notify people
	//***************通知信息将被发送****************
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([delegate respondsToSelector:@selector(notifierWillPostNotices)]) {
            [delegate notifierWillPostNotices];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ABNotifierWillPostNoticesNotification object:self];
    });
    
	//设置 传输服务器的URL
    // create url
    NSString *URLString = [NSString stringWithFormat:
                           @"%@://mobile-api2011.elong.com/JsonService/OtherService.aspx",
                           (__useSSL ? @"https" : @"http")];
    NSURL *URL = [NSURL URLWithString:URLString];
    
#if TARGET_OS_IPHONE
    
    // start background task
    __block BOOL keepPosting = YES;
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier task = [app beginBackgroundTaskWithExpirationHandler:^{
        keepPosting = NO;
    }];
    
    // report each notice
	//*******反馈每一个信息
    [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (keepPosting) { [self postNoticeWithContentsOfFile:obj toURL:URL]; }
        else { *stop = YES; }
    }];
    
    // end background task
    if (task != UIBackgroundTaskInvalid) {
        [app endBackgroundTask:task];
    }
    
#else
    
    // report each notice
    [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self postNoticeWithContentsOfFile:obj toURL:URL];
    }];
    
#endif
    
    // notify people
	//*************发送通知完成**********
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([delegate respondsToSelector:@selector(notifierDidPostNotices)]) {
            [delegate notifierDidPostNotices];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ABNotifierDidPostNoticesNotification object:self];
    });
	
}

//发送Crash文件信息到URL
+ (void)postNoticeWithContentsOfFile:(NSString *)path toURL:(NSURL *)URL {
    
    // assert
    NSAssert(![NSThread isMainThread], @"This method must not be called on the main thread");
    
    // create url request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
	[request setHTTPMethod:@"POST"];
    
	// get notice payload
    ABNotice *notice = [ABNotice noticeWithContentsOfFile:path];
#ifndef __OPTIMIZE__
    ABLog(@"%@", notice);
#endif
    NSString *JSONString = [notice hoptoadJSONString];
    
    if (JSONString) {
        NSData *data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
    }
    else {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return;
    }
	
	// perform request
    NSError *error = nil;
	NSHTTPURLResponse *response = nil;
#ifdef DEBUG
    NSData *responseBody = 
#endif
    [NSURLConnection
     sendSynchronousRequest:request
     returningResponse:&response
     error:&error];

    NSInteger statusCode = [response statusCode];
	// error checking
    if (error) {
        ABLog(@"Encountered error while posting notice.");
        ABLog(@"%@", error);
        return;
    }
    else {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
	
	// great success
	if (statusCode == 200) {
        ABLog(@"Crash report posted");
	}
    
    // forbidden
    else if (statusCode == 403) {
        ABLog(@"Please make sure that your API key is correct and that your project supports SSL.");
    }
    
    // invalid post
    else if (statusCode == 422) {
        ABLog(@"The posted notice payload is invalid.");
#ifdef DEBUG
        ABLog(@"%@", XMLString);
#endif
    }
    
    // unknown
    else {
        ABLog(@"Encountered unexpected status code: %ld", (long)statusCode);
#ifdef DEBUG
        NSString *responseString = [[NSString alloc]
                                    initWithData:responseBody
                                    encoding:NSUTF8StringEncoding];
        ABLog(@"%@", responseString);
        [responseString release];
#endif
    }
    
}

#pragma mark - cache methods
//重新缓存设置_userData的值
+ (void)cacheUserDataDictionary {
    @synchronized(self) {
        
        // free old cached value
        free(ab_signal_info.user_data);
        ab_signal_info.user_data_length = 0;
        ab_signal_info.user_data = nil;
        
        // cache new value
        if (__userData) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:__userData];
            unsigned long length = [data length];
            ab_signal_info.user_data = malloc(length);
            [data getBytes:ab_signal_info.user_data length:length];
            ab_signal_info.user_data_length = length;
        }
        
    }
}

#pragma mark - user interface
//*************显示给用户Crash提示并由用户选择是否发送信息报告***********
+ (void)showNoticeAlertForNoticesWithPaths:(NSArray *)paths {
    
    // assert
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread");
    NSAssert([paths count], @"No paths were provided");
    
    // get delegate
    id<ABNotifierDelegate> delegate = [self delegate];
    
    // alert title
    NSString *title = nil;
    if ([delegate respondsToSelector:@selector(titleForNoticeAlert)]) {
        title = [delegate titleForNoticeAlert];	//定义alert名字
    }
    if (title == nil) {
        title = ABLocalizedString(@"NOTICE_TITLE");
    }
    
    // alert body
    NSString *body = nil;
    if ([delegate respondsToSelector:@selector(bodyForNoticeAlert)]) {
        body = [delegate bodyForNoticeAlert];
    }
    if (body == nil) {
        body = [NSString stringWithFormat:ABLocalizedString(@"NOTICE_BODY"), ABNotifierApplicationName()];
    }
    
    // declare blocks
    void (^delegateDismissBlock) (void) = ^{
        if ([delegate respondsToSelector:@selector(notifierDidDismissAlert)]) {
            [delegate notifierDidDismissAlert];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ABNotifierDidDismissAlertNotification object:self];
    };
    void (^delegatePresentBlock) (void) = ^{
        if ([delegate respondsToSelector:@selector(notifierWillDisplayAlert)]) {
            [delegate notifierWillDisplayAlert];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ABNotifierWillDisplayAlertNotification object:self];
    };
    void (^postNoticesBlock) (void) = ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self postNoticesWithPaths:paths];
        });
    };
    void (^deleteNoticesBlock) (void) = ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [manager removeItemAtPath:obj error:nil];
        }];
    };
    void (^setDefaultsBlock) (void) = ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:ABNotifierAlwaysSendKey];
        [defaults synchronize];
    };
    
#if TARGET_OS_IPHONE
    
    GCAlertView *alert = [[GCAlertView alloc] initWithTitle:title message:body];
    [alert addButtonWithTitle:ABLocalizedString(@"ALWAYS_SEND") block:^{
        setDefaultsBlock();
        postNoticesBlock();
    }];
    [alert addButtonWithTitle:ABLocalizedString(@"SEND") block:postNoticesBlock];
    [alert addButtonWithTitle:ABLocalizedString(@"DONT_SEND") block:deleteNoticesBlock];
    [alert setDidDismissBlock:delegateDismissBlock];
    [alert setDidDismissBlock:delegatePresentBlock];
    [alert setCancelButtonIndex:2];
    [alert show];
    [alert release];
    
#else
    
    // delegate
    delegatePresentBlock();
    
    // build alert
	NSAlert *alert = [NSAlert
                      alertWithMessageText:title
                      defaultButton:ABLocalizedString(@"ALWAYS_SEND")
                      alternateButton:ABLocalizedString(@"DONT_SEND")
                      otherButton:ABLocalizedString(@"SEND")
                      informativeTextWithFormat:body];
    
    // run alert
	NSInteger code = [alert runModal];
    
    // don't send
    if (code == NSAlertAlternateReturn) {
        deleteNoticesBlock();
    }
    
    // send
    else {
        if (code == NSAlertDefaultReturn) {
            setDefaultsBlock();
        }
        postNoticesBlock();
    }
    
    // delegate
	delegateDismissBlock();
    
#endif
    
}

#pragma mark - reachability
//************判断是否联网**************
+ (BOOL)isReachable:(SCNetworkReachabilityFlags)flags {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return NO;
    }
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        return YES;
    }
    if (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
        ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            return YES;
        }
    }
    return NO;
}

@end

#pragma mark - reachability change
///**********网络联通时，进行回调监听*************
void ABNotifierReachabilityDidChange(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    if ([ABNotifier isReachable:flags]) {
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            NSArray *paths = [ABNotifier pathsForAllNotices];
            if ([paths count]) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:ABNotifierAlwaysSendKey] ||
                    !__displayPrompt) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [ABNotifier postNoticesWithPaths:paths];
                    });
                }
                else {
                    [ABNotifier showNoticeAlertForNoticesWithPaths:paths];
                }
            }
        });
    }
}
