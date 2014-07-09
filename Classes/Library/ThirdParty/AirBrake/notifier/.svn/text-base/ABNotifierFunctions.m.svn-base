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

#import <execinfo.h>
#import <fcntl.h>
#import <unistd.h>
#import <sys/sysctl.h>
#import <mach/task.h>
#import <mach/task_info.h>
#import <mach/mach_init.h>

#import "ABNotifierFunctions.h"
#import "ABNotice.h"

#import "ABNotifier.h"
#import "AccountManager.h"
#import "UIDevice-Hardware.h"
#import "CrashCollectionLog.h"

// handled signals
int ht_signals_count = 6;
int ht_signals[] = {
	SIGABRT,
	SIGBUS,
	SIGFPE,
	SIGILL,
	SIGSEGV,
	SIGTRAP
};

// internal function prototypes
void ht_handle_signal(int, siginfo_t *, void *);
void ht_handle_exception(NSException *);

#pragma mark crash time methods
//Crash监听 执行方法，一旦Crash，该方法即会调用
void ht_handle_signal(int signal, siginfo_t *info, void *context) {
    // Add by chenggong.
    [[CrashCollectionLog sharedInstance] logToFile];
    // End add.
    
    // stop handler
    ABNotifierStopSignalHandler();
    
    //-----------
	//额外加入，为了方便记录该情况下是发生在哪个ViewController里
	[ABNotifier setEnvironmentValue:ABNotifierCurrentViewController() forKey:ABSignalControllerKey];
    //添加出错时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    [df release];
    [ABNotifier setEnvironmentValue:dateStr forKey:@"Error Occured Time"];
    //添加手机号
    NSString *phoneNumber = [[AccountManager instanse] phoneNo];
    if(STRINGHASVALUE(phoneNumber)){
        [ABNotifier setEnvironmentValue:phoneNumber forKey:@"TelePhone"];
    }else{
        [ABNotifier setEnvironmentValue:@"User Not Login" forKey:@"TelePhone"];
    }
    //添加DeviceId
    [ABNotifier setEnvironmentValue:[PublicMethods macaddress] forKey:@"macAddress"];
    // 实时更新资源使用情况
    UIDevice *device = [UIDevice currentDevice];
    NSArray *usage = [device cpuUsage];
    NSMutableString *usageStr = [NSMutableString stringWithFormat:@""];
    for (NSNumber *u in usage) {
        [usageStr appendString:[NSString stringWithFormat:@"%.1f%% ", [u floatValue]]];
    }
    NSString *memoryInfo = [NSString stringWithFormat:@"%.1f / %uM", [device freeMemoryBytes] / 1024.0 / 1024.0, [device totalMemoryBytes] / 1024 / 1024];
    NSString *diskInfo = [NSString stringWithFormat:@"%llu / %lluG", [device freeDiskSpaceBytes] / (1024*1024*1024),[device totalDiskSpaceBytes] / (1024*1024*1024)];
    [ABNotifier setEnvironmentValue:usageStr forKey:@"CPU Information"];
    [ABNotifier setEnvironmentValue:memoryInfo forKey:@"Memory Information"];
    [ABNotifier setEnvironmentValue:diskInfo forKey:@"Disk Information"];
    //-------------
    // get file handle
    int fd = ABNotifierOpenNewNoticeFile(ab_signal_info.notice_path, ABNotifierSignalNoticeType);
    
    // write if we have a file
    if (fd > -1) {
		
		// signal
        write(fd, &signal, sizeof(int));

		// backtrace
		int count = 128;
		void *frames[count];
		count = backtrace(frames, count);
		backtrace_symbols_fd(frames, count, fd);
		
		// close
        close(fd);
        
    }
	
	// re raise
	raise(signal);
    
}
//同上，这是异常监听执行
void ht_handle_exception(NSException *exception) {
    ABNotifierStopSignalHandler();
    ABNotifierStopExceptionHandler();
    [ABNotifier logException:exception];
}

