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

#import <objc/runtime.h>

#import "ABNotice.h"
#import "ABNotifierFunctions.h"

#import "ABNotifier.h"

#import "DDXML.h"
#import "PostHeader.h"
#import "CrashCollectionLog.h"
#import "AccountManager.h"

// library constants
NSString * const ABNotifierOperatingSystemVersionKey    = @"Operating System";
NSString * const ABNotifierApplicationVersionKey        = @" App Version";
NSString * const ABNotifierPlatformNameKey              = @"System Platform";			//平台信息
NSString * const ABNotifierEnvironmentNameKey           = @"System Environment";
NSString * const ABNotifierBundleVersionKey             = @"Bundle Version";
NSString * const ABNotifierExceptionNameKey             = @"Exception Name";
NSString * const ABNotifierExceptionReasonKey           = @"Exception Reson";
NSString * const ABNotifierCallStackKey                 = @"Call Stack";
NSString * const ABNotifierControllerKey                = @"Exception Controller";
NSString *const ABSignalControllerKey			= @"Crash Controller";
NSString * const ABNotifierExecutableKey                = @"App Name";
NSString * const ABNotifierExceptionParametersKey       = @"Exception Parameters";
NSString * const ABNotifierNoticePathExtension          = @"htnotice";		//Crash文件后缀名设置
const int ABNotifierNoticeVersion         = 5;
const int ABNotifierSignalNoticeType      = 1;
const int ABNotifierExceptionNoticeType   = 2;

@interface ABNotice ()
@property (nonatomic, copy) NSString        *environmentName;
@property (nonatomic, copy) NSString        *bundleVersion;
@property (nonatomic, copy) NSString        *exceptionName;
@property (nonatomic, copy) NSString        *exceptionReason;
@property (nonatomic, copy) NSString        *controller;
@property (nonatomic, copy) NSString        *action;
@property (nonatomic, copy) NSString        *executable;
@property (nonatomic, copy) NSArray         *callStack;
@property (nonatomic, retain) NSNumber      *noticeVersion;
@property (nonatomic, copy) NSDictionary    *environmentInfo;
@property (nonatomic, copy) NSString         *callStackText;
@end

@implementation ABNotice

@synthesize noticeVersion = __noticeVersion;
@synthesize environmentName = __environmentName;
@synthesize bundleVersion = __bundleVersion;
@synthesize exceptionName = __exceptionName;
@synthesize exceptionReason = __exceptionReason;
@synthesize controller  = __controller;
@synthesize callStack = __callStack;
@synthesize environmentInfo = __environmentInfo;
@synthesize action = __action;
@synthesize executable = __executable;


