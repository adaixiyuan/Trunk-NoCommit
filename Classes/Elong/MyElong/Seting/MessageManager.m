//
//  MessageManager.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "MessageManager.h"

static MessageManager *instance = nil;

@interface MessageManager ()

@property (nonatomic, retain) NSMutableArray *messageList;

@end

@implementation MessageManager

+ (id)sharedInstance {
	@synchronized(instance) {
		if (!instance) {
			instance = [[MessageManager alloc] init];
		}
	}
	
	return instance;
}

- (id)init{
    if (self = [super init]) {
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Message"];
        
        BOOL isDir;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:filePath isDirectory:&isDir]) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            self.messageList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        else {
            self.messageList = [NSMutableArray array];
        }
        
//        for(int i=0;i<10;i++){
//            //Test Data
//            EMessage *emsg = [[EMessage alloc] init];
//            emsg.body = [NSString stringWithFormat:@"%d非常长的名字，非常长的名字，非常长的名字，非常长的名字，非常长的名字，非常长的名字，非常长的名字",i];
//            emsg.time = [NSDate date];
//            if(i%3==0){
//                emsg.url = @"http://www.elong.com";
//            }
//            [self addMessage:emsg];
//            [emsg release];
//        }
    }
    
    return self;
}

- (void)addMessage:(EMessage *)message
{
    while (self.messageCount >= 20) {
        [self.messageList removeObjectAtIndex:0];
    }
    // 排重
    [self removeMessage:message];
    [self.messageList addObject:message];
}

- (BOOL) removeMessage:(EMessage *)message{
    for (EMessage *msg in self.messageList) {
        if (STRINGHASVALUE(message.url)) {
            if ([message.body isEqualToString:msg.body] && [message.url isEqualToString:msg.url]) {
                [self.messageList removeObject:msg];
                return YES;
            }
        }else{
            if ([message.body isEqualToString:msg.body]) {
                [self.messageList removeObject:msg];
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL) haveMessage:(EMessage *)message{
    for (EMessage *msg in self.messageList) {
        if (STRINGHASVALUE(message.url)) {
            if ([message.body isEqualToString:msg.body] && [message.url isEqualToString:msg.url]) {
                return YES;
            }
        }else{
            if ([message.body isEqualToString:msg.body]) {
                return YES;
            }
        }
    }
    return NO;
}

- (EMessage *)getMessageByIndex:(NSUInteger)index
{
    return [self.messageList safeObjectAtIndex:index];
}

- (NSUInteger)messageCount
{
    return self.messageList.count;
}

-(NSUInteger)unreadMessageCount{
    int count = 0;
    for(EMessage *em in self.messageList){
        if(!em.hasRead){
            count++;
        }
    }
    
    return count;
}

- (void)save
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Message"];
    
    NSString *directoryPath = [filePath stringByDeletingLastPathComponent];
    BOOL isDir;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSData *data;
    data = [NSKeyedArchiver archivedDataWithRootObject:_messageList];
    
    BOOL successful = [data writeToFile:filePath atomically:YES];
    
    if (!successful) {
        NSLog(@"保存失败了");
    }
    else {
        NSLog(@"保存成功了");
    }
}

@end