#pragma mark - notice file methods
//打开通知文件
int ABNotifierOpenNewNoticeFile(const char *path, int type) {
    int fd = open(path, O_WRONLY | O_CREAT, S_IREAD | S_IWRITE);
    if (fd > -1) {
        
        // file version
        write(fd, &ABNotifierNoticeVersion, sizeof(int));
        
        // file bype
        write(fd, &type, sizeof(int));
        
        // notice payload
        write(fd, &ab_signal_info.notice_payload_length, sizeof(unsigned long));
        write(fd, ab_signal_info.notice_payload, ab_signal_info.notice_payload_length);
        
        // user data
        write(fd, &ab_signal_info.user_data_length, sizeof(unsigned long));
        write(fd, ab_signal_info.user_data, ab_signal_info.user_data_length);
        
    }
    return fd;
}

#pragma mark - modify handler state
//*********注册异常监听********
void ABNotifierStartExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(&ht_handle_exception);
}

//*********注册Crash监听*********
void ABNotifierStartSignalHandler(void) {
    for (int i = 0; i < ht_signals_count; i++) {
		int signal = ht_signals[i];
		struct sigaction action;
		sigemptyset(&action.sa_mask);
		action.sa_flags = SA_SIGINFO;
		action.sa_sigaction = ht_handle_signal;
		if (sigaction(signal, &action, NULL) != 0) {
            ABLog(@"Unable to register signal handler for %s", strsignal(signal));
		}
	}
}

//*********异常监听停止********
void ABNotifierStopExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(NULL);
}

//*********Crash监听停止********
void ABNotifierStopSignalHandler(void) {
	for (int i = 0; i < ht_signals_count; i++) {
		int signal = ht_signals[i];
		struct sigaction action;
		sigemptyset(&action.sa_mask);
		action.sa_handler = SIG_DFL;
		sigaction(signal, &action, NULL);
	}
}

#pragma mark - Info.plist accessors
//返回应用程序版本号
NSString *ABNotifierApplicationVersion(void) {
    static NSString *version = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (bundleVersion != nil && versionString != nil) {
            version = [[NSString alloc] initWithFormat:@"%@ (%@)", versionString, bundleVersion];
        }
        else if (bundleVersion != nil) { version = [bundleVersion copy]; }
        else if (versionString != nil) { version = [versionString copy]; }
    });
    return version;
}
//******返回应用程序名字********
NSString *ABNotifierApplicationName(void) {
    static NSString *name = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSString *displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
        if (displayName != nil) { name = [displayName copy]; }
        else if (bundleName != nil) { name = [bundleName copy]; }
        else if (identifier != nil) { name = [identifier copy]; }
    });
    return name;
}

#pragma mark - platform accessors
//*********返回操作系统版本号********
NSString *ABNotifierOperatingSystemVersion(void) {
    static NSString *version = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
#if TARGET_IPHONE_SIMULATOR
        version = [[[UIDevice currentDevice] systemVersion] copy];
#else
        version = [[[NSProcessInfo processInfo] operatingSystemVersionString] copy];
#endif
    });
    return version;
}

//********返回设备名称*********
NSString *ABNotifierMachineName(void) {
#if TARGET_IPHONE_SIMULATOR
    return @"iPhone Simulator";
#else
    static NSString *name = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        size_t size = 256;
        char *machine = malloc(size);
#if TARGET_OS_IPHONE
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
#else
        sysctlbyname("hw.model", machine, &size, NULL, 0);
#endif
        name = [[NSString alloc] initWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
    });
    return name;
#endif
}