//从Crash文件中读取数据，转为为ABNotice对象并填充ABNotice对象
- (id)initWithContentsOfFile:(NSString *)path {
    self = [super init];
    if (self) {
        @try {
            
            // check path
            NSString *extension = [path pathExtension];
            if (![extension isEqualToString:ABNotifierNoticePathExtension]) {
                [NSException
                 raise:NSInvalidArgumentException
                 format:@"%@ is not a valid notice", path];
            }
            
            // setup
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSData *subdata = nil;
            NSDictionary *dictionary = nil;
            unsigned long location = 0;
            unsigned long length = 0;
            
            // get version
            int version;
            [data getBytes:&version range:NSMakeRange(location, sizeof(int))];
            location += sizeof(int);
            if (version < 5) {
                [NSException
                 raise:NSInternalInconsistencyException
                 format:@"The notice at %@ is not compatible with this version of the notifier", path];
            }
            self.noticeVersion = [NSNumber numberWithInt:version];
            
            // get type
            int type;
            [data getBytes:&type range:NSMakeRange(location, sizeof(int))];
            location += sizeof(int);
            
            // get notice payload
            [data getBytes:&length range:NSMakeRange(location, sizeof(unsigned long))];
            location += sizeof(unsigned long);
            subdata = [data subdataWithRange:NSMakeRange(location, length)];
            location += length;
            dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:subdata];
            self.environmentName = [dictionary objectForKey:ABNotifierEnvironmentNameKey];
            self.bundleVersion = [dictionary objectForKey:ABNotifierBundleVersionKey];
            self.executable = [dictionary objectForKey:ABNotifierExecutableKey];
            
            // get user data
            [data getBytes:&length range:NSMakeRange(location, sizeof(unsigned long))];
            location += sizeof(unsigned long);
            subdata = [data subdataWithRange:NSMakeRange(location, length)];
            location += length;
            self.environmentInfo = [NSKeyedUnarchiver unarchiveObjectWithData:subdata];
            
			//输出查看是否是Crash还是异常
			NSLog(@"错误类型:%@",type==ABNotifierSignalNoticeType?@"ABNotifierSignalNoticeType":@"ABNotifierExceptionNoticeType");
            // signal notice
            if (type == ABNotifierSignalNoticeType) {
                
                // signal
                int signal;
                [data getBytes:&signal range:NSMakeRange(location, sizeof(int))];
                location += sizeof(int);
                
                // exception name
                self.exceptionName = [NSString stringWithUTF8String:strsignal(signal)];
                self.exceptionReason = @"Don't know the signal reason";
	       self.controller = [self.environmentInfo objectForKey:ABSignalControllerKey];
                
                // call stack
                length = [data length] - location;
                char *string = malloc(length + 1);
                const char *bytes = [data bytes];
                for (unsigned long i = 0; location < [data length]; location++) {
                    if (bytes[location] != '\0') {
                        string[i++] = bytes[location];
                    }
                }
                NSArray *lines = [[NSString stringWithUTF8String:string] componentsSeparatedByString:@"\n"];
                NSPredicate *lengthPredicate = [NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
                    return ([object length] > 0);
                }];
                self.callStack = [lines filteredArrayUsingPredicate:lengthPredicate];
                free(string);
                
            }
            
            // exception notice
            else if (type == ABNotifierExceptionNoticeType) {
                
                // exception payload
                [data getBytes:&length range:NSMakeRange(location, sizeof(unsigned long))];
                location += sizeof(unsigned long);
                subdata = [data subdataWithRange:NSMakeRange(location, length)];
                dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:subdata];
                self.exceptionName = [dictionary objectForKey:ABNotifierExceptionNameKey];
                self.exceptionReason = [dictionary objectForKey:ABNotifierExceptionReasonKey];
                self.callStack = [dictionary objectForKey:ABNotifierCallStackKey];
                
                //
                [self setCallStackText:[dictionary description]];
                
                self.controller = [dictionary objectForKey:ABNotifierControllerKey];
                NSMutableDictionary *mutableInfo = [self.environmentInfo mutableCopy];
                [mutableInfo addEntriesFromDictionary:[dictionary objectForKey:ABNotifierExceptionParametersKey]];
                self.environmentInfo = mutableInfo;
                [mutableInfo release];
                
            }
            
            // finish up call stack stuff
            self.callStack = ABNotifierParseCallStack(self.callStack);
            self.action = ABNotifierActionFromParsedCallStack(self.callStack, self.executable);
            if (type == ABNotifierSignalNoticeType && self.action != nil) {
                self.exceptionReason = self.action;
            }
            
        }
        @catch (NSException *exception) {
            ABLog(@"%@", exception);
            [self release];
            return nil;
        }
    }
    return self;
}

//静态方法 调用
+ (ABNotice *)noticeWithContentsOfFile:(NSString *)path {
    return [[[ABNotice alloc] initWithContentsOfFile:path] autorelease];
}

