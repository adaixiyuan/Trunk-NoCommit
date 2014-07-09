//
//  CrashCollectionLog.h
//  ElongClient
//
//  Created by chenggong on 13-10-8.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashCollectionLog : NSObject {
    NSMutableArray *_logInfoArray;
    NSString *_traceLogFilePath;
}

@property (nonatomic, retain) NSMutableArray *logInfoArray;
@property (nonatomic, copy)  NSString *traceLogFilePath;

+ (CrashCollectionLog *)sharedInstance;

- (void)logTarget:(NSString *)target action:(NSString *)action;

- (void)handleMemoryWarning;

- (void)logToFile;

// 本地保存
- (void)crashLocalSave:(NSString *)keyName;

- (NSString *)fileToString;

@end