//*******返回设备固件系统名称**********
NSString *ABNotifierPlatformName(void) {
#if TARGET_IPHONE_SIMULATOR || !TARGET_OS_IPHONE
    return ABNotifierMachineName();
#else
    static NSString *platform = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSString *machine = ABNotifierMachineName();
        // iphone
        if ([machine isEqualToString:@"iPhone1,1"]) { platform = @"iPhone"; }
        else if ([machine isEqualToString:@"iPhone1,2"]) { platform = @"iPhone 3G"; }
        else if ([machine isEqualToString:@"iPhone2,1"]) { platform = @"iPhone 3GS"; }
        else if ([machine isEqualToString:@"iPhone3,1"]) { platform = @"iPhone 4 (GSM)"; }
        else if ([machine isEqualToString:@"iPhone3,3"]) { platform = @"iPhone 4 (CDMA)"; }
        else if ([machine isEqualToString:@"iPhone4,1"]) { platform = @"iPhone 4S"; }
        else if ([machine isEqualToString:@"iPhone5,1"]) { platform = @"iPhone 5"; }
        else if ([machine isEqualToString:@"iPhone5,2"]) { platform = @"iPhone 5"; }
        // ipad
        else if ([machine isEqualToString:@"iPad1,1"]) { platform = @"iPad"; }
        else if ([machine isEqualToString:@"iPad2,1"]) { platform = @"iPad 2 (WiFi)"; }
        else if ([machine isEqualToString:@"iPad2,2"]) { platform = @"iPad 2 (GSM)"; }
        else if ([machine isEqualToString:@"iPad2,3"]) { platform = @"iPad 2 (CDMA)"; }
        else if ([machine isEqualToString:@"iPad2,5"]) { platform = @"iPad mini"; }
        else if ([machine isEqualToString:@"iPad3,1"]) { platform = @"iPad 2 (CDMA)"; }
        else if ([machine isEqualToString:@"iPad3,2"]) { platform = @"iPad 3 (GSM)"; }
        else if ([machine isEqualToString:@"iPad3,3"]) { platform = @"iPad 3 (CDMA)"; }
        // ipod
        else if ([machine isEqualToString:@"iPod1,1"]) { platform = @"iPod Touch"; }
        else if ([machine isEqualToString:@"iPod2,1"]) { platform = @"iPod Touch (2nd generation)"; }
        else if ([machine isEqualToString:@"iPod3,1"]) { platform = @"iPod Touch (3rd generation)"; }
        else if ([machine isEqualToString:@"iPod4,1"]) { platform = @"iPod Touch (4th generation)"; }
        else if ([machine isEqualToString:@"iPod5,1"]) { platform = @"iPod Touch (4th generation)"; }
        // unknown
        else { platform = machine; }
    });
    return platform;
#endif
}

#pragma mark - call stack functions
NSArray *ABNotifierParseCallStack(NSArray *callStack) {
	Class cls = NSClassFromString (@"NSRegularExpression");   
	if(cls){
		static NSString *pattern = @"^(\\d+)\\s+(\\S.*?)\\s+((0x[0-9a-f]+)\\s+.*)$";
		NSMutableArray *parsed = [NSMutableArray arrayWithCapacity:[callStack count]];
		[callStack enumerateObjectsUsingBlock:^(id line, NSUInteger idx, BOOL *stop) {
			id expression = [cls  regularExpressionWithPattern:pattern options:(NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators) error:nil];
			NSArray *components = [expression matchesInString:line options:NSMatchingReportCompletion range:NSMakeRange(0, [line length])];
			NSMutableArray *frame = [NSMutableArray arrayWithCapacity:[components count]];
			[components enumerateObjectsUsingBlock:^(id result, NSUInteger index, BOOL *s) {
				for (NSUInteger i = 0; i < [result numberOfRanges]; i++) {
					[frame addObject:[line substringWithRange:[result rangeAtIndex:i]]];
				}
			}];
			[parsed addObject:frame];
		}];
		return parsed;
	}else {
		return nil;
	}

}
NSString *ABNotifierActionFromParsedCallStack(NSArray *callStack, NSString *executable) {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bindings) {
        if (![[(NSArray *)obj objectAtIndex:2] isEqualToString:executable]) { return NO; }
        NSRange range = [[(NSArray *)obj objectAtIndex:3] rangeOfString:@"ht_handle_signal"];
        return range.location == NSNotFound;
    }];
    NSArray *matching = [callStack filteredArrayUsingPredicate:predicate];
    if ([matching count]) { return [(NSArray *)[matching objectAtIndex:0] objectAtIndex:3]; }
    else { return nil; }
}