- (NSString *)hoptoadJSONString
{
    // pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *message = [NSString stringWithFormat:@"%@: %@", self.exceptionName, self.exceptionReason];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [dictionary setValue:self.controller forKey:@"PageName"];
    [dictionary setValue:message forKey:@"ExceptionName"];
    [dictionary setValue:[NSNumber numberWithInt:0] forKey:@"ExceptionType"];
    NSMutableString *callstack = [NSMutableString string];
    // crash详细信息
    if (!STRINGHASVALUE(_callStackText))
    {
        // 获取异常信息描述
        NSString *stackText = [self.callStack description];
        if (STRINGHASVALUE(stackText))
        {
            [self setCallStackText:stackText];
        }
    }
//    else
//    {
//        [self.callStack enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [callstack appendFormat:@"number-%@;file-%@;method-%@", [obj objectAtIndex:1],  [obj objectAtIndex:2], [obj objectAtIndex:3]];
//        }];
//    }
    
    NSString *modifyString = [_callStackText stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    modifyString = [modifyString stringByReplacingOccurrencesOfString:@"\%" withString:@""];
    [callstack appendString:modifyString];
    
    // crash 步骤
    // Add by chenggong 10/17/2013.
    NSString *crashStep = [[CrashCollectionLog sharedInstance] fileToString];
    if (STRINGHASVALUE(crashStep))
    {
        [callstack appendString:[[CrashCollectionLog sharedInstance] fileToString]];
    }
    
    // End add.
    
    // 代替空格缩进
    NSString *modifyCallStack = [callstack stringByReplacingOccurrencesOfString:@" " withString:@"."];
    
    [dictionary setValue:modifyCallStack forKey:@"ExceptionsStackDetail"];
    [dictionary setValue:self.bundleVersion forKey:@"AppVersion"];
    [dictionary setValue:[self.environmentInfo objectForKey:@"Operating System"] forKey:@"OsVersion"];
    [dictionary setValue:[self.environmentInfo objectForKey:@"System Platform"] forKey:@"DeviceModel"];
    [dictionary setValue:@"3" forKey:@"NetWorkType"];
    [dictionary setValue:[NSString stringWithFormat:@"CPU:%@;%@", [self.environmentInfo objectForKey:@"CPU Information"], [self.environmentInfo objectForKey:@"Memory Information"]] forKey:@"DeviceStatus"];
    [dictionary setValue:CHANNELID forKey:@"ChannelId"];
    [dictionary setValue:@"1" forKey:@"ClientType"];
    [dictionary setValue:@"" forKey:@"NetWorkCarrier"];
    [dictionary setValue:[self.environmentInfo objectForKey:@"Error Occured Time"] forKey:@"CrashTime"];
    // 添加手机号
    NSString *phoneNumber = [[AccountManager instanse] phoneNo];
    if(!STRINGHASVALUE(phoneNumber)){
        phoneNumber = @"user didnot login!";
    }
    [dictionary setValue:phoneNumber forKey:@"PhoneNumber"];
    
    [params setValue:dictionary forKey:@"AppCrashDetail"];
    [params setValue:[PostHeader header] forKey:Resq_Header];
    
    NSString *JSONString = @"";
    @try {
        JSONString = [params JSONRepresentation];
        
    }
    @catch (NSException *exception) {
        NSLog(@"do nothing.");
    }
    @finally {
        
    }
    
    // 增加换行
    NSString *modifyJSONString = [JSONString stringByReplacingOccurrencesOfString:@"\\n" withString:@"<br />"];
    
    // 参数串编码
    NSString * encodedJsonString = (NSString *)CFURLCreateStringByAddingPercentEscapes
    (NULL, (CFStringRef)modifyJSONString, NULL,
     (CFStringRef)@"!*’();:@&=+$,/\?%#[]", kCFStringEncodingUTF8);
    
    NSString *text = [[NSString stringWithFormat:@"action=SaveCrash&version=1.2&compress=false&req=%@", encodedJsonString] retain];

    [pool drain];

    return [text autorelease];
}

//将ABNotice对象转化成XML格式字符窜
- (NSString *)hoptoadXMLString
{
    // pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // create root
    DDXMLElement *notice = [DDXMLElement elementWithName:@"notice"];
    [notice addAttribute:[DDXMLElement attributeWithName:@"version" stringValue:ABNotifierVersion]];
    // set api key
    NSString *APIKey = [ABNotifier APIKey];
    if (APIKey == nil) { APIKey = @""; }
    [notice addChild:[DDXMLElement elementWithName:@"api-key" stringValue:APIKey]];
    
	// set error information
    NSString *message = [NSString stringWithFormat:@"%@: %@", self.exceptionName, self.exceptionReason];
    
    // error
    DDXMLElement *error = [DDXMLElement elementWithName:@"error"];
    
    [error addChild:[DDXMLElement elementWithName:@"class" stringValue:self.exceptionName]];
	[error addChild:[DDXMLElement elementWithName:@"message" stringValue:message]];
    
    // backtrace
    DDXMLElement *backtrace = [DDXMLElement elementWithName:@"backtrace"];
    [self.callStack enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DDXMLElement *line = [DDXMLElement elementWithName:@"line"];
        [line addAttribute:
         [DDXMLElement
          attributeWithName:@"number"
          stringValue:[(NSArray *)obj objectAtIndex:1]]];
        [line addAttribute:
         [DDXMLElement
          attributeWithName:@"file"
          stringValue:[(NSArray *)obj objectAtIndex:2]]];
        [line addAttribute:
         [DDXMLElement
          attributeWithName:@"method"
          stringValue:[(NSArray *)obj objectAtIndex:3]]];
        [backtrace addChild:line];
    }];
	[error addChild:backtrace];
    
    [notice addChild:error];
    
    // request
    DDXMLElement *request = [DDXMLElement elementWithName:@"request"];
    [request addChild:[DDXMLElement elementWithName:@"url"]];
    [request addChild:[DDXMLElement elementWithName:@"component" stringValue:self.controller]];
    [request addChild:[DDXMLElement elementWithName:@"action" stringValue:self.action]];
    DDXMLElement *cgi = [DDXMLElement elementWithName:@"cgi-data"];
    [self.environmentInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        DDXMLElement *entry = [DDXMLElement elementWithName:@"var" stringValue:[obj description]];
        [entry addAttribute:[DDXMLElement attributeWithName:@"key" stringValue:[key description]]];
        [cgi addChild:entry];
    }];
    [request addChild:cgi];
    [notice addChild:request];
    
    // server encironment
    DDXMLElement *environment = [DDXMLElement elementWithName:@"server-environment"];
    [environment addChild:[DDXMLElement elementWithName:@"environment-name" stringValue:self.environmentName]];
    [environment addChild:[DDXMLElement elementWithName:@"app-version" stringValue:self.bundleVersion]];
	[notice addChild:environment];
    
    // get return value
    NSString *XMLString = [[notice XMLString] copy];
    
    // pool
    [pool drain];
    
    // return
    return [XMLString autorelease];
}

//ABNotice对象的相关信息描述
- (NSString *)description {
	unsigned int count;
	objc_property_t *properties = class_copyPropertyList([self class], &count);
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:count];
	for (unsigned int i = 0; i < count; i++) {
		NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
		NSString *value = [self valueForKey:name];
        if (value) { [dictionary setObject:value forKey:name]; }
        else { [dictionary setObject:[NSNull null] forKey:name]; }
	}
	free(properties);
    return [NSString stringWithFormat:@"%@ %@", [super description], [dictionary description]]; 
}

- (void)dealloc {
	self.exceptionName = nil;
	self.exceptionReason = nil;
	self.environmentName = nil;
	self.environmentInfo = nil;
    self.bundleVersion = nil;
    self.action = nil;
	self.callStack = nil;
	self.controller = nil;
    self.noticeVersion = nil;
    self.executable = nil;
	[super dealloc];
}

@end
