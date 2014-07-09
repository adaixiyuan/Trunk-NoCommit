//
//  CrashCollectionLog.m
//  ElongClient
//
//  Created by chenggong on 13-10-8.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TraceCommonDefine.h"
#import "CrashCollectionLog.h"

static CrashCollectionLog *instance = Nil;

@implementation CrashCollectionLog

@synthesize logInfoArray = _logInfoArray;
@synthesize traceLogFilePath = _traceLogFilePath;

- (void)dealloc {
    self.logInfoArray = nil;
    self.traceLogFilePath = nil;
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths safeObjectAtIndex:0];
        NSString *filePath;

        if ([paths count] == 0) {
            filePath = NSTemporaryDirectory();
        }
        else {
            filePath = [docDir stringByAppendingPathComponent:kUserClickTraceLogFilename];
        }
        self.traceLogFilePath = filePath;
        
        NSMutableArray *tempMutableArray = [NSMutableArray arrayWithArray:[NSMutableArray arrayWithContentsOfFile:_traceLogFilePath]];
        self.logInfoArray = tempMutableArray;
    }
    return self;
}

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CrashCollectionLog alloc] init];
    });
    return instance;
}

- (void)logTarget:(NSString *)target action:(NSString *)action {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *date = [NSDate date];
    NSString *now = [dateFormatter stringFromDate:date];
    // Using GCD write to file.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    });
    
    if (target == nil) {
        target = @"nil";
    }
    
    if (action == nil) {
        action = @"nil";
    }
    
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:now, kUserClickTraceLogTime, target, kUserClickTraceLogTarget, action, kUserClickTraceLogAction, nil];
    if ([_logInfoArray count] >= kTraceButtonCLickThreshold) {
//        [_logInfoArray removeLastObject];
        // Remove half objects in array.
        [_logInfoArray removeObjectsInRange:NSMakeRange(kTraceButtonCLickThreshold / 2, kTraceButtonCLickThreshold / 2)];
    }
    
    [_logInfoArray insertObject:infoDic atIndex:0];
//    [_logInfoArray addObject:infoDic];
    
    [dateFormatter release];
}

- (void)handleMemoryWarning {
    [self logTarget:@"UIApplication" action:@"didReceivedMemoryWarning"];
}

- (void)logToFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:_traceLogFilePath]) {
        [fileManager createFileAtPath:_traceLogFilePath contents:nil attributes:nil];
    }
    
    [_logInfoArray writeToFile:_traceLogFilePath atomically:NO];
    
}

// 本地保存
- (void)crashLocalSave:(NSString *)keyName
{
    // 保存本地在debugger界面中查看
    NSArray *arrayCrashStepSaved = [Utils arrayDateSaved:kCrashStepFile andSaveKey:kCrashStepArchiverKey];
    
    NSMutableArray *arrayCrashStep = [[NSMutableArray alloc] initWithArray:arrayCrashStepSaved];
    // 填充为key值
    NSString *stepKey = [NSString stringWithFormat:@"%@_Step",keyName];
    NSDictionary *currCrash = [NSDictionary dictionaryWithObject:_logInfoArray forKey:stepKey];
    [arrayCrashStep insertObject:currCrash atIndex:0];
    // 将crash信息写入文件
    if (DEBUGBAR_SWITCH)
    {
        [Utils saveData:arrayCrashStep withFileName:kCrashStepFile andSaveKey:kCrashStepArchiverKey];
    }
    
    [arrayCrashStep release];
}

- (NSString *)fileToString {
    NSArray *logArray = [NSArray arrayWithContentsOfFile:_traceLogFilePath];
    
//    NSMutableString * result = [[[NSMutableString alloc] init] autorelease];
//    for (NSObject * obj in logArray)
//    {
//        [result appendString:[obj description]];
//    }
    if (ARRAYHASVALUE(logArray))
    {
        NSString *result = [NSString stringWithFormat:@"\nCrash 步骤：\n%@",[logArray description]];
        
        return result;
    }
    
    return nil;
    
}

@end