#pragma mark - memory usage
//程序内存剩余
NSString *ABNotifierResidentMemoryUsage(void) {
    struct task_basic_info basic;
    mach_msg_type_number_t count = TASK_BASIC_INFO_COUNT;
    if (task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&basic, &count) == KERN_SUCCESS) {
        vm_size_t b = basic.resident_size;
        double mb = (float)b / 1048576.0;
        return [NSString stringWithFormat:@"%0.2f MB", mb];
    }
    else {
        return @"Unknown";
    }
}

//*****机器所剩内存*********
NSString *ABNotifierVirtualMemoryUsage(void) {
    struct task_basic_info basic;
    mach_msg_type_number_t count = TASK_BASIC_INFO_COUNT;
    if (task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&basic, &count) == KERN_SUCCESS) {
        vm_size_t b = basic.virtual_size;
        double mb = (float)b / 1048576.0;
        return [NSString stringWithFormat:@"%0.2f MB", mb];
    }
    else {
        return @"Unknown";
    }
}

#if TARGET_OS_IPHONE

#pragma mark - view controller
//*******返回当前控制器名称*********
NSString *ABNotifierCurrentViewController(void) {
    
    // assert
    NSCAssert([NSThread isMainThread], @"This function must be called on the main thread");
    
	// view controller to inspect
	UIViewController *rootController = nil;
    
	// try getting view controller from notifier delegate
	id<ABNotifierDelegate> delegte = [ABNotifier delegate];
	if ([delegte respondsToSelector:@selector(rootViewControllerForNotice)]) {
		rootController = [delegte rootViewControllerForNotice];
	}
	
	// try getting view controller from window
	NSLog(@"rootController:=======%@",rootController);
	UIApplication *app = [UIApplication sharedApplication];
	UIWindow *keyWindow = [app keyWindow];
	if (rootController == nil && [keyWindow respondsToSelector:@selector(rootViewController)]) {
		rootController = [keyWindow rootViewController];
	}
	// if we don't have a controller yet, give up
	if (rootController == nil) {
		return @"NotFoundCurrentViewController";
	}
	
	// call method to get class name
	return ABNotifierVisibleViewControllerFromViewController(rootController);
    
}

//************当前可见的控制器名称***********
NSString *ABNotifierVisibleViewControllerFromViewController(id controller) {
    
    // assert
    NSCAssert([NSThread isMainThread], @"This function must be called on the main thread");
	
	// tab bar controller
	if ([controller isKindOfClass:[UITabBarController class]]) {
//		UIViewController *visibleController = [(UITabBarController *)controller selectedViewController];
		return ABNotifierVisibleViewControllerFromViewController([(UITabBarController *)controller selectedViewController]);
	}
    
	// navigation controller
	else if ([controller isKindOfClass:[UINavigationController class]]) {
//		UIViewController *visibleController = [(UINavigationController *)controller visibleViewController];
		return ABNotifierVisibleViewControllerFromViewController([(UINavigationController *)controller visibleViewController]);
	}
    
	// other type
	else {
		return NSStringFromClass([controller class]);
	}
	
}
#endif

#pragma mark - localization
//返回  本地化序列文本*********
NSString *ABLocalizedString(NSString* key) {
    static NSBundle *bundle = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ABNotifier" ofType:@"bundle"];
        bundle = [[NSBundle alloc] initWithPath:path];
    });
    return [bundle localizedStringForKey:key value:key table:nil];
}
